From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH] Convert ext4_lock_group to use sb_bgl_lock
Date: Tue, 28 Apr 2009 01:04:56 +0530
Message-ID: <1240860896-2011-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:57860 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554AbZD0TfJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Apr 2009 15:35:09 -0400
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id n3RJWvji025076
	for <linux-ext4@vger.kernel.org>; Tue, 28 Apr 2009 05:32:57 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3RJZ5Uh1241336
	for <linux-ext4@vger.kernel.org>; Tue, 28 Apr 2009 05:35:05 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n3RJZ4me010631
	for <linux-ext4@vger.kernel.org>; Tue, 28 Apr 2009 05:35:05 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We have sb_bgl_lock() and ext4_group_info.bb_state
bit spinlock to protech group information. The later is only
used within mballoc code. Consolidate them to use sb_bgl_lock().
This makes the mballoc.c code much simpler and also avoid
confusion with two locks protecting same info.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

---
 fs/ext4/balloc.c  |   12 ++++----
 fs/ext4/ext4.h    |   19 +++++-------
 fs/ext4/ext4_sb.h |    5 ---
 fs/ext4/ialloc.c  |   29 +++++++++----------
 fs/ext4/mballoc.c |   78 ++++++++++++++++++----------------------------------
 fs/ext4/super.c   |    6 ++--
 6 files changed, 58 insertions(+), 91 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 53c72ad..4eed7cc 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -326,16 +326,16 @@ ext4_read_block_bitmap(struct super_block *sb, ext4_group_t block_group)
 		unlock_buffer(bh);
 		return bh;
 	}
-	spin_lock(sb_bgl_lock(EXT4_SB(sb), block_group));
+	ext4_lock_group(sb, block_group);
 	if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
 		ext4_init_block_bitmap(sb, bh, block_group, desc);
 		set_bitmap_uptodate(bh);
 		set_buffer_uptodate(bh);
-		spin_unlock(sb_bgl_lock(EXT4_SB(sb), block_group));
+		ext4_unlock_group(sb, block_group);
 		unlock_buffer(bh);
 		return bh;
 	}
-	spin_unlock(sb_bgl_lock(EXT4_SB(sb), block_group));
+	ext4_unlock_group(sb, block_group);
 	if (buffer_uptodate(bh)) {
 		/*
 		 * if not uninit if bh is uptodate,
@@ -451,7 +451,7 @@ void ext4_add_groupblocks(handle_t *handle, struct super_block *sb,
 	down_write(&grp->alloc_sem);
 	for (i = 0, blocks_freed = 0; i < count; i++) {
 		BUFFER_TRACE(bitmap_bh, "clear bit");
-		if (!ext4_clear_bit_atomic(sb_bgl_lock(sbi, block_group),
+		if (!ext4_clear_bit_atomic(ext4_group_lock(sb, block_group),
 						bit + i, bitmap_bh->b_data)) {
 			ext4_error(sb, __func__,
 				   "bit already cleared for block %llu",
@@ -461,11 +461,11 @@ void ext4_add_groupblocks(handle_t *handle, struct super_block *sb,
 			blocks_freed++;
 		}
 	}
-	spin_lock(sb_bgl_lock(sbi, block_group));
+	ext4_lock_group(sb, block_group);
 	blk_free_count = blocks_freed + ext4_free_blks_count(sb, desc);
 	ext4_free_blks_set(sb, desc, blk_free_count);
 	desc->bg_checksum = ext4_group_desc_csum(sbi, block_group, desc);
-	spin_unlock(sb_bgl_lock(sbi, block_group));
+	ext4_unlock_group(sb, block_group);
 	percpu_counter_add(&sbi->s_freeblocks_counter, blocks_freed);
 
 	if (sbi->s_log_groups_per_flex) {
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index d0f15ef..9090bbb 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1283,33 +1283,30 @@ struct ext4_group_info {
 };
 
 #define EXT4_GROUP_INFO_NEED_INIT_BIT	0
-#define EXT4_GROUP_INFO_LOCKED_BIT	1
 
 #define EXT4_MB_GRP_NEED_INIT(grp)	\
 	(test_bit(EXT4_GROUP_INFO_NEED_INIT_BIT, &((grp)->bb_state)))
 
-static inline void ext4_lock_group(struct super_block *sb, ext4_group_t group)
+static inline spinlock_t *ext4_group_lock(struct super_block *sb, ext4_group_t group)
 {
-	struct ext4_group_info *grinfo = ext4_get_group_info(sb, group);
+	return bgl_lock_ptr(EXT4_SB(sb)->s_blockgroup_lock, group);
+}
 
-	bit_spin_lock(EXT4_GROUP_INFO_LOCKED_BIT, &(grinfo->bb_state));
+static inline void ext4_lock_group(struct super_block *sb, ext4_group_t group)
+{
+	spin_lock(ext4_group_lock(sb, group));
 }
 
 static inline void ext4_unlock_group(struct super_block *sb,
 					ext4_group_t group)
 {
-	struct ext4_group_info *grinfo = ext4_get_group_info(sb, group);
-
-	bit_spin_unlock(EXT4_GROUP_INFO_LOCKED_BIT, &(grinfo->bb_state));
+	spin_unlock(ext4_group_lock(sb, group));
 }
 
 static inline int ext4_is_group_locked(struct super_block *sb,
 					ext4_group_t group)
 {
-	struct ext4_group_info *grinfo = ext4_get_group_info(sb, group);
-
-	return bit_spin_is_locked(EXT4_GROUP_INFO_LOCKED_BIT,
-						&(grinfo->bb_state));
+	return spin_is_locked(ext4_group_lock(sb, group));
 }
 
 /*
diff --git a/fs/ext4/ext4_sb.h b/fs/ext4/ext4_sb.h
index 57b71fe..e41c7fe 100644
--- a/fs/ext4/ext4_sb.h
+++ b/fs/ext4/ext4_sb.h
@@ -152,10 +152,5 @@ struct ext4_sb_info {
 	struct flex_groups *s_flex_groups;
 };
 
-static inline spinlock_t *
-sb_bgl_lock(struct ext4_sb_info *sbi, unsigned int block_group)
-{
-	return bgl_lock_ptr(sbi->s_blockgroup_lock, block_group);
-}
 
 #endif	/* _EXT4_SB */
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index f18e0a0..7c00032 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -123,16 +123,16 @@ ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
 		unlock_buffer(bh);
 		return bh;
 	}
