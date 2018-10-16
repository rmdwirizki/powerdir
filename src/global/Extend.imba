import {Connect} from './Connect.imba'

extend tag element
  def asset resource=''
    # remove filename from path (index.html / index.es5.html)
    const path = window:location:pathname.replace(/[^\/]*$/, '') 
    return path + 'dist/static/images/' + resource
  
  # PATCH IE11 FIX
  # InvalidArgument Error
  def setText text
    if text != @tree_ # ad
      var val = text === null or text === false ? '' : text
      var tod = @text_ or @dom
      if tod:outerHTML == undefined
        Connect.timeout 0, do tod:textContent = val  
      else
        tod:textContent = val
      @text_ ||= @dom:firstChild
      @tree_ = text
    self
