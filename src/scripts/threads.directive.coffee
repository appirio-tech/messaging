'use strict'

directive = (MessagingService) ->
  restrict    : 'E'
  templateUrl : 'views/threads.directive.html'
  controller  : 'ThreadsController'
  controllerAs: 'vm'
  scope       :
    subscriberId: '@subscriberId'

directive.$inject = ['MessagingService']

angular.module('appirio-tech-ng-messaging').directive 'threads', directive
