
# install
```
git pull && docker build 

docker run -dit --restart always \
-e PLUS_TOKEN=123  \
-v ~/.config/:/root/.config/ \
-v ./new/:/app/new/
```