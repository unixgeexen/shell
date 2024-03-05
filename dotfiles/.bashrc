# shell profile
# 	Fix usage of access to other servers to fit in with the bash and ksh - and fix lsHost, x1s, j, jl
# 	Fix email addr - variable
# 	Fix home dir
# 	Review function, alias naming standards

# Set up if we're using ksh to get config from .kshrc
export ENV=~/.kshrc
#stty erase 
#stty erase ^?
#stty erase 
shopt -s histappend

export EDITOR=nvim
export VISUAL=nvim
export LC_COLLATE="C"
alias nnn='nnn -e -H'

EmailAddr='userid@email.site'

# User specific environment and startup programs
#PATH=$PATH:$HOME/bin:/usr/local/script
PATH=$PATH:$HOME/bin
export PATH
set -o vi
# Source global definitions
if [[ $0 = *bash ]] ; then
	if [ -f /etc/bashrc ]; then
		. /etc/bashrc
	fi
fi
#if [[ -n $PS1 ]]; then
if [[ $- == *i* ]] ; then
    : # These are executed only for interactive shells
    InteractiveType="interactive"
else
    : # Only for NON-interactive shells
    InteractiveType="non-interactive"
fi

#if shopt -q login_shell ; then
if [[ $0 = -* ]] ; then
    : # These are executed only when it is a login shell
    LoginType="login"
else
    : # Only when it is NOT a login shell
    LoginType="non-login"
fi
alias lsshell="echo $SHELL:$0:$InteractiveType:$LoginType"
#lsshell
PS1="\[\033[01;32m\]\u@\h\[\033[01;36m\]:\w $0(\$?)\\$\[\033[00m\] "
export PS1
alias uc='su - pa0034ub'

if [ -f ~/.bashrc.filesearch ]; then
	. ~/.bashrc.filesearch
fi

# nnn plugins, bookmarks
export NNN_PLUG='f:finder;o:fzopen;p:mocplay;d:diffs;t:nmount;v:imgview;p:pdfview;l:launch'
export NNN_BMS='s:/share;h:${HOME};r:/'

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# SSH Configuration
SSH_ENV="$HOME/.ssh/environment"
alias sshagentshow="ps -ef|grep ssh-agent|grep $USER|grep -v grep"

sshagentstart() {
     /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
     chmod 600 "${SSH_ENV}"
     . "${SSH_ENV}" > /dev/null
     /usr/bin/ssh-add;
}

# Source SSH settings, if applicable
#if [ -f "${SSH_ENV}" ]; then
#     . "${SSH_ENV}" > /dev/null
#     #ps ${SSH_AGENT_PID} doesn't work under cywgin
#     ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
#         sshagentstart;
#     }
#else
#     sshagentstart;
#fi

sshagentstop(){
    ME=`whoami`
    # Stop the agent if this is the last session being terminated
    if [[ `who|grep -w $ME|grep pts|wc -l` -eq 1 && `w|grep -w $ME|grep tmux|wc -l` -ne 1 ]];then
        test -n "$SSH_AGENT_PID" && eval `ssh-agent -k`
        test -n "$SSH2_AGENT_PID" && kill $SSH2_AGENT_PID  0
    fi
}

TrapHandler(){
	if [[ $0 = -* ]] ; then	# Only for login shell
		sshagentstop
	fi
}

trap TrapHandler TERM HUP QUIT TSTP STOP

#trap sshagentstop EXIT SIGHUP SIGKILL SIGTERM

alias tm='tmux'
alias ta='tmux attach -t '
alias tl="tmux ls"
#alias tn="tmux new -n ${HOSTNAME%%.*} -s "
alias tn="tmux has-session -t hpelite && tmux -2 attach -t hpelite || tmux -2 new -n ${HOSTNAME%%.*} -s hpelite"
alias cb="vi ~/clipboard"

# sphinx documentation
alias startsphinx='source /share/sites/internal.sphinx.org/docs/.venv/bin/activate;cd /share/sites/;find . -name make.bat|sed "s/make\.bat//"'
alias stopsphinx='deactivate'
alias starthttp='cd /share/sites;python -m http.server 8080;cd -'
alias lssphinx='find /share/sites -type d -name source'

