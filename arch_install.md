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

Ethernet should work off the bat, so no special configuration needs to happen
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

Keep it simple and only enable `us` keyboard (which is the default)

```bash
# loadkeys us
```

### Repartition

This is the _hardest_ part in that we have to be sure of what we are doing, and
what disk we are partitioning.

Let's start by using `lsblk` to see the devices in our computer.

```
# lsblk

NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
nvme0n1     259:0    0 931.5G  0 disk
├─nvme0n1p1 259:1    0     1G  0 part /boot/efi
├─nvme0n1p2 259:2    0    36G  0 part [SWAP]
└─nvme0n1p3 259:3    0 894.5G  0 part /

# cfdisk /path/to/disk # this will be something like /dev/nvme0n1
```

`cfdisk` will help us repartition the disk, but we will format each partition
in a later step.

Within `cfdisk` we will select `[Delete]` for every existing partition in the
disk and then press the key `d` for each to make `Free space`.

After that, we will create 3 different partitions from the one `Free space`
disk, like so:

- 1G for boot partition
- 36G (or RAM plus 4G) for swap partition
- Remainder for root partition

Then simply select `[Write]` and `yes`.

Make sure to check the disk after using `cfdisk`:

```bash
# lsblk
```

Now, let's format each of the partitions

__Root Partition__

Let's use the Linux filesystem for the root partition (the biggest of them all)
```
# mkfs.ext4 /path/to/root  # something like /dev/nvme0n1p3
```

__Boot Partition__

We use FAT32 for boot partition
```
# mkfs.fat -F 32 /path/to/boot  # something like /dev/nvme0n1p1
```

__SWAP Partition__

We make swap type
```
# mkswap /path/to/swap  # something like /dev/nvme0n1p2
```

### Mount

Now that we have repartitioned the disk and change the file type for each
partition, we can mount all partitions.

First, let's mount the `root` partition, most commonly to `/mnt`
```
# mount /path/to/root /mnt
```

Second, let's mount the boot partition
```
# mkdir -p /mnt/boot/efi
# mount /path/to/boot /mnt/boot/efi
```

Finally, turn on the SWAP partition
```
# swapon /path/to/swap
```

### Installation - Pacman Packages

Now that all partitions have been mounted, you can choose all the programs to
install.

Remember to change `amd-ucode` for `intel-ucode` depending on your CPU.

```
# pacstrap /mnt base linux linux-firmware amd-ucode sof-firmware networkmanager \
    network-manager-applet base-devel grub efibootmgr git kitty firefox vim \
    zsh man-db man-pages texinfo tmux stow bluez bluez-utils blueman \
    pipewire-pulse pamixer wofi waybar nautilus hyprland tree solaar htop \
    fastfetch sed python-requests nodejs-lts-jod npm ttf-font-awesome \
    ttf-jetbrains-mono-nerd noto-fonts-emoji
```

A couple notes:

- `blueman` is the GUI for bluetooth connection
- `solaar` will help with your system not waking up from logitech's receiver

Optionally, add the following after installation, which can help with debugging
USB, keyboard, and other things

```
$ sudo pacman -S xorg-xmodmap pciutils usbutils
```

### File System Tab

Let's create the file system. First confirm the mounts are correct:
```
# genfstab /mnt
```

Then direct it to a file
```
# genfstab /mnt > /mnt/etc/fstab
```

### Enter installed system

To enter the installed system, you can use the following command

```
# arch-chroot /mnt
```

This will put us inside the new system as sudo user.

### General Configuration

Now for some configurations inside the system.

Let's start with the timezone, and sychronizing our clock
```
# ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
# hwclock --systohc
```

Then, we can get our locale added. You need to find `en_US.UTF-8 UTF-8` and
uncomment that line, and generate the locale

```
# vim /etc/locale.gen
# locale-gen
```

Let's add our language to `/etc/locale.conf` by adding the following line to
that file:
```
LANG=en_US.UTF-8
```

Finally, we can set the keymap to `us` in `/etc/vconsole.conf` by adding the
following line:
```
KEYMAP=us
```

### Hostname and add new users

You need to specify a hostname for your computer, best standard is to only use
lowercases and dashes, like `mudi-beelink` or similar.

