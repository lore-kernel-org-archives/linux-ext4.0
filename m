From: Enrico Mioso <mrkiko.rs@gmail.com>
Subject: Bug in mount options handling in EXT4?
Date: Thu, 5 Feb 2015 04:22:17 +0100 (CET)
Message-ID: <alpine.LNX.2.03.1502050418390.11412@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello guys.
I noticed from some time, that I can make mount options accumulate simply 
continously repeating them.
By typing:
sudo mount -t ext4 -o rw,noatime,nobarrier,nobarrier,nobarrier, ...
I can get:
$ dmesg | tail
[  216.075581] EXT4-fs (sdb): mounted filesystem without journal. Opts: nobarrier
[  472.851105] snd_hda_intel 0000:00:1b.0: IRQ timing workaround is activated for card #0. Suggest a bigger bdl_pos_adj.
[41950.250515] EXT4-fs (sdc1): re-mounted. Opts: nobarrier,nobarrier
[42093.049879] EXT4-fs (sdc1): re-mounted. Opts: nobarrier,nobarrier
[42095.673967] EXT4-fs (sdc1): re-mounted. Opts: nobarrier,nobarrier
[42095.954595] EXT4-fs (sdc1): re-mounted. Opts: nobarrier,nobarrier
[42096.220220] EXT4-fs (sdc1): re-mounted. Opts: nobarrier,nobarrier
[42103.212371] EXT4-fs (sdc1): re-mounted. Opts: nobarrier,nobarrier,nobarrier
[42128.137609] EXT4-fs (sdc1): re-mounted. Opts: nobarrier,nobarrier,nobarrier,nobarrier,nobarrier,nobarrier,nobarrier
[42144.960612] EXT4-fs (sdc1): re-mounted. Opts: nobarrier,nobarrier,nobarrier,nobarrier,nobarrier,nobarrier,nobarrier,nobarrier,nobarrier,nobarrier,nobarrier,nobarrier,nobarrier

But the problem seems limited to the filesystem messages / something like that:
$ cat /proc/mounts
/dev/root / ext4 rw,noatime,nobarrier 0 0
devtmpfs /dev devtmpfs rw,relatime,size=252428k,nr_inodes=63107,mode=755 0 0
sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
tmpfs /dev/shm tmpfs rw,nosuid,nodev 0 0
devpts /dev/pts devpts rw,nosuid,noexec,relatime,gid=5,mode=620 0 0
tmpfs /run tmpfs rw,nosuid,nodev,mode=755 0 0
tmpfs /sys/fs/cgroup tmpfs ro,nosuid,nodev,noexec,mode=755 0 0
cgroup /sys/fs/cgroup/systemd cgroup rw,nosuid,nodev,noexec,relatime,xattr,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd 0 0
cgroup /sys/fs/cgroup/memory cgroup rw,nosuid,nodev,noexec,relatime,memory 0 0
cgroup /sys/fs/cgroup/net_cls,net_prio cgroup rw,nosuid,nodev,noexec,relatime,net_cls,net_prio 0 0
cgroup /sys/fs/cgroup/blkio cgroup rw,nosuid,nodev,noexec,relatime,blkio 0 0
cgroup /sys/fs/cgroup/cpu,cpuacct cgroup rw,nosuid,nodev,noexec,relatime,cpu,cpuacct 0 0
cgroup /sys/fs/cgroup/devices cgroup rw,nosuid,nodev,noexec,relatime,devices 0 0
cgroup /sys/fs/cgroup/freezer cgroup rw,nosuid,nodev,noexec,relatime,freezer 0 0
systemd-1 /proc/sys/fs/binfmt_misc autofs rw,relatime,fd=22,pgrp=1,timeout=300,minproto=5,maxproto=5,direct 0 0
debugfs /sys/kernel/debug debugfs rw,relatime 0 0
tmpfs /tmp tmpfs rw 0 0
mqueue /dev/mqueue mqueue rw,relatime 0 0
tmpfs /run/user/1000 tmpfs rw,nosuid,nodev,relatime,size=50516k,mode=700,uid=1000,gid=1000 0 0
/dev/sdc1 /mnt/trekstor ext4 rw,noatime,nobarrier 0 0
/dev/sdb /mnt/sd ext4 rw,noatime,nobarrier 0 0

thank you for reading this message,
enrico