alias fp='find $(echo $PATH|sed "s/:/ /g")|grep -i'
alias gls='ls -1|egrep -i '
#export PYTHONPATH=/usr/lib64/python2.7/site-packages
#export PYENV_ROOT="$HOME/.pyenv"
#export PATH="$PYENV_ROOT/bin:$PATH"
#eval "$(pyenv init -)"
export WORKON_HOME=~/Development/Python/.ve
export PROJECT_HOME=~/Development/Python/workspace
__FileList=`mktemp --tmpdir $$.filelist.XXXXXXXXXX`
#pyenv virtualenvwrapper_lazy
#pyenv-virtualenv: prompt changing will be removed from future release. configure `export PYENV_VIRTUALENV_DISABLE_PROMPT=1' to simulate the behavior.
NL="
"
CR=""
TAB=`printf "\t"`
#TAB="	"
ESC=""
SPC=" "
export NL CR TAB ESC SPC
export ShortHost="${HOSTNAME%%.*}"
export MyUserName=$(whoami)
export _US=
export MyOFS=':'
export ODMDirs='/usr/lib/objrepos /usr/share/lib/objrepos /etc/objrepos'
#export  DocDir="~/documentation ~/procedures"
export  DocDir="~/documentation ~/procedures /share/compdev /share/compinfo /share/documents /share/finance /share/personal /share/science /share/security /share/society /share/research"
export  TicketDir="~/tickets"


############  Notes  ######################

tty -s && stty erase ^?
#tty -s && stty erase 
set -o vi

# Set Aliases
alias DT='echo $(date +"D%C%y%m%d.T%H%M%S")'
alias ts='echo $(date -u +"%C%y-%m-%d %H.%M.%S (%Z)"):$(date +"%C%y-%m-%d %H.%M.%S (%Z)"):${HOSTNAME}:${HOSTNAME%%.*}:${USER}'

# Special Directories
alias logs='cd /usr/local/logs'
alias home='cd ${HOME}'

# Text Processing
alias tailf='tail -f'
alias bold='tput smso'
alias unbold='tput rmso'
alias lsText='egrep -v "^$|^[[:space:]]*#|^[[:space:]]*\*|^[[:space:]]*:"'
alias rmXIVsnap='egrep -v "last-replicated-|most-recent-"'
alias cus='tr ''${_US}'' ''${MyOFS}'''
alias upper='tr ''[:lower:]'' ''[:upper:]'''
alias lower='tr ''[:upper:]'' ''[:lower:]'''
alias squote="sed \"s/^/'/;s/\$/'/\""
alias dquote="sed 's/^/\"/;s/\$/\"/'"
alias lines2list="tr '\n' ' '"
alias rmComment='sed -e "/^[[:space:]]*#.*/d"'
alias trim='sed "s/^[[:space:]]*//;s/[[:space:]]*$//"'
alias singlespace='tr "[:blank:]" " " | tr -s "[:blank:]"'
alias rmBlank='sed -e "/^[[:space:]]*$/d"'
alias rmAsterComment='sed -e "/^[[:space:]]*\*.*/d"'
alias bod='od -td1 -tx1 -to1 -ta'
alias m=' more'
alias sr='xargs'
alias mr='xargs -n1'
alias gi='egrep -i'
alias gvg='grep -v grep'
alias giw='egrep -iw'
alias gip='egrep -w "[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}"'
alias linecount='(__sep=`printf "\t"`;nl -ba -nrn -s "$__sep")'
alias filecnt='linecount <$__FileList'

# The tbl* functions/aliases relate to tables with FS as the field separator
alias tblData='egrep -v "^$|^[[:space:]]*#"'
alias tblControl='egrep "^[[:space:]]*#[Hh]|^[[:space:]]*#[Tt]|^[[:space:]]*#[Ww]"'

# grep special files
alias gpwd='cat /etc/passwd | egrep -i'
alias gspwd='cat /etc/security/passwd | egrep -ip'
alias gsgrp='cat /etc/security/group | egrep -ip'
alias ggrp='cat /etc/group | egrep -i'
alias g2pwd='grep . /etc/passwd /etc/security/passwd | egrep -i'
alias gteam='lsText ~/etc/Team|egrep -i'
alias gticketg='grep -R . ~/tickets|egrep -i'
alias gcntclean='grep -v :0$|cut -f1 -d:'
alias gappl='cat ~/etc/DevReg.Applications.csv|egrep -i'
alias ghost='cat ~/etc/DevReg.Hosts.csv|egrep -i'
alias linesPath='(IFS=:;printf "%s\n" ${PATH})'
alias listPath='(IFS=:;printf "'"'%s' "'" ${PATH})'
alias listPathd='(IFS=:;printf "\"%s\" " ${PATH})'
#alias listPathFiles="find -L `echo $PATH|sed 's/:/ /g'` -type f 2>/dev/null"
alias listPathFiles='eval find -L `listPath`-type f 2>/dev/null'
alias findProg="listPathFiles|egrep -i "
alias l2w="paste -s -d ' '"	# convert multiple lines to a series of words - unquoted so you might miss files with spaces in it
alias l2wq='while read FileName ; do echo "'"'"'$FileName'"'"'" ; done|paste -s -d " "'	# convert multiple lines to a series of single quoted words
alias w2l='xargs -n1'	# convert each word to single line - doesn't handle file names with embedded spaces
alias dotfiles='for FileName in .* ; do case $FileName in \.\*|\.\.|\.) continue ;; *) echo $FileName;; esac ; done'
alias dotdirs='for FileName in .*/ ; do case $FileName in \.\*|\.\.\/|\.\/) continue ;; *) echo ${FileName%/*} ;; esac ; done'
# vi Some special files
alias vk='vi ${HOME}/.kshrc'
alias sk='. ${HOME}/.kshrc'	# source kshrc
alias vp='vi ${HOME}/.profile* ${HOME}/.bashrc*'
alias gp='grep . ${HOME}/.profile* ${HOME}/.bashrc*|egrep -i '
alias sp='. ${HOME}/.profile'
alias gpr='cat ${HOME}/.profile|sgrep '
alias videas='vi /share/admin/planning/ideas.stream'
alias vppwd='view /etc/passwd'
alias vsppwd='view /etc/security/passwd'
alias vsgrp='view /etc/security/group'

