// Generated by CoffeeScript 1.12.2
(function() {
  var mongoose, user;

  mongoose = require('mongoose');

  user = new mongoose.Schema({
    username: String,
    avatar: String,
    onlineStatus: String
  });

  module.exports = user;

}).call(this);
