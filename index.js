(function(){
  var connect, csvParse, typeIs, EnumHeaderConfig, DefaultHeaderConfig, split$ = ''.split, replace$ = ''.replace;
  connect = require('connect');
  csvParse = require('csv-parse');
  typeIs = require('type-is');
  EnumHeaderConfig = ['strict', 'guess', 'present', 'absent'];
  DefaultHeaderConfig = 'strict';
  exports = module.exports = function(options){
    var headerConfig;
    options == null && (options = {});
    headerConfig = options.header || DefaultHeaderConfig;
    if (!(Array.isArray(headerConfig) || in$(headerConfig, EnumHeaderConfig))) {
      console.log("Warning: connect-csv header: '" + headerConfig + "' not in " + EnumHeaderConfig + ", defaulting to " + DefaultHeaderConfig);
      headerConfig = DefaultHeaderConfig;
    }
    return (function(){
      function csv(req, res, next){
        var header, i$, ref$, len$, chunk, buf, x$;
        if (req._body) {
          return next();
        }
        if (!typeIs(req, 'text/csv')) {
          return next();
        }
        header = headerConfig;
        if (header === 'strict' || header === 'guess') {
          for (i$ = 0, len$ = (ref$ = split$.call(req.headers['content-type'], ';')).length; i$ < len$; ++i$) {
            chunk = ref$[i$];
            if (!/^\s*header=(present|absent)\s*$/i.test(chunk)) {
              continue;
            }
            header = RegExp.$1.toLowerCase();
          }
        }
        if (header === 'strict') {
          header = 'present';
        }
        buf = '';
        x$ = req;
        x$.body = [];
        x$._body = true;
        x$.setEncoding('utf8');
        x$.on('data', function(it){
          return buf += it;
        });
        x$.on('end', function(){
          var e;
          try {
            buf = replace$.call(buf, /\n*$/, '');
            return csvParse(buf, {
              delimiter: ','
            }, function(_, body){
              var res$, i$, to$, i;
              req.body = body;
              if (header === 'guess') {
                if (req.body.length && req.body[0].some((function(it){
                  return /^[-\d]/.exec(it);
                }))) {
                  header = 'absent';
                } else {
                  header = 'present';
                }
              }
              if (header === 'absent' && req.body.length) {
                res$ = [];
                for (i$ = 0, to$ = req.body[0].length; i$ < to$; ++i$) {
                  i = i$;
                  res$.push("_" + i);
                }
                header = res$;
              }
              if (Array.isArray(header)) {
                req.body.unshift(header);
              }
              return next();
            });
          } catch (e$) {
            e = e$;
            e.body = buf;
            e.status = 400;
            return next(e);
          }
        });
      }
      return csv;
    }());
  };
  function in$(x, xs){
    var i = -1, l = xs.length >>> 0;
    while (++i < l) if (x === xs[i]) return true;
    return false;
  }
}).call(this);
