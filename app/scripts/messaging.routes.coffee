'use strict'

config = ($stateProvider) ->
  states = {}

  states['messaging'] =
    url         : '/messaging/:id'
    title       : 'Messaging'
    controller  : 'MessagingController'
    controllerAs: 'vm'
    templateUrl : 'views/messaging.html'

  states['messaging-widget'] =
    url         : '/messaging-widget/:id'
    title       : 'Messaging Widget'
    controller  : 'MessagingController'
    controllerAs: 'vm'
    templateUrl : 'views/messaging-widget.html'

  for key, state of states
    $stateProvider.state key, state

config.$inject = ['$stateProvider']

angular.module('appirio-tech-messaging').config(config).run()


