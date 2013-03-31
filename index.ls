{utils} = require connect

const EnumHeaderConfig = <[ strict guess present absent ]>
const DefaultHeaderConfig = \guess

``exports`` = module.exports = (options={}) ->
  # Row type control:
  # "strict"  : object on ;header=present, array on ;header=absent or missing
  # "guess"   : if ;header is missing, guess it based on whether the first row contains numbers
  # "present" : always use object representation with first row as header
  # "absent"  : always use array representation
  { header=DefaultHeaderConfig } = options
  unless header in EnumHeaderConfig
    console.log "Warning: connect-csv header setting #header not in #EnumHeaderConfig, defaulting to #DefaultHeaderConfig"
    header = DefaultHeaderConfig

  return function csv (req, res, next)
    return next! if req._body
    return next! unless utils.mime(req) is \text/csv'
    buf = ''
    req
      ..body ||= {}
      .._body = true
      ..setEncoding \utf8
      ..on \data -> buf += it
      ..on \end ->
        console.log buf

/*
    limit(req, res, function(err){
      if (err) return next(err);
      var buf = '';
      req.setEncoding('utf8');
      req.on('data', function(chunk){ buf += chunk });
      req.on('end', function(){
        if (strict && '{' != buf[0] && '[' != buf[0]) return next(utils.error(400, 'invalid json'));
        try {
          req.body = JSON.parse(buf, options.reviver);
          next();
        } catch (err){
          err.body = buf;
          err.status = 400;
          next(err);
        }
      });
    });
  }
*/
