'use strict'

srv      = null
messages = {}

describe 'MessagesAPIService', ->
  beforeEach inject (MessagesAPIService) ->
    srv = MessagesAPIService

  it 'should have a save method', ->
    expect(srv.save).to.be.ok

  describe 'MessagesAPIService.save', ->
    beforeEach inject ($httpBackend) ->
      params =
        threadId   : 'abc'
        publisherId: 'Batman'
        body       : 'abc'
        attachments: []

      srv.save params, (response) ->
        messages = response

      $httpBackend.flush()

    it 'should have at some results', ->
      expect(messages).to.be.ok
