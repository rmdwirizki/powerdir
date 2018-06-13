import {Box} from '../global/Box.imba'
import {Store} from '../global/Store.imba'

import {ItemBox} from './ItemBox.imba'

export tag ListItemBox < ItemBox
  def generate item, index
    if !self.isActive item
      Box.load item, index

  def isActive item
    if Store:boxes:length > index + 1
      return item:name == Store:boxes[index  + 1]:name

  def hasDescription item
    return (item:description) ? true : false

  def render
    <self>
      <nav.panel.m-b-0>
        <p.panel-heading .has-background-info=isLast .has-text-white=isLast>
          <i.icon-folder attr:aria-hidden="true">
          " " + box:alias
        <div.panel-block>
          <p.control.has-icons-left>
            <input.input.is-small type="text" placeholder="Search">
            <span.icon.is-small.is-left>
              <i.icon-search attr:aria-hiden="true">
        # <p.panel-tabs>
        #   <a.is-active> "Tab One"
        #   <a> "Tab Two"
      <div.panel-container>
        for item in box:children
          <a.panel-block .has-description=hasDescription(item) .is-active=isActive(item) :tap.generate(item, index)>
            <span.panel-icon>
              if item:type == 'directory'
                <i.icon-folder attr:aria-hidden="true">
              elif item:type == 'file'
                <i.icon-book attr:aria-hidden="true">
            <span> item:alias
            if item:description
              <div><small> item:description