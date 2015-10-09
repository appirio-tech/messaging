'use strict'

spy = null
vm  = null

describe 'MessagingController', ->
  describe 'activate', ->
    beforeEach inject ($rootScope, $controller) ->
      scope          = $rootScope.$new()
      scope.threadId = '123'
      vm             = $controller 'MessagingController', $scope: scope

    it 'should have a view model', ->
      expect(vm).to.be.ok

  describe 'sendMessage', ->
    beforeEach inject ($rootScope, $controller, MessagesAPIService) ->
      scope         = $rootScope.$new()
      vm            = $controller 'MessagingController', $scope: scope
      vm.newMessage = 'hello world'
      spy           = sinon.spy MessagesAPIService, 'post'
      vm.activateThread
        messages: []
      vm.newMessage = 'abc'
      vm.sendMessage()

    afterEach ->
      spy.restore()

    it 'should activate a thread', ->
      vm.activateThread
        messages: ['abc']
      expect(vm.activeThread).to.eql
        messages: ['abc']

    it 'should have called MessagesAPIService.post once', ->
      expect(spy.calledOnce).to.be.ok
