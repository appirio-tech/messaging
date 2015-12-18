'use strict'

MessagingController = ($scope, $document, $filter, API_URL, MessagesAPIService, ThreadsAPIService, InboxesAPIService, MessageUpdateAPIService) ->
  vm                      = this
  vm.currentUser          = null
  vm.activeThread         = null
  vm.sending              = false
  vm.loadingThreads       = false
  vm.loadingMessages      = false
  vm.showImageSlideViewer = false
  vm.workId               = $scope.workId
  vm.threadId             = $scope.threadId
  vm.subscriberId         = $scope.subscriberId
  vm.uploaderUploading    = null
  vm.uploaderHasErrors    = null
  vm.uploaderHasFiles     = null

  generateProfileUrl = (handle) ->
    "https://www.topcoder.com/members/#{handle}"

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

    vm.sendMessage              = sendMessage
    vm.generateProfileUrl       = generateProfileUrl
    vm.uploaderConfig           = configureUploader(vm.threadId, 'attachment')
    vm.activateImageSlideViewer = activateImageSlideViewer
    vm.onFileChange             = onFileChange

    $scope.$watch 'vm.uploaderUploading', (newValue) ->
      if newValue == true
        vm.disableSend = true
      else
        vm.disableSend = false

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

        if vm.firstUnreadMessageIndex > 0
          angular.element(document).ready ->
            vm.thread.messages[vm.firstUnreadMessageIndex - 1].showNewMessage = true
            scrollElement = angular.element document.getElementById vm.firstUnreadMessageIndex
            $document.scrollToElement scrollElement

        else
          $scope.showLast = 'scroll'

      resource.$promise.catch ->

      resource.$promise.finally ->
        vm.loadingThreads = false

  findFirstUnreadMessageIndex = (messages) ->

    unreadMessages = messages.filter (message) ->
      !message.read

    messages.indexOf(unreadMessages[0])

  isMessageValid = (message, attachments) ->
    valid = true
    if attachments.length > 0
      if vm.uploaderUploading
        valid = false
        vm.disableSend = true
    else
      if !vm.newMessage.length || !vm.thread
        valid = false
        vm.disableSend = true

    valid

  sendMessage = ->
    if isMessageValid vm.newMessage, vm.newAttachments
      message =
        param:
          publisherId: $scope.subscriberId
          threadId   : vm.threadId
          body       : vm.newMessage
          attachments: vm.newAttachments

      vm.disableSend = true

      resource = MessagesAPIService.post message

      resource.$promise.then (response) ->
        vm.uploaderConfig = configureUploader(vm.threadId, 'attachment')
        vm.newMessage = ''
        vm.newAttachments = []
        $scope.showLast = 'scroll'
        getThread()

      resource.$promise.catch (response) ->

      resource.$promise.finally ->
        vm.disableSend = false

  activateImageSlideViewer = (file, files, handle, avatar, date) ->
    vm.showImageSlideViewer = true
    vm.currentImage         = file
    vm.currentImages        = files
    vm.currentHandle        = handle
    vm.currentAvatar        = avatar
    vm.currentTitle         = $filter('timeLapse')(date)

  onFileChange = (file) ->
    vm.currentImage = file

  activate()

MessagingController.$inject = ['$scope', '$document', '$filter', 'API_URL', 'MessagesAPIService', 'ThreadsAPIService', 'InboxesAPIService', 'MessageUpdateAPIService']

angular.module('appirio-tech-ng-messaging').controller 'MessagingController', MessagingController
