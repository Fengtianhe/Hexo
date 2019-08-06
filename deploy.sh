#!/bin/sh

hexo clean
hexo g -d
ssh fengtianhe@120.27.127.94 -p 4215 "cd /home/fengtianhe/Hexo && git pull"