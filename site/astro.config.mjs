import { defineConfig, fontProviders } from 'astro/config';
import mdx from '@astrojs/mdx';
import { satteri } from '@astrojs/markdown-satteri';
import snippetSource from './plugins/snippet-source.mjs';

// GitHub Pages serves a project site from https://orac.github.io/REPO/, so every
// internal link and asset URL has to carry that prefix.  Set both of these to
// match the repository, or the deployed site will 404 on its own stylesheets.
// A custom domain removes the need for `base` entirely.
const SITE = 'https://orac.github.io';
const BASE = '/stradella-clef';

export default defineConfig({
  site: SITE,
  base: BASE,
  markdown: {
    processor: satteri({ mdastPlugins: [snippetSource] }),
    shikiConfig: {
      // Shiki has no LilyPond grammar.  Scheme is a decent approximation --- the
      // interesting parts of a .ly file are Scheme anyway --- and mapping the
      // alias means ```lilypond fences highlight instead of failing the build.
      langAlias: { lilypond: 'scheme' },
      theme: 'github-light',
    },
  },
  // Astro downloads and self-hosts these at build time, so the pages make no
  // request to Google. Fraunces sets the display lines; Source Serif 4 sets
  // everything you actually read.
  fonts: [
    {
      provider: fontProviders.google(),
      name: 'Fraunces',
      cssVariable: '--font-display',
      weights: ['500 800'],
      styles: ['normal'],
      subsets: ['latin'],
      fallbacks: ['Georgia', 'serif'],
    },
    {
      provider: fontProviders.google(),
      name: 'Source Serif 4',
      cssVariable: '--font-body',
      weights: ['400 700'],
      styles: ['normal', 'italic'],
      subsets: ['latin'],
      fallbacks: ['Georgia', 'serif'],
    },
  ],
  integrations: [mdx()],
});
