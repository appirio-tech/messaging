'use strict'

MessagingController = ($scope, MessagingService, $stateParams) ->
  vm            = this
  vm.messaging  = {}
  vm.newMessage = ''

  activate = ->
    params =
      workId: $stateParams.id

    onChange = (messages) ->
      vm.messaging = messages

    MessagingService.getMessages params, onChange

  # sendMessage = ->
  #   params =
  #     workId: $stateParams.id,
  #     body: vm.newMessage,
#       context: 'work',
#       updatedBy:"",
#       reads: [],
#       attachments: 



  activate()

  vm

MessagingController.$inject = ['$scope', 'MessagingService', '$stateParams']

angular.module('appirio-tech-messaging').controller 'MessagingController', MessagingController
