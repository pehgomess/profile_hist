# capture rsyslog - by Pedro

#export PROMPT_COMMAND='RETRN_VAL=$?;logger -p local6.debug "$(whoami) [$$]: $(history 1 | sed "s/^[ ]*[0-9]\+[ ]*//" ) [$RETRN_VAL]"'


PROMPT_COMMAND=$(history -a)
typeset -r PROMPT_COMMAND

function log2syslog
{
   declare command
   command=$BASH_COMMAND
   logger -p local1.notice -t bash -i -- $USER : $command

}
trap log2syslog DEBUG

# capture diretorio - by Pedro

conf_hist="`echo $HISTFILE | grep HISTORY | wc -l`"
conf_hist="`echo $conf_hist`"

if [ "${conf_hist}" -eq 0 ]
then
   TTY="`tty | sed 's:/dev/::g'`"
   IPSRC="`who | grep ${TTY} | awk '{print $5}'`"
   MES="`date +%m_%Y`"
   DIA="`date +%d%m%Y_%H%M%S`"
   mkdir -p /.HISTORY/`id -un`/${MES}
   HISTFILE="/.HISTORY/`id -un`/${MES}/history_`logname 2>/dev/null`_${DIA}.log"
   HISTTIMEFORMAT="%d/%m/%y %T "

cat<<EOT>>${HISTFILE}
Login  : `logname 2>/dev/null`_`id -un` from ${TTY} --> ${IPSRC} - `date +%d/%m/%Y` `date +%H:%M:%S` - PID : $$
EOT
  if [ -f ${HOME}/.bash_logout ]
  then
    echo OK> /dev/null
  else
    cp /etc/skel/.bash_logout ${HOME}/.bash_logout
    chmod 440 ${HOME}/.bash_logout
  fi

  #HISTSIZE=90000
  readonly HISTSIZE
  readonly HISTTIMEFORMAT
  readonly HISTFILE
else
  echo "" > /dev/null
fi

unset conf_hist
