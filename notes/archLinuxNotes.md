# Arch Linux Notes

The purpose of these notes is to document useful commands and factoids
most of which can be done without root or sudo access.

## Journalctl

For scanning journalctl output, some useful options,

* `journalctl -f     # follows like tail -f`
* `journalctl -x     # augment log lines with explanation texts`
* `journalctl -b     # since last boot`
* `journalctl -b -1  # previous boot`
* `journalctl -b 20  # 20th boot`

System maintenance,

* `journalctl -p 3 -xb  # Look for high priority errors since last boot`

## Systemctl

Poweroff or restart system,

* `systemctl poweroff`
* `systemctl reboot`

System maintenance,

* `systemctl --failed`

## Pacman

System maintenance, add and remove software.

* `sudo pacman -Syu` (*upgrade software on system*)
  * `-y, --refresh` (*download fresh package list*)
  * `-u, --sysupgrade` (*upgrade all packages that are out of date*)
* `sudo pacman -Syuw` (*download packages without installing*)
* `sudo pacman -Syu <pkg>` (*upgrade system and install package*)
* `sudo pacman -S <pkg>` (*install package based on current package list*)
* `sudo -Rsc <pkg>` (*uninstall package, dependencies, & dependent packages*)
  * `-s, --recursive`
  * `-c, --cascade`
* `sudo -Rsu <pkg1> <pkg2>` (*Remove targets and uneeded dependencies*)
  * `-u, --uneeded`
* `sudo -R <pkg>` (*just uninstall the package*)
* `sudo -Rs <pkg>` (*uninstall package & dependencies*)
  * `sudo pacman -Rs $(pacman -Qdtq)` (*Uninstall unneeded packages*)
  * `sudo pacman -Rns $(pacman -Qdtq)` (*Same as above, don't create .pacsave files*)

Search for packages, groups and descriptions,

* `pacman -Qs <regex>` (*search against local package database*)
* `pacman -Ss <regex>` (*search against synced remote package database*)

Get information on packages,

* `pacman -Qi <pkg>` (*use local package database*)
* `pacman -Qii <pkg>` (*also include denendency and required by info*)
* `pacman -Si <pkg>` (*use synced (remote) package database*)
* `pacman -Sii <pkg>` (*also include denendency and required by info*)
* `pacman -Qlq <pkg>` *list files associated with a package, use local database*)
* `pacman -Flq <pkg>` (*list files associated with a package, use synced databases*)

Get package group information,

* `pacman -Qg`
* `pacman -Sg`
* `pacman -Qg <grp>` (*list packages in group, use local database*)
* `pacman -Sg <grp>` (*list packages in group, use synced database*)
* `pacman -Qg | cut -f1 -d\  | uniq | sort` (*list names of groups in local database*)
* `pacman -Sg | cut -f1 -d\  | uniq | sort` (*list names of groups in synced database*)`

Find the package which owns a particular installed file,

* `pacman -Qo </full/path/to/file>`
* `pacman -Qoq </full/path/to/file>`

Query local package DB,

* `pacman -Q` (*list all installed packages*)
* `pacman -Qe` (*list all explicitly installed packages*)
* `pacman -Qet` (*  not reqired by other packages*)
* `pacman -Qdt` (*list unneeded, orphaned packages*)
  * `-d, --deps` (*packages installed as dependencies*)
  * `-t, --unrequired` (*packages not required nor optionally required*)
  * `-q, --quiet` (*omit version numbers, useful in scripts*)
* `pacman -Qmq` (*list all foreign, usually AUR, packages*)
* `pacman -Qnq` (*list all packages from the standard repos*)
* `pactree <pkg>` (*packages package depends on, -c for colorization*)
* `pactree -r <pkg>` (*packages depending on the package*)
* `pactree -u <pkg>` (*list packages package depends on, only once*)
* `pactree -ru <pkg>` (*list packages depending on package, only once*)

Locations of config and log files

* Pacman logs stored here: /var/log/pacman.log
* Pacman configuration: /etc/pacman.conf
* Pacman mirrors: /etc/pacman.d/mirrorlist

## Building via AUR

1. acquire tarball or clone via GIT
1. untar or clone in directory you want to build in, I use ~/build/AUR/ for these
1. verify that the PKGBUILD and accompanying files are not malicious or untrustworthy
1. run command: makepkg -sri

## Memory management

  Arch likes to cache disk space in memory

```
    $ free -h
                   total        used        free      shared  buff/cache   available
    Mem:            15Gi       1.7Gi        11Gi       127Mi       2.0Gi        13Gi
    Swap:           15Gi          0B        15Gi
