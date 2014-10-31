'use strict';

(function (app) {
    var passwordServiceController = function ($scope, $http) {
        //$http.get
        $scope.passwords = [
            { 'Name': 'svc_test_001', 'Value': 'asdafasdffasdfljl==' },
            { 'Name': 'svc_test_002', 'Value': 'asdafasdfafasfasdfdffasdfljl==' },
            { 'Name': 'svc_test_003', 'Value': 'asdafasddfafasdfadfafdafasfsdffasfffasdfljl==' }
        ]
    }

    app.controller("passwordServiceController", passwordServiceController);
}(angular.module("passwordServiceApp")));
