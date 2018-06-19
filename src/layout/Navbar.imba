import {EventDispatcher as Event} from '../global/EventDispatcher.imba'

export tag Navbar
  def openSearchPanel
    Event.trigger 'searchpanelopened'
    
  def render
    <self>
      <nav.navbar.is-info>
        <div.navbar-brand>
          <a.navbar-item.is-logo href="">
            <img src=(asset('logo-inverted.png')) attr:alt="Bulma: a modern CSS framework based on Flexbox">
          <div.navbar-burger.burger data-target="nav-menu">
            <span>
            <span>
            <span>

        <div.navbar-menu id="nav-menu">
          <div.navbar-start>
            <div.navbar-item>
              <a.button.has-background-link.has-text-white :tap.prevent.openSearchPanel>
                <span.icon>
                  <i.icon-search attr:aria-hiden="true">
                <span>
                  "Quick Search"
          <div.navbar-end>
            <div.navbar-item>
              <a.button.has-background-info.has-text-white  target="_blank" href="https://github.com/rmdwirizki/powerdir">
                <span.icon.m-r-10>
                  <object data=(asset('github.svg')) type="image/svg+xml">
                <span>
                  "Source on Github"