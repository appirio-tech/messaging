'use strict'

MessagingController = ($scope, MessagesAPIService, ThreadsAPIService, MessageUpdateAPIService) ->
  vm                 = this
  vm.currentUser     = null
  vm.activeThread    = null
  vm.sending         = false
  vm.loadingThreads  = false
  vm.loadingMessages = false
  vm.workId          = $scope.workId

  vm.activateThread = (thread) ->
    vm.activeThread = thread
    thread.messages = orderMessagesByCreationDate(thread.messages)

    if thread.unreadCount > 0
      params =
        subscriberId: $scope.subscriberId

      for message in thread.messages
        markMessageRead message, params

  orderMessagesByCreationDate = (messages) ->
    orderedMessages = messages.sort (previous, next) ->
      new Date(previous.createdAt) - new Date(next.createdAt)

    orderedMessages

  onMessageChange = (message) ->
    vm.activeThread.messages.push message
    vm.newMessage = ''
    $scope.showLast = 'scroll'

  markMessageRead = (message, params) ->
    queryParams =
      workId: vm.workId
      messageId: message.id

    putParams =
      param:
        readFlag:     true
        subscriberId: params.subscriberId

    MessageUpdateAPIService.put queryParams, putParams

  activate = ->
    vm.newMessage = ''

    $scope.$watch 'subscriberId', ->
      getUserThreads()

    vm.sendMessage = sendMessage

    vm

  getUserThreads =  ->
    if $scope.subscriberId
      params =
        subscriberId: $scope.subscriberId

      vm.loadingThreads = true

      resource = ThreadsAPIService.get params

      resource.$promise.then (response) ->
        vm.threads = response.threads

      resource.$promise.catch ->

      resource.$promise.finally ->
        vm.loadingThreads = false

  sendMessage = ->
    if vm.newMessage.length && vm.activeThread
      message =
        param:
          publisherId: $scope.subscriberId
          threadId   : vm.activeThread.id
          body       : vm.newMessage
          attachments: []

      params =
        threadId: vm.activeThread.id

      vm.sending = true

      resource = MessagesAPIService.post message

      resource.$promise.then (response) ->
        onMessageChange message.param

      resource.$promise.catch (response) ->

      resource.$promise.finally ->
        vm.sending = false

  activate()

MessagingController.$inject = ['$scope', 'MessagesAPIService', 'ThreadsAPIService', 'MessageUpdateAPIService']

angular.module('appirio-tech-ng-messaging').controller 'MessagingController', MessagingController
