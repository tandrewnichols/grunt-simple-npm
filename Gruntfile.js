module.exports = function(grunt) {
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-mocha-test');
  grunt.loadNpmTasks('grunt-mocha-cov');
  grunt.loadTasks('tasks');

  grunt.initConfig({
    jshint: {
      options: {
        reporter: require('jshint-stylish'),
        eqeqeq: true,
        es3: true,
        indent: 2,
        newcap: true,
        quotmark: 'single'
      },
      all: ['tasks/*.js']
    },
    mochacov: {
      lcov: {
        options: {
          reporter: 'mocha-lcov-reporter',
          instrument: true,
          ui: 'mocha-given',
          require: 'coffee-script/register',
          output: 'coverage/coverage.lcov'
        },
        src: ['test/helpers.coffee', 'test/**/*.coffee', '!test/acceptance.coffee'],
      },
      html: {
        options: {
          reporter: 'html-cov',
          ui: 'mocha-given',
          require: 'coffee-script/register',
          output: 'coverage/coverage.html'
        },
        src: ['test/helpers.coffee', 'test/**/*.coffee', '!test/acceptance.coffee']
      }
    },
    mochaTest: {
      options: {
        reporter: 'spec',
        ui: 'mocha-given',
        require: 'coffee-script/register'
      },
      test: {
        src: ['test/helpers.coffee', 'test/**/*.coffee']
      }
    },
    npm: {
    }
  });

  grunt.registerTask('mocha', ['mochaTest:test']);
  grunt.registerTask('default', ['jshint:all', 'mocha']);
  grunt.registerTask('coverage', ['mochacov:html']);
  grunt.registerTask('travis', ['jshint:all', 'mocha', 'mochacov:lcov']);
};
