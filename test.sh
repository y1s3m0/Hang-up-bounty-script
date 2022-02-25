#!/bin/bash
export PATH=$PATH:`pwd`

while true
do
echo '['`date +%Y-%m-%d-%H:%M:%S`']：开始脚本'

python3 -vesion

echo '['`date +%Y-%m-%d-%H:%M:%S`']：zip更新完毕'
echo '['`date +%Y-%m-%d-%H:%M:%S`']：subs更新内容：`cat subs.txt`'
echo 'marid.tk' >> subs.txt
echo '['`date +%Y-%m-%d-%H:%M:%S`']：对更新子域名进行探查'
cat subs.txt| httpx -silent | nuclei  -es info -o ./res.log ; python3 pushplus.py res.log;

echo '['`date +%Y-%m-%d-%H:%M:%S`']：对各域名进行子域名探查'

echo '['`date +%Y-%m-%d-%H:%M:%S`']：结束脚本'
sleep 600
echo '' > ./subs.txt
done
