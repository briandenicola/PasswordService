import argparse
import json
import requests
import urllib3
import os
from requests_ntlm import HttpNtlmAuth

class Password:
	User  = None
	Value = None
	Usage = None
	def __init__(self, username, password, usage):
		self.User = username
		self.Value = password
		self.Usage = usage
	
class PasswordService:
	server = "server.com"
	webservice_url = "https://{0}/passwords/api/passwords/".format(server)
	auth = None
	ca_certificate_path = "False" 
	passwords = None

	def __init__(self, username, password, ca):
		if os.path.exists(ca):  self.ca_certificate_path = ca
		self.auth =  HttpNtlmAuth(username,password)
	
	def LoadPasswords(self):
		r = requests.get( self.webservice_url, auth=self.auth, verify=self.ca_certificate_path )
		if r.status_code == 200:
			self.passwords = json.loads(r.text)

	def FindIdByName(self,name):
		ids = [ password['PasswordId'] for password in self.passwords if password['Name'] == name ]
		return ids

	def GetPasswords(self):
		return [ Password(password['Name'],password['Value'],password['Usage']) for password in self.passwords ]
		
	def GetPassword(self,id):
		r = requests.get( self.webservice_url + str(id), auth=self.auth, verify=self.ca_certificate_path )
		if r.status_code == 200:
			return (json.loads(r.text))['Value']
		else:
			return None

	def GetPasswordByName(self,name):
		return [ self.GetPassword(id) for id in self.FindIdByName(name) ]

	def NewPassword(self,name,password,usage):
		payload = {'Name': name, 'Value': password, 'Usage': usage}
		r = requests.post( self.webservice_url, params=payload )
		self.LoadPasswords()

	def UpdatePassword(self,id,name,password,usage):
		payload = {'Name': name, 'Value': password, 'Usage': usage}
		r = requests.put( self.webservice_url + id, params=payload )
		self.LoadPasswords()