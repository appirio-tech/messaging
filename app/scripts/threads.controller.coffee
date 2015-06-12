'use strict'

ThreadsController = ($scope, ThreadsService, $stateParams) ->
  vm = this

  onChange = (threadsVm) ->
    vm.threads          = threadsVm.threads
    vm.totalUnreadCount = threadsVm.totalUnreadCount
    vm.avatars          = threadsVm.avatars

  activate = ->
    ThreadsService.get $scope.subscriber, onChange

    vm

  activate()

ThreadsController.$inject = ['$scope', 'ThreadsService', '$stateParams']

angular.module('appirio-tech-messaging').controller 'ThreadsController', ThreadsController
