'use strict'

ThreadsController = ($scope, $state, InboxesProjectAPIService) ->
  vm = this
  vm.loadingThreads = false
  vm.userType = $scope.userType || 'customer'

  if vm.userType == 'customer'
    vm.threadHref = 'messaging'
  else
    vm.threadHref = 'copilot-messaging'

  removeBlanksAndOrder = (threads) ->
    noBlanks = []
    if threads
      for thread in threads
        noBlanks.push thread if thread?.messages?.length

      noBlanks

      orderedThreads = noBlanks?.sort (previous, next) ->
        new Date(next.messages[next.messages.length - 1].createdAt) - new Date(previous.messages[previous.messages.length - 1].createdAt)

      orderedThreads

  getUserThreads =  ->

    vm.loadingThreads = true

    resource = InboxesProjectAPIService.get()

    resource.$promise.then (response) ->
      vm.threads          = removeBlanksAndOrder response?.threads
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
