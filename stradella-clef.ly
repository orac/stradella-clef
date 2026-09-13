% stradella-clef.ly -- a tabular notation for the Stradella bass of an accordion.
%
% Copyright (C) 2026 Tufty Indigo
%
% SPDX-License-Identifier: GPL-3.0-or-later
%
% This file is free software: you can redistribute it and/or modify it under
% the terms of the GNU General Public License as published by the Free
% Software Foundation, either version 3 of the License, or (at your option)
% any later version.  These are the same terms as LilyPond itself.
%
% This file is distributed in the hope that it will be useful, but WITHOUT ANY
% WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
% FOR A PARTICULAR PURPOSE.  See the GNU General Public License for details.
%
% You should have received a copy of the GNU General Public License along with
% this file.  If not, see <https://www.gnu.org/licenses/>.
%
% Home: https://github.com/orac/stradella-clef

\version "2.24.3"

%{
  Stradella clef -- a tabular notation for the Stradella bass of an accordion,
  plus the machinery to engrave the same input in traditional notation.

  A note is written as the button you press.  Which *column* of the board the
  button is in is given by the pitch: columns go round the circle of fifths, so
  the vertical position of the note head is its distance in fifths from C, with
  C on the centre line, G in the space above, F in the space below.  Which *row*
  it is in is given by one of \cnt \maj \min \sev \dimin, or by nothing at all
  for a fundamental bass note; the row shows up as the colour and shape of the
  note head.  The octave you write a note in is never significant.

  The same input engraves three ways:

    \clef stradella          the tablature notation described above
    \stradellaTriads music   traditional notation, chords written out in full
    \stradellaSymbols music  traditional notation, chord roots marked M m 7 d

  Only the first of these needs the engraver, and only on the staff that uses
  it:

    \new Staff \with \stradellaBass { \clef stradella ... }

  The row commands are attached to notes as articulations, so they survive
  chord repetition (q) and can be mixed within a chord for the spicier
  harmonies the Stradella board can reach by pressing two buttons:

    <\maj c \min a>8 q q q

  \stradellaTriads and \stradellaSymbols choose octaves for themselves, so
  wrap them round \relative music rather than putting them inside it.

  MIDI is not supported: a chord button sounds as its root alone.

  Two buttons in the same column, such as <c \maj c>, land on the same line and
  are split either side of the stem in the usual way.  A third one on the same
  line will overlap the first: LilyPond only ever alternates two sides.
%}

#(use-modules (lily accreg))

%%%% The circle of fifths

% Distance of PITCH from C in fifths, which is its column on the board and so
% its vertical position in Stradella clef.  Enharmonics are distinct: a sharp
% is seven columns to the right of a natural.
#(define (stradella-pitch->fifths pitch)
   (let ((name-in-semis (* 2 (ly:pitch-notename pitch))))
     (+ (if (> name-in-semis 4)
            (- name-in-semis 7)
            name-in-semis)
        (* 14 (ly:pitch-alteration pitch)))))

%%%% The rows of the board

% Intervals, spelled so that transposition produces sensible accidentals.
#(define stradella-unison (ly:make-pitch 0 0 0))
#(define stradella-minor-third (ly:make-pitch 0 2 FLAT))
#(define stradella-major-third (ly:make-pitch 0 2 0))
#(define stradella-fifth (ly:make-pitch 0 4 0))
#(define stradella-major-sixth (ly:make-pitch 0 5 0))
#(define stradella-minor-seventh (ly:make-pitch 0 6 FLAT))