```

## Hostnamectl

Get info on an Arch System,

```
   $ hostnamectl
      Static hostname: gauss17
            Icon name: computer-laptop
              Chassis: laptop
           Machine ID: <snip>
              Boot ID: <snip>
     Operating System: Arch Linux
               Kernel: Linux 5.4.15-arch1-1
         Architecture: x86-64
```

Other ways,

```
   $ pacman -Q | grep '^linux '
   linux 5.4.15.arch1-1

   $ uname -r
   5.4.15-arch1-1

   $ uname -a
```

## Loginctl

```
   $ loginctl
   SESSION  UID USER  SEAT  TTY
         2 1000 geoff seat0 tty2
         4 1000 geoff       pts/3
         5 1002 jd    seat0 tty4
         7 1001 jb    seat0 tty5
        c1  120 gdm   seat0 tty1

   $ loginctl show-session 2 -p Type
   Type=x11

   $ loginctl show-session 4
   Id=4
   User=1000
   Name=geoff
   Timestamp=Sun 2020-02-02 12:05:58 MST
   TimestampMonotonic=67119046169
   VTNr=0
   TTY=pts/3
   Remote=yes
   RemoteHost=::1
   Service=sshd
   Scope=session-4.scope
   Leader=16779
   Audit=4
   Type=tty
   Class=user
   Active=yes
   State=active
   IdleHint=no
   IdleSinceHint=1580670778717714
   IdleSinceHintMonotonic=67539111506
   LockedHint=no

   $ loginctl show-user geoff
   UID=1000
   GID=1000
   Name=geoff
   Timestamp=Sat 2020-02-01 17:27:43 MST
   TimestampMonotonic=23966084
   RuntimePath=/run/user/1000
   Service=user@1000.service
   Slice=user-1000.slice
   Display=2
   State=active
   Sessions=4 2
   IdleHint=no
   IdleSinceHint=1580659420065201
   IdleSinceHintMonotonic=56180458994
   Linger=no
```

## DNSUTILS replacements

For a while, no longer had nslookup, dig, and host.  These are back
via the extra/bind package, which replaces core/bind-utils.

* From the core/ldns package, drill replaces dig and hosts.
* From the core/glibc package, getent replaces nslookup.

```
   $ getent hosts 8.8.8.8
   8.8.8.8         google-public-dns-a.google.com

   $ getent hosts dns1.fast.net
   205.147.200.114 dns1.corp.fast.net dns1.fast.net

   $ getent hosts www.fast.net
   64.80.108.108   www.fast.net

   $ getent hosts www.google.comm; echo $?
   2

   $ drill dns1.fast.net
   ;; ->>HEADER<<- opcode: QUERY, rcode: NOERROR, id: 6512
   ;; flags: qr rd ra ; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 0
   ;; QUESTION mount - mount a filesystemSECTION:
   ;; dns1.fast.net. IN A

   ;; ANSWER SECTION:
   dns1.fast.net.        86400   IN  CNAME   dns1.corp.fast.net.
   dns1.corp.fast.net.   86400   IN  A       205.147.200.114

   ;; AUTHORITY SECTION:

   ;; ADDITIONAmount - mount a filesystemL SECTION:

   ;; Query time: 414 msec
   ;; SERVER: 192.168.0.1
   ;; WHEN: Thu Jul  6 17:54:18 2017
   ;; MSG SIZE  rcvd: 71
```

## Disk partitian grokking

Between these three commands,

* parted - a partition manipulation program
* blkid - locate/print block device attributes
* mount - mount a filesystem

You can reverse engineer your disk drives and how
they are are carved up using these commands,

```
   $ sudo parted --list
   $ mount | grep '^/dev/'
   $ blkid
   $ lsblk -f
   $ df -hT
