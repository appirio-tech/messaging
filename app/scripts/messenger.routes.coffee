'use strict'

config = ($stateProvider) ->
  state =
    url         : '/messenger/:workId'
    title       : 'Messenger'
    controller  : 'MessengerController'
    controllerAs: 'vm'
    templateUrl : 'views/messenger.html'

  $stateProvider.state 'messenger', state

config.$inject = ['$stateProvider']

angular.module('appirio-tech-messenger').config(config).run()


