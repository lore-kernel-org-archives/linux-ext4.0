From: "Jayson R. King" <dev@jaysonking.com>
Subject: [04/11] ext4: Add percpu dirty block accounting.
Date: Sat, 27 Feb 2010 00:32:34 -0600
Message-ID: <4B88BC82.2000101@jaysonking.com>
References: <4B88BA1B.4050500@jaysonking.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Mingming Cao <cmm@us.ibm.com>, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Jayson King <dev@jaysonking.com>
To: LKML <linux-kernel@vger.kernel.org>,
	Stable team <stable@kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bosmailout03.eigbox.net ([66.96.187.3]:40980 "EHLO
	bosmailout03.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150Ab0B0HV6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 27 Feb 2010 02:21:58 -0500
In-Reply-To: <4B88BA1B.4050500@jaysonking.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date: Fri Oct 10 09:39:00 2008 -0400
Subject: ext4: Add percpu dirty block accounting.

commit 6bc6e63fcd7dac9e633ea29f1fddd9580ab28f3f upstream.

This patch adds dirty block accounting using percpu_counters.  Delayed
allocation block reservation is now done by updating dirty block
counter.  In a later patch we switch to non delalloc mode if the
filesystem free blocks is greater than 150% of total filesystem dirty
blocks

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Mingming Cao<cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Jayson R. King <dev@jaysonking.com>

---
 fs/ext4/balloc.c  |   62 ++++++++++++++++++++++++++++----------------
 fs/ext4/ext4_sb.h |    1 
 fs/ext4/inode.c   |   22 +++++++--------
 fs/ext4/mballoc.c |   31 +++++++++-------------
 fs/ext4/super.c   |    8 ++++-
 5 files changed, 73 insertions(+), 51 deletions(-)

diff -urNp linux-2.6.27.orig/fs/ext4/balloc.c linux-2.6.27/fs/ext4/balloc.c
--- linux-2.6.27.orig/fs/ext4/balloc.c	2010-02-26 14:21:03.148252808 -0600
+++ linux-2.6.27/fs/ext4/balloc.c	2010-02-26 14:21:14.292252864 -0600
@@ -1757,26 +1757,38 @@ out:
 int ext4_claim_free_blocks(struct ext4_sb_info *sbi,
 						ext4_fsblk_t nblocks)
 {
-	s64 free_blocks;
+	s64 free_blocks, dirty_blocks;
 	ext4_fsblk_t root_blocks = 0;
 	struct percpu_counter *fbc = &sbi->s_freeblocks_counter;
+	struct percpu_counter *dbc = &sbi->s_dirtyblocks_counter;
 
-	free_blocks = percpu_counter_read(fbc);
+	free_blocks  = percpu_counter_read_positive(fbc);
+	dirty_blocks = percpu_counter_read_positive(dbc);
 
 	if (!capable(CAP_SYS_RESOURCE) &&
 		sbi->s_resuid != current->fsuid &&
 		(sbi->s_resgid == 0 || !in_group_p(sbi->s_resgid)))
 		root_blocks = ext4_r_blocks_count(sbi->s_es);
 
-	if (free_blocks - (nblocks + root_blocks) < EXT4_FREEBLOCKS_WATERMARK)
-		free_blocks = percpu_counter_sum(&sbi->s_freeblocks_counter);
-
-	if (free_blocks < (root_blocks + nblocks))
+	if (free_blocks - (nblocks + root_blocks + dirty_blocks) <
+						EXT4_FREEBLOCKS_WATERMARK) {
+		free_blocks  = percpu_counter_sum(fbc);
+		dirty_blocks = percpu_counter_sum(dbc);
+		if (dirty_blocks < 0) {
+			printk(KERN_CRIT "Dirty block accounting "
+					"went wrong %lld\n",
+					dirty_blocks);
+		}
+	}
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
 
@@ -1792,23 +1804,28 @@ int ext4_claim_free_blocks(struct ext4_s
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
 		(sbi->s_resgid == 0 || !in_group_p(sbi->s_resgid)))
 		root_blocks = ext4_r_blocks_count(sbi->s_es);
 
-	if (free_blocks - (nblocks + root_blocks) < EXT4_FREEBLOCKS_WATERMARK)
-		free_blocks = percpu_counter_sum_positive(&sbi->s_freeblocks_counter);
-
-	if (free_blocks <= root_blocks)
+	if (free_blocks - (nblocks + root_blocks + dirty_blocks) <
+						EXT4_FREEBLOCKS_WATERMARK) {
+		free_blocks  = percpu_counter_sum_positive(fbc);
+		dirty_blocks = percpu_counter_sum_positive(dbc);
+	}
+	if (free_blocks <= (root_blocks + dirty_blocks))
 		/* we don't have free space */
 		return 0;
-	if (free_blocks - root_blocks < nblocks)
+	if (free_blocks - (root_blocks + dirty_blocks) < nblocks)
 		return free_blocks - root_blocks;
 	return nblocks;
 }
@@ -2089,13 +2106,14 @@ allocated:
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
+	if (!EXT4_I(inode)->i_delalloc_reserved_flag)
+		percpu_counter_sub(&sbi->s_dirtyblocks_counter, *count);
+	else
+		percpu_counter_sub(&sbi->s_dirtyblocks_counter, num);
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi, group_no);
 		spin_lock(sb_bgl_lock(sbi, flex_group));
