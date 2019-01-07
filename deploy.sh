#!/bin/sh

hexo clean
hexo g -d
ssh fengtianhe@120.27.127.94 "cd /home/fengtianhe/blog && git reset --hard HEAD && git pull"