(function() {
  'use strict';
  var dependencies;

  dependencies = ['ui.router', 'ngResource', 'app.constants', 'angular-storage', 'angular-jwt', 'duScroll'];

  angular.module('appirio-tech-messaging', dependencies);

}).call(this);

angular.module("appirio-tech-messaging").run(["$templateCache", function($templateCache) {$templateCache.put("views/messaging.directive.html","<ul class=\"messages\"><li ng-repeat=\"message in vm.messaging.messages track by $index\"><img ng-src=\"{{ vm.messaging.avatars[message.publisherId] }}\" class=\"avatar\"/><img ng-src=\"http://www.topcoder.com/i/m/cardiboy_big.jpg\" ng-show=\"vm.currentUser == message.publisherId\" class=\"avatar\"/><svg class=\"avatar\" ng-hide=\"vm.currentUser == message.publisherId\" version=\"1.1\" id=\"Layer_1\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" x=\"0px\" y=\"0px\" viewBox=\"0 0 512 512\" enable-background=\"new 0 0 512 512\" xml:space=\"preserve\"><path fill=\"#020201\" d=\"M454.426,392.582c-5.439-16.32-15.298-32.782-29.839-42.362c-27.979-18.572-60.578-28.479-92.099-39.085 c-7.604-2.664-15.33-5.568-22.279-9.7c-6.204-3.686-8.533-11.246-9.974-17.886c-0.636-3.512-1.026-7.116-1.228-10.661 c22.857-31.267,38.019-82.295,38.019-124.136c0-65.298-36.896-83.495-82.402-83.495c-45.515,0-82.403,18.17-82.403,83.468 c0,43.338,16.255,96.5,40.489,127.383c-0.221,2.438-0.511,4.876-0.95,7.303c-1.444,6.639-3.77,14.058-9.97,17.743 c-6.957,4.133-14.682,6.756-22.287,9.42c-31.521,10.605-64.119,19.957-92.091,38.529c-14.549,9.58-24.403,27.159-29.838,43.479 c-5.597,16.938-7.886,37.917-7.541,54.917h205.958h205.974C462.313,430.5,460.019,409.521,454.426,392.582z\"/></svg><div class=\"message\"><p>{{ message.body }}</p><ul class=\"attachments\"><li ng-repeat=\"attachment in message.attachments track by $index\"><a href=\"#\">{{ message.attachments.originalUrl }}</a></li></ul><time>{{ message.createdAt | timeLapse }}</time></div></li><a id=\"messaging-bottom-{{ vm.threadId }}\"></a></ul><form ng-submit=\"vm.sendMessage()\"><textarea placeholder=\"Send a message&hellip;\" ng-model=\"vm.newMessage\"></textarea><button type=\"submit\" class=\"enter\">Enter</button><button type=\"button\" class=\"attach\"><div class=\"icon\"></div><span>Add Attachment</span></button></form>");
$templateCache.put("views/threads.directive.html","<ul><li ng-repeat=\"thread in vm.threads track by $index\"><a ui-sref=\"messaging({ id: thread.id })\"><header><h4>{{ thread.subject }}</h4><time>{{ thread.messages[0].createdAt | timeLapse }}</time></header><main><img ng-src=\"{{ vm.avatars[thread.messages[0].publisherId] }}\" ng-show=\"vm.avatars[thread.messages[0].publisherId]\" class=\"avatar\"/><svg class=\"avatar\" ng-hide=\"vm.avatars[thread.messages[0].publisherId]\" version=\"1.1\" id=\"Layer_1\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" x=\"0px\" y=\"0px\" viewBox=\"0 0 512 512\" enable-background=\"new 0 0 512 512\" xml:space=\"preserve\"><path fill=\"#020201\" d=\"M454.426,392.582c-5.439-16.32-15.298-32.782-29.839-42.362c-27.979-18.572-60.578-28.479-92.099-39.085 c-7.604-2.664-15.33-5.568-22.279-9.7c-6.204-3.686-8.533-11.246-9.974-17.886c-0.636-3.512-1.026-7.116-1.228-10.661 c22.857-31.267,38.019-82.295,38.019-124.136c0-65.298-36.896-83.495-82.402-83.495c-45.515,0-82.403,18.17-82.403,83.468 c0,43.338,16.255,96.5,40.489,127.383c-0.221,2.438-0.511,4.876-0.95,7.303c-1.444,6.639-3.77,14.058-9.97,17.743 c-6.957,4.133-14.682,6.756-22.287,9.42c-31.521,10.605-64.119,19.957-92.091,38.529c-14.549,9.58-24.403,27.159-29.838,43.479 c-5.597,16.938-7.886,37.917-7.541,54.917h205.958h205.974C462.313,430.5,460.019,409.521,454.426,392.582z\"/></svg><div ng-show=\"thread.unreadCount &gt; 0\" class=\"notification\">{{ thread.unreadCount }}</div><div class=\"message\"><div class=\"co-pilot\">{{ thread.messages[0].publisherId }}:</div><p>{{ thread.messages[0].body }}</p></div></main></a></li></ul><div ng-show=\"vm.threads.length == 0\" class=\"none\">None</div>");}]);
(function() {
  'use strict';
  var MessagingController;

  MessagingController = function($scope, MessagingService) {
    var activate, getUserMessages, onChange, sendMessage, vm;
    vm = this;
    vm.currentUser = null;
    onChange = function(messages) {
      return vm.messaging = messages;
    };
    activate = function() {
      vm.messaging = {
        messages: []
      };
      vm.newMessage = '';
      $scope.$watch('threadId', function() {
        if ($scope.threadId.length) {
          return getUserMessages($scope.threadId);
        }
      });
      vm.sendMessage = sendMessage;
      return vm;
    };
    getUserMessages = function(threadId) {
      return $scope.$watch('subscriberId', function() {
        var params;
        if ($scope.subscriberId.length) {
          vm.currentUser = $scope.subscriberId;
        }
        params = {
          id: threadId,
          subscriberId: vm.currentUser
        };
        return MessagingService.getMessages(params, onChange);
      });
    };
    sendMessage = function() {
      var message;
      if (vm.newMessage.length) {
        message = {
          threadId: $scope.threadId,
          body: vm.newMessage,
          publisherId: vm.currentUser,
          createdAt: moment(),
          attachments: []
        };
        vm.messaging.messages.push(message);
        MessagingService.postMessage(message, onChange);
        vm.newMessage = '';
        return $scope.showLast = 'scroll';
      }
    };
    return activate();
  };

  MessagingController.$inject = ['$scope', 'MessagingService'];

  angular.module('appirio-tech-messaging').controller('MessagingController', MessagingController);

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

  angular.module('appirio-tech-messaging').directive('messaging', directive);

}).call(this);