-	spin_lock(sb_bgl_lock(EXT4_SB(sb), block_group));
+	ext4_lock_group(sb, block_group);
 	if (desc->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)) {
 		ext4_init_inode_bitmap(sb, bh, block_group, desc);
 		set_bitmap_uptodate(bh);
 		set_buffer_uptodate(bh);
-		spin_unlock(sb_bgl_lock(EXT4_SB(sb), block_group));
+		ext4_unlock_group(sb, block_group);
 		unlock_buffer(bh);
 		return bh;
 	}
-	spin_unlock(sb_bgl_lock(EXT4_SB(sb), block_group));
+	ext4_unlock_group(sb, block_group);
 	if (buffer_uptodate(bh)) {
 		/*
 		 * if not uninit if bh is uptodate,
@@ -247,9 +247,8 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
 		goto error_return;
 
 	/* Ok, now we can actually update the inode bitmaps.. */
-	spin_lock(sb_bgl_lock(sbi, block_group));
-	cleared = ext4_clear_bit(bit, bitmap_bh->b_data);
-	spin_unlock(sb_bgl_lock(sbi, block_group));
+	cleared = ext4_clear_bit_atomic(ext4_group_lock(sb, block_group),
+					bit, bitmap_bh->b_data);
 	if (!cleared)
 		ext4_error(sb, "ext4_free_inode",
 			   "bit already cleared for inode %lu", ino);
@@ -261,7 +260,7 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
 		if (fatal) goto error_return;
 
 		if (gdp) {
-			spin_lock(sb_bgl_lock(sbi, block_group));
+			ext4_lock_group(sb, block_group);
 			count = ext4_free_inodes_count(sb, gdp) + 1;
 			ext4_free_inodes_set(sb, gdp, count);
 			if (is_directory) {
@@ -277,7 +276,7 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
 			}
 			gdp->bg_checksum = ext4_group_desc_csum(sbi,
 							block_group, gdp);
-			spin_unlock(sb_bgl_lock(sbi, block_group));
+			ext4_unlock_group(sb, block_group);
 			percpu_counter_inc(&sbi->s_freeinodes_counter);
 			if (is_directory)
 				percpu_counter_dec(&sbi->s_dirs_counter);
@@ -708,10 +707,10 @@ static int find_group_other(struct super_block *sb, struct inode *parent,
 
 /*
  * claim the inode from the inode bitmap. If the group
- * is uninit we need to take the groups's sb_bgl_lock
+ * is uninit we need to take the groups's ext4_group_lock
  * and clear the uninit flag. The inode bitmap update
  * and group desc uninit flag clear should be done
- * after holding sb_bgl_lock so that ext4_read_inode_bitmap
+ * after holding ext4_group_lock so that ext4_read_inode_bitmap
  * doesn't race with the ext4_claim_inode
  */
 static int ext4_claim_inode(struct super_block *sb,
@@ -722,7 +721,7 @@ static int ext4_claim_inode(struct super_block *sb,
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_group_desc *gdp = ext4_get_group_desc(sb, group, NULL);
 
-	spin_lock(sb_bgl_lock(sbi, group));
+	ext4_lock_group(sb, group);
 	if (ext4_set_bit(ino, inode_bitmap_bh->b_data)) {
 		/* not a free inode */
 		retval = 1;
@@ -731,7 +730,7 @@ static int ext4_claim_inode(struct super_block *sb,
 	ino++;
 	if ((group == 0 && ino < EXT4_FIRST_INO(sb)) ||
 			ino > EXT4_INODES_PER_GROUP(sb)) {
-		spin_unlock(sb_bgl_lock(sbi, group));
+		ext4_unlock_group(sb, group);
 		ext4_error(sb, __func__,
 			   "reserved inode or inode > inodes count - "
 			   "block_group = %u, inode=%lu", group,
@@ -780,7 +779,7 @@ static int ext4_claim_inode(struct super_block *sb,
 	}
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, group, gdp);
 err_ret:
-	spin_unlock(sb_bgl_lock(sbi, group));
+	ext4_unlock_group(sb, group);
 	return retval;
 }
 
@@ -938,7 +937,7 @@ got:
 		}
 
 		free = 0;
-		spin_lock(sb_bgl_lock(sbi, group));
+		ext4_lock_group(sb, group);
 		/* recheck and clear flag under lock if we still need to */
 		if (gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
 			free = ext4_free_blocks_after_init(sb, group, gdp);
@@ -947,7 +946,7 @@ got:
 			gdp->bg_checksum = ext4_group_desc_csum(sbi, group,
 								gdp);
 		}
-		spin_unlock(sb_bgl_lock(sbi, group));
+		ext4_unlock_group(sb, group);
 
 		/* Don't need to dirty bitmap block if we didn't change it */
 		if (free) {
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index f871677..2e81421 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -372,24 +372,12 @@ static inline void mb_set_bit(int bit, void *addr)
 	ext4_set_bit(bit, addr);
 }
 
-static inline void mb_set_bit_atomic(spinlock_t *lock, int bit, void *addr)
-{
-	addr = mb_correct_addr_and_bit(&bit, addr);
-	ext4_set_bit_atomic(lock, bit, addr);
-}
-
 static inline void mb_clear_bit(int bit, void *addr)
 {
 	addr = mb_correct_addr_and_bit(&bit, addr);
 	ext4_clear_bit(bit, addr);
 }
 
-static inline void mb_clear_bit_atomic(spinlock_t *lock, int bit, void *addr)
-{
-	addr = mb_correct_addr_and_bit(&bit, addr);
-	ext4_clear_bit_atomic(lock, bit, addr);
-}
-
 static inline int mb_find_next_zero_bit(void *addr, int max, int start)
 {
 	int fix = 0, ret, tmpmax;
@@ -801,17 +789,17 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 			unlock_buffer(bh[i]);
 			continue;
 		}
-		spin_lock(sb_bgl_lock(EXT4_SB(sb), first_group + i));
+		ext4_lock_group(sb, first_group + i);
 		if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
 			ext4_init_block_bitmap(sb, bh[i],
 						first_group + i, desc);
 			set_bitmap_uptodate(bh[i]);
 			set_buffer_uptodate(bh[i]);
-			spin_unlock(sb_bgl_lock(EXT4_SB(sb), first_group + i));
+			ext4_unlock_group(sb, first_group + i);
 			unlock_buffer(bh[i]);
 			continue;
 		}
-		spin_unlock(sb_bgl_lock(EXT4_SB(sb), first_group + i));
+		ext4_unlock_group(sb, first_group + i);
 		if (buffer_uptodate(bh[i])) {
 			/*
 			 * if not uninit if bh is uptodate,
@@ -1078,7 +1066,7 @@ static int mb_find_order_for_block(struct ext4_buddy *e4b, int block)
 	return 0;
 }
 
-static void mb_clear_bits(spinlock_t *lock, void *bm, int cur, int len)
+static void mb_clear_bits(void *bm, int cur, int len)
 {
 	__u32 *addr;
 
@@ -1091,15 +1079,12 @@ static void mb_clear_bits(spinlock_t *lock, void *bm, int cur, int len)
 			cur += 32;
 			continue;
 		}
-		if (lock)
-			mb_clear_bit_atomic(lock, cur, bm);
-		else
-			mb_clear_bit(cur, bm);
+		mb_clear_bit(cur, bm);
 		cur++;
 	}
 }
 
-static void mb_set_bits(spinlock_t *lock, void *bm, int cur, int len)
+static void mb_set_bits(void *bm, int cur, int len)
 {
 	__u32 *addr;
 
@@ -1112,10 +1097,7 @@ static void mb_set_bits(spinlock_t *lock, void *bm, int cur, int len)
 			cur += 32;
 			continue;
 		}
-		if (lock)
-			mb_set_bit_atomic(lock, cur, bm);
-		else
-			mb_set_bit(cur, bm);
+		mb_set_bit(cur, bm);
 		cur++;
 	}
 }
@@ -1330,8 +1312,7 @@ static int mb_mark_used(struct ext4_buddy *e4b, struct ext4_free_extent *ex)
 		e4b->bd_info->bb_counters[ord]++;
 	}
 
-	mb_set_bits(sb_bgl_lock(EXT4_SB(e4b->bd_sb), ex->fe_group),
-			EXT4_MB_BITMAP(e4b), ex->fe_start, len0);
+	mb_set_bits(EXT4_MB_BITMAP(e4b), ex->fe_start, len0);
 	mb_check_buddy(e4b);
 
 	return ret;
@@ -2761,7 +2742,7 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
 	return 0;
 }
 
-/* need to called with ext4 group lock (ext4_lock_group) */
+/* need to called with ext4_group_lock() held */
 static void ext4_mb_cleanup_pa(struct ext4_group_info *grp)
 {
 	struct ext4_prealloc_space *pa;
@@ -2997,14 +2978,17 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 		 * Fix the bitmap and repeat the block allocation
 		 * We leak some of the blocks here.
 		 */
-		mb_set_bits(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group),
-				bitmap_bh->b_data, ac->ac_b_ex.fe_start,
-				ac->ac_b_ex.fe_len);
+		ext4_lock_group(sb, ac->ac_b_ex.fe_group);
+		mb_set_bits(bitmap_bh->b_data, ac->ac_b_ex.fe_start,
+			    ac->ac_b_ex.fe_len);
+		ext4_unlock_group(sb, ac->ac_b_ex.fe_group);
 		err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
 		if (!err)
 			err = -EAGAIN;
 		goto out_err;
 	}
+
+	ext4_lock_group(sb, ac->ac_b_ex.fe_group);
 #ifdef AGGRESSIVE_CHECK
 	{
 		int i;
@@ -3014,9 +2998,7 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 		}
 	}
 #endif
-	spin_lock(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group));
-	mb_set_bits(NULL, bitmap_bh->b_data,
-				ac->ac_b_ex.fe_start, ac->ac_b_ex.fe_len);
+	mb_set_bits(bitmap_bh->b_data, ac->ac_b_ex.fe_start,ac->ac_b_ex.fe_len);
 	if (gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
 		gdp->bg_flags &= cpu_to_le16(~EXT4_BG_BLOCK_UNINIT);
 		ext4_free_blks_set(sb, gdp,
@@ -3026,7 +3008,8 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	len = ext4_free_blks_count(sb, gdp) - ac->ac_b_ex.fe_len;
 	ext4_free_blks_set(sb, gdp, len);
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, ac->ac_b_ex.fe_group, gdp);
-	spin_unlock(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group));
+
+	ext4_unlock_group(sb, ac->ac_b_ex.fe_group);
 	percpu_counter_sub(&sbi->s_freeblocks_counter, ac->ac_b_ex.fe_len);
 	/*
 	 * Now reduce the dirty block count also. Should not go negative
@@ -3459,7 +3442,7 @@ ext4_mb_use_preallocated(struct ext4_allocation_context *ac)
  * the function goes through all block freed in the group
  * but not yet committed and marks them used in in-core bitmap.
  * buddy must be generated from this bitmap
- * Need to be called with ext4 group lock (ext4_lock_group)
+ * Need to be called with ext4_group_lock() held
  */
 static void ext4_mb_generate_from_freelist(struct super_block *sb, void *bitmap,
 						ext4_group_t group)
@@ -3473,9 +3456,7 @@ static void ext4_mb_generate_from_freelist(struct super_block *sb, void *bitmap,
 
 	while (n) {
 		entry = rb_entry(n, struct ext4_free_data, node);
-		mb_set_bits(sb_bgl_lock(EXT4_SB(sb), group),
-				bitmap, entry->start_blk,
-				entry->count);
+		mb_set_bits(bitmap, entry->start_blk, entry->count);
 		n = rb_next(n);
 	}
 	return;
@@ -3484,7 +3465,7 @@ static void ext4_mb_generate_from_freelist(struct super_block *sb, void *bitmap,
 /*
  * the function goes through all preallocation in this group and marks them
  * used in in-core bitmap. buddy must be generated from this bitmap
- * Need to be called with ext4 group lock (ext4_lock_group)
+ * Need to be called with ext4_group_lock() held
  */
 static void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
 					ext4_group_t group)
@@ -3516,8 +3497,7 @@ static void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
 		if (unlikely(len == 0))
 			continue;
 		BUG_ON(groupnr != group);
-		mb_set_bits(sb_bgl_lock(EXT4_SB(sb), group),
-						bitmap, start, len);
+		mb_set_bits(bitmap, start, len);
 		preallocated += len;
 		count++;
 	}
@@ -4859,29 +4839,25 @@ do_more:
 		new_entry->group  = block_group;
 		new_entry->count = count;
 		new_entry->t_tid = handle->h_transaction->t_tid;
+
 		ext4_lock_group(sb, block_group);
-		mb_clear_bits(sb_bgl_lock(sbi, block_group), bitmap_bh->b_data,
-				bit, count);
+		mb_clear_bits(bitmap_bh->b_data, bit, count);
 		ext4_mb_free_metadata(handle, &e4b, new_entry);
-		ext4_unlock_group(sb, block_group);
 	} else {
-		ext4_lock_group(sb, block_group);
 		/* need to update group_info->bb_free and bitmap
 		 * with group lock held. generate_buddy look at
 		 * them with group lock_held
 		 */
-		mb_clear_bits(sb_bgl_lock(sbi, block_group), bitmap_bh->b_data,
-				bit, count);
+		ext4_lock_group(sb, block_group);
+		mb_clear_bits(bitmap_bh->b_data, bit, count);
 		mb_free_blocks(inode, &e4b, bit, count);
 		ext4_mb_return_to_preallocation(inode, &e4b, block, count);
-		ext4_unlock_group(sb, block_group);
 	}
 
-	spin_lock(sb_bgl_lock(sbi, block_group));
 	ret = ext4_free_blks_count(sb, gdp) + count;
 	ext4_free_blks_set(sb, gdp, ret);
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, block_group, gdp);
-	spin_unlock(sb_bgl_lock(sbi, block_group));
+	ext4_unlock_group(sb, block_group);
 	percpu_counter_add(&sbi->s_freeblocks_counter, count);
 
 	if (sbi->s_log_groups_per_flex) {
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 2958f4e..8e9955d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1744,18 +1744,18 @@ static int ext4_check_descriptors(struct super_block *sb)
 			       "(block %llu)!\n", i, inode_table);
 			return 0;
 		}
-		spin_lock(sb_bgl_lock(sbi, i));
+		ext4_lock_group(sb, i);
 		if (!ext4_group_desc_csum_verify(sbi, i, gdp)) {
 			printk(KERN_ERR "EXT4-fs: ext4_check_descriptors: "
 			       "Checksum for group %u failed (%u!=%u)\n",
 			       i, le16_to_cpu(ext4_group_desc_csum(sbi, i,
 			       gdp)), le16_to_cpu(gdp->bg_checksum));
 			if (!(sb->s_flags & MS_RDONLY)) {
-				spin_unlock(sb_bgl_lock(sbi, i));
+				ext4_unlock_group(sb, i);
 				return 0;
 			}
 		}
-		spin_unlock(sb_bgl_lock(sbi, i));
+		ext4_unlock_group(sb, i);
 		if (!flexbg_flag)
 			first_block += EXT4_BLOCKS_PER_GROUP(sb);
 	}
-- 
tg: (ce8a742..) ext4_lock_group_conversion (depends on: master)
