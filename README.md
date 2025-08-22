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

You can also install coc-pyright after you run `stow vim` by running the
following command from within vim `:CocInstall coc-pyright`

## Kitty
kitty will most likely not have its config file present. So you can just run
`stow kitty` to have configs in the system.

## TMUX
With tmux, you want to first install the themepack by running the following
command:
```
git clone https://github.com/jimeh/tmux-themepack.git ~/.tmux-themepack
```
then running `stow tmux`

## Waybar
In order for waybar's clock to work after using `stow waybar`, you need to
install extra languages. See `arch_install.md` at the `Additional Languages`
section and follow the instructions.

## Wofi
Nothing special here, simply run `stow wofi`

## MPD
First run `mkdir -p ~/.config/mpd` so new files don't get automatically added
to your git directory. Then run `stow mpd`.

## NCMPCPP
First run `mkdir -p ~/.config/ncmpcpp` so new files don't get automatically added
to your git directory. Then run `stow ncmpcpp`.

## Hyprland & Others
Backup the default hyprland.conf file, and then run `stow hyprland`, you might
need to adjust a few things based on your laptop/desktop's needs.


