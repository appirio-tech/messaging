(function() {
  'use strict';
  var dependencies;

  dependencies = ['ui.router', 'ngResource', 'app.constants', 'duScroll', 'appirio-tech-ng-ui-components', 'appirio-tech-ng-api-services'];

  angular.module('appirio-tech-ng-messaging', dependencies);

}).call(this);

(function() {
  'use strict';
  var MessagingController;

  MessagingController = function($scope, MessagingService) {
    var activate, getUserThreads, onMessageChange, onThreadsChange, sendMessage, vm;
    vm = this;
    vm.currentUser = null;
    vm.activeThread = null;
    vm.activateThread = function(thread) {
      var i, len, message, params, ref, results;
      vm.activeThread = thread;
      if (thread.unreadCount > 0) {
        params = {
          id: thread.id,
          subscriberId: $scope.subscriberId
        };
        ref = thread.messages;
        results = [];
        for (i = 0, len = ref.length; i < len; i++) {
          message = ref[i];
          results.push(MessagingService.markMessageRead(message, params));
        }
        return results;
      }
    };
    onThreadsChange = function(threads) {
      return vm.threads = threads.threads;
    };
    onMessageChange = function(message) {
      vm.activeThread.messages.push(message);
      vm.newMessage = '';
      return $scope.showLast = 'scroll';
    };
    activate = function() {
      vm.newMessage = '';
      $scope.$watch('subscriberId', function() {
        return getUserThreads();
      });
      vm.sendMessage = sendMessage;
      return vm;
    };
    getUserThreads = function() {
      var params;
      if ($scope.threadId && $scope.subscriberId) {
        params = {
          subscriberId: $scope.subscriberId
        };
        return MessagingService.getThreads(params, onThreadsChange);
      }
    };
    sendMessage = function() {
      var message, params;
      if (vm.newMessage.length && vm.activeThread) {
        message = {
          threadId: vm.activeThread.id,
          body: vm.newMessage,
          publisherId: $scope.subscriberId,
          createdAt: moment(),
          attachments: []
        };
        params = {
          threadId: vm.activeThread.id
        };
        return MessagingService.postMessage(params, message, onMessageChange);
      }
    };
    return activate();
  };

  MessagingController.$inject = ['$scope', 'MessagingService'];

  angular.module('appirio-tech-ng-messaging').controller('MessagingController', MessagingController);

}).call(this);

(function() {
  'use strict';
  var srv;

  srv = function(MessagesAPIService, ThreadsAPIService) {
    var getThreads, markMessageRead, postMessage;
    getThreads = function(params, onChange) {
      var resource;
      resource = ThreadsAPIService.get(params);
      resource.$promise.then(function(response) {
        return typeof onChange === "function" ? onChange(response) : void 0;
      });
      resource.$promise["catch"](function() {});
      return resource.$promise["finally"](function() {});
    };
    markMessageRead = function(message, params) {
      var putParams, queryParams;
      queryParams = {
        id: message.id
      };
      putParams = {
        read: true,
        subscriberId: params.subscriberId
      };
      return MessagesAPIService.put(queryParams, putParams);
    };
    postMessage = function(params, message, onChange) {
      var resource;
      resource = MessagesAPIService.post(message);
      resource.$promise.then(function(response) {
        return typeof onChange === "function" ? onChange(message) : void 0;
      });
      resource.$promise["catch"](function(response) {});
      return resource.$promise["finally"](function() {});
    };
    return {
      getThreads: getThreads,
      postMessage: postMessage,
      markMessageRead: markMessageRead
    };
  };

  srv.$inject = ['MessagesAPIService', 'ThreadsAPIService'];

  angular.module('appirio-tech-ng-messaging').factory('MessagingService', srv);

}).call(this);

(function() {
  'use strict';
  var directive;

  directive = function(MessagingService) {
    var link;
    link = function(scope, element, attrs) {
      var showLast;
      showLast = function(newValue, oldValue) {
        var $messageList, bottom, messageList, uls;
        if (newValue) {
          scope.showLast = false;
          uls = element.find('ul');
          messageList = uls[0];
          $messageList = angular.element(messageList);
          bottom = messageList.scrollHeight;
          if (newValue === 'scroll') {
            return $messageList.scrollTopAnimated(bottom);
          } else {
            return $messageList.scrollTop(bottom);
          }
        }
      };
      showLast(true);
      return scope.$watch('showLast', showLast);
    };
    return {
      restrict: 'E',
      templateUrl: 'views/messaging.directive.html',
      link: link,
      controller: 'MessagingController',
      controllerAs: 'vm',
      scope: {
        threadId: '@threadId',
        subscriberId: '@subscriberId'
      }
    };
  };

  directive.$inject = ['MessagingService'];

  angular.module('appirio-tech-ng-messaging').directive('messaging', directive);

}).call(this);

(function() {
  'use strict';
  var directive;

  directive = function(MessagingService) {
    return {
      restrict: 'E',
      templateUrl: 'views/threads.directive.html',
      controller: 'ThreadsController',
      controllerAs: 'vm',
      scope: {
        subscriberId: '@subscriberId'
      }
    };
  };

  directive.$inject = ['MessagingService'];

  angular.module('appirio-tech-ng-messaging').directive('threads', directive);

}).call(this);

