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
