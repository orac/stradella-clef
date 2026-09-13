// Moves the LilyPond source of each <Snippet> out of its code fence and into its `code` prop.
//
// The music has to be fenced, because MDX reads { } and < > as JSX. But by the time an Astro component renders its slot, Expressive Code has turned the fence into highlighted HTML. This mdast plugin runs earlier, while the fence is still plain text.

import { fileURLToPath } from 'node:url';
import { defineMdastPlugin } from 'satteri';

export default defineMdastPlugin({
  name: 'snippet-source',
  options: { position: true },
  mdxJsxFlowElement(node, ctx) {
    if (node.name !== 'Snippet') return;
    if (node.children.some((child) => child.type !== 'code')) {
      const file = ctx.fileURL ? fileURLToPath(ctx.fileURL) : '<unknown file>';
      throw new Error(`${file}:${node.position?.start.line}: put the music inside <Snippet> in a code fence`);
    }
    const code = node.children.map((child) => child.value).join('\n');
    ctx.replaceNode(node, {
      type: 'mdxJsxFlowElement',
      name: 'Snippet',
      attributes: [...node.attributes, { type: 'mdxJsxAttribute', name: 'code', value: code }],
      children: [],
    });
  },
});
