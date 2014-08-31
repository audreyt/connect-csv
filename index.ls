require! connect
csv-parse = require \csv-parse
type-is = require \type-is

const EnumHeaderConfig = <[ strict guess present absent ]>
const DefaultHeaderConfig = \strict

``exports`` = module.exports = (options={}) ->
  # Row type control:
  # "strict"  : prepend on ;header=absent, otherwise assumes ;header=present
  # "guess"   : if ;header is missing, guess it based on whether any fields in first row begin with numbers
  # "present" : never prepend header rows
  # "absent"  : always prepend header rows with ["_0","_1","_2"...]
  # ["list","of","columns"]: always prepend the specified header row
  header-config = options.header || DefaultHeaderConfig
  unless Array.isArray header-config or header-config in EnumHeaderConfig
    console.log "Warning: connect-csv header: '#header-config' not in #EnumHeaderConfig, defaulting to #DefaultHeaderConfig"
    header-config = DefaultHeaderConfig

  return function csv(req, res, next)
    return next! if req._body
    return next! unless type-is req, \text/csv
    header = header-config
    if header in <[ strict guess ]>
      for chunk in req.headers['content-type'] / ';'
        continue unless chunk is /^\s*header=(present|absent)\s*$/i
        header = RegExp.$1.toLowerCase!
    header = \present if header is \strict
    buf = ''
    req
      ..body = []
      .._body = true
      ..setEncoding \utf8
      ..on \data -> buf += it
      ..on \end -> try
        buf -= /\n*$/
        _, req.body <- csv-parse(buf, delimiter: \,)
        if header is \guess
          if req.body.length and req.body.0.some (is /^[-\d]/)
            then header := \absent
            else header := \present
        if header is \absent and req.body.length
          header := [ "_#i" for i til req.body.0.length ]
        req.body.unshift header if Array.isArray header
        next!
      catch
        e.body = buf
        e.status = 400
        next e
    return
