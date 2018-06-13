import {Connect} from './Connect.imba'
import {Store} from './Store.imba'
import {EventDispatcher as Event} from './EventDispatcher.imba'

class Box
  prop isFetching default: {status: false, id: -1}

  def fetchTree
    Store:tree = await Connect.fetchData('data-example/imba-docs/tree.json', true)
    
  # Remove leading number
  def removeNumbering str
    return str.replace /^\d+\.\s*/, ''

  def create node, box={}
    box = Object.assign {}, {}, node
    box:alias = self.removeNumbering node:name

    if node:type == 'directory'
      self.isFetching:status = false
  
      box:children = []
      for child, i in node:children
        if child:name !== 'meta.json'
          child:alias = self.removeNumbering child:name
          # child:description = 'Lorem ipsum dolor sit amet lorem ipsum dolor sit amet'
          box:children.push child

    elif node:type == 'file'
      box:content = ''
      box:loading = true

      self.isFetching:status = true
      self.isFetching:id = Date.now()

      # Run on separate thread
      Connect.async do
        const fetchId = self.isFetching:id
        const content = await Connect.fetchData node:path

        if self.isFetching:status && self.isFetching:id == fetchId
          let index = node:index
          index++ if Store:boxes[index + 1]

          Store:boxes[index]:loading = false
          Store:boxes[index]:content = content
          
          self.isFetching:status = false
        
          Imba.commit
    
    return box

  def load node, index=-1, trigger=true
    let box = self.create Object.assign node, {}, {index: index}

    if index > -1
      Store:boxes.splice index + 1, Store:boxes:length - index + 1

    Store:boxes.push box
    Store:node = node

    if trigger
      Event.trigger 'boxloaded'
      Imba.commit

    return box

  def remove index
    Store:boxes.splice index + 1, Store:boxes:length - index + 1
    Store:node = Store:boxes[Store:boxes:length - 1]

    Event.trigger 'boxremoved'

  def search id
    let itemFound = null

    const walk = do |node|
      return if itemFound != null
      itemFound = node if node:id == id 
      if node:children
        for child, index in node:children
          walk child

    walk Store:tree

    return itemFound

  def open id, trigger=true
    const item = self.search id

    if item
      let path = item:path
      path = path.split('data-example/')
      path = path[1].split('/')
      
      Store:boxes = [] # Reset boxes items

      let node = Store:tree
      for name, index in path
        let box = null
        if !node:length
          box = node if node:name == name
        else
          for child in node
            box = child if child:name == name
        
        Box.load box, index, false if box !== null
        node = box:children if box:children
      
      # To make sure event listener setup (on) first before triggered
      Connect.timeout 0, do 
        Event.trigger 'boxloaded'  if  trigger
        Event.trigger 'syncscroll' if !trigger
    else
      Event.trigger 'boxnotfound'

    return; # End of line return bug

export var Box = Box.new