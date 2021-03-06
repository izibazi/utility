# PS1="\u:\w \! \$ "
source /usr/local/etc/bash_completion.d/git-prompt.sh
source /usr/local/etc/bash_completion.d/git-completion.bash
GIT_PS1_SHOWDIRTYSTATE=true
# export PS1='\u\:\w[\033[00m\]:\W\[\033[31m\]$(__git_ps1 [%s])\[\033[00m\]\$ '
export PS1='\u:\w\033[00m\]\[\033[31m\]$(__git_ps1 [%s])\[\033[00m\]\$ '
PS2=" >>> "

# vim 7.3 mac defaults
# alias vi="/usr/bin/vim"
# alias vim="/usr/bin/vim"
# vim 7.4
alias vi="/usr/local/bin/vim"
alias vim="/usr/local/bin/vim"
# MacVim
# alias vi="/Applications/MacVim.app/Contents/MacOS/Vim"
# alias vi='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
# cpu使用率順5件表示 topコマンド 
# alias top="/usr/bin/top -s 5 -o cpu"
# ctagの場所
alias ctags="/usr/local/Cellar/ctags/5.8/bin/ctags"
alias oc="open ."
alias od="open ~/Desktop"
alias ds="cd ~/Desktop"
# CTRL+Rで履歴の検索が出来るのでコメントアウト
# alias h="history | grep $1"
function p() {
	cd ~/Projects/$1;
}
function github() {
	cd ~/Dropbox/GitHub;
	if [ $# -eq 1 ]
	then
		cd $1 > /dev/null 2>&1;
		echo "moved" $(pwd) 
	fi
}
function htdocs() {
	cd ~/Projects/$1/Repos/trunk/$1.shed.co.jp/htdocs > /dev/null 2>&1
	if [ $? -ne 0 ]
	then
	cd ~/Projects/$1/$1.shed.co.jp/htdocs;
	fi
}
function gr() {
	htdocs $1
	if [ $? -ne 0 ]
	then
		return $?
	fi
	if [ $2 ]
	then
	 cd ../grunt_sp;
	else
	 cd ../grunt;
	fi
	t=$?
	if [ $t -eq 0 ]
	then
	echo "moved" $(pwd)
	fi
	if [ $t -eq 0 ]
	then
	grunt;
	fi
}
eval "$(hub alias -s)"
# アプリケーションを起動.
alias md="open -a /Applications/MacDown.app"
alias geny="open -a /Applications/Genymotion.app"
alias as="open -a /Applications/Android\ Studio.app"
alias excel="open -a /Applications/Microsoft\ Office\ 2011/Microsoft\ Excel.app"
alias word="open -a /Applications/Microsoft\ Office\ 2011/Microsoft\ Word.app"
alias virtualbox="open -a /Applications/VirtualBox.app"
alias vb="open -a /Applications/VirtualBox.app"
alias charles="open -a Charles"
alias xcode="open -a Xcode"
alias unity="open -a Unity"
alias versions="open -a Versions"
alias preview="open -a preview"
alias sourcetree="open -a SourceTree"
alias sc="open -a SourceTree"
alias slack="open -a /Applications/Slack.app"
alias qt="open -a /Applications/QuickTime\ Player.app"
alias sketch="open -a /Applications/Skitch.app"
alias teamviewer="open -a TeamViewer"
alias photoshop="open -a /Applications/Adobe\ Photoshop\ CC\ 2014/Adobe\ Photoshop\ CC\ 2014.app"
alias dw="open -a /Applications/Adobe\ Dreamweaver\ CC\ 2014/Adobe\ Dreamweaver\ CC\ 2014.app"
alias flash="open -a /Applications/Adobe\ Flash\ CC\ 2015/Adobe\ Flash\ CC\ 2015.app"
alias unity="open -a Unity"
alias monodevelop="open -a /Applications/Unity/MonoDevelop.app"
alias evernote="open -a /Applications/Evernote.app"
alias safari="open -a safari"
alias am="open -a Activity\ Monitor"
alias eclipse="open -a eclipse"
alias openmail="open -a mail"
alias firefox="open -a firefox"
alias chrome="open -a 'Google Chrome'"
alias safari="open -a Safari"
alias itunes="open -a iTunes"
alias console="open -a console"
alias skype="open -a /Applications/Skype.app"
alias colors="open -a Colors"
alias filezilla="open -a FileZilla"
alias sublime="open -a Sublime\ Text\ 2"
alias note="open -a Evernote.app"
alias appstore="open -a App\ Store"

alias ls="ls -FG"
alias dfh="df -h"
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"
alias m2u="tr '\015' '\012'"
alias u2m="tr '\012' '\015'"
alias listusers="cut -d: -f1 /etc/passwd"

# grep結果のカラーリング.
GREP_OPTIONS="--color=always"; 
export GREP_OPTIONS

# 日本語文字化け対策
# alias java="java -Dfile.encoding=UTF-8"

# lsの色
#export LSCOLORS=xbfxcxdxbxegedabagacad

export NODE_PATH=/usr/local/lib/node_modules
export PATH=$PATH:/Users/ishibashi/.nodebrew/current/bin 

export BUNDLER_EDITOR=vim
export EDITOR=vim

SDKROOT=$(xcrun --show-sdk-path -sdk macosx)
alias swift='xcrun swift'
alias swiftc='xcrun swiftc -sdk $SDKROOT'

alias be='bundle exec'
alias b='bundle exec'
alias adb-monitor='/Applications/AndroidSDK/adt-bundle-mac-x86_64-20140702/sdk/tools/monitor'
alias xamarin='/Applications/Xamarin\ Studio.app'

export GEM_PATH=:/Users/ishibashi/.gem/ruby/2.0.0:/Library/Ruby/Gems/2.0.0:/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/lib/ruby/gems/2.0.0

# Gitの設定
alias g="git"
alias ga='git add'
alias gaa='git add .'
alias gaaa='git add -A'
alias gb='git branch'
alias gbd='git branch -d'
alias gco='git commit'
alias gcom='git commit -m'
alias gcoam='git commit -am'
alias gch='git checkout'
alias gchb='git checkout -b'
alias gchm='git checkout master'
alias gd='git diff'
alias gds='git diff --staged'
alias gdh='git diff HEAD'
alias gdd='git diff develop'
alias gi='git init'
alias glog='git log --oneline'
alias glog1='git log --oneline -10'
alias glg='git log --grape --oneline --decarate --all'
alias gl='git l'
alias gl5='git l -5'
alias gl10='git l -10'
alias glme='git me'
alias gm='git merge --no-ff'
alias gp='git pull'
alias gs='echo ""; echo "*********************************************"; echo -e "   DO NOT FORGET TO PULL BEFORE COMMITTING"; echo "*********************************************"; echo ""; git status' 
alias gss='git status -s'

function groot() {
	cd $(git rev-parse --show-toplevel)
}

function glf() {
	git log --all --grep="$1";
}

# Projects
alias reversi="cd ~/Projects/Reversid/git/reversid"
alias reversi-assets="cd ~/Projects/Reversid/git/assets"
alias reversi-html="cd ~/Projects/Reversid/git/reversid_html"
alias start-reversi-server="/Users/ishibashi/Projects/ReversiD/git/assets/commands/start-server.command"
alias stop-reversi-server="/Users/ishibashi/Projects/ReversiD/git/assets/commands/stop-server.command"
alias build-reversi-assetsjson="/Users/ishibashi/Projects/ReversiD/git/assets/commands/build-assetsjson.command"
alias validate-reversi-assetsjson="/Users/ishibashi/Projects/ReversiD/git/assets/commands/validate-assetsjson.command"

alias rails4="cd ~/Desktop/rails4"

export JAVA_HOME=`/usr/libexec/java_home -v 1.8`

