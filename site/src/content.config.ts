import { defineCollection } from 'astro:content';
import { glob } from 'astro/loaders';
import { z } from 'astro/zod';

// Globs the same .mdx files that src/pages routes as pages, purely to read their frontmatter back out. A page opts into the top nav by giving itself a `nav` block; Base.astro reads this collection instead of a hard-coded list, so a new page shows up just by adding one.
const pages = defineCollection({
    loader: glob({ pattern: '**/*.mdx', base: './src/pages' }),
    schema: z.object({
        title: z.string(),
        nav: z.object({
            label: z.string(),
            order: z.number(),
        }).optional(),
    }),
});

export const collections = { pages };
