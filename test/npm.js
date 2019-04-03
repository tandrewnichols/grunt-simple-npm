const proxyquire = require('proxyquire');
const sinon = require('sinon');

describe('npm', () => {
  let cli, subject;

  beforeEach(() => {
    cli = sinon.stub();
    cli.withArgs('npm').returns('Success!');
    subject = proxyquire('../tasks/npm', {
      'simple-cli': cli
    });
  });

  it('should setup the task', () => {
    subject.should.equal('Success!');
  });
});
