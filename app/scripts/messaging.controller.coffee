'use strict'

MessagingController = ($scope, MessagingService) ->
  vm = this

  onChange = (messages) ->
    vm.messaging = messages

  activate = ->
    vm.messaging  = {}
    vm.newMessage = ''

    params =
      threadId    : $scope.threadId
      subscriberId: $scope.user

    MessagingService.getMessages params, onChange

    vm.sendMessage = sendMessage

    vm

  sendMessage = ->
    if vm.newMessage.length
      message =
        threadId   : $scope.threadId
        body       : vm.newMessage
        publisherId: $scope.user
        createdAt  : moment()
        attachments: []

      vm.messaging.messages.push message

      MessagingService.postMessage message, onChange

      vm.newMessage = ''

      $scope.showLast = 'scroll'

  activate()

MessagingController.$inject = ['$scope', 'MessagingService']

angular.module('appirio-tech-messaging').controller 'MessagingController', MessagingController
