#!/usr/bin/python3
# encoding:utf-8
import json
import requests
import sys,os
 #https://dns.projectdiscovery.io/dns/stats
 #https://chaos-data.projectdiscovery.io/index.json
 #https://dns.projectdiscovery.io/dns/clickup.com
#没有文件夹就下载，有就对比change!=0的就下载

new_json = requests.get('https://chaos-data.projectdiscovery.io/index.json',timeout=50)
new_data = new_json.json()
# print(new_data)

filename = './new/index.json'
if not os.path.exists(filename):
    print("py:找不到index文件，下载index")
    with open(filename, 'wb') as f:
        f.write(new_json.content)
    sys.exit()

local_json = open(filename,encoding='UTF-8')
local_data = json.load(local_json)

def updateSubs(new_dict):
    url = new_dict['URL']
    filename=url.split('/')[-1]
    filename_path = "./new/"+filename
    if not os.path.exists(filename_path):
        response = requests.get(url,timeout=50)
        if response.status_code == 200:
            with open(filename_path, 'wb') as f:
                f.write(response.content)
    
path='./new/'
for new_dict in new_data:
    if new_dict['bounty']:
        if not os.path.exists(path+new_dict['URL'].split('/')[-1][:-4]+'/'):
            print('py:'+new_dict['name']+':新网站，下载zip')
            updateSubs(new_dict)
            continue
        for local_dict in local_data:
            if local_dict['name']==new_dict['name']:
                if new_dict['change']!=0 or local_dict['count']!=new_dict['count']:
                    print('py:'+local_dict['name']+'网站更新'+str(int(new_dict['count'])-int(local_dict['count']))+"个网址，下载zip")
                    updateSubs(new_dict)
                break

with open(filename, 'wb') as f:
    print("py:下载完成，进行覆盖")
    f.write(new_json.content)


