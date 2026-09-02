import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

// GitHub Pages serves a project site from https://USER.github.io/REPO/, so every
// internal link and asset URL has to carry that prefix.  Set both of these to
// match the repository, or the deployed site will 404 on its own stylesheets.
// A custom domain removes the need for `base` entirely.
const SITE = 'https://USER.github.io';
const BASE = '/stradella-clef';

export default defineConfig({
  site: SITE,
  base: BASE,
  markdown: {
    shikiConfig: {
      // Shiki has no LilyPond grammar.  Scheme is a decent approximation --- the
      // interesting parts of a .ly file are Scheme anyway --- and mapping the
      // alias means ```lilypond fences highlight instead of failing the build.
      langAlias: { lilypond: 'scheme' },
    },
  },
  integrations: [
    starlight({
      title: 'Stradella clef',
      description:
        'A tabular notation for the Stradella bass of an accordion, for LilyPond.',
      social: [
        {
          icon: 'github',
          label: 'GitHub',
          href: 'https://github.com/USER/stradella-clef',
        },
      ],
      sidebar: [{ label: 'Using the library', link: '/using/' }],
    }),
  ],
});
