'use strict'

MessagingController = ($scope, MessagingService, UserV3Service) ->
  vm                = this
  vm.currentUser    = null
  vm.uploaderStatus = 'pristine'
  vm.showUpload     = false
  vm.uploaderConfig =
    allowMultiple: true
    fileEndpoint : 'http://localhost:4321'
    queryUrl     : 'http://localhost:4321'
    urlPresigner : 'http://localhost:4321'
    saveParams   :
      workRequestId: "1436372805000-66d14ff5-ec15-410f-8c51-98e18e75f0fe"
      assetType    : "specs"

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
