'use strict'

directive = (MessagingService) ->
  restrict    : 'E'
  templateUrl : 'views/threads.directive.html'
  controller  : 'ThreadsController'
  controllerAs: 'vm'

directive.$inject = ['MessagingService']

angular.module('appirio-tech-messaging').directive 'threads', directive
