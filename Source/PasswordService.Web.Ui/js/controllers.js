'use strict';

(function (app) {
	var passwordAppController = function( $scope ) {
		$scope.searchTerm = '';
		$scope.predicate = 'Name';
		$scope.reverse = false;
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
			console.log("Scope - Open");
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
				console.log("Inside modalInstance.result.then with password Name - " + password.Name);
				$scope.create.password = password;
			});
		}
	}

	var passwordCreateServiceController = function ($scope, $modalInstance, passwordService) {

		$scope.cancel = function () {
			console.log("Scope - Cancel");
			$modalInstance.dismiss('cancel');  
		};

		$scope.save = function () {
			console.log("Scope - New/Save function with Password Name - " + $scope.create.password.Name);
			createPassword();
			$modalInstance.close($scope.create.password);
			window.location.replace("");
		}

		var createPassword = function () {
			passwordService.create($scope.create.password)
				.success(function () {
					console.log("Success Call to HTTP POST - New/Save ");
				})
				.error(function () {
					console.log("Erroring Calling to HTTP POST - New/Save ");
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
		    console.log("Scope - Update/Save function with Password Name - " + $scope.create.password.Name);
			updatePassword();
			window.location.replace("");
		}

		var updatePassword = function () {
			passwordService.update($scope.password)
				.success(function () {
				    console.log("Success Call to HTTP PUT - Update/Save ");
					window.location.replace("");
				})
				.error(function () {
				    console.log("Erroring Calling to HTTP PUTT - Update/Save ");
				});
		};
	}

	app.controller("passwordAppController", passwordAppController);
	app.controller("passwordServiceController", passwordServiceController);
	app.controller("passwordCreateModalController", passwordCreateModalController);
	app.controller("passwordCreateServiceController", passwordCreateServiceController);    
	app.controller("passwordEditServiceController", passwordEditServiceController);

}(angular.module("passwordServiceApp")));
