From: Mathieu Segaud <mathieu.segaud@regala.cx>
Subject: [PATCH] [Coding Style]: fs/ext{3,4}/balloc.c
Date: Fri,  4 Jan 2008 14:21:33 +0100
Message-ID: <1199452896-20145-2-git-send-email-mathieu.segaud@regala.cx>
References: <1199452896-20145-1-git-send-email-mathieu.segaud@regala.cx>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Mathieu Segaud <mathieu.segaud@regala.cx>
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bde.crans.org ([138.231.137.76]:48604 "EHLO bde.crans.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752931AbYADNaT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 4 Jan 2008 08:30:19 -0500
In-Reply-To: <1199452896-20145-1-git-send-email-mathieu.segaud@regala.cx>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Mathieu Segaud <mathieu.segaud@regala.cx>
---
 fs/ext3/balloc.c |  101 ++++++++++++++++++++++++++++--------------------------
 fs/ext4/balloc.c |   93 +++++++++++++++++++++++++------------------------
 2 files changed, 100 insertions(+), 94 deletions(-)

diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index a8ba7e8..feb00fb 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -45,17 +45,17 @@
  * @bh:			pointer to the buffer head to store the block
  *			group descriptor
  */
-struct ext3_group_desc * ext3_get_group_desc(struct super_block * sb,
+struct ext3_group_desc *ext3_get_group_desc(struct super_block *sb,
 					     unsigned int block_group,
-					     struct buffer_head ** bh)
+					     struct buffer_head **bh)
 {
 	unsigned long group_desc;
 	unsigned long offset;
-	struct ext3_group_desc * desc;
+	struct ext3_group_desc *desc;
 	struct ext3_sb_info *sbi = EXT3_SB(sb);
 
 	if (block_group >= sbi->s_groups_count) {
-		ext3_error (sb, "ext3_get_group_desc",
+		ext3_error(sb, "ext3_get_group_desc",
 			    "block_group >= groups_count - "
 			    "block_group = %d, groups_count = %lu",
 			    block_group, sbi->s_groups_count);
@@ -67,7 +67,7 @@ struct ext3_group_desc * ext3_get_group_desc(struct super_block * sb,
 	group_desc = block_group >> EXT3_DESC_PER_BLOCK_BITS(sb);
 	offset = block_group & (EXT3_DESC_PER_BLOCK(sb) - 1);
 	if (!sbi->s_group_desc[group_desc]) {
-		ext3_error (sb, "ext3_get_group_desc",
+		ext3_error(sb, "ext3_get_group_desc",
 			    "Group descriptor not loaded - "
 			    "block_group = %d, group_desc = %lu, desc = %lu",
 			     block_group, group_desc, offset);
@@ -93,15 +93,15 @@ struct ext3_group_desc * ext3_get_group_desc(struct super_block * sb,
 static struct buffer_head *
 read_block_bitmap(struct super_block *sb, unsigned int block_group)
 {
-	struct ext3_group_desc * desc;
-	struct buffer_head * bh = NULL;
+	struct ext3_group_desc *desc;
+	struct buffer_head *bh = NULL;
 
-	desc = ext3_get_group_desc (sb, block_group, NULL);
+	desc = ext3_get_group_desc(sb, block_group, NULL);
 	if (!desc)
 		goto error_out;
 	bh = sb_bread(sb, le32_to_cpu(desc->bg_block_bitmap));
 	if (!bh)
-		ext3_error (sb, "read_block_bitmap",
+		ext3_error(sb, "read_block_bitmap",
 			    "Cannot read block bitmap - "
 			    "block_group = %d, block_bitmap = %u",
 			    block_group, le32_to_cpu(desc->bg_block_bitmap));
@@ -142,26 +142,26 @@ restart:
 	bad = 0;
 	prev = NULL;
 
-	printk("Block Allocation Reservation Windows Map (%s):\n", fn);
+	printk(KERN_INFO "Block Allocation Reservation Windows Map (%s):\n", fn);
 	while (n) {
 		rsv = rb_entry(n, struct ext3_reserve_window_node, rsv_node);
 		if (verbose)
-			printk("reservation window 0x%p "
+			printk(KERN_INFO "reservation window 0x%p "
 			       "start:  %lu, end:  %lu\n",
 			       rsv, rsv->rsv_start, rsv->rsv_end);
 		if (rsv->rsv_start && rsv->rsv_start >= rsv->rsv_end) {
-			printk("Bad reservation %p (start >= end)\n",
-			       rsv);
+			printk(KERN_WARNING "Bad reservation %p (start >= end)\n", rsv);
 			bad = 1;
 		}
 		if (prev && prev->rsv_end >= rsv->rsv_start) {
-			printk("Bad reservation %p (prev->end >= start)\n",
-			       rsv);
+			printk(KERN_WARNING
+					"Bad reservation %p (prev->end >= start)\n", rsv);
 			bad = 1;
 		}
 		if (bad) {
 			if (!verbose) {
-				printk("Restarting reservation walk in verbose mode\n");
+				printk(KERN_WARNING
+						"Restarting reservation walk in verbose mode\n");
 				verbose = 1;
 				goto restart;
 			}
@@ -169,7 +169,7 @@ restart:
 		n = rb_next(n);
 		prev = rsv;
 	}
-	printk("Window map complete.\n");
+	printk(KERN_INFO "Window map complete.\n");
 	if (bad)
 		BUG();
 }
@@ -197,7 +197,7 @@ restart:
  */
 static int
 goal_in_my_reservation(struct ext3_reserve_window *rsv, ext3_grpblk_t grp_goal,
-			unsigned int group, struct super_block * sb)
+			unsigned int group, struct super_block *sb)
 {
 	ext3_fsblk_t group_first_block, group_last_block;
 
@@ -268,12 +268,11 @@ void ext3_rsv_window_add(struct super_block *sb,
 	struct rb_node *node = &rsv->rsv_node;
 	ext3_fsblk_t start = rsv->rsv_start;
 
-	struct rb_node ** p = &root->rb_node;
-	struct rb_node * parent = NULL;
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
 	struct ext3_reserve_window_node *this;
 
-	while (*p)
-	{
+	while (*p) {
 		parent = *p;
 		this = rb_entry(parent, struct ext3_reserve_window_node, rsv_node);
 
@@ -421,8 +420,8 @@ void ext3_free_blocks_sb(handle_t *handle, struct super_block *sb,
 	ext3_grpblk_t bit;
 	unsigned long i;
 	unsigned long overflow;
-	struct ext3_group_desc * desc;
-	struct ext3_super_block * es;
+	struct ext3_group_desc *desc;
+	struct ext3_super_block *es;
 	struct ext3_sb_info *sbi;
 	int err = 0, ret;
 	ext3_grpblk_t group_freed;
@@ -433,13 +432,13 @@ void ext3_free_blocks_sb(handle_t *handle, struct super_block *sb,
 	if (block < le32_to_cpu(es->s_first_data_block) ||
 	    block + count < block ||
 	    block + count > le32_to_cpu(es->s_blocks_count)) {
-		ext3_error (sb, "ext3_free_blocks",
+		ext3_error(sb, "ext3_free_blocks",
 			    "Freeing blocks not in datazone - "
 			    "block = "E3FSBLK", count = %lu", block, count);
 		goto error_return;
 	}
 
-	ext3_debug ("freeing block(s) %lu-%lu\n", block, block + count - 1);
+	ext3_debug("freeing block(s) %lu-%lu\n", block, block + count - 1);
 
 do_more:
 	overflow = 0;
@@ -459,17 +458,17 @@ do_more:
 	bitmap_bh = read_block_bitmap(sb, block_group);
 	if (!bitmap_bh)
 		goto error_return;
-	desc = ext3_get_group_desc (sb, block_group, &gd_bh);
+	desc = ext3_get_group_desc(sb, block_group, &gd_bh);
 	if (!desc)
 		goto error_return;
 
-	if (in_range (le32_to_cpu(desc->bg_block_bitmap), block, count) ||
-	    in_range (le32_to_cpu(desc->bg_inode_bitmap), block, count) ||
-	    in_range (block, le32_to_cpu(desc->bg_inode_table),
+	if (in_range(le32_to_cpu(desc->bg_block_bitmap), block, count) ||
+	    in_range(le32_to_cpu(desc->bg_inode_bitmap), block, count) ||
+	    in_range(block, le32_to_cpu(desc->bg_inode_table),
 		      sbi->s_itb_per_group) ||
-	    in_range (block + count - 1, le32_to_cpu(desc->bg_inode_table),
+	    in_range(block + count - 1, le32_to_cpu(desc->bg_inode_table),
 		      sbi->s_itb_per_group))
-		ext3_error (sb, "ext3_free_blocks",
+		ext3_error(sb, "ext3_free_blocks",
 			    "Freeing blocks in system zones - "
 			    "Block = "E3FSBLK", count = %lu",
 			    block, count);
@@ -579,7 +578,8 @@ do_more:
 	/* And the group descriptor block */
 	BUFFER_TRACE(gd_bh, "dirtied group descriptor block");
 	ret = ext3_journal_dirty_metadata(handle, gd_bh);
-	if (!err) err = ret;
+	if (!err)
+		err = ret;
 	*pdquot_freed_blocks += group_freed;
 
 	if (overflow && !err) {
@@ -604,12 +604,12 @@ error_return:
 void ext3_free_blocks(handle_t *handle, struct inode *inode,
 			ext3_fsblk_t block, unsigned long count)
 {
-	struct super_block * sb;
+	struct super_block *sb;
 	unsigned long dquot_freed_blocks;
 
 	sb = inode->i_sb;
 	if (!sb) {
-		printk ("ext3_free_blocks: nonexistent device");
+		printk(KERN_WARNING "ext3_free_blocks: nonexistent device");
 		return;
 	}
 	ext3_free_blocks_sb(handle, sb, block, count, &dquot_freed_blocks);
@@ -765,7 +765,7 @@ claim_block(spinlock_t *lock, ext3_grpblk_t block, struct buffer_head *bh)
 	if (ext3_set_bit_atomic(lock, block, bh->b_data))
 		return 0;
 	jbd_lock_bh_state(bh);
-	if (jh->b_committed_data && ext3_test_bit(block,jh->b_committed_data)) {
+	if (jh->b_committed_data && ext3_test_bit(block, jh->b_committed_data)) {
 		ext3_clear_bit_atomic(lock, block, bh->b_data);
 		ret = 0;
 	} else {
@@ -915,7 +915,7 @@ fail_access:
 static int find_next_reservable_window(
 				struct ext3_reserve_window_node *search_head,
 				struct ext3_reserve_window_node *my_rsv,
-				struct super_block * sb,
+				struct super_block *sb,
 				ext3_fsblk_t start_block,
 				ext3_fsblk_t last_block)
 {
@@ -949,7 +949,7 @@ static int find_next_reservable_window(
 
 		prev = rsv;
 		next = rb_next(&rsv->rsv_node);
-		rsv = rb_entry(next,struct ext3_reserve_window_node,rsv_node);
+		rsv = rb_entry(next, struct ext3_reserve_window_node, rsv_node);
 
 		/*
 		 * Reached the last reservation, we can just append to the
@@ -1087,7 +1087,7 @@ static int alloc_new_reservation(struct ext3_reserve_window_node *my_rsv,
 			size = size * 2;
 			if (size > EXT3_MAX_RESERVE_BLOCKS)
 				size = EXT3_MAX_RESERVE_BLOCKS;
-			my_rsv->rsv_goal_size= size;
+			my_rsv->rsv_goal_size = size;
 		}
 	}
 
@@ -1236,7 +1236,7 @@ static ext3_grpblk_t
 ext3_try_to_allocate_with_rsv(struct super_block *sb, handle_t *handle,
 			unsigned int group, struct buffer_head *bitmap_bh,
 			ext3_grpblk_t grp_goal,
-			struct ext3_reserve_window_node * my_rsv,
+			struct ext3_reserve_window_node *my_rsv,
 			unsigned long *count, int *errp)
 {
 	ext3_fsblk_t group_first_block, group_last_block;
@@ -1264,7 +1264,7 @@ ext3_try_to_allocate_with_rsv(struct super_block *sb, handle_t *handle,
 	 * or the file is not a regular file
 	 * or last attempt to allocate a block with reservation turned on failed
 	 */
-	if (my_rsv == NULL ) {
+	if (my_rsv == NULL) {
 		ret = ext3_try_to_allocate(sb, handle, group, bitmap_bh,
 						grp_goal, count, NULL);
 		goto out;
@@ -1361,9 +1361,9 @@ static int ext3_has_free_blocks(struct ext3_sb_info *sbi)
 	root_blocks = le32_to_cpu(sbi->s_es->s_r_blocks_count);
 	if (free_blocks < root_blocks + 1 && !capable(CAP_SYS_RESOURCE) &&
 		sbi->s_resuid != current->fsuid &&
-		(sbi->s_resgid == 0 || !in_group_p (sbi->s_resgid))) {
+		(sbi->s_resgid == 0 || !in_group_p(sbi->s_resgid)))
 		return 0;
-	}
+
 	return 1;
 }
 
@@ -1457,8 +1457,11 @@ ext3_fsblk_t ext3_new_blocks(handle_t *handle, struct inode *inode,
 	 * reservation on that particular file)
 	 */
 	block_i = EXT3_I(inode)->i_block_alloc_info;
-	if (block_i && ((windowsz = block_i->rsv_window_node.rsv_goal_size) > 0))
-		my_rsv = &block_i->rsv_window_node;
+	if (block_i) {
+		windowsz = block_i->rsv_window_node.rsv_goal_size
+		if (windowsz > 0)
+			my_rsv = &block_i->rsv_window_node;
+	}
 
 	if (!ext3_has_free_blocks(sbi)) {
 		*errp = -ENOSPC;
@@ -1714,7 +1717,7 @@ ext3_fsblk_t ext3_count_free_blocks(struct super_block *sb)
 		bitmap_count += x;
 	}
 	brelse(bitmap_bh);
-	printk("ext3_count_free_blocks: stored = "E3FSBLK
+	printk(KERN_INFO "ext3_count_free_blocks: stored = "E3FSBLK
 		", computed = "E3FSBLK", "E3FSBLK"\n",
 	       le32_to_cpu(es->s_free_blocks_count),
 		desc_count, bitmap_count);
@@ -1804,10 +1807,10 @@ unsigned long ext3_bg_num_gdb(struct super_block *sb, int group)
 			le32_to_cpu(EXT3_SB(sb)->s_es->s_first_meta_bg);
 	unsigned long metagroup = group / EXT3_DESC_PER_BLOCK(sb);
 
-	if (!EXT3_HAS_INCOMPAT_FEATURE(sb,EXT3_FEATURE_INCOMPAT_META_BG) ||
+	if (!EXT3_HAS_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_META_BG) ||
 			metagroup < first_meta_bg)
-		return ext3_bg_num_gdb_nometa(sb,group);
+		return ext3_bg_num_gdb_nometa(sb, group);
 
-	return ext3_bg_num_gdb_meta(sb,group);
+	return ext3_bg_num_gdb_meta(sb, group);
 
 }
diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 71ee95e..2ce8db7 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -98,7 +98,7 @@ unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
 		 */
 		group_blocks = ext4_blocks_count(sbi->s_es) -
 			le32_to_cpu(sbi->s_es->s_first_data_block) -
-			(EXT4_BLOCKS_PER_GROUP(sb) * (sbi->s_groups_count -1));
+			(EXT4_BLOCKS_PER_GROUP(sb) * (sbi->s_groups_count - 1));
 	} else {
 		group_blocks = EXT4_BLOCKS_PER_GROUP(sb);
 	}
@@ -152,17 +152,17 @@ unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
  * @bh:			pointer to the buffer head to store the block
  *			group descriptor
  */
-struct ext4_group_desc * ext4_get_group_desc(struct super_block * sb,
+struct ext4_group_desc *ext4_get_group_desc(struct super_block *sb,
 					     unsigned int block_group,
-					     struct buffer_head ** bh)
+					     struct buffer_head **bh)
 {
 	unsigned long group_desc;
 	unsigned long offset;
-	struct ext4_group_desc * desc;
+	struct ext4_group_desc *desc;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
 	if (block_group >= sbi->s_groups_count) {
-		ext4_error (sb, "ext4_get_group_desc",
+		ext4_error(sb, "ext4_get_group_desc",
 			    "block_group >= groups_count - "
 			    "block_group = %d, groups_count = %lu",
 			    block_group, sbi->s_groups_count);
@@ -174,7 +174,7 @@ struct ext4_group_desc * ext4_get_group_desc(struct super_block * sb,
 	group_desc = block_group >> EXT4_DESC_PER_BLOCK_BITS(sb);
 	offset = block_group & (EXT4_DESC_PER_BLOCK(sb) - 1);
 	if (!sbi->s_group_desc[group_desc]) {
-		ext4_error (sb, "ext4_get_group_desc",
+		ext4_error(sb, "ext4_get_group_desc",
 			    "Group descriptor not loaded - "
 			    "block_group = %d, group_desc = %lu, desc = %lu",
 			     block_group, group_desc, offset);
@@ -202,8 +202,8 @@ struct ext4_group_desc * ext4_get_group_desc(struct super_block * sb,
 struct buffer_head *
 read_block_bitmap(struct super_block *sb, unsigned int block_group)
 {
-	struct ext4_group_desc * desc;
-	struct buffer_head * bh = NULL;
+	struct ext4_group_desc *desc;
+	struct buffer_head *bh = NULL;
 	ext4_fsblk_t bitmap_blk;
 
 	desc = ext4_get_group_desc(sb, block_group, NULL);
@@ -225,7 +225,7 @@ read_block_bitmap(struct super_block *sb, unsigned int block_group)
 		bh = sb_bread(sb, bitmap_blk);
 	}
 	if (!bh)
-		ext4_error (sb, __FUNCTION__,
+		ext4_error(sb, __FUNCTION__,
 			    "Cannot read block bitmap - "
 			    "block_group = %d, block_bitmap = %llu",
 			    block_group, bitmap_blk);
@@ -265,26 +265,26 @@ restart:
 	bad = 0;
 	prev = NULL;
 
-	printk("Block Allocation Reservation Windows Map (%s):\n", fn);
+	printk(KERN_INFO "Block Allocation Reservation Windows Map (%s):\n", fn);
 	while (n) {
 		rsv = rb_entry(n, struct ext4_reserve_window_node, rsv_node);
 		if (verbose)
-			printk("reservation window 0x%p "
+			printk(KERN_INFO "reservation window 0x%p "
 			       "start:  %llu, end:  %llu\n",
 			       rsv, rsv->rsv_start, rsv->rsv_end);
 		if (rsv->rsv_start && rsv->rsv_start >= rsv->rsv_end) {
-			printk("Bad reservation %p (start >= end)\n",
-			       rsv);
+			printk(KERN_WARNING "Bad reservation %p (start >= end)\n", rsv);
 			bad = 1;
 		}
 		if (prev && prev->rsv_end >= rsv->rsv_start) {
-			printk("Bad reservation %p (prev->end >= start)\n",
-			       rsv);
+			printk(KERN_WARNING
+					"Bad reservation %p (prev->end >= start)\n", rsv);
 			bad = 1;
 		}
 		if (bad) {
 			if (!verbose) {
-				printk("Restarting reservation walk in verbose mode\n");
+				printk(KERN_WARNING
+						"Restarting reservation walk in verbose mode\n");
 				verbose = 1;
 				goto restart;
 			}
@@ -292,7 +292,7 @@ restart:
 		n = rb_next(n);
 		prev = rsv;
 	}
-	printk("Window map complete.\n");
+	printk(KERN_INFO "Window map complete.\n");
 	if (bad)
 		BUG();
 }
@@ -320,7 +320,7 @@ restart:
  */
 static int
 goal_in_my_reservation(struct ext4_reserve_window *rsv, ext4_grpblk_t grp_goal,
-			unsigned int group, struct super_block * sb)
+			unsigned int group, struct super_block *sb)
 {
 	ext4_fsblk_t group_first_block, group_last_block;
 
@@ -391,12 +391,11 @@ void ext4_rsv_window_add(struct super_block *sb,
 	struct rb_node *node = &rsv->rsv_node;
 	ext4_fsblk_t start = rsv->rsv_start;
 
-	struct rb_node ** p = &root->rb_node;
-	struct rb_node * parent = NULL;
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
 	struct ext4_reserve_window_node *this;
 
-	while (*p)
-	{
+	while (*p) {
 		parent = *p;
 		this = rb_entry(parent, struct ext4_reserve_window_node, rsv_node);
 
@@ -544,8 +543,8 @@ void ext4_free_blocks_sb(handle_t *handle, struct super_block *sb,
 	ext4_grpblk_t bit;
 	unsigned long i;
 	unsigned long overflow;
-	struct ext4_group_desc * desc;
-	struct ext4_super_block * es;
+	struct ext4_group_desc *desc;
+	struct ext4_super_block *es;
 	struct ext4_sb_info *sbi;
 	int err = 0, ret;
 	ext4_grpblk_t group_freed;
@@ -556,13 +555,13 @@ void ext4_free_blocks_sb(handle_t *handle, struct super_block *sb,
 	if (block < le32_to_cpu(es->s_first_data_block) ||
 	    block + count < block ||
 	    block + count > ext4_blocks_count(es)) {
-		ext4_error (sb, "ext4_free_blocks",
+		ext4_error(sb, "ext4_free_blocks",
 			    "Freeing blocks not in datazone - "
 			    "block = %llu, count = %lu", block, count);
 		goto error_return;
 	}
 
-	ext4_debug ("freeing block(s) %llu-%llu\n", block, block + count - 1);
+	ext4_debug("freeing block(s) %llu-%llu\n", block, block + count - 1);
 
 do_more:
 	overflow = 0;
@@ -579,7 +578,7 @@ do_more:
 	bitmap_bh = read_block_bitmap(sb, block_group);
 	if (!bitmap_bh)
 		goto error_return;
-	desc = ext4_get_group_desc (sb, block_group, &gd_bh);
+	desc = ext4_get_group_desc(sb, block_group, &gd_bh);
 	if (!desc)
 		goto error_return;
 
@@ -588,7 +587,7 @@ do_more:
 	    in_range(block, ext4_inode_table(sb, desc), sbi->s_itb_per_group) ||
 	    in_range(block + count - 1, ext4_inode_table(sb, desc),
 		     sbi->s_itb_per_group))
-		ext4_error (sb, "ext4_free_blocks",
+		ext4_error(sb, "ext4_free_blocks",
 			    "Freeing blocks in system zones - "
 			    "Block = %llu, count = %lu",
 			    block, count);
@@ -699,7 +698,8 @@ do_more:
 	/* And the group descriptor block */
 	BUFFER_TRACE(gd_bh, "dirtied group descriptor block");
 	ret = ext4_journal_dirty_metadata(handle, gd_bh);
-	if (!err) err = ret;
+	if (!err)
+		err = ret;
 	*pdquot_freed_blocks += group_freed;
 
 	if (overflow && !err) {
@@ -724,12 +724,12 @@ error_return:
 void ext4_free_blocks(handle_t *handle, struct inode *inode,
 			ext4_fsblk_t block, unsigned long count)
 {
-	struct super_block * sb;
+	struct super_block *sb;
 	unsigned long dquot_freed_blocks;
 
 	sb = inode->i_sb;
 	if (!sb) {
-		printk ("ext4_free_blocks: nonexistent device");
+		printk(KERN_WARNING "ext4_free_blocks: nonexistent device");
 		return;
 	}
 	ext4_free_blocks_sb(handle, sb, block, count, &dquot_freed_blocks);
@@ -885,7 +885,7 @@ claim_block(spinlock_t *lock, ext4_grpblk_t block, struct buffer_head *bh)
 	if (ext4_set_bit_atomic(lock, block, bh->b_data))
 		return 0;
 	jbd_lock_bh_state(bh);
-	if (jh->b_committed_data && ext4_test_bit(block,jh->b_committed_data)) {
+	if (jh->b_committed_data && ext4_test_bit(block, jh->b_committed_data)) {
 		ext4_clear_bit_atomic(lock, block, bh->b_data);
 		ret = 0;
 	} else {
@@ -1035,7 +1035,7 @@ fail_access:
 static int find_next_reservable_window(
 				struct ext4_reserve_window_node *search_head,
 				struct ext4_reserve_window_node *my_rsv,
-				struct super_block * sb,
+				struct super_block *sb,
 				ext4_fsblk_t start_block,
 				ext4_fsblk_t last_block)
 {
@@ -1069,7 +1069,7 @@ static int find_next_reservable_window(
 
 		prev = rsv;
 		next = rb_next(&rsv->rsv_node);
-		rsv = rb_entry(next,struct ext4_reserve_window_node,rsv_node);
+		rsv = rb_entry(next, struct ext4_reserve_window_node, rsv_node);
 
 		/*
 		 * Reached the last reservation, we can just append to the
@@ -1207,7 +1207,7 @@ static int alloc_new_reservation(struct ext4_reserve_window_node *my_rsv,
 			size = size * 2;
 			if (size > EXT4_MAX_RESERVE_BLOCKS)
 				size = EXT4_MAX_RESERVE_BLOCKS;
-			my_rsv->rsv_goal_size= size;
+			my_rsv->rsv_goal_size = size;
 		}
 	}
 
@@ -1356,7 +1356,7 @@ static ext4_grpblk_t
 ext4_try_to_allocate_with_rsv(struct super_block *sb, handle_t *handle,
 			unsigned int group, struct buffer_head *bitmap_bh,
 			ext4_grpblk_t grp_goal,
-			struct ext4_reserve_window_node * my_rsv,
+			struct ext4_reserve_window_node *my_rsv,
 			unsigned long *count, int *errp)
 {
 	ext4_fsblk_t group_first_block, group_last_block;
@@ -1384,7 +1384,7 @@ ext4_try_to_allocate_with_rsv(struct super_block *sb, handle_t *handle,
 	 * or the file is not a regular file
 	 * or last attempt to allocate a block with reservation turned on failed
 	 */
-	if (my_rsv == NULL ) {
+	if (my_rsv == NULL) {
 		ret = ext4_try_to_allocate(sb, handle, group, bitmap_bh,
 						grp_goal, count, NULL);
 		goto out;
@@ -1481,9 +1481,9 @@ static int ext4_has_free_blocks(struct ext4_sb_info *sbi)
 	root_blocks = ext4_r_blocks_count(sbi->s_es);
 	if (free_blocks < root_blocks + 1 && !capable(CAP_SYS_RESOURCE) &&
 		sbi->s_resuid != current->fsuid &&
-		(sbi->s_resgid == 0 || !in_group_p (sbi->s_resgid))) {
+		(sbi->s_resgid == 0 || !in_group_p(sbi->s_resgid)))
 		return 0;
-	}
+
 	return 1;
 }
 
@@ -1577,8 +1577,11 @@ ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
 	 * reservation on that particular file)
 	 */
 	block_i = EXT4_I(inode)->i_block_alloc_info;
-	if (block_i && ((windowsz = block_i->rsv_window_node.rsv_goal_size) > 0))
-		my_rsv = &block_i->rsv_window_node;
+	if (block_i) {
+		windowsz = block_i->rsv_window_node.rsv_goal_size;
+		if (windowsz > 0)
+			my_rsv = &block_i->rsv_window_node;
+	}
 
 	if (!ext4_has_free_blocks(sbi)) {
 		*errp = -ENOSPC;
@@ -1834,7 +1837,7 @@ ext4_fsblk_t ext4_count_free_blocks(struct super_block *sb)
 		bitmap_count += x;
 	}
 	brelse(bitmap_bh);
-	printk("ext4_count_free_blocks: stored = %llu"
+	printk(KERN_INFO "ext4_count_free_blocks: stored = %llu"
 		", computed = %llu, %llu\n",
 	       EXT4_FREE_BLOCKS_COUNT(es),
 		desc_count, bitmap_count);
@@ -1924,10 +1927,10 @@ unsigned long ext4_bg_num_gdb(struct super_block *sb, int group)
 			le32_to_cpu(EXT4_SB(sb)->s_es->s_first_meta_bg);
 	unsigned long metagroup = group / EXT4_DESC_PER_BLOCK(sb);
 
-	if (!EXT4_HAS_INCOMPAT_FEATURE(sb,EXT4_FEATURE_INCOMPAT_META_BG) ||
+	if (!EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_META_BG) ||
 			metagroup < first_meta_bg)
-		return ext4_bg_num_gdb_nometa(sb,group);
+		return ext4_bg_num_gdb_nometa(sb, group);
 
-	return ext4_bg_num_gdb_meta(sb,group);
+	return ext4_bg_num_gdb_meta(sb, group);
 
 }
-- 
1.5.3.7
