'use strict'

srv    = null
events = null

describe 'MessagesAPIService', ->
  beforeEach inject (MessagesAPIService) ->
    srv = MessagesAPIService

  it 'should have a query method', ->
    expect(srv.query).to.be.isFunction

  describe 'MessagesAPIService.query', ->
    beforeEach inject ($httpBackend) ->
      params =
        workId: '123'

      srv.query(params).$promise.then (response) ->
        events = response

      $httpBackend.flush()

    it 'should have at some results', ->
      expect(events.length).to.be.ok
