import {Connect} from '../global/Connect.imba'
import {Store} from '../global/Store.imba'

import {SyncScroll} from '../lib/syncScroll.js'

export tag Scroller
  prop domScroll
  prop syncedScroller

  def mount
    @domScroll = self.dom
    await self.reset
    SyncScroll() if @domScroll && @syncedScroller

  def reset
    # Must be overridden in childs tag
