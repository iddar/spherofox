var roundRobot = require('./sphero');
var sphero = new roundRobot.Sphero();
var keypress = require('keypress');
var io = require('socket.io-client');
// tty.Sphero-RRY-RN-SPP
//cu.Sphero-RRY-RN-SPP

// make `process.stdin` begin emitting "keypress" events
keypress(process.stdin);

console.log(sphero);

sphero.on("Sphero connected", function(ball){
  console.log("Connected!");

  var rgb = color();
  sphero.setRGBLED(rgb[0], rgb[1], rgb[2], false);

  // listen for the "keypress" event
  process.stdin.on('keypress', function (ch, key) {
    if (key && key.ctrl && key.name == 'c') {
      process.stdin.pause(); process.exit();
    }
   if(key && key.name == 'c'){
      var rgb = color();
      sphero.setRGBLED(rgb[0], rgb[1], rgb[2], false);
    }
    if(key && key.name == 'b') sphero.setBackLED(1);
    if(key && key.name == 'n') sphero.setBackLED(0);
    if(key && key.name == 'right') sphero.setHeading(45);
    if(key && key.name == 'left') sphero.setHeading(315);
    if(key && key.name == 'up') sphero.roll(0, 0.5);
    if(key && key.name == 'down') sphero.roll(0, 0);
    if(key && key.name == 'x') sphero.setHeading(45).setHeading(315).setBackLED(1);
    
  });
  process.stdin.setRawMode(true);
  process.stdin.resume();

});

var color = function(){
  var r = Math.random()*255;
  var g = Math.random()*255;
  var b = Math.random()*255;
  return [r,g,b];
}



/*
sphero:color
sphero:backled
sphero:forward
sphero:stop
sphero:left
sphero:right
*/

//socket = io.connect("http://iddarmx-spheroweb.nodejitsu.com");
socket = io.connect("http://iddarmx-spheroweb.nodejitsu.com");
socket.on('connect', function(){
	console.log("conectado al socket");
  
  socket.on('sphero:color', function(data){
    var rgb = data.color;
    sphero.setRGBLED(rgb[0], rgb[1], rgb[2], false);
  });

  socket.on('sphero:forward', function(data){
    sphero.roll(0, 0.5);
  });

  socket.on('sphero:left', function(data){
    sphero.setHeading(315);
  });

  socket.on('sphero:right', function(data){
    sphero.setHeading(45);
  });

  socket.on('sphero:stop', function(data){
    sphero.roll(0, 0);
  });

});

sphero.connect();

