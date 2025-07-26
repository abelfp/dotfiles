# Arch Install
Author: Abel Flores Prieto
Date: Thu Jul 24 04:41:10 PM PDT 2025


## Basics


## Additional Languages

See the following refereces:
- [Arch Linux Wiki] Localization Japanese: https://wiki.archlinux.org/title/Localization/Japanese
- Reddit Hyprland Japanese: https://www.reddit.com/r/hyprland/comments/1fdi7cf/japanese_input/

For any new keyboard layout or language, you will want to do the following
steps

1. Check if the langauge/locale is enabled by typing `locale -a`, if they are
   not enabled, then do the rest of the steps.
2. Uncomment the relevant locales in `/etc/locale.gen` using sudo
```bash
$ sudo vim /etc/locale.gen
```
3. Afterwards, regenerate the locales
```
$ sudo locale-gen
```

### Japanase & Spanish

#### Hyprland

For and possibly other similar languages, you could add the following lines to
your hyprland config file:
```
input {
    kb_layout = us,es
    kb_variant =
    kb_options = grp:alt_space_toggle
}
```
and toggle it with ALT + SPACE. However this does not work for Japanese. So
it's easier to set up everything through FCITX

#### FCITX

Start by isntalling the relevant packages using `pacman`.
```bash
sudo pacman -S fcitx5-mozc fcitx5-configtool fcitx5-gtk adobe-source-han-sans-jp-fonts
```

Our .zshrc file already export relevant variables and hyprland starts `fcitx`,
so all you have to do is open `fcitx5-configtool` and add Mozc for Japanese
and Spanish keyboards.

You should be able to switch between languages with CTRL + SPACE.

## Laptop Specific Notes

For Thinkpad Laptop, use the `thinkpad-laptop` branch.

You might want to install brightnessctl, and other similar things.

## Resources
