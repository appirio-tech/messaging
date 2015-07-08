'use strict'

MessagingController = ($scope, MessagingService) ->
  vm             = this
  vm.currentUser = null

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
    $scope.$watch 'subscriberId', ->
      vm.currentUser = $scope.subscriberId if $scope.subscriberId.length

      params =
        id          : threadId
        subscriberId: vm.currentUser

      MessagingService.getMessages params, onChange

  sendMessage = ->
    if vm.newMessage.length
      message =
        threadId   : $scope.threadId
        body       : vm.newMessage
        publisherId: vm.currentUser
        createdAt  : moment()
        attachments: []

      vm.messaging.messages.push message

      MessagingService.postMessage message, onChange

      vm.newMessage = ''

      $scope.showLast = 'scroll'

  activate()

MessagingController.$inject = ['$scope', 'MessagingService']

angular.module('appirio-tech-messaging').controller 'MessagingController', MessagingController
