From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: BUG_ON at mballoc.c:3752
Date: Mon, 4 Feb 2008 11:30:55 +0530
Message-ID: <20080204060055.GC7494@skywalker>
References: <20080131140137.GA20780@alice> <20080131154207.GA22201@alice>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sesterhenn <snakebyte@gmx.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:37899 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751246AbYBDGBB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Feb 2008 01:01:01 -0500
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp03.in.ibm.com (8.13.1/8.13.1) with ESMTP id m1460vBG029562
	for <linux-ext4@vger.kernel.org>; Mon, 4 Feb 2008 11:30:57 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1460vSg934044
	for <linux-ext4@vger.kernel.org>; Mon, 4 Feb 2008 11:30:57 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m146103N023915
	for <linux-ext4@vger.kernel.org>; Mon, 4 Feb 2008 06:01:01 GMT
Content-Disposition: inline
In-Reply-To: <20080131154207.GA22201@alice>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 31, 2008 at 04:42:07PM +0100, Eric Sesterhenn wrote:
> * Eric Sesterhenn (snakebyte@gmx.de) wrote:
> > hi,
> > 
> > while running a modified version of fsfuzzer i triggered the BUG() in
> > ext4_mb_release_inode_pa(). Sadly I am not able to reproduce this using
> > the generated image, but running the fuzzer will usually trigger this in
> > less than 40 attempts. Increasing the JBD2 Debug level didnt give more
> > information. The kernel is current git with
> > ext4-fix-null-pointer-deref-in-journal_wait_on_commit_record.patch
> > applied. 
> 
> I am now able to reproduce this using this image:
> http://www.cccmz.de/~snakebyte/ext4.24.img.bz2
> 
> the following commands will trigger the oops for me
> 
> mount cfs/ext4.24.img /media/test -t ext4dev -o extents -o loop
> mkdir /media/test/stress
> chown snakebyte:snakebyte /media/test/stress && sudo -u snakebyte fstest -n 10 -l 10 -f 5 -s 40000 -p /media/test/stress/
> 

The file system is corrupted. The BUG_ON indicate that the free spcae
marked in the prealloc space and found by looking at the bitmap are not
same. Do you have a set of steps that i can follow to reproduce this ?
on a clean file system ? Where do i find the fsfuzzer that you are using ?


kvaneesh@skywalker:/tmp$/home/opensource/patches/e2fsprogs-1.40.4.cfs1/e2fsck/e2fsck.static  -f ./ext4.24.img
e2fsck 1.40.4.cfs1 (31-Dec-2007)
Superblock has an invalid ext3 journal (inode 8).
Clear<y>? yes

*** ext3 journal has been deleted - filesystem is now ext2 only ***

Pass 1: Checking inodes, blocks, and sizes
Inode 7 has illegal block(s).  Clear<y>? yes

Illegal block #552 (9568256) in inode 7.  CLEARED.
Illegal block #647 (4063232) in inode 7.  CLEARED.
Illegal block #659 (12517376) in inode 7.  CLEARED.
Illegal block #766 (2600468480) in inode 7.  CLEARED.
Illegal block #944 (51200) in inode 7.  CLEARED.
Illegal block #1135 (2583691264) in inode 7.  CLEARED.
Illegal block #1214 (15925248) in inode 7.  CLEARED.
Illegal block #1345 (771751936) in inode 7.  CLEARED.
Illegal block #1384 (10092544) in inode 7.  CLEARED.
Illegal block #1416 (14811136) in inode 7.  CLEARED.
Illegal block #1470 (10420224) in inode 7.  CLEARED.
Illegal block #1709 (10158080) in inode 7.  CLEARED.
Too many illegal blocks in inode 7.
Clear inode<y>? yes

Journal inode is not in use, but contains data.  Clear<y>? yes

Deleted inode 160 has zero dtime.  Fix<y>? yes

Deleted inode 257 has zero dtime.  Fix<y>? yes

Deleted inode 638 has zero dtime.  Fix<y>? yes

Deleted inode 1407 has zero dtime.  Fix<y>? yes

Deleted inode 1650 has zero dtime.  Fix<y>? yes

Deleted inode 1656 has zero dtime.  Fix<y>? yes

Deleted inode 1677 has zero dtime.  Fix<y>? yes

Deleted inode 1720 has zero dtime.  Fix<y>? yes

Inode 11 has illegal block(s).  Clear<y>? yes

Illegal block #249 (15990784) in inode 11.  CLEARED.
Inode 11, i_size is 12288, should be 33792.  Fix<y>? yes

Inode 11, i_blocks is 24, should be 28.  Fix<y>? yes

Recreate journal to make the filesystem ext3 again?
Fix<y>? yes

-aneesh
