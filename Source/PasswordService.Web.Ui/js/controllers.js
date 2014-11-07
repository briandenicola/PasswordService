'use strict';

(function (app) {
    var passwordAppController = function( $scope ) {
        $scope.searchTerm = '';
    }

    var passwordServiceController = function ($scope, passwordService) {
        
        $scope.currentPage = 1;

        passwordService
             .getAll()
             .success(function (data) {
                 $scope.passwords = data;
             });

        $scope.showPassword = function (id) {
            passwordService
             .getById(id)
             .success(function (data) {
                  prompt("The password is...",data.Value.toString());
             });  
        };
    }

    var passwordCreateModalController = function ($scope, $modal, $log) {
      $scope.create = {
        password: {
            Name: "",
            Value: "",
            Usage: ""
        }
      };

      $scope.open = function (size) {
        var modalInstance = $modal.open({
          templateUrl: 'template/modal/create.html',
          controller: 'passwordCreateServiceController',
          size: size,
          resolve: {
            password: function () {
              return $scope.create.password;
            }
          }
        });

        modalInstance.result.then(function (password) {
          $scope.create.password = password;
        });
      }
    }

    var passwordCreateServiceController = function ($scope, $modalInstance, passwordService) {

        $scope.cancel = function () {
          $modalInstance.dismiss('cancel');  
        };

        $scope.save = function () {
           createPassword();
           $modalInstance.close($scope.create.password);
           window.location.replace("");
        }

        var createPassword = function () {
            passwordService.create($scope.create.password)
                .success(function (password) {
                    $scope.create.password = null;
                });
        };
    }

    var passwordEditServiceController = function ($scope, $routeParams, passwordService) {

        passwordService
             .getById($routeParams.id)
             .success(function (data) {
                 $scope.password = data;
             });

        $scope.cancel = function () {
          window.location.replace(""); 
        };

        $scope.save = function () {
            updatePassword();
            window.location.replace("");
        }

        var updatePassword = function () {
            passwordService.update($scope.password)
                .success(function () {
                    $scope.password = null;
                    window.location.replace("");
                });
        };
    }

    app.controller("passwordAppController", passwordAppController);
    app.controller("passwordServiceController", passwordServiceController);
    app.controller("passwordCreateModalController", passwordCreateModalController);
    app.controller("passwordCreateServiceController", passwordCreateServiceController);    
    app.controller("passwordEditServiceController", passwordEditServiceController);

}(angular.module("passwordServiceApp")));
