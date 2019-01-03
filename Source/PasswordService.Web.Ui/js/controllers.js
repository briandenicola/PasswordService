'use strict';

(function (app) {
    var passwordAppController = function ($scope, adalService) {
		$scope.searchTerm = '';
		$scope.predicate = 'Name';
		$scope.reverse = false;

		$scope.login = function () {
		    adalService.login();
		};
		$scope.logout = function () {
		    adalService.logOut();
		};

	}

	var passwordAuditController = function ($scope, passwordService, adalService) {
		$scope.currentPage = 1;

		passwordService
			 .getAudits()
			 .success(function (data) {
				 $scope.audits = data;
			 });
	}

	var passwordServiceController = function ($scope, passwordService, adalService) {
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
		$scope.open = function (size) {
			var modalInstance = $modal.open({
				templateUrl: 'template/modal/create.html',
				controller: 'passwordCreateServiceController',
				size: size,
				resolve: {
					password: function () {
						return $scope.password;
					}
				}
			});

			modalInstance.result.then(function (password) {
				$scope.password = password;
			});
		}
	}

	var passwordCreateServiceController = function ($scope, $modalInstance, passwordService, adalService) {
        $scope.password = {
            Name: "",
            Value: "",
            Usage: ""
        };
        
		$scope.cancel = function () {
			$modalInstance.dismiss('cancel');
		};

        $scope.generate = function() {
            var randomstring = Math.random().toString(36).slice(-15);
            $scope.password.Value = randomstring;
        }

		$scope.save = function () {
			passwordService.create($scope.password)
				.success(function () {
                    $modalInstance.close($scope.password);
                    window.location.replace("");
				})
				.error(function () {
                    window.location.replace("");
				});
		}
	}

	var passwordEditServiceController = function ($scope, $routeParams, passwordService, adalService) {

		passwordService
			 .getById($routeParams.id)
			 .success(function (data) {
	            $scope.password = data;
			 });

		$scope.cancel = function () {
			window.location.replace("");
		};

		$scope.generate = function () {
		    var randomstring = Math.random().toString(36).slice(-15);
		    $scope.password.Value = randomstring;
		}

		$scope.remove = function () {
		    passwordService.remove($routeParams.id)
				.success(function () {
				    window.location.replace("");
				})
				.error(function () {
				    window.location.replace("");
				});
		};

		$scope.save = function () {
            passwordService.update($scope.password)
				.success(function () {
					window.location.replace("");
				})
				.error(function () {
                    window.location.replace("");
				});
			
		}
	}

	app.controller("passwordAppController", ['$scope', 'passwordService', 'adalAuthenticationService', passwordAppController]);
    app.controller("passwordAuditController", ['$scope', 'passwordService','adalAuthenticationService', passwordAuditController]);
	app.controller("passwordServiceController", ['$scope', 'passwordService', 'adalAuthenticationService', passwordServiceController]);
	app.controller("passwordCreateModalController",['$scope', '$modal', 'passwordService', 'adalAuthenticationService', passwordCreateModalController]);
	app.controller("passwordCreateServiceController", ['$scope', '$modalInstance', 'passwordService', 'adalAuthenticationService',passwordCreateServiceController]);
	app.controller("passwordEditServiceController", ['$scope', '$routeParams', 'passwordService', 'adalAuthenticationService', passwordEditServiceController]);

}(angular.module("passwordServiceApp")));
