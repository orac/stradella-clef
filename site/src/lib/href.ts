/** Prefixes an internal path with the site's `base` (`/stradella-clef` on GitHub Pages, `/` on a custom domain).
 *
 * Astro applies `base` to assets it emits, but not to hrefs you write yourself, so every internal link on the site goes through here. */
export function href(path: string): string {
    return import.meta.env.BASE_URL.replace(/\/$/, '') + '/' + path.replace(/^\//, '');
}
