'use strict'

spy = null
vm  = null

describe 'MessagingController', ->
  describe 'activate', ->
    beforeEach inject ($rootScope, $controller, ThreadsAPIService) ->
      scope          = $rootScope.$new()
      scope.threadId = '123'
      scope.subscriberId = 'abc'
      spy = sinon.spy ThreadsAPIService, 'get'
      vm             = $controller 'MessagingController', $scope: scope
      vm.threadId = '123'
      $rootScope.$apply()

    afterEach ->
      spy.restore()

    it 'should have a view model', ->
      expect(vm).to.be.ok

    it 'should have called ThreadsAPIService', ->
      expect(spy.called).to.be.ok


  describe 'sendMessage', ->
    beforeEach inject ($rootScope, $controller, MessagesAPIService) ->
      scope         = $rootScope.$new()
      vm            = $controller 'MessagingController', $scope: scope
      vm.newMessage = 'hello world'
      vm.thread = {}
      spy           = sinon.spy MessagesAPIService, 'post'
      vm.newMessage = 'abc'
      vm.sendMessage()

    afterEach ->
      spy.restore()

    it 'should have called MessagesAPIService.post once', ->
      expect(spy.called).to.be.ok
