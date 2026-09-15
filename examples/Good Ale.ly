\version "2.26.0"
\language "english"
\include "stradella-clef.ly"
\include "stradella-ambitus.ly"

\header {
  title = "Good Ale"
  composer = "Tufty Indigo, from a traditional melody"
  tagline = "Learn Stradella clef at https://orac.github.io/stradella-clef/"
}

global = {
  \time 3/2
  \key g \major
}

verseChordNames = \chordmode {
  g2 d c
  \time 2/2
  e1:m
  \time 3/2
  g1 c2
  \time 2/2
  g1
  \time 3/2
  e2:m d g
  \time 2/2
  c1
  \time 3/2
  g1 c2
}
refrainChordNames = \chordmode {
  b1:m d2 | g1 e2:m | c2 d c | a1:m d2 |
  d2:7 g1
}

chordNames = {
  \verseChordNames
  \refrainChordNames
}

finalChordNames = \chordmode {
  g2 d c
  \time 2/2
  e1:m
  \time 3/2
  g1 c2
  \time 2/2
  g1
  \time 3/2
  e2:m d g
  \time 2/2
  c1
  \time 3/2
  g2 c d |
  a:dim/d g1
}

wordsChorus = \lyricmode {
  O good ale, thou art my dar -- ling
  Thou art my joy, both night and mor -- ning.
}

words = \lyricmode {
  It is of good ale to you I'll sing
  And to good ale I'll al -- ways cling.
  I like my mug filled to the brim
  And I'll drink all you'd like to bring.

  \wordsChorus

  It is
}

wordsTwo = \lyricmode {
  you that helps me with my work
  And from a task I'll nev -- er shirk
  While I can get a good home brew,
  And better than one pint I like two.
  \*17 \skip 4

  I __
}

wordsThree = \lyricmode {
  love you in the ear -- ly morn
  I love you in day -- light, dark, or dawn,
  And when I'm wea -- ry, worn, or spent,
  I'll turn the tap and ease the vent.

  \wordsChorus
}

wordsFour = \lyricmode {
  It is you that makes my friends my foes,
  It is you that makes me wear old clothes,
  But since you come so near my nose,
  It's up you comes and down you goes.
}

% omit these two
wordsFive = \lyricmode {
  And if all my friends from A -- dam's race
  Was to meet me here all in this place,
  I could part from all with -- out one fear
  Be -- fore I'd part from my good beer
}

wordsSix = \lyricmode {
  And _ if my wife should me des -- pise,
  How soon I'd give her two black eyes
  But if she loved me as I love thee
  What a hap -- py coup -- le we should be.
}

wordsSeven = \lyricmode {
  You have caused me debts that I've of -- ten swore
  I nev -- er would drink strong ale no more
  But you for all that I'll for -- give
  And I'll drink strong ale as long as I live.
}

intro = \relative c' {
  e8 fs g4~4 d4 a'2 |
  \time 2/2
  g1
  \time 3/2
  b8 a g4~4 d4 e2 |
  \time 2/2
  d1
  \time 3/2
  b'1.
  \time 2/2
  b8 a g4. fs8 g a |
  \time 3/2
  b1 e2 |
  d2\prall ~ 8 c b a b a g fs |
  d2. d4 e fs | g4 d2 d4 e d' | c2. b4 a g | fs2 g2\prall_\fermata r4
}

bridge = \relative c'' {
  \time 3/2
  g8 a b4 d4 a c2 |
  \time 2/2
  b1
  \time 3/2
  d8 c b4~4 fs4 g2 |
  \time 2/2
  a8 b2..
  \time 3/2
  b4 d a d g, b
  \time 2/2
  c8 d e4 d8 c b a |
  \time 3/2
  b2 d e |
  fs ~ 8 g fs e d4 a |
  g2. d4 g a | b4 g2 d4 g d' | c2.\prall b4 a g | fs2 g2\fermata r4
}

melody = \relative c'' {
  b4 g a fs g fs |
  \time 2/2
  e2. fs4 |
  \time 3/2
  g4 g g d e c |
  \time 2/2
  b2. g'8( a)
  \time 3/2
  b4 g a fs g fs
  \time 2/2
  e2. fs4 |
  \time 3/2
  g4 g g d e c | b( d2.) \breathe
  % refrain
  d4. 8 | d2. 4 e fs | g d2 4 e d' |
  c2. b4 a g fs2 g2 r4 \breathe
}

