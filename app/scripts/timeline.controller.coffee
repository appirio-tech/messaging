'use strict'

TimelineController = (TimelineService, $stateParams) ->
  vm                  = this
  vm.coPilotHandle    = null
  vm.members          = []
  vm.avatars          = {}
  vm.submissionHandle = null
  vm.feedbackHandle   = null
  vm.feedback2Handle  = null

  mapEvents = [
    ['submitted', 'submitted']
    ['email', 'email-verified']
    ['quote', 'quote-created']
    ['payment', 'payment-accepted']
    ['coPilot', 'copilot-assigned']
    ['launched', 'launched']
    ['joined', 'challenge-member-registered']
    ['submissions', 'challenge-submission']
    ['feedback', 'challenge-feedback-provided']
    ['checkpoint1', 'checkpoint1']
    ['finalists', 'finalists']
    ['finalistsSelected', 'challenge-finalists-selected']
    ['finalDesign', 'final-design']
    ['winner', 'winner']
    ['finalFeedback', 'final-feedback']
    ['completed', 'completed']
  ]

  activate = ->
    for mapEvent in mapEvents
      vm[mapEvent[0]] =
        passed: false
        completed: false

    params =
      workId: $stateParams.workId

    TimelineService.getEvents params, onChange

  onChange = (timeline) ->
    setStatus timeline

    vm.coPilotHandle    = timeline.coPilot
    vm.members          = timeline.members
    vm.avatars          = timeline.avatars
    vm.submissionHandle = timeline.submission
    vm.submissionThumbs = timeline.submissionThumbs
    vm.feedbackHandle   = timeline.feedback
    vm.feedback2Handle  = timeline.feedback2

  setStatus = (timeline) ->
    for mapEvent in mapEvents
      vm[mapEvent[0]].completed = timeline.createdDates?[mapEvent[1]]

    for mapEvent, i in mapEvents
      if mapEvents[i + 1]
        vm[mapEvent[0]].passed = vm[mapEvents[i + 1][0]].completed

  activate()

  vm

TimelineController.$inject = ['TimelineService', '$stateParams']

angular.module('appirio-tech-timeline').controller 'TimelineController', TimelineController

