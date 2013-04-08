require! connect
CSV = require \csv-string

const EnumHeaderConfig = <[ strict guess present absent ]>
const DefaultHeaderConfig = \guess

``exports`` = module.exports = (options={}) ->
  # Row type control:
  # "strict"  : object on ;header=present, array on ;header=absent or missing
  # "guess"   : if ;header is missing, guess it based on whether the first row contains numbers
  # "present" : always use object rows with first row as header
  # "absent"  : always use array rows with ["_0","_1","_2"...]
  # ["list","of","columns"]: always use object rows with specified headers
  { header-config=DefaultHeaderConfig } = options
  unless Array.isArray header-config or header-config in EnumHeaderConfig
    console.log "Warning: connect-csv header: '#header-config' not in #EnumHeaderConfig, defaulting to #DefaultHeaderConfig"
    header-config = DefaultHeaderConfig

  return function csv(req, res, next)
    return next! if req._body
    return next! unless connect.utils.mime(req) is \text/csv
    header = header-config
    if header in <[ strict guess ]>
      for chunk in req.headers['content-type'] / ';'
        continue unless chunk is /^\s*header=(present|absent)\s*$/i
        header = RegExp.$1.toLowerCase!
    header = \absent if header is \strict
    buf = ''
    req
      ..body = []
      .._body = true
      ..setEncoding \utf8
      ..on \data -> buf += it
      ..on \end -> try
        buf -= /\n*$/
        req.body = CSV.parse buf
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
