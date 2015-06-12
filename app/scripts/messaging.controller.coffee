'use strict'

MessagingController = (MessagingService, $stateParams) ->
  vm           = this
  vm.messaging = {}

  activate = ->
    params =
      workId: $stateParams.id

    onChange = (messages) ->
      vm.messaging = messages

    MessagingService.getMessages params, onChange

  activate()

  vm

MessagingController.$inject = ['MessagingService', '$stateParams']

angular.module('appirio-tech-messaging').controller 'MessagingController', MessagingController
