\version "2.26.0"

\language "english"
\include "stradella-clef.ly"
\include "stradella-ambitus.ly"

\header {
    title = "Auld Lang Syne"
    composer = "Traditional"
    tagline = "Learn Stradella clef at https://orac.github.io/stradella-clef/"
}

right = \relative {
    \key f \major
    \partial 4
    c'4 | f4. e8 f4 a | g4. f8 g4 a8( g) | f4. e8 a4 c | d2. \breathe
    4 | c4. a8 4 f | g4. f8 g4 a8( g) | f4.( d8) 4( c) | f2. \breathe
    d'4 | c4.( a8) 4( f) g4. f8 g4 d' | c4.( a8) a4( c) | d2.
    e4 | c4. a8 a4 f | g4. f8 g4 a8( g) | f4.( d8) 4( c) | f2.
    \fine
}

left = {
    \partial 4
    c4 | f4 \maj f \cnt a \maj f | c \sev c c \sev c | f \maj f f \sev f |
    bf \maj bf \cnt d \maj bf | f \maj f \cnt a \maj f | c \maj c g \sev c | d \min d g \sev c | f \maj f c \sev c |
    f4 \maj f \cnt a \maj f | c \maj c c \sev c | f \maj f c \sev f |
    bf \maj bf f \sev c | f \maj f \cnt a \maj f | c \maj c g \sev c | d \min d g \sev c | f \maj f f
    \fine
}

theWords = \lyricmode {
    Should auld ac -- quain -- tance be for -- got,
    And nev -- er brought to mind,
    Should auld ac -- quain -- tance be for -- got,
    And auld lang syne.

    For auld lang syne, my jo,
    For auld lang syne,
    We'll tak a cup o' kind -- ness yet
    For auld lang syne.
}

\layout {
  indent = #0
}

\score {
    \new PianoStaff <<
        \new Staff \with {
            \consists "Ambitus_engraver"
        } {
            \new Voice = "right" \right
        }
        \new Lyrics \lyricsto "right" \theWords
        \new StradellaStaff = "left" \with {
            \consists "Stradella_ambitus_engraver"
        } {
            \clef stradella \left
        }
    >>
}