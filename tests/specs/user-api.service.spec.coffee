'use strict'

srv  = null
user = null

describe 'UserAPIService', ->
  beforeEach inject (UserAPIService) ->
    srv = UserAPIService

  describe 'UserAPIService.get', ->
    beforeEach inject ($httpBackend) ->
      params =
        handle: 'abc'

      srv.get(params).$promise.then (response) ->
        user = response

      $httpBackend.flush()

    it 'should have a handle of CardioBoy', ->
      expect(user.handle).to.be.equal 'CardioBoy'
