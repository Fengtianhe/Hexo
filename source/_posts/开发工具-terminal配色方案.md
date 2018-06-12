---
title: 开发工具-terminal配色方案
date: 2018-06-12 17:49:05
tags: 开发工具
---
## MAC下Iterm2配色方案
### 1.编辑bash_profile文件
`vim ~/.bash_profile`
### 2.带有 git 分支形式的
```
find_git_branch () {
    local dir=. head
    until [ "$dir" -ef / ]; do
    if [ -f "$dir/.git/HEAD" ]; then
        head=$(< "$dir/.git/HEAD")
        if [[ $head = ref:\ refs/heads/* ]]; then
            git_branch=" (${head#*/*/})"
        elif [[ $head != '' ]]; then
            git_branch=" → (detached)"
        else
            git_branch=" → (unknow)"
        fi
    return
    fi
    dir="../$dir"
    done
    git_branch=''
}
PROMPT_COMMAND="find_git_branch; $PROMPT_COMMAND"
green=$'\[\033[01;32m\]'
grey=$'\[\033[00m\]'
blue=$'\[\033[01;36m\]'
red=$'\[\e[1;31m\]'
PS1="$green\u@\h$grey:$blue\W$red\$git_branch$grey\$    "
```
### 3.没有 git 分支形式的

```
#enables colorin the terminal bash shell export
export CLICOLOR=1

#setsup thecolor scheme for list export
export LSCOLORS=gxfxcxdxbxegedabagacad

#sets up theprompt color (currently a green similar to linux terminal)
#export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;36m\]\w\[\033[00m\]\$    '
#enables colorfor iTerm
export TERM=xterm-256color
```
### 4.生效配置
`source ~/.bash_profile`
### 5.效果图
![带有git分支](/images/20180612-1.jpg)
![没有git分支](/images/20180612-2.jpg)