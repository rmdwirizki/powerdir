import './styles/appStyles.scss'
import './global/Extend.imba'

import {Router} from 'imba-router'

import {Connect} from './global/Connect.imba'
import {Box} from './global/Box.imba'
import {Store} from './global/Store.imba'

import {Navbar} from './layout/Navbar.imba'
import {TopScroller} from './layout/TopScroller.imba'
import {Breadcrumb} from './layout/Breadcrumb.imba'
import {Boxes} from './layout/Boxes.imba'

tag App 
  def build
    setRouter Router.new mode:'hash'
    Store:tree = await Connect.fetchData('data-example/imba-docs/tree.json', true)
    Box.load Store:tree

  def render
    <self>
      <Navbar>
      <TopScroller>
      <Breadcrumb>
      <Boxes>

Imba.mount <App>