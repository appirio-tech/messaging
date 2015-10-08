'use strict'

MessagingController = ($scope, MessagesAPIService, ThreadsAPIService) ->
  vm                 = this
  vm.currentUser     = null
  vm.activeThread    = null
  vm.sending         = false
  vm.loadingThreads  = false
  vm.loadingMessages = false

  vm.activateThread = (thread) ->
    vm.activeThread = thread

    if thread.unreadCount > 0
      params =
        id          : thread.id
        subscriberId: $scope.subscriberId

      for message in thread.messages
        markMessageRead message, params

  onMessageChange = (message) ->
    vm.activeThread.messages.push message
    vm.newMessage = ''
    $scope.showLast = 'scroll'

  markMessageRead = (message, params) ->
    queryParams =
      id: message.id

    putParams =
      read        : true
      subscriberId: params.subscriberId

    MessagesAPIService.put queryParams, putParams

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
        threadId   : vm.activeThread.id
        body       : vm.newMessage
        publisherId: $scope.subscriberId
        createdAt  : moment()
        attachments: []

      params =
        threadId: vm.activeThread.id

      vm.sending = true

      resource = MessagesAPIService.post message

      resource.$promise.then (response) ->
        onMessageChange message

      resource.$promise.catch (response) ->

      resource.$promise.finally ->
        vm.sending = false

  activate()

MessagingController.$inject = ['$scope', 'MessagesAPIService', 'ThreadsAPIService']

angular.module('appirio-tech-ng-messaging').controller 'MessagingController', MessagingController
