# Stradella clef

A tabular notation for the Stradella bass of an accordion, and the LilyPond machinery to engrave the same input three ways.

You write down the *buttons you press*, once. The library can engrave it as different kinds of accordion notation: fully written-out chords, or the traditional convention of putting chords in the top half of the staff with a letter to show the chord shape, or the new Stradella clef notation.

<!-- TODO: an engraved example image goes here. It is the whole pitch, and it should be
     the first thing anyone sees. -->

**[Read the documentation](https://orac.github.io/stradella-clef/)**

## Install

Save [`stradella-clef.ly`](https://orac.github.io/stradella-clef/stradella-clef.ly) next to your score and include it:

```lilypond
\include "stradella-clef.ly"
```

You can also put it in a different directory and use LilyPond's `-I path/to/include/dir` option to make it findable.

## Requirements

LilyPond 2.24.1 or newer.

## Documentation

<!-- TODO: keep these pointing at the real pages once they exist. -->

- [Why Stradella clef?](https://orac.github.io/stradella-clef/) — what problem it solves
- [Using the library](https://orac.github.io/stradella-clef/using/) — writing basslines, the three engravings, migrating from `stradella.ly`

## Licence

GPLv3 or later: the same terms as LilyPond itself. See [LICENSE](LICENSE).
