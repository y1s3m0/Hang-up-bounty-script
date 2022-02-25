#!/bin/bash
export PATH=$PATH:`pwd`

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
	for line in `ls ./new/${files}`
	do
	  echo ${line}|sed 's/\.txt//g' >> ./new/${files}/urls.txt
	  cat ./new/${files}/${line} >> ./new/${files}/subs.txt
	done
	#cat ./new/${files}/urls.txt
	#cat ./new/${files}/subs.txt
	echo '['`date +%Y-%m-%d-%H:%M:%S`']：对'${files}'进行子域名探查'
	# if [`cat ./new/${files}/subs.txt | wc -l` -ge 500 ];then fi
	subfinder -dL ./new/${files}/urls.txt -all | anew ./new/${files}/subs.txt| httpx -silent | nuclei  -es info -o ./res.log ; python3 pushplus.py res.log
	sleep 600
	rm ./new/${files}/urls.txt
	rm ./new/${files}/subs.txt
done

echo '['`date +%Y-%m-%d-%H:%M:%S`']：结束脚本'
sleep 600
echo '' > ./subs.txt
done