melodyTwo = \relative c'' {
  b4 g a fs g fs |
  \time 2/2
  e2. fs4 |
  \time 3/2
  g8 g g4 g d e c |
  \time 2/2
  b2. g'8( a)
  \time 3/2
  b4 g a fs g fs
  \time 2/2
  e2. fs4 |
  \time 3/2
  g4 g g d e c | b( d2.) \breathe
  % refrain
  d4. 8 | d2. 4 e fs | g d2 4 e d' |
  c2. b4 a g fs2 g2 r4 \breathe
}

melodyThree = \relative c'' {
  g8 a |
  b4 g a fs g fs |
  \time 2/2
  e2. 8 fs8 |
  \time 3/2
  g4 g g d e c |
  \time 2/2
  b2. g'8( a)
  \time 3/2
  b4 g a fs g fs
  \time 2/2
  e2. fs4 |
  \time 3/2
  g4 g g d e c | \time 2/2 b( d2.)
  % into bridge
}

melodyFour = \relative c'' {
  g8 a |
  b4 g a8 g fs4 g fs |
  \time 2/2
  e2. fs4 |
  \time 3/2
  g8 g g4 g d e c |
  \time 2/2
  b2. g'8( a)
  \time 3/2
  b4 g a fs g fs
  \time 2/2
  e2. g8 a |
  \time 3/2
  b4 d c b a g fs2 g1\prall
}

verseChords = \transpose c c, {
  g4 \maj g d \maj d c \maj c |
  \time 2/2
  e2 \min e |
  \time 3/2
  g4 \maj g \cnt b \maj g c \maj c |
  \time 2/2
  g2 \maj g |
  \time 3/2
  e4 \min e d \maj d g \maj g |
  \time 2/2
  c2 \maj c |
  \time 3/2
  g4 \maj g \cnt b \maj g c \maj c |
}

refrainChords = \transpose c c, {
  b2 \min b d4 \maj d | g \maj g \cnt b \maj g e \min e |
  c \maj c d \maj d c \maj c |
  a \min a e \min a d \maj d | d \sev d <g \maj g>2 r2
}

stradellaChords = \transpose c c, {
  \verseChords
  \refrainChords
}

finalStradellaChords = \transpose c c, {
  g4 \maj g d \maj d c \maj c |
  \time 2/2
  e2 \min e |
  \time 3/2
  g4 \maj g \cnt b \maj g c \maj c |
  \time 2/2
  g2 \maj g |
  \time 3/2
  e4 \min e d \maj d g \maj g |
  \time 2/2
  c2 \maj c |
  \time 3/2
  g4 \maj g c \maj c d \maj d |
  d \dimin a <g \maj g>1
}

\paper {
  % undoes the changes made by 2.26
  top-margin = 5\mm
  bottom-margin = 6\mm
  top-system-spacing.basic-distance = 1
  top-markup-spacing.basic-distance = 0
  left-margin = 10\mm
  right-margin = 10\mm
  inner-margin = 10\mm
  outer-margin = 20\mm
  binding-offset = 0\mm

  print-page-number = ##t
  print-first-page-number = ##f
  oddHeaderMarkup = \markup \null
  evenHeaderMarkup = \markup \null
}

\layout {
  indent = #0
}

\score {
  <<
    \new ChordNames {
      \global
      \*3 \chordNames
      \verseChordNames
      \time 2/2 \chordmode { b1:min } | \time 3/2
      \chordNames
      \finalChordNames
    }
    \new Staff \with {
      \consists "Ambitus_engraver"
    } {
      \global
      \intro g'8 a' |
      \repeat volta 2 { \melody g'8 a' | }
      \break
      \melodyTwo
      \melodyThree
      \bridge
      \melodyFour
      \fine
    }
    \addlyrics {
      \*44 \skip 4
      \words
      \wordsThree
      \wordsFour
      \*51 \skip 4
      \wordsSeven
    }
    \addlyrics {
      \*46 \skip 4
      \wordsTwo
    }
    \new StradellaStaff \with {
      \consists "Stradella_ambitus_engraver"
    } {
      \clef stradella
      \global
      \*3 \stradellaChords
      \verseChords
      \time 2/2 b2 \min b | \time 3/2
      \stradellaChords
      \finalStradellaChords
      \fine
    }
    %\addlyrics { \wordsThree }
    %\addlyrics { \wordsFour }
    %\addlyrics { \wordsSeven }
  >>
}