# File Management
alias ma='${HOME}/bin/makeArchive'
alias bu='${HOME}/bin/makeLocalBU'
alias la='${HOME}/bin/lsArchive'
alias ra='${HOME}/bin/restoreArchive'
alias dfph='df -Ph'

# Info
alias lookupmulti='while read HostName ; do lookup $HostName |egrep -w "HostName|OS|DeviceState|Environment|Criticality|Application"|awk '"'"'{getline b; getline c;getline d;getline e;getline f;printf("%s %s %s %s %s %s\n",$0,b,c,d,e,f)}'"'"' ; done <'
alias recentFiles='echo "Use cw alias"'
alias recentFilesf='echo "Use cwf alias"'
alias cw='find ~ \( -name ".dotnet" -o -name "sphinx" -o -name ".gem" -o -name ".tmp" -o -name ".recoll" -o -name ".vscode" -o -name "snap" -o -name ".ICEauthority" -o -name ".java" -o -name ".pEp*" -o -name "sync" -o -name "archive" -o -name "logs" -o -name "backup" -o -name ".cache" -o -name ".thunderbird" -o -name ".dbus" -o -name ".atom" -o -name ".local" -o -name ".mozilla" -o -name ".config" -o -name "Media" -o -name ".gnupg" -o -name ".npm" \) -prune -o -type f -printf "%T@ %Tc %p\n" |egrep -v "/etc/CmdList|.ssh/environment|.Xauthority|.bash_history|.viminfo|.lesshst"|sort -rn|head -30'
alias cwf='find ~ \( -name ".dotnet" -o -name "sphinx" -o -name ".gem" -o -name ".tmp" -o -name ".recoll" -o -name ".vscode" -o -name "snap" -o -name ".ICEauthority" -o -name ".java" -o -name ".pEp*" -o -name "sync" -o -name "archive" -o -name "logs" -o -name "backup" -o -name ".cache" -o -name ".thunderbird" -o -name ".dbus" -o -name ".atom" -o -name ".local" -o -name ".mozilla" -o -name ".config" -o -name "Media" -o -name ".gnupg" -o -name ".npm" \) -prune -o -type f -printf "%T@ %Tc %p\n" |egrep -v "/etc/CmdList|.ssh/environment|.Xauthority|.bash_history|.viminfo|.lesshst"|sort -rn|head -30|cut -c56-'
__FileSelectFile=~/tmp/FileSelectFile
alias lsf='echo "__FileSelect: $__FileSelect";echo "__FileSelectArray";printf "%s\n" "${__FileSelectArray[@]}"'
alias lsfw='printf "%s\n" $__FileSelect'
alias sfh='select name in "${__FileSelectArray[@]}"; do [[ -n $name ]] && __FileSelect="$name";echo "$__FileSelect"; break; done'
alias sf='cat > "$__FileSelectFile";unset ItemList;i=0;while read Line ; do ItemList[$i]="$Line";i=$((i+1));done < "$__FileSelectFile";if [[ "${#ItemList[*]}" -eq 1 ]] ; then __FileSelect="\"${ItemList[0]}\"" ; else select name in "${ItemList[@]}"; do [[ -n $name ]] && __FileSelect="\"$name\"";echo "$__FileSelect"; break; done; fi;[[ -n $__FileSelect ]] && __FileSelectArray[${#__FileSelectArray[@]}]="$__FileSelect"'
alias sfm='cat > "$__FileSelectFile";unset ItemList;i=0;__FileSelect="";while read Line ; do ItemList[$i]="$Line";i=$((i+1));done < "$__FileSelectFile";if [[ "${#ItemList[*]}" -eq 1 ]] ; then __FileSelect="\"${ItemList[0]}\"" ; else select name in "${ItemList[@]}" "exit"; do [[ $name == "exit" ]] && break;[[ -n $name ]] && __FileSelect="$__FileSelect \"$name\"";echo "$__FileSelect"; done; fi;[[ -n $__FileSelect ]] && __FileSelectArray[${#__FileSelectArray[@]}]="$__FileSelect"'
alias cws='cwf|sf'
alias cwsm='cwf|sfm'
alias gs='eval grep . $__FileSelect ~/tmp/__empty|egrep -v ":[[:space:]]*$"'
alias rs='eval rm -i $__FileSelect'
alias vs='eval vi $__FileSelect'
alias os='eval gio open $__FileSelect'
alias fs='eval fileInfo $__FileSelect'
alias adocs='adoc $__FileSelect'
gsf () {
        eval egrep $@ $__FileSelect
}

