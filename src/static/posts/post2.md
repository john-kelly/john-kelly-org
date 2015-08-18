## Hello World Server

index.html
```html
<!doctype html>
<html>
    <body>Hello World</body>
</html>
```

server.js
```js
const http = require('http');
const fs = require('fs');

http.createServer(function (req, res) {
    fs.readFile('./index.html', function(err, data) {
        res.end(data);
    });
}).listen(8080, 'localhost');
```
