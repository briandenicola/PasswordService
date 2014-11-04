'use strict';

(function () {
    var passwordServiceApp = angular.module('passwordServiceApp', ["ngRoute","ui.bootstrap"]);

    var config = function ($routeProvider) {
        $routeProvider
            .when("/list",
                { templateUrl: "/template/list.html"})
            .when("/list/:id",
                { templateUrl: "/template/details.html"})
            .when("/edit/:id",
                { templateUrl: "/template/edit.html" })
            .otherwise(
                { redirectTo: "/list" });
    };
    
    var passwordService = function ($http, serviceUrl) {
        var getAll = function () { return $http.get(serviceUrl); }
        var getById = function (id) { return $http.get(serviceUrl + id); }
        var update = function (password) { return $http.put(serviceUrl + password.PasswordId, password); }
        var create = function (password) { return $http.post(serviceUrl, password); }

        return {
            getAll: getAll,
            getById: getById,
            update: update,
            create: create
        };
    };

    passwordServiceApp.config(config);
    passwordServiceApp.factory("passwordService", passwordService);
    passwordServiceApp.constant("serviceUrl", "/api/passwords/");
})();

