date

PS1="\u:\w \! \$ "
PS2=" >>> "

# vim 7.3 mac defaults
# alias vi="/usr/bin/vim"
# alias vim="/usr/bin/vim"
# vim 7.4
alias vi="/usr/local/bin/vim"
alias vim="/usr/local/bin/vim"
# alias vi="/Applications/MacVim.app/Contents/MacOS/Vim"
# viでMacVimを開く.
# alias vi='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
alias top="/usr/bin/top -s 5 -o cpu"

alias ctags="/usr/local/Cellar/ctags/5.8/bin/ctags"
alias opend="cd ~/Desktop;open .;cd -"
# CTRL+Rで履歴の検索が出来るのでコメントアウト
alias h="history | grep $1"
function proj() {
	cd ~/Projects/$1/Repos/trunk/$1.example.co.jp;
}
function htdocs() {
	cd ~/Projects/$1/Repos/trunk/$1.example.co.jp/htdocs > /dev/null 2>&1
	if [ $? -ne 0 ]
	then
	cd ~/Projects/$1/$1.example.co.jp/htdocs;
	fi
}

eval "$(hub alias -s)"
# アプリケーションを起動.
alias preview="open -a preview"
alias sourcetree="open -a SourceTree"
alias slack="open -a /Applications/Slack.app"
alias qt="open -a /Applications/QuickTime\ Player.app"
alias virtualbox="open -a /Applications/VirtualBox.app"
alias sketch="open -a /Users/ishibashi/Dropbox/Applications/Skitch.app"
alias teamviewer="open -a TeamViewer"
alias photoshop="open -a /Applications/Adobe\ Photoshop\ CC\ 2014/Adobe\ Photoshop\ CC\ 2014.app"
alias dw="open -a /Applications/Adobe\ Dreamweaver\ CC\ 2014/Adobe\ Dreamweaver\ CC\ 2014.app"
alias flash="open -a /Applications/Adobe\ Flash\ CC\ 2014/Adobe\ Flash\ CC\ 2014.app"
alias unity="open -a Unity"
alias monodevelop="open -a /Applications/Unity/MonoDevelop.app"
alias evernote="open -a /Applications/Evernote.app"
alias safari="open -a safari"
alias charles="open -a Charles"
alias am="open -a Activity\ Monitor"
alias eclipse="open -a eclipse"
alias openmail="open -a mail"
alias firefox="open -a firefox"
alias chrome="open -a 'Google Chrome'"
alias safari="open -a Safari"
alias itunes="open -a iTunes"
alias xcode="open -a Xcode"
alias console="open -a console"
alias skype="open -a /Applications/Skype.app"
alias colors="open -a Colors"
alias filezilla="open -a FileZilla"
alias sublime="open -a Sublime\ Text"
alias unity="open -a Unity"
alias versions="open -a Versions"
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
