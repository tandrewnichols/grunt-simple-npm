module.exports = function(grunt) {
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-open');
  grunt.loadNpmTasks('grunt-mocha-test');
  grunt.loadNpmTasks('grunt-travis-matrix');
  grunt.loadNpmTasks('grunt-eslint');
  grunt.loadNpmTasks('grunt-simple-istanbul');
  grunt.loadNpmTasks('grunt-shell');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadTasks('tasks');

  grunt.initConfig({
    clean: {
      coverage: 'coverage'
    },
    open: {
      coverage: {
        path: 'coverage/coverage.html'
      }
    },
    watch: {
      tests: {
        files: ['lib/**/*.js', 'test/**/*.coffee'],
        tasks: ['mocha'],
        options: {
          atBegin: true
        }
      }
    },
    eslint: {
      tasks: {
        options: {
          configFile: '.eslint.json',
          format: 'node_modules/eslint-codeframe-formatter'
        },
        src: ['tasks/**/*.js']
      }
    },
    shell: {
      codeclimate: 'npm run codeclimate'
    },
    travisMatrix: {
      v10: {
        test: function() {
          return /^v10/.test(process.version);
        },
        tasks: ['istanbul:unit', 'shell:codeclimate']
      }
    },
    istanbul: {
      unit: {
        options: {
          root: 'tasks',
          dir: 'coverage',
          simple: {
            cmd: 'cover',
            args: ['grunt', 'mocha'],
            rawArgs: ['--', '--color']
          }
        }
      }
    },
    mochaTest: {
      test: {
        options: {
          reporter: 'spec',
          require: 'should'
        },
        src: ['test/**/*.js']
      }
    }
  });

  grunt.registerTask('mocha', ['mochaTest:test']);
  grunt.registerTask('test', ['mochaTest:test']);
  grunt.registerTask('default', ['eslint:tasks', 'mocha']);
  grunt.registerTask('cover', ['istanbul:unit', 'open:coverage']);
  grunt.registerTask('ci', ['eslint:tasks', 'mocha', 'travisMatrix']);
};
