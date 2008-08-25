From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH -v2] ext4: Add percpu dirty block accounting.
Date: Mon, 25 Aug 2008 16:50:31 +0530
Message-ID: <1219663233-21849-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1219663233-21849-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219663233-21849-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219663233-21849-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:37305 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753088AbYHYLUm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Aug 2008 07:20:42 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp04.in.ibm.com (8.13.1/8.13.1) with ESMTP id m7PBKcFW014028
	for <linux-ext4@vger.kernel.org>; Mon, 25 Aug 2008 16:50:38 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7PBKbpC1806498
	for <linux-ext4@vger.kernel.org>; Mon, 25 Aug 2008 16:50:38 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id m7PBKb9N014112
	for <linux-ext4@vger.kernel.org>; Mon, 25 Aug 2008 16:50:37 +0530
In-Reply-To: <1219663233-21849-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch add dirty block accounting using percpu_counters.
Delayed allocation block reservation is now done by updating
dirty block counter. In the later patch we switch to non
delalloc mode if the filesystem free blocks is < that
150 % of total filesystem  dirty blocks

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/balloc.c  |   64 ++++++++++++++++++++++++++++------------------------
 fs/ext4/ext4_sb.h |    1 +
 fs/ext4/inode.c   |   25 ++++++++++++--------
 fs/ext4/mballoc.c |   17 ++-----------
 fs/ext4/super.c   |    8 +++++-
 5 files changed, 60 insertions(+), 55 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index b7d1347..4ebe3b6 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -1605,11 +1605,13 @@ ext4_try_to_allocate_with_rsv(struct super_block *sb, handle_t *handle,
 int ext4_claim_free_blocks(struct ext4_sb_info *sbi,
 						ext4_fsblk_t nblocks)
 {
-	s64 free_blocks;
+	s64 free_blocks, dirty_blocks;
 	ext4_fsblk_t root_blocks = 0;
 	struct percpu_counter *fbc = &sbi->s_freeblocks_counter;
+	struct percpu_counter *dbc = &sbi->s_dirtyblocks_counter;
 
-	free_blocks = percpu_counter_read(fbc);
+	free_blocks = percpu_counter_read_positive(fbc);
+	dirty_blocks = percpu_counter_read_positive(dbc);
 
 	if (!capable(CAP_SYS_RESOURCE) &&
 		sbi->s_resuid != current->fsuid &&
@@ -1620,26 +1622,27 @@ int ext4_claim_free_blocks(struct ext4_sb_info *sbi,
 	 * counters. So we need to make sure we have free blocks more
 	 * than FBC_BATCH  * nr_cpu_ids. Also add a window of 4 times.
 	 */
-	if (free_blocks - (nblocks + root_blocks) <
+	if (free_blocks - (nblocks + root_blocks + dirty_blocks) <
 				(4 * (FBC_BATCH * nr_cpu_ids))) {
-		/*
-		 * We need to sum and claim under lock
-		 * This is the slow patch which will be
-		 * taken when we are very low on free blocks
-		 */
-		if (percpu_counter_sum_and_sub(fbc, nblocks + root_blocks))
-			return -ENOSPC;
-		/* add root_blocks back */
-		percpu_counter_add(fbc, root_blocks);
-		return 0;
+
+		free_blocks  = percpu_counter_sum(fbc);
+		dirty_blocks = percpu_counter_sum(dbc);
+		if (dirty_blocks < 0) {
+			printk(KERN_CRIT "Dirty block accounting "
+					"went wrong %lld\n",
+					dirty_blocks);
+		}
 	}
 #endif
-	if (free_blocks < (root_blocks + nblocks))
+	/* Check whether we have space after
+	 * accounting for current dirty blocks
+	 */
+	if (free_blocks < ((s64)(root_blocks + nblocks) + dirty_blocks))
 		/* we don't have free space */
 		return -ENOSPC;
 
-	/* reduce fs free blocks counter */
-	percpu_counter_sub(fbc, nblocks);
+	/* Add the blocks to nblocks */
+	percpu_counter_add(dbc, nblocks);
 	return 0;
 }
 
@@ -1655,10 +1658,13 @@ int ext4_claim_free_blocks(struct ext4_sb_info *sbi,
 ext4_fsblk_t ext4_has_free_blocks(struct ext4_sb_info *sbi,
 						ext4_fsblk_t nblocks)
 {
-	ext4_fsblk_t free_blocks;
+	ext4_fsblk_t free_blocks, dirty_blocks;
 	ext4_fsblk_t root_blocks = 0;
+	struct percpu_counter *fbc = &sbi->s_freeblocks_counter;
+	struct percpu_counter *dbc = &sbi->s_dirtyblocks_counter;
 
-	free_blocks = percpu_counter_read_positive(&sbi->s_freeblocks_counter);
+	free_blocks  = percpu_counter_read_positive(fbc);
+	dirty_blocks = percpu_counter_read_positive(dbc);
 
 	if (!capable(CAP_SYS_RESOURCE) &&
 		sbi->s_resuid != current->fsuid &&
@@ -1669,16 +1675,16 @@ ext4_fsblk_t ext4_has_free_blocks(struct ext4_sb_info *sbi,
 	 * counters. So we need to make sure we have free blocks more
 	 * than FBC_BATCH  * nr_cpu_ids. Also add a window of 4 times.
 	 */
-	if (free_blocks - (nblocks + root_blocks) <
+	if (free_blocks - (nblocks + root_blocks + dirty_blocks) <
 				(4 * (FBC_BATCH * nr_cpu_ids))) {
-		free_blocks =
-			percpu_counter_sum(&sbi->s_freeblocks_counter);
+		free_blocks = percpu_counter_sum_positive(fbc);
+		dirty_blocks = percpu_counter_sum_positive(dbc);
 	}
 #endif
-	if (free_blocks <= root_blocks)
+	if (free_blocks <= (root_blocks + dirty_blocks))
 		/* we don't have free space */
 		return 0;
-	if (free_blocks - root_blocks < nblocks)
+	if (free_blocks - (root_blocks + dirty_blocks) < nblocks)
 		return free_blocks - root_blocks;
 	return nblocks;
 }
@@ -1965,13 +1971,11 @@ ext4_fsblk_t ext4_old_new_blocks(handle_t *handle, struct inode *inode,
 	le16_add_cpu(&gdp->bg_free_blocks_count, -num);
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, group_no, gdp);
 	spin_unlock(sb_bgl_lock(sbi, group_no));
-	if (!EXT4_I(inode)->i_delalloc_reserved_flag && (*count != num)) {
-		/*
-		 * we allocated less blocks than we
-		 * claimed. Add the difference back.
-		 */
-		percpu_counter_add(&sbi->s_freeblocks_counter, *count - num);
-	}
+	percpu_counter_sub(&sbi->s_freeblocks_counter, num);
+	/*
+	 * Now reduce the dirty block count also. Should not go negative
+	 */
+	percpu_counter_sub(&sbi->s_dirtyblocks_counter, num);
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi, group_no);
 		spin_lock(sb_bgl_lock(sbi, flex_group));
diff --git a/fs/ext4/ext4_sb.h b/fs/ext4/ext4_sb.h
index 6300226..0fa3762 100644
--- a/fs/ext4/ext4_sb.h
+++ b/fs/ext4/ext4_sb.h
@@ -59,6 +59,7 @@ struct ext4_sb_info {
 	struct percpu_counter s_freeblocks_counter;
 	struct percpu_counter s_freeinodes_counter;
 	struct percpu_counter s_dirs_counter;
+	struct percpu_counter s_dirtyblocks_counter;
 	struct blockgroup_lock s_blockgroup_lock;
 
 	/* root of the per fs reservation window tree */
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 72a4a71..3f3ecc0 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1030,19 +1030,25 @@ static void ext4_da_update_reserve_space(struct inode *inode, int used)
 	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
 	mdb_free = EXT4_I(inode)->i_reserved_meta_blocks - mdb;
 
-	/* Account for allocated meta_blocks */
-	mdb_free -= EXT4_I(inode)->i_allocated_meta_blocks;
+	if (mdb_free) {
+		/* Account for allocated meta_blocks */
+		mdb_free -= EXT4_I(inode)->i_allocated_meta_blocks;
 
-	/* update fs free blocks counter for truncate case */
-	percpu_counter_add(&sbi->s_freeblocks_counter, mdb_free);
+		/* update fs dirty blocks counter */
+		/*
+		 * FIXME!! doing this get the free block count wrong
+		 * But we need to take care of over allocated meta-data
+		 * blocks
+		 */
+		//percpu_counter_sub(&sbi->s_dirtyblocks_counter, mdb_free);
+		EXT4_I(inode)->i_allocated_meta_blocks = 0;
+		EXT4_I(inode)->i_reserved_meta_blocks = mdb;
+	}
 
 	/* update per-inode reservations */
 	BUG_ON(used  > EXT4_I(inode)->i_reserved_data_blocks);
 	EXT4_I(inode)->i_reserved_data_blocks -= used;
 
-	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
-	EXT4_I(inode)->i_reserved_meta_blocks = mdb;
-	EXT4_I(inode)->i_allocated_meta_blocks = 0;
 	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 }
 
@@ -1588,8 +1594,8 @@ static void ext4_da_release_space(struct inode *inode, int to_free)
 
 	release = to_free + mdb_free;
 
-	/* update fs free blocks counter for truncate case */
-	percpu_counter_add(&sbi->s_freeblocks_counter, release);
+	/* update fs dirty blocks counter for truncate case */
+	percpu_counter_sub(&sbi->s_dirtyblocks_counter, release);
 
 	/* update per-inode reservations */
 	BUG_ON(to_free > EXT4_I(inode)->i_reserved_data_blocks);
@@ -2490,7 +2496,6 @@ static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
 	index = pos >> PAGE_CACHE_SHIFT;
 	from = pos & (PAGE_CACHE_SIZE - 1);
 	to = from + len;
-
 retry:
 	/*
 	 * With delayed allocation, we don't log the i_disksize update
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 419009f..4da4b9a 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2971,22 +2971,11 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	le16_add_cpu(&gdp->bg_free_blocks_count, -ac->ac_b_ex.fe_len);
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, ac->ac_b_ex.fe_group, gdp);
 	spin_unlock(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group));
-
+	percpu_counter_sub(&sbi->s_freeblocks_counter, ac->ac_b_ex.fe_len);
 	/*
-	 * free blocks account has already be reduced/reserved
-	 * at write_begin() time for delayed allocation
-	 * do not double accounting
+	 * Now reduce the dirty block count also. Should not go negative
 	 */
-	if (!(ac->ac_flags & EXT4_MB_DELALLOC_RESERVED) &&
-			ac->ac_o_ex.fe_len != ac->ac_b_ex.fe_len) {
-		/*
-		 * we allocated less blocks than we calimed
-		 * Add the difference back
-		 */
-		percpu_counter_add(&sbi->s_freeblocks_counter,
-				ac->ac_o_ex.fe_len - ac->ac_b_ex.fe_len);
-	}
-
+	percpu_counter_sub(&sbi->s_dirtyblocks_counter, ac->ac_b_ex.fe_len);
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi,
 							  ac->ac_b_ex.fe_group);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ed77786..7b9db51 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -520,6 +520,7 @@ static void ext4_put_super(struct super_block *sb)
 	percpu_counter_destroy(&sbi->s_freeblocks_counter);
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
 	percpu_counter_destroy(&sbi->s_dirs_counter);
+	percpu_counter_destroy(&sbi->s_dirtyblocks_counter);
 	brelse(sbi->s_sbh);
 #ifdef CONFIG_QUOTA
 	for (i = 0; i < MAXQUOTAS; i++)
@@ -2259,6 +2260,9 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		err = percpu_counter_init(&sbi->s_dirs_counter,
 				ext4_count_dirs(sb));
 	}
+	if (!err) {
+		err = percpu_counter_init(&sbi->s_dirtyblocks_counter, 0);
+	}
 	if (err) {
 		printk(KERN_ERR "EXT4-fs: insufficient memory\n");
 		goto failed_mount3;
@@ -2491,6 +2495,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	percpu_counter_destroy(&sbi->s_freeblocks_counter);
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
 	percpu_counter_destroy(&sbi->s_dirs_counter);
+	percpu_counter_destroy(&sbi->s_dirtyblocks_counter);
 failed_mount2:
 	for (i = 0; i < db_count; i++)
 		brelse(sbi->s_group_desc[i]);
@@ -3164,7 +3169,8 @@ static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_type = EXT4_SUPER_MAGIC;
 	buf->f_bsize = sb->s_blocksize;
 	buf->f_blocks = ext4_blocks_count(es) - sbi->s_overhead_last;
-	buf->f_bfree = percpu_counter_sum_positive(&sbi->s_freeblocks_counter);
+	buf->f_bfree = percpu_counter_sum_positive(&sbi->s_freeblocks_counter) -
+		       percpu_counter_sum_positive(&sbi->s_dirtyblocks_counter);
 	ext4_free_blocks_count_set(es, buf->f_bfree);
 	buf->f_bavail = buf->f_bfree - ext4_r_blocks_count(es);
 	if (buf->f_bfree < ext4_r_blocks_count(es))
-- 
1.6.0.1.90.g27a6e

