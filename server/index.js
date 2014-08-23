var express = require('express');
var app = express();
var http = require('http').Server(app);
var io = require('socket.io')(http);
var port = process.env.PORT || 8080;

http.listen(port, function() {
  console.log('Server started on port ' + port);
});

var usernames = {};
var numUsers = 0;

app.use(express.static(__dirname + '/public'))
.get('/api/users/online', function(req, res) {
  res.send(usernames);
})
.get('/api/users/online/count', function(req, res) {
  res.json({
    numUsers: numUsers
  });
});

io.on('connection', function(socket) {
  console.log('User with id ' + socket.id + ' has connected');
  var addedUser = false;

  socket.on('addUser', function(username) {
    console.log('Adding user: ' + username);

    addedUser = true;
    numUsers++;
    socket.username = username;
    usernames[username] = username;

    socket.emit('login', {
      numUsers: numUsers
    });

    console.log('Broadcasting number of users: ' + numUsers);
    socket.broadcast.emit('userJoined', {
      username: socket.username,
      numUsers: numUsers
    });
  });

  socket.on('newMessage', function(msg) {
    if (!addedUser) {
      return;
    }
    console.log('Broadcasting user message: ' + msg);
    socket.broadcast.emit('newMessage', {
      username: socket.username,
      message: msg
    });
  });

  socket.on('typing', function() {
    if (!addedUser) {
      return;
    }
    console.log('User ' + socket.username + ' is typing');
    socket.broadcast.emit('typing', {
      username: socket.username
    });
  });

  socket.on('stopTyping', function() {
    if (!addedUser) {
      return;
    }
    console.log('User ' + socket.username + ' has stopped typing');
    socket.broadcast.emit('stopTyping', {
      username: socket.username
    });
  });

  socket.on('disconnect', function() {
    if (!addedUser) {
      console.log('User with id ' + socket.id + ' has disconnected');
      return;
    }
    delete usernames[socket.username];
    addedUser = false;
    numUsers--;
    console.log('User ' + socket.username + ' has disconnected');

    socket.broadcast.emit('userLeft', {
      username: socket.username,
      numUsers: numUsers
    });
  });
});
