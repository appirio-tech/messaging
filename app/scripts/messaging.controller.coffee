'use strict'

MessagingController = ($scope, MessagingService, UserV3Service) ->
  vm = this

  onChange = (messages) ->
    vm.messaging = messages

  activate = ->
    vm.messaging  =
      messages: []

    vm.newMessage = ''
    vm.user       = ''

    UserV3Service.getCurrentUser (response) ->
      vm.user = response?.handle

    params =
      threadId    : $scope.threadId
      subscriberId: vm.user

    MessagingService.getMessages params, onChange

    vm.sendMessage = sendMessage

    vm

  sendMessage = ->
    if vm.newMessage.length
      message =
        threadId   : $scope.threadId
        body       : vm.newMessage
        publisherId: vm.user
        createdAt  : moment()
        attachments: []

      vm.messaging.messages.push message

      MessagingService.postMessage message, onChange

      vm.newMessage = ''

      $scope.showLast = 'scroll'

  activate()

MessagingController.$inject = ['$scope', 'MessagingService', 'UserV3Service']

angular.module('appirio-tech-messaging').controller 'MessagingController', MessagingController