csf () {
        eval $@ $__FileSelect
}

new.cw () {
	SearchDirs=xxxxxx
	Exclude=yyyyyyy
	find ~ \( -name ".ICEauthority" -o -name ".java" -o -name ".pEp*" -o -name "sync" -o -name "archive" -o -name "logs" -o -name "backup" -o -name ".cache" -o -name ".thunderbird" -o -name ".dbus" -o -name ".atom" -o -name ".local" -o -name ".mozilla" -o -name ".config" -o -name "Media" -o -name ".gnupg" -o -name ".npm" \) -prune -o -type f -printf "%T@ %Tc %p\n" |egrep -v "/etc/CmdList|.ssh/environment|.Xauthority|.bash_history|.viminfo|.lesshst"|sort -rn|head -50
}

alias viCmd='vi ${HOME}/etc/CmdList*'
alias chkCmd="awk -F\"`printf '\t'`\" \"NF!=3 {print}\" ~/etc/CmdList*"
alias lsHist='fc -t 1'
alias lsl='xargs -n1 ls -ld'
alias his=history
alias ghist='history|egrep -i'
alias lsInfo='cat /usr/share/man/whatis | egrep -i'
alias lsHMC='echo HMC:Server:lpar_id:lpar_name;lsHost -u hmc|x1s "lssyscfg -r sys -F name | while read SysName ; do lshwres -r proc -m \$SysName --level lpar -F lpar_id:lpar_name| while read HWResLine ; do echo \$SysName:\$HWResLine; done; done"'
alias lsHMCmem='echo HMC:Server:lpar_name:curr_mem:curr_min_mem:curr_max_mem;lsHost -u hmc|x1s "lssyscfg -r sys -F name | while read SysName ; do lshwres -r mem -m \$SysName --level lpar -F lpar_name:curr_mem:curr_min_mem:curr_max_mem| while read HWResLine ; do echo \$SysName:\$HWResLine; done; done"'
alias lsHMCio='echo HMC:Server:phys_loc:description;lsHost -u hmc|x1s "lssyscfg -r sys -F name | while read SysName ; do lshwres -r io --rsubtype slot -m \$SysName -F phys_loc:description|while read HWResLine ; do echo \$SysName:\$HWResLine; done; done"'
alias lsHMCwwn='echo HMC:Server:phys_loc:description:mac_address:wwpn:microcode_version;lsHost -u hmc|x1s "lssyscfg -r sys -F name | while read SysName ; do lshwres -r io --rsubtype slotchildren -m \$SysName -F phys_loc:description:mac_address:wwpn:microcode_version|grep -i fibre| while read HWResLine ; do echo \$SysName:\$HWResLine; done; done"'
alias lsHMCslot='echo HMC:Server:lpar_name:lpar_id:slot_num:adapter_type:remote_lpar_id:remote_lpar_name:remote_slot_num;lsHost -u hmc|x1s "lssyscfg -r sys -F name | while read SysName ; do lshwres -r virtualio --rsubtype scsi -m \$SysName -F lpar_name:lpar_id:slot_num:adapter_type:remote_lpar_id:remote_lpar_name:remote_slot_num| while read HWResLine ; do echo \$SysName:\$HWResLine; done; done"'

# Processes
alias psa='/bin/ps -af'
alias pse='/bin/ps -eaf'
alias psg='/bin/ps -ef | egrep -i'

# All the ls stuff
alias ll='/bin/ls -al'
alias llg='/bin/ls -al | egrep -i'
alias lr='/bin/ls -lR'
alias findRecent='find ~$USER -type f -mtime -30 |egrep -v "~$USER/tmp/|~$USER/backups/"'

# Protection
#  -i makes commands ask before over writing existing files
alias cpi='cp -i'
alias mvi='mv -i'
alias rmi='rm -i'
alias open='chmod go r'
alias shut='chmod go-r'
alias chex='chmod 750'

# Applications
alias jl='j -L'

# General functions
ShortHost() {
	echo ${1%%.*};
}

function cs {
	[[ -n $1 ]] && cd "$1"
	ls -l
}

function DiskUsage {
	for DirName in $@ ; do
		find "$DirName" -type d 2>/dev/null|wc -l;du -ak "$DirName" 2>/dev/null|sort -rnk1,1|head -50
	done|more
}

