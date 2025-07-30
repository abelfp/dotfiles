# Arch Install
Author: Abel Flores Prieto
Date: Thu Jul 24 04:41:10 PM PDT 2025


## Installation

In this section, I will cover the basic installation steps I took to install
arch linux on my beelink mini pc. These steps should work with other laptops
or computers (with no dual booting).

I am assuming that you already have a bootable USB flashdrive with the Arch
Linux ISO.

### Windows
**IMPORTANT**: Disable Fast-Start and Hibernation on Windows!

- Fast-Start: Control-Panel -> Power Options -> Choose what the power button
  does -> Turn off Fast-Start (and Hibernation)
- Hibernation: Open cmd as admin, and execute `powercfg.exe /hibernate off`
- Restart computer

### Internet

Ethernet should work off the bat, so special configuration needs to happen
there. For Wifi connections, you can use `iwctl` to connect to the network:

```bash
# iwctl
[iwd] # station wlan0 show
[iwd] # station wlan0 scan
[iwd] # station wlan0 connect NetworkName
[iwd] # exit
```

To test the connection after you have successfully connected, try pinging a
website, e.g. `ping archlinux.org`

### Keyboard

## SSH Setup for Github

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
