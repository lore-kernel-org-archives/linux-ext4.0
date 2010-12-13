From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: 20TB ext4
Date: Mon, 13 Dec 2010 19:12:20 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1012131907040.3054@dhcp-lab-213.englab.brq.redhat.com>
References: <s6nzks9y74l.fsf@falbala.ieap.uni-kiel.de>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="571108635-1174549499-1292263943=:3054"
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Stephan Boettcher <boettcher@physik.uni-kiel.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752Ab0LMSM1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Dec 2010 13:12:27 -0500
In-Reply-To: <s6nzks9y74l.fsf@falbala.ieap.uni-kiel.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--571108635-1174549499-1292263943=:3054
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Mon, 13 Dec 2010, Stephan Boettcher wrote:

> 
> Moin,
> 
> I spent the weekend trying to setup a 20TB ext4 filesystem on a 32-bit
> i386 system.  The filesystem is now up and running, but on a 64-bit
> machine.  I intend to test this setup for a while.  I understand that
> this is highly experimental.  If there is anything special I should do
> to help shaking out bugs, please tell me.
> 
> Thanks for all the code
> Stephan

This is indeed interesting, I'll add linux-ext4 into cc so more ext4
people can see this.

Thanks!

-Lukas

> 
> 
> 
> The setup:
> 
> Two old servers, dual Xeon 3GHz, hyperthreaded, in sturdy server
> housings, redundant power supplies, noisy but solid.  A third
> identical server will become available to me next week.
> 
> Each server has six 2TB SATA drives.  The drives are partitioned into a
> 20GB partition and a second partition with the remaining almost 2TB.
> 
> Kernel 2.6.36.1.
> 
> A raid1 (/dev/md1) over three 20GB partitions is the root filesystem,
> three 20GB partitions for swap, and a RAID5 (/dev/md0) from the six big
> partitions.
> 
> The 10TB /dev/md0 is exported via nbd.  I had to patch nbd-client to
> import this on a 32-bit machine, so that part works.
> 
> The intention was to export two (later three) via nbd to one of the
> servers, which combines them to a RAID5² with net capacity 20TB.  With
> e2fsprogs master branch I could make a filesystem, but dumpe2fs and
> fsck failed.  Mounting the filesystem said: EFBIG.
> 
> Obviously, with 32-bit pgoff_t this will not work, and it was said
> elsewhere that making pgoff_t 64-bit on i386 will require a lot of faith
> and luck, since there are more than 3000 unsigned longs in the fs tree.
> 
> So I exported both 10TB raid5 as nbd to my 64-bit desktop (Core 2 Quad,
> 2.6.36.2), did mke2fs, mount, some rsyncing, umount, dumpe2fs, fsck, mount,
> more rsyning -- no problems yet.
> 
> I'd prefer to run the setup selfcontained without an extra 64-bit head.
> Maybe I will partition it down to a 16TB and a 4TB partition.  Maybe I
> just dare to compile a kernel with typedef unsigned long long pgoff_t
> and see what happens, maybe I can help fixing that kind of configuration.
> 
> 
> 
> (stephan)idefix:~$ cat /proc/mdstat 
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4] 
> md0 : active raid5 sda2[0] sdf2[5] sde2[4] sdd2[3] sdc2[2] sdb2[1]
>       9662653440 blocks level 5, 512k chunk, algorithm 2 [6/6] [UUUUUU]
>       
> md1 : active raid1 sda1[0] sde1[2] sdc1[1]
>       20980736 blocks [3/3] [UUU]
>       
> unused devices: <none>
> 
> (stephan)falbala:~$ cat /proc/mdstat 
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4] 
> md9 : active raid5 nbd0[0] nbd1[1]
>       19325303808 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/2] [UU_]
> ...
>       
> unused devices: <none>
> 
> 
> (root)falbala:~# /home/asterix/stephan/src/e2fsprogs/build/misc/dumpe2fs -h /dev/md9p1 
> dumpe2fs 1.41.13 (22-Nov-2010)
> Filesystem volume name:   <none>
> Last mounted on:          /data/hinkelstein
> Filesystem UUID:          7c96821d-3371-465b-9c69-f67ec1a953fa
> Filesystem magic number:  0xEF53
> Filesystem revision #:    1 (dynamic)
> Filesystem features:      has_journal ext_attr dir_index filetype needs_recovery extent 64bit flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
> Filesystem flags:         signed_directory_hash 
> Default mount options:    (none)
> Filesystem state:         clean
> Errors behavior:          Continue
> Filesystem OS type:       Linux
> Inode count:              2415673344
> Block count:              4831325943
> Reserved block count:     241566297
> Free blocks:              4686685845
> Free inodes:              2415191498
> First block:              0
> Block size:               4096
> Fragment size:            4096
> Blocks per group:         32768
> Fragments per group:      32768
> Inodes per group:         16384
> Inode blocks per group:   512
> Flex block group size:    16
> Filesystem created:       Sun Dec 12 23:02:05 2010
> Last mount time:          Mon Dec 13 09:24:10 2010
> Last write time:          Mon Dec 13 09:24:10 2010
> Mount count:              2
> Maximum mount count:      26
> Last checked:             Sun Dec 12 23:02:05 2010
> Check interval:           15552000 (6 months)
> Next check after:         Sat Jun 11 00:02:05 2011
> Lifetime writes:          288 GB
> Reserved blocks uid:      0 (user root)
> Reserved blocks gid:      0 (group root)
> First inode:              11
> Inode size:               128
> Journal inode:            8
> Default directory hash:   half_md4
> Directory Hash Seed:      3c0d80ff-6611-43ad-93e8-b083d637e549
> Journal backup:           inode blocks
> Journal features:         journal_incompat_revoke FEATURE_I1
> Journal size:             128M
> Journal length:           32768
> Journal sequence:         0x00002bea
> Journal start:            4481
> 
> 
> 

-- 
--571108635-1174549499-1292263943=:3054--
