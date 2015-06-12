'use strict'

vm = null

describe 'MessagingController', ->
  beforeEach inject ($rootScope, $controller) ->
    scope = $rootScope.$new()
    vm    = $controller 'MessagingController', $scope: scope

  it 'activate method', ->
    expect(vm).to.be.ok
