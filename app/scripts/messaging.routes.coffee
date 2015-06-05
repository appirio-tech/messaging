'use strict'

config = ($stateProvider) ->
  state =
    url         : '/messaging/:id'
    title       : 'Messaging'
    controller  : 'MessagingController'
    controllerAs: 'vm'
    templateUrl : 'views/messaging.html'

  $stateProvider.state 'messaging', state

config.$inject = ['$stateProvider']

angular.module('appirio-tech-messaging').config(config).run()


