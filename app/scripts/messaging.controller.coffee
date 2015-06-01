'use strict'

MessagingController = (MessagingService) ->
  vm           = this
  vm.greetings = null

  activate = ->
    vm.greetings = 'Hello World!'

  activate()

  vm

MessagingController.$inject = ['MessagingService']

angular.module('appirio-tech-messaging').controller 'MessagingController', MessagingController

