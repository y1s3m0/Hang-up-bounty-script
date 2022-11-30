#!/bin/bash

git fetch --all ;
git reset --hard origin/main;
git pull;

chmod +x ./*;

./start.sh;