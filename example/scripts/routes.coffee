'use strict'

config = ($stateProvider) ->
  states = {}

  states['messaging'] =
    url         : '/messaging/:id'
    title       : 'Messaging'
    templateUrl : 'views/messaging.html'
    controller  : 'MessagingExampleController'
    controllerAs: 'vm'

  states['messaging-widget'] =
    url         : '/messaging-widget'
    title       : 'Messaging Widget'
    templateUrl : 'views/messaging-widget.html'

  states['threads'] =
    url         : '/threads'
    title       : 'Threads'
    templateUrl : 'views/threads.html'

  for key, state of states
    $stateProvider.state key, state

config.$inject = ['$stateProvider']

angular.module('appirio-tech-messaging').config(config).run()


