'use strict'

spy = null
vm  = null

describe 'MessagingController', ->
  describe 'activate', ->
    beforeEach inject ($rootScope, $controller) ->
      scope          = $rootScope.$new()
      scope.threadId = '123'
      vm             = $controller 'MessagingController', $scope: scope
      spy            = sinon.spy vm, 'getUserMessages'

    afterEach ->
      spy.restore()

    it 'should have a view model', ->
      expect(vm).to.be.ok

  describe 'sendMessage', ->
    beforeEach inject ($rootScope, $controller, MessagingService) ->
      scope         = $rootScope.$new()
      vm            = $controller 'MessagingController', $scope: scope
      vm.newMessage = 'hello world'
      spy = sinon.spy MessagingService, 'postMessage'
      vm.sendMessage()

    afterEach ->
      spy.restore()

    it 'should be able to send a message', ->
      expect(vm.messaging.messages.length).to.be.ok

    it 'should have called MessagingService.postMessage once', ->
      expect(spy.calledOnce).to.be.ok
