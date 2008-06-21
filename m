From: Mingming <cmm@us.ibm.com>
Subject: [PATCH] delalloc: add quota handling
Date: Fri, 20 Jun 2008 18:14:38 -0700
Message-ID: <1214010878.27507.228.camel@BVR-FS.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:39107 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbYFUBOE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Jun 2008 21:14:04 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m5L1E4ER015601
	for <linux-ext4@vger.kernel.org>; Fri, 20 Jun 2008 21:14:04 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5L1E4B3174074
	for <linux-ext4@vger.kernel.org>; Fri, 20 Jun 2008 19:14:04 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5L1E2iJ003029
	for <linux-ext4@vger.kernel.org>; Fri, 20 Jun 2008 19:14:02 -0600
Received: from [9.47.17.71] (BVR-FS.beaverton.ibm.com [9.47.17.71])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id m5L1E2un003022
	for <linux-ext4@vger.kernel.org>; Fri, 20 Jun 2008 19:14:02 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Correct quota handling in delayed allocation. With this patch,
the quota for blocks are counted at block reservation time when
the fs free blocks counter are updated, instead of at later 
block allocation time.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/balloc.c  |    8 +++++---
 fs/ext4/inode.c   |    5 +++++
 fs/ext4/mballoc.c |   22 ++++++++++++----------
 3 files changed, 22 insertions(+), 13 deletions(-)

Index: linux-2.6.26-rc6/fs/ext4/balloc.c
===================================================================
--- linux-2.6.26-rc6.orig/fs/ext4/balloc.c	2008-06-20 18:06:02.000000000 -0700
+++ linux-2.6.26-rc6/fs/ext4/balloc.c	2008-06-20 18:06:05.000000000 -0700
@@ -1716,7 +1716,8 @@ ext4_fsblk_t ext4_old_new_blocks(handle_
 	/*
 	 * Check quota for allocation of this block.
 	 */
-	if (DQUOT_ALLOC_BLOCK(inode, num)) {
+	if (!EXT4_I(inode)->i_delalloc_reserved_flag &&
+	     DQUOT_ALLOC_BLOCK(inode, num)) {
 		*errp = -EDQUOT;
 		return 0;
 	}
@@ -1928,7 +1929,8 @@ allocated:
 
 	*errp = 0;
 	brelse(bitmap_bh);
-	DQUOT_FREE_BLOCK(inode, *count-num);
+	if (!EXT4_I(inode)->i_delalloc_reserved_flag)
+		DQUOT_FREE_BLOCK(inode, *count-num);
 	*count = num;
 	return ret_block;
 
@@ -1942,7 +1944,7 @@ out:
 	/*
 	 * Undo the block allocation
 	 */
-	if (!performed_allocation)
+	if (!EXT4_I(inode)->i_delalloc_reserved_flag && !performed_allocation)
 		DQUOT_FREE_BLOCK(inode, *count);
 	brelse(bitmap_bh);
 	return 0;
Index: linux-2.6.26-rc6/fs/ext4/inode.c
===================================================================
--- linux-2.6.26-rc6.orig/fs/ext4/inode.c	2008-06-20 18:06:02.000000000 -0700
+++ linux-2.6.26-rc6/fs/ext4/inode.c	2008-06-20 18:06:05.000000000 -0700
@@ -1450,6 +1450,9 @@ static int ext4_da_reserve_space(struct 
 		return -ENOSPC;
 	}
 
+	if (DQUOT_ALLOC_BLOCK(inode, total))
+		return -EDQUOT;
+
 	/* reduce fs free blocks counter */
 	percpu_counter_sub(&sbi->s_freeblocks_counter, total);
 
@@ -1479,6 +1482,8 @@ void ext4_da_release_space(struct inode 
 
 	release = to_free + mdb_free;
 
+	DQUOT_FREE_BLOCK(inode, release);
+
 	/* update fs free blocks counter for truncate case */
 	percpu_counter_add(&sbi->s_freeblocks_counter, release);
 
Index: linux-2.6.26-rc6/fs/ext4/mballoc.c
===================================================================
--- linux-2.6.26-rc6.orig/fs/ext4/mballoc.c	2008-06-20 18:06:01.000000000 -0700
+++ linux-2.6.26-rc6/fs/ext4/mballoc.c	2008-06-20 18:06:05.000000000 -0700
@@ -4037,7 +4037,7 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t
 	struct super_block *sb;
 	ext4_fsblk_t block = 0;
 	int freed;
-	int inquota;
+	int inquota = 0;
 
 	sb = ar->inode->i_sb;
 	sbi = EXT4_SB(sb);
@@ -4059,15 +4059,17 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t
 		return 0;
 	}
 
-	while (ar->len && DQUOT_ALLOC_BLOCK(ar->inode, ar->len)) {
-		ar->flags |= EXT4_MB_HINT_NOPREALLOC;
-		ar->len--;
-	}
-	if (ar->len == 0) {
-		*errp = -EDQUOT;
-		return 0;
+	if (!EXT4_I(ar->inode)->i_delalloc_reserved_flag) {
+		while (ar->len && DQUOT_ALLOC_BLOCK(ar->inode, ar->len)) {
+			ar->flags |= EXT4_MB_HINT_NOPREALLOC;
+			ar->len--;
+		}
+		if (ar->len == 0) {
+			*errp = -EDQUOT;
+			return 0;
+		}
+		inquota = ar->len;
 	}
-	inquota = ar->len;
 
 	if (EXT4_I(ar->inode)->i_delalloc_reserved_flag)
 		ar->flags |= EXT4_MB_DELALLOC_RESERVED;
@@ -4134,7 +4136,7 @@ repeat:
 out2:
 	kmem_cache_free(ext4_ac_cachep, ac);
 out1:
-	if (ar->len < inquota)
+	if (!EXT4_I(ar->inode)->i_delalloc_reserved_flag && ar->len < inquota)
 		DQUOT_FREE_BLOCK(ar->inode, inquota - ar->len);
 
 	return block;


