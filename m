From: Valerie Clement <Valerie.Clement@bull.net>
Subject: [RFC][PATCH 2/4] BIG_BG: larger block bitmaps
Date: 24 Nov 2006 17:48:31 +0100
Message-ID: <1164386910.17961.75.camel@ckrm>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:27311 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP id S934973AbWKXQ6O
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Nov 2006 11:58:14 -0500
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id D9C0219D934
	for <linux-ext4@vger.kernel.org>; Fri, 24 Nov 2006 17:58:09 +0100 (CET)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 21174-01 for <linux-ext4@vger.kernel.org>;
 Fri, 24 Nov 2006 17:58:03 +0100 (CET)
Received: from ckrm.frec.bull.fr (unknown [172.16.109.44])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 54D9E19D932
	for <linux-ext4@vger.kernel.org>; Fri, 24 Nov 2006 17:58:03 +0100 (CET)
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch modifies the read_block_bitmap() and the block allocation functions to take into account that the block bitmap can be stored on several consecutive
blocks.


Signed-off-by: Valerie Clement <valerie.clement@bull.net>

 fs/ext4/balloc.c        |  150 ++++++++++++++++++++++++++++++++++--------------
 fs/ext4/super.c         |   36 ++++++-----
 include/linux/ext4_fs.h |    6 +
 3 files changed, 133 insertions(+), 59 deletions(-)

Index: linux-2.6.19-rc6/include/linux/ext4_fs.h
===================================================================
--- linux-2.6.19-rc6.orig/include/linux/ext4_fs.h	2006-11-17 12:13:52.000000000 +0100
+++ linux-2.6.19-rc6/include/linux/ext4_fs.h	2006-11-17 12:14:07.000000000 +0100
@@ -151,6 +151,12 @@ struct ext4_group_desc
 # define EXT4_DESC_PER_BLOCK(s)		(EXT4_SB(s)->s_desc_per_block)
 # define EXT4_INODES_PER_GROUP(s)	(EXT4_SB(s)->s_inodes_per_group)
 # define EXT4_DESC_PER_BLOCK_BITS(s)	(EXT4_SB(s)->s_desc_per_block_bits)
+# define EXT4_BITS_PER_BLOCK(s)		(EXT4_BLOCK_SIZE(s) << 3)
+# define EXT4_BITS_PER_BLOCK_BITS(s)	(EXT4_BLOCK_SIZE_BITS(s) + 3)
+# define EXT4_BLOCK_BITMAP_NBYTES(s)	((EXT4_BLOCKS_PER_GROUP(s) + 7) >> 3)
+# define EXT4_BLOCK_BITMAP_PER_GROUP(s)	((EXT4_BLOCK_BITMAP_NBYTES(s) + (EXT4_BLOCK_SIZE(s) - 1)) >> EXT4_BLOCK_SIZE_BITS(s))
+# define EXT4_INODE_BITMAP_NBYTES(s)	((EXT4_INODES_PER_GROUP(s) + 7) >> 3)
+# define EXT4_INODE_BITMAP_PER_GROUP(s)	((EXT4_INODE_BITMAP_NBYTES(s) + (EXT4_BLOCK_SIZE(s) - 1)) >> EXT4_BLOCK_SIZE_BITS(s))
 #else
 # define EXT4_BLOCKS_PER_GROUP(s)	((s)->s_blocks_per_group)
 # define EXT4_DESC_PER_BLOCK(s)		(EXT4_BLOCK_SIZE(s) / EXT4_DESC_SIZE(s))
Index: linux-2.6.19-rc6/fs/ext4/balloc.c
===================================================================
--- linux-2.6.19-rc6.orig/fs/ext4/balloc.c	2006-11-17 12:13:59.000000000 +0100
+++ linux-2.6.19-rc6/fs/ext4/balloc.c	2006-11-17 12:14:07.000000000 +0100
@@ -111,21 +111,22 @@ struct ext4_group_desc * ext4_get_group_
  * Return buffer_head on success or NULL in case of failure.
  */
 static struct buffer_head *
-read_block_bitmap(struct super_block *sb, unsigned int block_group)
+read_block_bitmap(struct super_block *sb, unsigned int block_group,
+						unsigned int bitmap_block)
 {
 	struct ext4_group_desc * desc;
 	struct buffer_head * bh = NULL;
 
-	desc = ext4_get_group_desc (sb, block_group, NULL);
+	desc = ext4_get_group_desc(sb, block_group, NULL);
 	if (!desc)
 		goto error_out;
-	bh = sb_bread(sb, ext4_block_bitmap(sb, desc));
+	bh = sb_bread(sb, bitmap_block + ext4_block_bitmap(sb, desc));
 	if (!bh)
 		ext4_error (sb, "read_block_bitmap",
 			    "Cannot read block bitmap - "
 			    "block_group = %d, block_bitmap = %llu",
 			    block_group,
-			    ext4_block_bitmap(sb, desc));
+			    bitmap_block + ext4_block_bitmap(sb, desc));
 error_out:
 	return bh;
 }
