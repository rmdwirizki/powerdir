import {Box} from '../core/Box.imba'
import {Connect} from '../global/Connect.imba'
import {Store} from '../global/Store.imba'
import {EventDispatcher as Event} from '../global/EventDispatcher.imba'

export tag Breadcrumb
	prop offsetWidth
	prop domScroll

	def build
		Event.on 'boxloaded',  do |e| self.updateScrollOffset
		Event.on 'boxremoved', do |e| self.updateScrollOffset

	def mount
		@domScroll = self.querySelector('.breadcrumb').dom

	def updateScrollOffset
		await Connect.timeout 100, do @offsetWidth = @domScroll:offsetWidth
		Connect.timeout 100, do
			@domScroll:scrollLeft = @domScroll:scrollWidth - @offsetWidth

	def setActive index
		Box.remove index

	def render
		<self>
			<nav.breadcrumb attr:aria-label="breadcrumbs">
				<ul>
					for box, index in Store:boxes
						<li>
							<a :tap.setActive(index)>
								if box:type == 'directory' 
									<i.icon-folder.m-r-5 attr:aria-hidden="true">
								elif box:type == 'file'
									<i.icon-book.m-r-5 attr:aria-hidden="true">
								box:alias