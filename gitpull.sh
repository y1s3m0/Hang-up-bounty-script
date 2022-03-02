#!/bin/bash
workdir=$(cd $(dirname $0); pwd)

if [ ${workdir} == "/app" ];then
	export PATH=$PATH:${workdir}
else 
	cd /app
	export PATH=$PATH:`pwd`
fi

git fetch --all ;
git reset --hard origin/main;
git pull;

chmod +x ./*;

./start.sh;