#!
# * jsUri v1.1.1 – ported to CoffeeScript with http://js2coffee.org/
# * https://github.com/derek-watson/jsUri
# *
# * Copyright 2011, Derek Watson
# * Released under the MIT license.
# * http://jquery.org/license
# *
# * Includes parseUri regular expressions
# * http://blog.stevenlevithan.com/archives/parseuri
# * Copyright 2007, Steven Levithan
# * Released under the MIT license.
# *
# * Date: Mon Nov 14 20:06:34 2011 -0800
# 
window.Gretel or= {}
window.Gretel.Trails or= {}

window.Gretel.Trails.Query = (queryString) ->
  
  # query string parsing, parameter manipulation and stringification
  "use strict"
  # parseQuery(q) parses the uri query string and returns a multi-dimensional array of the components
  parseQuery = (q) ->
    arr = []
    i = undefined
    ps = undefined
    p = undefined
    keyval = undefined
    return arr  if typeof (q) is "undefined" or q is null or q is ""
    q = q.substring(1)  if q.indexOf("?") is 0
    ps = q.toString().split(/[&;]/)
    i = 0
    while i < ps.length
      p = ps[i]
      keyval = p.split("=")
      arr.push [keyval[0], keyval[1]]
      i++
    arr

  params = parseQuery(queryString)
  
  # toString() returns a string representation of the internal state of the object
  toString = ->
    s = ""
    i = undefined
    param = undefined
    i = 0
    while i < params.length
      param = params[i]
      s += "&"  if s.length > 0
      s += param.join("=")
      i++
    (if s.length > 0 then "?" + s else s)

  decode = (s) ->
    s = decodeURIComponent(s)
    s = s.replace("+", " ")
    s

  
  # getParamValues(key) returns the first query param value found for the key 'key'
  getParamValue = (key) ->
    param = undefined
    i = undefined
    i = 0
    while i < params.length
      param = params[i]
      return param[1]  if decode(key) is decode(param[0])
      i++

  
  # getParamValues(key) returns an array of query param values for the key 'key'
  getParamValues = (key) ->
    arr = []
    i = undefined
    param = undefined
    i = 0
    while i < params.length
      param = params[i]
      arr.push param[1]  if decode(key) is decode(param[0])
      i++
    arr

  
  # deleteParam(key) removes all instances of parameters named (key)
  # deleteParam(key, val) removes all instances where the value matches (val)
  deleteParam = (args...) ->
    [key, val] = args
    arr = []
    i = undefined
    param = undefined
    keyMatchesFilter = undefined
    valMatchesFilter = undefined
    i = 0
    while i < params.length
      param = params[i]
      keyMatchesFilter = decode(param[0]) is decode(key)
      valMatchesFilter = decode(param[1]) is decode(val)
      arr.push param  if (args.length is 1 and not keyMatchesFilter) or (args.length is 2 and not keyMatchesFilter and not valMatchesFilter)
      i++
    params = arr
    this

  
  # addParam(key, val) Adds an element to the end of the list of query parameters
  # addParam(key, val, index) adds the param at the specified position (index)
  addParam = (args...) ->
    [key, val, index] = args
    if args.length is 3 and index isnt -1
      index = Math.min(index, params.length)
      params.splice index, 0, [key, val]
    else params.push [key, val]  if args.length > 0
    this

  
  # replaceParam(key, newVal) deletes all instances of params named (key) and replaces them with the new single value
  # replaceParam(key, newVal, oldVal) deletes only instances of params named (key) with the value (val) and replaces them with the new single value
  # this function attempts to preserve query param ordering
  replaceParam = (args...) ->
    [key, newVal, oldVal] = args
    index = -1
    i = undefined
    param = undefined
    if args.length is 3
      i = 0
      while i < params.length
        param = params[i]
        if decode(param[0]) is decode(key) and decodeURIComponent(param[1]) is decode(oldVal)
          index = i
          break
        i++
      deleteParam(key, oldVal).addParam key, newVal, index
    else
      i = 0
      while i < params.length
        param = params[i]
        if decode(param[0]) is decode(key)
          index = i
          break
        i++
      deleteParam key
      addParam key, newVal, index
    this

  
  # public api
  getParamValue: getParamValue
  getParamValues: getParamValues
  deleteParam: deleteParam
  addParam: addParam
  replaceParam: replaceParam
  toString: toString

