connect-csv
===========

Connect Middleware for parsing incoming `text/csv` data type.

```javascript
csv = require('connect-csv');
var app = express();
app.use(csv()); // Prepends header row only for 'text/csv; header=absent'

app.use(csv({ header: 'guess' })); // Prepend header row heuristically
app.use(csv({ header: ['x','y','z'] })); // Always prepend this row
app.use(csv({ header: 'present' })); // Never prepend header row
```

This middleware parses the `Content-Type` header, and sets
`request.body` to an array-of-array structure for `text/csv` data,
as defined in [RFC 4180](https://tools.ietf.org/html/rfc4180).

By default, if the MIME type is `text/csv; header=absent`, we
prepend `request.body` with an array of `["_0", "_1", ...]`
which serves as a default header row.

If `header` middleware parameter is `guess`, and if any field in the
first row begin with numbers, then it's treated the same way as
`header=absent`.

# CC0 1.0 Universal

To the extent possible under law, 唐鳳 has waived all copyright
and related or neighboring rights to connect-csv.

This work is published from Taiwan.

http://creativecommons.org/publicdomain/zero/1.0
