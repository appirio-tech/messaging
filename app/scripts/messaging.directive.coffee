'use strict'

directive = (MessagingService) ->
  link = ->
    # do something

  restrict   : 'E'
  templateUrl: 'views/messaging.directive.html'
  link       : link
  # scope      :
  #   show: 'thread-id'

directive.$inject = ['MessagingService']

angular.module('appirio-tech-messaging').directive 'messaging', directive
