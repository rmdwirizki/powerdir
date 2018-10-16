import {ItemBox} from './ItemBox.imba'
import {Marked} from '../lib/Marked.js'

export tag ReadItemBox < ItemBox
  def render
    <self>
      <nav.panel.m-b-0>
        <p.panel-heading .has-background-info=isLast .has-text-white=isLast>
          <i.icon-book attr:aria-hidden="true">
          " " + box:alias
        <div.panel-block .is-loading=box:loading>
          <object .is-hidden=!box:loading data=(asset('loader.svg')) type="image/svg+xml">
          <div.content .is-hidden=box:loading html=Marked(box:content)>
