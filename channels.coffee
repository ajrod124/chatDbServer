mongoose = require 'mongoose'

channel = new mongoose.Schema
	name: String
	messages: [
		userId: String
		time: Number
		message: String
	]

module.exports = channel