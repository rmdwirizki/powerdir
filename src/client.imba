import {Router} from 'imba-router'

let store = {
  tree : null,
  node : null,
  pwdir: '/',
  boxes: []
}

extend tag element
  def generateBox node, index=-1
    let box = {}
    if node:type == 'directory'
      box:type = 'list'
      box:items = []

      const childs = node:children
      for child in childs
        box:items.push child

    elif node:type == 'file'
      box:type = 'read'
      box:content = 'Ini dummy content'

    if index > -1
      store:boxes.splice index + 1, store:boxes:length - index + 1

    store:boxes.push box
    store:node = node

    Imba.commit

tag ListItemBox
  prop box
  prop index

  def render
    <self>
      for item in box:items
        <div :tap.generateBox(item, index)> 
          item:name

tag App 
  def load url
    const res = await window.fetch url
    return res.json

  def build
    setRouter Router.new mode:'hash'
    store:tree = await self.load '/powerdir/data-example/imba-docs/tree.json'
    self.generateBox store:tree

  def render
    <self>
      for box,index in store:boxes
        if box:type == 'list'
          <ListItemBox box=box index=index>

Imba.mount <App>