cp = require 'child_process'

describe 'acceptance', ->
  Given (done) ->
    console.log('Starting grunt')
    @grunt = cp.spawn 'grunt', ['npm']
    @grunt.stdout.on 'data', (data) => @output += data.toString()
    @grunt.on 'close', ->
      console.log('Finished grunting')
      done()
  Then ->
    console.log @output
    expect(@output).to.contain('tandrewnichols@gmail.com') and
    expect(@output).to.contain('"grunt-mocha-cov": {') and
    expect(@output).to.contain('"sinon": {')
