cp = require 'child_process'

describe 'acceptance', ->
  Given (done) ->
    @grunt = cp.spawn 'grunt', ['npm']
    @grunt.stdout.on 'data', (data) => @output += data.toString()
    @grunt.on 'close', ->
      done()
  Then ->
    console.log @output
    expect(@output).to.contain('tandrewnichols@gmail.com') and
    expect(@output).to.contain('"grunt-mocha-cov": {') and
    expect(@output).to.contain('"sinon": {')
