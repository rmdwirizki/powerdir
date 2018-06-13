import {ItemBox} from './ItemBox.imba'
import {Markdown} from './Markdown.imba'

export tag ReadItemBox < ItemBox
  def render
    <self>
      <nav.panel.m-b-0>
        <p.panel-heading .has-background-info=isLast .has-text-white=isLast>
          <i.icon-book attr:aria-hidden="true">
          " " + box:name
        <div.panel-block .is-loading=box:loading>
          if box:loading
            <object data=(asset('loader.svg')) type="image/svg+xml">
          else
            <Markdown.content content=box:content>