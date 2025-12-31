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

```bash
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
disk and you might need to press the key `d` for each to make `Free space`
(this last part can vary between systems).

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
```bash
# mkfs.ext4 /path/to/root  # something like /dev/nvme0n1p3
```

__Boot Partition__

We use FAT32 for boot partition
```bash
# mkfs.fat -F 32 /path/to/boot  # something like /dev/nvme0n1p1
```

__SWAP Partition__

We make swap type
```bash
# mkswap /path/to/swap  # something like /dev/nvme0n1p2
```

### Mount

Now that we have repartitioned the disk and change the file type for each
partition, we can mount all partitions.

First, let's mount the `root` partition, most commonly to `/mnt`
```bash
# mount /path/to/root /mnt
```

Second, let's mount the boot partition
```bash
# mkdir -p /mnt/boot/efi
# mount /path/to/boot /mnt/boot/efi
```

Finally, turn on the SWAP partition
```bash
# swapon /path/to/swap
```

### Installation - Pacman Packages

Now that all partitions have been mounted, you can choose all the programs to
install.

Remember to change `amd-ucode` for `intel-ucode` depending on your CPU.

```bash
# pacstrap /mnt base linux linux-firmware amd-ucode sof-firmware networkmanager \
    network-manager-applet base-devel grub efibootmgr git kitty firefox vim \
    zsh man-db man-pages texinfo tmux stow bluez bluez-utils blueman rsync \
    pipewire-pulse pamixer wofi waybar nautilus hyprland mpd mpc ncmpcpp tree \
    solaar htop fastfetch sed python-requests nodejs-lts-jod npm cheese \
    pavucontrol bluez-obexqv ttf-font-awesome ttf-jetbrains-mono-nerd \
    noto-fonts-emoji
```

For laptops, you might want to install the following packages as well:

- brightnessctl
- power-profiles-daemon

A couple notes:

- `blueman` is the GUI for bluetooth connection
- `bluez-obex` will allow you to send files through bluetooth after pairing
- `solaar` will help with your system not waking up from logitech's receiver

Optionally, add the following after installation, which can help with debugging
USB, keyboard, and other things

```bash
sudo pacman -S xorg-xmodmap pciutils usbutils
```

### File System Tab

Let's create the file system. First confirm the mounts are correct:
```bash
# genfstab /mnt
```

Then direct it to a file
```bash
# genfstab /mnt > /mnt/etc/fstab
```

### Enter installed system

To enter the installed system, you can use the following command

```bash
# arch-chroot /mnt
```

This will put us inside the new system as sudo user.

### General Configuration

Now for some configurations inside the system.

Let's start with the timezone, and sychronizing our clock
```bash
ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
hwclock --systohc
```

Then, we can get our locale added. You need to find `en_US.UTF-8 UTF-8` and
uncomment that line, and generate the locale

```bash
vim /etc/locale.gen
locale-gen
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

```bash
vim /etc/hostname
```

Now give root a password,

```bash
passwd
```

To create a new user, you can use the following command where `-m` creates a
home directory, `-G wheel` puts the user in the `wheel` group, and `-s`
specifies the default shell. Then create a password for it.

```bash
useradd -m -G wheel -s /usr/bin/zsh user-name
passwd user-name
```

To set up sudo priviledges on the user, you want to remove the comment on the
following line
```
%wheel ALL=(ALL:ALL) ALL
```
when you run
```bash
EDITOR=vim visudo
```

Now, if you run `su user-name`, you will be able to run `sudo` commands, such
as `sudo pacman -Syu`.

### Enable Core Services

Now back in root in your system (not the bootable drive), you can enable core
services like Wifi and bluetooth

```bash
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable sshd
```

If you installed other packages, like power-profiles-daemon, you can start the
service now:
```bash
systemctl enable power-profiles-daemon
```

### Bootloader

Lastly, you can add the bootloader to your system:

```bash
grub-install /path/to/disk  # as in /dev/nvme0n1 (this is not a partition)
```

And configure grub

```bash
grub-mkconfig -o /boot/grub/grub.cfg
```

### Exit and Reboot

Now we can `exit` back to the bootable drive, and then unmount all non-busy
devices and reboot:

```bash
# umount -a
# reboot
```

### First-time Login

Set up network using `nmcli` like so

```bash
nmcli device wifi connect NetworkName --ask
```


Maybe also disable Wi-Fi power savings for faster internet?

Add the following to `/etc/NetworkManager/conf.d/wifi-powersave.conf`
```
[connection]
wifi.powersave = 2
```
and restart NetworkManager.

Update system

```bash
pacman -Syu
```

Also let's make sure to enable `mpd` for our user

```bash
systemctl --user enable mpd
```

### yay Packages

After logging in with your new user, you should install `yay`, see
https://github.com/Jguer/yay

```bash
sudo pacman -S --needed git base-devel  # already from base install
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

and then install the following packages:

```bash
yay -S hyprshot hyprlock hyrpidle hyprpaper hyprsunset swaync nwg-look \
    catppuccin-gtk-theme-mocha brave-bin gcalcli
```

Use `nwg-look` or `GTK Settings` to change color scheme and other things.

### Dotfiles

Clone dotfiles and use `stow`, see README.md

## SSH Setup for Github
In order to set up SSH for github, we need to generate our ssh keys and add
it with `ssh-add`:

```bash
ssh-keygen -t ed25519 -C "emailAddress"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

Then in Github, we need to creater an ssh key/setting and add the contents of
`~/.ssh/id_ed25519.pub`

To test it, simply try the following command
```bash
ssh -T git@github.com
```

I also added the following to `~/.ssh/config`
```
Host *
    AddKeysToAgent yes
    IdentityFile ~/.ssh/id_ed25519
```

