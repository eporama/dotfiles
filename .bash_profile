if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

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

function db-import { size=$(gzip -l $1 | awk 'NR==2 { print $2 }') && gzip -d -c $1 | pv -s $size | mysql -u root $2 ; }

# set PATH so it includes Support-Tools bin, composer and phpenv
export PATH="/usr/local/opt/openssl/bin:$PATH"
export PATH="$HOME/.composer/vendor/bin:/usr/local/sbin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/Library/Python/2.7/bin:$PATH"
export HOMEBREW_EDITOR="/usr/local/bin/atom"
export EDITOR="/usr/bin/vi"

# include AH profile
if [ -f ~/.ah_profile ]; then
  . ~/.ah_profile
fi

alias pj='python -m json.tool'
alias GET='curl -XGET -s -D - -o /dev/null'
alias ocurl='curl -vvs -u erik.peterson:ABC1234'
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

export LS_COLORS="no=00:fi=00:di=00;34:ln=00;36:pi=40;33:so=00;35:bd=40;33;01:ex=00;35"

export PATH="$HOME/.phpenv/bin:$PATH"
export BASH_SILENCE_DEPRECATION_WARNING=1

eval "$(phpenv init -)"
function blt() {
  if [[ ! -z ${AH_SITE_ENVIRONMENT} ]]; then
    PROJECT_ROOT="/var/www/html/${AH_SITE_GROUP}.${AH_SITE_ENVIRONMENT}"
  elif [ "`git rev-parse --show-cdup 2> /dev/null`" != "" ]; then
    PROJECT_ROOT=$(git rev-parse --show-cdup)
  else
    PROJECT_ROOT="."
  fi

  if [ -f "$PROJECT_ROOT/vendor/bin/blt" ]; then
    $PROJECT_ROOT/vendor/bin/blt "$@"

  # Check for local BLT.
  elif [ -f "./vendor/bin/blt" ]; then
    ./vendor/bin/blt "$@"

  else
    echo "You must run this command from within a BLT-generated project."
    return 1
  fi
}
