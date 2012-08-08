From: "George Spelvin" <linux@horizon.com>
Subject: metadata_csum Oops
Date: 8 Aug 2012 09:39:43 -0400
Message-ID: <20120808133943.24605.qmail@science.horizon.com>
References: <20120806232512.GE30677@thunk.org>
Cc: linux@horizon.com
To: linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:62382 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S964926Ab2HHNjq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Aug 2012 09:39:46 -0400
In-Reply-To: <20120806232512.GE30677@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The machine I reported earlier issues has not glitched yet.
However, I have some more fun to report.

To further test metadata checksums, I enabled it on my desktop machine.
(Also has SSE4.2, so the checksum overhead should be minimal.)  This is
a Debian/unstable lachine, with 64-bit kernel (v3.5 + ext4-for-linus)
and 32-bit userland, with e2fsprogs from the next branch.

This time I included the root FS, which gave some interesting issues
last night during the network backup run.  This morning I was greeted by:

BUG: unable to handle kernel paging request at fffffffffffffff8
IP: [<ffffffff810ffbf9>] ext4_readdir+0x1e2/0x5a8
PGD 1589067 PUD 158a067 PMD 0
Oops: 0000 [#1] SMP
CPU 1
Modules linked in:  battery nfds exportfs deflate zlib_deflate zlib_inflate ctr <whole bunch of crypto modules snipped> crypto_null af_key xfrm_algo fuse ftdi_sio usbserial r8199
Pid: 31650, comm: rsync Not tainted 3.5.0-00032-g0e1gf37 #55 Gigabyte Technology Co., Ltd. H55M-UD2H/H55M-UD2H
RIP: 0010:[<ffffffff810ffbf9>]  [<ffffffff810ffbf9>] ext4_readdir+0x1e2/0x5a8
RSP: 0018:ffff88010eb65e38  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8800b6763300 RCX: 0000000000000000
RDX: ffffffff810e5d99 RSI: ffff88010eb65f40 RDI: ffff8800b6763300
RBP: ffff88010eb65ed8 R08: 0000000000013750 R09: ffffea000445bd40
R10: 0000000000000000 R11: ffffffff8111a578 R12: ffff880108808740
R13: ffff88003ab13748 R14: ffff8801137e8400 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff880117c80000(0063) knlGS:00000000f760d6c0
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: fffffffffffffff8 CR3: 000000011177e000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process rsync (pid: 31650, threadinfo ffff88010eb64000, task ffff880111d6a5e0)
Stack:
 ffff88010eb65f08 ffffffff810bc5e9 ffff880113782220 ffff880000000000
 00000005756e69e4 ffff88011379501e ffffffff810e5d99 ffff88010eb65f40 
 ffff88003ab13748 ffff88003ab13748 0000000000000000 ffffffff813dc01c
Call Trace:
 [<ffffffff810bc5e9>] ? do_filp_open+0x33/0x81
 [<ffffffff810e5d99>] ? compat_filldir+0xdd/0xdd
 [<ffffffff813dc01c>] ? _cond_resched+0x9/0x1d
 [<ffffffff8104437b>] ? shoud_resched+0x9/0x28
 [<ffffffff810e5d99>] ? compat_filldir+0xdd/0xdd
 [<ffffffff810be52e>] vfs_readdir+0x61/0x9a
 [<ffffffff810aa3b5>] ? kmem_cache_free+0x15/0x6e
 [<ffffffff810e729e>] compat_sys_getdents64+0x72/0xcc
 [<ffffffff813de59b>] sysenter_dispatch+0x7/0x1e
Code: 00 83 f8 00 0f 8c a6 00 00 00 75 02 eb 6d 4c 89 e7 e8 49 5b 09 00 49 89 44 24 08 49 8b 4c 24 08 48 8b 55 90 48 89 df 48 8b 75 98 <8b> 41 f8 41 89 44 24 20 8b 41 fc 48 83 e9 08 41 89 44 24 24 e8
RIP  [<ffffffff810ffbf9>] ext4_readdir+0x1e2/0x5a8
 RSP <ffff88010eb65e38>
CR2: fffffffffffffff8

(The above was hand-transcribed, so I *hope* I got all the hex correct!)

Anyway, on reboot, the system came up, but would not fsck, printing:

fsck.ext4: Superblock checksum does not match superblock while trying to open /dev/sda2
/dev/sda2:
The superblock could not be read or does not describe a correct ext2
filesstem.  If the device is valid and it really contains an ext2
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblock:
    e2fsck -b 8193 <device>

fsck died with exit code 8


So I logged in by hand and tried to run the recommended command, but!
Including "-b 8193" produced the above message, while *omitting* it
actually ran successfully.  I'm a little confused by that.
(The "fsck" wrapper invoked from /etc/init.d/checkroot.sh is 2.20.1-5.1.)

For some limited values of "successfully"; it sure found a lot of problems:

(This is the second run; I stopped the first and started capturing it
when it was obvious pencil and paper was impractical.)

Script started on Wed Aug  8 08:40:45 2012
/run# e2fsck -y -v -C0 /dev/sda2
e2fsck 1.43-WIP (1-Aug-2012)
root was not cleanly unmounted, check forced.
Pass 1: Checking inodes, blocks, and sizes
... some similar errors from earlier run omitted ...
Inode 947580 checksum does not match inode.  Clear? yes
Inode 947581 checksum does not match inode.  Clear? yes
Inode 947582 checksum does not match inode.  Clear? yes
Inode 947583 checksum does not match inode.  Clear? yes
Inode 947584 checksum does not match inode.  Clear? yes
Inode 947585 checksum does not match inode.  Clear? yes
Inode 947586 checksum does not match inode.  Clear? yes
Inode 947587 checksum does not match inode.  Clear? yes
Inode 947588 checksum does not match inode.  Clear? yes
Inode 947589 checksum does not match inode.  Clear? yes
Inode 947590 checksum does not match inode.  Clear? yes
Inode 947591 checksum does not match inode.  Clear? yes
... 315 additional deleted ...
Inode 947920 checksum does not match inode.  Clear? yes

Pass 2: Checking directory structure
Entry 'linux' in /usr/arm-linux-gnueabi/include (534036) has deleted/unused inode 534518.  Clear? yes
Entry '..' in ??? (534570) has deleted/unused inode 534518.  Clear? yes
Entry '..' in ??? (534582) has deleted/unused inode 534518.  Clear? yes
Entry '..' in ??? (534660) has deleted/unused inode 534518.  Clear? yes
Entry '..' in ??? (534681) has deleted/unused inode 534518.  Clear? yes
Entry '..' in ??? (534695) has deleted/unused inode 534518.  Clear? yes
Entry '..' in ??? (534737) has deleted/unused inode 534518.  Clear? yes
Entry '..' in ??? (534785) has deleted/unused inode 534518.  Clear? yes
Entry '..' in ??? (534796) has deleted/unused inode 534518.  Clear? yes
Entry '..' in ??? (534805) has deleted/unused inode 534518.  Clear? yes
Entry '..' in ??? (534820) has deleted/unused inode 534518.  Clear? yes
Entry '..' in ??? (534824) has deleted/unused inode 534518.  Clear? yes
Entry '..' in ??? (534860) has deleted/unused inode 534518.  Clear? yes
Entry '..' in ??? (534911) has deleted/unused inode 534518.  Clear? yes
Entry '..' in ??? (534947) has deleted/unused inode 534518.  Clear? yes
Entry '..' in ??? (534959) has deleted/unused inode 534518.  Clear? yes
Entry '..' in ??? (534978) has deleted/unused inode 534518.  Clear? yes
Entry '..' in ??? (535012) has deleted/unused inode 534518.  Clear? yes
Entry '..' in ??? (535026) has deleted/unused inode 534518.  Clear? yes
Entry '..' in ??? (535045) has deleted/unused inode 534518.  Clear? yes
Entry '..' in ??? (535065) has deleted/unused inode 534518.  Clear? yes

Pass 3: Checking directory connectivity
Unconnected directory inode 534570 (...)
Connect to /lost+found? yes
... suplicates snipped ...

Pass 4: Checking reference counts
Inode 534036 ref count is 30, should be 29.  Fix? yes
Inode 534570 ref count is 3, should be 2.  Fix? yes
Inode 534582 ref count is 4, should be 3.  Fix? yes
Inode 534660 ref count is 3, should be 2.  Fix? yes
Inode 534681 ref count is 3, should be 2.  Fix? yes
Inode 534695 ref count is 3, should be 2.  Fix? yes
Inode 534737 ref count is 3, should be 2.  Fix? yes
Inode 534785 ref count is 3, should be 2.  Fix? yes
Unattached inode 534795  Connect to /lost+found? yes
Inode 534795 ref count is 2, should be 1.  Fix? yes
Inode 534796 ref count is 3, should be 2.  Fix? yes
Unattached inode 534797  Connect to /lost+found? yes
Inode 534797 ref count is 2, should be 1.  Fix? yes
... snip ...
Unattached inode 542215  Connect to /lost+found? yes
Inode 542215 ref count is 2, should be 1.  Fix? yes

Pass 5: Checking group summary information
Block bitmap differences:  -(3833858--3833859) -3833862 -(3833864--3833865) -3833867 -3833870 -(3833872--3833873)  ...2.5 MB snipped...
Fix? yes

Free blocks count wrong for group #0 (27905, counted=27767).
Fix? yes
Free blocks count wrong for group #1 (2607, counted=2109).
Fix? yes
Free blocks count wrong for group #2 (4062, counted=4164).
Fix? yes
... snip ...
Free blocks count wrong for group #289 (21421, counted=21608).
Fix? yes
Free blocks count wrong (6043152, counted=6026661).
Fix? yes

Inode bitmap differences:  -(26241--26243) -(26245--26247) -26253 -26263 -26268 -(26271--26272) -(26275--26276) -26278 ... 1,000,000 bytes snipped ...
Fix? yes

Free inodes count wrong for group #0 (2, counted=31).
Fix? yes
Free inodes count wrong for group #1 (0, counted=934).
Fix? yes
Free inodes count wrong for group #2 (0, counted=1847).
Fix? yes
... snip ...
Free inodes count wrong for group #288 (486, counted=468).
Fix? yes

Free inodes count wrong (693942, counted=693943).
Fix? yes

root: ***** FILE SYSTEM WAS MODIFIED *****
root: ***** REBOOT LINUX *****

      286777 inodes used (29.24%, out of 980720)
         278 non-contiguous files (0.1%)
         172 non-contiguous directories (0.1%)
             # of inodes with ind/dind/tind blocks: 0/0/0
             Extent depth histogram: 262385/65
     3738850 blocks used (38.29%, out of 9765511)
           0 bad blocks
           0 large files

      238864 regular files
       21703 directories
         164 character device files
          10 block device files
           1 fifo
  4294967292 links
       26014 symbolic links (24132 fast symbolic links)
          12 sockets
------------
      286397 files

/run# e2fsck -f -v -C0 /dev/sda2
e2fsck 1.43-WIP (1-Aug-2012)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information

      286777 inodes used (29.24%, out of 980720)
         278 non-contiguous files (0.1%)
         173 non-contiguous directories (0.1%)
             # of inodes with ind/dind/tind blocks: 0/0/0
             Extent depth histogram: 262385/65
     3738850 blocks used (38.29%, out of 9765511)
           0 bad blocks
           0 large files

      238864 regular files
       21703 directories
         164 character device files
          10 block device files
           1 fifo
          36 links
       26014 symbolic links (24132 fast symbolic links)
          12 sockets
------------
      286804 files
