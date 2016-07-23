# set git completion
#source /usr/local/Cellar/git/2.8.1/.git-completion.sh

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
if [ -d "/Users/erik.peterson/Acquia/Support-Tools/bin" ] ; then
    export PATH="/Users/erik.peterson/Acquia/Support-Tools/bin:$PATH"
fi
export PATH="$HOME/.composer/vendor/bin:/usr/local/sbin:$PATH"
export PATH="/Users/erik.peterson/.phpenv/bin:$PATH"
export PATH="/Users/erik.peterson/Library/Python/2.7/bin:$PATH"
eval "$(phpenv init -)"

# include AH profile
if [ -f ~/.ah_profile ]; then
  . ~/.ah_profile
fi

# New svn command to allow Support Tools config to have svn ssh command uninterrupted
mySvnSsh() {
  ssh -o ProxyCommand="ssh -F ~/.ssh/ah_config bastion nc $2.prod.hosting.acquia.com 40506" $1@$2
}
alias sshsvn=mySvnSsh

alias assh='ssh -F $HOME/.ssh/ah_config'
alias pj='python -m json.tool'
alias GET='curl -XGET -s -D - -o /dev/null'
alias ocurl='curl -vvs -u erik.peterson:ABC1234'

powerline_path=$(python -c 'import pkgutil; print pkgutil.get_loader("powerline").filename' 2>/dev/null)
  if [[ "$powerline_path" != "" ]]; then
    source ${powerline_path}/bindings/bash/powerline.sh
  else
    # Setup your normal PS1 here.
    PS1="\n\W\$(__git_ps1) \$ "
  fi

function blt() {
  if [ "`git rev-parse --show-cdup 2> /dev/null`" != "" ]; then
    GIT_ROOT=$(git rev-parse --show-cdup)
  else
    GIT_ROOT="."
  fi

  if [ -f "$GIT_ROOT/blt.sh" ]; then
    $GIT_ROOT/blt.sh "$@"
  else
    echo "You must run this command from within a BLT-generated project repository."
  fi
}

# start up rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

function livegit() {
while :
do
    clear
    git --no-pager log --graph --pretty=oneline --abbrev-commit --decorate --all $*
    sleep 1
done
}
