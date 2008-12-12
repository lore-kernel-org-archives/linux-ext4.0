From: Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH V4 3/3]ext4: quota handling for delayed allocation
Date: Fri, 12 Dec 2008 12:47:43 -0800
Message-ID: <1229114863.7646.27.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: jack@suse.cz, tytso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:60425 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798AbYLLUrt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Dec 2008 15:47:49 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: quota reservation for delayed allocation

Uses quota reservation/claim/release to handle quota properly for delayed
allocation in the three steps: 1) quotas are reserved when data being copied
to cache when block allocation is defered 2) when new blocks are allocated.
reserved quotas are converted to the real allocated quota, 2) over-booked
quotas for metadata blocks are released back.


Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/inode.c   |   25 ++++++++++++++++++++++---
 fs/ext4/mballoc.c |   43 ++++++++++++++++++++++++++-----------------
 fs/ext4/super.c   |    3 +++
 3 files changed, 51 insertions(+), 20 deletions(-)

Index: linux-2.6.28-rc2/fs/ext4/inode.c
===================================================================
--- linux-2.6.28-rc2.orig/fs/ext4/inode.c	2008-12-10 11:27:32.000000000 -0800
+++ linux-2.6.28-rc2/fs/ext4/inode.c	2008-12-12 12:22:26.000000000 -0800
@@ -1017,8 +1017,14 @@ static void ext4_da_update_reserve_space
 	/* update per-inode reservations */
 	BUG_ON(used  > EXT4_I(inode)->i_reserved_data_blocks);
 	EXT4_I(inode)->i_reserved_data_blocks -= used;
-
 	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
+
+	/*
+	 * free those over-booking quota for metadata blocks
+	 */
+
+	if (mdb_free)
+		vfs_dq_release_reservation_block(inode, mdb_free);
 }
 
 /*
@@ -1514,8 +1520,8 @@ static int ext4_journalled_write_end(str
 static int ext4_da_reserve_space(struct inode *inode, int nrblocks)
 {
 	int retries = 0;
-       struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-       unsigned long md_needed, mdblocks, total = 0;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	unsigned long md_needed, mdblocks, total = 0;
 
 	/*
 	 * recalculate the amount of metadata blocks to reserve
@@ -1531,12 +1537,23 @@ repeat:
 	md_needed = mdblocks - EXT4_I(inode)->i_reserved_meta_blocks;
 	total = md_needed + nrblocks;
 
+	/*
+	 * Make quota reservation here to prevent quota overflow
+	 * later. Real quota accounting is done at pages writeout
+	 * time.
+	 */
+	if (vfs_dq_reserve_block(inode, total)) {
+		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
+		return -EDQUOT;
+	}
+
 	if (ext4_claim_free_blocks(sbi, total)) {
 		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
 			yield();
 			goto repeat;
 		}
+		vfs_dq_release_reservation_block(inode, total);
 		return -ENOSPC;
 	}
 	EXT4_I(inode)->i_reserved_data_blocks += nrblocks;
@@ -1590,6 +1607,8 @@ static void ext4_da_release_space(struct
 	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
 	EXT4_I(inode)->i_reserved_meta_blocks = mdb;
 	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
+
+	vfs_dq_release_reservation_block(inode, release);
 }
 
 static void ext4_da_page_release_reservation(struct page *page,
Index: linux-2.6.28-rc2/fs/ext4/super.c
===================================================================
--- linux-2.6.28-rc2.orig/fs/ext4/super.c	2008-12-10 11:27:32.000000000 -0800
+++ linux-2.6.28-rc2/fs/ext4/super.c	2008-12-12 12:22:08.000000000 -0800
@@ -795,6 +795,9 @@ static struct dquot_operations ext4_quot
 	.initialize	= ext4_dquot_initialize,
 	.drop		= ext4_dquot_drop,
 	.alloc_space	= dquot_alloc_space,
+	.reserve_space	= dquot_reserve_space,
+	.claim_space	= dquot_claim_space,
+	.release_rsv	= dquot_release_reserved_space,
 	.alloc_inode	= dquot_alloc_inode,
 	.free_space	= dquot_free_space,
 	.free_inode	= dquot_free_inode,
Index: linux-2.6.28-rc2/fs/ext4/mballoc.c
===================================================================
--- linux-2.6.28-rc2.orig/fs/ext4/mballoc.c	2008-12-10 11:27:32.000000000 -0800
+++ linux-2.6.28-rc2/fs/ext4/mballoc.c	2008-12-12 12:22:26.000000000 -0800
@@ -2887,9 +2887,12 @@ ext4_mb_mark_diskspace_used(struct ext4_
 	if (!(ac->ac_flags & EXT4_MB_DELALLOC_RESERVED))
 		/* release all the reserved blocks if non delalloc */
 		percpu_counter_sub(&sbi->s_dirtyblocks_counter, reserv_blks);
-	else
+	else {
 		percpu_counter_sub(&sbi->s_dirtyblocks_counter,
 						ac->ac_b_ex.fe_len);
+		/* convert reserved quota blocks to real quota blocks */
+		vfs_dq_claim_block(ac->ac_inode, ac->ac_b_ex.fe_len);
+	}
 
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi,
@@ -4286,15 +4289,24 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t
 	struct ext4_sb_info *sbi;
 	struct super_block *sb;
 	ext4_fsblk_t block = 0;
-	unsigned long inquota;
+	unsigned long inquota = 0;
 	unsigned long reserv_blks = 0;
 
 	sb = ar->inode->i_sb;
 	sbi = EXT4_SB(sb);
 
-	if (!EXT4_I(ar->inode)->i_delalloc_reserved_flag) {
+	/*
+	 * For delayed allocation, we could skip the ENOSPC and
+	 * EDQUOT check, as blocks and quotas have been already
+	 * reserved when data being copied into pagecache.
+	 */
+	if (EXT4_I(ar->inode)->i_delalloc_reserved_flag)
+		ar->flags |= EXT4_MB_DELALLOC_RESERVED;
+	else {
 		/*
-		 * With delalloc we already reserved the blocks
+		 * Without delayed allocation we need to verify
+		 * there is enough free blocks to do block allocation
+		 * and verify allocation doesn't exceed the quota limits.
 		 */
 		while (ar->len && ext4_claim_free_blocks(sbi, ar->len)) {
 			/* let others to free the space */
@@ -4306,19 +4318,16 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t
 			return 0;
 		}
 		reserv_blks = ar->len;
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
-	while (ar->len && DQUOT_ALLOC_BLOCK(ar->inode, ar->len)) {
-		ar->flags |= EXT4_MB_HINT_NOPREALLOC;
-		ar->len--;
-	}
-	if (ar->len == 0) {
-		*errp = -EDQUOT;
-		return 0;
-	}
-	inquota = ar->len;
