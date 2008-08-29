From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V3 09/11] ext4: Fix ext4 nomballoc allocator for ENOSPC
Date: Fri, 29 Aug 2008 09:44:12 +0530
Message-ID: <20080829041202.GB6444@skywalker>
References: <1219850916-8986-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1219850916-8986-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1219850916-8986-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1219850916-8986-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1219850916-8986-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1219850916-8986-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1219850916-8986-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1219850916-8986-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1219960669.6384.58.camel@mingming-laptop> <20080829034451.GA6444@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:46349 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbYH2EO0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Aug 2008 00:14:26 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id m7T4DuY2013129
	for <linux-ext4@vger.kernel.org>; Fri, 29 Aug 2008 14:13:56 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7T4ENni4608064
	for <linux-ext4@vger.kernel.org>; Fri, 29 Aug 2008 14:14:23 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7T4ENjN010362
	for <linux-ext4@vger.kernel.org>; Fri, 29 Aug 2008 14:14:23 +1000
Content-Disposition: inline
In-Reply-To: <20080829034451.GA6444@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 29, 2008 at 09:14:51AM +0530, Aneesh Kumar K.V wrote:
> On Thu, Aug 28, 2008 at 02:57:49PM -0700, Mingming Cao wrote:
> > 
> > From: Mingming Cao <cmm@us.ibm.com>
> > 
> > ext4: Fix ext4 nomballoc allocator for ENOSPC
> >     
> > We run into ENOSPC error on nonmballoc ext4, even when there is free blocks
> > on the filesystem.
> > 
> > The problem is triggered in the case the goal block group has 0 free blocks
> > , and the rest block groups are skipped due to the check of "free_blocks 
> > < windowsz/2".
> 
> The goal block group had free blocks < windowsz .
> 
> 

Ok how about this. The Final change is same to what you have done.
But it make the code easier to understand. I also added a comment
explaining the details

commit 0216ee1ac13270c1ab7b7517d41775727f7da02d
Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date:   Fri Aug 29 09:35:15 2008 +0530

    ext4: Fix ext4 nomballoc allocator for ENOSPC
    
    We run into ENOSPC error on nonmballoc ext4, even when there is free blocks
    on the filesystem.
    
    The patch include two changes
    
    a) Set reservation to NULL if we trying to allocate near group_target_block
    from the goal group if the free block in the group is less than windowsz.
    This should give us a better chance to allocate near group_target_block.
    This also ensures that if we are not allocating near group_target_block
    then we don't trun off reservation. This should enable us to allocate
    with reservation from other groups that have large free blocks count.
    
    b) we don't need to check the window size if the block reservation is off.
    
    Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
    Signed-off-by: Mingming Cao <cmm@us.ibm.com>

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index cfe01b4..399bec5 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -1802,15 +1802,17 @@ ext4_fsblk_t ext4_old_new_blocks(handle_t *handle, struct inode *inode,
 		goto io_error;
 
 	free_blocks = le16_to_cpu(gdp->bg_free_blocks_count);
-	/*
-	 * if there is not enough free blocks to make a new resevation
-	 * turn off reservation for this allocation
-	 */
-	if (my_rsv && (free_blocks < windowsz)
-		&& (rsv_is_empty(&my_rsv->rsv_window)))
-		my_rsv = NULL;
 
 	if (free_blocks > 0) {
+		/*
+		 * try to allocate with group target block
+		 * in the goal group. If we have low free_blocks
+		 * count turn off reservation
+		 */
+		if (my_rsv && (free_blocks < windowsz)
+			&& (rsv_is_empty(&my_rsv->rsv_window)))
+			my_rsv = NULL;
+
 		bitmap_bh = ext4_read_block_bitmap(sb, group_no);
 		if (!bitmap_bh)
 			goto io_error;
@@ -1843,7 +1845,7 @@ ext4_fsblk_t ext4_old_new_blocks(handle_t *handle, struct inode *inode,
 		 * free blocks is less than half of the reservation
 		 * window size.
 		 */
-		if (free_blocks <= (windowsz/2))
+		if (my_rsv && (free_blocks <= (windowsz/2)))
 			continue;
 
 		brelse(bitmap_bh);
