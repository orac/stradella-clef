// Copies the library into the site's public/ directory so that the site can
// offer it for download.  Copying rather than committing a second copy is the
// point: the file served at /stradella-clef.ly is byte-identical to the one in
// the repository root by construction, and cannot drift from it.

import { copyFile, mkdir } from 'node:fs/promises';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const here = dirname(fileURLToPath(import.meta.url));
const source = resolve(here, '../../stradella-clef.ly');
const destination = resolve(here, '../public/stradella-clef.ly');

await mkdir(dirname(destination), { recursive: true });
await copyFile(source, destination);

console.log(`sync-library: ${source} -> ${destination}`);
