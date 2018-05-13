#!/bin/bash 
#
set -a

# trap the escape routes

# trap the escape routes
#trap yur_fckd SIGHUP
#trap yur_fckd SIGINT
#trap yur_fckd SIGTERM

#if [ -f /etc/bashrc ]; then
#      . /etc/bashrc   # --> Read /etc/bashrc, if present.
#fi

# Normal Colors
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White

# Bold
BBlack='\e[1;30m'       # Black
BRed='\e[1;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[1;34m'        # Blue
BPurple='\e[1;35m'      # Purple
BCyan='\e[1;36m'        # Cyan
BWhite='\e[1;37m'       # White

# Background
On_Black='\e[40m'       # Black
On_Red='\e[41m'         # Red
On_Green='\e[42m'       # Green
On_Yellow='\e[43m'      # Yellow
On_Blue='\e[44m'        # Blue
On_Purple='\e[45m'      # Purple
On_Cyan='\e[46m'        # Cyan
On_White='\e[47m'       # White

NC="\e[m"               # Color Reset


ALERT=${BWhite}${On_Red} # Bold White on red background
CLEANPS=${BGreen} # Bold White on red background


# Test connection type:
if [ -n "${SSH_CONNECTION}" ]; then
    CNX=${Green}        # Connected on remote machine, via ssh (good).
elif [[ "${DISPLAY%%:0*}" != "" ]]; then
    CNX=${ALERT}        # Connected on remote machine, not via ssh (bad).
else
    CNX=${BCyan}        # Connected on local machine.
fi

# Test user type:
if [[ ${USER} == "root" ]]; then
    SU=${BRed}           # User is root.
elif [[ ${USER} == "doc" ]]; then
    SU=${BBlue}          # User is not login user.
elif [[ ${USER} == "kellman" ]]; then
    SU=${BBlue}          # User is not login user.
else
    SU=${BCyan}         # User is normal (well ... most of us are).
fi



# Returns a color according to running/suspended jobs.
function job_color()
{
    if [ $(jobs -s | wc -l) -gt "0" ]; then
        echo -en ${BRed}
    elif [ $(jobs -r | wc -l) -gt "0" ] ; then
        echo -en ${BCyan}
    fi
}

#============================================================
promptls () {
    pmptls=$(ls -xF1 --color=always "$PWD" | tr '\n' ' ') 
    echo -en "${pmptls[@]}"
}

promptpwd () {
    prmptwd=$(pwd | tr -d '\n')
    echo -en "${prmptwd[@]}"
}

promptsys () {
    if [ "${TERM}" = "screen" ] ; then
        tinfo=$(screen -ls 2> /dev/null | grep ${STY} | tr -d '\n' | tr -d '\t')
        echo -n "$tinfo"
    else
  uname -n | tr -d '\n'
  fi
}

prompthist () {
  #pshist=$(`history |tail -n2 |head -n1` | sed 's/[0-9]* //')
  pshist=$(history 1 | sed 's/[0-9]* //')
  echo -n "${pshist}"
}

promptscore () {
    score=$(etcdctl get /score 2>/dev/null) || score="No Game"
    echo -n "$score "
}

promptblog () {
    blogurl="https://hack.securinglabs.online/$BUDDY"
    echo -n "$blogurl "
}

promptgit () {
    if [ -d .git ] ; then
    gitstat=$(git status | tail -n 1 | tr -d '\n' | cut -c1-512)
        echo -en "${On_Red}${BCyan}Git Status:${NC} ${BCyan}$gitstat"
        echo -en "${NC} $(git status --porcelain -z -s)"
    #git status -s -z
    else
    pmptls=$(ls -xF1 --color=always "$PWD" | tr '\n' ' ' | cut -c1-512) 
    echo -en "${pmptls[@]}"
    #   echo -n " " 
   fi
}

promptsession () {
  if [ -f $HOME/.sessionkey ] ; then
  cat $HOME/.sessionkey | tr -d '\n'
  else
      echo -n "No session (session-create)"
  fi
}

promptmsg () {
        echo -ne "${Green} $(etcdctl get stream)${NC}" || echo -n "no messages"
 }

timer_start () {
  timer=${timer:-$SECONDS}
}

timer_stop () {
  timer_show=$(($SECONDS - $timer))
let hours=timer_show/3600
let minutes=(timer_show/60)%60
let seconds=timer_show%60
let millis=0
if [ "$timer_show" -lt 1 ]; then
clock_show=$(printf %s "$millis second")
else
	if [ "$timer_show" -eq 1 ]; then
clock_show=$(printf "%0d second" $seconds)
else
	if [ "$timer_show" -lt 10 ]; then
clock_show=$(printf "%0d seconds" $seconds)
else
	if [ "$timer_show" -le 59 ]; then
clock_show=$(printf "%02d seconds" $seconds)
else
	if [ "$timer_show" -lt 3600 ]; then
clock_show=$(printf "%02d minutes, and %02d seconds" $minutes $seconds)
	else
clock_show=$(printf "%02d hours, %02d minutes and %02d seconds" $hours $minutes $seconds)
	fi
	fi
	fi
	fi
fi	
  unset timer
}


#-------------------
# Personnal Aliases
#-------------------
alias showdebug='tail -f $HOME/nohup.out'
alias helpme='cat /etc/motd'
alias apihelp='tree $HOME'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
# -> Prevents accidentally clobbering files.
alias mkdir='mkdir -p'

alias h='history'
alias j='jobs -l'
alias which='type -a'
alias ..='cd ..'

# Pretty-print of some PATH variables:
alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'


