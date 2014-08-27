EventEmitter = require('events').EventEmitter

describe 'npm', ->
  Given -> @grunt = spyObj 'registerMultiTask'
  Given -> @context =
    async: sinon.stub()
    options: sinon.stub()
    data: {}
  Given -> @cb = ->
  Given -> @context.async.returns @cb
  Given -> @context.options.returns {}
  Given -> @cp =
    spawn: sinon.stub()
  Given -> @subject = sandbox '../tasks/npm',
    child_process: @cp

  When -> @subject(@grunt)
  And -> expect(@grunt.registerMultiTask).to.have.been.calledWith 'npm', 'A simple API for using npm via grunt', sinon.match.func

  describe 'command with npm options', ->
    Given -> @emitter = new EventEmitter()
    Given -> @cp.spawn.withArgs('npm', ['install', '--tag', 'v0.2.0'], { stdio: 'inherit', cwd: '.' }).returns @emitter
    Given -> @context.target = 'install'
    Given -> @context.options.returns
      tag: 'v0.2.0'
    When ->
      @grunt.registerMultiTask.getCall(0).args[2].apply @context, []
      @emitter.emit 'close', 0
    Then -> expect(@cb).to.have.been.called

  describe 'command with a boolean flag', ->
    Given -> @emitter = new EventEmitter()
    Given -> @cp.spawn.withArgs('npm', ['install', '--production'], { stdio: 'inherit', cwd: '.' }).returns @emitter
    Given -> @context.target = 'install'
    Given -> @context.options.returns
      production: true
    When ->
      @grunt.registerMultiTask.getCall(0).args[2].apply @context, []
      @emitter.emit 'close', 0
    Then -> expect(@cb).to.have.been.called

  describe 'command with short flags', ->
    Given -> @emitter = new EventEmitter()
    Given -> @cp.spawn.withArgs('npm', ['install', '-dg', '-t', 'v0.0.1'], { stdio: 'inherit', cwd: '.' }).returns @emitter
    Given -> @context.target = 'install'
    Given -> @context.options.returns
      d: true
      t: 'v0.0.1'
      g: true
    When ->
      @grunt.registerMultiTask.getCall(0).args[2].apply @context, []
      @emitter.emit 'close', 0
    Then -> expect(@cb).to.have.been.called

  describe 'command with extra options', ->
    Given -> @emitter = new EventEmitter()
    Given -> @cp.spawn.withArgs('npm', ['install', '--tag', 'v0.2.0'], { stdio: 'foo', cwd: 'bar' }).returns @emitter
    Given -> @context.target = 'install'
    Given -> @context.options.returns
      tag: 'v0.2.0'
    Given -> @context.data =
      stdio: 'foo'
      cwd: 'bar'
    When ->
      @grunt.registerMultiTask.getCall(0).args[2].apply @context, []
      @emitter.emit 'close', 0
    Then -> expect(@cb).to.have.been.called

  describe 'command with sub-commands', ->
    Given -> @emitter = new EventEmitter()
    Given -> @cp.spawn.withArgs('npm', ['config', 'set', 'init.author.email', 'tandrewnichols@gmail.com'], { stdio: 'inherit', cwd: '.' }).returns @emitter
    Given -> @context.target = 'config'
    Given -> @context.data =
      cmd: 'config set init.author.email tandrewnichols@gmail.com'
    When ->
      @grunt.registerMultiTask.getCall(0).args[2].apply @context, []
      @emitter.emit 'close', 0
    Then -> expect(@cb).to.have.been.called

  describe 'command with sub-commands with "npm" at the front', ->
    Given -> @emitter = new EventEmitter()
    Given -> @cp.spawn.withArgs('npm', ['config', 'set', 'init.author.email', 'tandrewnichols@gmail.com'], { stdio: 'inherit', cwd: '.' }).returns @emitter
    Given -> @context.target = 'config'
    Given -> @context.data =
      cmd: 'npm config set init.author.email tandrewnichols@gmail.com'
    When ->
      @grunt.registerMultiTask.getCall(0).args[2].apply @context, []
      @emitter.emit 'close', 0
    Then -> expect(@cb).to.have.been.called

  describe 'command with a different name', ->
    Given -> @emitter = new EventEmitter()
    Given -> @cp.spawn.withArgs('npm', ['config', 'set', 'init.author.email', 'tandrewnichols@gmail.com'], { stdio: 'inherit', cwd: '.' }).returns @emitter
    Given -> @context.target = 'banana'
    Given -> @context.data =
      cmd: 'config set init.author.email tandrewnichols@gmail.com'
    When ->
      @grunt.registerMultiTask.getCall(0).args[2].apply @context, []
      @emitter.emit 'close', 0
    Then -> expect(@cb).to.have.been.called

  describe 'dasherizes commands and options', ->
    Given -> @emitter = new EventEmitter()
    Given -> @cp.spawn.withArgs('npm', ['add-user', '--save-dev'], { stdio: 'inherit', cwd: '.' }).returns @emitter
    Given -> @context.target = 'addUser'
    Given -> @context.options.returns
      saveDev: true
    When ->
      @grunt.registerMultiTask.getCall(0).args[2].apply @context, []
      @emitter.emit 'close', 0
    Then -> expect(@cb).to.have.been.called

  describe 'allows raw args as string', ->
    Given -> @emitter = new EventEmitter()
    Given -> @cp.spawn.withArgs('npm', ['install', 'package@0.1.2#foo'], { stdio: 'inherit', cwd: '.' }).returns @emitter
    Given -> @context.target = 'install'
    Given -> @context.data =
      rawArgs: 'package@0.1.2#foo'
    When ->
      @grunt.registerMultiTask.getCall(0).args[2].apply @context, []
      @emitter.emit 'close', 0
    Then -> expect(@cb).to.have.been.called

  describe 'allows raw args as array', ->
    Given -> @emitter = new EventEmitter()
    Given -> @cp.spawn.withArgs('npm', ['install', '---blah^foo hi'], { stdio: 'inherit', cwd: '.' }).returns @emitter
    Given -> @context.target = 'install'
    Given -> @context.data =
      rawArgs: ['---blah^foo hi']
    When ->
      @grunt.registerMultiTask.getCall(0).args[2].apply @context, []
      @emitter.emit 'close', 0
    Then -> expect(@cb).to.have.been.called

  describe 'options have equal sign', ->
    Given -> @emitter = new EventEmitter()
    Given -> @cp.spawn.withArgs('npm', ['set', '--author=nichols'], { stdio: 'inherit', cwd: '.' }).returns @emitter
    Given -> @context.target = 'set'
    Given -> @context.options.returns
      'author=': 'nichols'
    When ->
      @grunt.registerMultiTask.getCall(0).args[2].apply @context, []
      @emitter.emit 'close', 0
    Then -> expect(@cb).to.have.been.called
