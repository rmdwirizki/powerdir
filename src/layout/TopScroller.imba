import {Store} from '../global/Store.imba'
import {Scroller} from '../components/Scroller.imba'

export tag TopScroller < Scroller
  def mount
    @syncedScroller = document.querySelector('.Boxes.Scroller')
    super

  def render
    <self.syncscroll attr:name='box-scroller'>
      <div.inner-scroller css:width=Store:scroller:width>