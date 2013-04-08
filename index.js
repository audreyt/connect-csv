(function(){
  var connect, CSV, EnumHeaderConfig, DefaultHeaderConfig, split$ = ''.split, replace$ = ''.replace;
  connect = require('connect');
  CSV = require('csv-string');
  EnumHeaderConfig = ['strict', 'guess', 'present', 'absent'];
  DefaultHeaderConfig = 'guess';
  exports = module.exports = function(options){
    var headerConfig, ref$;
    options == null && (options = {});
    headerConfig = (ref$ = options.headerConfig) != null ? ref$ : DefaultHeaderConfig;
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
        if (connect.utils.mime(req) !== 'text/csv') {
          return next();
        }
        header = headerConfig;
        if (header == 'strict' || header == 'guess') {
          for (i$ = 0, len$ = (ref$ = split$.call(req.headers['content-type'], ';')).length; i$ < len$; ++i$) {
            chunk = ref$[i$];
            if (!/^\s*header=(present|absent)\s*$/i.test(chunk)) {
              continue;
            }
            header = RegExp.$1.toLowerCase();
          }
        }
        if (header === 'strict') {
          header = 'absent';
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
          var res$, i$, to$, i, e;
          try {
            buf = replace$.call(buf, /\n*$/, '');
            req.body = CSV.parse(buf);
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
  function in$(x, arr){
    var i = -1, l = arr.length >>> 0;
    while (++i < l) if (x === arr[i] && i in arr) return true;
    return false;
  }
}).call(this);
