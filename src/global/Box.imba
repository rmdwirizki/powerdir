import {Connect} from './Connect.imba'
import {Store} from './Store.imba'
import {EventDispatcher as Event} from './EventDispatcher.imba'

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
      Connect.async do
        const fetchId = self.isFetching:id
        const content = await Connect.fetchData node:path

        if self.isFetching:status && self.isFetching:id == fetchId
          Store:boxes[node:index + 1]:loading = false
          Store:boxes[node:index + 1]:content = content
          
          self.isFetching:status = false
        
          Imba.commit
    
    return box

  def load node, index=-1
    let box = self.create Object.assign node, {}, {index: index}

    if index > -1
      Store:boxes.splice index + 1, Store:boxes:length - index + 1

    Store:boxes.push box
    Store:node = node

    Imba.commit

    Event.trigger 'boxloaded'

    return box

  def removeFrom index
    Store:boxes.splice index + 1, Store:boxes:length - index + 1
    Event.trigger 'boxremoved'

export var Box = Box.new