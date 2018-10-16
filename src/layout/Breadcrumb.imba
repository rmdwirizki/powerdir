import {Box} from '../core/Box.imba'
import {Store} from '../global/Store.imba'

export tag Breadcrumb
  def setActive index
    Box.remove index

  def render
    <self>
      <nav.breadcrumb.has-arrow-separator attr:aria-label="breadcrumbs">
        <ul>
          for box, index in Store:boxes
            <li><a :tap.setActive(index)> box:alias