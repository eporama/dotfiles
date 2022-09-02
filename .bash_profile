if [ -x /usr/libexec/path_helper ]; then
  PATH=""
  eval $(/usr/libexec/path_helper -s)
fi

export PATH=/opt/homebrew/opt/openssl@3/bin:$PATH
export PATH="$HOME/.phpenv/bin:vendor/bin:../vendor/bin:$PATH"
export PATH="$HOME/.composer/vendor/bin:/usr/local/sbin:$PATH"
export PATH="$HOME/.symfony/bin:$PATH"

export HOMEBREW_EDITOR="/usr/local/bin/atom"
export EDITOR="/usr/bin/vi"
export LS_COLORS="no=00:fi=00:di=00;34:ln=00;36:pi=40;33:so=00;35:bd=40;33;01:ex=00;35"
export BASH_SILENCE_DEPRECATION_WARNING=1
export COMPOSER_MEMORY_LIMIT=-1
export HOMEBREW_NO_ENV_HINTS=1

if [ -d /opt/homebrew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  [[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"
else
  eval "$(/usr/local/bin/brew shellenv)"
  [[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
fi

eval "$(phpenv init -)"

# include AH profile
if [ -f ~/.ah_profile ]; then
  . ~/.ah_profile
fi

alias GET='curl -XGET -s -D - -o /dev/null'
alias tbl='column -s $'\''\t'\'' -t'
alias please='sudo'

function _update_ps1() {
    PS1=$(powerline-shell $?)
}
if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi

function wtree() {
  while :; do clear; tree -a; sleep 1; done
}

function livegit() {
  while :
  do
      clear
      git --no-pager log --graph --pretty=oneline --abbrev-commit --decorate --all $*
      sleep 1
  done
}

function sslcheck() {
  echo "" | openssl s_client -connect $@:443 -servername $@ 2> /dev/null |  openssl x509 -noout  -dates -ext subjectAltName | egrep "DNS|not[Before|After]" | sed -e 's/^[[:space:]]*//'
}

function notify() {
  v=$(acli api:notifications:find $1| jq -r '.status'); while [ $v == "in-progress" ]; do echo -n "not yet: "; date; v=$(acli api:notifications:find $1| jq -r '.status');sleep 60;done; echo "${v}"
}
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

function db-import { 
  size=$(gzip -l $1 | awk 'NR==2 { print $2 }') && gzip -d -c $1 | pv -s $size | mysql -u root $2 ;
}

# YouTube Preview
function ytp {
  curl -Ls "$1" | htmlq -t title
}

# Brew update and phpenv update
function bup {
  brew update && brew upgrade --greedy && phpenv_update
}
