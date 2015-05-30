(function() {
  'use strict';
  var MessengerController;

  MessengerController = function(MessengerService) {
    var activate, vm;
    vm = this;
    vm.greetings = null;
    activate = function() {
      return vm.greetings = 'Hello World!';
    };
    activate();
    return vm;
  };

  MessengerController.$inject = ['MessengerService'];

  angular.module('appirio-tech-messenger').controller('MessengerController', MessengerController);

}).call(this);
