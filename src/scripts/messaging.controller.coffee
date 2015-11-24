'use strict'

MessagingController = ($scope, $document, API_URL, MessagesAPIService, ThreadsAPIService, InboxesAPIService, MessageUpdateAPIService) ->
  vm                 = this
  vm.currentUser     = null
  vm.activeThread    = null
  vm.sending         = false
  vm.loadingThreads  = false
  vm.loadingMessages = false
  vm.workId          = $scope.workId
  vm.threadId        = $scope.threadId
  vm.subscriberId    = $scope.subscriberId
  vm.uploaderUploading = null
  vm.uploaderHasErrors = null
  vm.uploaderHasFiles = null

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
    vm.newAttachments = []

    $scope.$watch 'subscriberId', ->
      getThread()

    vm.sendMessage = sendMessage
    vm.uploaderConfig = configureUploader(vm.threadId, 'attachment')

    $scope.$watch 'vm.newAttachments', (newValue) ->
      console.log('attachments', newValue)

    vm

  configureUploader = (threadId, assetType) ->
    domain = API_URL
    category = 'message'

    uploaderConfig =
      name: "#{assetType}-uploader-#{threadId}-#{Date.now()}"
      allowMultiple: true
      allowCaptions: false
      onUploadSuccess: (data) ->
        vm.newAttachments.push
          ownerId:  $scope.subscriberId
          id:       data.id
          fileName: data.name
          filePath: data.path
          fileType: data.type
          fileSize: data.size
      presign:
        url: domain + '/v3/attachments/uploadurl'
        params:
          id: threadId
          assetType: assetType
          category: category
      removeRecord:
        url: domain + '/v3/attachments/:fileId'
        params:
          filter: 'category=' + category

    uploaderConfig

  getThread =  ->
    if $scope.subscriberId
      params =
        threadId:     vm.threadId

      vm.loadingThreads = true

      resource = InboxesAPIService.get params

      resource.$promise.then (response) ->
        vm.thread = response
        vm.thread.messages = orderMessagesByCreationDate(vm.thread.messages)

        vm.firstUnreadMessageIndex = findFirstUnreadMessageIndex vm.thread.messages

        if vm.thread.unreadCount > 0
          lastMessage = vm.thread.messages[vm.thread.messages.length - 1]
          markMessageRead lastMessage

        if vm.firstUnreadMessageIndex >= 0
          angular.element(document).ready ->
            messageList = angular.element document.getElementById 'messaging-message-list'
            scrollElement = angular.element document.getElementById vm.firstUnreadMessageIndex
            messageList.scrollToElement scrollElement

      resource.$promise.catch ->

      resource.$promise.finally ->
        vm.loadingThreads = false

  findFirstUnreadMessageIndex = (messages) ->

    unreadMessages = messages.filter (message) ->
      !message.read

    messages.indexOf(unreadMessages[0])


  sendMessage = ->
    if vm.newMessage.length && vm.thread
      message =
        param:
          publisherId: $scope.subscriberId
          threadId   : vm.threadId
          body       : vm.newMessage
          attachments: vm.newAttachments

      vm.sending = true

      resource = MessagesAPIService.post message

      resource.$promise.then (response) ->
        vm.uploaderConfig = configureUploader(vm.threadId, 'attachment')
        vm.newMessage = ''
        vm.newAttachments = []
        $scope.showLast = 'scroll'
        getThread()

      resource.$promise.catch (response) ->

      resource.$promise.finally ->
        vm.sending = false

  activate()

MessagingController.$inject = ['$scope', '$document', 'API_URL', 'MessagesAPIService', 'ThreadsAPIService', 'InboxesAPIService', 'MessageUpdateAPIService']

angular.module('appirio-tech-ng-messaging').controller 'MessagingController', MessagingController
