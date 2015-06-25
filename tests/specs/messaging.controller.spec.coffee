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

    # it 'should have called getUserMessages once', ->
    #   expect(spy.called).to.be.ok

#  only need to test the response and/or MessagingService.getMessages
  # describe 'getUserMessages', ->
  #   beforeEach inject ($rootScope, $controller, MessagingService, $httpBackend) ->
  #     scope          = $rootScope.$new()
  #     scope.threadId = '123'
  #     spy            = sinon.spy MessagingService, 'getMessages'
  #     vm             = $controller 'MessagingController', $scope: scope
  #     vm.getUserMessages scope.threadId

  #   afterEach ->
  #     spy.restore()

  #   it 'should have a view model', ->
  #     expect(vm).to.be.ok

  #   it 'should have called MessagingService.getMessages once', ->
  #     expect(spy.calledOnce).to.be.ok

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


# describe 'MessagingController', ->
#   beforeEach inject (MessagingController, $scope, $controller, $httpBackend) ->
#     # vm = MessagingController
#     vm = $controller 'MessagingController', $scope: scope 

#   it 'should have a view model', ->
#     expect(vm).to.be.ok

# # assert on 'activate'?

#   it 'should have a getUserMessages method', ->
#     expect(vm.getUserMessages).to.be.ok

#   it 'should have a sendMessage method', ->
#     expect(vm.sendMessage).to.be.ok

#   describe 'activate', ->
#     beforeEach ->
#       spy = sinon.spy vm, 'getUserMessages'

#     afterEach ->
#       spy.restore()

#     it 'should call getUserMessages', ->
#       expect(spy.calledOnce).to.be.ok

#   describe 'getUserMessages', ->
#     beforeEach inject ($rootScope, MessagingService) ->
#       # scope = $rootScope.$new()
#       spy = sinon.spy MessagingService, 'getMessages'

#     afterEach ->
#       spy.restore()

#     it 'should have called MessagingService.getMessages once', ->
#       expect(spy.calledOnce).to.be.ok

#   describe 'sendMessage', ->
#     beforeEach inject ($rootScope, $scope, MessagingService) ->
#       # double check what Alex did here
#       scope              = $rootScope.$new()
#       vm.newMessage      = 'hello world'
#       vm.sendMessage()

#     it 'should be able to send a message', ->
#       expect(vm.messaging.messages.length).to.be.ok
