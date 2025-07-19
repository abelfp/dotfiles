# dotfiles

The way files are stored in this package, it is expected that you run
individual commands at a time, e.g. `stow vim` or `stow zsh` as opposed to
running `stow .` which will not create the appropriate sim links in your
system.

## ZSH
For ZSH, we will need to first run a few things before we can get a new system
started. You will need to install oh-my-zsh and autosuggestions using the
following commands:

```
# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# install autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```
After that, you should delete your ~/.zshrc file or make a copy if you'd like
and then run `stow zsh`.

## VIM
Before running `stow vim`, first run `vim -u ~/dotfiles/vim/.vimrc` so all
plugins are installed, and ~/.vim is created. Then run the stow command.
