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

After writing the `grunt-simple-git` plugin, I realized it would be handy to have the same functionality for npm. They're so similar I probably could've made them one thing, and maybe someday I will. For now, though, I kind of appreciate the semantic separation. You know what you're getting when you install `grunt-simple-npm` or `grunt-simple-git`, whereas with something like `grunt-simple-cli` you might not.

### Overview

The `npm` task is a multiTask, where the target is (usually) the npm command to run. You can configure as many npm commands as are useful to you either in your `grunt.initConfig` call or, as mentioned above, by using [task-master](https://github.com/tandrewnichols/task-master). I strongly recommend using task-master . . . not just because I wrote it. I wrote it because grunt configuration is messy and annoying and sometimes, at least with `loadNpmTasks`, redundant (I was shocked to learn that you can't pass more than one string to `loadNpmTasks` - it's plural . . . doesn't that mean I should be able to do `grunt.loadNpmTasks('grunt-foo', 'grunt-bar', 'grunt-baz')`? . . . apparently not). I've been using task-master for everything I write now for a few months, and it just makes grunt more pleasurable to use. Things are nicely separated . . . but I digress. Here's a sample configuration:

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

### Options

Any npm option can be specified, though there are some variations. Any long or short option can be specified using camelCase notation (it will be converted to dash notation):

```javascript
grunt.initConfig({
  npm: {
    // Short option - Runs 'npm install -S'
    install: {
      options: {
        q: true,
        saveDev: true
      }
    },
    // Long option - Runs 'npm publish --tag 0.1.2'
    publish: {
      options: {
        tag: '0.1.2'
      }
    }
  }
});
```

Options that are just flags (i.e. they have no value after them) are specified with `true`, as above.

Sub-commands that aren't options (e.g. "npm config set email myEmail@emial.com", "npm version patch", "npm ls grunt", etc.) can be specified using the `cmd` key.

```javascript
grunt.initConfig({
  npm: {
    // 'npm version patch --message "New version 0.1.2"'
    version: {
      options: {
        message: 'New version %s'
      },
      cmd: 'version patch'
    }
  }
});
```

It might seem redundant specifying `version` as part of the `cmd` when it's the name of the target, but that's because the `cmd` option doubles as a way to run the same npm command with different arguments:

```javascript
grunt.initConfig({
  npm: {
    // 'npm version patch'
    patch: {
      cmd: 'version patch'
    },
    // 'npm version minor'
    minor: {
      cmd: 'version minor'
    },
    // 'npm version major'
    major: {
      cmd: 'version major'
    }
  }
});
```

Additionally, if `cmd` is the configuration you need, you can pass that as the entirety of the task body:

```javascript
grunt.initConfig({
  npm: {
    owner: 'owner ls grunt-simple-npm'
  }
});
```

Finally, if your usage doesn't fit these formats, you can specify raw arguments to pass to npm using the `rawArgs` option:

```javascript
grunt.initConfig({
  npm: {
    // 'npm explor grunt -- cat package.json'
    explor: {
      cmd: 'explore grunt',
      rawArgs: '-- cat package.json'
    }
  }
});
```

There are also a few non-npm related options: `stdio` and `cwd`, which are passed as is to `child_process.spawn` (defaults are `inherit` and `process.cwd()` respectivly) and `force`, which you can use for non-critical git commands that should not halt the grunt task chain (like `--force` but on a per task basis). These are under `options` so that they can be specified for all tasks if desired. If you want to turn off `stdio` altogether (which you probably shouldn't do), you can pass `stdio: false`.

```javascript
grunt.initConfig({
  npm: {
    options: {
      cwd: '..',
      stdio: false
    },
    ls: {
      options: {
        depth: 1
      }
    }
  }
});
```

## Coming soon

Filling in options after the fact via prompt (perfect for `npm install --save` for example).

Ideally, you wouldn't have to do `cmd: 'version patch'` if the name of the target was `version`. There's no easy way to handle this immediately, but I'd like to improve that eventually.
