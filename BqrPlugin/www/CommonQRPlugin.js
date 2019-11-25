var exec = require('cordova/exec');

var PLUGIN_NAME = 'CommonQRPlugin';

var CommonQRPlugin = {
  echo: function (phrase, cb) {
    exec(cb, null, PLUGIN_NAME, 'echo', [phrase]);
  },
  
  cameraplugin: function (successCallback, errorCallback, action, argumen) {
    exec(successCallback, errorCallback, PLUGIN_NAME, action, [argumen]);
  },
  galleryplugin: function (successCallback, errorCallback, action, argumen) {
    exec(successCallback, errorCallback, PLUGIN_NAME, action, [argumen]);
  }
};

module.exports = CommonQRPlugin;
