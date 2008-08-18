From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: ENOSPC error returned too late
Date: Mon, 18 Aug 2008 16:21:40 +0530
Message-ID: <20080818105140.GB7808@skywalker>
References: <E1KUhkt-0003yw-Sf@closure.thunk.org> <20080818093026.GA7808@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:45460 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752040AbYHRKvt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Aug 2008 06:51:49 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp06.in.ibm.com (8.13.1/8.13.1) with ESMTP id m7IApjts018002
	for <linux-ext4@vger.kernel.org>; Mon, 18 Aug 2008 16:21:45 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7IApjbQ1765380
	for <linux-ext4@vger.kernel.org>; Mon, 18 Aug 2008 16:21:45 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id m7IApjYK012130
	for <linux-ext4@vger.kernel.org>; Mon, 18 Aug 2008 16:21:45 +0530
Content-Disposition: inline
In-Reply-To: <20080818093026.GA7808@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 18, 2008 at 03:00:26PM +0530, Aneesh Kumar K.V wrote:
> On Sun, Aug 17, 2008 at 08:53:11AM -0400, Theodore Ts'o wrote:
> > 
> > While trying to track down kernel BZ #11341 (which is really an
> > e2fsprogs bug, not a 2.6.26 regression) I created a fresh ext4
> > filesystem which was 5GB in length, and then filled it to ENOSPC via:
> > 
> > dd if=/dev/zero of=/mnt/bigfile bs=1024 count=10485760
> > 
> > Unfortunately, it sent the ENOSPC few blocks too late, so the following
> > appeared in dmesg, and an attempt to umount the filesystem hung in D
> > wait.  :-(
> > 
> > 						- Ted
> > 
> > 
> > [63518.930337] mpage_da_map_blocks block allocation failed for inode 12 at logical offset 1254547 with max blocks 2 with error -28
> > [63518.930337] This should not happen.!! Data will be lost
> 
> I will look into this. Are we really out of free space or is it that
> mballoc is not able to find free space ?. I am not able to reproduce
> this here. Will try more.
> 
> 

How about 

commit 08085a642ac6e7c3bfae0b6daf538e64a99695b2
Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date:   Mon Aug 18 16:20:39 2008 +0530

    ext4: make sure ext4_has_free_blocks return 0 for ENOSPC
    
    Fix ext4_has_free_blocks to return 0 when we don't have
    enought space.
    
    Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 27323cd..dfe2d4f 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -1628,6 +1628,9 @@ ext4_fsblk_t ext4_has_free_blocks(struct ext4_sb_info *sbi,
 		free_blocks =
 			percpu_counter_sum_and_set(&sbi->s_freeblocks_counter);
 #endif
+	if (free_blocks <= root_blocks)
+		/* we don't have free space */
+		return 0;
 	if (free_blocks - root_blocks < nblocks)
 		return free_blocks - root_blocks;
 	return nblocks;
