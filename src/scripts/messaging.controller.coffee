'use strict'

MessagingController = ($scope, MessagesAPIService, ThreadsAPIService, InboxesAPIService, MessageUpdateAPIService) ->
  vm                 = this
  vm.currentUser     = null
  vm.activeThread    = null
  vm.sending         = false
  vm.loadingThreads  = false
  vm.loadingMessages = false
  vm.workId          = $scope.workId
  vm.threadId        = $scope.threadId
  vm.subscriberId    = $scope.subscriberId

  orderMessagesByCreationDate = (messages) ->
    orderedMessages = messages?.sort (previous, next) ->
      new Date(previous.createdAt) - new Date(next.createdAt)

    orderedMessages

  markMessageRead = (message) ->
    queryParams =
      threadId: vm.threadId
      messageId: message.id

    putParams =
      param:
        readFlag:     true
        subscriberId: $scope.subscriberId

    resource = MessageUpdateAPIService.put queryParams, putParams

    resource.$promise.then (response) ->

    resource.$promise.finally ->

  activate = ->
    vm.newMessage = ''

    $scope.$watch 'subscriberId', ->
      getThread()

    vm.sendMessage = sendMessage

    vm

  getThread =  ->
    if $scope.subscriberId
      params =
        threadId:     vm.threadId

      vm.loadingThreads = true

      resource = InboxesAPIService.get params

      resource.$promise.then (response) ->
        vm.thread = response
        vm.thread.messages = orderMessagesByCreationDate(vm.thread.messages)
        if vm.thread.unreadCount > 0
          lastMessage = vm.thread.messages[vm.thread.messages.length - 1]
          markMessageRead lastMessage

      resource.$promise.catch ->

      resource.$promise.finally ->
        vm.loadingThreads = false

  sendMessage = ->
    if vm.newMessage.length && vm.thread
      message =
        param:
          publisherId: $scope.subscriberId
          threadId   : vm.threadId
          body       : vm.newMessage
          attachments: []

      vm.sending = true

      resource = MessagesAPIService.post message

      resource.$promise.then (response) ->
        vm.newMessage = ''
        $scope.showLast = 'scroll'
        getThread()

      resource.$promise.catch (response) ->

      resource.$promise.finally ->
        vm.sending = false

  activate()

MessagingController.$inject = ['$scope', 'MessagesAPIService', 'ThreadsAPIService', 'InboxesAPIService', 'MessageUpdateAPIService']

angular.module('appirio-tech-ng-messaging').controller 'MessagingController', MessagingController
