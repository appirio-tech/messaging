'use strict'


srv     = null
spy     = null
message = null
avatar  = null
spy = null

describe 'MessagingService', ->
  beforeEach inject (MessagingService) ->
    srv = MessagingService

  it 'should have a getMessages method', ->
    expect(srv.getMessages).to.be.ok

  # it 'should have a markMessageRead method', ->
  #   expect(srv.markMessageRead).to.be.ok

  # it 'should have a buildAvatar method', ->
  #   expect(srv.buildAvatar).to.be.ok

  it 'should have a postMessage method', ->
    expect(srv.postMessage).to.be.ok

  describe 'getMessages method', ->
    beforeEach inject ($httpBackend) ->
      # spy = sinon.spy srv, 'buildAvatar'
      params = {
        id          : '123'
        subscriberId: 'Batman'
      }

      srv.getMessages params, (response) ->
        message = response

      $httpBackend.flush()

    it 'should have returned some message', ->
      expect(message).to.be.ok

    # it 'should have called buildAvatar', ->
    #   expect(spy.called).to.be.ok

