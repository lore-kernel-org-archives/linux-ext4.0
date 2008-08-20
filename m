From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: ENOSPC returned during writepages
Date: Wed, 20 Aug 2008 16:16:44 +0530
Message-ID: <20080820104644.GA11267@skywalker>
References: <20080820054339.GB6381@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:33262 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751073AbYHTKqv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Aug 2008 06:46:51 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp06.in.ibm.com (8.13.1/8.13.1) with ESMTP id m7KAkmgH020498
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 16:16:48 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7KAkm311515552
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 16:16:48 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m7KAkmbn009867
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 16:16:48 +0530
Content-Disposition: inline
In-Reply-To: <20080820054339.GB6381@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 20, 2008 at 11:13:39AM +0530, Aneesh Kumar K.V wrote:
> Hi,
> 
> I am getting this even with the latest patch queue. The test program is
> a modified fsstress with fallocate support.
> 
> mpage_da_map_blocks block allocation failed for inode 377954 at logical
> offset 313 with max blocks 4 with error -28
> mpage_da_map_blocks block allocation failed for inode 336367 at logical
> offset 74 with max blocks 9 with error -28
> mpage_da_map_blocks block allocation failed for inode 345560 at logical
> offset 542 with max blocks 7 with error -28
> This should not happen.!! Data will be lost
> mpage_da_map_blocks block allocation failed for inode 355317 at logical
> offset 152 with max blocks 10 with error -28
> This should not happen.!! Data will be lost
> mpage_da_map_blocks block allocation failed for inode 395261 at logical
> offset 462 with max blocks 1 with error -28
> This should not happen.!! Data will be lost
> mpage_da_map_blocks block allocation failed for inode 323784 at logical
> offset 313 with max blocks 11 with error -28
> This should not happen.!! Data will be lost
> 

I tried this patch. There are still multiple ways we can get wrong free
block count. The patch reduced the number of errors. So we are doing
better with patch. But I guess we can't use the percpu_counter based
free block accounting with delalloc. Without delalloc it is ok even if
we find some wrong free blocks count . The actual block allocation will fail in
that case and we handle it perfectly fine. With delalloc we cannot
afford to fail the block allocation. Should we look at a free block
accounting rewrite using simple ext4_fsblk_t and and a spin lock ?

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index dfe2d4f..00934b1 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -1624,7 +1624,7 @@ ext4_fsblk_t ext4_has_free_blocks(struct ext4_sb_info *sbi,
 		(sbi->s_resgid == 0 || !in_group_p(sbi->s_resgid)))
 		root_blocks = ext4_r_blocks_count(sbi->s_es);
 #ifdef CONFIG_SMP
-	if (free_blocks - root_blocks < FBC_BATCH)
+	if (free_blocks - (nblocks + root_blocks) < FBC_BATCH)
 		free_blocks =
 			percpu_counter_sum_and_set(&sbi->s_freeblocks_counter);
 #endif
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1c289c1..f825470 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1543,7 +1543,14 @@ static int ext4_da_reserve_space(struct inode *inode, int nrblocks)
 	}
 	/* reduce fs free blocks counter */
 	percpu_counter_sub(&sbi->s_freeblocks_counter, total);
