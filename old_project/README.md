# 全自动扫描器 1.0

近期正在进行重构

## 介绍

    调用anew subfinder httpx nuclei 对国外src项目合集子域名进行探活及poc探测，并使用pushplus进行提醒

## install

```
git pull && docker build -t ysmco/hang-up-bounty-script:v4 \
../Hang-up-bounty-script/ --no-cache

docker run -dit --restart always \
-e PLUS_TOKEN={YOU_TOKEN}  \
-v $(pwd)/.config/:/root/.config/ \
-v $(pwd)/new/:/app/new/ \
--name bugBounty \
ysmco/hang-up-bounty-script:v4 && \
docker logs -f --tail=100bugBounty

```
