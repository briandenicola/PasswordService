'use strict';

(function () {
    var passwordServiceApp = angular.module('passwordServiceApp', ["ngRoute", "AdalAngular", "ui.bootstrap","angularUtils.directives.dirPagination" ]);
    
    var url = "";
    var endpoints = {
        "": ""
    };

    var config = function ($routeProvider, $httpProvider, $locationProvider, adalProvider) {
        $routeProvider
            .when("/list",        { templateUrl: "/template/list.html",        requireADLogin: true })
            .when("/audit",       { templateUrl: "template/audit.html",        requireADLogin: true })
            .when("/create",      { templateUrl: "template/modal/create.html", requireADLogin: true })
            .when("/list/:id",    { templateUrl: "template/details.html",      requireADLogin: true })
            .when("/edit/:id",    { templateUrl: "template/edit.html",         requireADLogin: true })
            .when("/remove/:id",  { templateUrl: "template/remove.html",       requireADLogin: true })
            .otherwise({ redirectTo: "/list" });
        
        adalProvider.init({
            instance: 'https://login.microsoftonline.com/', 
            tenant: '',
            clientId: '',
            extraQueryParameter: 'nux=1',
            endpoints: endpoints
        }, $httpProvider);

        $locationProvider.html5Mode(false);
                
    };
    
    var passwordService = function ($http, serviceUrl, auditUrl) {
        return {
            getAudits: function () { return $http.get(auditUrl); },
            getAll:    function () { return $http.get(serviceUrl); },
            getById:   function (id) { return $http.get(serviceUrl + id); },
            update:    function (password) { return $http.put(serviceUrl + password.PasswordId, password); },
            remove:    function (id) { return $http.delete(serviceUrl + id); },
            create:    function (password) { return $http.post(serviceUrl, password); }
        };
    };

    passwordServiceApp.config(['$routeProvider', '$httpProvider', '$locationProvider', 'adalAuthenticationServiceProvider', config]);
    passwordServiceApp.factory("passwordService", passwordService);
    passwordServiceApp.constant("serviceUrl", url + "api/passwords/");
    passwordServiceApp.constant("auditUrl", url + "api/audits/");
})();

