#!/bin/bash
if [ -f ./nuclei ];then
wget ${REPO_URL}/tomnomnom/anew/releases/download/v0.1.1/anew-linux-amd64-0.1.1.tgz && \
tar zxvf anew-linux-amd64-0.1.1.tgz && \
rm anew-linux-amd64-0.1.1.tgz && \
wget ${REPO_URL}/projectdiscovery/subfinder/releases/download/v2.5.1/subfinder_2.5.1_linux_amd64.zip && \
unzip -o subfinder_2.5.1_linux_amd64.zip && \
rm subfinder_2.5.1_linux_amd64.zip && \
wget ${REPO_URL}/projectdiscovery/httpx/releases/download/v1.2.0/httpx_1.2.0_linux_amd64.zip && \
unzip -o httpx_1.2.0_linux_amd64.zip && \
rm httpx_1.2.0_linux_amd64.zip && \
wget ${REPO_URL}/projectdiscovery/nuclei/releases/download/v2.6.5/nuclei_2.6.5_linux_amd64.zip && \
unzip -o nuclei_2.6.5_linux_amd64.zip && \
rm nuclei_2.6.5_linux_amd64.zip && \
chmod +x ./*
fi

while true
do
	start_time=$(date +%Y-%m-%d\ %H:%M:%S)

	echo "[${start_time}]：开始脚本"

	

	python3 getjson.py;#下载zip

	for zipf in `ls ./new/*.zip`
	do
		name=$(echo "${zipf}"|sed 's/\.zip//g'|sed 's/\.\/new\///g')
		if [ -e ./new/${name} ];then
			echo "[`date +%Y-%m-%d\ %H:%M:%S`]：src平台${name}更新"
			mkdir ./new/tmp/${name}/;
			unzip ${zipf} -d ./new/tmp/${name}/
			for line in `ls ./new/tmp/${name}/*.txt`
			do
					txt_name=$(echo "${line}"|sed 's/\.txt//g'|cut -f 5 -d '/')
					cat $line | anew ./new/${name}/${txt_name}.txt >> ./new/${name}/subs.txt
					echo $txt_name >> ./new/${name}/urls.txt
					echo "[`date +%Y-%m-%d\ %H:%M:%S`]：域名${txt_name}更新"
			done
			rm -rf ./new/tmp/${name}/
		else
			echo "[`date +%Y-%m-%d\ %H:%M:%S`]：src平台${name}重建"
			unzip ${zipf} -d ./new/${name}/
		fi
		rm ${zipf}

		echo "[`date +%Y-%m-%d\ %H:%M:%S`]：：对${name}chaos源进行探查`wc -l ./new/${name}/subs.txt``wc -l ./new/${name}/urls.txt`"
		
		cat ./new/${name}/subs.txt| httpx -silent | nuclei -resume -es info,low -o ./new/${name}/res_chaos.log; python3 pushplus.py ./new/${name}/res_chaos.log;
		
		echo "[`date +%Y-%m-%d\ %H:%M:%S`]：对${name}subfinder源进行探查"

		subfinder -dL ./new/${name}/urls.txt -all | anew ./new/${name}/subs.txt | httpx -silent | nuclei -resume -es info,low -o ./new/${name}/res_sub.log; python3 pushplus.py ./new/${name}/res_sub.log;
		
		echo '' > ./new/${name}/subs.txt
		echo '' > ./new/${name}/urls.txt
	done	
	echo "[`date +%Y-%m-%d\ %H:%M:%S`]：结束脚本"

	while [ $(expr $(date +%s) - $(date +%s -d ${start_time})) -lt 21600  ]
	do
		sleep 600s
	done
	sleep 600s
done

# `wc -l subs.txt`

#sort urls.txt |uniq > urls.txt;

#sort subs.txt |uniq > subs.txt



#subfinder -dL urls.txt -all | anew subs.txt 
# echo '['`date +%Y-%m-%d\ %H:%M:%S`']：对更新子域名进行探查'
# cat subs.txt| httpx -silent | nuclei -resume -es info,low -o ./res.log ; python3 pushplus.py res.log;
# echo '' > ./subs.txt

# echo '['`date +%Y-%m-%d\ %H:%M:%S`']：对各域名进行子域名探查'

# for files in `ls -F ./new/| grep '/$'`
# do
# 	if [ -f ./new/${files}urls.txt ];
# 	then
# 	#echo "文件存在！路径为：$filepath"
# 	filetimestamp=`stat -c %Y ./new/${files}urls.txt`
# 	#echo "文件最后修改时间戳：$filetimestamp"
# 	timecha=$[`date +%s` - $filetimestamp]
	
# 	if [ $timecha -gt 4320000 ];then #43200=50*24*60*60
# 	#echo '当前时间大于文件最后修改时间50天'
# 		for line in `ls ./new/${files}`cx
# 		do
# 		echo ${line}|sed 's/\.txt//g' >> ./new/${files}urls.txt
# 		cat ./new/${files}${line} >> ./new/${files}subs.txt
# 		done
# 		#cat ./new/${files}urls.txt
# 		#cat ./new/${files}subs.txt
# 		echo '['`date +%Y-%m-%d\ %H:%M:%S`']：距上次大于5天，对'${files}'进行子域名探查'
# 		# if [`cat ./new/${files}subs.txt | wc -l` -ge 500 ];then fi
# 		subfinder -dL ./new/${files}urls.txt -all | anew ./new/${files}subs.txt| httpx -silent | nuclei  -es info -o ./res.log ; python3 pushplus.py res.log
# 		sleep 120
# 		echo '`date +%Y-%m-%d\ %H:%M:%S`' > ./new/${files}urls.txt
# 		echo '`date +%Y-%m-%d\ %H:%M:%S`' > ./new/${files}subs.txt
# 	fi
# 	else
# 	#echo "文件不存在或者您输入的路径有误"
# 		for line in `ls ./new/${files}`
# 		do
# 		echo ${line}|sed 's/\.txt//g' >> ./new/${files}urls.txt
# 		cat ./new/${files}${line} >> ./new/${files}subs.txt
# 		done
# 		#cat ./new/${files}urls.txt
# 		#cat ./new/${files}subs.txt
# 		echo '['`date +%Y-%m-%d\ %H:%M:%S`']：未进行探查过，对'${files}'进行子域名探查'
# 		# if [`cat ./new/${files}subs.txt | wc -l` -ge 500 ];then fi
# 		subfinder -dL ./new/${files}urls.txt -all | anew ./new/${files}subs.txt| httpx -silent | nuclei -es info -o ./res.log ; python3 pushplus.py res.log
# 		sleep 120
# 		echo '' > ./new/${files}urls.txt
# 		echo '' > ./new/${files}subs.txt
# 	fi

# done