function mailinfo {
        if [[ -z "$@" ]] ; then
                uuencode output.txt|mailx -s "$@ Output" $EmailAddr
        else
                uuencode "$@" "${@}.txt"|mailx -s "$@ Output" $EmailAddr
        fi
}

# grep functions
function g {
   if [ $# -eq 0 ] ; then
        echo "Usage g SearchString CommandString"
   else
        SearchString="$1"
	shift
        eval "$@ | egrep -i \"$SearchString\""
   fi
}

greps () {
# Sequential egrep expects stdin - recursive function
	if [[ $# -eq 0 ]] ; then
		echo "Error no search arguments"
		return 1
	elif [[ $# -eq 1 ]] ; then
		egrep "$1"
	else
		SearchStr="$1"
		shift 1
		greps "$@"|egrep "$SearchStr"
	fi
}

function vx {
   if [ $# -eq 0 ] ; then
        echo "Usage: vx CommandName"
   else
	export vx=`which $1`
        vi "$vx"
   fi
}

function gp {
   # run command and filter output with grep - first parameter is search string - remaining are command
   if [ $# -eq 0 ] ; then
        echo "Usage gp SearchString CommandString"
   else
        SearchString="$1"
        shift
        eval "$@ | egrep -ip \"$SearchString\""
   fi
}

function grc {
   # grep to find matching filenames - recursive, case insensitive
   if [ $# -eq 0 ] ; then
        echo "Usage grc SearchString StartDir #Recursive case insensitive search showing only filenames"
   else
	grep -iRc $@|grep -v :0$|cut -f1 -d:
   fi
}

function lsCmdFiles {
    ls -l ${HOME}/etc/CmdList*
}

function lsCmd {
    SearchCmd=""
    for SearchArg in $@ ; do
        SearchCmd="grep -i -- $SearchArg|$SearchCmd"
    done
    echo "cat ${HOME}/etc/CmdList*|${SearchCmd%?}"|bash
}

function sgrep {
    set -vx
    SearchCmd="cat -|"
    for SearchArg in $@ ; do
        SearchCmd="egrep -i -- $SearchArg|$SearchCmd"
    done
    echo "${SearchCmd%?}"|bash
    set +vx
}

function addCmd {
    local OPTIND OptName CmdGroup
    CmdGroup=${ShortHost}
    while getopts :f: OptName ; do
            case $OptName in
                    f  )    CmdGroup="$OPTARG" ;;
            esac
    done
    shift $((OPTIND-1))

    if [ $# -ne 3 ] ; then
        echo "Usage addCmd [-f CmdGroup] Command Description Tag1,Tag2,..."
    else
        echo -e "$1${TAB}$2${TAB}$3" >> "${HOME}/etc/CmdList.${CmdGroup}"
    fi
}

function lsNew {
	if [[ -n $1 ]] ; then
		for Path in $@ ; do
			if [[ "$Path" = /* ]]; then
				ls -lt $Path/*|tail +2|head
			else
				ls -lt $(pwd)/$Path/*|tail +2|head
			fi
			echo
		done
	fi
}

function numbase {
	# Convert input various output bases, input base defaults to 10 or specified by $2
	case ${#} in
		1 )        Number=${1};Base=10;;
		2 )        Number=${1};Base=${2};;
		* )        echo "Usage:numbase Number [ibase]";return 1;;
	esac
	Dec=$(echo "ibase=$Base;$Number"|bc)
	Hex=$(echo "ibase=$Base;obase=16;$Number"|bc)
	Bin=$(echo "ibase=$Base;obase=2;$Number"|bc)
	Oct=$(echo "ibase=$Base;obase=8;$Number"|bc)
	echo "$Number base $Base: Hex($Hex):Dec($Dec):Oct($Oct):Bin($Bin)"
}

function trim {
	# Trim a string
	_sp=${1%%[! 	]*}
	_trim=${1#$_sp}
	_sp=${_trim##*[! 	]}
	echo ${_trim%$_sp}
}

function chr.old {
	printf \\$(($1/64*100+$1%64/8*10+$1%8))
}
chr() {
  printf \\$(printf '%03o' $1)
}

ord() {
  printf '%d' "'$1"
}

function dirwin2unix {
	echo $@|sed 's/\\/\//g'
}

function dirunix2win {
	echo $@|sed 's/\//\\/g'
}

function ci {
        # Allow interactive choice of file list using l command executing command in following args
	if [ $# -eq 0 ] ; then
		echo "Usage ci File/DirMask [CommandString]"
	else
		typeset DirName
		select DirName in $(l $1) ; do break ; done
		shift
		if [[ -z "$@" ]] ; then
			echo $DirName
		else
			$@ $DirName
		fi
	fi
}

function c {
        # Execute specified command against first file/directory specified by pattern
	if [ $# -eq 0 ] ; then
		echo "Usage c File/DirMask [CommandString]"
	else
		typeset DirName
		for DirName in $(l $1) ; do	# workaround since xargs|head -1 got 0402-057 on command
			break
		done
		shift
		if [[ -z "$@" ]] ; then
			echo $DirName
		else
			$@ $DirName
		fi
	fi
}

function x1 {
        # Run piped input through xargs -n1 with {} as positioner
        if [ $# -eq 0 ] ; then
                echo "Usage: PipeLine | x1 Command\t#position input with {} if required"
        else
                if [[ $@ = *{}* ]] ; then
                        eval cat | xargs -n1 -I{} $@
                else
                        cat | xargs -n1 $@
                fi
        fi
}

function x1s
{
        # Run piped input through xargs -n1 then ssh to each host
        # Do not use single quote ' in input
        if [ $# -eq 0 ] ; then
                echo "Usage: PipeLine | x1s 'Command'\t#Run command through xargs to ssh -qn or local"
        else
                xargs -n1 | while read HostName ; do
#                        eval ssh -qn $HostName \'echo Host:\$\(hostname\):\;$@\'
                        if [[ $HostName == $(hostname) ]] ; then
                                (eval "$@";CmdRC=$?;[[ $CmdRC -eq 0 ]]||echo "RC($CmdRC)") | while read OutLine ; do
                                        echo "$HostName:$OutLine"
                                done
                        else
                                (eval ssh -qn $HostName \'$@\';CmdRC=$?;[[ $CmdRC -eq 0 ]]||echo "RC($CmdRC)") | while read OutLine ; do
                                        echo "$HostName:$OutLine"
                                done
                        fi
                done
        fi
}

function x1c {
        # Run piped input through xargs -n1 ksh -c with {} as positioner
        # Do not use single quote ' in input
        if [ $# -eq 0 ] ; then
                echo "Usage: PipeLine | x1c Command\t#Run command through xargs ksh -c"
        else
                eval "cat | xargs -n1 -I{} ksh -c '$@'"
        fi
}
function x1d {
        # Run piped input host list using dsh
        # Do not use single quote ' in input
        if [ $# -eq 0 ] ; then
                echo "Usage: lsHost -raix suprsde | x1d Command\t#Run command through dsh"
        else
                _HostList=$(cat)
                ksh -c "dsh -r /usr/bin/ssh -o '-q' -n ${_HostList} '$@'"
        fi
}

function tf {
	# Run single filename test against stdin.  Uses test command tests related to files
	if [ $# -eq 0 ] ; then
		echo "Usage tf TestCommandOption FileList"
	else
		typeset OptList
		while getopts :bcdefghkLprsuwx OptName ; do
			case $OptName in
				b|c|d|e|f|g|h|k|L|p|r|s|u|w|x )	OptList="$OptList$OptName";;
				\?)     echo "Check usage";;
			esac
		done
		shift $(expr $OPTIND - 1)
		if [[ ${#OptList} -ne 1 ]] ; then
# ksh			print -u2 "Single option only: $OptList"
			1>&2 echo "Single option only: $OptList"
			return 1
		else
			if [[ $# -gt 0 ]] ; then
				for FileName in "$@" ; do
					test -$OptList $FileName && echo $FileName
				done
			else
				while read FileName ; do
					test -$OptList $FileName && echo $FileName
				done
			fi
		fi
	fi

}

function l {
	# Lists files based on pattern e.g. b/d/ls*k matches b*/d*/ls*k*
	if [ $# -eq 0 ] ; then
		echo "Usage l FileDirMask"
	else
		typeset OptList
		typeset -L1 FirstChar
		typeset MaskBase
		typeset MaskDir
		typeset DirectoryPattern
		typeset FileList
		typeset DotFiles

		if [[ $# -ge 1 ]] ; then
			DirectoryPattern="`echo $1 | sed 's/\([^/]*\)\([/]\)/\1*\2/g' | sed 's/^\*//'`*"
			shift
		else
			DirectoryPattern='./*'
		fi
		MaskBase=${DirectoryPattern##*/}
		FirstChar=$MaskBase
		FileList=$DirectoryPattern
		if [[ $FirstChar == '*' ]] ; then
			MaskDir=${DirectoryPattern%/*}
			DotFiles=$MaskDir/.$MaskBase
			FileList="$FileList $DotFiles"
		fi
		echo $FileList | xargs -n1

		unset DirectoryPattern FileList DotFiles
	fi
}

function Expand {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1        ;;
      *.tar.gz)    tar xzf $1     ;;
      *.bz2)       bunzip2 $1       ;;
      *.rar)       rar x $1     ;;
      *.gz)        gunzip $1     ;;
      *.tar)       tar xf $1        ;;
      *.tbz2)      tar xjf $1      ;;
      *.tgz)       tar xzf $1       ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1    ;;
      *)           echo "'$1' cannot be extracted via Expand()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

function apropos {
	egrep "$@" /usr/share/man/whatis
}

function tblCheck {
        tblData $@ | awk -F '
                BEGIN {NumCounts=0 ; FunctionRC=0 }
                {FieldCnt[NF]+=1}
                END {
                        for ( FieldLen in FieldCnt ) {
                                printf "Len:%s:Count:%s\n",FieldLen,FieldCnt[FieldLen]
                                NumCounts+=1
                        }
                        if ( NumCounts != 1 ) {
                                printf "Error:Varied field counts:%s\n",NumCounts
				FunctionRC+=1
			}
                        printf "DataRows:%s\n",NR
			exit FunctionRC
                }'
	return $?
}

function DottedDecimal {
# compare number chars to number of "decimal and 0-9" characters
	if [ "`expr $1 : '.*'`" -ne "`expr $1 : '[.0-9]*'`" ] ; then
	       echo "NotDottedDecimal:$1"
	else
	       echo "DottedDecimal:$1"
	fi
}

function afind {
# find with absolute names
	find `pwd`/$@
}

function grepr {
# grep recursively excluding directories
	DirName="$1"
	shift 1
	grep $@ `find -L "$DirName" -type f`
}

function index { 
# Index of second string within first - 0 based index
  x="${1%%$2*}"
  [[ $x = $1 ]] && echo -1 || echo ${#x}
}

function fmtwwn { 
# Print wwn in colon separated and non-separated forms
	nosepWWN=$(echo ${1}|sed 's/://g'|sed 's/-//g')
	echo $nosepWWN $(echo ${nosepWWN}|sed 's/\(..\)/\1:/g;s/:$//')
}


# Network Functions
mask2cdr ()
{
   # Assumes there's no "255." after a non-255 byte in the mask
   local x=${1##*255.}
   set -- 0^^^128^192^224^240^248^252^254^ $(( (${#1} - ${#x})*2 )) ${x%%.*}
   x=${1%%$3*}
   echo $(( $2 + (${#x}/4) ))
}



# Usage of directory/file search functions
#  DocDir="~/documentation ~/procedures"
#  TicketDir="~/tickets"
#  SearchDir SearchStr $DocDir
#    gbasename SearchStr $DocDir|sort -u
#    find $DocDir -type f|grepdir SearchStr|sort -u
#  squote file list
#  dquote file list
#nl -ba -s "FSClosed`printf "\t"`"|cut -c7-

function sdir {
	OPTIND=1
	__SetOpts=
	while getopts :nvx OptName ; do
		case $OptName in
			n  )    __SetOpts=${__SetOpts}n;;
			v  )    __SetOpts=${__SetOpts}v;;
			x  )    __SetOpts=${__SetOpts}x;;
			* )     echo "Usage egrepSearch DirList...";return 1;;
		esac
	done
	shift $((OPTIND-1))
	[[ -n $__SetOpts ]] && set -$__SetOpts
	if [[ $# -ge 1 ]] ; then
		eval grepdir $@
		eval gbasename -i $@
	else
		return 1
	fi|sort -u|tee $__FileList
	[[ -n $__SetOpts ]] && set +$__SetOpts
}

function grepdir {
# Recursive grep with a list of matching files - same arguments as grep
	OPTIND=1
	__SetOpts=
	while getopts :nvx OptName ; do
		case $OptName in
			n  )    __SetOpts=${__SetOpts}n;;
			v  )    __SetOpts=${__SetOpts}v;;
			x  )    __SetOpts=${__SetOpts}x;;
			* )     echo "Usage grepdir \"FileList...\" egrepSearch...  # Recursive grep listing files which match";return 1;;
		esac
	done
	shift $((OPTIND-1))
	[[ -n $__SetOpts ]] && set -$__SetOpts
	if [[ $# -ge 2 ]] ; then
		eval egrep -iRc -d skip --binary-files=without-match $@|gcntclean
	else
		return 1
	fi
	[[ -n $__SetOpts ]] && set +$__SetOpts
#		FileList="$1"
#		shift 1
#		eval egrep -iRc $@ $FileList|gcntclean
}

function gbasename {
# find files from specified directories with basename matching regex
# Performance enhancements: add egrep after find, use parameter expansion instead of basename
        OPTIND=1
        OutputFormat=
        __SetOpts=
	typeset -l lcSearchStr
	typeset -l lcBaseName
	IgnoreCase=false
        while getopts :invx OptName ; do
                case $OptName in
                        i )     IgnoreCase=true;;
                        n  )    __SetOpts=${__SetOpts}n;;
                        v  )    __SetOpts=${__SetOpts}v;;
                        x  )    __SetOpts=${__SetOpts}x;;
                        * )     echo "Usage gbasename [-i] Regex DirList";return 1;;
                esac
        done
        shift $((OPTIND-1))
        [[ -n $__SetOpts ]] && set -$__SetOpts
	if [[ $# -ge 1 ]] ; then
		SearchStr="$1"
		lcSearchStr="$1"
		shift 1
		if $IgnoreCase ; then
			for DirName in $@ ; do
				eval find $DirName | egrep -i $lcSearchStr|while read FileName ; do
					lcBaseName=${FileName##*/}
					[[ "$lcBaseName" =~ $lcSearchStr ]] && echo $FileName
				done
			done
		else
			for DirName in $@ ; do
				eval find $DirName |egrep $SearchStr|while read FileName ; do
					BaseName=${FileName##*/}
					[[ "$BaseName" =~ $lcSearchStr ]] && echo $FileName
				done
			done
		fi
	else
		return 1
	fi
        [[ -n $__SetOpts ]] && set +$__SetOpts
}

function gdocs {
	gdoc $@|sf
}

function gdoc {
	OPTIND=1
	OutputFormat=
	__SetOpts=
	while getopts :nvxl OptName ; do
		case $OptName in
			n  )    __SetOpts=${__SetOpts}n;;
			v  )    __SetOpts=${__SetOpts}v;;
			x  )    __SetOpts=${__SetOpts}x;;
			l  )    echo "Search directories: $DocDir";return 0 ;;
			* )     echo "Usage gdoc [-l] SearchExpression";return 1;;
		esac
	done
	shift $((OPTIND-1))
	[[ -n $__SetOpts ]] && set -$__SetOpts
	if [[ $# -ge 1 ]] ; then
		sdir "$1" $DocDir|grep -v 'output/'
	else
		return 1
	fi
	[[ -n $__SetOpts ]] && set +$__SetOpts
}

function gticket {
	OPTIND=1
	OutputFormat=
	__SetOpts=
	while getopts :nvx OptName ; do
		case $OptName in
			n  )    __SetOpts=${__SetOpts}n;;
			v  )    __SetOpts=${__SetOpts}v;;
			x  )    __SetOpts=${__SetOpts}x;;
			* )     echo "Usage gticket [-l][-a] SearchExpression";return 1;;
		esac
	done
	shift $((OPTIND-1))
	[[ -n $__SetOpts ]] && set -$__SetOpts
	if [[ $# -ge 1 ]] ; then
		sdir "$1" $TicketDir
	else
		return 1
	fi
	[[ -n $__SetOpts ]] && set +$__SetOpts
}

function fileInfo {
	if [[ $# -gt 0 ]] ; then
		for FileName in $@ ; do
			echo $FileName
		done
	else
		cat
	fi|while read FileName ; do
		echo "====== $FileName ====="
		fileOut=$(file "$FileName")
		echo 'ls -ld:'$(ls -ld "$FileName")
		echo "file:${fileOut#*: }"
		case $fileOut in
			*text*|*data* )	__wcl=$(wc -l "$FileName");echo 'wc -l:'${__wcl% *};echo head;echo $(head "$FileName"); echo; echo tail;echo $(tail "$FileName") ;;
		esac
		echo
	done
}

# list the elements of the array specified in $1
lsArray () {
	eval 'printf "%s\n" "${'$1'[@]}"'
}

lsArray.v1 () {
# list the elements of the array specified in $1 with an index
        __ArrayName=$1
        let __count=0
#        eval 'while (( $__count < ${#'${__ArrayName}'[*]} )); do fname=${'${__ArrayName}'[__count]};echo $__count:$fname;let __count="__count + 1";done'
	eval 'printf "%s\n" "${'$__ArrayName'[@]}"'

}

adoc () {
        AsciiDocPgm=asciidoctor
        for FileLocation in $@ ; do
		# Remove leading/trailing quotes
		FileLocation="${FileLocation%\"}"
		FileLocation="${FileLocation#\"}"
                if [[ -e $FileLocation ]] ; then
                        OutDir=$(dirname $FileLocation)/output/
                        OutFile=$(basename $FileLocation).html
                        [[ -d "$OutDir" ]]||mkdir "$OutDir"
# Without diagrams      $AsciiDocPgm -o ${OutDir}${OutFile} "$FileLocation"
                        $AsciiDocPgm -r asciidoctor-diagram -a imagesoutdir=${OutDiagramDir} -a imagesdir=diagram -o ${OutDir}${OutFile} "$FileLocation"
			echo "gio open ${OutDir}${OutFile}"
                else
                        echo "Err:Input file $1 doesn't exist"
                fi
        done
}

cdr2mask ()
{
   # Number of args to shift, 255..255, first non-255 byte, zeroes
   set -- $(( 5 - ($1 / 8) )) 255 255 255 255 $(( (255 << (8 - ($1 % 8))) & 255 )) 0 0 0
   [ $1 -gt 1 ] && shift $1 || shift
   echo ${1-0}.${2-0}.${3-0}.${4-0}
}
