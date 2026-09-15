% stradella-ambitus.ly -- an ambitus for a Stradella clef staff.
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
%
% Requires stradella-clef.ly to be \include'd first: it uses
% stradella-pitch->fifths, stradella-event-row and stradella-row-attribute
% from there, but does not \include that file itself, since including it
% twice would register its toplevel music functions twice.

\version "2.24.3"

%{
  Stradella_ambitus_engraver draws an ambitus at the start of a Stradella clef
  staff, spanning the columns of the board the staff uses.  The built-in
  Ambitus_engraver takes its extrema by pitch and positions them by
  middleCPosition plus pitch step, so in Stradella clef it chooses the wrong
  notes and puts them on the wrong lines.  This engraver positions its two note
  heads exactly as \clef stradella positions an ordinary note, and gives them
  no accidentals.

  Add it with \consists #Stradella_ambitus_engraver.
%}

#(define (Stradella_ambitus_engraver context)
   (let (;; The four grobs, made at the first timestep so that they belong at the start of the staff.
         (ambitus #f) (line #f) (low-head #f) (high-head #f)
         ;; The lowest and highest staff positions seen, and the event that
         ;; produced each -- exactly the position stradella-clef.ly gives the
         ;; note head, so the ambitus always agrees with the notes under it.
         (low #f) (low-cause #f)
         (high #f) (high-cause #f))

     (define (ensure-grobs! engraver)
       (if (not ambitus)
           (begin
             (set! ambitus (ly:engraver-make-grob engraver 'Ambitus '()))
             (set! line (ly:engraver-make-grob engraver 'AmbitusLine '()))
             (set! low-head (ly:engraver-make-grob engraver 'AmbitusNoteHead '()))
             (set! high-head (ly:engraver-make-grob engraver 'AmbitusNoteHead '()))
             (for-each (lambda (head) (ly:axis-group-interface::add-element ambitus head))
                       (list low-head high-head))
             (ly:axis-group-interface::add-element ambitus line)
             (set! (ly:grob-parent line X) low-head))))

     (make-engraver
      ((process-music engraver) (ensure-grobs! engraver))

      (acknowledgers
       ((note-head-interface engraver grob source-engraver)
        (if (and (ly:context-property context 'stradellaClef #f)
                 (not (grob::has-interface grob 'ambitus-interface)))
            (let* ((event (event-cause grob))
                   (pitch (and event (ly:event-property event 'pitch #f))))
              (if (ly:pitch? pitch)
                  (let* ((row (stradella-event-row event))
                         (position (+ (stradella-pitch->fifths pitch)
                                      (stradella-row-attribute row 'fifths))))
                    (if (or (not low) (< position low))
                        (begin (set! low position) (set! low-cause event)))
                    (if (or (not high) (> position high))
                        (begin (set! high position) (set! high-cause event)))))))))

      ((finalize engraver)
       (if low
           (for-each
            (lambda (head position cause)
              (ly:grob-set-property! head 'staff-position position)
              (ly:grob-set-property! head 'cause cause)
              (ly:pointer-group-interface::add-grob line 'note-heads head))
            (list low-head high-head) (list low high) (list low-cause high-cause))
           (for-each ly:grob-suicide! (list ambitus line low-head high-head)))))))

#(ly:register-translator
  Stradella_ambitus_engraver 'Stradella_ambitus_engraver
  '((grobs-created . (Ambitus AmbitusLine AmbitusNoteHead))
    (events-accepted . ())
    (properties-read . (stradellaClef))
    (properties-written . ())
    (description . "Draw an ambitus at the start of a Stradella clef staff,
spanning every button pressed on it, positioned the same way @code{\\clef
stradella} positions a note head: by column, not by pitch.")))
