const marked = require 'marked'

export tag Markdown
  prop content

  def setInner markup
    const html = await marked(markup)
    self.dom:innerHTML = html
    
  def render
    <self>
      setInner content