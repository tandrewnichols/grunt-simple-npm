describe 'npm', ->
  Given -> @cli = sinon.stub()
  Given -> @cli.withArgs('npm').returns 'Success!'
  When -> @subject = sandbox '../tasks/npm',
    'simple-cli': @cli
  Then -> expect(@subject).to.equal 'Success!'
