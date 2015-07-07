'use strict'

element = null
html    = '<messaging thread-id="123" created-by="123"></messaging>'

describe 'MessagingDirective', ->
  beforeEach inject ($compile, $rootScope) ->
    compiled = $compile html
    element  = compiled $rootScope

    $rootScope.$digest()

  it 'element should have some html', ->
    expect(element.html().length).to.be.ok