import {Router} from 'imba-router'

const marked = require 'marked'

tag Markdown
  prop html
  def mount
    this.dom:innerHTML = marked html

let store = {
  tree : null,
  node : null,
  pwdir: '/',
  boxes: []
}

class Connect
  prop prefix default: '/powerdir/'

  def fetchData url, json=false
    const res = await window.fetch prefix + url
    return res.json if json
    return res.text

const conn = Connect.new
  
class Box
  def create node, box={}
    if node:type == 'directory'
      box:type = 'list'
      box:items = []

      for child in node:children
        box:items.push child if child:name !== '__index'

    elif node:type == 'file'
      const content = await conn.fetchData node:path
      box:type = 'read'
      box:content = content
    
    return box

  def load node, index=-1
    let box = await self.create node

    if index > -1
      store:boxes.splice index + 1, store:boxes:length - index + 1

    store:boxes.push box
    store:node = node

    Imba.commit

const BOX = Box.new

tag ReadItemBox
  prop box

  def render
    <self>
      <Markdown html=box:content>

tag ListItemBox
  prop box
  prop index

  def generate item, index
    BOX.load item, index

  def render
    <self>
      for item in box:items
        <div :tap.generate(item, index)> 
          item:name

tag App 
  def build
    setRouter Router.new mode:'hash'
    store:tree = await conn.fetchData('data-example/imba-docs/tree.json', true)
    BOX.load store:tree

  def render
    <self>
      for box,index in store:boxes
        if box:type == 'list'
          <ListItemBox box=box index=index>
        elif box:type == 'read'
          <ReadItemBox box=box>

Imba.mount <App>