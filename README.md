
# install
```
git pull && docker build -t ysmco/hang-up-bounty-script:v4 \
../Hang-up-bounty-script/ --no-cache

docker run -dit --restart always \
-e PLUS_TOKEN=YOU_TOKEN  \
-v ~/.config/:/root/.config/ \ 
-v $(pwd)/new/:/app/new/ \ 
--name bugBounty \
ysmco/hang-up-bounty-script:v4 && \
docker logs -f --tail=100bugBounty

```