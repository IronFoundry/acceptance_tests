var express = require('express');
var app = express();

var port = parseInt(process.env.PORT,10);

app.get('/', function(req, res){
  res.send('Hello World\n');
});

app.get('/api/environment',function(req, res) {

	var variables = [];
	for(var e in process.env) {
		variables.push({ Name: e, Value: process.env[e]});
	}

	res.json(variables);
});

app.get('/api/environment/:id', function(req, res) {

	var envValue = process.env[req.params.id];

	if (envValue == null) {
		res.send(404);
	}
	else {
		res.json({ 
			Name:  req.params.id,	
			Value: envValue,
		});
	}
});

app.logEntry = function(req, res) {
	if (req.query.entry) {
		console.log(req.query.entry);
		res.send("Posted: " + req.query.entry);
	}
	else
	{
		res.send(400, 'Entry query parameter requried');
	}
};

app.get('/api/log', app.logEntry);
app.put('/api/log', app.logEntry);


app.listen(port);

console.log('Server running at http://0.0.0.0:' + port.toString() + '/');
