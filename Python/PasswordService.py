import argparse
import json
import requests
import urllib3
import os
from requests_ntlm import HttpNtlmAuth

class PasswordService:
    server = "server.com"
    webservice_url = "https://" + server + "/passwords/api/passwords/"
    auth = None
    ca_certificate_path = "False" 
    passwords = None

    def __init__(self, username, password, ca):
        if os.path.exists(ca):  self.ca_certificate_path = ca
        self.auth =  HttpNtlmAuth(username,password)
        # self.ReloadPasswords()
    
    def LoadPasswords(self):
        r = requests.get( self.webservice_url, auth=self.auth, verify=self.ca_certificate_path)
        if r.status_code == 200:
            self.passwords = json.loads(r.text)

    def FindIdByName(self,name):
        ids = [ password['PasswordId'] for password in self.passwords if password['Name'] == name ]
        return ids

    def GetPassword(self,id):
        r = requests.get( self.webservice_url + str(id), auth=self.auth, verify=self.ca_certificate_path)
        if r.status_code == 200:
            return (json.loads(r.text))["Value"]
        else:
            return None

    def GetPasswordByName(self,name):
        return [ self.GetPassword(id) for id in self.FindIdByName(name) if self.GetPassword(id) ]
