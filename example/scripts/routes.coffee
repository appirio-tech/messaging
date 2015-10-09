'use strict'

config = ($stateProvider) ->
  states = {}

  states['messaging'] =
    url         : '/'
    title       : 'Messaging'
    templateUrl : 'views/messaging.html'

  states['threads'] =
    url         : '/threads'
    title       : 'Threads'
    templateUrl : 'views/threads.html'

  for key, state of states
    $stateProvider.state key, state

config.$inject = ['$stateProvider']

angular.module('example').config(config).run()


