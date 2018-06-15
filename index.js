const DIR_PATH = './data-example/imba-docs';

const fs = require('fs');
const dirTree = require('directory-tree');
const yaml = require('js-yaml');
const frontMatter = require('@egoist/front-matter');
const generateUUID = require('uuid-by-string')

const tree = dirTree(DIR_PATH, {
  extensions:/\.(md|json)/,
  exclude:/(tree|tree-clean).json/
}, (node, PATH, stats) => {
  let meta = null;
  const prefix = (node.path.indexOf('./') == 0) ? '' : './';
  // Get meta properties from meta.json 
  if(node.type == 'directory') {
    try {
      meta = require(prefix + node.path + '/meta.json');
    } catch(e) {
      // doesn't have valid meta.json  
    }
  }
  // Get meta properties from markdown header
  else if(node.type == 'file' && node.extension == '.md') {
    const content = fs.readFileSync(prefix + node.path, 'utf8');
    const { head } = frontMatter(content);
    if (head) {
      meta = yaml.safeLoad(head);
    } 
  }
  node = Object.assign(node, {}, meta);

  if(!node.id) {
    node.id = (stats && stats.ino) 
      ? generateUUID(stats.ino) : generateUUID(node.path);
  }

  delete node['size'];
  delete node['extension'];
});

fs.writeFile(DIR_PATH + '/tree-clean.json', JSON.stringify(tree, null, 2), err => { if (err) throw err; });
fs.writeFile(DIR_PATH + '/tree.json', JSON.stringify(tree), err => {
  if (err) throw err;
  console.log('File successfully written to disk');
});
