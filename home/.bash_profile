# set git completion
#source ~/.git-completion.sh

PS1="\n\W\$(__git_ps1) \$ "

if [ -x /usr/libexec/path_helper ]; then
	PATH=""
	eval `/usr/libexec/path_helper -s`
fi
function hd {
  defaults write com.apple.finder CreateDesktop -bool false;
  echo "Hiding all Desktop icons";
  killall Finder
}
function sd {
  defaults write com.apple.finder CreateDesktop -bool true;
  echo "Showing all Desktop icons";
  killall Finder
}

alias GET='curl -XGET -s -D - -o /dev/null'
alias ocurl='curl -vvs -u erik.peterson:ABC1234'


function db-import { size=$(gzip -l $1 | awk 'NR==2 { print $2 }') && gzip -d -c $1 | pv -s $size | mysql -u root $2 ; }

# set PATH so it includes Support-Tools bin
if [ -d "/Users/erik.peterson/Acquia/Support-Tools/bin" ] ; then
    export PATH="/Users/erik.peterson/Acquia/Support-Tools/bin:$PATH"
fi


export PATH="$HOME/.composer/vendor/bin:$PATH"

[ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh


# include AH profile
if [ -f ~/.ah_profile ]; then
  . ~/.ah_profile
fi

# Executes commands against a number of servers
apdsh() {
  if [ -z `which pdsh` ]; then
    echo "pdsh must be installed before using apdsh."
    exit 1
  fi
  OPTIND=1
  sitename=
  type=
  command=
    while getopts "s:t:c:" opt; do
      case "$opt" in
      s)
        sitename=$OPTARG
        ;;
      c)
        command=$OPTARG
        ;;
      t)
        type=$OPTARG
        ;;
      esac
    done
    if [[ -z $command ]] || [ -z $type ] || [ -z $sitename ]; then
      echo 'Enter a sitename a command and a server type. The server type may be web, db, or bal.'
      echo 'Usage should be:'
      echo '* apdsh -s eeamalone -t web -c "ls" #To execute ls against all eeamalone webs'
      echo '* apdsh -s eeconeill.dev -t bal -c "netstat -nlept" #To execute netstat against all eeconeill bals'
      echo '* apdsh -s eescooper.prod -t db -c "touch foo" #To touch the file foo on all eescooper prod db class servers.'
    else
      echo "Running $command against all $type servers on $sitename :>"
      filter=$type
      if [ $type == 'web' ] || [ $type == 'staging' ] || [ $type == 'ded' ] || [ $type == 'managed' ]; then
        filter='web'
        servermatch='(web|staging|ded|managed)'
      fi
      if [ $type == 'db' ]; then
        filter='db'
        servermatch='(ded|fsdb|fsdbmesh|dbmaster)'
      fi
      pdsh -w `aht @$sitename --show=$filter | awk {'print $1'} | egrep "^${servermatch}" | sed -e 's/^[ \t]*//' | tr '\n' ','` $command
    fi

  shift $((OPTIND-1))
}

mySvnSsh() {
  ssh -o ProxyCommand="ssh -F ~/.ssh/ah_config bastion nc $2.prod.hosting.acquia.com 40506" $1@$2
}
alias sshsvn=mySvnSsh
