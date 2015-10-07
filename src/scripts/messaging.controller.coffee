'use strict'

MessagingController = ($scope, MessagingService) ->
  vm             = this
  vm.currentUser = null
  vm.activeThread = null

  vm.activateThread = (thread) ->
    vm.activeThread = thread

    if thread.unreadCount > 0
      params =
        id          : thread.id
        subscriberId: $scope.subscriberId

      for message in thread.messages
        MessagingService.markMessageRead message, params

  onThreadsChange = (threads) ->
    vm.threads = threads.threads

  onMessageChange = (message) ->
    vm.activeThread.messages.push message
    vm.newMessage = ''
    $scope.showLast = 'scroll'

  activate = ->
    vm.newMessage = ''

    $scope.$watch 'subscriberId', ->
      getUserThreads()

    vm.sendMessage = sendMessage

    vm

  getUserThreads =  ->
    if $scope.threadId && $scope.subscriberId
      params =
        subscriberId: $scope.subscriberId

      MessagingService.getThreads params, onThreadsChange

  sendMessage = ->
    if vm.newMessage.length && vm.activeThread
      message =
        threadId   : vm.activeThread.id
        body       : vm.newMessage
        publisherId: $scope.subscriberId
        createdAt  : moment()
        attachments: []

      params =
        threadId: vm.activeThread.id

      MessagingService.postMessage params, message, onMessageChange


  activate()

MessagingController.$inject = ['$scope', 'MessagingService']

angular.module('appirio-tech-ng-messaging').controller 'MessagingController', MessagingController
