FROM alpine:latest
# FROM ubuntu:trusty

# MAINTAINER ysmco <none>
LABEL AUTHOR = "ysmco <none>"

ENV REPO_URL='https://github.com/' \
    PLUS_TOKEN='' \
    Green="\\033[32m" \
    Red="\\033[31m" \
    GreenBG="\\033[42;37m" \
    RedBG="\\033[41;37m" \
    Font="\\033[0m" \
    Green_font_prefix="\\033[32m" \
    Green_background_prefix="\\033[42;37m" \
    Font_color_suffix="\\033[0m" \
    Info="${Green}[信息]${Font}" \
    OK="${Green}[OK]${Font}" \
    Error="${Red}[错误]${Font}"

#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories

WORKDIR /app

VOLUME ["/app"]

RUN apk add --no-cache git python3 && \
    git clone ${REPO_URL}/y1s3m0/Hang-up-bounty-script --depth=1 /app && \
    chmod 777 /app/start.sh && \
    chmod 777 /app/test.sh && \
    mkdir /app/new/ && \
    mkdir /app/new/tmp && \
    wget ${REPO_URL}/projectdiscovery/subfinder/releases/download/v2.4.9/subfinder_2.4.9_linux_amd64.zip && \
    unzip -o subfinder_2.4.9_linux_amd64.zip && \
    rm subfinder_2.4.9_linux_amd64.zip && \
    chmod 777 /app/subfinder && \
    wget ${REPO_URL}/projectdiscovery/httpx/releases/download/v1.1.5/httpx_1.1.5_linux_amd64.zip && \
    unzip -o httpx_1.1.5_linux_amd64.zip && \
    rm httpx_1.1.5_linux_amd64.zip && \
    chmod 777 /app/httpx && \
    wget ${REPO_URL}/projectdiscovery/nuclei/releases/download/v2.6.2/nuclei_2.6.2_linux_amd64.zip && \
    unzip -o nuclei_2.6.2_linux_amd64.zip && \
    rm nuclei_2.6.2_linux_amd64.zip && \
    chmod 777 /app/nuclei && \
    rm -r /var/cache/apk && \
    rm -r /usr/share/man

ENTRYPOINT ["test.sh"]