(function() {
  'use strict';
  var srv;

  srv = function(MessagesAPIService, AVATAR_URL, UserAPIService, ThreadsAPIService) {
    var buildAvatar, getMessages, markMessageRead, postMessage;
    getMessages = function(params, onChange) {
      var messaging, resource;
      messaging = {
        messages: [],
        avatars: {}
      };
      resource = ThreadsAPIService.get(params);
      resource.$promise.then(function(response) {
        var i, len, message, ref;
        messaging.messages = response != null ? response.messages : void 0;
        ref = messaging.messages;
        for (i = 0, len = ref.length; i < len; i++) {
          message = ref[i];
          buildAvatar(message.publisherId, messaging, onChange);
          markMessageRead(message, params);
        }
        return typeof onChange === "function" ? onChange(messaging) : void 0;
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
        subscriberId: params.subscriberId,
        threadId: params.id
      };
      return MessagesAPIService.put(queryParams, putParams);
    };
    buildAvatar = function(handle, messaging, onChange) {
      var params, user;
      if (!messaging.avatars[handle]) {
        params = {
          handle: handle
        };
        user = UserAPIService.get(params);
        user.$promise.then(function(response) {
          messaging.avatars[handle] = AVATAR_URL + (response != null ? response.photoLink : void 0);
          return typeof onChange === "function" ? onChange(messaging) : void 0;
        });
        user.$promise["catch"](function(response) {});
        return user.$promise["finally"](function() {});
      }
    };
    postMessage = function(message, onChange) {
      var resource;
      resource = MessagesAPIService.save(message);
      resource.$promise.then(function(response) {});
      resource.$promise["catch"](function(response) {});
      return resource.$promise["finally"](function() {});
    };
    return {
      getMessages: getMessages,
      postMessage: postMessage
    };
  };

  srv.$inject = ['MessagesAPIService', 'AVATAR_URL', 'UserAPIService', 'ThreadsAPIService'];

  angular.module('appirio-tech-messaging').factory('MessagingService', srv);

}).call(this);

(function() {
  'use strict';
  var srv, transformResponse;

  transformResponse = function(response) {
    var parsed, ref;
    parsed = JSON.parse(response);
    return (parsed != null ? (ref = parsed.result) != null ? ref.content : void 0 : void 0) || [];
  };

  srv = function($resource, API_URL) {
    var methods, params, url;
    url = API_URL + '/messages/:id';
    params = {
      id: '@id'
    };
    methods = {
      put: {
        method: 'PUT'
      }
    };
    return $resource(url, {}, methods);
  };

  srv.$inject = ['$resource', 'API_URL'];

  angular.module('appirio-tech-messaging').factory('MessagesAPIService', srv);

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

  angular.module('appirio-tech-messaging').directive('threads', directive);

}).call(this);

(function() {
  'use strict';
  var srv, transformResponse;

  transformResponse = function(response) {
    var parsed, ref;
    parsed = JSON.parse(response);
    return (parsed != null ? (ref = parsed.result) != null ? ref.content : void 0 : void 0) || {};
  };

  srv = function($resource, API_URL) {
    var actions, params, url;
    url = API_URL + '/threads/:id';
    params = {
      id: '@id',
      subscriberId: '@subscriberId'
    };
    actions = {
      query: {
        method: 'GET',
        isArray: false,
        transformResponse: transformResponse
      },
      get: {
        method: 'GET',
        isArray: false,
        transformResponse: transformResponse
      }
    };
    return $resource(url, params, actions);
  };

  srv.$inject = ['$resource', 'API_URL'];

  angular.module('appirio-tech-messaging').factory('ThreadsAPIService', srv);

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

  angular.module('appirio-tech-messaging').controller('ThreadsController', ThreadsController);

}).call(this);

(function() {
  'use strict';
  var srv;

  srv = function(ThreadsAPIService, AVATAR_URL, UserAPIService) {
    var buildAvatar, get;
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
        var i, j, len, len1, message, ref, ref1, thread;
        threadsVm.threads = response.threads;
        ref = threadsVm.threads;
        for (i = 0, len = ref.length; i < len; i++) {
          thread = ref[i];
          ref1 = thread.messages;
          for (j = 0, len1 = ref1.length; j < len1; j++) {
            message = ref1[j];
            buildAvatar(message.publisherId, threadsVm, onChange);
          }
        }
        return typeof onChange === "function" ? onChange(threadsVm) : void 0;
      });
      resource.$promise["catch"](function() {});
      return resource.$promise["finally"](function() {});
    };
    buildAvatar = function(handle, threadsVm, onChange) {
      var user, userParams;
      if (!threadsVm.avatars[handle]) {
        userParams = {
          handle: handle
        };
        user = UserAPIService.get(userParams);
        user.$promise.then(function(response) {
          threadsVm.avatars[handle] = AVATAR_URL + (response != null ? response.photoLink : void 0);
          return typeof onChange === "function" ? onChange(threadsVm) : void 0;
        });
        user.$promise["catch"](function() {});
        return user.$promise["finally"](function() {});
      }
    };
    return {
      get: get
    };
  };

  srv.$inject = ['ThreadsAPIService', 'AVATAR_URL', 'UserAPIService'];

  angular.module('appirio-tech-messaging').factory('ThreadsService', srv);

}).call(this);

(function() {
  'use strict';
  var srv;

  srv = function($resource, API_URL_V2) {
    var params, url;
    url = API_URL_V2 + '/users/:handle';
    params = {
      handle: '@handle'
    };
    return $resource(url, params);
  };

  srv.$inject = ['$resource', 'API_URL_V2'];

  angular.module('appirio-tech-messaging').factory('UserAPIService', srv);

}).call(this);

(function() {
  'use strict';
  var filter;

  filter = function() {
    return function(createdAt) {
      return moment(createdAt).fromNow();
    };
  };

  angular.module('appirio-tech-messaging').filter('timeLapse', filter);

}).call(this);
