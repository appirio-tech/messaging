'use strict'

ThreadsController = ($scope, $state, InboxesProjectAPIService) ->
  vm = this
  vm.loadingThreads = false
  vm.userType = $scope.userType || 'customer'

  if vm.userType == 'customer'
    vm.threadHref = 'messaging'
  else
    vm.threadHref = 'copilot-messaging'

  removeBlanks = (threads) ->
    noBlanks = []
    if threads
      for thread in threads
        noBlanks.push thread if thread?.messages?.length

      noBlanks

  getUserThreads =  ->

    vm.loadingThreads = true

    resource = InboxesProjectAPIService.get()

    resource.$promise.then (response) ->
      vm.threads          = removeBlanks response?.threads
      vm.totalUnreadCount = response?.totalUnreadCount

    resource.$promise.catch ->

    resource.$promise.finally ->
      vm.loadingThreads = false

  activate = ->
    $scope.$watch 'subscriberId', ->
      getUserThreads()

    vm

  activate()

ThreadsController.$inject = ['$scope', '$state', 'InboxesProjectAPIService']

angular.module('appirio-tech-ng-messaging').controller 'ThreadsController', ThreadsController