@@ -442,6 +443,7 @@ void ext4_free_blocks_sb(handle_t *handl
 	ext4_grpblk_t bit;
 	unsigned long i;
 	unsigned long overflow;
+	unsigned long overflow_bitmap;
 	struct ext4_group_desc * desc;
 	struct ext4_super_block * es;
 	struct ext4_sb_info *sbi;
@@ -462,9 +464,17 @@ void ext4_free_blocks_sb(handle_t *handl
 
 	ext4_debug ("freeing block(s) %llu-%llu\n", block, block + count - 1);
 
-do_more:
+do_more_group:
+	group_freed = 0;
 	overflow = 0;
 	ext4_get_group_no_and_offset(sb, block, &block_group, &bit);
+	desc = ext4_get_group_desc (sb, block_group, &gd_bh);
+	if (!desc)
+		goto error_return;
+
+do_more_bitmap:
+	overflow_bitmap = 0;
+	ext4_get_group_no_and_offset(sb, block, &block_group, &bit);
 	/*
 	 * Check to see if we are freeing blocks across a group
 	 * boundary.
@@ -477,20 +487,40 @@ do_more:
 	if (!desc)
 		goto error_return;
 
-	if (in_range(ext4_block_bitmap(sb, desc), block, count) ||
-	    in_range(ext4_inode_bitmap(sb, desc), block, count) ||
-	    in_range(block, ext4_inode_table(sb, desc), sbi->s_itb_per_group) ||
+	if (in_range(block, ext4_block_bitmap(sb, desc), 
+		     EXT4_BLOCK_BITMAP_PER_GROUP(sb)) ||
+	    in_range(block + count - 1, ext4_block_bitmap(sb, desc),
+		     EXT4_BLOCK_BITMAP_PER_GROUP(sb)) ||
+	    in_range(block, ext4_inode_bitmap(sb, desc), 
+		     EXT4_INODE_BITMAP_PER_GROUP(sb)) ||
+	    in_range(block + count - 1, ext4_inode_bitmap(sb, desc),
+		     EXT4_INODE_BITMAP_PER_GROUP(sb)) ||
+	    in_range(block, ext4_inode_table(sb, desc), 
+		     sbi->s_itb_per_group) ||
 	    in_range(block + count - 1, ext4_inode_table(sb, desc),
 		     sbi->s_itb_per_group))
 		ext4_error (sb, "ext4_free_blocks",
 			    "Freeing blocks in system zones - "
 			    "Block = %llu, count = %lu",
 			    block, count);
+	/* read bitmap */
 
 	brelse(bitmap_bh);
-	bitmap_bh = read_block_bitmap(sb, block_group);
+	bitmap_bh = read_block_bitmap(sb, block_group,
+					bit >> EXT4_BITS_PER_BLOCK_BITS(sb));
 	if (!bitmap_bh)
 		goto error_return;
+	bit &= (EXT4_BITS_PER_BLOCK(sb) - 1);
+
+	/*
+	 * check if we are freeing block accross bitmap blocks
+	 */
+
+	if (bit + count > EXT4_BITS_PER_BLOCK(sb)) {
+		overflow_bitmap = bit + count - EXT4_BITS_PER_BLOCK(sb);
+		count -= overflow_bitmap;
+	}
+
 	/*
 	 * We are about to start releasing blocks in the bitmap,
 	 * so we need undo access.
@@ -513,7 +543,7 @@ do_more:
 
 	jbd_lock_bh_state(bitmap_bh);
 
-	for (i = 0, group_freed = 0; i < count; i++) {
+	for (i = 0; i < count; i++) {
 		/*
 		 * An HJ special.  This is expensive...
 		 */
@@ -582,6 +612,16 @@ do_more:
 	}
 	jbd_unlock_bh_state(bitmap_bh);
 
+	/* We dirtied the bitmap block */
+	BUFFER_TRACE(bitmap_bh, "dirtied bitmap block");
+	err = ext4_journal_dirty_metadata(handle, bitmap_bh);
+
+	if (overflow_bitmap && !err) {
+		block += count;
+		count = overflow_bitmap;
+		goto do_more_bitmap;
+	}
+
 	spin_lock(sb_bgl_lock(sbi, block_group));
 	desc->bg_free_blocks_count =
 		cpu_to_le16(le16_to_cpu(desc->bg_free_blocks_count) +
@@ -589,11 +629,7 @@ do_more:
 	spin_unlock(sb_bgl_lock(sbi, block_group));
 	percpu_counter_mod(&sbi->s_freeblocks_counter, count);
 
-	/* We dirtied the bitmap block */
-	BUFFER_TRACE(bitmap_bh, "dirtied bitmap block");
-	err = ext4_journal_dirty_metadata(handle, bitmap_bh);
-
-	/* And the group descriptor block */
+	/* We dirtied  the group descriptor block */
 	BUFFER_TRACE(gd_bh, "dirtied group descriptor block");
 	ret = ext4_journal_dirty_metadata(handle, gd_bh);
 	if (!err) err = ret;
@@ -602,7 +638,7 @@ do_more:
 	if (overflow && !err) {
 		block += count;
 		count = overflow;
-		goto do_more;
+		goto do_more_group;
 	}
 	sb->s_dirt = 1;
 error_return:
@@ -797,6 +833,7 @@ claim_block(spinlock_t *lock, ext4_grpbl
  * @sb:			superblock
  * @handle:		handle to this transaction
  * @group:		given allocation block group
+ * @bitmap_block:	
  * @bitmap_bh:		bufferhead holds the block bitmap
  * @grp_goal:		given target block within the group
  * @count:		target number of blocks to allocate
@@ -818,25 +855,32 @@ claim_block(spinlock_t *lock, ext4_grpbl
  */
 static ext4_grpblk_t
 ext4_try_to_allocate(struct super_block *sb, handle_t *handle, int group,
-			struct buffer_head *bitmap_bh, ext4_grpblk_t grp_goal,
-			unsigned long *count, struct ext4_reserve_window *my_rsv)
+			int bitmap_block, struct buffer_head *bitmap_bh,
+			ext4_grpblk_t grp_goal, unsigned long *count,
+			struct ext4_reserve_window *my_rsv)
 {
 	ext4_fsblk_t group_first_block;
 	ext4_grpblk_t start, end;
 	unsigned long num = 0;
+	unsigned long offset;
+
+	offset = bitmap_block << EXT4_BITS_PER_BLOCK_BITS(sb);
+	if (grp_goal > 0)
+		grp_goal = grp_goal - offset;
 
 	/* we do allocation within the reservation window if we have a window */
 	if (my_rsv) {
-		group_first_block = ext4_group_first_block_no(sb, group);
+		group_first_block = ext4_group_first_block_no(sb, group) +
+			offset;
 		if (my_rsv->_rsv_start >= group_first_block)
 			start = my_rsv->_rsv_start - group_first_block;
 		else
 			/* reservation window cross group boundary */
 			start = 0;
 		end = my_rsv->_rsv_end - group_first_block + 1;
-		if (end > EXT4_BLOCKS_PER_GROUP(sb))
-			/* reservation window crosses group boundary */
-			end = EXT4_BLOCKS_PER_GROUP(sb);
+		if (end > EXT4_BITS_PER_BLOCK(sb))
+			/* reservation window crosses bitmap block boundary */
+			end = EXT4_BITS_PER_BLOCK(sb);
 		if ((start <= grp_goal) && (grp_goal < end))
 			start = grp_goal;
 		else
@@ -846,7 +890,7 @@ ext4_try_to_allocate(struct super_block 
 			start = grp_goal;
 		else
 			start = 0;
-		end = EXT4_BLOCKS_PER_GROUP(sb);
+		end = EXT4_BITS_PER_BLOCK(sb);
 	}
 
 	BUG_ON(start > EXT4_BLOCKS_PER_GROUP(sb));
@@ -890,7 +934,7 @@ repeat:
 		grp_goal++;
 	}
 	*count = num;
-	return grp_goal - num;
+	return offset + grp_goal - num;
 fail_access:
 	*count = num;
 	return -1;
@@ -1053,7 +1097,8 @@ static int find_next_reservable_window(
  */
 static int alloc_new_reservation(struct ext4_reserve_window_node *my_rsv,
 		ext4_grpblk_t grp_goal, struct super_block *sb,
-		unsigned int group, struct buffer_head *bitmap_bh)
+		unsigned int group, unsigned int bitmap_block,
+		struct buffer_head *bitmap_bh)
 {
 	struct ext4_reserve_window_node *search_head;
 	ext4_fsblk_t group_first_block, group_end_block, start_block;
@@ -1063,13 +1108,15 @@ static int alloc_new_reservation(struct 
 	int ret;
 	spinlock_t *rsv_lock = &EXT4_SB(sb)->s_rsv_window_lock;
 
-	group_first_block = ext4_group_first_block_no(sb, group);
-	group_end_block = group_first_block + (EXT4_BLOCKS_PER_GROUP(sb) - 1);
+	group_first_block = ext4_group_first_block_no(sb, group) +
+		(bitmap_block << EXT4_BITS_PER_BLOCK_BITS(sb));
+	group_end_block = group_first_block + (EXT4_BITS_PER_BLOCK(sb) - 1);
 
 	if (grp_goal < 0)
 		start_block = group_first_block;
 	else
-		start_block = grp_goal + group_first_block;
+		start_block = grp_goal + (group_first_block -
+			(bitmap_block << EXT4_BITS_PER_BLOCK_BITS(sb)));
 
 	size = my_rsv->rsv_goal_size;
 
@@ -1147,7 +1194,6 @@ retry:
 	first_free_block = bitmap_search_next_usable_block(
 			my_rsv->rsv_start - group_first_block,
 			bitmap_bh, group_end_block - group_first_block + 1);
-
 	if (first_free_block < 0) {
 		/*
 		 * no free block left on the bitmap, no point
@@ -1257,6 +1303,7 @@ ext4_try_to_allocate_with_rsv(struct sup
 {
 	struct buffer_head *bitmap_bh = NULL;
 	ext4_fsblk_t group_first_block, group_last_block;
+	ext4_fsblk_t bitmap_block;
 	ext4_grpblk_t ret = 0;
 	int fatal;
 	unsigned long num = *count;
@@ -1268,7 +1315,12 @@ ext4_try_to_allocate_with_rsv(struct sup
 	 * that we do the frozen_data COW on bitmap buffers in all cases even
 	 * if the buffer is in BJ_Forget state in the committing transaction.
 	 */
-	bitmap_bh = read_block_bitmap(sb, group);
+	if (grp_goal < 0)
+		bitmap_block = 0;
+	else
+		bitmap_block = grp_goal >> EXT4_BITS_PER_BLOCK_BITS(sb);
+try_next:
+	bitmap_bh = read_block_bitmap(sb, group,  bitmap_block);
 	if (!bitmap_bh) {
 		*errp = -EIO;
 		return -1;
@@ -1287,8 +1339,8 @@ ext4_try_to_allocate_with_rsv(struct sup
 	 * or last attempt to allocate a block with reservation turned on failed
 	 */
 	if (my_rsv == NULL ) {
-		ret = ext4_try_to_allocate(sb, handle, group, bitmap_bh,
-						grp_goal, count, NULL);
+		ret = ext4_try_to_allocate(sb, handle, group, bitmap_block,
+					   bitmap_bh, grp_goal, count, NULL);
 		goto out;
 	}
 	/*
@@ -1322,7 +1374,7 @@ ext4_try_to_allocate_with_rsv(struct sup
 			if (my_rsv->rsv_goal_size < *count)
 				my_rsv->rsv_goal_size = *count;
 			ret = alloc_new_reservation(my_rsv, grp_goal, sb,
-							group, bitmap_bh);
+							group, bitmap_block, bitmap_bh);
 			if (ret < 0)
 				break;			/* failed */
 
@@ -1339,7 +1391,7 @@ ext4_try_to_allocate_with_rsv(struct sup
 			rsv_window_dump(&EXT4_SB(sb)->s_rsv_window_root, 1);
 			BUG();
 		}
-		ret = ext4_try_to_allocate(sb, handle, group, bitmap_bh,
+		ret = ext4_try_to_allocate(sb, handle, group, bitmap_block, bitmap_bh,
 					   grp_goal, &num, &my_rsv->rsv_window);
 		if (ret >= 0) {
 			my_rsv->rsv_alloc_hit += num;
@@ -1390,6 +1442,11 @@ out:
 	BUFFER_TRACE(bitmap_bh, "journal_release_buffer");
 	ext4_journal_release_buffer(handle, bitmap_bh);
 	brelse(bitmap_bh);
+	if (++bitmap_block < EXT4_BLOCK_BITMAP_PER_GROUP(sb)) {
+		if (grp_goal < 0)
+			grp_goal = bitmap_block << EXT4_BITS_PER_BLOCK_BITS(sb);
+		goto try_next;
+	}
 	return ret;
 }
 
@@ -1606,8 +1663,14 @@ allocated:
 
 	ret_block = grp_alloc_blk + ext4_group_first_block_no(sb, group_no);
 
-	if (in_range(ext4_block_bitmap(sb, gdp), ret_block, num) ||
-	    in_range(ext4_block_bitmap(sb, gdp), ret_block, num) ||
+	if (in_range(ret_block, ext4_block_bitmap(sb, gdp), 
+		     EXT4_BLOCK_BITMAP_PER_GROUP(sb)) ||
+	    in_range(ret_block + num - 1, ext4_block_bitmap(sb, gdp), 
+		     EXT4_BLOCK_BITMAP_PER_GROUP(sb)) ||
+	    in_range(ret_block, ext4_inode_bitmap(sb, gdp), 
+		     EXT4_INODE_BITMAP_PER_GROUP(sb)) ||
+	    in_range(ret_block + num - 1, ext4_inode_bitmap(sb, gdp), 
+		     EXT4_INODE_BITMAP_PER_GROUP(sb)) ||
 	    in_range(ret_block, ext4_inode_table(sb, gdp),
 		     EXT4_SB(sb)->s_itb_per_group) ||
 	    in_range(ret_block + num - 1, ext4_inode_table(sb, gdp),
@@ -1720,12 +1783,15 @@ ext4_fsblk_t ext4_count_free_blocks(stru
 		if (!gdp)
 			continue;
 		desc_count += le16_to_cpu(gdp->bg_free_blocks_count);
-		brelse(bitmap_bh);
-		bitmap_bh = read_block_bitmap(sb, i);
-		if (bitmap_bh == NULL)
-			continue;
-
-		x = ext4_count_free(bitmap_bh, sb->s_blocksize);
+		for (j = 0, x = 0;
+		     j < (EXT4_BLOCKS_PER_GROUP(sb) >> EXT4_BITS_PER_BLOCK_BITS(sb));
+		     j++) {
+			brelse(bitmap_bh);
+			bitmap_bh = read_block_bitmap(sb, i, j);
+			if (bitmap_bh == NULL)
+				continue;
+			x += ext4_count_free(bitmap_bh, sb->s_blocksize);
+		}
 		printk("group %d: stored = %d, counted = %lu\n",
 			i, le16_to_cpu(gdp->bg_free_blocks_count), x);
 		bitmap_count += x;
Index: linux-2.6.19-rc6/fs/ext4/super.c
===================================================================
--- linux-2.6.19-rc6.orig/fs/ext4/super.c	2006-11-17 12:13:52.000000000 +0100
+++ linux-2.6.19-rc6/fs/ext4/super.c	2006-11-17 12:14:07.000000000 +0100
@@ -1665,23 +1665,25 @@ static int ext4_fill_super (struct super
 		sbi->s_hash_seed[i] = le32_to_cpu(es->s_hash_seed[i]);
 	sbi->s_def_hash_version = es->s_def_hash_version;
 
-	if (sbi->s_blocks_per_group > blocksize * 8) {
-		printk (KERN_ERR
-			"EXT4-fs: #blocks per group too big: %lu\n",
-			sbi->s_blocks_per_group);
-		goto failed_mount;
-	}
-	if (sbi->s_frags_per_group > blocksize * 8) {
-		printk (KERN_ERR
-			"EXT4-fs: #fragments per group too big: %lu\n",
-			sbi->s_frags_per_group);
-		goto failed_mount;
-	}
-	if (sbi->s_inodes_per_group > blocksize * 8) {
-		printk (KERN_ERR
-			"EXT4-fs: #inodes per group too big: %lu\n",
-			sbi->s_inodes_per_group);
-		goto failed_mount;
+	if (!EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_64BIT)) {
+		if (sbi->s_blocks_per_group > blocksize * 8) {
+			printk (KERN_ERR
+				"EXT4-fs: #blocks per group too big: %lu\n",
+				sbi->s_blocks_per_group);
+			goto failed_mount;
+		}
+		if (sbi->s_frags_per_group > blocksize * 8) {
+			printk (KERN_ERR
+				"EXT4-fs: #fragments per group too big: %lu\n",
+				sbi->s_frags_per_group);
+			goto failed_mount;
+		}
+		if (sbi->s_inodes_per_group > blocksize * 8) {
+			printk (KERN_ERR
+				"EXT4-fs: #inodes per group too big: %lu\n",
+				sbi->s_inodes_per_group);
+			goto failed_mount;
+		}
 	}
 
 	if (ext4_blocks_count(es) >
