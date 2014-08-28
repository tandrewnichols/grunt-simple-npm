describe 'npm', ->
  Given -> @grunt =
    registerMultiTask: sinon.stub()
  Given -> @context =
    async: sinon.stub()
  Given -> @cb = sinon.stub()
  Given -> @context.async.returns @cb
  Given -> @cli =
    spawn: sinon.stub()
  Given -> @subject = sandbox '../tasks/npm',
    'simple-cli': @cli

  When -> @subject(@grunt)
  And -> expect(@grunt.registerMultiTask).to.have.been.calledWith 'npm', 'A simple API for using npm via grunt', sinon.match.func
  And -> @grunt.registerMultiTask.getCall(0).args[2].apply @context, []
  Then -> expect(@cli.spawn).to.have.been.calledWith @grunt, @context, 'npm', @cb
