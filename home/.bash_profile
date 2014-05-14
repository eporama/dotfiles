# set git completion
#source ~/.git-completion.sh

PS1="\W\$(__git_ps1) \$ "

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
function db-import { size=$(gzip -l $1 | awk 'NR==2 { print $2 }') && gzip -d -c $1 | pv -s $size | mysql -u root $2 ; }

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

# set PATH so it includes Support-Tools bin
if [ -d "/Users/erik.peterson/Acquia/Support-Tools/bin" ] ; then
    export PATH="/Users/erik.peterson/Acquia/Support-Tools/bin:$PATH"
fi

# set bastion function to use
function bastion { mywik ; }


# set ahtools autocomplete
complete -W '$(/Users/erik.peterson/Acquia/Support-Tools/aht --autocomplete)' aht

export PATH="$HOME/.composer/vendor/bin:$PATH"
