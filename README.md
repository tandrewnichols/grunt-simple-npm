[![Build Status](https://travis-ci.org/tandrewnichols/grunt-simple-npm.png)](https://travis-ci.org/tandrewnichols/grunt-simple-npm) [![downloads](http://img.shields.io/npm/dm/grunt-simple-npm.svg)](https://npmjs.org/package/grunt-simple-npm) [![npm](http://img.shields.io/npm/v/grunt-simple-npm.svg)](https://npmjs.org/package/grunt-simple-npm) [![Code Climate](https://codeclimate.com/github/tandrewnichols/grunt-simple-npm/badges/gpa.svg)](https://codeclimate.com/github/tandrewnichols/grunt-simple-npm) [![Test Coverage](https://codeclimate.com/github/tandrewnichols/grunt-simple-npm/badges/coverage.svg)](https://codeclimate.com/github/tandrewnichols/grunt-simple-npm) [![dependencies](https://david-dm.org/tandrewnichols/grunt-simple-npm.png)](https://david-dm.org/tandrewnichols/grunt-simple-npm)

[![NPM info](https://nodei.co/npm/grunt-simple-npm.png?downloads=true)](https://nodei.co/npm/grunt-simple-npm.png?downloads=true)

# grunt-simple-npm

A simple API for using npm via grunt

## Getting Started

If you haven't used [Grunt](http://gruntjs.com/) before, be sure to check out the [Getting Started](http://gruntjs.com/getting-started) guide, as it explains how to create a [Gruntfile](http://gruntjs.com/sample-gruntfile) as well as install and use Grunt plugins. Once you're familiar with that process, you may install this plugin with this command:

```bash
npm install grunt-simple-npm --save-dev
```

Once the plugin has been installed, it may be enabled inside your Gruntfile with:

```javascript
grunt.loadNpmTasks('grunt-simple-npm');
```

Alternatively, install and use [task-master](https://github.com/tandrewnichols/task-master), and it will handle this for you.

## The "npm" task

This plugin uses the [simple-cli](https://github.com/tandrewnichols/simple-cli) interface, so any of the options avaiable there will work with this plugin. A summary of the more salient points are included below.

### Overview

The `npm` task is a multiTask, where the target is (usually) the npm command to run. Options to npm can be supplied in the options object, and there are various options supported by the library itself which must be under `options.simple`.

```javascript
grunt.initConfig({
  npm: {
    version: {
      cmd: 'version patch'
    },
    publish: {}
  },
});
```

Then add an alias task to bundle them into one thing. For instance, I use something like this:

```javascript
grunt.registerTask('publish', ['npm:version', 'git:push', /* other house keeping tasks . . . */ 'npm:publish']);
```

Now I simply run `grunt publish` to handle versioning, publishing, and all my other publish-oriented tasks.

### npm Options

Generally speaking, options are supplied as camel-cased equivalents of the command line options. Specifically, you can do any/all of the following:

#### Long options

```js
grunt.initConfig({
  npm: {
    install: {
      options: {
        tag: 'v1.0.0'
      }
    }
  }
});
```

This will run `npm install --tag v1.0.0`

#### Boolean options

```js
grunt.initConfig({
  npm: {
    install: {
      options: {
        production: true
      }
    }
  }
});
```

This will run `npm install --production`

#### Multi-word options

```js
grunt.initConfig({
  npm: {
    install: {
      options: {
        noOptional: true
      }
    }
  }
});
```

This will run `npm install --no-optional`

#### Short options

```js
grunt.initConfig({
  npm: {
    version: {
      options: {
        args: ['patch'],
        m: '"Update to v1.0.0"'
      }
    }
  }
});
```

This will run `npm version patch -m "Update to v1.0.0"`

#### Short boolean options

```js
grunt.initConfig({
  npm: {
    install: {
      options: {
        d: true
      }
    }
  }
});
```

This will run `npm install -d`

#### Multiple short options grouped together

I'm not sure such a thing exists in npm, but if it does, it will work. Here's a fake example:

```js
grunt.initConfig({
  npm: {
    fake: {
      options: {
        a: true,
        n: true,
        m: '"Fix stuff"'
      }
    }
  }
});
```

This will run `npm fake -an -m "Fix Stuff"`

#### Options with equal signs

Again, I can't think of an actual npm command that uses this structure, but it would work:

```js
grunt.initConfig({
  npm: {
    fake: {
      options: {
        'author=': 'tandrewnichols'
      }
    }
  }
});
```

This will run `npm fake --author=tandrewnichols`

#### Arrays of options

And again, another feature that may not get much exercise under npm, but it's there if you need it.

```js
grunt.initConfig({
  npm: {
    fake: {
      options: {
        a: ['foo', 'bar'],
        greeting: ['hello', 'goodbye']
      }
    }
  }
});
```

This will run `npm fake -a foo -a bar --greeting hello --greeting goodbye`, which, as previously mentioned, is nothing.

### Task Options

Simple cli can be configured by specifying any of the following options under `options.simple`.

#### env

Supply additional environment variables to the child process.

```js
grunt.initConfig({
  npm: {
    publish: {
      options: {
        simple: {
          env: {
            FOO: 'bar'
          }
        }
      }
    }
  }
});
```

#### cwd

Set the current working directory for the child process.

```js
grunt.initConfig({
  npm: {
    uninstall: {
      options: {
        simple: {
          cwd: './test'
        }
      }
    }
  }
});
```

#### force

If the task fails, don't halt the entire task chain.

```js
grunt.initConfig({
  npm: {
    install: {
      options: {
        simple: {
          force: true
        }
      }
    }
  }
});
```

#### onComplete

A callback to handle the stdout and stderr streams. `simple-cli` aggregates the stdout and stderr data output and will supply the final strings to the `onComplete` function. This function should have the signature `function(err, stdout, callback)` where `err` is an error object containing the stderr stream (if any errors were reported) and the code returned by the child process (as `err.code`), `stdout` is a string, and `callback` is a function. The callback must be called with a falsy value to complete the task (calling it with a truthy value - e.g. `1` - will fail the task).

```js
grunt.initConfig({
  npm: {
    ls: {
      options: {
        simple: {
          onComplete: function(err, stdout, callback) {
            if (err) {
              grunt.fail.fatal(err.message, err.code);
            } else {
              grunt.config.set('cli output', stdout);
              callback();
            }
          });
        }
      }
    }
  }
});
```

#### cmd

An alternative sub-command to call on the cli. This is useful when you want to create multiple targets that call the same command with different options/parameters. If this value is present, it will be used instead of the grunt target as the first argument to the executable.

```js
grunt.initConfig({
  // Using git as a real example
  npm: {
    major: {
      options: {
        simple: {
          cmd: 'version',
          args: ['major']
        }
      }
    },
    minor: {
      options: {
        simple: {
          cmd: 'version',
          args: 'minor'
        }
      }
    }
  }
});
```

Running `grunt npm:major` will run `npm version major` and running `grunt npm:minor` will run `npm version minor`.

#### args

Additional, non-flag arguments to pass to the executable. These can be passed as an array (as in `npm:major` above) or as a single string with arguments separated by a space (as in `npm:minor` above).

#### rawArgs

`rawArgs` is a catch all for any arguments to git that can't be handled (for whatever reason) with the options above (e.g. arguments supplied to arbitrary scripts: `npm run-script doStuff -- --foo bar`). Anything in `rawArgs` will be concatenated to the end of all the normal args.

```js
grunt.initConfig({
  npm: {
    runScript: {
      options: {
        simple: {
          args: ['doStuff'],
          rawArgs: '-- --foo bar'
        }
      }
    }
  }
});
```

#### debug

Similar to `--dry-run` in many executables. This will log the command that will be spawned in a child process without actually spawning it. Additionally, if you have an onComplete handler, a fake stderr and stdout will be passed to this handler, simulating the real task. If you want to use specific stderr/stdout messages, `debug` can also be an object with `stderr` and `stdout` properties that will be passed to the onComplete handler.

```js
grunt.initConfig({
  npm: {
    ls: {
      options: {
        simple: {
          // Invoked with default fake stderr/stdout
          onComplete: function(err, stdout, callback) {
            console.log(arguments);
          },
          debug: true
        }
      }
    },
    outdated: {
      options: {
        simple: {
          // Invoked with 'foo' and 'bar'
          onComplete: function(err, stdout, callback) {
            console.log(arguments);
          },
          debug: {
            stderr: 'foo',
            stdout: 'bar'
          }
        }
      }
    }
  }
});
```

Additionally, you can pass the `--debug` option to grunt itself to enable the above behavior in an ad hoc manner.

### Dynamic values

Sometimes you just don't know what values you want to supply to for an option until you're ready to use it (for instance, `--message`). That makes it hard to put into a task. `simple-cli` supports dynamical values (via interpolation) which can be supplied in any of three ways:

#### via command line options to grunt (e.g. grunt.option)

Supply the value when you call the task itself.

```js
grunt.initConfig({
  npm: {
    version: {
      options: {
        simple: {
          // You can also do this as a string, but note that simple-cli splits
          // string args on space, so you wouldn't be able to put space INSIDE
          // the interpolation. You'd have to say args: '{{portion}}'
          args: ['{{ portion }}']
        }
      }
    }
  }
});
```

If the above was invoked with `grunt npm:version --portion major` the final command would be `npm version major`.

#### via grunt.config

This is primarily useful if you want the result of another task to determine the value of an argument. For instance, maybe in another task you say `grunt.config.set('portion', 'minor')`, then the task above would run `npm version minor`.

#### via prompt

If `simple-cli` can't find an interpolation value via `grunt.option` or `grunt.config`, it will prompt you for one on the terminal. Thus you could do something like:

```js
grunt.initConfig({
  npm: {
    version: {
      options: {
        simple: {
          args: 'major'
        },
        message: '{{ message }}'
      }
    }
  }
});
```

and automate commits for version bumps, while still supplying an accurate message.

### Shortcut configurations

For very simple tasks, you can define the task body as an array or string, rather than as an object, as all the above examples have been.

```js
grunt.initConfig({
  npm: {
    // will invoke "npm version major"
    major: ['version major'],

    // will invoke "npm run acceptance"
    run: 'run acceptance'
  }
});
```