window.Gretel.Trails.Uri = (uriString) ->
  
  # uri string parsing, attribute manipulation and stringification
  "use strict"
  
  #global Query: true 
  
  #jslint regexp: false, plusplus: false 
  strictMode = false
  
  # parseUri(str) parses the supplied uri and returns an object containing its components
  parseUri = (str) ->
    
    #jslint unparam: true 
    parsers =
      strict: /^(?:([^:\/?#]+):)?(?:\/\/((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?))?((((?:[^?#\/]*\/)*)([^?#]*))(?:\?([^#]*))?(?:#(.*))?)/
      loose: /^(?:(?![^:@]+:[^:@\/]*@)([^:\/?#.]+):)?(?:\/\/)?((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?)(((\/(?:[^?#](?![^?#\/]*\.[^?#\/.]+(?:[?#]|$)))*\/?)?([^?#\/]*))(?:\?([^#]*))?(?:#(.*))?)/

    keys = ["source", "protocol", "authority", "userInfo", "user", "password", "host", "port", "relative", "path", "directory", "file", "query", "anchor"]
    q =
      name: "queryKey"
      parser: /(?:^|&)([^&=]*)=?([^&]*)/g

    m = parsers[(if strictMode then "strict" else "loose")].exec(str)
    uri = {}
    i = 14
    uri[keys[i]] = m[i] or ""  while i--
    uri[q.name] = {}
    uri[keys[12]].replace q.parser, ($0, $1, $2) ->
      uri[q.name][$1] = $2  if $1

    uri

  uriParts = parseUri(uriString or "")
  queryObj = new Gretel.Trails.Query(uriParts.query)
  
  #
  #            Basic get/set functions for all properties
  #        
  protocol = (val) ->
    uriParts.protocol = val  if typeof val isnt "undefined"
    uriParts.protocol

  hasAuthorityPrefixUserPref = null
  
  # hasAuthorityPrefix: if there is no protocol, the leading // can be enabled or disabled
  hasAuthorityPrefix = (val) ->
    hasAuthorityPrefixUserPref = val  if typeof val isnt "undefined"
    if hasAuthorityPrefixUserPref is null
      uriParts.source.indexOf("//") isnt -1
    else
      hasAuthorityPrefixUserPref

  userInfo = (val) ->
    uriParts.userInfo = val  if typeof val isnt "undefined"
    uriParts.userInfo

  host = (val) ->
    uriParts.host = val  if typeof val isnt "undefined"
    uriParts.host

  port = (val) ->
    uriParts.port = val  if typeof val isnt "undefined"
    uriParts.port

  path = (val) ->
    uriParts.path = val  if typeof val isnt "undefined"
    uriParts.path

  query = (val) ->
    queryObj = new Gretel.Trails.Query(val)  if typeof val isnt "undefined"
    queryObj

  anchor = (val) ->
    uriParts.anchor = val  if typeof val isnt "undefined"
    uriParts.anchor

  
  #
  #            Fluent setters for Uri uri properties
  #        
  setProtocol = (val) ->
    protocol val
    this

  setHasAuthorityPrefix = (val) ->
    hasAuthorityPrefix val
    this

  setUserInfo = (val) ->
    userInfo val
    this

  setHost = (val) ->
    host val
    this

  setPort = (val) ->
    port val
    this

  setPath = (val) ->
    path val
    this

  setQuery = (val) ->
    query val
    this

  setAnchor = (val) ->
    anchor val
    this

  
  #
  #            Query method wrappers
  #        
  getQueryParamValue = (key) ->
    query().getParamValue key

  getQueryParamValues = (key) ->
    query().getParamValues key

  deleteQueryParam = (args...) ->
    [key, val] = args
    if args.length is 2
      query().deleteParam key, val
    else
      query().deleteParam key
    this

  addQueryParam = (args...) ->
    [key, val, index] = args
    if args.length is 3
      query().addParam key, val, index
    else
      query().addParam key, val
    this

  replaceQueryParam = (args...) ->
    [key, newVal, oldVal] = args
    if args.length is 3
      query().replaceParam key, newVal, oldVal
    else
      query().replaceParam key, newVal
    this

  
  #
  #            Serialization
  #        
  
  # toString() stringifies the current state of the uri
  toString = ->
    s = ""
    is_ = (s) ->
      s isnt null and s isnt ""

    if is_(protocol())
      s += protocol()
      s += ":"  if protocol().indexOf(":") isnt protocol().length - 1
      s += "//"
    else
      s += "//"  if hasAuthorityPrefix() and is_(host())
    if is_(userInfo()) and is_(host())
      s += userInfo()
      s += "@"  if userInfo().indexOf("@") isnt userInfo().length - 1
    if is_(host())
      s += host()
      s += ":" + port()  if is_(port())
    if is_(path())
      s += path()
    else
      s += "/"  if is_(host()) and (is_(query().toString()) or is_(anchor()))
    if is_(query().toString())
      s += "?"  if query().toString().indexOf("?") isnt 0
      s += query().toString()
    if is_(anchor())
      s += "#"  if anchor().indexOf("#") isnt 0
      s += anchor()
    s

  
  #
  #            Cloning
  #        
  
  # clone() returns a new, identical Uri instance
  clone = ->
    new Uri(toString())

  
  # public api
  protocol: protocol
  hasAuthorityPrefix: hasAuthorityPrefix
  userInfo: userInfo
  host: host
  port: port
  path: path
  query: query
  anchor: anchor
  setProtocol: setProtocol
  setHasAuthorityPrefix: setHasAuthorityPrefix
  setUserInfo: setUserInfo
  setHost: setHost
  setPort: setPort
  setPath: setPath
  setQuery: setQuery
  setAnchor: setAnchor
  getQueryParamValue: getQueryParamValue
  getQueryParamValues: getQueryParamValues
  deleteQueryParam: deleteQueryParam
  addQueryParam: addQueryParam
  replaceQueryParam: replaceQueryParam
  toString: toString
  clone: clone