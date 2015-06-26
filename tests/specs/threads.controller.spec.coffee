'use strict'

vm  = null
spy = null


describe 'ThreadsController', ->
  describe 'activate', ->
    beforeEach inject ($rootScope, $controller, ThreadsService) ->
      scope = $rootScope.$new()
      vm    = $controller 'MessagingController', $scope: scope
      spy   = sinon.spy ThreadsService, 'get'

    afterEach ->
      spy.restore()

    it 'should have a view model', ->
      expect(vm).to.be.ok
