var childProcess = require('child_process');
var flexSdk = require('flex-sdk');
var binPath = flexSdk.bin.mxmlc;
var path = require('path');
 
var childArgs = [
  '-output',
  path.resolve(__dirname, './www/player/mini.swf'),
  '--',
  path.resolve(__dirname, './miniplayer/MiniPlayer.as')
];

childProcess.execFile(binPath, childArgs, function(err, stdout, stderr) {
  if (!err) {
    console.log('done');
  } else {
    console.error(err.toString());
  }
});
