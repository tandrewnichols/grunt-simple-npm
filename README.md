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

After writing the `grunt-simple-git` plugin, I realized it would be handy to have the same functionality for npm. They're so similar I probably could've made them one thing, and maybe someday I will. For now, though I kind of appreciate the semantic separation. You know what you're getting when you install `grunt-simple-npm` or `grunt-simple-git`, whereas with something like `grunt-simple-cli` you might not.

### Overview

The `npm` task is a multiTask, where the target is (usually) the npm command to run. You can configure as many npm commands as are useful to you either in your `grunt.initConfig` call or, as mentioned above, by using [task-master](https://github.com/tandrewnichols/task-master). I strongly recommend using task-master . . . not just because I wrote it. I wrote it because grunt configuration is messy and annoying and sometimes, at least with `loadNpmTasks`, redundant (I was shocked to learn that you can't pass more than one string to `loadNpmTasks` - it's plural . . . doesn't that mean I should be able to do `grunt.loadNpmTasks('grunt-foo', 'grunt-bar', 'grunt-baz')`? . . . apparently not). I've been using task-master for everything I write now for a few months, and it just makes grunt more pleasurable to use. Things are nicely separated . . . but I digress. Here's a sample configuration:

```javascript
grunt.initConfig({
  npm: {
    status: {
      options: {
        short: true
      }
    },
    add: {
      options: {
        all: true
      }
    },
    commit: {
      options: {
        message: 'Automated commit'
      }
    },
    pushToOrigin: {
      cmd: 'push origin master'
    },
    pushToHeroku: {
      cmd: 'push heroku master'
    }
  },
});
```

Then add an alias task to bundle them into one thing. I use something like this:

```javascript
grunt.registerTask('deploy', ['copy', 'npm:add', 'npm:commit', 'npm:pushToOrigin', 'npm:pushToHeroku']);
```

Now I simply run `grunt deploy` from the command line and all my readmes and coverage files are copied, staged, committed, and pushed automatically.

### Options

Any npm option can be specified, though there are some variations. Any long or short option can be specified using camelCase notation (it will be converted to dash notation):

```javascript
grunt.initConfig({
  npm: {
    log: {
      // Short option - Runs 'git log -n 2'
      n: 2
    },
    commit: {
      // Long option - Runs 'git commit --message "A message"'
      message: 'A message'
    }
  }
});
```

Options that are just flags (i.e. they have no value after them) are specified with `true`:

```javascript
grunt.initConfig({
  npm: {
    // 'git log --name-only'
    log: {
      nameOnly: true
    },
    // 'git commit -na -m "A message"'
    commit: {
      m: 'A message',
      n: true,
      a: true
    }
  }
});
```

You can also specify `=` style options. Just add `=` to the end of the arg:

```javascript
grunt.initConfig({
  npm: {
    // 'git show --summary --format=%s'
    show: {
      summary: true,
      'format=': '%s'
    }
  }
});
```

Sub-commands that aren't options (e.g. "npm push origin master", "npm checkout foo", "npm show HEAD~", etc.) can be specified using the `cmd` key.

```javascript
grunt.initConfig({
  npm: {
    // 'git push origin master --dry-run'
    push: {
      options: {
        dryRun: true
      },
      cmd: 'push origin master'
    }
  }
});
```

It might seem redundant specifying `push` as part of the `cmd` when it's the name of the target, but that's because the `cmd` option doubles as a way to run the same npm command with different arguments:

```javascript
grunt.initConfig({
  npm: {
    // 'git push origin master'
    origin: {
      cmd: 'push origin master'
    },
    // 'git push heroku master'
    heroku: {
      cmd: 'push heroku master'
    }
  }
});
```

Finally, if your usage doesn't fit these formats, you can specify raw arguments to pass to npm using the `rawArgs` option:

```javascript
grunt.initConfig({
  npm: {
    // 'git checkout master -- config/*.json'
    checkout: {
      cmd: 'checkout master',
      rawArgs: '-- config/*.json'
    }
  }
});
```

There are also a few non-npm related options, specifcally `stdio` and `cwd` which are passed as is to `child_process.spawn` (defaults are `inherit` and `.` respectivly). These are under `options` so that they can be specified for all tasks if desired:

```javascript
grunt.initConfig({
  npm: {
    options: {
      cwd: '..'
    },
    add: {
      options: {
        all: true
      }
    }
  }
});
```

## Coming soon

Filling in options after the fact via prompt (perfect for `npm commit --message` for example).

Ideally, you wouldn't have to do `cmd: 'push origin master'` if the name of the target was `push`. There's no easy way to handle this immediately, but I'd like to improve that eventually.
