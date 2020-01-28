import {Connect} from '../global/Connect.imba'
import {Store} from '../global/Store.imba'
import {EventDispatcher as Event} from '../global/EventDispatcher.imba'

import {HorizontalScroll} from '../lib/HorizontalScroll.js'

import {Scroller} from '../components/Scroller.imba'
import {ListItemBox} from '../components/ListItemBox.imba'
import {ReadItemBox} from '../components/ReadItemBox.imba'

export tag Boxes < Scroller
  prop offsetWidth

  def build
    Event.on 'boxloaded',  do |e| self.onboxloaded
    Event.on 'boxremoved', do |e| self.onboxremoved
    Event.on 'syncscroll', do |e| self.sync

  def mount
    @syncedScroller = document.querySelector('.TopScroller.Scroller')
    super
    HorizontalScroll(@domScroll)

  def sync
    await Connect.timeout 100, do @offsetWidth = @domScroll:offsetWidth

    Store:scroller:width = @domScroll:scrollWidth
    Imba.commit

    Connect.timeout 100, do
      const scrollLeft = @domScroll:scrollWidth - @offsetWidth

      # Smooth Scrolling

      const duration = 200

      const startLocation = @domScroll:scrollLeft;
      const endLocation = scrollLeft;
      const distance = endLocation - startLocation;
      const increments = distance / (duration / 16);
      
      let runAnimation

      const animateScroll = do
        @domScroll.scrollBy increments, 0
        if @domScroll:scrollLeft >= endLocation
          clearInterval runAnimation
          @syncedScroller:scrollLeft = scrollLeft

      runAnimation = setInterval animateScroll, 16

  def onboxloaded
    self.sync
  
  def onboxremoved
    self.sync

  def render
    <self.container.syncscroll attr:name='box-scroller'>
      <div.boxes.is-flex>
        for box,index in Store:boxes
          if box:type == 'directory'
            <ListItemBox box=box index=index>
          elif box:type == 'file'
            <ReadItemBox box=box index=index>