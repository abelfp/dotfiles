# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# TODO: if .oh-my-zsh folder is missing, run the installation
# Install oh-my-zsh
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Find user's home directory
current_user="$(whoami)"
home_dir="$(grep $current_user /etc/passwd | cut -d ":" -f6)"

# Path to your oh-my-zsh installation.
export ZSH="$(echo $home_dir)/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="abelfpmortalscumbag"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
#
# To install zsh-autosuggestions
# TODO: if folder is missing, run git clone
# git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
plugins=(git tmux vi-mode zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh
# User configuration
# The following lines were added by compinstall
zstyle :compinstall filename $home_dir/.zshrc
autoload -Uz compinit
compinit
# end of compinstall

export EDITOR='vim'

# git aliases
alias git-log='git --no-pager log --graph --pretty="%Cred%h%Creset %C(bold blue)<%an>%Creset %Cgreen(%ad)%Creset -%C(auto)%d%Creset %s" --date=short'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

export LESS="-F -X $LESS"
export LESS="$LESS --no-vbell -R -Q"

# Add date and time to right side of prompt
RPROMPT="[%D{%f/%m/%y} | %D{%H:%M:%S}]"

# export the local bin folder
export PATH="/home/abelfp/bin:$PATH"
# for japanese language
# export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

if [ "$(tty)" = "/dev/tty1" ]; then
  exec Hyprland
fi
