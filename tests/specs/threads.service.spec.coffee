'use strict'

srv = null
params = null
threads = null

describe 'ThreadsService', ->
  beforeEach inject (ThreadsService) ->
    srv = ThreadsService

  it 'should have a get method', ->
    expect(srv.get).to.be.ok

  describe 'get method', ->
    beforeEach inject ($httpBackend, ThreadsAPIService) ->
      params =
        subscriberId: '123'

      srv.get params, (response) ->
        threads = response

      $httpBackend.flush()

    it 'should have returned some threads', ->
      expect(threads).to.be.ok