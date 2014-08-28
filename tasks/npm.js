var cli = require('simple-cli');

module.exports = function(grunt) {
  grunt.registerMultiTask('npm', 'A simple API for using npm via grunt', function() {
    cli.spawn(grunt, this, 'npm', this.async());
  });
};
