From: "Andrey Jr. Melnikov" <temnota.am@gmail.com>
Subject: Re: ext4 file system corruption with v4.19.3 / v4.19.4
Date: Wed, 28 Nov 2018 03:16:33 +0300
Message-ID: <vb31df-25g.ln1@banana.localnet>
References: <065643a0-f9aa-a361-715a-03ca978d9228@roeck-us.net> <b43fb902-9b64-22d9-25ca-c970b3842a43@roeck-us.net>
Cc: linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

In gmane.comp.file-systems.ext4 Guenter Roeck <linux@roeck-us.net> wrote:
> [trying again, this time with correct kernel.org address]

> Hi,

> I have seen the following and similar problems several times,
> with both v4.19.3 and v4.19.4:

> Nov 23 04:32:25 mars kernel: [112668.673671] EXT4-fs error (device sdb1): ext4_iget:4831: inode #12602889: comm git: bad extra_isize 33661 (inode size 256)
> Nov 23 04:32:25 mars kernel: [112668.675217] Aborting journal on device sdb1-8.
> Nov 23 04:32:25 mars kernel: [112668.676681] EXT4-fs (sdb1): Remounting filesystem read-only
> Nov 23 04:32:25 mars kernel: [112668.808886] EXT4-fs error (device sdb1): ext4_iget:4831: inode #12602881: comm rm: bad extra_isize 33685 (inode size 256)
> ...

> Nov 25 00:12:43 saturn kernel: [59377.725984] EXT4-fs error (device sda1): ext4_lookup:1578: inode #238034131: comm updatedb.mlocat: deleted inode referenced: 238160407
> Nov 25 00:12:43 saturn kernel: [59377.766638] Aborting journal on device sda1-8.
> Nov 25 00:12:43 saturn kernel: [59377.779372] EXT4-fs (sda1): Remounting filesystem read-only
> ...

> Nov 24 01:52:31 saturn kernel: [189085.240016] EXT4-fs error (device sda1): ext4_lookup:1578: inode #52038457: comm nfsd: deleted inode referenced: 52043796
> Nov 24 01:52:31 saturn kernel: [189085.263427] Aborting journal on device sda1-8.
> Nov 24 01:52:31 saturn kernel: [189085.275313] EXT4-fs (sda1): Remounting filesystem read-only


> The same systems running v4.18.6 never experienced a problem.

> Has anyone else seen similar problems ? Is there anything I can do
> to help tracking down the problem ?

I see this problem on 4.19.1, 4.19.2 & 4.19.5 (4.19.3 & 4.19.4 - skipped).

kernel always report:
ext4_iget:4851: inode #XXXXXXX: comm updatedb.mlocat: checksum invalid

/dev/sde2 mounted as ext4 with relatime,errors=remount-ro options.

last one (from 4.19.5):
[  355.926146] EXT4-fs error (device sde2): ext4_iget:4851: inode #63184919: comm updatedb.mlocat: checksum invalid
[  355.966810] EXT4-fs (sde2): Remounting filesystem read-only
[  355.987887] EXT4-fs error (device sde2): ext4_journal_check_start:61: Detected aborted journal

# debugfs -n /dev/sde2
debugfs 1.44.4 (18-Aug-2018)
debugfs:  ncheck 63184919
Inode   Pathname
63184919        /home/lynxchaus/openwrt/lede/build_dir/target-mipsel_24kc_musl/linux-ramips_mt7621/linux-4.15/drivers/gpu
debugfs:  ls /home/lynxchaus/openwrt/lede/build_dir/target-mipsel_24kc_musl/linux-ramips_mt7621/linux-4.15/drivers/gpu

/home/lynxchaus/openwrt/lede/build_dir/target-mipsel_24kc_musl/linux-ramips_mt7621/linux-4.15/drivers/gpu: Ext2 inode is not a directory
debugfs:  stat /home/lynxchaus/openwrt/lede/build_dir/target-mipsel_24kc_musl/linux-ramips_mt7621/linux-4.15/drivers/gpu
Inode: 63184919   Type: regular    Mode:  0644   Flags: 0x80000
Generation: 1951786937    Version: 0x00000000:00000001
User:  1000   Group:  1000   Project:     0   Size: 6013
File ACL: 0
Links: 1   Blockcount: 16
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x59bfa71f:bee151ac -- Mon Sep 18 13:59:43 2017
 atime: 0x59bfa71f:bee151ac -- Mon Sep 18 13:59:43 2017
 mtime: 0x59b9a16d:00000000 -- Thu Sep 14 00:21:49 2017
crtime: 0x59bfa71f:bee151ac -- Mon Sep 18 13:59:43 2017
Size of extra inode fields: 32
Inode checksum: 0x39c8526f
EXTENTS:  
(0-1):214480636-214480637

After repair /home/lynxchaus/openwrt/lede/build_dir/target-mipsel_24kc_musl/linux-ramips_mt7621/linux-4.15/drivers/gpu deleted,
all files in it - connected to lost+found.

Corrupted inodes - always directory, not touched at least year or more for writing. Something wrong when updating atime?
