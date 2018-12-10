class Connect
  prop prefix default: window:location:pathname

  def timeout miliseconds=100, callback=null, resolveValue=null
    return Promise.new do |resolve|
      return window.setTimeout(&, miliseconds) do 
        callback && callback()
        resolve() if !resolveValue
        resolve(resolveValue) if resolveValue

  def async callback
    self.timeout 0, callback

  def fetchData url, json=false
    const res = await window.fetch prefix + url
    return res.json if json
    return res.text

export var Connect = Connect.new