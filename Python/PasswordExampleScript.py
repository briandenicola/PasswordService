import argparse
import json
import requests
import urllib3
from requests_ntlm import HttpNtlmAuth

webservice_url = "server.com"

parser = argparse.ArgumentParser(description="Get Service Account Passwords")
parser.add_argument('--username', metavar='U', help='A username for the web site to process')
parser.add_argument('--password', metavar='P', help='The password for username')
parser.add_argument('--id', metavar='I', help='The id of the service account')
parser.add_argument('--ca', metavar='C', help='The path to the CA Cert file for SSL verification')
args = parser.parse_args()

auth =  HttpNtlmAuth(args.username,args.password)

if not args.id:
    r = requests.get( "https://" + webservice_url + "/passwords/api/passwords/", auth=auth, verify=args.ca)
else:
    r = requests.get( "https://" + webservice_url + "/passwords/api/passwords/" + args.id, auth=auth, verify=args.ca) 

if r.status_code == 200:
    for password in [json.loads(r.text)]:
        print "Service Account: %s (%r). Password - %s" % (password['Name'], password['PasswordId'], password['Value'])

else:
    print "Something happened. HTTP Error Code - %r" % r.status_code

'''
-----BEGIN CERTIFICATE-----
MIIGEjCCA/qgAwIBAgIRAPeCIneztajhC2LD+k4K+RwwDQYJKoZIhvcNAQEMBQAw
gYgxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpOZXcgSmVyc2V5MRQwEgYDVQQHEwtK
ZXJzZXkgQ2l0eTEeMBwGA1UEChMVVGhlIFVTRVJUUlVTVCBOZXR3b3JrMS4wLAYD
VQQDEyVVU0VSVHJ1c3QgUlNBIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTE0
MDkxMDAwMDAwMFoXDTI0MDkwOTIzNTk1OVowgYYxCzAJBgNVBAYTAlVTMQswCQYD
VQQIEwJERTETMBEGA1UEBxMKV2lsbWluZ3RvbjEkMCIGA1UEChMbQ29ycG9yYXRp
b24gU2VydmljZSBDb21wYW55MS8wLQYDVQQDEyZUcnVzdGVkIFNlY3VyZSBDZXJ0
aWZpY2F0ZSBBdXRob3JpdHkgNTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBAI0GNgsj2QI1JOdYk8aNg/0JtkcQDJ8oVyVm1qosht+fd7UJuxnE+cfbrEiV
heNHkCTUSAgHNYPAtMvTRpTW5SoXp5ywE9vstT+QEyTCh9hXe/Ix+9rHKaYiRV+H
vfJapC9UmXHFP0V/eQPMRcS6kFjY/kLgGkpy/NmBblvAfw+BIqW7u1l+lxkJ9qOu
SzcetveuGLsuekM9cc0bzChx5W3lc0kAbX/1KKiaByk/oMf3qHFkDf9q2KfrpY9A
/KE4hgLdTC5hKrQrehazl7b+Epmx8G2MvsK28Vl7m1QD35vxtKHHiuDNOQdF5Ct4
JtXfi2Kuzi1Q6bEVQymayy1DjwcCAwEAAaOCAXUwggFxMB8GA1UdIwQYMBaAFFN5
v1qqK0rPVIDh2JvAnfKyA2bLMB0GA1UdDgQWBBTyu1Xu/I/P0D8UaBqVfnkOqxcw
9DAOBgNVHQ8BAf8EBAMCAYYwEgYDVR0TAQH/BAgwBgEB/wIBADAdBgNVHSUEFjAU
BggrBgEFBQcDAQYIKwYBBQUHAwIwIgYDVR0gBBswGTANBgsrBgEEAbIxAQICCDAI
BgZngQwBAgIwUAYDVR0fBEkwRzBFoEOgQYY/aHR0cDovL2NybC51c2VydHJ1c3Qu
Y29tL1VTRVJUcnVzdFJTQUNlcnRpZmljYXRpb25BdXRob3JpdHkuY3JsMHYGCCsG
AQUFBwEBBGowaDA/BggrBgEFBQcwAoYzaHR0cDovL2NydC51c2VydHJ1c3QuY29t
L1VTRVJUcnVzdFJTQUFkZFRydXN0Q0EuY3J0MCUGCCsGAQUFBzABhhlodHRwOi8v
b2NzcC51c2VydHJ1c3QuY29tMA0GCSqGSIb3DQEBDAUAA4ICAQAGsUdhGf+feSte
4SOKj+2XtTfw4uo5t21lm1kXoRPM/ObB8yzzuVscvwnZ8Dn8PXjQXlP3ycqtc91X
g4i63y48TUjsrK1/d6IvWAuzMN7tkEzVbBVFWlZz9jxYMmeGhrZ5HFOIjYJRRduQ
4jTYZFjX+cm5b8baZuS43nRqsYGARFYlsxIzUGSOITM6W0QZ7s15p6Nh7nRMGR/g
m2qShUIzj2RDEz2XXDDTsVT9NnN7b2WhbBMmsXRxY7ERL/oZ6sZLzz7g0tdP/fOx
geY+CWp891EqIxQLd5HYdIyGXesILMu8EaX9zMY76kbahJ0HKL//f0+S2SKDaYe7
6APSyu1jqjfEUeaBSlPlvP5pXbygHjr/gQDVPyFzre6+Di+qZSIvcWuqo/jV2jJk
Ixd1rieFcsdkepYyAPC5GxNzHg0eWG9N669bnSxpvVDvmEl6ztbp7gxM3ciisBQz
OLApig0V1N+0+YUXUq5f/0lenGZ9cqN3cs0/8ClTp1p3o84ErzFhjWQCIaBTODTS
hYvB1+z6Hf2ljqD50KHs/80KO4mQBsPZjod8rQQa2KP0W3yvCBR6Z7ZUKTGGB0FV
Q29vl2FmGkHV80dWIIgWzkU6ajnQXygkTr46jKxNXqT+G5+FaY79d0Vpf9XNg+m1
Kw/4P1yG/5xtH6HrU2uqz3qOmM4yWg==
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
MIIF3jCCA8agAwIBAgIQAf1tMPyjylGoG7xkDjUDLTANBgkqhkiG9w0BAQwFADCB
iDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCk5ldyBKZXJzZXkxFDASBgNVBAcTC0pl
cnNleSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsxLjAsBgNV
BAMTJVVTRVJUcnVzdCBSU0EgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMTAw
MjAxMDAwMDAwWhcNMzgwMTE4MjM1OTU5WjCBiDELMAkGA1UEBhMCVVMxEzARBgNV
BAgTCk5ldyBKZXJzZXkxFDASBgNVBAcTC0plcnNleSBDaXR5MR4wHAYDVQQKExVU
aGUgVVNFUlRSVVNUIE5ldHdvcmsxLjAsBgNVBAMTJVVTRVJUcnVzdCBSU0EgQ2Vy
dGlmaWNhdGlvbiBBdXRob3JpdHkwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIK
AoICAQCAEmUXNg7D2wiz0KxXDXbtzSfTTK1Qg2HiqiBNCS1kCdzOiZ/MPans9s/B
3PHTsdZ7NygRK0faOca8Ohm0X6a9fZ2jY0K2dvKpOyuR+OJv0OwWIJAJPuLodMkY
tJHUYmTbf6MG8YgYapAiPLz+E/CHFHv25B+O1ORRxhFnRghRy4YUVD+8M/5+bJz/
Fp0YvVGONaanZshyZ9shZrHUm3gDwFA66Mzw3LyeTP6vBZY1H1dat//O+T23LLb2
VN3I5xI6Ta5MirdcmrS3ID3KfyI0rn47aGYBROcBTkZTmzNg95S+UzeQc0PzMsNT
79uq/nROacdrjGCT3sTHDN/hMq7MkztReJVni+49Vv4M0GkPGw/zJSZrM233bkf6
c0Plfg6lZrEpfDKEY1WJxA3Bk1QwGROs0303p+tdOmw1XNtB1xLaqUkL39iAigmT
Yo61Zs8liM2EuLE/pDkP2QKe6xJMlXzzawWpXhaDzLhn4ugTncxbgtNMs+1b/97l
c6wjOy0AvzVVdAlJ2ElYGn+SNuZRkg7zJn0cTRe8yexDJtC/QV9AqURE9JnnV4ee
UB9XVKg+/XRjL7FQZQnmWEIuQxpMtPAlR1n6BB6T1CZGSlCBst6+eLf8ZxXhyVeE
Hg9j1uliutZfVS7qXMYoCAQlObgOK6nyTJccBz8NUvXt7y+CDwIDAQABo0IwQDAd
BgNVHQ4EFgQUU3m/WqorSs9UgOHYm8Cd8rIDZsswDgYDVR0PAQH/BAQDAgEGMA8G
A1UdEwEB/wQFMAMBAf8wDQYJKoZIhvcNAQEMBQADggIBAFzUfA3P9wF9QZllDHPF
Up/L+M+ZBn8b2kMVn54CVVeWFPFSPCeHlCjtHzoBN6J2/FNQwISbxmtOuowhT6KO
VWKR82kV2LyI48SqC/3vqOlLVSoGIG1VeCkZ7l8wXEskEVX/JJpuXior7gtNn3/3
ATiUFJVDBwn7YKnuHKsSjKCaXqeYalltiz8I+8jRRa8YFWSQEg9zKC7F4iRO/Fjs
8PRF/iKz6y+O0tlFYQXBl2+odnKPi4w2r78NBc5xjeambx9spnFixdjQg3IM8WcR
iQycE0xyNN+81XHfqnHd4blsjDwSXWXavVcStkNr/+XeTWYRUc+ZruwXtuhxkYze
Sf7dNXGiFSeUHM9h4ya7b6NnJSFd5t0dCy5oGzuCr+yDZ4XUmFF0sbmZgIn/f3gZ
XHlKYC6SQK5MNyosycdiyA5d9zZbyuAlJQG03RoHnHcAP9Dc1ew91Pq7P8yF1m9/
qS3fuQL39ZeatTXaw2ewh0qpKJ4jjv9cJ2vhsE/zB+4ALtRZh8tSQZXq9EfX7mRB
VXyNWQKV3WKdwrnuWih0hKWbt5DHDAff9Yk2dDLWKMGwsAvgnEzDHNb842m1R0aB
L6KCq9NjRHDEjf8tM7qtj3u1cIiuPhnPQCjY/MiQu12ZIvVS5ljFH4gxQ+6IHdfG
jjxDah2nGN59PRbxYvnKkKj9
-----END CERTIFICATE-----
'''