% Everything that distinguishes one row of the board from another.
%   fifths:    how far left of the note's own column the button sits.  The counterbass row is a major third above its column's fundamental, so \cnt e is a button in the C column.
%   colour, style:     appearance of the note head in Stradella clef.  #f leaves the usual appearance alone, as do any \tweak or \override you make.
%   mark:      what \stradellaSymbols writes above the note.
%   intervals: what the button actually sounds, and so what \stradellaTriads writes out.  The seventh and diminished buttons have only three reeds, and drop the fifth and the root respectively.
#(define stradella-rows
   `((bass . ((fifths . 0)
              (colour . #f)
              (style . #f)
              (mark . #f)
              (intervals . ,(list stradella-unison))))
     (counterbass . ((fifths . -4)
                     (colour . "#117733")
                     (style . #f)
                     (mark . #f)
                     (intervals . ,(list stradella-unison))))
     (major . ((fifths . 0)
               (colour . "#332288")
               (style . laThin)
               (mark . "M")
               (intervals . ,(list stradella-unison
                                   stradella-major-third
                                   stradella-fifth))))
     (minor . ((fifths . 0)
               (colour . "#882255")
               (style . fa)
               (mark . "m")
               (intervals . ,(list stradella-unison
                                   stradella-minor-third
                                   stradella-fifth))))
     (seventh . ((fifths . 0)
                 (colour . "#56B4E9")
                 (style . do)
                 (mark . "7")
                 (intervals . ,(list stradella-unison
                                     stradella-major-third
                                     stradella-minor-seventh))))
     (diminished . ((fifths . 0)
                    (colour . "#aa4499")
                    (style . tiThin)
                    (mark . "d")
                    (intervals . ,(list stradella-unison
                                        stradella-minor-third
                                        stradella-major-sixth))))))

#(define (stradella-row-attribute row key)
   (let ((entry (assq-ref stradella-rows row)))
     (and entry (assq-ref entry key))))

%%%% Marking a note with its row

% A row event rides on a note as an articulation, so \chordRepeats copies it
% into repeated chords and any future \q-like mechanism will too.
#(if (not (ly:make-event-class 'stradella-row-event))
     (define-event-class 'stradella-row-event 'music-event))

#(set-object-property! 'stradella-row 'music-type? symbol?)
#(set-object-property! 'stradella-row 'music-doc
                       "Row of the Stradella board a note is played on.")

#(hashq-set! music-name-to-property-table 'StradellaRowEvent
             '((name . StradellaRowEvent)
               (types . (post-event event stradella-row-event))))

% Make q keep the row events by default; without this a repeated chord would
% come back as bare bass notes.
#(ly:parser-define! '$chord-repeat-events
                    (cons 'stradella-row-event
                          (let ((kept (ly:parser-lookup '$chord-repeat-events)))
                            (if (list? kept) kept '()))))

#(define (stradella-set-row! music row)
   (cond
    ((music-is-of-type? music 'note-event)
     (set! (ly:music-property music 'articulations)
           (cons (make-music 'StradellaRowEvent 'stradella-row row)
                 (ly:music-property music 'articulations))))
    (else
     (let ((element (ly:music-property music 'element)))
       (if (ly:music? element)
           (stradella-set-row! element row)))
     (for-each (lambda (element) (stradella-set-row! element row))
               (ly:music-property music 'elements))))
   music)

cnt =
#(define-music-function (note) (ly:music?)
   (_i "Play @var{note} on the counterbass row, a major third above the fundamental of its column: @samp{\\cnt e} is the counterbass button of the C@tie{}column, and sounds@tie{}E.")
   (stradella-set-row! note 'counterbass))

maj =
#(define-music-function (note) (ly:music?)
   (_i "Play @var{note} on the major chord row.")
   (stradella-set-row! note 'major))

min =
#(define-music-function (note) (ly:music?)
   (_i "Play @var{note} on the minor chord row.")
   (stradella-set-row! note 'minor))

sev =
#(define-music-function (note) (ly:music?)
   (_i "Play @var{note} on the seventh chord row, which sounds root, major third and minor seventh.")
   (stradella-set-row! note 'seventh))

dimin =
#(define-music-function (note) (ly:music?)
   (_i "Play @var{note} on the diminished chord row, which sounds root, minor third and diminished seventh.")
   (stradella-set-row! note 'diminished))

% The row of a note, as a music object or as a stream event.  A note with no row event on it is a fundamental bass note.
#(define (stradella-music-row note)
   (let loop ((articulations (ly:music-property note 'articulations)))
     (cond ((null? articulations) 'bass)
           ((music-is-of-type? (car articulations) 'stradella-row-event)
            (ly:music-property (car articulations) 'stradella-row))
           (else (loop (cdr articulations))))))

#(define (stradella-event-row event)
   (let loop ((articulations (ly:event-property event 'articulations)))
     (cond ((null? articulations) 'bass)
           ((ly:in-event-class? (car articulations) 'stradella-row-event)
            (ly:event-property (car articulations) 'stradella-row))
           (else (loop (cdr articulations))))))

#(define (stradella-row-events note)
   (filter (lambda (articulation)
             (music-is-of-type? articulation 'stradella-row-event))
           (ly:music-property note 'articulations)))

#(define (stradella-strip-row! note)
   (set! (ly:music-property note 'articulations)
         (filter (lambda (articulation)
                   (not (music-is-of-type? articulation 'stradella-row-event)))
                 (ly:music-property note 'articulations)))
   note)

% Repeating a note or chord by giving a duration on its own -- <c \min c>2 4 4
% -- goes through different machinery from q, and that machinery drops
% articulations on purpose and offers no hook to say otherwise.  So rewrite
% those naked durations before the repeat expansions run: after a chord, into
% the very form q parses to, which does honour the hook; after a single note,
% by carrying its rows across directly.  Music with no Stradella rows in it
% comes through this unchanged.
#(define (stradella-carry-rows! music)
   (let ((previous #f))     ; #f, 'chord, or the row events of the last note
     (map-some-music
      (lambda (music)
        (cond
         ((music-is-of-type? music 'event-chord)
          (if (any (lambda (element) (music-is-of-type? element 'rhythmic-event))
                   (ly:music-property music 'elements))
              (set! previous 'chord))
          music)

         ((music-is-of-type? music 'note-event)
          (cond
           ;; a note that says what it is: remember it and move on
           ((or (ly:music-property music 'pitch #f)
                (ly:music-property music 'drum-type #f))
            (set! previous (stradella-row-events music))
            music)
           ((eq? previous 'chord)
            (make-music 'EventChord
                        'duration (ly:music-property music 'duration)
                        'articulations (ly:music-property music 'articulations)
                        'origin (ly:music-property music 'origin)))
           ((pair? previous)
            (set! (ly:music-property music 'articulations)
                  (append (ly:music-deep-copy previous music)
                          (ly:music-property music 'articulations)))
            music)
           (else music)))

         (else #f)))
      music)))

#(if (not (memq stradella-carry-rows! toplevel-music-functions))
     (set! toplevel-music-functions
           (cons stradella-carry-rows! toplevel-music-functions)))

%%%% Engraving Stradella clef

% Grob properties the engraver would like to set, but only if the user has not
% already said otherwise with \tweak or \override.
#(define (stradella-suggest-property! grob property value)
   (if (and value (null? (ly:grob-property grob property '())))
       (ly:grob-set-property! grob property value)))

% The engraver lets the ordinary Note_heads_engraver do its work and then moves
% the heads it made, rather than standing in for it: the C++ engraver stays on
% the fast path, and staves that never see a Stradella note pay nothing at all.
% This has to sit in Staff rather than Voice, because grobs are announced
% upwards -- a Staff engraver sees the note heads of every voice below it, but
% a Voice engraver would never see the Staff's own accidentals and key
% signatures, which Stradella clef must suppress.
#(define (Stradella_engraver context)
   (define (stradella-clef?) (ly:context-property context 'stradellaClef #f))
   (define (blank-in-stradella-clef grob)
     (if (stradella-clef?) (ly:grob-set-property! grob 'stencil #f)))
   (make-engraver
    (acknowledgers
     ((note-head-interface engraver grob source-engraver)
      (if (stradella-clef?)
          (let* ((event (event-cause grob))
                 (pitch (and event (ly:event-property event 'pitch))))
            (if (ly:pitch? pitch)
                (let ((row (stradella-event-row event)))
                  (ly:grob-set-property! grob 'staff-position
                                         (+ (stradella-pitch->fifths pitch)
                                            (stradella-row-attribute row 'fifths)))
                  (stradella-suggest-property! grob 'color
                                               (stradella-row-attribute row 'colour))
                  (stradella-suggest-property! grob 'style
                                               (stradella-row-attribute row 'style)))))))

     ;; Accidentals, key signatures and arpeggio signs all say something about
     ;; pitches that Stradella clef says with the note's position instead.
     ((accidental-interface engraver grob source-engraver)
      (blank-in-stradella-clef grob))
     ((key-signature-interface engraver grob source-engraver)
      (blank-in-stradella-clef grob))
     ((arpeggio-interface engraver grob source-engraver)
      (blank-in-stradella-clef grob))

     ;; The Stradella clef sign has no small mid-line variant, being a note
     ;; head rather than a real clef glyph.
     ((clef-interface engraver grob source-engraver)
      (if (stradella-clef?)
          (ly:grob-set-property! grob 'full-size-change #t))))))

#(ly:register-translator
  Stradella_engraver 'Stradella_engraver
  '((grobs-created . ())
    (events-accepted . ())
    (properties-read . (stradellaClef))
    (properties-written . ())
    (description . "Lay a staff out by the columns of the Stradella board
whenever @code{stradellaClef} is set: move each note head to its column, colour
and shape it for its row, and suppress the accidentals, key signatures and
arpeggio signs that Stradella clef has no use for.")))

#(set-object-property! 'stradellaClef 'translation-type? boolean?)
#(set-object-property! 'stradellaClef 'translation-doc
                       "Is this staff notated in Stradella clef?")

% Add this to the staves that need it -- \new Staff \with \stradellaBass -- so
% that no other staff carries the cost.
stradellaBass = \with { \consists #Stradella_engraver }

%%%% Switching in and out of Stradella clef

#(add-new-clef "stradella" "stradella" 0 0 0)

% \clef stradella turns the layout on, any other clef turns it off, so that
% moving between Stradella clef and bass clef is no harder than moving between
% treble and bass.
clef =
#(define-music-function (type) (string?)
   (_i "Set the current clef to @var{type}.  This is the usual @code{\\clef},
extended with one new @var{type}, @code{\"stradella\"}, which lays the staff
out by columns of the Stradella board; any other @var{type} lays it out
normally again, so that @code{\\clef stradella} and @code{\\clef bass} may be
mixed as freely as @code{\\clef treble} and @code{\\clef bass}.")
   #{
     \set Staff.stradellaClef = #(string=? type "stradella")
     $(make-clef-set type)
   #})

%%%% Engraving the same music traditionally

% The bass and treble halves of the traditionally-notated staff, as the
% ly:pitch-steps of their boundary notes.  The line between them -- d -- is
% used by neither: a root note stays at or below ROOT-CEILING (c), and a
% chord's notes stay at or above CHORD-FLOOR (ef), so the middle line marks
% the border between the two rather than being a position either ever uses.
#(define stradella-root-ceiling (ly:pitch-steps (ly:make-pitch -1 0 0)))
#(define stradella-chord-floor (ly:pitch-steps (ly:make-pitch -1 2 FLAT)))

% Shift PITCH by whole octaves to the highest octave that still sits at or
% below LIMIT.  A pitch's letter and alteration survive; only its octave, the
% one thing a Stradella button never specifies, is chosen for it.
#(define (stradella-fit-below-ceiling pitch limit)
   (let* ((step (ly:pitch-steps pitch))
          (octaves (- (ceiling (/ (- step limit) 7)))))
     (ly:pitch-transpose pitch (ly:make-pitch octaves 0 0))))

% Shift PITCH by whole octaves to the lowest octave that still sits at or
% above LIMIT.
#(define (stradella-fit-above-floor pitch limit)
   (let* ((step (ly:pitch-steps pitch))
          (octaves (- (floor (/ (- step limit) 7)))))
     (ly:pitch-transpose pitch (ly:make-pitch octaves 0 0))))

% Move a whole chord bodily by octaves, keeping its close-position spacing, so
% that its lowest note sits at the lowest step at or above FLOOR-STEP.
% Guile's own min is shadowed here by \min, the minor-chord row command --
% every row command is itself a top-level Scheme binding -- so it has to be
% reimplemented rather than called by name.
#(define (stradella-lowest-step pitches)
   (fold (lambda (pitch lowest) (if (< (ly:pitch-steps pitch) lowest)
                                     (ly:pitch-steps pitch)
                                     lowest))
         (ly:pitch-steps (car pitches))
         (cdr pitches)))

#(define (stradella-fit-chord-above-floor pitches floor-step)
   (let* ((low (stradella-lowest-step pitches))
          (octaves (- (floor (/ (- low floor-step) 7)))))
     (map (lambda (pitch) (ly:pitch-transpose pitch (ly:make-pitch octaves 0 0)))
          pitches)))

% Choose the inversion that, once its octave is fitted above FLOOR-STEP, sits
% lowest overall, so that chords hug the floor instead of climbing the staff
% with their roots.
#(define (stradella-chord-voicing pitches floor-step)
   (let loop ((rotations (length pitches))
              (candidate pitches)
              (best #f))
     (if (zero? rotations)
         best
         (let ((voicing (stradella-fit-chord-above-floor candidate floor-step)))
           (loop (1- rotations)
                 (append (cdr candidate)
                         (list (ly:pitch-transpose (car candidate)
                                                   (ly:make-pitch 1 0 0))))
                 (if (or (not best)
                         (< (stradella-lowest-step voicing)
                            (stradella-lowest-step best)))
                     voicing
                     best))))))

#(define (stradella-chord-pitches root row)
   (map (lambda (interval) (ly:pitch-transpose root interval))
        (stradella-row-attribute row 'intervals)))

% Is this note a button that sounds something other than the note written?
#(define (stradella-chord-note? note)
   (and (ly:pitch? (ly:music-property note 'pitch))
        (memq (stradella-music-row note) '(major minor seventh diminished))
        #t))

#(define (stradella-note-at note pitch)
   (let ((copy (stradella-strip-row! (ly:music-deep-copy note))))
     (set! (ly:music-property copy 'pitch) pitch)
     copy))

% Traditional notation has no button to show, so a counterbass note marks
% itself tenuto instead: the closest ordinary sign to "held down while the
% row above it changes".
#(define (stradella-add-tenuto! note)
   (set! (ly:music-property note 'articulations)
         (cons (make-music 'ArticulationEvent 'articulation-type 'tenuto)
               (ly:music-property note 'articulations)))
   note)

% A fundamental bass or counterbass note, octaved into the lower half of the
% staff.  A note with no pitch at all (a drum note, say) is left untouched.
#(define (stradella-root-note note)
   (let ((pitch (ly:music-property note 'pitch #f)))
     (if (ly:pitch? pitch)
         (let ((root (stradella-note-at note (stradella-fit-below-ceiling pitch stradella-root-ceiling))))
           (if (eq? (stradella-music-row note) 'counterbass)
               (stradella-add-tenuto! root)
               root))
         (stradella-strip-row! note))))

% Rewrite every note event in MUSIC with EXPAND, which returns a list of events
% to stand in its place; a lone note that expands into several becomes a chord.
#(define (stradella-rewrite-notes! music expand)
   (map-some-music
    (lambda (music)
      (cond
       ((music-is-of-type? music 'event-chord)
        (set! (ly:music-property music 'elements)
              (append-map (lambda (element)
                            (if (music-is-of-type? element 'note-event)
                                (expand element)
                                (list element)))
                          (ly:music-property music 'elements)))
        music)
       ((music-is-of-type? music 'note-event)
        (let ((notes (expand music)))
          (if (null? (cdr notes))
              (car notes)
              (make-music 'EventChord 'elements notes))))
       (else #f)))
    music))

stradellaTriads =
#(define-music-function (music) (ly:music?)
   (_i "Replace every chord button in @var{music} with the notes it sounds, for
engraving in ordinary notation.  Each chord is voiced in close position and
octaved so that its notes stay in the upper half of the bass staff, at or
above@tie{}@code{ef}, without climbing any higher than that requires.  A
fundamental bass or counterbass note is octaved into the lower half instead,
at or below@tie{}@code{c}: the middle line, @code{d}, is never used by either.

Wrap this round @code{\\relative} music rather than putting it inside, or
@code{\\relative} will undo the octaves it chooses.")
   (stradella-rewrite-notes!
    music
    (lambda (note)
      (if (stradella-chord-note? note)
          (map (lambda (pitch) (stradella-note-at note pitch))
               (stradella-chord-voicing (stradella-chord-pitches
                                         (ly:music-property note 'pitch)
                                         (stradella-music-row note))
                                        stradella-chord-floor))
          (list (stradella-root-note note))))))

stradellaSymbols =
#(define-music-function (music) (ly:music?)
   (_i "Replace every chord button in @var{music} with its root alone, marked
@samp{M}, @samp{m}, @samp{7} or @samp{d} above the staff for the row, for
engraving in ordinary notation.  The root is octaved into the upper half of
the bass staff, at or above@tie{}@code{ef}.  A fundamental bass or
counterbass note is octaved into the lower half instead, at or
below@tie{}@code{c}: the middle line, @code{d}, is never used by either.

Wrap this round @code{\\relative} music rather than putting it inside, or
@code{\\relative} will undo the octaves it chooses.")
   (stradella-rewrite-notes!
    music
    (lambda (note)
      (if (stradella-chord-note? note)
          (let* ((row (stradella-music-row note))
                 (root (stradella-fit-above-floor
                        (ly:music-property note 'pitch) stradella-chord-floor))
                 (mark (stradella-row-attribute row 'mark)))
            ;; The mark has to be a sibling of the note rather than an
            ;; articulation on it: LilyPond cannot attach text to one note head
            ;; of a chord, so two buttons pressed together get two marks above
            ;; the chord as a whole.
            (cons (stradella-note-at note root)
                  (if mark
                      (list (make-music 'TextScriptEvent 'text mark 'direction UP))
                      '())))
          (list (stradella-root-note note))))))

% The Stradella clef glyph, transcribed from stradella.svg.  Its "M"/"l"/"c"/"Z"
% commands are exactly \path's SVG-equivalent syntax, so the only translation
% needed is: negate every y (SVG grows downward, LilyPond upward) and scale
% from the SVG's 14x20 viewBox down to 4 staff-spaces tall, so it fits the
% staff without any further scaling at print time.
#(define stradella-glyph-path
   (let ((scale (/ 4.0 20)))
     (define (convert command)
       (cons (car command)
             (map (lambda (n i) (* scale (if (even? i) n (- n))))
                  (cdr command)
                  (iota (length (cdr command))))))
     (map convert
          '((M 10.443 1.834)
            (l 1.154 -1.654)
            (l 0.937 -0)
            (l -2.811 8.521)
            (l -0.217 -1.477)
            (c -0.194 -1.072 0.335 -4.211 -0.704 -5.186)
            (c -1.039 -0.975 -1.627 -1.05 -2.978 -1.05)
            (c -1.129 -0 -2.052 0.338 -2.771 1.014)
            (c -0.718 0.676 -1.077 1.502 -1.077 2.478)
            (c -0 0.608 0.136 1.141 0.41 1.599)
            (c 0.274 0.458 0.682 0.83 1.225 1.117)
            (c 0.543 0.287 1.567 0.592 3.073 0.915)
            (c 2.112 0.46 3.594 0.925 4.445 1.395)
            (c 0.851 0.47 1.486 1.063 1.905 1.777)
            (c 0.419 0.714 0.628 1.55 0.628 2.508)
            (c 0 1.71 -0.575 3.128 -1.725 4.252)
            (c -1.15 1.125 -2.636 1.687 -4.458 1.687)
            (c -1.958 0 -3.66 -0.632 -5.106 -1.898)
            (l -1.449 1.77)
            (l -0.924 0)
            (l 3.018 -8.349)
            (l 0.337 1.65)
            (c 0.142 1.136 -0.33 3.835 0.48 4.646)
            (c 1.211 1.21 2.156 1.258 3.721 1.258)
            (c 1.266 -0 2.299 -0.374 3.098 -1.123)
            (c 0.8 -0.748 1.2 -1.657 1.2 -2.726)
            (c -0 -0.607 -0.15 -1.139 -0.449 -1.597)
            (c -0.3 -0.458 -0.774 -0.842 -1.424 -1.155)
            (c -0.65 -0.312 -1.929 -0.69 -3.836 -1.135)
            (c -2.095 -0.496 -3.524 -1.052 -4.285 -1.668)
            (c -1.069 -0.872 -1.603 -2.108 -1.603 -3.707)
            (c -0 -1.668 0.532 -3.034 1.597 -4.099)
            (c 1.065 -1.065 2.426 -1.597 4.086 -1.597)
            (c 0.795 -0 1.552 0.141 2.27 0.423)
            (c 0.719 0.283 1.463 0.753 2.233 1.411)
            (Z)))))

#(define (stradella-clef::print grob)
   (if (string=? (ly:grob-property grob 'glyph-name) "stradella")
       (let* ((raw (grob-interpret-markup grob
                     (markup #:override '(filled . #t)
                             #:path 0 stradella-glyph-path)))
              (y-ext (ly:stencil-extent raw Y)))
         (ly:stencil-translate-axis raw (- (interval-center y-ext)) Y))
       (ly:clef::print grob)))

\layout {
   \context {
      \Staff
      \alias Staff
      \name StradellaStaff
      \description "Context for generating tablature-style staff for Stradella bass"
      \consists #Stradella_engraver
      \override Clef.stencil = #stradella-clef::print
   }
    \inherit-acceptability StradellaStaff Staff
}