(function() {
  'use strict';
  var MessagingController;

  MessagingController = function(MessagingService) {
    var activate, vm;
    vm = this;
    vm.greetings = null;
    activate = function() {
      return vm.greetings = 'Hello World!';
    };
    activate();
    return vm;
  };

  MessagingController.$inject = ['MessagingService'];

  angular.module('appirio-tech-messaging').controller('MessagingController', MessagingController);

}).call(this);
