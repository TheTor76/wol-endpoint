#!/usr/bin/env node

var net = require('net');

var server = net.createServer();
server.on('connection', handleConnection);

server.listen(process.env.LISTEN_PORT, process.env.LISTEN_IP, 511, function() {
  console.log('server listening to %j', server.address());
});

function handleConnection(conn) {
  var remoteAddress = conn.remoteAddress + ':' + conn.remotePort;
  console.log('new client connection from %s', remoteAddress);

  conn.setEncoding('utf8');

  conn.on('data', onConnData);
  conn.once('close', onConnClose);
  conn.on('error', onConnError);

  function onConnData(d) {
    d = d.trim().toLowerCase();
    console.log('connection from %s @ %s: "%s"', remoteAddress, new Date().toISOString(), d);
    var sys = require('sys')
    var exec = require('child_process').exec;
    var cmd;

    switch(d){
      case 'shutdown':
      case 'psshutdown/sleep':      
      case 'test':
        cmd = 'ruby /app/open_winrm.rb ' + d;
      break;
      case 'sleep':
      case 'hibernate':
      case 'suspend':
        cmd = 'ruby /app/open_ssh.rb'
      case 'wake':
        cmd = '/app/send_wol.sh ' + process.env.WOL_MAC;
      break
      default:
        conn.write('unknown data value returing early');
        return;
    }

    console.log('Running @cmd=' + cmd);
    exec(cmd, function (error, stdout, stderr) {
      console.log('stdout: ' + stdout);
      console.log('stderr: ' + stderr);
      if (error !== null) {
        console.log('exec error: ' + error);
      }
    });

    conn.write("done");
  }

  function onConnClose() {
    console.log('connection from %s closed', remoteAddress);
  }

  function onConnError(err) {
    console.log('Connection %s error: %s', remoteAddress, err.message);
  }
}
