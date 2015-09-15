#
# Cookbook Name:: PasswordService
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'PasswordService::webserver'
include_recipe 'awesome_customers::database'
