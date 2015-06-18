'use strict'

vm  = null
spy = null

describe 'MessagingController', ->
  describe 'activate', ->
    beforeEach inject ($rootScope, $controller, MessagingService) ->
      scope = $rootScope.$new()
      spy   = sinon.spy MessagingService, 'getMessages'
      vm    = $controller 'MessagingController', $scope: scope

    afterEach ->
      spy.restore()

    it 'should have a view model', ->
      expect(vm).to.be.ok

    it 'should have called MessagingService.getMessages once', ->
      expect(spy.calledOnce).to.be.ok

  describe 'sendMessage', ->
    beforeEach inject ($rootScope, $controller, MessagingService) ->
      scope              = $rootScope.$new()
      vm                 = $controller 'MessagingController', $scope: scope
      vm.newMessage      = 'hello world'
      vm.sendMessage()

    it 'should be able to send a message', ->
      expect(vm.messaging.messages.length).to.be.ok

