import {EventDispatcher as Event} from '../global/EventDispatcher.imba'

import {Box} from '../core/Box.imba'
import {Store} from '../global/Store.imba'

export tag SearchPanel
  prop keyword default: ''
  prop results default: []
  prop isOpen  default: false

  def build
    Event.on 'searchpanelopened', do |e| 
      @isOpen = true
      const input = self.dom.querySelector('input')
      setTimeout(&, 100) do input:focus()

  def closeSearchPanel
    @isOpen = false

  def search e
    setTimeout(&, 0) do
      @results = Box.searchByKeyword @keyword
      Imba.commit

  def routeTo id
    self.closeSearchPanel if window.matchMedia("(max-width: 400px)"):matches
    router.go '/' + id, { reload: false }

  def render
    <self.has-background-white-ter.is-closed=!isOpen>
      <nav.is-link.navbar>
        <div.navbar-menu>
          <div.navbar-start>
            <div.navbar-item>
              <input.input[keyword] :keydown.search :paste.search type="text" placeholder="Search..." attr:spellcheck="false">
          <div.navbar-end>
            <div.navbar-item>
              <a.button.has-background-info.has-text-white-bis :tap.prevent.closeSearchPanel>
                <span.icon>
                  <i.icon-cancel-circled attr:aria-hiden="true">
                <span>
                  "Close"
      <div.search-results>
        for item in results
          <a :tap.prevent.routeTo(item:id)>
            <div.card .has-background-grey-lighter=(item:id == router.hash.substring(2))> 
              <div.card-content>
                <p.title.is-size-6> 
                  <span.panel-icon.is-size-6.m-t-5>
                    if item:type == 'directory'
                      <i.icon-folder attr:aria-hidden="true">
                    elif item:type == 'file'
                      <i.icon-book attr:aria-hidden="true">
                  <span> item:alias
                <p.subtitle.is-size-7.m-t-5> item:description if item:description
