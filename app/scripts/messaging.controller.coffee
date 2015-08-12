'use strict'

MessagingController = ($scope, MessagingService) ->
  vm              = this
  vm.currentUser  = null
  vm.uploadStatus = 'pristine'
  vm.showUpload   = false

  onChange = (messages) ->
    vm.messaging = messages

  activate = ->
    vm.messaging  =
      messages: []

    vm.newMessage = ''

    $scope.$watch 'threadId', ->
      getUserMessages()

    $scope.$watch 'subscriberId', ->
      getUserMessages()

    vm.sendMessage = sendMessage

    vm

  getUserMessages =  ->
    if $scope.threadId && $scope.subscriberId
      params =
        id          : $scope.threadId
        subscriberId: $scope.subscriberId

      MessagingService.getMessages params, onChange

  sendMessage = ->
    if vm.newMessage.length
      message =
        threadId   : $scope.threadId
        body       : vm.newMessage
        publisherId: $scope.subscriberId
        createdAt  : moment()
        attachments: []

      vm.messaging.messages.push message

      MessagingService.postMessage message, onChange

      vm.newMessage = ''

      $scope.showLast = 'scroll'

  activate()

MessagingController.$inject = ['$scope', 'MessagingService']

angular.module('appirio-tech-messaging').controller 'MessagingController', MessagingController
