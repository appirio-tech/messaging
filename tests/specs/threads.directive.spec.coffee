'use strict'

element = null
html    = '<threads subscriber-id="123"></threads>'

describe 'ThreadDirective', ->
  beforeEach inject ($compile, $rootScope) ->
    compiled = $compile html
    element  = compiled $rootScope

    $rootScope.$digest()

  it 'element should have some html', ->
    expect(element.html().length).to.be.ok