From: Andreas Dilger <adilger@sun.com>
Subject: Re: Group descriptor 0 checksum is invalid
Date: Mon, 16 Nov 2009 08:36:12 -0800
Message-ID: <E4529F89-AACD-42EA-BC77-BB1DC0BAC01D@sun.com>
References: <alpine.DEB.2.01.0911141349050.27639@bogon.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:50446 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbZKPQgt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Nov 2009 11:36:49 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id nAGGaq3L009237
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2009 08:36:54 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KT700800NC11T00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Mon,
 16 Nov 2009 08:36:52 -0800 (PST)
In-reply-to: <alpine.DEB.2.01.0911141349050.27639@bogon.housecafe.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2009-11-14, at 14:00, Christian Kujau wrote:
> when trying to convert an ext3 filesystem to ext4, I'm getting these
> "Group descriptor 0 checksum is invalid" messages. I've seen them  
> before
> and the net is full of them, but I still wonder if they're expected to
> show up at all during the filesystem's first fsck. See below for the
> script log.

Yes, this is because enabling the uninit_bg feature on the filesystem  
also
requires that the group descriptor checksums are used.  This is the  
reason
why it asks you to run e2fsck on the filesystem.

It isn't safe to just have tune2fs initialize the unused inode count  
based
on the inode bitmap and then compute the checksums when the uninit_bg
feature, since tune2fs can't know for sure know which inodes are in use
without a full e2fsck run.

I suppose it would be possible to just set the bg_itable_unused = 0 and
then compute the checksum at tune2fs, and the next time the e2fsck is
run it will initialize bg_itable_unused to the right value.  It is a bit
sub-optimal, but not harmful and it avoids the need to run a full  
e2fsck.

> sid:~# cat /proc/version
> Linux version 2.6.32-rc7 (dummy@sid) (gcc version 4.4.2 (Debian  
> 4.4.2-2) ) #1 SMP Sat Nov 14 22:00:51 CET 2009
> sid:~# mkfs.ext3 -q /dev/xvdc
> sid:~# mount -t ext3 /dev/xvdc /mnt/d2
> sid:~# grep /dev/xvdc /proc/mounts
> /dev/xvdc /mnt/d2 ext3 rw,relatime,errors=continue,data=writeback 0 0
> sid:~# df -h /dev/xvdc
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/xvdc              16G  173M   15G   2% /mnt/d2
> sid:~# umount /dev/xvdc
> sid:~# tune2fs -O extents,uninit_bg /dev/xvdc
> tune2fs 1.41.9 (22-Aug-2009)
>
> Please run e2fsck on the filesystem.
>
> sid:~# tune2fs -l /dev/xvdc | grep -i feat
> Filesystem features:      has_journal ext_attr resize_inode  
> dir_index filetype extent sparse_super large_file uninit_bg
>
> sid:~# e2fsck -fpDC0 /dev/xvdc
> /dev/xvdc: One or more block group descriptor checksums are  
> invalid.  FIXED.
> /dev/xvdc: Group descriptor 0 checksum is invalid.
>
> /dev/xvdc: UNEXPECTED INCONSISTENCY; RUN fsck MANUALLY.
> 	(i.e., without -a or -p options)
>
> sid:~# e2fsck -fDC0 /dev/xvdc
> e2fsck 1.41.9 (22-Aug-2009)
> One or more block group descriptor checksums are invalid.  Fix<y>? yes
>
> Group descriptor 0 checksum is invalid.  FIXED.
> Group descriptor 1 checksum is invalid.  FIXED.
> [...]
> Group descriptor 126 checksum is invalid.  FIXED.
> Group descriptor 127 checksum is invalid.  FIXED.
> Pass 1: Checking inodes, blocks, and sizes
> /dev/xvdc: |  [...]
> Pass 3: Checking directory connectivity
> Pass 3A: Optimizing directories
> Rebuilding directory: |================                / 50.0% [...]
> Pass 5: Checking group summary information
> /dev/xvdc: | 
> ========================================================| 100.0%
> /dev/xvdc: ***** FILE SYSTEM WAS MODIFIED *****
> /dev/xvdc: 11/1048576 files (0.0% non-contiguous), 109874/4194304  
> blocks
> sid:~#
> sid:~# e2fsck -fC0 /dev/xvdc
> /dev/xvdc: |                                            [...]
> /dev/xvdc: 11/1048576 files (0.0% non-contiguous), 109874/4194304  
> blocks
>
> -- 
> BOFH excuse #389:
>
> /dev/clue was linked to /dev/null
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

