import './styles/appStyles.scss'
import {Router} from 'imba-router'
import {Navbar} from './components/Navbar.imba'
import {Breadcrumb} from './components/Breadcrumb.imba'

const marked = require 'marked'

tag Markdown
  prop html
  def setInner markup
    this.dom:innerHTML = markup
  def render
    <self>
      setInner html

let store = {
  tree : null,
  node : null,
  boxes: []
}

extend tag element
  def asset resource=''
    return window:location:pathname + 'dist/assets/' + resource

class Connect
  prop prefix default: '/powerdir/'

  def fetchData url, json=false
    const res = await window.fetch prefix + url
    return res.json if json
    return res.text

const conn = Connect.new
  
class Box
  # Remove leading number
  def removeNumbering str
    return str.replace /^\d+\.\s*/, ''

  def create node, box={}
    if node:type == 'directory'
      box:type = 'list'
      box:items = []
      box:name = self.removeNumbering node:name

      for child in node:children
        if child:name !== '__index'
          child:name = self.removeNumbering child:name
          box:items.push child 

    elif node:type == 'file'
      const content = await conn.fetchData node:path
      box:type = 'read'
      box:content = content
      box:name = self.removeNumbering node:name
    
    return box

  def load node, index=-1
    let box = await self.create node

    if index > -1
      store:boxes.splice index + 1, store:boxes:length - index + 1

    store:boxes.push box
    store:node = node

    Imba.commit

    return box

const BOX = Box.new

tag ItemBox
  prop index
  prop box
  def isLast 
    return index == store:boxes:length - 1

tag ReadItemBox < ItemBox
  def render
    <self>
      <nav.panel.m-b-0>
        <p.panel-heading .has-background-info=isLast .has-text-white=isLast>
          box:name
        <div.panel-block>
          <Markdown.content html=marked(box:content)>

tag ListItemBox < ItemBox
  def generate item, index
    await BOX.load item, index
    trigger 'boxloaded'

  def isActive item
    if store:boxes:length > index + 1
      return item:name == store:boxes[index  + 1]:name

  def render
    <self>
      <nav.panel.m-b-0>
        <p.panel-heading .has-background-info=isLast .has-text-white=isLast>
          box:name
        <div.panel-block>
          <p.control>
            <input.input.is-small type="text" placeholder="Search">
        # <p.panel-tabs>
        #   <a.is-active> "Tab One"
        #   <a> "Tab Two"
      for item in box:items
        <a.panel-block .is-active=isActive(item) :tap.generate(item, index)>
          # <span.panel-icon>
          #   <i.fas.fa-book attr:aria-hidden="true">
          item:name

tag Boxes
  prop domScroll
  prop scrollLeft
  prop scrollWidth
  prop offsetWidth

  def reset
    return Promise.new do |resolve|
      return window.setTimeout(&, 100) do 
        @domScroll   = self.dom.closest('.container')
        @scrollLeft  = @domScroll:scrollLeft
        @scrollWidth = @domScroll:scrollWidth
        @offsetWidth = @domScroll:offsetWidth
        resolve()

  def build
    await self.reset

  def setScroll
    if @scrollWidth > @offsetWidth
      @domScroll:scrollLeft = @scrollWidth - @offsetWidth

  def onboxloaded
    await self.reset
    self.setScroll

  def render
    <self.is-flex>
      for box,index in store:boxes
        if box:type == 'list'
          <ListItemBox box=box index=index>
        elif box:type == 'read'
          <ReadItemBox box=box index=index>

tag App 
  def build
    setRouter Router.new mode:'hash'
    store:tree = await conn.fetchData('data-example/imba-docs/tree.json', true)
    BOX.load store:tree

  def render
    <self>
      <Navbar>
      <Breadcrumb boxes=store:boxes>
      <div.container>
        <Boxes>

Imba.mount <App>