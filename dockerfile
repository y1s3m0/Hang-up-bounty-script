FROM python:3.6.13-alpine
# FROM ubuntu:trusty

# MAINTAINER ysmco <none>
LABEL AUTHOR = "ysmco <none>"

ENV REPO_URL='https://github.com/' \
    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/app  \
    LANG=zh_CN.UTF-8 \
    SHELL=/bin/bash \
    PLUS_TOKEN='' \

#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
#sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
WORKDIR /app

RUN apk update -f \
    && apk upgrade \
    && apk add --no-cache git bash wget curl \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone &&\
    git clone ${REPO_URL}/y1s3m0/Hang-up-bounty-script --depth=1 /app && \
    mkdir /app/new/ && \
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
    chmod 777 /app/* && \
    pip install requests && \
    rm -r /var/cache/apk && \
    rm -r /usr/share/man

CMD ["/app/gitpull.sh"]
