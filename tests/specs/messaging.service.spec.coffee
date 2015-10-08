'use strict'

srv     = null
spy     = null
message = null
avatar  = null

describe 'MessagingService', ->
  beforeEach inject (MessagingService) ->
    srv = MessagingService

  it 'should have a getThreads method', ->
    expect(srv.getThreads).to.be.ok

  it 'should have a postMessage method', ->
    expect(srv.postMessage).to.be.ok

  describe 'getThreads method', ->
    beforeEach inject ($httpBackend) ->
      params =
        id          : '123'
        subscriberId: 'Batman'

      srv.getThreads params, (response) ->
        message = response

      $httpBackend.flush()

    it 'should have returned some message', ->
      expect(message).to.be.ok
