'use strict'

MessagingController = (MessagingService, $stateParams) ->
  vm          = this
  vm.messages = null

  activate = ->
    vm.greetings = 'Hello World!'

    params =
      workId: $stateParams.id

    MessagingService.retrieveCreatedAt params, displayCreatedAt

  displayCreatedAt = (messages) ->
    vm.messages = messages
    timeDifference vm.messages[0].createdAt

  timeDifference = (timeDifference) ->
    date = new Date()
    createdTime = new Date(timeDifference)
    vm.messages.timeDiff = date - createdTime

  activate()

  vm

MessagingController.$inject = ['MessagingService', '$stateParams']

angular.module('appirio-tech-messaging').controller 'MessagingController', MessagingController
