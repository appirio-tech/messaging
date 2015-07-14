'use strict'

MessagingExampleController = ($stateParams) ->
  vm = this
  vm.threadId = $stateParams.threadId

MessagingExampleController.$inject = ['$stateParams']

angular.module('appirio-tech-messaging').controller 'MessagingExampleController', MessagingExampleController
