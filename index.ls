require! <[ fast-csv connect ]>

const EnumHeadersConfig = <[ strict guess present absent ]>
const DefaultHeadersConfig = \guess

``exports`` = module.exports = (options={}) ->
  # Row type control:
  # "strict"  : object on ;header=present, array on ;header=absent or missing
  # "guess"   : if ;header is missing, guess it based on whether the first row contains numbers
  # "present" : always use object rows with first row as header
  # "absent"  : always use array rows
  # ["list","of","columns"]: always use object rows with specified headers
  { headers=DefaultHeadersConfig } = options
  unless headers in EnumHeadersConfig
    console.log "Warning: connect-csv headers: '#headers' not in #EnumHeadersConfig, defaulting to #DefaultHeadersConfig"
    headers = DefaultHeadersConfig

  return function csv(req, res, next)
    return next! if req._body
    return next! unless connect.utils.mime(req) is \text/csv
    buf = ''
    req.body = []
    req._body = true
    req.setEncoding \utf8
    data = []
    # TODO: guess, auto
    headers = true if headers is \present
    headers = null if headers is \absent
    fast-csv(req, {headers})
      ..on \data ->
        console.log \data
        req.body.push it
      ..on \end ->
        console.log \going
        console.log next
        console.log req.body
        next!
      ..parse!
