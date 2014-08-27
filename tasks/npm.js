var cp = require('child_process');
var _ = require('lodash');
_.mixin(require('underscore.string'));

module.exports = function(grunt) {
  grunt.registerMultiTask('npm', 'A simple API for using npm via grunt', function() {
    var done = this.async();
    var options = this.options();
    var target = _.dasherize(this.target);
    var flag = [];
    var nonFlag = [];

    // Build out npm options
    var npmOptions = _.chain(options).keys().reduce(function(memo, key) {
      // Allow short options
      if (key.length === 1) {
        if (options[key] === true) flag.push(key);
        else nonFlag.push(key);
      } else {
        if (_.endsWith(key, '=')) {
          memo.push('--' + _.dasherize(key) + options[key]);
        } else {
          memo.push('--' + _.dasherize(key));
          // Specifically allow "true" to mean "this flag has no arg with it"
          if (options[key] !== true) memo.push(options[key]);
        }
      }
      return memo;
    }, []).value();

    // Collect short options
    if (flag.length) npmOptions.push('-' + flag.join(''));
    _.each(nonFlag, function(k) {
      npmOptions = npmOptions.concat([ '-' + k, options[k] ]);
    });
    
    // Allow multiple tasks that run the same npm command
    if (this.data.cmd) {
      var cmdArgs = this.data.cmd.split(' ');
      target = cmdArgs.shift();
      if (target === 'npm') target = cmdArgs.shift();
      npmOptions = cmdArgs.concat(npmOptions);
    }

    if (this.data.rawArgs) npmOptions = npmOptions.concat(this.data.rawArgs);
    
    // Create npm process
    var npmCmd = cp.spawn('npm', [target].concat(npmOptions), { stdio: this.data.stdio || 'inherit', cwd: this.data.cwd || '.' });
    npmCmd.on('close', function(code) {
      done();
    });
  });
};
