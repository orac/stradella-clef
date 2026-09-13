Stradella clef is a new form of accordion notation.

- [stradella-clef.ly] implements this and two forms of traditional notation for LilyPond
- [site/] is an Astro SSG to promote and teach the new notation
    - [site/src/components/Snippet.astro] runs LilyPond in the build to turn snippets of .ly format into embedded SVG
    - [site/src/styles/global.css] is the whole design system: the ink-and-paper palette, the type scale, and the `.prose` grid that everything is laid out on

## Style
There is no column limit for files in this repo. Do not wrap lines when they reach a particular length; rather when it makes semantic sense (like between JS statements).

## Design Context

### Users
Accordionists evaluating a new notation for the Stradella bass — mostly working musicians and teachers who already read one or both of the traditional conventions (written-out chords, or chords-with-letter). They arrive sceptical: adopting a new notation is a real cost, so the site has to earn it by demonstrating the notation is legible and worth learning, not just asserting that it is.

### Brand Personality
Playful and inviting. The tone should lower the barrier to trying something new — warm and a little fun, not academic or dry. Still needs to be trustworthy to a notation-literate audience, but confidence comes with a smile, not a lecture.

### Aesthetic Direction
Starting point: ink-and-paper (`--paper` #faf7f0, `--ink` #1c1a17) with LilyPond engravings sitting directly in the prose as black ink on the page's own paper colour — that mechanism (Snippet.astro hard-codes `--paper` because LilyPond draws onto it) stays.

Free to move beyond the current two-accent palette (`--accent` indigo / `--emph` wine, both lifted from `stradella-clef.ly`'s own chord colours) — new colours are fair game where they serve a bolder, more playful direction. The "site coloured by the thing it's arguing for" idea was a nice conceit but isn't a hard constraint going forward.

Anti-reference: generic AI-slop maximalism (cyan/purple gradients, glassmorphism, neon-on-dark). Bold here means confident and characterful, not loud for its own sake — this is still a site for people who care about typesetting precision.

### Design Principles
1. Warmth over authority — the site should feel like it's inviting the reader to play, not proving a thesis.
2. The engraved notation is the hero — any bolder colour/type/layout work should make the LilyPond examples land harder, never compete with or upstage them.
3. Precision persists even as personality increases — this is a notation site; typographic rigour (the type scale, the prose grid) is not up for grabs, only how boldly it's dressed.
4. One dominant move at a time — pick a clear focal point per page/component and commit, rather than spreading many small decorations evenly.
5. Colour can now do more work than before, but should still feel considered and specific to this project, not a generic bold palette bolted on.