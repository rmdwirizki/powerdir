import {Connect} from '../global/Connect.imba'
import {Store} from '../global/Store.imba'
import {EventDispatcher as Event} from '../global/EventDispatcher.imba'

import {Scroller} from '../components/Scroller.imba'
import {ListItemBox} from '../components/ListItemBox.imba'
import {ReadItemBox} from '../components/ReadItemBox.imba'

export tag Boxes < Scroller
  prop offsetWidth

  def build
    Event.on 'boxloaded',  do |e| self.onboxloaded
    Event.on 'boxremoved', do |e| self.onboxremoved

  def mount
    @syncedScroller = document.querySelector('.TopScroller.Scroller')
    super

  def sync
    await Connect.timeout 100, do @offsetWidth = @domScroll:offsetWidth

    Store:scroller:width = @domScroll:scrollWidth
    Imba.commit

    Connect.timeout 100, do
      const scrollLeft = @domScroll:scrollWidth - @offsetWidth
      @domScroll:scrollLeft = scrollLeft
      @syncedScroller:scrollLeft = scrollLeft

  def onboxloaded
    self.sync
  
  def onboxremoved
    self.sync

  def render
    <self.container.syncscroll attr:name='box-scroller'>
      <div.boxes.is-flex>
        for box,index in Store:boxes
          if box:type == 'list'
            <ListItemBox box=box index=index>
          elif box:type == 'read'
            <ReadItemBox box=box index=index>