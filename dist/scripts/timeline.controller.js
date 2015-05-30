(function() {
  'use strict';
  var TimelineController;

  TimelineController = function(TimelineService, $stateParams) {
    var activate, mapEvents, onChange, setStatus, vm;
    vm = this;
    vm.coPilotHandle = null;
    vm.members = [];
    vm.avatars = {};
    vm.submissionHandle = null;
    vm.feedbackHandle = null;
    vm.feedback2Handle = null;
    mapEvents = [['submitted', 'submitted'], ['email', 'email-verified'], ['quote', 'quote-created'], ['payment', 'payment-accepted'], ['coPilot', 'copilot-assigned'], ['launched', 'launched'], ['joined', 'challenge-member-registered'], ['submissions', 'challenge-submission'], ['feedback', 'challenge-feedback-provided'], ['checkpoint1', 'checkpoint1'], ['finalists', 'finalists'], ['finalistsSelected', 'challenge-finalists-selected'], ['finalDesign', 'final-design'], ['winner', 'winner'], ['finalFeedback', 'final-feedback'], ['completed', 'completed']];
    activate = function() {
      var j, len, mapEvent, params;
      for (j = 0, len = mapEvents.length; j < len; j++) {
        mapEvent = mapEvents[j];
        vm[mapEvent[0]] = {
          passed: false,
          completed: false
        };
      }
      params = {
        workId: $stateParams.workId
      };
      return TimelineService.getEvents(params, onChange);
    };
    onChange = function(timeline) {
      setStatus(timeline);
      vm.coPilotHandle = timeline.coPilot;
      vm.members = timeline.members;
      vm.avatars = timeline.avatars;
      vm.submissionHandle = timeline.submission;
      vm.submissionThumbs = timeline.submissionThumbs;
      vm.feedbackHandle = timeline.feedback;
      return vm.feedback2Handle = timeline.feedback2;
    };
    setStatus = function(timeline) {
      var i, j, k, len, len1, mapEvent, ref, results;
      for (j = 0, len = mapEvents.length; j < len; j++) {
        mapEvent = mapEvents[j];
        vm[mapEvent[0]].completed = (ref = timeline.createdDates) != null ? ref[mapEvent[1]] : void 0;
      }
      results = [];
      for (i = k = 0, len1 = mapEvents.length; k < len1; i = ++k) {
        mapEvent = mapEvents[i];
        if (mapEvents[i + 1]) {
          results.push(vm[mapEvent[0]].passed = vm[mapEvents[i + 1][0]].completed);
        } else {
          results.push(void 0);
        }
      }
      return results;
    };
    activate();
    return vm;
  };

  TimelineController.$inject = ['TimelineService', '$stateParams'];

  angular.module('appirio-tech-timeline').controller('TimelineController', TimelineController);

}).call(this);
