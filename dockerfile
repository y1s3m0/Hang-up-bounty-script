FROM python:3.6.13-alpine
# FROM ubuntu:trusty

#MAINTAINER ysmco
LABEL AUTHOR = "ysmco"

ENV REPO_URL='https://github.com/' \
    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/app  \
    LANG=zh_CN.UTF-8 \
    SHELL=/bin/bash \
    PLUS_TOKEN='' \

#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
#sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
WORKDIR /app

#VOLUME ["/app"]

RUN apk update -f \
    && apk upgrade \
    && apk add --no-cache git bash wget curl \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone && \
    pip install requests && \
    rm -r /var/cache/apk && \
    rm -r /usr/share/man

CMD ["/app/gitpull.sh"]
