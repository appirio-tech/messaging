'use strict'

NotificationsController = ($scope, ThreadsAPIService) ->
  vm = this

  onChange = (threadsVm) ->
    vm.unreadCount = threadsVm.unreadCount

  activate = ->
    params =
      subscriberId: $scope.subscriberId
      threadId: $scope.threadId

    ThreadsAPIService.get params, onChange if $scope.subscriberId.length

    vm

  activate()

NotificationsController.$inject = ['$scope', 'ThreadsAPIService']

angular.module('appirio-tech-messaging').controller 'NotificationsController', NotificationsController
