From: Gabriele Giacone <1o5g4r8o@gmail.com>
Subject: Re: Bug#738758: linux-image-3.12-1-amd64: ext4 can't properly handle
 ext2 filesystems created for GNU/Hurd
Date: Wed, 19 Mar 2014 21:20:09 +0100
Message-ID: <20140319202009.GA21361@jessie01>
References: <20140212185534.GA4005@phenomenon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: 738758@bugs.debian.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:45907 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953AbaCSUUN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Mar 2014 16:20:13 -0400
Received: by mail-ee0-f51.google.com with SMTP id c13so6995153eek.24
        for <linux-ext4@vger.kernel.org>; Wed, 19 Mar 2014 13:20:12 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140212185534.GA4005@phenomenon>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

> 04:23 < bwh> Send mail to linux-ext4@vger.kernel.org and cc 738758@bugs.debian.org

Forwarding debian bug https://bugs.debian.org/738758

On Wed, Feb 12, 2014 at 07:55:34PM +0100, Gabriele Giacone wrote:
> Package: src:linux
> Version: 3.12.9-1
> Severity: normal
> 
> Since CONFIG_EXT4_USE_FOR_EXT23 has been enabled, ext4 module can't properly
> handle ext2 created for Hurd causing data corruption.
> ext2 module would do its job.
> 
> Reproducible with:
> 
> dd if=/dev/zero of=test.fs count=10000
> echo y|mkfs.ext2 -o hurd test.fs
> mount -t ext2 test.fs /mnt
> touch /mnt/bug0000
> umount /mnt
> fsck.ext2 -fp test.fs
> 
> Attached output with kernel 3.10-3 and 3.12-1.
> 

> + dd if=/dev/zero of=test.fs count=10000
> 10000+0 records in
> 10000+0 records out
> 5120000 bytes (5.1 MB) copied, 0.0459037 s, 112 MB/s
> + echo y
> + mkfs.ext2 -o hurd test.fs
> mke2fs 1.42.9 (28-Dec-2013)
> test.fs is not a block special device.
> Proceed anyway? (y,n) Discarding device blocks:          done                            
> Filesystem label=
> OS type: Hurd
> Block size=4096 (log=2)
> Fragment size=4096 (log=2)
> Stride=0 blocks, Stripe width=0 blocks
> 1280 inodes, 1250 blocks
> 62 blocks (4.96%) reserved for the super user
> First data block=0
> 1 block group
> 32768 blocks per group, 32768 fragments per group
> 1280 inodes per group
> 
> Allocating group tables: 0/1   done                            
> Writing inode tables: 0/1   done                            
> Writing superblocks and filesystem accounting information: 0/1   done
> 
> + mount -t ext2 test.fs /mnt
> + touch /mnt/bug0000
> + umount /mnt
> + fsck.ext2 -fp test.fs
> test.fs: 12/1280 files (0.0% non-contiguous), 50/1250 blocks

> + dd if=/dev/zero of=test.fs count=10000
> 10000+0 records in
> 10000+0 records out
> 5120000 bytes (5.1 MB) copied, 0.0227442 s, 225 MB/s
> + echo y
> s.ext2 -o hurd test.fs
> mke2fs 1.42.9 (28-Dec-2013)
> test.fs is not a block special device.
> Proceed anyway? (y,n) Discarding device blocks:          done                            
> Filesystem label=
> OS type: Hurd
> Block size=4096 (log=2)
> Fragment size=4096 (log=2)
> Stride=0 blocks, Stripe width=0 blocks
> 1280 inodes, 1250 blocks
> 62 blocks (4.96%) reserved for the super user
> First data block=0
> 1 block group
> 32768 blocks per group, 32768 fragments per group
> 1280 inodes per group
> 
> Allocating group tables: 0/1   done                            
> Writing inode tables: 0/1   done                            
> Writing superblocks and filesystem accounting information: 0/1   done
> 
> + mount -t ext2 test.fs /mnt
> + touch /mnt/bug0000
> + umount /mnt
> + fsck.ext2 -fp test.fs
> test.fs: Inode 2, i_blocks is 8, should be 16.  FIXED.
> test.fs: Inode 12, i_blocks is 0, should be 8.  FIXED.
> test.fs: Duplicate or bad block in use!
> test.fs: Multiply-claimed block(s) in inode 2: 1
> test.fs: Multiply-claimed block(s) in inode 12: 1
> test.fs: (There are 2 inodes containing multiply-claimed blocks.)
> 
> test.fs: File / (inode #2, mod time Wed Feb 12 19:02:45 2014) 
>   has 1 multiply-claimed block(s), shared with 2 file(s):
> test.fs: 	<filesystem metadata>
> test.fs: 	/bug0000 (inode #12, mod time Wed Feb 12 19:02:45 2014)
> test.fs: 
> 
> test.fs: UNEXPECTED INCONSISTENCY; RUN fsck MANUALLY.
> 	(i.e., without -a or -p options)

--
G..e