```
$ vim /etc/hostname
```

Now give root a password,

```
# passwd
```

To create a new user, you can use the following command where `-m` creates a
home directory, `-G wheel` puts the user in the `wheel` group, and `-s`
specifies the default shell. Then create a password for it.

```
# useradd -m -G wheel -s /usr/bin/zsh user-name
# passwd user-name
```

To set up sudo priviledges on the user, you want to remove the comment on the
following line
```
%wheel ALL=(ALL:ALL) ALL
```
when you run
```
# EDITOR=vim visudo
```

Now, if you run `su user-name`, you will be able to run `sudo` commands, such
as `sudo pacman -Syu`.

### Enable Core Services

Now back in root in your system (not the bootable drive), you can enable core
services like Wifi and bluetooth

```
# systemctl enable NetworkManager
# systemctl enable bluetooth
```

### Bootloader

Lastly, you can add the bootloader to your system:

```
# grub-install /path/to/disk  # as in /dev/nvme0n1 (this is not a partition)
```

And configure grub

```
# grub-mkconfig -o /boot/grub/grub.cfg
```

### Exit and Reboot

Now we can `exit` back to the bootable drive, and then unmount all non-busy
devices and reboot:

```
# umount -a
# reboot
```

### First-time Login

Set up network using `nmcli` like so

```
# nmcli device wifi connect NetworkName --ask
```

### yay Packages

After logging in with your new user, you should install `yay`, see
https://github.com/Jguer/yay

```
# sudo pacman -S --needed git base-devel  # already from base install
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

and then install the following packages:

```
yay -S hyprshot hyprlock hyrpidle hyprpaper swaync nwg-look \
    catppuccin-gtk-theme-mocha brave-bin
```

### Dotfiles

Clone dotfiles and use `stow`, see README.md

## Dropbox Install

See https://wiki.archlinux.org/title/Dropbox

We need to install a package needed for dropbox before we can use it:

```
sudo pacman -S python-gpgme
```

We also want to remove a folder and make it read-only to preent dropbox from
consuming our CPU

```
rm -rf ~/.dropbox-dist
install -dm0 ~/.dropbox-dist
```

Then we can install dropbox and dropbox-cli with `yay`

```
yay -S dropbox dropbox-cli
```

Our hyrpland config already has an exec-once for dropbox.

## SSH Setup for Github



## Additional Languages

See the following refereces:
- [Arch Linux Wiki] Localization Japanese: https://wiki.archlinux.org/title/Localization/Japanese
- Reddit Hyprland Japanese: https://www.reddit.com/r/hyprland/comments/1fdi7cf/japanese_input/

For any new keyboard layout or language, you will want to do the following
steps

1. Check if the langauge/locale is enabled by typing `locale -a`, if they are
   not enabled, then do the rest of the steps.
2. Uncomment the relevant locales in `/etc/locale.gen` using sudo, you want to
   uncomment UTF-8 locales, like `ja_JP.UTF-8 UTF-8` and `es_ES.UTF-8 UTF-8`
```bash
$ sudo vim /etc/locale.gen
```
3. Afterwards, regenerate the locales
```
$ sudo locale-gen
```

### Japanase & Spanish

#### FCITX (Preferred)

Start by installing the relevant packages using `pacman`.
```bash
sudo pacman -S fcitx5-mozc fcitx5-configtool fcitx5-gtk adobe-source-han-sans-jp-fonts
```

Our .zshrc file already export relevant variables and hyprland starts `fcitx`,
so all you have to do is open `fcitx5-configtool` and add Mozc for Japanese
and Spanish keyboards.

You should be able to switch between languages with CTRL + SPACE.

#### Hyprland

For Spanish and possibly other similar languages, you could add the following
lines to your hyprland config file:

```
input {
    kb_layout = us,es
    kb_variant =
    kb_options = grp:alt_space_toggle
}
```
and toggle it with ALT + SPACE. However this does not work for Japanese. So
it's easier to set up everything through FCITX

## Laptop Specific Notes

For Thinkpad Laptop, use the `thinkpad-laptop` branch.

You might want to install brightnessctl, and other similar things.

## Resources

- Comfy Guide: https://www.youtube.com/watch?v=68z11VAYMS8
