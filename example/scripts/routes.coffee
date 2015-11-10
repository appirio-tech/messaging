'use strict'

config = ($stateProvider) ->
  states = {}

  states['messaging'] =
    url         : '/'
    title       : 'Messaging'
    templateUrl : 'views/messaging.html'

  for key, state of states
    $stateProvider.state key, state

config.$inject = ['$stateProvider']

angular.module('example').config(config).run()


