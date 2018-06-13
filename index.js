const fs = require('fs');
const dirTree = require('directory-tree');
const shortid = require('shortid');

const tree = dirTree('./data-example/imba-docs', {
  extensions:/\.(md|json)/,
  exclude:/tree.json/
});
const walk = function(node) {
  if(node.children) {
    for (let index = 0; index < node.children.length; index++) {
      walk(node.children[index]);
    }
  }
  
  node['id'] = shortid.generate();
  delete node['size'];
}

const mutatedTree = walk(tree);

fs.writeFile('./data-example/imba-docs/tree.json', JSON.stringify(tree, null, 2), err => {
  if (err) throw err;
  console.log('File successfully written to disk');
});
