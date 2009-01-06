From: Andreas Dilger <adilger@sun.com>
Subject: Re: How to recover a damaged ext4 file system?
Date: Tue, 06 Jan 2009 05:05:27 -0700
Message-ID: <20090106120527.GT3932@webber.adilger.int>
References: <20090105135347.GA3337@localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Christian Ohm <chr.ohm@gmx.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:65011 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbZAFMFd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Jan 2009 07:05:33 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n06C5Ufa021416
	for <linux-ext4@vger.kernel.org>; Tue, 6 Jan 2009 04:05:32 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KD100201TK8QR00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 06 Jan 2009 04:05:30 -0800 (PST)
In-reply-to: <20090105135347.GA3337@localdomain>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jan 05, 2009  14:53 +0100, Christian Ohm wrote:
> no reports of serious problems, I decided to try it on a partition of
> semi-important files. Well, after a hard system hang because of the (open
> source Radeon) graphics driver, the file system is quite corrupted, and cannot
> be mounted any more (that never happened with ext3). mount gives the following
> error:
> 
> mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so
> 
> dmesg message:
> 
> EXT4-fs: ext4_check_descriptors: Block bitmap for group 0 not in group (block 727012683)!
> EXT4-fs: group descriptors corrupted!

You should try to run e2fsck with the backup group descriptors, using
the -B and/or -b options (at a guess -B 4096 and -b 32768).

> I have uploaded the output of fsck .ext4 -n at
> http://www.filefactory.com/file/aff6f3g/n/fsck_ext4_bz2 which is over 6MB of
> stuff like
> 
> ---
> e2fsck 1.41.3 (12-Oct-2008)
> fsck.ext4: Group descriptors look bad... trying backup blocks...
> Block bitmap for group 0 is not in group.  (block 727012683)
> Relocate? no
> 
> Inode bitmap for group 0 is not in group.  (block 3406175899)
> Relocate? no
> 
> Inode table for group 0 is not in group.  (block 1236188664)
> WARNING: SEVERE DATA LOSS POSSIBLE.
> Relocate? no
> 
> Group descriptor 0 checksum is invalid.  Fix? no
> 
> Block bitmap for group 1 is not in group.  (block 2704710215)
> Relocate? no
> 
> Inode bitmap for group 1 is not in group.  (block 2166870417)
> Relocate? no
> 
> Inode table for group 1 is not in group.  (block 600148394)
> WARNING: SEVERE DATA LOSS POSSIBLE.
> Relocate? no
> 
> Group descriptor 1 checksum is invalid.  Fix? no
> ---
> 
> and later
> 
> ---
> Group descriptor 7452 checksum is invalid.  Fix? no
> 
> Error reading block 1236188664 (Invalid argument).  Ignore error? no
> 
> data-1000 contains a file system with errors, check forced.
> Error reading block 1236188664 (Invalid argument).  Ignore error? no
> 
> fsck.ext4: Invalid argument while reading bad blocks inode
> This doesn't bode well, but we'll try to go on...
> Pass 1: Checking inodes, blocks, and sizes
> Illegal block number passed to ext2fs_test_block_bitmap #1236188664 for in-use block map
> Illegal block number passed to ext2fs_mark_block_bitmap #1236188664 for in-use block map
> ---
> 
> 
> Now as I said, the files are semi-important, meaning I could recover those I
> still want with some time, but repairing the file system would be preferable.
> Unfortunately I don't have enough space on another harddrive to just copy the
> partition and experiment on that, so I haven't tried letting fsck repair the fs
> yet, and since it says SEVERE DATA LOSS POSSIBLE I wouldn't like to try that
> without copying first.
> 
> So my two main questions would be:
> 
> 1. How can I recover the data on the file system? As I said, I don't need all
> the files, but it would save some time. I created it with the mkfs.ext4 from
> Debian unstable (1.41.3) with only largefile as extra option, and the default
> mount options with kernel 2.6.28. The fs wasn't used for long, and I mostly
> copied/created files, without deleting much.
> 
> 2. Is this corruption a fault of ext4? I guess this is difficult to answer, but
> I had ext3 survive any lockups without much problems. So far ext4 seems not
> quite that robust, but perhaps another file system would have blown up as well
> in this situation. Is there any information I can give you to help make ext4
> more robust?
> 
> Best regards,
> Christian Ohm
> 
> PS: I think my first post with the fsck output attached got rejected due to its
> size, though I didn't receive a message about that.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

