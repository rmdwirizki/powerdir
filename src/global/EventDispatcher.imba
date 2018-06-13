class EventDispatcher
  prop eventFuncs default: {}
  prop node

  def initialize
    @node = document.createTextNode ''

  def on eventName, func
    @node.addEventListener eventName, func
    @eventFuncs[eventName] = func

  def once eventName, func
    if !@eventFuncs[eventName]
      @node.addEventListener eventName, func
      @eventFuncs[eventName] = func

  def off eventName
    @node.removeEventListener eventName, @eventFuncs[eventName]
    delete @eventFuncs[eventName]

  def trigger eventName, data
    return if !eventName
    const e = CustomEvent.new eventName, {'detail': data}
    @node.dispatchEvent e

export var EventDispatcher = EventDispatcher.new