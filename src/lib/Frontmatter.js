import * as frontMatter from '@egoist/front-matter/dist/front-matter'
function parse(str) {
  const  { head, body } = frontMatter(str.replace(/\r?/g, ''))
  return { head: head, body: body }
}
export const Frontmatter = parse
