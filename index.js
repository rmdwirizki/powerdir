const fs = require("fs")
const dirTree = require('directory-tree');

// const tree = dirTree('./data-example/imba-docs', null, (item, PATH) => {
//   console.log(item);
// });
// console.log(JSON.stringify(tree));

const tree = dirTree('./data-example/imba-docs');
fs.writeFile("tree.json", JSON.stringify(tree, null, 2), err => {
  if (err) throw err;
  console.log('File successfully written to disk');
})
