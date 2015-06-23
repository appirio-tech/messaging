'use strict'

MessagingDemoController = ($stateParams) ->
  vm = this
  vm.threadId = $stateParams.threadId

MessagingDemoController.$inject = ['$stateParams']

angular.module('appirio-tech-messaging').controller 'MessagingDemoController', MessagingDemoController
