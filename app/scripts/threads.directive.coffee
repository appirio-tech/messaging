'use strict'

directive = (MessagingService) ->
  link = (scope, element, attrs) ->
    messages = element.find 'ul'

  restrict   : 'E'
  templateUrl: 'views/threads.directive.html'
  link       : link
  # scope      :
  #   show: 'thread-id'

directive.$inject = ['MessagingService']

angular.module('appirio-tech-messaging').directive 'threads', directive
