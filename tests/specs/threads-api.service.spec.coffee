'use strict'

srv    = null
threads = null

describe 'ThreadsAPIService', ->
  beforeEach inject (ThreadsAPIService) ->
    srv = ThreadsAPIService

  it 'should have a query method', ->
    expect(srv.query).to.be.isFunction

  describe 'ThreadsAPIService.query', ->
    beforeEach inject ($httpBackend) ->
      params =
        workId: '123'

      srv.query(params).$promise.then (response) ->
        threads = response

      $httpBackend.flush()

    it 'should have at some results', ->
      expect(threads.length).to.be.ok
