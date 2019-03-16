#!/bin/sh

hexo clean
hexo g -d
ssh fengtianhe@120.27.127.94 "cd /home/fengtianhe && rm -rf blog && git clone https://git.dev.tencent.com/fengtianhe/blog.git"