```

What types of partitians do you have?

```
  $ df -hT
  Filesystem     Type      Size  Used Avail Use% Mounted on
  dev            devtmpfs  7.8G     0  7.8G   0% /dev
  run            tmpfs     7.8G  1.5M  7.8G   1% /run
  /dev/sda2      ext4      117G   74G   38G  67% /
  tmpfs          tmpfs     7.8G     0  7.8G   0% /dev/shm
  tmpfs          tmpfs     7.8G  4.0K  7.8G   1% /tmp
  /dev/sda1      vfat      511M   95M  417M  19% /boot
  /dev/sdb4      ext4      839G   65G  731G   9% /home
  /dev/sdb2      ext4       63G   14G   47G  23% /extra
  tmpfs          tmpfs     1.6G  148K  1.6G   1% /run/user/1003
  /dev/sdc1      ext4       73G   14G   56G  20% /run/media/grs/60844d50-85ac-42fd-b848-2591be3c7fd0

  $ mount | grep '^/dev'
  /dev/sda2 on / type ext4 (rw,relatime)
  /dev/sda1 on /boot type vfat (rw,relatime,fmask=0022,dmask=0022,codepage=437,
      iocharset=iso8859-1,shortname=mixed,utf8,errors=remount-ro)
  /dev/sdb4 on /home type ext4 (rw,relatime,data=ordered)
  /dev/sdb2 on /extra type ext4 (rw,relatime,data=ordered)
  /dev/sdc1 on /run/media/grs/60844d50-85ac-42fd-b848-2591be3c7fd0 type ext4
      (rw,nosuid,nodev,relatime,uhelper=udisks2)

  $ lsblk -f
  NAME   FSTYPE FSVER LABEL UUID                                 FSAVAIL FSUSE% MOUNTPOINT
  sda
  ├─sda1 vfat   FAT32       A024-8139                             416.8M    18% /boot
  └─sda2 ext4   1.0         0859da7c-f429-470d-818f-d3951b5d89af   37.2G    63% /
  sdb
  ├─sdb1 vfat   FAT32       BC00-6365
  ├─sdb2 ext4   1.0         4b1b0623-c1d0-4da9-8164-20ee74253def     46G    21% /extra
  ├─sdb3 swap   1           a5945738-343f-4cfb-ad76-8ca012eb2576                [SWAP]
  └─sdb4 ext4   1.0         833c2579-bc84-463a-96a4-89478bd89e9e  730.7G     8% /home
  sdc
  └─sdc1 ext4   1.0         60844d50-85ac-42fd-b848-2591be3c7fd0     56G    18% /run/media/grs/6

  $ sudo parted --list
  Model: ATA Patriot Torch II (scsi)
  Disk /dev/sda: 128GB
  Sector size (logical/physical): 512B/512B
  Partition Table: gpt
  Disk Flags:

  Number  Start   End    Size   File system  Name  Flags
   1      1049kB  538MB  537MB  fat32              boot, esp
   2      538MB   128GB  127GB  ext4


  Model: ATA WDC WD10JPVX-22J (scsi)
  Disk /dev/sdb: 1000GB
  Sector size (logical/physical): 512B/4096B
  Partition Table: gpt
  Disk Flags:

  Number  Start   End     Size    File system     Name  Flags
   1      1049kB  538MB   537MB   fat32                 boot, esp
   2      538MB   68.7GB  68.2GB  ext4
   3      68.7GB  85.9GB  17.2GB  linux-swap(v1)        swap
   4      85.9GB  1000GB  914GB   ext4


  Model: SAMSUNG HM080HI (scsi)
  Disk /dev/sdc: 80.0GB
  Sector size (logical/physical): 512B/512B
  Partition Table: gpt
  Disk Flags:

  Number  Start   End     Size    File system  Name     Flags
   1      1049kB  80.0GB  80.0GB  ext4         primary
```

  Note that df -T and mount command report fuseblk instead of
  underlying NTFS filesystems.  FUSE (Filesystem in USEr space)
  filesystem can in principle access filesystems unknown to
  the Linux Kernel.  (FUSE has long since been folded into the
  Linux Kernel)

## Time management

```
   $ timedatectl
                  Local time: Wed 2020-07-22 08:56:06 EDT
              Universal time: Wed 2020-07-22 12:56:06 UTC
                    RTC time: Wed 2020-07-22 12:56:06
                   Time zone: America/New_York (EDT, -0400)
   System clock synchronized: yes
                 NTP service: active
             RTC in local TZ: no
```

Last line shows that HW clock, "real time clock," is not local time.
The timedatectl manpage recommends NOT to set HW clock to local time.

Reset the timezone to East Coast.

```
   $ timedatectl list-timezones | grep America/Ne
   America/New_York
   $ sudo timedatectl set-timezone America/New_York
```

To check if hardware clock is set to UTC time,

```
   $ sudo hwclock --verbose
   hwclock from util-linux 2.35
   System Time: 1580671267.025714
   Trying to open: /dev/rtc0
   Using the rtc interface to the clock.
   Last drift adjustment done at 1498353865 seconds after 1969
   Last calibration done at 1498353865 seconds after 1969
   Hardware clock is on UTC time
   Assuming hardware clock is kept in UTC time.
   Waiting for clock tick...
   ...got clock tick
   Time read from Hardware Clock: 2020/02/02 19:21:08
   Hw clock time : 2020/02/02 19:21:08 = 1580671268 seconds since 1969
   Time since last adjustment is 82317403 seconds
   Calculated Hardware Clock drift is 0.000000 seconds
   2020-02-02 12:21:06.997828-07:00
```

This shows HW clock is actually kept in UTC time.
