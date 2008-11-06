From: akpm@linux-foundation.org
Subject: - ext4-quota-handling-for-delayed-allocation.patch removed from -mm tree
Date: Thu, 06 Nov 2008 15:51:21 -0800
Message-ID: <200811062351.mA6NpLDq030278@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: cmm@us.ibm.com, jack@ucw.cz, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext4: quota handling for delayed allocation
has been removed from the -mm tree.  Its filename was
     ext4-quota-handling-for-delayed-allocation.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext4: quota handling for delayed allocation
From: Mingming Cao <cmm@us.ibm.com>

Use quota reservation/claim/release to handle quota properly for delayed
allocation in three steps:

1) quotas are reserved when data is being copied to cache when block
   allocation is defered

2) when new blocks are allocated, reserved quotas are converted to the
   real allocated quota

3) over-booked quotas for metadata blocks are released back.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Cc: Jan Kara <jack@ucw.cz>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/inode.c   |   29 ++++++++++++++++++++++++++---
 fs/ext4/mballoc.c |   42 +++++++++++++++++++++++++-----------------
 fs/ext4/super.c   |    3 +++
 3 files changed, 54 insertions(+), 20 deletions(-)

diff -puN fs/ext4/inode.c~ext4-quota-handling-for-delayed-allocation fs/ext4/inode.c
--- a/fs/ext4/inode.c~ext4-quota-handling-for-delayed-allocation
+++ a/fs/ext4/inode.c
@@ -994,7 +994,9 @@ static void ext4_da_update_reserve_space
 {
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	int total, mdb, mdb_free;
+	int claim_quota, free_quota = 0;
 
+	claim_quota = used;
 	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
 	/* recalculate the number of metablocks still need to be reserved */
 	total = EXT4_I(inode)->i_reserved_data_blocks - used;
@@ -1007,6 +1009,8 @@ static void ext4_da_update_reserve_space
 	if (mdb_free) {
 		/* Account for allocated meta_blocks */
 		mdb_free -= EXT4_I(inode)->i_allocated_meta_blocks;
+		free_quota = mdb_free;
+		claim_quota += EXT4_I(inode)->i_allocated_meta_blocks;
 
 		/* update fs dirty blocks counter */
 		percpu_counter_sub(&sbi->s_dirtyblocks_counter, mdb_free);
@@ -1017,8 +1021,14 @@ static void ext4_da_update_reserve_space
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
+	if (free_quota)
+		DQUOT_RELEASE_RSV_BLOCK(inode, free_quota);
 }
 
 /*
@@ -1514,8 +1524,8 @@ static int ext4_journalled_write_end(str
 static int ext4_da_reserve_space(struct inode *inode, int nrblocks)
 {
 	int retries = 0;
-       struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-       unsigned long md_needed, mdblocks, total = 0;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	unsigned long md_needed, mdblocks, total = 0;
 
 	/*
 	 * recalculate the amount of metadata blocks to reserve
@@ -1531,12 +1541,23 @@ repeat:
 	md_needed = mdblocks - EXT4_I(inode)->i_reserved_meta_blocks;
 	total = md_needed + nrblocks;
 
+	/*
+	 * Make quota reservation here, to prevent quota overflow
+	 * later.Real quota accounting is done at pages writeout
+	 * time
+	 */
+	 if (DQUOT_RESERVE_BLOCK(inode, total)) {
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
+		DQUOT_RELEASE_RSV_BLOCK(inode,total);
 		return -ENOSPC;
 	}
 	EXT4_I(inode)->i_reserved_data_blocks += nrblocks;
@@ -1590,6 +1611,8 @@ static void ext4_da_release_space(struct
 	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
 	EXT4_I(inode)->i_reserved_meta_blocks = mdb;
 	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
+
+	DQUOT_RELEASE_RSV_BLOCK(inode, release);
 }
 
 static void ext4_da_page_release_reservation(struct page *page,
diff -puN fs/ext4/mballoc.c~ext4-quota-handling-for-delayed-allocation fs/ext4/mballoc.c
--- a/fs/ext4/mballoc.c~ext4-quota-handling-for-delayed-allocation
+++ a/fs/ext4/mballoc.c
@@ -2887,9 +2887,11 @@ ext4_mb_mark_diskspace_used(struct ext4_
 	if (!(ac->ac_flags & EXT4_MB_DELALLOC_RESERVED))
 		/* release all the reserved blocks if non delalloc */
 		percpu_counter_sub(&sbi->s_dirtyblocks_counter, reserv_blks);
-	else
+	else {
 		percpu_counter_sub(&sbi->s_dirtyblocks_counter,
 						ac->ac_b_ex.fe_len);
+		DQUOT_CLAIM_BLOCK(ac->ac_inode, ac->ac_b_ex.fe_len);
+	}
 
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi,
@@ -4286,15 +4288,24 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t
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
+	 * reserved when data being copied to cache
+	 */
+	if (EXT4_I(ar->inode)->i_delalloc_reserved_flag)
+		ar->flags |= EXT4_MB_DELALLOC_RESERVED;
+	else {
 		/*
-		 * With delalloc we already reserved the blocks
+		 * Without delayed allocation we need to verify
+		 * there is enough free blocks to do block allocation
+		 * and under the quota limits
 		 */
 		while (ar->len && ext4_claim_free_blocks(sbi, ar->len)) {
 			/* let others to free the space */
@@ -4306,19 +4317,16 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t
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
-
-	if (EXT4_I(ar->inode)->i_delalloc_reserved_flag)
-		ar->flags |= EXT4_MB_DELALLOC_RESERVED;
 
 	ac = kmem_cache_alloc(ext4_ac_cachep, GFP_NOFS);
 	if (!ac) {
@@ -4380,7 +4388,7 @@ repeat:
 out2:
 	kmem_cache_free(ext4_ac_cachep, ac);
 out1:
-	if (ar->len < inquota)
+	if (inquota && ar->len < inquota)
 		DQUOT_FREE_BLOCK(ar->inode, inquota - ar->len);
 
 	return block;
diff -puN fs/ext4/super.c~ext4-quota-handling-for-delayed-allocation fs/ext4/super.c
--- a/fs/ext4/super.c~ext4-quota-handling-for-delayed-allocation
+++ a/fs/ext4/super.c
@@ -803,6 +803,9 @@ static struct dquot_operations ext4_quot
 	.initialize	= ext4_dquot_initialize,
 	.drop		= ext4_dquot_drop,
 	.alloc_space	= dquot_alloc_space,
+	.reserve_space	= dquot_reserve_space,
+	.claim_space	= dquot_claim_space,
+	.release_rsv	= dquot_release_reserved_space,
 	.alloc_inode	= dquot_alloc_inode,
 	.free_space	= dquot_free_space,
 	.free_inode	= dquot_free_inode,
_

Patches currently in -mm which might be from cmm@us.ibm.com are

ext4-quota-handling-for-delayed-allocation.patch
ext4-quota-handling-for-delayed-allocation-checkpatch-fixes.patch

