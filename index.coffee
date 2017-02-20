express = require 'express'
app = express()
_ = require 'underscore'
bodyParser = require 'body-parser'
mongoose = require 'mongoose'
path = require 'path'

connection = mongoose.createConnection process.env.mongod
channels = connection.model 'channel', require('./channels')
users = connection.model 'user', require('./users')

app.set 'port', (process.env.PORT || 5000)

app.use '/img', express.static path.join __dirname, 'img'
app.use(express.static(__dirname + '/public'))
app.use bodyParser.json()
app.use bodyParser.urlencoded({extended: false})

app.set 'views', __dirname + '/views'
app.set 'view engine', 'ejs'

getChannels = (req, res) ->
	channels.find {}
	, (err, channels) ->
		if err
			res.send
				err: 'Error retrieving channels!'
				res: null
		else
			for channel in channels
				channel.messages = _.last channel.messages, 50
			res.send
				err: null
				res: channels

app.post '/', (req, res) ->
	res.sendfile __dirname + '/index.html'

app.post '/getLast50', (req, res) -> 
	getChannels req, res

app.post '/updateLog', (req, res) ->
	obj = req.body

	channels.findOne
		name: obj.name
	, (err, channel) ->
		if err or !channel?
			console.error 'Error finding channel'
		else
			messages = channel.messages
			msg =
				userId: obj.userId
				time: obj.time
				message: obj.message
			messages.push msg
			channels.update
				name: channel.name
			,
				messages: messages
			, (err, raw) ->
				if err
	  			console.error 'Error updating channel'
	  		res.send 'Logs for ' + obj.name + ' updated!'

app.post '/getUsers', (req, res) ->
	users.find {}
	, (err, users) ->
		if err
			res.send
				err: 'Error retrieving users!'
				res: null
		else
			res.send
				err: null
				res: users

app.post '/addChannel', (req, res) ->
	obj = req.body

	channels.create
		name: obj.name
		messages: []
	, (err, channel) ->
		if err
			res.send
				err: 'Error creating channel!'
				res: null
		else
			getChannels req, res

app.listen app.get('port'), ->
	console.log 'Node app is running on port', app.get('port')
	