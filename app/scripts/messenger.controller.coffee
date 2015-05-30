'use strict'

MessengerController = (MessengerService) ->
  vm           = this
  vm.greetings = null

  activate = ->
    vm.greetings = 'Hello World!'

  activate()

  vm

MessengerController.$inject = ['MessengerService']

angular.module('appirio-tech-messenger').controller 'MessengerController', MessengerController

