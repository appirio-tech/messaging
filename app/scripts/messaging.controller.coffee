'use strict'

MessagingController = ($scope, MessagingService, $stateParams) ->
  vm = this

  onChange = (messages) ->
    vm.messaging = messages

  activate = ->
    vm.messaging  = {}
    vm.newMessage = ''
    vm.threadId   = $scope.threadId

    params =
      workId: $stateParams.id

    MessagingService.getMessages params, onChange

    vm.sendMessage = sendMessage

    vm

  sendMessage = ->
    if vm.newMessage.length
      message =
        workId     : $stateParams.id
        threadId   : $scope.threadId
        createdBy  : $scope.createdBy
        createdAt  : 'a minute ago'
        body       : vm.newMessage
        context    : 'work'
        updatedBy  : ''
        reads      : []
        attachments: []

      vm.messaging.messages.push message

      MessagingService.postMessage message, onChange

      vm.newMessage = ''

      $scope.showLast = 'scroll'

  activate()

MessagingController.$inject = ['$scope', 'MessagingService', '$stateParams']

angular.module('appirio-tech-messaging').controller 'MessagingController', MessagingController
