From: Mingming Cao <cmm@us.ibm.com>
Subject: [RFC PATCH 3/3] ext4: quota handling for delayed allocation
Date: Wed, 29 Oct 2008 17:59:23 -0700
Message-ID: <1225328363.6405.36.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>, tytso <tytso@mit.edu>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

ext4: quota reservation for delayed allocation

Uses quota reservation/claim/release to handle quota properly for delayed
allocation in the three steps: 1) quotas are reserved when data being copied
to cache when block allocation is defered 2) when new blocks are allocated.
reserved quotas are converted to the real allocated quota, 2) over-booked
quotas for metadata blocks are released back.


Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/inode.c   |   25 ++++++++++++++++++++++++-
 fs/ext4/mballoc.c |   18 +++++++++---------
 fs/ext4/super.c   |    2 ++
 3 files changed, 35 insertions(+), 10 deletions(-)

Index: linux-2.6.28-rc2/fs/ext4/inode.c
===================================================================
--- linux-2.6.28-rc2.orig/fs/ext4/inode.c	2008-10-26 12:13:29.000000000 -0700
+++ linux-2.6.28-rc2/fs/ext4/inode.c	2008-10-28 17:38:07.000000000 -0700
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
Index: linux-2.6.28-rc2/fs/ext4/super.c
===================================================================
--- linux-2.6.28-rc2.orig/fs/ext4/super.c	2008-10-28 16:01:42.000000000 -0700
+++ linux-2.6.28-rc2/fs/ext4/super.c	2008-10-28 17:38:07.000000000 -0700
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
--- linux-2.6.28-rc2.orig/fs/ext4/mballoc.c	2008-10-28 16:00:53.000000000 -0700
+++ linux-2.6.28-rc2/fs/ext4/mballoc.c	2008-10-28 17:38:07.000000000 -0700
@@ -2887,9 +2887,12 @@ ext4_mb_mark_diskspace_used(struct ext4_
 	if (!(ac->ac_flags & EXT4_MB_DELALLOC_RESERVED))
 		/* release all the reserved blocks if non delalloc */
 		percpu_counter_sub(&sbi->s_dirtyblocks_counter, reserv_blks);
-	else
+	else {
 		percpu_counter_sub(&sbi->s_dirtyblocks_counter,
 						ac->ac_b_ex.fe_len);
+		DQUOT_CLAIM_BLOCK(ac->ac_inode, ac->ac_b_ex.fe_len);
+		printk("allocatin %d blocks, charged to quota\n", ac->ac_b_ex.fe_len);
+	}
 
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi,
@@ -4306,14 +4309,14 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t
 			return 0;
 		}
 		reserv_blks = ar->len;
-	}
-	while (ar->len && DQUOT_ALLOC_BLOCK(ar->inode, ar->len)) {
-		ar->flags |= EXT4_MB_HINT_NOPREALLOC;
-		ar->len--;
-	}
-	if (ar->len == 0) {
-		*errp = -EDQUOT;
-		return 0;
+		while (ar->len && DQUOT_ALLOC_BLOCK(ar->inode, ar->len)) {
+			ar->flags |= EXT4_MB_HINT_NOPREALLOC;
+			ar->len--;
+		}
+		if (ar->len == 0) {
+			*errp = -EDQUOT;
+			return 0;
+		}
 	}
 	inquota = ar->len;
 
@@ -4380,7 +4383,7 @@ repeat:
 out2:
 	kmem_cache_free(ext4_ac_cachep, ac);
 out1:
-	if (ar->len < inquota)
+	if (inquota && ar->len < inquota)
 		DQUOT_FREE_BLOCK(ar->inode, inquota - ar->len);
 
 	return block;



