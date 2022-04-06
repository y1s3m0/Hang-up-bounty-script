#!/bin/bash

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
rm nuclei_2.6.5_linux_amd64.zip

chmod +x ./*;

./start.sh;