'use strict'

MessagingController = ($scope, MessagingService, UserV3Service) ->
  vm = this

  onChange = (messages) ->
    vm.messaging = messages

  activate = ->
    vm.messaging  =
      messages: []

    vm.newMessage = ''

    $scope.$watch 'threadId', ->
      getUserMessages $scope.threadId if $scope.threadId.length

    vm.sendMessage = sendMessage

    vm

  getUserMessages = (threadId) ->
    UserV3Service.getCurrentUser (response) ->
      params =
        id          : threadId
        subscriberId: response?.handle

      MessagingService.getMessages params, onChange


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
