'use strict'

vm = null
serviceSpy = null

describe 'TimelineController', ->
  beforeEach inject ($rootScope, $controller, $httpBackend, $stateParams, TimelineService) ->
    stashIt $stateParams, 'workId'

    scope               = $rootScope.$new()
    $stateParams.workId = 'abc'
    serviceSpy          = sinon.spy TimelineService, 'getEvents'
    vm                  = $controller 'TimelineController', $scope: scope

    $httpBackend.flush()

  afterEach inject ($stateParams) ->
    serviceSpy.restore()
    unstashIt $stateParams, 'workId'

  it 'should have called TimelineService with `workId: "abc"', ->
    serviceSpy.calledWith workId: 'abc'

  it 'should have vm.submissionHandle of `Batman9000`', ->
    expect(vm.submissionHandle).to.be.equal 'Batman9000'

  it 'should have vm.feedbackHandle of `Batman9000`', ->
    expect(vm.feedbackHandle).to.be.equal 'Batman9000'

  it 'should have vm.feedback2Handle of `Batman9000`', ->
    expect(vm.feedback2Handle).to.be.equal 'Batman9000'

  it 'should have vm.email completed and passed', ->
    expect(vm.email.completed).to.be.ok
    expect(vm.email.passed).to.be.ok

  it 'should have a coPilotHandle of `Batman9000`', ->
    expect(vm.coPilotHandle).to.be.equal 'Batman9000'

  it 'should have a first member of `Batman9000`', ->
    expect(vm.members[0].handle).to.be.equal 'Batman9000'

  it 'should have a avatar url `http://www.topcoder.com/i/m/cardiboy_big.jpg`', ->
    expect(vm.avatars['Batman9000']).to.be.equal 'http://www.topcoder.com/i/m/cardiboy_big.jpg'

  it 'should have a submission thumb url', ->
    expect(vm.submissionThumbs[0]).to.be.equal 'https://studio.topcoder.com/?module=DownloadSubmission&sbmid=200703&sbt=tiny'
