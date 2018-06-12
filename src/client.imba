import './styles/appStyles.scss'

import {Router} from 'imba-router'
import {Navbar} from './components/Navbar.imba'
import {Breadcrumb} from './components/Breadcrumb.imba'

import {reset as SyncScroll} from './lib/syncScroll.js'

class Connect
  prop prefix default: '/powerdir/'

  def timeout miliseconds=100, callback=null
    return Promise.new do |resolve|
      return window.setTimeout(&, miliseconds) do 
        callback && callback()
        resolve()

  def async callback
    self.timeout 0, callback

  def fetchData url, json=false
    const res = await window.fetch prefix + url
    return res.json if json
    return res.text

const conn = Connect.new

let store = {
  tree : null,
  node : null,
  boxes: [],
  scroller: { width: 0 }
}

extend tag element
  def asset resource=''
    return window:location:pathname + 'dist/assets/' + resource
  
const marked = require 'marked'

tag Markdown
  prop content
  def setInner markup
    const html = await marked(markup)
    self.dom:innerHTML = html
  def render
    <self>
      setInner content

class Box
  prop isFetching default: {status: false, id: -1}

  # Remove leading number
  def removeNumbering str
    return str.replace /^\d+\.\s*/, ''

  def create node, box={}
    if node:type == 'directory'
      box:type = 'list'
      box:items = []
      box:name = self.removeNumbering node:name

      self.isFetching:status = false

      for child in node:children
        if child:name !== '__index'
          child:name = self.removeNumbering child:name
          # child:description = 'Lorem ipsum dolor sit amet lorem ipsum dolor sit amet'
          box:items.push child 

    elif node:type == 'file'
      box:type = 'read'
      box:content = ''
      box:name = self.removeNumbering node:name
      box:loading = true

      self.isFetching:status = true
      self.isFetching:id = Date.now()

      # Run on separate thread
      conn.async do
        const fetchId = self.isFetching:id
        const content = await conn.fetchData node:path

        if self.isFetching:status && self.isFetching:id == fetchId
          store:boxes[node:index + 1]:loading = false
          store:boxes[node:index + 1]:content = content
          
          self.isFetching:status = false
        
          Imba.commit
    
    return box

  def load node, index=-1
    let box = self.create Object.assign node, {}, {index: index}

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
          <i.icon-book attr:aria-hidden="true">
          " " + box:name
        <div.panel-block .is-loading=box:loading>
          if box:loading
            <object data=(asset('loader.svg')) type="image/svg+xml">
          else
            <Markdown.content content=box:content>

tag ListItemBox < ItemBox
  def generate item, index
    if !self.isActive item
      BOX.load item, index
      trigger 'boxloaded'

  def isActive item
    if store:boxes:length > index + 1
      return item:name == store:boxes[index  + 1]:name

  def hasDescription item
    return (item:description) ? true : false

  def render
    <self>
      <nav.panel.m-b-0>
        <p.panel-heading .has-background-info=isLast .has-text-white=isLast>
          <i.icon-folder attr:aria-hidden="true">
          " " + box:name
        <div.panel-block>
          <p.control.has-icons-left>
            <input.input.is-small type="text" placeholder="Search">
            <span.icon.is-small.is-left>
              <i.icon-search attr:aria-hiden="true">
        # <p.panel-tabs>
        #   <a.is-active> "Tab One"
        #   <a> "Tab Two"
      <div.panel-container>
        for item in box:items
          <a.panel-block .has-description=hasDescription(item) .is-active=isActive(item) :tap.generate(item, index)>
            <span.panel-icon>
              if item:type == 'directory'
                <i.icon-folder attr:aria-hidden="true">
              elif item:type == 'file'
                <i.icon-book attr:aria-hidden="true">
            <span> item:name
            if item:description
              <div><small> item:description

tag Scroller
  prop domScroll
  prop syncedScroller

  def mount
    @domScroll = self.dom
    await self.reset
    SyncScroll() if @domScroll && @syncedScroller

  def reset
    # Must be overridden in childs tag

  def sync
    const funcSync = do
      @syncedScroller:scrollLeft = @domScroll:scrollLeft
      store:scroller:width = @domScroll:scrollWidth
    conn.timeout 50, funcSync if @syncedScroller

tag Boxes < Scroller
  prop offsetWidth

  def mount
    @syncedScroller = document.querySelector('.TopScroller.Scroller')
    super

  def reset
    conn.timeout 100, do
      @offsetWidth = @domScroll:offsetWidth
      store:scroller:width = @domScroll:scrollWidth

  def setScroll
    if store:scroller:width > @offsetWidth
      @domScroll:scrollLeft = store:scroller:width - @offsetWidth
      self.sync

  def onboxloaded
    await self.reset
    self.setScroll
    Imba.commit

  def render
    <self.container.syncscroll attr:name='box-scroller'>
      <div.boxes.is-flex>
        for box,index in store:boxes
          if box:type == 'list'
            <ListItemBox box=box index=index>
          elif box:type == 'read'
            <ReadItemBox box=box index=index>

tag TopScroller < Scroller
  def mount
    @syncedScroller = document.querySelector('.Boxes.Scroller')
    super

  def render
    <self.syncscroll attr:name='box-scroller'>
      <div.inner-scroller css:width=store:scroller:width>

tag App 
  def build
    setRouter Router.new mode:'hash'
    store:tree = await conn.fetchData('data-example/imba-docs/tree.json', true)
    BOX.load store:tree

  def render
    <self>
      <Navbar>
      <TopScroller>
      <Breadcrumb boxes=store:boxes>
      <Boxes>

Imba.mount <App>