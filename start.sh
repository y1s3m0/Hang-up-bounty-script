#!/bin/bash
workdir=$(cd $(dirname $0); pwd)

if [ ${workdir} == "/app" ];then
	export PATH=$PATH:${workdir}
else 
	cd /app
	export PATH=$PATH:`pwd`
fi

git pull;

while true
do
echo '['`date +%Y-%m-%d-%H:%M:%S`']：开始脚本'

python3 getjson.py;#下载zip

for zipf in `ls ./new/*.zip`
do
	name=$(echo "${zipf}"|sed 's/\.zip//g'|sed 's/\.\/new\///g')
	if [ -e ./new/${name} ];then
		echo "[`date +%Y-%m-%d-%H:%M:%S`]：src平台${name} update"
		mkdir ./new/tmp/${name}/;
  		unzip ${zipf} -d ./new/tmp/${name}/
		for line in `ls ./new/tmp/${name}/*.txt`
		do
			txt_name=$(echo "${line}"|sed 's/\.txt//g'|cut -f 5 -d '/')
			cat $line | anew ./new/${name}/${txt_name}.txt >> ./subs.txt
			#echo $txt_name >> urls.txt
			echo "[`date +%Y-%m-%d-%H:%M:%S`]：域名${txt_name} update"
		done
		rm -rf ./new/tmp/${name}/
	else
		echo "[`date +%Y-%m-%d-%H:%M:%S`]：src平台${name} renew"
		unzip ${zipf} -d ./new/${name}/
	fi
  	rm ${zipf}
done	

echo '['`date +%Y-%m-%d-%H:%M:%S`']：zip更新完毕'
echo '['`date +%Y-%m-%d-%H:%M:%S`']：subs更新内容：`cat subs.txt`'

#sort urls.txt |uniq > urls.txt;

#sort subs.txt |uniq > subs.txt



#subfinder -dL urls.txt -all | anew subs.txt 
echo '['`date +%Y-%m-%d-%H:%M:%S`']：对更新子域名进行探查'
cat subs.txt| httpx -silent | nuclei  -es info -o ./res.log ; python3 pushplus.py res.log;

echo '['`date +%Y-%m-%d-%H:%M:%S`']：对各域名进行子域名探查'

for files in `ls ./new/`
do
	if [ -f ./new/${files}/urls.txt ];
	then
	#echo "文件存在！路径为：$filepath"
	filetimestamp=`stat -c %Y ./new/${files}/urls.txt`
	#echo "文件最后修改时间戳：$filetimestamp"
	timecha=$[`date +%s` - $filetimestamp]
	
	if [ $timecha -gt 432000 ];then #43200=5*24*60*60
	#echo '当前时间大于文件最后修改时间5天'
		for line in `ls ./new/${files}`cx
		do
		echo ${line}|sed 's/\.txt//g' >> ./new/${files}/urls.txt
		cat ./new/${files}/${line} >> ./new/${files}/subs.txt
		done
		#cat ./new/${files}/urls.txt
		#cat ./new/${files}/subs.txt
		echo '['`date +%Y-%m-%d-%H:%M:%S`']：距上次大于5天，对'${files}'进行子域名探查'
		# if [`cat ./new/${files}/subs.txt | wc -l` -ge 500 ];then fi
		subfinder -dL ./new/${files}/urls.txt -all | anew ./new/${files}/subs.txt| httpx -silent | nuclei  -es info -o ./res.log ; python3 pushplus.py res.log
		sleep 120
		echo '`date +%Y-%m-%d-%H:%M:%S`' > ./new/${files}/urls.txt
		echo '`date +%Y-%m-%d-%H:%M:%S`' > ./new/${files}/subs.txt
	fi
	else
	#echo "文件不存在或者您输入的路径有误"
		for line in `ls ./new/${files}`
		do
		echo ${line}|sed 's/\.txt//g' >> ./new/${files}/urls.txt
		cat ./new/${files}/${line} >> ./new/${files}/subs.txt
		done
		#cat ./new/${files}/urls.txt
		#cat ./new/${files}/subs.txt
		echo '['`date +%Y-%m-%d-%H:%M:%S`']：未进行探查过，对'${files}'进行子域名探查'
		# if [`cat ./new/${files}/subs.txt | wc -l` -ge 500 ];then fi
		subfinder -dL ./new/${files}/urls.txt -all | anew ./new/${files}/subs.txt| httpx -silent | nuclei  -es info -o ./res.log ; python3 pushplus.py res.log
		sleep 120
		echo '' > ./new/${files}/urls.txt
		echo '' > ./new/${files}/subs.txt
	fi

done

echo '['`date +%Y-%m-%d-%H:%M:%S`']：结束脚本'
sleep 600
echo '' > ./subs.txt
done
