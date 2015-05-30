(function() {
  'use strict';
  var eventTypes, srv;

  eventTypes = ['copilot-assigned', 'created', 'submitted', 'quote-created', 'email-verified', 'payment-accepted', 'challenge-feedback-provided', 'challenge-submission', 'challenge-member-registered', 'challenge-finalists-selected', 'state-change', 'launched', 'checkpoint1', 'finalists', 'final-design', 'winner', 'final-feedback', 'completed'];

  srv = function(TimelineAPIService, UserAPIService, AVATAR_URL, SUBMISSION_URL) {
    var buildAvatar, buildTimeline, findAllEvents, findEvent, getCreatedAt, getEvents, getHandle, getMembers, getSubmissionThumbs;
    buildTimeline = function(events, onChange) {
      var coPilot, createdDates, eventType, feedback, feedback2, i, j, len, len1, member, members, submission, submissionThumbs, timeline;
      createdDates = {};
      coPilot = getHandle(events, 'copilot-assigned');
      submission = getHandle(events, 'challenge-submission');
      feedback = getHandle(events, 'challenge-feedback-provided');
      feedback2 = getHandle(events, 'final-feedback');
      members = getMembers(events);
      submissionThumbs = getSubmissionThumbs(events);
      for (i = 0, len = eventTypes.length; i < len; i++) {
        eventType = eventTypes[i];
        createdDates[eventType] = getCreatedAt(eventType, events);
      }
      timeline = {
        events: events,
        createdDates: createdDates,
        coPilot: coPilot,
        members: members,
        avatars: {},
        submission: submission,
        submissionThumbs: submissionThumbs,
        feedback: feedback,
        feedback2: feedback2
      };
      if (coPilot) {
        buildAvatar(timeline, coPilot, onChange);
      }
      for (j = 0, len1 = members.length; j < len1; j++) {
        member = members[j];
        buildAvatar(timeline, member.handle, onChange);
      }
      return typeof onChange === "function" ? onChange(timeline) : void 0;
    };
    buildAvatar = function(timeline, handle, onChange) {
      var user, userParams;
      if (!timeline.avatars[handle]) {
        userParams = {
          handle: handle
        };
        user = UserAPIService.get(userParams);
        user.$promise.then(function(response) {
          timeline.avatars[handle] = AVATAR_URL + (response != null ? response.photoLink : void 0);
          return typeof onChange === "function" ? onChange(timeline) : void 0;
        });
        user.$promise["catch"](function() {});
        return user.$promise["finally"](function() {});
      }
    };
    getEvents = function(params, onChange) {
      var queryParams, resource;
      queryParams = {
        filter: 'sourceObjectId=' + params.workId
      };
      resource = TimelineAPIService.query(queryParams);
      resource.$promise.then(function(response) {
        return buildTimeline(response, onChange);
      });
      resource.$promise["catch"](function() {});
      return resource.$promise["finally"](function() {});
    };
    getSubmissionThumbs = function(events) {
      var i, len, ref, submissionEvent, submissionEvents, thumbUrl, thumbs;
      thumbs = [];
      submissionEvents = findAllEvents('challenge-submission', events);
      for (i = 0, len = submissionEvents.length; i < len; i++) {
        submissionEvent = submissionEvents[i];
        thumbUrl = SUBMISSION_URL + '/?module=DownloadSubmission&sbmid=';
        thumbUrl += (submissionEvent != null ? (ref = submissionEvent.sourceObjectContent) != null ? ref.submissionId : void 0 : void 0) + '&sbt=tiny';
        thumbs.push(thumbUrl);
      }
      return thumbs;
    };
    findEvent = function(type, events) {
      var e, i, len;
      for (i = 0, len = events.length; i < len; i++) {
        e = events[i];
        if (e.eventSubType === type) {
          return e;
        }
      }
      return false;
    };
    findAllEvents = function(type, events) {
      var e, foundEvents, i, len;
      foundEvents = [];
      for (i = 0, len = events.length; i < len; i++) {
        e = events[i];
        if (e.eventSubType === type) {
          foundEvents.push(e);
        }
      }
      return foundEvents;
    };
    getHandle = function(events, type) {
      var event, ref;
      event = findEvent(type, events);
      return event != null ? (ref = event.sourceObjectContent) != null ? ref.handle : void 0 : void 0;
    };
    getMembers = function(events) {
      var i, len, memberEvent, memberEvents, members, ref;
      members = [];
      memberEvents = findAllEvents('challenge-member-registered', events);
      for (i = 0, len = memberEvents.length; i < len; i++) {
        memberEvent = memberEvents[i];
        members.push({
          handle: memberEvent != null ? (ref = memberEvent.sourceObjectContent) != null ? ref.handle : void 0 : void 0,
          joined: memberEvent != null ? memberEvent.createdAt : void 0
        });
      }
      return members;
    };
    getCreatedAt = function(type, events) {
      var e;
      e = findEvent(type, events);
      return e != null ? e.createdAt : void 0;
    };
    return {
      getEvents: getEvents
    };
  };

  srv.$inject = ['TimelineAPIService', 'UserAPIService', 'AVATAR_URL', 'SUBMISSION_URL'];

  angular.module('appirio-tech-timeline').factory('TimelineService', srv);

}).call(this);
