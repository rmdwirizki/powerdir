import {Box} from '../core/Box.imba'
import {Store} from '../global/Store.imba'

import {ItemBox} from './ItemBox.imba'

export tag ListItemBox < ItemBox
  prop filter default: ''

  def generate item, index
    if !self.isActive item
      Box.load item, index

  def isActive item
    if Store:boxes:length > index + 1
      return item:name == Store:boxes[index  + 1]:name

  def hasDescription item
    return (item:description) ? true : false

  def clearFilter
    @filter = ''
    self.filterList
    
  def filterList e
    const isMatch = do |item1, item2|
      return item1.toLowerCase().indexOf(item2.toLowerCase()) > -1
    setTimeout(&, 0) do
      for item in box:children
        item:hide = !isMatch item:name, (e) ? e.target.value : @filter
        item:hide = !isMatch item:alias, e.target.value if item:alias && item:hide
        item:hide = !isMatch item:description, e.target.value if item:description && item:hide
      Imba.commit

  def render
    <self>
      <nav.panel.m-b-0>
        <p.panel-heading .has-background-info=isLast .has-text-white=isLast>
          <i.icon-folder attr:aria-hidden="true">
          " " + box:alias
        <div.panel-block .has-background-grey-lighter=(filter !== '')>
          <p.control.has-icons-left>
            <input.input.is-small[filter] :keydown.filterList :paste.filterList type="text" placeholder="Filter">
            <span.icon.is-small.is-left>
              <i.icon-search attr:aria-hiden="true">
        if filter !== ''
          <div.panel-block.has-background-light.is-size-7 css:justify-content="center">
            <a.has-text-grey :tap.clearFilter> "Clear Filter"
        # <p.panel-tabs>
        #   <a.is-active> "Tab One"
        #   <a> "Tab Two"
      <div.panel-container>
        for item in box:children
          <a.panel-block .is-hidden=item:hide .has-description=hasDescription(item) .is-active=isActive(item) :tap.generate(item, index)>
            <span.panel-icon>
              if item:type == 'directory'
                <i.icon-folder attr:aria-hidden="true">
              elif item:type == 'file'
                <i.icon-book attr:aria-hidden="true">
            <span> item:alias
            <div><small> item:description if item:description