diff -urNp linux-2.6.27.orig/fs/ext4/ext4_sb.h linux-2.6.27/fs/ext4/ext4_sb.h
--- linux-2.6.27.orig/fs/ext4/ext4_sb.h	2010-02-26 14:10:41.167252303 -0600
+++ linux-2.6.27/fs/ext4/ext4_sb.h	2010-02-26 14:21:14.292252864 -0600
@@ -60,6 +60,7 @@ struct ext4_sb_info {
 	struct percpu_counter s_freeblocks_counter;
 	struct percpu_counter s_freeinodes_counter;
 	struct percpu_counter s_dirs_counter;
+	struct percpu_counter s_dirtyblocks_counter;
 	struct blockgroup_lock s_blockgroup_lock;
 
 	/* root of the per fs reservation window tree */
diff -urNp linux-2.6.27.orig/fs/ext4/inode.c linux-2.6.27/fs/ext4/inode.c
--- linux-2.6.27.orig/fs/ext4/inode.c	2010-02-26 14:21:03.149252723 -0600
+++ linux-2.6.27/fs/ext4/inode.c	2010-02-26 14:21:14.293252633 -0600
@@ -1032,19 +1032,20 @@ static void ext4_da_update_reserve_space
 	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
 	mdb_free = EXT4_I(inode)->i_reserved_meta_blocks - mdb;
 
-	/* Account for allocated meta_blocks */
-	mdb_free -= EXT4_I(inode)->i_allocated_meta_blocks;
-
-	/* update fs free blocks counter for truncate case */
-	percpu_counter_add(&sbi->s_freeblocks_counter, mdb_free);
+	if (mdb_free) {
+		/* Account for allocated meta_blocks */
+		mdb_free -= EXT4_I(inode)->i_allocated_meta_blocks;
+
+		/* update fs dirty blocks counter */
+		percpu_counter_sub(&sbi->s_dirtyblocks_counter, mdb_free);
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
 
 	/*
@@ -1609,8 +1610,8 @@ static void ext4_da_release_space(struct
 
 	release = to_free + mdb_free;
 
-	/* update fs free blocks counter for truncate case */
-	percpu_counter_add(&sbi->s_freeblocks_counter, release);
+	/* update fs dirty blocks counter for truncate case */
+	percpu_counter_sub(&sbi->s_dirtyblocks_counter, release);
 
 	/* update per-inode reservations */
 	BUG_ON(to_free > EXT4_I(inode)->i_reserved_data_blocks);
@@ -2546,7 +2547,6 @@ static int ext4_da_write_begin(struct fi
 	index = pos >> PAGE_CACHE_SHIFT;
 	from = pos & (PAGE_CACHE_SIZE - 1);
 	to = from + len;
-
 retry:
 	/*
 	 * With delayed allocation, we don't log the i_disksize update
diff -urNp linux-2.6.27.orig/fs/ext4/mballoc.c linux-2.6.27/fs/ext4/mballoc.c
--- linux-2.6.27.orig/fs/ext4/mballoc.c	2010-02-26 14:21:03.150252678 -0600
+++ linux-2.6.27/fs/ext4/mballoc.c	2010-02-26 14:21:14.294252546 -0600
@@ -3100,7 +3100,7 @@ void exit_ext4_mballoc(void)
  */
 static noinline_for_stack int
 ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
-				handle_t *handle)
+				handle_t *handle, unsigned long reserv_blks)
 {
 	struct buffer_head *bitmap_bh = NULL;
 	struct ext4_super_block *es;
@@ -3188,21 +3188,16 @@ ext4_mb_mark_diskspace_used(struct ext4_
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
+	if (!(ac->ac_flags & EXT4_MB_DELALLOC_RESERVED))
+		/* release all the reserved blocks if non delalloc */
+		percpu_counter_sub(&sbi->s_dirtyblocks_counter, reserv_blks);
+	else
+		percpu_counter_sub(&sbi->s_dirtyblocks_counter,
+						ac->ac_b_ex.fe_len);
 
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi,
@@ -4636,12 +4631,13 @@ static int ext4_mb_discard_preallocation
 ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 				 struct ext4_allocation_request *ar, int *errp)
 {
+	int freed;
 	struct ext4_allocation_context *ac = NULL;
 	struct ext4_sb_info *sbi;
 	struct super_block *sb;
 	ext4_fsblk_t block = 0;
-	int freed;
-	int inquota;
+	unsigned long inquota;
+	unsigned long reserv_blks = 0;
 
 	sb = ar->inode->i_sb;
 	sbi = EXT4_SB(sb);
@@ -4659,6 +4655,7 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t
 			*errp = -ENOSPC;
 			return 0;
 		}
+		reserv_blks = ar->len;
 	}
 	while (ar->len && DQUOT_ALLOC_BLOCK(ar->inode, ar->len)) {
 		ar->flags |= EXT4_MB_HINT_NOPREALLOC;
@@ -4704,7 +4701,7 @@ repeat:
 			ext4_mb_new_preallocation(ac);
 	}
 	if (likely(ac->ac_status == AC_STATUS_FOUND)) {
-		*errp = ext4_mb_mark_diskspace_used(ac, handle);
+		*errp = ext4_mb_mark_diskspace_used(ac, handle, reserv_blks);
 		if (*errp ==  -EAGAIN) {
 			/*
 			 * drop the reference that we took
diff -urNp linux-2.6.27.orig/fs/ext4/super.c linux-2.6.27/fs/ext4/super.c
--- linux-2.6.27.orig/fs/ext4/super.c	2010-02-26 14:10:41.170252357 -0600
+++ linux-2.6.27/fs/ext4/super.c	2010-02-26 14:21:14.295252319 -0600
@@ -520,6 +520,7 @@ static void ext4_put_super(struct super_
 	percpu_counter_destroy(&sbi->s_freeblocks_counter);
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
 	percpu_counter_destroy(&sbi->s_dirs_counter);
+	percpu_counter_destroy(&sbi->s_dirtyblocks_counter);
 	brelse(sbi->s_sbh);
 #ifdef CONFIG_QUOTA
 	for (i = 0; i < MAXQUOTAS; i++)
@@ -2279,6 +2280,9 @@ static int ext4_fill_super(struct super_
 		err = percpu_counter_init(&sbi->s_dirs_counter,
 				ext4_count_dirs(sb));
 	}
+	if (!err) {
+		err = percpu_counter_init(&sbi->s_dirtyblocks_counter, 0);
+	}
 	if (err) {
 		printk(KERN_ERR "EXT4-fs: insufficient memory\n");
 		goto failed_mount3;
@@ -2516,6 +2520,7 @@ failed_mount3:
 	percpu_counter_destroy(&sbi->s_freeblocks_counter);
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
 	percpu_counter_destroy(&sbi->s_dirs_counter);
+	percpu_counter_destroy(&sbi->s_dirtyblocks_counter);
 failed_mount2:
 	for (i = 0; i < db_count; i++)
 		brelse(sbi->s_group_desc[i]);
@@ -3207,7 +3212,8 @@ static int ext4_statfs(struct dentry *de
 	buf->f_type = EXT4_SUPER_MAGIC;
 	buf->f_bsize = sb->s_blocksize;
 	buf->f_blocks = ext4_blocks_count(es) - sbi->s_overhead_last;
-	buf->f_bfree = percpu_counter_sum_positive(&sbi->s_freeblocks_counter);
+	buf->f_bfree = percpu_counter_sum_positive(&sbi->s_freeblocks_counter) -
+		       percpu_counter_sum_positive(&sbi->s_dirtyblocks_counter);
 	ext4_free_blocks_count_set(es, buf->f_bfree);
 	buf->f_bavail = buf->f_bfree - ext4_r_blocks_count(es);
 	if (buf->f_bfree < ext4_r_blocks_count(es))
