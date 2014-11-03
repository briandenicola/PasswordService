'use strict';

(function (app) {
    var passwordServiceController = function ($scope, passwordService) {
        passwordService
             .getAll()
             .success(function (data) {
                 $scope.passwords = data;
             });

        $scope.create = function () {
            $scope.edit = {
                password: {
                    Name: "",
                    Value: "",
                    Usage: ""
                }
            };
        };
    }

    var passwordDetailsServiceController = function ($scope, $routeParams, passwordService) {
        passwordService
             .getById($routeParams.id)
             .success(function (data) {
                 $scope.password = data;
             });

        $scope.edit = function () {
            $scope.edit.password = angular.copy($scope.password);
        };
    }

    var passwordEditServiceController = function ($scope, passwordService) {
        $scope.isEditable = function () {
            return $scope.edit && $scope.edit.password;
        };

        $scope.cancel = function () {
            $scope.edit.password = null;
        };

        $scope.save = function () {
            console.log("I got here - " + $scope.edit.password.PasswordId);
            if ($scope.edit.password.PasswordId) {
                updatePassword();
            }
            else {
                createPassword();
            }
        }

        var updatePassword = function () {
            console.log("I got to UpdatePassword");
            passwordService.update($scope.edit.password)
                .success(function () {
                    angular.extend($scope.password, $scope.edit.password);
                    $scope.edit.password = null;
                });
        };

        var createPassword = function () {
            passwordService.create($scope.edit.password)
                .success(function (password) {
                    $scope.passwords.push(password);
                    $scope.edit.password = null;
                });
        };
    }

    app.controller("passwordServiceController", passwordServiceController);
    app.controller("passwordDetailsServiceController", passwordDetailsServiceController);
    app.controller("passwordEditServiceController", passwordEditServiceController);
}(angular.module("passwordServiceApp")));
