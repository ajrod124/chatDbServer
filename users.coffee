mongoose = require 'mongoose'

user = new mongoose.Schema
	username: String
	avatar: String
	onlineStatus: String

module.exports = user