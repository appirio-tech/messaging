'use strict'

directive = (MessagingService) ->
  link = (scope, element, attrs) ->
    # Nothing to do yet

  restrict    : 'E'
  templateUrl : 'views/messaging.directive.html'
  link        : link
  controller  : 'MessagingController'
  controllerAs: 'vm'
  scope:
    threadId : '@threadId'
    createdBy: '@createdBy'

directive.$inject = ['MessagingService']

angular.module('appirio-tech-messaging').directive 'messaging', directive
