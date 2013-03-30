{utils} = require connect

``exports`` = module.exports = (options={}) ->
  # "auto"    = object on header=present, array on header=absent (default)
  # "guess"   = guess header=present based on type comparison on the first two rows
  # "present" = always use object representation with first row as header
  # "absent"  = always use array representation
  { header=\auto } = options
  return function json(req, res, next)
    return next! if req._body
    return next! unless utils.mime(req) is \text/csv'
    req.body ||= {};
    req._body = true;

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
