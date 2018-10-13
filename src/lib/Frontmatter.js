const frontMatter = require('@egoist/front-matter')
function parse(str) {
  const  { head, body } = frontMatter(str.replace(/\r?/g, ''))
  return { head: head, body: body }
}
exports.Frontmatter = parse
