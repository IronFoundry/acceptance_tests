var express = require('express');
var app = express();

var port = parseInt(process.env.PORT,10);

app.get('/', function(req, res){
  res.send('Hello World\n');
});

app.get('/api/environment',function(req, res) {
	res.send("Query for specific environments at /api/environment/id");	
});

app.get('/api/environment/:id', function(req, res) {

	var envValue = process.env[req.params.id];

	if (envValue == null) {
		res.send(404);
	}
	else {
		res.json({ 
			name:  req.params.id,	
			value: envValue,
		});
	}
});

app.listen(port);

console.log('Server running at http://0.0.0.0:' + port.toString() + '/');
