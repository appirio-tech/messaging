'use strict'

vm = null

describe 'MessagingController', ->
  beforeEach inject ($rootScope, $controller) ->
    scope = $rootScope.$new()
    vm    = $controller 'MessagingController', $scope: scope

  it 'should be `Hello World!`', ->
    expect(vm.greetings).to.be.equal 'Hello World!'