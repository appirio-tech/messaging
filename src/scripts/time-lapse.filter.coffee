'use strict'

filter = ->
  (createdAt) ->
    moment(createdAt).fromNow()

angular.module('appirio-tech-ng-messaging').filter 'timeLapse', filter
