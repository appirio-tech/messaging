'use strict'

directive = ->
  link = (scope, element, attrs) ->
    showLast = (newValue, oldValue) ->
      if newValue
        scope.showLast = false # to allow trigger change
        uls            = element.find 'ul'
        messageList    = uls[0]
        $messageList   = angular.element messageList
        bottom         = messageList.scrollHeight

        if newValue == 'scroll'
          $messageList.scrollTopAnimated bottom
        else
          $messageList.scrollTop bottom

    showLast true

    scope.$watch 'showLast', showLast

  restrict    : 'E'
  templateUrl : 'views/messaging.directive.html'
  link        : link
  controller  : 'MessagingController'
  controllerAs: 'vm'
  scope       :
    workId    : '@workId'
    subscriberId: '@subscriberId'

directive.$inject = []

angular.module('appirio-tech-ng-messaging').directive 'messaging', directive
