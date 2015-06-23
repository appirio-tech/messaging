'use strict'

srv      = null
threads  = null

describe 'ThreadsAPIService', ->
  beforeEach inject (ThreadsAPIService) ->
    srv = ThreadsAPIService

  it 'should have a query method', ->
    expect(srv.query).to.be.isFunction

  describe 'ThreadsAPIService.query', ->
    beforeEach inject ($httpBackend) ->
      params =
        subscriber: 'subscriber'
        threadId  : 'threadId'

      srv.query(params).$promise.then (response) ->
        threads = response

      $httpBackend.flush()

    it 'threads should be ok', ->
      expect(threads).to.be.ok
