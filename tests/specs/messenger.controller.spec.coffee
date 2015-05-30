'use strict'

vm = null

describe 'MessengerController', ->
  beforeEach inject ($rootScope, $controller) ->
    scope = $rootScope.$new()
    vm    = $controller 'MessengerController', $scope: scope

  it 'should be `Hello World!`', ->
    expect(vm.greetings).to.be.equal 'Hello World!'