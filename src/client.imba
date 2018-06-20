import './global/Extend.imba'

import {Router} from 'imba-router'

import {Connect} from './global/Connect.imba'
import {Box} from './global/Box.imba'
import {Store} from './global/Store.imba'
import {EventDispatcher as Event} from './global/EventDispatcher.imba'

import {Navbar} from './layout/Navbar.imba'
import {SearchPanel} from './layout/SearchPanel.imba'
import {TopScroller} from './layout/TopScroller.imba'
import {Breadcrumb} from './layout/Breadcrumb.imba'
import {Boxes} from './layout/Boxes.imba'

tag Home
  def build
    Event.once 'boxnotfound', do |e| router.go '/', { reload: false }
    Event.once 'boxloaded',   do |e| router.go '/' + Store:node:id, { reload: false }
    Event.once 'boxremoved',  do |e| router.go '/' + Store:node:id, { reload: false }

  def load
    let firstLoad = router.history:state:reload
    firstLoad = true if firstLoad != false
    
    if firstLoad
      await Box.fetchTree if !Store:tree
      if params:id
        Box.open params:id
      else
        Box.load Store:tree
    else
      # Browser Event a,k.a Back/Forward History Button
      if Store:node:id != params:id
        Box.open params:id, false

  def render
    <self>
      <Navbar>
      <SearchPanel>
      <TopScroller>
      <Breadcrumb>
      <Boxes>

tag App 
  def build
    setRouter Router.new mode:'hash'

  def render
    <self>
      <Home route='/'>
      <Home route='/:id'>
      
Imba.mount <App>