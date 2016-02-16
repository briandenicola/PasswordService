'use strict';

(function (app) {
	var passwordAppController = function( $scope ) {
		$scope.searchTerm = '';
		$scope.predicate = 'Name';
		$scope.reverse = false;
	}

    var passwordAuditController = function ($scope, passwordService) {
		$scope.currentPage = 1;

		passwordService
			 .getAudits()
			 .success(function (data) {
				 $scope.audits = data;
			 });
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

	var passwordCreateServiceController = function ($scope, $modalInstance, passwordService) {
        $scope.password = {
            Name: "",
            Value: "",
            Usage: ""
        };
        
		$scope.cancel = function () {
			$modalInstance.dismiss('cancel');
		};

        $scope.generate = function() {
            //https://stackoverflow.com/questions/9719570/generate-random-password-string-with-requirements-in-javascript
            var randomstring = Math.random().toString(36).slice(-12);
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
            passwordService.update($scope.password)
				.success(function () {
					window.location.replace("");
				})
				.error(function () {
                    window.location.replace("");
				});
			
		}
	}

	app.controller("passwordAppController", passwordAppController);
    app.controller("passwordAuditController", passwordAuditController);
	app.controller("passwordServiceController", passwordServiceController);
	app.controller("passwordCreateModalController", passwordCreateModalController);
	app.controller("passwordCreateServiceController", passwordCreateServiceController);
	app.controller("passwordEditServiceController", passwordEditServiceController);

}(angular.module("passwordServiceApp")));
