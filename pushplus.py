# encoding:utf-8

import requests
import json,sys,random,os
import string


token = os.environ['PLUS_TOKEN'] #在 http://www.pushplus.plus/push1.html

file=sys.argv[1]
with open(file) as f:
    f.seek(0)
    first_char = f.read(1)
    if not first_char:
        sys.exit()
    f.seek(0)
    vuln = f.read()

print(vuln)

ran_str = ''.join(random.sample(string.ascii_letters + string.digits, 8))
title = "赏金漏洞提醒"
content = """
**您有新的赏金漏洞啦 ！**


{}


Token: {}

**请注意查收哦 ~**
""".format(str(vuln),ran_str)

url = 'http://www.pushplus.plus/send'
data = {
    "token":token,
    "title":title,
    "content":content,
    "template":"markdown",
    "channel":"wechat"
}
body=json.dumps(data).encode(encoding='utf-8')
headers = {'Content-Type':'application/json'}
resp = requests.post(url,data=body,headers=headers)

#print(resp.json()["msg"])

if resp.json()["msg"] == "请求成功":

    print('push wechat success',resp.text)
else:
        raise ValueError("push wechat failed, %s" % resp.text)