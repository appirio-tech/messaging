'use strict'

directive = ->
  restrict    : 'E'
  controller  : 'NotificationsController as vm'
  templateUrl : 'views/notifications.directive.html'
  scope       :
    threadId    : '@threadId'
    subscriberId: '@subscriberId'

angular.module('appirio-tech-messaging').directive 'notifications', directive
