'use strict'

filter = ->
  (createdAt) ->
    moment(createdAt).fromNow()

angular.module('appirio-tech-messaging').filter 'timeLapse', filter
