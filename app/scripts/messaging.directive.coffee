'use strict'

directive = (MessagingService) ->
  link = (scope, element, attrs) ->
    messages = element.find 'ul'

	restrict    : 'E'
	templateUrl : 'views/messaging.directive.html'
	link        : link
	controller  : 'MessagingController'
	controllerAs: 'vm'
	scope:
		threadId: '@thread-id'
		createdBy: '@created-by'

directive.$inject = ['MessagingService']

angular.module('appirio-tech-messaging').directive 'messaging', directive
