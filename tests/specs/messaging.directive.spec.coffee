'use strict'

element = null
html    = '<messaging thread-id="123"></messaging>'

describe 'MessagingController', ->
  beforeEach inject ($compile, $rootScope) ->
    compiled = $compile html
    element  = compiled $rootScope

    $rootScope.$digest()

  it 'element should have messaging text', ->
    matched = element.html().match 'Messaging'
    expect(matched).to.be.ok