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

  timeDifference = (timeDifference) ->
    date = new Date()
    createdTime = new Date(timeDifference)
    vm.messages.timeDiff = date - createdTime

  activate()

  vm

MessagingController.$inject = ['MessagingService', '$stateParams']

angular.module('appirio-tech-messaging').controller 'MessagingController', MessagingController
