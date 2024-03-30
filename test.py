import requests

url = 'http://127.0.0.1:8000/create-user'
# import json
payload = {
        "first_name": "firstName",
        "last_name": "lastName",
        "email": "emafil",
        "password": "password"
      }
resp = requests.post(url=url, json=payload)
print(resp.json())