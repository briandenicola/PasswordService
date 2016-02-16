'use strict';

(function () {
    var passwordServiceApp = angular.module('passwordServiceApp', ["ngRoute","ui.bootstrap", "angularUtils.directives.dirPagination"]);

    var config = function ($routeProvider) {
        $routeProvider
            .when("/list",
                { templateUrl: "template/list.html"})
            .when("/audit",
                { templateUrl: "template/audit.html"})
            .when("/create",
                { templateUrl: "template/modal/create.html"})
            .when("/list/:id",
                { templateUrl: "template/details.html"})
            .when("/edit/:id",
                { templateUrl: "template/edit.html" })
            .otherwise(
                { redirectTo: "/list" });
    };
    
    var passwordService = function ($http, serviceUrl, auditUrl) {
        var getAudits = function () { return $http.get(auditUrl); }
        var getAll = function () { return $http.get(serviceUrl); }
        var getById = function (id) { return $http.get(serviceUrl + id); }
        var update = function (password) { return $http.put(serviceUrl + password.PasswordId, password); }
        var create = function (password) { return $http.post(serviceUrl, password); }

        return {
            getAudits: getAudits,
            getAll: getAll,
            getById: getById,
            update: update,
            create: create
        };
    };

    passwordServiceApp.config(config);
    passwordServiceApp.factory("passwordService", passwordService);
    passwordServiceApp.constant("serviceUrl", "api/passwords/");
    passwordServiceApp.constant("auditUrl", "api/audits/");
})();