You will also need to set up gloabl configs for git, like so:
```bash
git --global user.email "emailAddress"
git --global user.name "FullName"
```

If you initially cloned a repository with https, then you can change it to use
ssh with the following command
```bash
git remote set-url origin git@github.com:userName/packageName.git
```

Note: It might be a good idea to see how you can use `pass` to store ssh key
passphrase.
Or see https://www.lorenzobettini.it/2023/09/hyprland-and-ssh-agent/

## Hibernation

I did not look into using hibernation much. Hyprland doesn't seem to work out
of the box with hibernation, but suspend does, so I am relying on suspend.

## Dropbox Install

See https://wiki.archlinux.org/title/Dropbox

We need to install a package needed for dropbox before we can use it:

```bash
sudo pacman -S python-gpgme
```

We also want to remove a folder and make it read-only to preent dropbox from
consuming our CPU

```bash
rm -rf ~/.dropbox-dist
install -dm0 ~/.dropbox-dist
```

Then we can install dropbox and dropbox-cli with `yay`

```bash
yay -S dropbox dropbox-cli
```

Our hyrpland config already has an exec-once for dropbox, but you might want to
run the following command for good measure:
```bash
dropbox-cli autostart y
```


## Neomutt and mutt-wizard

```bash
yay -S goimapnotify lynx abook notmuch urlview mutt-wizard
```

Follow mutt-wizard instructions, you will need to create a new pgp key:
```bash
gpg --full-gen-key
pass init yourgpgemail
```

Then we can use `mw -a emailAccount -n "Full Name"` to add each account (you
will be prompted for the password).

Then we can use `mbsync emailAccount` and get all of our email. This will take
a while.

To enable notification, you will want to create a config file per email address
and store them under `~/.config/imapnotify/emailAddress.yaml`:

```json
{
  "host": "imap.gmail.com",
  "port": 993,
  "tls": true,
  "tlsOptions": {
    "rejectUnauthorized": false
  },
  "username": "username@gmail.com",
  "password": "",
    "passwordCmd": "pass username@gmail.com | head -n1",
  "onNewMail": "mailsync",
  "onNewMailPost": "",
  "boxes": [ "INBOX" ]
}
```

Then enable and start one of the services (only one synce `mbsync` can't run
multiple times at the same time):
```bash
systemctl --user enable goimapnotify@emailAddress.service
systemctl --user start goimapnotify@emailAddress.service
systemctl --user status goimapnotify@emailAddress.service
```

We can also look into installing `imagemagick` to see images inside neomutt.

Maybe after all of that, we can do `notmuch setup`.

Use `mailsync` to get mail afterwards.

Update `~/.gnupg/gpg-agent.conf` to cache passwords for 7 days:
```
default-cache-ttl 604800
max-cache-ttl 604800
```

### Useful Neomutt and Email-Related Commands


## Google Calendar

```bash
yay -S gcalcli
```

Follow instructions: https://github.com/insanum/gcalcli

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
sudo vim /etc/locale.gen
```
3. Afterwards, regenerate the locales
```bash
sudo locale-gen
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

Keyboards:
- Keyboard - Spanish
- Mozc

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

## Obtaining Media

You can use `yt-dlp` to obtain media. You can download it using `pacman` like
so
```bash
sudo pacman -S ffmpeg yt-dlp  # ffmpeg might be needed for some file types
```

You can run it like this
```bash
yt-dlp -x -f bestaudio --embed-metadata 'URL' -o '~/path/to/dir/%(title)s.%(ext)s'
```

## Music Player Daemon - Play Count

After installing mpd and ncmpcpp, you can install the following project to
create a playcount of each song, and even add rating.

https://github.com/sp1ff/mpdpopm?tab=readme-ov-file#building-from-source

Make sure you have defined a sticker database in your mpd dotfile.

You can follow the Building from source section since the AUR package seems to
be outdated. After installing it, you need to run the following:

```bash
mppopmd -v -F  # and play a song, you'll see the play count be updated
```

You can then verify that the playcount has been updated by running

```bash
mppopm get-pc path/to/song
```

Then you can start the service as a user:
```bash
systemctl --user start mppopmd.service
systemctl --user enable mppopmd.service
```

Then you can use `mppopm` to add songs to the queue based on the number of
times a song has been played, like so:

```bash
mppopm findadd "(playcount == 0)"
mppopm findadd "(artist =~ \"green\") and (playcount > 0)" # multiple filters
```

## PDF Viewer

Follow: https://wiki.archlinux.org/title/Zathura

```bash
sudo pacman -S zathura zathura-pdf-poppler
```

Set Zathura as the default pdf viewer:
```bash
ls /usr/share/applications/org.pwmt.zathura.desktop
xdg-mime default org.pwmt.zathura.desktop application/pdf
```

## Connecting Android
See https://wiki.archlinux.org/title/Media_Transfer_Protocol

```bash
sudo pacman -S android-file-transfer
aft-mtp-mount ~/mnt_point
```

## Printer & Scanner

In order to get the printer to work, we need to install
[CUPS](https://wiki.archlinux.org/title/CUPS) and the HP libraries to set up
the printer:
```bash
sudo pacman -S cups hplip
```

This should also install ghostscript, if not install it too.

Then you can setup your HP printer by running the following:
```bash
hp-setup -i ip_address
```
You can look up the printer's IP address by going to http://localhost:631/admin
and signing in as your user, and starting to set up the printer.

For the scanner, simply install the following packages
```bash
sudo pacman -S sane-airscan simple-scan
```
You can use the GUI Simple Scan for scanning.

## Resources

- Comfy Guide: https://www.youtube.com/watch?v=68z11VAYMS8