(function() {
  'use strict';
  var srv;

  srv = function(ThreadsAPIService) {
    var get;
    get = function(subscriberId, onChange) {
      var queryParams, resource, threadsVm;
      queryParams = {
        subscriberId: subscriberId
      };
      threadsVm = {
        threads: [],
        totalUnreadCount: {},
        avatars: {}
      };
      resource = ThreadsAPIService.query(queryParams);
      resource.$promise.then(function(response) {
        threadsVm.threads = response.threads;
        return typeof onChange === "function" ? onChange(threadsVm) : void 0;
      });
      resource.$promise["catch"](function() {});
      return resource.$promise["finally"](function() {});
    };
    return {
      get: get
    };
  };

  srv.$inject = ['ThreadsAPIService'];

  angular.module('appirio-tech-ng-messaging').factory('ThreadsService', srv);

}).call(this);

(function() {
  'use strict';
  var ThreadsController;

  ThreadsController = function($scope, ThreadsService) {
    var activate, onChange, removeBlanks, vm;
    vm = this;
    onChange = function(threadsVm) {
      vm.threads = removeBlanks(threadsVm.threads);
      vm.totalUnreadCount = threadsVm.totalUnreadCount;
      return vm.avatars = threadsVm.avatars;
    };
    removeBlanks = function(threads) {
      var i, len, noBlanks, thread;
      noBlanks = [];
      for (i = 0, len = threads.length; i < len; i++) {
        thread = threads[i];
        if (thread.messages.length) {
          noBlanks.push(thread);
        }
      }
      return noBlanks;
    };
    activate = function() {
      $scope.$watch('subscriberId', function() {
        if ($scope.subscriberId.length) {
          return ThreadsService.get($scope.subscriberId, onChange);
        }
      });
      return vm;
    };
    return activate();
  };

  ThreadsController.$inject = ['$scope', 'ThreadsService'];

  angular.module('appirio-tech-ng-messaging').controller('ThreadsController', ThreadsController);

}).call(this);

(function() {
  'use strict';
  var filter;

  filter = function() {
    return function(createdAt) {
      return moment(createdAt).fromNow();
    };
  };

  angular.module('appirio-tech-ng-messaging').filter('timeLapse', filter);

}).call(this);

angular.module("appirio-tech-ng-messaging").run(["$templateCache", function($templateCache) {$templateCache.put("views/messaging.directive.html","<aside><h6>Project contributors</h6><ul><li ng-repeat=\"thread in vm.threads\"><a href=\"#\" ng-click=\"vm.activateThread(thread)\" ng-class=\"{active: vm.activeThread.id == thread.id}\"><avatar></avatar><div class=\"name-title\"><div class=\"name\">{{thread.publishers[0]}}</div><div class=\"title\">Development Co-Pilot</div></div><div class=\"notification\">{{thread.unreadCount}}</div></a></li></ul></aside><main class=\"flex-center-column flex-grow\"><h1>Messaging</h1><p>You have {{vm.activeThread.messages.length}} messages with {{vm.activeThread.publishers[0]}}</p><ul class=\"messages flex-grow\"><li ng-repeat=\"message in vm.messaging.messages track by $index\"><avatar avatar-url=\"{{ vm.messaging.avatars[message.publisherId] }}\"></avatar><div class=\"message elevated-bottom\"><a href=\"#\" class=\"name\">{{vm.activeThread.publishers[0]}}</a><time>{{ message.createdAt | timeLapse }}</time><p class=\"title\">Co-Pilot</p><p>{{ message.body }}</p><ul class=\"attachments\"><li ng-repeat=\"attachment in message.attachments track by $index\"><a href=\"#\">{{ message.attachments.originalUrl }}</a></li></ul><a class=\"download\"><div class=\"icon download smallest\"></div><p>Download all images</p></a></div></li><a id=\"messaging-bottom-{{ vm.threadId }}\"></a></ul><div class=\"respond\"><div class=\"icon warning\"></div><form ng-submit=\"vm.sendMessage()\"><textarea placeholder=\"Send a message&hellip;\" ng-model=\"vm.newMessage\"></textarea><button type=\"submit\" class=\"wider action\">reply</button></form></div></main>");
$templateCache.put("views/threads.directive.html","<ul><li ng-repeat=\"thread in vm.threads track by $index\"><a ui-sref=\"messaging({ id: thread.id })\"><header><h4>{{ thread.subject }}</h4><time>{{ thread.messages[0].createdAt | timeLapse }}</time></header><main><avatar avatar-url=\"{{ vm.avatars[thread.messages[0].publisherId]  }}\"></avatar><div ng-show=\"thread.unreadCount &gt; 0\" class=\"notification\">{{ thread.unreadCount }}</div><div class=\"message\"><div class=\"co-pilot\">{{ thread.messages[0].publisherId }}:</div><p>{{ thread.messages[0].body }}</p></div></main></a></li></ul><div ng-show=\"vm.threads.length == 0\" class=\"none\">None</div>");}]);