alias du='du -h'    # Makes a more readable output.
alias df='df -h'

#-------------------------------------------------------------
# The 'ls' family (this assumes you use a recent GNU ls).
#-------------------------------------------------------------
# Add colors for filetype and  human-readable sizes by default on 'ls':
alias ls='ls -h --color=auto'
alias lx='ls -lXB'         #  Sort by extension.
alias lk='ls -lSr'         #  Sort by size, biggest last.
alias lc='ls -ltcr'        #  Sort by/show change time,most recent last.
alias lu='ls -ltur'        #  Sort by/show access time,most recent last.

# The ubiquitous 'll': directories first, with alphanumeric sorting:
alias ll='ls -hl --color=auto'
alias lm='ll | more'        #  Pipe through 'more'
alias lt='ll -tr'         #  Sort by date, most recent last.
alias lr='ll -R'           #  Recursive ls.
alias la='ll -A'           #  Show hidden files.
alias tree='tree -Csuh'    #  Nice alternative to 'recursive ls' ...


#-------------------------------------------------------------
# Spelling typos - highly personnal and keyboard-dependent :-)
#-------------------------------------------------------------

alias xs='cd'
alias vf='cd'
alias moer='more'
alias moew='more'
alias kk='ll'


#-------------------------------------------------------------
# A few fun ones
#-------------------------------------------------------------
export EDITOR=vim
alias vi='vim'

#-------------------------------------------------------------

#-------------------------------------------------------------
# construct the prompt:
#-------------------------------------------------------------

# Now we construct the prompt.
PROMPT_COMMAND=""
#if [ -n "$STY" ] ; then
#    sysback="${On_Green}"
#	systype="SCREEN"
thehost=$(hostname)
if [ "${thehost}" == "doc" ] ; then
    systype="Docs:"
	sysback="${On_Green}"
	else
	systype="IPS:"
	sysback="${On_Blue}"
fi

trap 'timer_start' DEBUG

if [ "$PROMPT_COMMAND" == "" ]; then
  PROMPT_COMMAND="timer_stop"
else
  PROMPT_COMMAND="$PROMPT_COMMAND; timer_stop"
fi

checkexit () {
if [ $? -eq 0 ]
then
printf ${CLEANPS}
else
printf ${ALERT}
fi
}
PS1=""

	# mark last output
PS1=${PS1}"\[${BGreen}\]<=doc \[${BYellow}\][\$(checkexit)\$(prompthist)\[${NC}\]\[${BYellow}\]] [runtime:\[${BWhite}\]\${clock_show}\[${BYellow}\]]\[${NC}\]\n"
        # Start with time of day
PS1=${PS1}"\n\[${Yellow}\][\[${BPurple}\]\@ \d\[${Yellow}\]]\[${NC}\]"
        PS1=${PS1}"\[${Yellow}\][${systype}\[${BYellow}\]\[${sysback}\]\$(promptsys)\[${Yellow}\] role:\[${SU}\]\u\[${Yellow}\]]\[${NC}\]"
        PS1=${PS1}":\[${Yellow}\][cmd:\[${Green}\]\!\[${Yellow}\] done:\[${BRed}\]\#\[${Yellow}\]]\[${NC}\]"
	# set the prompt
    PS1=${PS1}"\n\[${BGreen}\]|_/DIR [\[${BYellow}\] \$(promptpwd) \[${BGreen}\]] \[${BWhite}\]  "
    	PS1=${PS1}"\n\[${BYellow}\]   |_/[\[${NC}\]\$(promptgit)\[${BYellow}\]]"
	PS1=${PS1}"\n\[${BGreen}\]doc=> \[${NC}\]"
        # Set title of current xterm:
        #PS1=${PS1}"\[\e]0;[\u@\h] \w\a\]"



# Local Variables:
# mode:shell-script
# sh-shell:bash
# End:
export CLICOLOR=1
export CLICOLOR_FORCE=G
LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:';
export LS_COLORS
export LSCOLORS=ExFxBxDxCxegedabagacad
#export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
export HISTFILESIZE=8192
export HISTSIZE=4096
#export HISTIGNORE="ls:cd*:pwd:ll:la:history:h:exit:"
export HISTIGNORE="exit:history*:h"
alias clearhistory='echo clear > ~/.bash_history'

# Build up vim if not configured already

if [ ! -f $HOME/.vimrc ] ; then
    echo "Setting up vim editor . . . "
    mkdir -p $HOME/.vim/autoload
    mkdir -p $HOME/.vim/bundle
    curl -o $HOME/.vim/autoload/pathogen.vim -L https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim
cat > $HOME/.vimrc <<EOF
execute pathogen#infect()
filetype plugin indent on
syntax on
syntax enable
set background=dark
colorscheme solarized
set term=xterm
if has("autocmd")
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
EOF

cd $HOME/.vim/bundle
git clone https://github.com/plasticboy/vim-markdown 
git clone https://github.com/pangloss/vim-javascript
git clone https://github.com/klen/python-mode
git clone https://github.com/ekalinin/dockerfile.vim
git clone https://github.com/othree/html5.vim
git clone https://github.com/elzr/vim-json
git clone git://github.com/altercation/vim-colors-solarized.git

cd ~

fi

# User specific aliases and functions

export TZ='America/Toronto'

alias dev='cd ~/build'
alias doc='cd ~'
alias index='book sm -i node_modules,_book'

alias cleanscreen='reset ; resize'

reset

# User specific aliases and functions
export PAGER=more
export PATH=/node/bin:$PATH

echo " "


echo "Starting gitbook interface" 
cd ~
echo 

