From: Jan Kara <jack@suse.cz>
Subject: [PATCH 3/3] ext3: Implement delayed allocation on page_mkwrite time
Date: Sat,  9 Oct 2010 02:12:27 +0200
Message-ID: <1286583147-14760-4-git-send-email-jack@suse.cz>
References: <1286583147-14760-1-git-send-email-jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36618 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063Ab0JIANn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Oct 2010 20:13:43 -0400
In-Reply-To: <1286583147-14760-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We don't want to really allocate blocks on page_mkwrite() time because for
random writes via mmap it results is much more fragmented files. So just
reserve enough free blocks in page_mkwrite() and do the real allocation from
writepage().

It's however not so simple because we do not want to overestimate necessary
number of indirect blocks too badly in presence of lots of delayed allocated
buffers. Thus we track which indirect blocks have already reservation pending
and do not reserve space for them again.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/balloc.c           |  103 +++++++++-----
 fs/ext3/file.c             |   19 +++-
 fs/ext3/ialloc.c           |    2 +-
 fs/ext3/inode.c            |  346 +++++++++++++++++++++++++++++++++++++++++---
 fs/ext3/resize.c           |    2 +-
 fs/ext3/super.c            |   23 +++-
 include/linux/ext3_fs.h    |    5 +-
 include/linux/ext3_fs_i.h  |   20 +++
 include/linux/ext3_fs_sb.h |    3 +-
 9 files changed, 458 insertions(+), 65 deletions(-)

diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index 4a32511..bf3f607 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -20,6 +20,8 @@
 #include <linux/ext3_jbd.h>
 #include <linux/quotaops.h>
 #include <linux/buffer_head.h>
+#include <linux/delalloc_counter.h>
+#include <linux/writeback.h>
 
 /*
  * balloc.c contains the blocks allocation and deallocation routines
@@ -633,7 +635,7 @@ do_more:
 	spin_lock(sb_bgl_lock(sbi, block_group));
 	le16_add_cpu(&desc->bg_free_blocks_count, group_freed);
 	spin_unlock(sb_bgl_lock(sbi, block_group));
-	percpu_counter_add(&sbi->s_freeblocks_counter, count);
+	dac_free(&sbi->s_alloc_counter, count);
 
 	/* We dirtied the bitmap block */
 	BUFFER_TRACE(bitmap_bh, "dirtied bitmap block");
@@ -1411,23 +1413,19 @@ out:
 }
 
 /**
- * ext3_has_free_blocks()
- * @sbi:		in-core super block structure.
+ * ext3_free_blocks_limit()
+ * @sb:			super block
  *
  * Check if filesystem has at least 1 free block available for allocation.
  */
-static int ext3_has_free_blocks(struct ext3_sb_info *sbi)
+ext3_fsblk_t ext3_free_blocks_limit(struct super_block *sb)
 {
-	ext3_fsblk_t free_blocks, root_blocks;
+	struct ext3_sb_info *sbi = EXT3_SB(sb);
 
-	free_blocks = percpu_counter_read_positive(&sbi->s_freeblocks_counter);
-	root_blocks = le32_to_cpu(sbi->s_es->s_r_blocks_count);
-	if (free_blocks < root_blocks + 1 && !capable(CAP_SYS_RESOURCE) &&
-		sbi->s_resuid != current_fsuid() &&
-		(sbi->s_resgid == 0 || !in_group_p (sbi->s_resgid))) {
-		return 0;
-	}
-	return 1;
+	if (!capable(CAP_SYS_RESOURCE) && sbi->s_resuid != current_fsuid() &&
+	    (sbi->s_resgid == 0 || !in_group_p(sbi->s_resgid)))
+		return le32_to_cpu(sbi->s_es->s_r_blocks_count) + 1;
+	return 0;
 }
 
 /**
@@ -1444,12 +1442,21 @@ static int ext3_has_free_blocks(struct ext3_sb_info *sbi)
  */
 int ext3_should_retry_alloc(struct super_block *sb, int *retries)
 {
-	if (!ext3_has_free_blocks(EXT3_SB(sb)) || (*retries)++ > 3)
+	struct ext3_sb_info *sbi = EXT3_SB(sb);
+	ext3_fsblk_t limit;
+
+	limit = ext3_free_blocks_limit(sb);
+	if (dac_get_free(&sbi->s_alloc_counter) < limit || (*retries)++ > 3)
 		return 0;
 
 	jbd_debug(1, "%s: retrying operation after ENOSPC\n", sb->s_id);
-
-	return journal_force_commit_nested(EXT3_SB(sb)->s_journal);
+	/*
+	 * There's a chance commit will free some blocks and writeback can
+	 * write delayed blocks so that excessive reservation gets released.
+	 */
+	if (dac_get_reserved(&sbi->s_alloc_counter))
+		writeback_inodes_sb_if_idle(sb);
+	return journal_force_commit_nested(sbi->s_journal);
 }
 
 /**
@@ -1458,6 +1465,7 @@ int ext3_should_retry_alloc(struct super_block *sb, int *retries)
  * @inode:		file inode
  * @goal:		given target block(filesystem wide)
  * @count:		target number of blocks to allocate
+ * @reserved:		number of reserved blocks
  * @errp:		error code
  *
  * ext3_new_blocks uses a goal block to assist allocation.  It tries to
@@ -1465,9 +1473,13 @@ int ext3_should_retry_alloc(struct super_block *sb, int *retries)
  * fails, it will try to allocate block(s) from other block groups without
  * any specific goal block.
  *
+ * If there is some number of blocks reserved for the allocation, we first
+ * allocate non-reserved blocks and only when we have enough of them, we start
+ * using the reserved ones.
  */
 ext3_fsblk_t ext3_new_blocks(handle_t *handle, struct inode *inode,
-			ext3_fsblk_t goal, unsigned long *count, int *errp)
+			ext3_fsblk_t goal, unsigned long *count,
+			unsigned int reserved, int *errp)
 {
 	struct buffer_head *bitmap_bh = NULL;
 	struct buffer_head *gdp_bh;
@@ -1478,7 +1490,7 @@ ext3_fsblk_t ext3_new_blocks(handle_t *handle, struct inode *inode,
 	ext3_fsblk_t ret_block;		/* filesyetem-wide allocated block */
 	int bgi;			/* blockgroup iteration index */
 	int fatal = 0, err;
-	int performed_allocation = 0;
+	int got_quota = 0, got_space = 0;
 	ext3_grpblk_t free_blocks;	/* number of free blocks in a group */
 	struct super_block *sb;
 	struct ext3_group_desc *gdp;
@@ -1499,17 +1511,28 @@ ext3_fsblk_t ext3_new_blocks(handle_t *handle, struct inode *inode,
 		printk("ext3_new_block: nonexistent device");
 		return 0;
 	}
+	sbi = EXT3_SB(sb);
 
 	/*
 	 * Check quota for allocation of this block.
 	 */
-	err = dquot_alloc_block(inode, num);
-	if (err) {
-		*errp = err;
-		return 0;
+	if (dquot_alloc_block(inode, num - reserved)) {
+		*errp = -EDQUOT;
+		goto out;
 	}
+	got_quota = 1;
+	/*
+	 * We need not succeed in allocating all these blocks but we have to
+	 * check & update delalloc counter before allocating blocks. That
+	 * guarantees that reserved blocks are always possible to allocate...
+	 */
+	if (dac_alloc(&sbi->s_alloc_counter, num - reserved,
+		      ext3_free_blocks_limit(sb)) < 0) {
+		*errp = -ENOSPC;
+		goto out;
+	}
+	got_space = 1;
 
-	sbi = EXT3_SB(sb);
 	es = EXT3_SB(sb)->s_es;
 	ext3_debug("goal=%lu.\n", goal);
 	/*
@@ -1524,11 +1547,6 @@ ext3_fsblk_t ext3_new_blocks(handle_t *handle, struct inode *inode,
 	if (block_i && ((windowsz = block_i->rsv_window_node.rsv_goal_size) > 0))
 		my_rsv = &block_i->rsv_window_node;
 
-	if (!ext3_has_free_blocks(sbi)) {
-		*errp = -ENOSPC;
-		goto out;
-	}
-
 	/*
 	 * First, test whether the goal block is free.
 	 */
@@ -1658,8 +1676,6 @@ allocated:
 		goto retry_alloc;
 	}
 
-	performed_allocation = 1;
-
 #ifdef CONFIG_JBD_DEBUG
 	{
 		struct buffer_head *debug_bh;
@@ -1709,7 +1725,6 @@ allocated:
 	spin_lock(sb_bgl_lock(sbi, group_no));
 	le16_add_cpu(&gdp->bg_free_blocks_count, -num);
 	spin_unlock(sb_bgl_lock(sbi, group_no));
-	percpu_counter_sub(&sbi->s_freeblocks_counter, num);
 
 	BUFFER_TRACE(gdp_bh, "journal_dirty_metadata for group descriptor");
 	err = ext3_journal_dirty_metadata(handle, gdp_bh);
@@ -1721,7 +1736,23 @@ allocated:
 
 	*errp = 0;
 	brelse(bitmap_bh);
-	dquot_free_block(inode, *count-num);
+	/* Used some of the reserved blocks? */
+	if (*count - reserved < num) {
+		unsigned int used_rsv = num - (*count - reserved);
+
+		dac_alloc_reserved(&sbi->s_alloc_counter, used_rsv);
+		dquot_claim_block(inode, used_rsv);
+	} else {
+		unsigned int missing_blocks = *count - reserved - num;
+
+		/*
+		 * We didn't succeed in allocating all non-reserved blocks.
+		 * Update counters to fix overestimation we did at the
+		 * beginning of this function
+		 */
+		dac_free(&sbi->s_alloc_counter, missing_blocks);
+		dquot_free_block(inode, missing_blocks);
+	}
 	*count = num;
 	return ret_block;
 
@@ -1735,8 +1766,10 @@ out:
 	/*
 	 * Undo the block allocation
 	 */
-	if (!performed_allocation)
-		dquot_free_block(inode, *count);
+	if (got_quota)
+		dquot_free_block(inode, *count - reserved);
+	if (got_space)
+		dac_free(&sbi->s_alloc_counter, *count - reserved);
 	brelse(bitmap_bh);
 	return 0;
 }
@@ -1746,7 +1779,7 @@ ext3_fsblk_t ext3_new_block(handle_t *handle, struct inode *inode,
 {
 	unsigned long count = 1;
 
-	return ext3_new_blocks(handle, inode, goal, &count, errp);
+	return ext3_new_blocks(handle, inode, goal, &count, 0, errp);
 }
 
 /**
diff --git a/fs/ext3/file.c b/fs/ext3/file.c
index f55df0e..249597d 100644
--- a/fs/ext3/file.c
+++ b/fs/ext3/file.c
@@ -52,6 +52,23 @@ static int ext3_release_file (struct inode * inode, struct file * filp)
 	return 0;
 }
 
+static const struct vm_operations_struct ext3_file_vm_ops = {
+	.fault		= filemap_fault,
+	.page_mkwrite	= ext3_page_mkwrite,
+};
+
+static int ext3_file_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct address_space *mapping = file->f_mapping;
+
+	if (!mapping->a_ops->readpage)
+		return -ENOEXEC;
+	file_accessed(file);
+	vma->vm_ops = &ext3_file_vm_ops;
+	vma->vm_flags |= VM_CAN_NONLINEAR;
+	return 0;
+}
+
 const struct file_operations ext3_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
@@ -62,7 +79,7 @@ const struct file_operations ext3_file_operations = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext3_compat_ioctl,
 #endif
-	.mmap		= generic_file_mmap,
+	.mmap		= ext3_file_mmap,
 	.open		= dquot_file_open,
 	.release	= ext3_release_file,
 	.fsync		= ext3_sync_file,
diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
index 4ab72db..481f63c 100644
--- a/fs/ext3/ialloc.c
+++ b/fs/ext3/ialloc.c
@@ -257,7 +257,7 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent)
 
 	freei = percpu_counter_read_positive(&sbi->s_freeinodes_counter);
 	avefreei = freei / ngroups;
-	freeb = percpu_counter_read_positive(&sbi->s_freeblocks_counter);
+	freeb = dac_get_avail(&sbi->s_alloc_counter);
 	avefreeb = freeb / ngroups;
 	ndirs = percpu_counter_read_positive(&sbi->s_dirs_counter);
 
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 5e0faf4..2ee6df7 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -38,6 +38,7 @@
 #include <linux/bio.h>
 #include <linux/fiemap.h>
 #include <linux/namei.h>
+#include <linux/mount.h>
 #include "xattr.h"
 #include "acl.h"
 
@@ -195,6 +196,7 @@ static int truncate_restart_transaction(handle_t *handle, struct inode *inode)
 void ext3_evict_inode (struct inode *inode)
 {
 	struct ext3_block_alloc_info *rsv;
+	struct ext3_inode_info *ei;
 	handle_t *handle;
 	int want_delete = 0;
 
@@ -205,9 +207,10 @@ void ext3_evict_inode (struct inode *inode)
 
 	truncate_inode_pages(&inode->i_data, 0);
 
+	ei = EXT3_I(inode);
 	ext3_discard_reservation(inode);
-	rsv = EXT3_I(inode)->i_block_alloc_info;
-	EXT3_I(inode)->i_block_alloc_info = NULL;
+	rsv = ei->i_block_alloc_info;
+	ei->i_block_alloc_info = NULL;
 	if (unlikely(rsv))
 		kfree(rsv);
 
@@ -239,7 +242,7 @@ void ext3_evict_inode (struct inode *inode)
 	 * (Well, we could do this if we need to, but heck - it works)
 	 */
 	ext3_orphan_del(handle, inode);
-	EXT3_I(inode)->i_dtime	= get_seconds();
+	ei->i_dtime	= get_seconds();
 
 	/*
 	 * One subtle ordering requirement: if anything has gone wrong
@@ -260,10 +263,194 @@ void ext3_evict_inode (struct inode *inode)
 		ext3_free_inode(handle, inode);
 	}
 	ext3_journal_stop(handle);
+out_check:
+	if (ei->i_reserved_quota)
+		ext3_warning(inode->i_sb, __func__, "Releasing inode %lu with "
+			"%lu reserved blocks.\n", inode->i_ino,
+			(unsigned long)ei->i_reserved_quota);
 	return;
 no_delete:
 	end_writeback(inode);
 	dquot_drop(inode);
+	goto out_check;
+}
+
+/*
+ * Find indirect block structure for given block offset. If the structure
+ * does not exist, return NULL and fill parentp (provided it's != NULL) with
+ * a pointer to the parent node in rb_tree.
+ */
+static struct ext3_da_indirect *ext3_find_da_indirect(struct inode *inode,
+	long i_block, struct rb_node **parentp)
+{
+	struct rb_node *n = EXT3_I(inode)->i_da_indirect.rb_node;
+	struct rb_node *parent = NULL;
+	struct ext3_da_indirect *ind;
+
+	if (i_block < EXT3_NDIR_BLOCKS)
+		return NULL;
+	i_block = (i_block - EXT3_NDIR_BLOCKS) &
+				~(EXT3_ADDR_PER_BLOCK(inode->i_sb) - 1);
+	while (n) {
+		ind = rb_entry(n, struct ext3_da_indirect, node);
+
+		parent = n;
+		if (i_block < ind->offset)
+			n = n->rb_left;
+		else if (i_block > ind->offset)
+			n = n->rb_right;
+		else
+			return ind;
+	}
+	if (parentp)
+		*parentp = parent;
+	return NULL;
+}
+
+static struct ext3_da_indirect *ext3_add_da_indirect(struct inode *inode,
+	long i_block, struct rb_node *parent_node)
+{
+	struct ext3_da_indirect *ind;
+	struct rb_node **np;
+
+	ind = kmalloc(sizeof(struct ext3_da_indirect), GFP_NOFS);
+	if (!ind)
+		return NULL;
+
+	ind->offset = (i_block - EXT3_NDIR_BLOCKS) &
+					~(EXT3_ADDR_PER_BLOCK(inode->i_sb) - 1);
+	ind->data_blocks = 1;
+	ind->flags = 0;
+	if (parent_node) {
+		struct ext3_da_indirect *parent = rb_entry(
+			parent_node, struct ext3_da_indirect, node);
+
+		if (ind->offset < parent->offset)
+			np = &parent_node->rb_left;
+		else
+			np = &parent_node->rb_right;
+	} else
+		np = &EXT3_I(inode)->i_da_indirect.rb_node;
+	rb_link_node(&ind->node, parent_node, np);
+	rb_insert_color(&ind->node, &EXT3_I(inode)->i_da_indirect);
+	return ind;
+}
+
+static int ext3_calc_indirect_depth(struct inode *inode, long i_block)
+{
+	int apbb = EXT3_ADDR_PER_BLOCK_BITS(inode->i_sb);
+
+	if (i_block < EXT3_NDIR_BLOCKS)
+		return 0;
+	i_block -= EXT3_NDIR_BLOCKS;
+	if (i_block < (1 << apbb))
+		return 1;
+	i_block -= (1 << apbb);
+	if (i_block < (1 << 2*apbb))
+		return 2;
+	return 3;
+}
+
+static int ext3_reserve_blocks(struct inode *inode, unsigned int count)
+{
+	int ret;
+
+	if (dquot_reserve_block(inode, count))
+		return -EDQUOT;
+	ret = dac_reserve(&EXT3_SB(inode->i_sb)->s_alloc_counter, count,
+			  ext3_free_blocks_limit(inode->i_sb));
+	if (ret < 0) {
+		dquot_release_reservation_block(inode, count);
+		return ret;
+	}
+	return 0;
+}
+
+static void ext3_cancel_rsv_blocks(struct inode *inode, unsigned int count)
+{
+	dac_cancel_reserved(&EXT3_SB(inode->i_sb)->s_alloc_counter, count);
+	dquot_release_reservation_block(inode, count);
+}
+
+/*
+ * Reserve appropriate amount of space (and quota) for future allocation.
+ * Record the fact in inode's tree of reserved indirect blocks.
+ */
+static int ext3_rsv_da_block(struct inode *inode, long i_block)
+{
+	int depth = ext3_calc_indirect_depth(inode, i_block);
+	struct rb_node *parent_node;
+	struct ext3_da_indirect *ind;
+	int ret;
+
+	/* No indirect blocks needed? */
+	if (depth == 0)
+		return ext3_reserve_blocks(inode, 1);
+
+	mutex_lock(&EXT3_I(inode)->truncate_mutex);
+	ind = ext3_find_da_indirect(inode, i_block, &parent_node);
+	/* If indirect block is already reserved, we need just the data block */
+	if (ind)
+		depth = 1;
+	else
+		depth++;
+
+	ret = ext3_reserve_blocks(inode, depth);
+	if (ret < 0)
+		goto out;
+	
+	if (!ind) {
+		ind = ext3_add_da_indirect(inode, i_block, parent_node);
+		if (!ind) {
+			ext3_cancel_rsv_blocks(inode, depth);
+			ret = -ENOMEM;
+			goto out;
+		}
+	} else
+		ind->data_blocks++;
+out:
+	mutex_unlock(&EXT3_I(inode)->truncate_mutex);
+	return 0;
+}
+
+/*
+ * Cancel reservation of delayed allocated block and corresponding metadata
+ */
+static void ext3_cancel_da_block(struct inode *inode, long i_block)
+{
+	struct ext3_da_indirect *ind;
+	int unrsv = 1;
+
+	if (i_block < EXT3_NDIR_BLOCKS) {
+		ext3_cancel_rsv_blocks(inode, 1);
+		return;
+	}
+
+	mutex_lock(&EXT3_I(inode)->truncate_mutex);
+	ind = ext3_find_da_indirect(inode, i_block, NULL);
+	if (ind && !--ind->data_blocks) {
+		if (!(ind->flags & EXT3_DA_ALLOC_FL))
+			unrsv += ext3_calc_indirect_depth(inode, i_block);
+		rb_erase(&ind->node, &EXT3_I(inode)->i_da_indirect);
+		kfree(ind);
+	}
+	mutex_unlock(&EXT3_I(inode)->truncate_mutex);
+	ext3_cancel_rsv_blocks(inode, unrsv);
+}
+
+static void ext3_allocated_da_block(struct inode *inode,
+				    struct ext3_da_indirect *ind,
+				    int bh_delayed, unsigned int unrsv_blocks)
+{
+	if (!(ind->flags & EXT3_DA_ALLOC_FL)) {
+		/* Cancel unused indirect blocks reservation */
+		ext3_cancel_rsv_blocks(inode, unrsv_blocks);
+		ind->flags |= EXT3_DA_ALLOC_FL;
+	}
+	if (bh_delayed && !--ind->data_blocks) {
+		rb_erase(&ind->node, &EXT3_I(inode)->i_da_indirect);
+		kfree(ind);
+	}
 }
 
 typedef struct {
@@ -537,8 +724,10 @@ static int ext3_blks_to_allocate(Indirect *branch, int k, unsigned long blks,
 
 /**
  *	ext3_alloc_blocks: multiple allocate blocks needed for a branch
+ *	@goal: goal block for the allocation
  *	@indirect_blks: the number of blocks need to allocate for indirect
  *			blocks
+ *	@reserved: is the data block reserved?
  *
  *	@new_blocks: on return it will store the new block numbers for
  *	the indirect blocks(if needed) and the first direct block,
@@ -547,7 +736,8 @@ static int ext3_blks_to_allocate(Indirect *branch, int k, unsigned long blks,
  */
 static int ext3_alloc_blocks(handle_t *handle, struct inode *inode,
 			ext3_fsblk_t goal, int indirect_blks, int blks,
-			ext3_fsblk_t new_blocks[4], int *err)
+			unsigned int reserved, ext3_fsblk_t new_blocks[4],
+			int *err)
 {
 	int target, i;
 	unsigned long count = 0;
@@ -568,11 +758,15 @@ static int ext3_alloc_blocks(handle_t *handle, struct inode *inode,
 	while (1) {
 		count = target;
 		/* allocating blocks for indirect blocks and direct blocks */
-		current_block = ext3_new_blocks(handle,inode,goal,&count,err);
+		current_block = ext3_new_blocks(handle, inode, goal, &count,
+						reserved, err);
 		if (*err)
 			goto failed_out;
 
 		target -= count;
+		/* Used some reserved blocks? */
+		if (target < reserved)
+			reserved = target;
 		/* allocate blocks for indirect blocks */
 		while (index < indirect_blks && count) {
 			new_blocks[index++] = current_block++;
@@ -601,6 +795,8 @@ failed_out:
  *	@inode: owner
  *	@indirect_blks: number of allocated indirect blocks
  *	@blks: number of allocated direct blocks
+ *	@reserved: is the data block reserved?
+ *	@goal: goal block for the allocation
  *	@offsets: offsets (in the blocks) to store the pointers to next.
  *	@branch: place to store the chain in.
  *
@@ -622,8 +818,8 @@ failed_out:
  *	as described above and return 0.
  */
 static int ext3_alloc_branch(handle_t *handle, struct inode *inode,
-			int indirect_blks, int *blks, ext3_fsblk_t goal,
-			int *offsets, Indirect *branch)
+			int indirect_blks, int *blks, unsigned int reserved,
+			ext3_fsblk_t goal, int *offsets, Indirect *branch)
 {
 	int blocksize = inode->i_sb->s_blocksize;
 	int i, n = 0;
@@ -634,7 +830,7 @@ static int ext3_alloc_branch(handle_t *handle, struct inode *inode,
 	ext3_fsblk_t current_block;
 
 	num = ext3_alloc_blocks(handle, inode, goal, indirect_blks,
-				*blks, new_blocks, &err);
+				*blks, reserved, new_blocks, &err);
 	if (err)
 		return err;
 
@@ -834,7 +1030,9 @@ int ext3_get_blocks_handle(handle_t *handle, struct inode *inode,
 	int depth;
 	struct ext3_inode_info *ei = EXT3_I(inode);
 	int count = 0;
+	unsigned int reserved = 0;
 	ext3_fsblk_t first_block = 0;
+	struct ext3_da_indirect *ind = NULL;
 
 
 	J_ASSERT(handle != NULL || create == 0);
@@ -924,16 +1122,48 @@ int ext3_get_blocks_handle(handle_t *handle, struct inode *inode,
 	indirect_blks = (chain + depth) - partial - 1;
 
 	/*
-	 * Next look up the indirect map to count the totoal number of
+	 * Next look up the indirect map to count the total number of
 	 * direct blocks to allocate for this branch.
 	 */
 	count = ext3_blks_to_allocate(partial, indirect_blks,
 					maxblocks, blocks_to_boundary);
-	/*
-	 * Block out ext3_truncate while we alter the tree
-	 */
-	err = ext3_alloc_branch(handle, inode, indirect_blks, &count, goal,
-				offsets + (partial - chain), partial);
+	if (indirect_blks || buffer_delay(bh_result)) {
+		ind = ext3_find_da_indirect(inode, iblock, NULL);
+		if (ind) {
+			if (!(ind->flags & EXT3_DA_ALLOC_FL))
+				reserved = indirect_blks;
+			else if (indirect_blks)
+				ext3_warning(inode->i_sb, __func__,
+					"Block %lu of inode %lu needs "
+					"allocating %d indirect blocks but all "
+					"should be already allocated.",
+					(unsigned long)iblock, inode->i_ino,
+					indirect_blks);
+		}
+		if (buffer_delay(bh_result)) {
+			WARN_ON(maxblocks != 1 || !bh_result->b_page);
+			if (!ind && depth > 1)
+				ext3_warning(inode->i_sb, __func__,
+					"Delayed block %lu of inode %lu is "
+					"missing reservation for %d indirect "
+					"blocks.", (unsigned long)iblock,
+					inode->i_ino, indirect_blks);
+			reserved++;	/* For data block */
+		}
+	}
+	err = ext3_alloc_branch(handle, inode, indirect_blks, &count, reserved,
+				goal, offsets + (partial - chain), partial);
+	if (!err) {
+		if (ind)
+			ext3_allocated_da_block(inode, ind,
+				buffer_delay(bh_result),
+				ext3_calc_indirect_depth(inode, iblock) -
+				indirect_blks);
+		if (buffer_delay(bh_result))
+			clear_buffer_delay(bh_result);
+		else
+			set_buffer_new(bh_result);
+	}
 
 	/*
 	 * The ext3_splice_branch call will free and forget any buffers
@@ -948,8 +1178,6 @@ int ext3_get_blocks_handle(handle_t *handle, struct inode *inode,
 	mutex_unlock(&ei->truncate_mutex);
 	if (err)
 		goto cleanup;
-
-	set_buffer_new(bh_result);
 got_it:
 	map_bh(bh_result, inode->i_sb, le32_to_cpu(chain[depth-1].key));
 	if (count > blocks_to_boundary)
@@ -1744,15 +1972,39 @@ ext3_readpages(struct file *file, struct address_space *mapping,
 	return mpage_readpages(mapping, pages, nr_pages, ext3_get_block);
 }
 
+
+static int truncate_delayed_bh(handle_t *handle, struct buffer_head *bh)
+{
+	if (buffer_delay(bh)) {
+		struct inode *inode = bh->b_page->mapping->host;
+
+		/*
+		 * We cheat here a bit since we do not add a block-in-page
+		 * offset but that does not matter for identifying indirect
+		 * block
+		 */
+		ext3_cancel_da_block(inode, bh->b_page->index <<
+				(PAGE_CACHE_SHIFT - inode->i_blkbits));
+		clear_buffer_delay(bh);
+	}
+	return 0;
+}
+
 static void ext3_invalidatepage(struct page *page, unsigned long offset)
 {
-	journal_t *journal = EXT3_JOURNAL(page->mapping->host);
+	struct inode *inode = page->mapping->host;
+	journal_t *journal = EXT3_JOURNAL(inode);
+	int bsize = 1 << inode->i_blkbits;
 
 	/*
 	 * If it's a full truncate we just forget about the pending dirtying
 	 */
 	if (offset == 0)
 		ClearPageChecked(page);
+	if (page_has_buffers(page)) {
+		walk_page_buffers(NULL, page_buffers(page), offset + bsize - 1,
+				  PAGE_CACHE_SIZE, NULL, truncate_delayed_bh);
+	}
 
 	journal_invalidatepage(journal, page, offset);
 }
@@ -2044,6 +2296,7 @@ static inline int all_zeroes(__le32 *p, __le32 *q)
 /**
  *	ext3_find_shared - find the indirect blocks for partial truncation.
  *	@inode:	  inode in question
+ *	@iblock:  number of the first truncated block
  *	@depth:	  depth of the affected branch
  *	@offsets: offsets of pointers in that branch (see ext3_block_to_path)
  *	@chain:	  place to store the pointers to partial indirect blocks
@@ -2076,8 +2329,8 @@ static inline int all_zeroes(__le32 *p, __le32 *q)
  *		c) free the subtrees growing from the inode past the @chain[0].
  *			(no partially truncated stuff there).  */
 
-static Indirect *ext3_find_shared(struct inode *inode, int depth,
-			int offsets[4], Indirect chain[4], __le32 *top)
+static Indirect *ext3_find_shared(struct inode *inode, sector_t iblock,
+		int depth, int offsets[4], Indirect chain[4], __le32 *top)
 {
 	Indirect *partial, *p;
 	int k, err;
@@ -2097,8 +2350,22 @@ static Indirect *ext3_find_shared(struct inode *inode, int depth,
 	if (!partial->key && *partial->p)
 		/* Writer: end */
 		goto no_top;
+	/*
+	 * If we don't truncate the whole indirect block and there are some
+	 * delay allocated blocks in it (must be before the truncation point
+	 * as ext3_invalidatepage() has been already run for others), we must
+	 * keep the indirect block as reservation has been already spent on
+	 * its allocation.
+	 */
+	if (partial == chain + depth - 1 &&
+	    ext3_find_da_indirect(inode, iblock, NULL)) {
+		p = partial;
+		goto shared_ind_found;
+	}
+
 	for (p=partial; p>chain && all_zeroes((__le32*)p->bh->b_data,p->p); p--)
 		;
+shared_ind_found:
 	/*
 	 * OK, we've found the last block that must survive. The rest of our
 	 * branch should be detached before unlocking. However, if that rest
@@ -2516,7 +2783,7 @@ void ext3_truncate(struct inode *inode)
 		goto do_indirects;
 	}
 
-	partial = ext3_find_shared(inode, n, offsets, chain, &nr);
+	partial = ext3_find_shared(inode, last_block, n, offsets, chain, &nr);
 	/* Kill the top of shared branch (not detached) */
 	if (nr) {
 		if (partial == chain) {
@@ -3493,3 +3760,42 @@ int ext3_change_inode_journal_flag(struct inode *inode, int val)
 
 	return err;
 }
+
+/*
+ * Reserve block writes instead of allocation. Called only on buffer heads
+ * attached to a page (and thus for 1 block).
+ */
+static int ext3_da_get_block(struct inode *inode, sector_t iblock,
+			     struct buffer_head *bh, int create)
+{
+	int ret;
+
+	/* Buffer has already blocks reserved? */
+	if (buffer_delay(bh))
+		return 0;
+
+	ret = ext3_get_blocks_handle(NULL, inode, iblock, 1, bh, 0);
+	if (ret < 0)
+		return ret;
+	if (ret > 0 || !create)
+		return 0;
+	ret = ext3_rsv_da_block(inode, iblock);
+	if (ret < 0)
+		return ret;
+	set_buffer_delay(bh);
+	set_buffer_new(bh);
+	return 0;
+}
+
+int ext3_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	int retry = 0;
+	int ret;
+	struct super_block *sb = vma->vm_file->f_path.mnt->mnt_sb;
+
+	do {
+		ret = block_page_mkwrite(vma, vmf, ext3_da_get_block);
+	} while (ret == VM_FAULT_SIGBUS &&
+		 ext3_should_retry_alloc(sb, &retry));
+	return ret;
+}
diff --git a/fs/ext3/resize.c b/fs/ext3/resize.c
index 0ccd7b1..91d1ae1 100644
--- a/fs/ext3/resize.c
+++ b/fs/ext3/resize.c
@@ -929,7 +929,7 @@ int ext3_group_add(struct super_block *sb, struct ext3_new_group_data *input)
 	le32_add_cpu(&es->s_r_blocks_count, input->reserved_blocks);
 
 	/* Update the free space counts */
-	percpu_counter_add(&sbi->s_freeblocks_counter,
+	percpu_counter_add(&sbi->s_alloc_counter.free,
 			   input->free_blocks_count);
 	percpu_counter_add(&sbi->s_freeinodes_counter,
 			   EXT3_INODES_PER_GROUP(sb));
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 5dbf4db..c5b7f39 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -431,7 +431,7 @@ static void ext3_put_super (struct super_block * sb)
 	for (i = 0; i < sbi->s_gdb_count; i++)
 		brelse(sbi->s_group_desc[i]);
 	kfree(sbi->s_group_desc);
-	percpu_counter_destroy(&sbi->s_freeblocks_counter);
+	dac_destroy(&sbi->s_alloc_counter);
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
 	percpu_counter_destroy(&sbi->s_dirs_counter);
 	brelse(sbi->s_sbh);
@@ -482,6 +482,11 @@ static struct inode *ext3_alloc_inode(struct super_block *sb)
 	ei->vfs_inode.i_version = 1;
 	atomic_set(&ei->i_datasync_tid, 0);
 	atomic_set(&ei->i_sync_tid, 0);
+#ifdef CONFIG_QUOTA
+	ei->i_reserved_quota = 0;
+#endif
+	ei->i_da_indirect = RB_ROOT;
+
 	return &ei->vfs_inode;
 }
 
@@ -742,8 +747,17 @@ static ssize_t ext3_quota_read(struct super_block *sb, int type, char *data,
 			       size_t len, loff_t off);
 static ssize_t ext3_quota_write(struct super_block *sb, int type,
 				const char *data, size_t len, loff_t off);
+#ifdef CONFIG_QUOTA
+qsize_t *ext3_get_reserved_space(struct inode *inode)
+{
+	return &EXT3_I(inode)->i_reserved_quota;
+}
+#endif
 
 static const struct dquot_operations ext3_quota_operations = {
+#ifdef CONFIG_QUOTA
+	.get_reserved_space = ext3_get_reserved_space,
+#endif
 	.write_dquot	= ext3_write_dquot,
 	.acquire_dquot	= ext3_acquire_dquot,
 	.release_dquot	= ext3_release_dquot,
@@ -1946,8 +1960,7 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 				"mounting ext3 over ext2?");
 		goto failed_mount2;
 	}
-	err = percpu_counter_init(&sbi->s_freeblocks_counter,
-			ext3_count_free_blocks(sb));
+	err = dac_init(&sbi->s_alloc_counter, ext3_count_free_blocks(sb));
 	if (!err) {
 		err = percpu_counter_init(&sbi->s_freeinodes_counter,
 				ext3_count_free_inodes(sb));
@@ -2036,7 +2049,7 @@ cantfind_ext3:
 	goto failed_mount;
 
 failed_mount3:
-	percpu_counter_destroy(&sbi->s_freeblocks_counter);
+	dac_destroy(&sbi->s_alloc_counter);
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
 	percpu_counter_destroy(&sbi->s_dirs_counter);
 	journal_destroy(sbi->s_journal);
@@ -2723,7 +2736,7 @@ static int ext3_statfs (struct dentry * dentry, struct kstatfs * buf)
 	buf->f_type = EXT3_SUPER_MAGIC;
 	buf->f_bsize = sb->s_blocksize;
 	buf->f_blocks = le32_to_cpu(es->s_blocks_count) - sbi->s_overhead_last;
-	buf->f_bfree = percpu_counter_sum_positive(&sbi->s_freeblocks_counter);
+	buf->f_bfree = dac_get_avail_sum(&sbi->s_alloc_counter);
 	buf->f_bavail = buf->f_bfree - le32_to_cpu(es->s_r_blocks_count);
 	if (buf->f_bfree < le32_to_cpu(es->s_r_blocks_count))
 		buf->f_bavail = 0;
diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index 6ce1bca..e24a355 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -837,12 +837,14 @@ ext3_group_first_block_no(struct super_block *sb, unsigned long group_no)
 # define NORET_AND     noreturn,
 
 /* balloc.c */
+extern ext3_fsblk_t ext3_free_blocks_limit(struct super_block *sb);
 extern int ext3_bg_has_super(struct super_block *sb, int group);
 extern unsigned long ext3_bg_num_gdb(struct super_block *sb, int group);
 extern ext3_fsblk_t ext3_new_block (handle_t *handle, struct inode *inode,
 			ext3_fsblk_t goal, int *errp);
 extern ext3_fsblk_t ext3_new_blocks (handle_t *handle, struct inode *inode,
-			ext3_fsblk_t goal, unsigned long *count, int *errp);
+			ext3_fsblk_t goal, unsigned long *count,
+			unsigned int reserved, int *errp);
 extern void ext3_free_blocks (handle_t *handle, struct inode *inode,
 			ext3_fsblk_t block, unsigned long count);
 extern void ext3_free_blocks_sb (handle_t *handle, struct super_block *sb,
@@ -908,6 +910,7 @@ extern void ext3_get_inode_flags(struct ext3_inode_info *);
 extern void ext3_set_aops(struct inode *inode);
 extern int ext3_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		       u64 start, u64 len);
+extern int ext3_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
 
 /* ioctl.c */
 extern long ext3_ioctl(struct file *, unsigned int, unsigned long);
diff --git a/include/linux/ext3_fs_i.h b/include/linux/ext3_fs_i.h
index f42c098..10e7703 100644
--- a/include/linux/ext3_fs_i.h
+++ b/include/linux/ext3_fs_i.h
@@ -64,6 +64,20 @@ struct ext3_block_alloc_info {
 #define rsv_start rsv_window._rsv_start
 #define rsv_end rsv_window._rsv_end
 
+
+#define EXT3_DA_ALLOC_FL 0x0001	/* Indirect block is allocated */
+/*
+ * Structure recording information about indirect block with delayed allocated
+ * data blocks beneath.
+ */
+struct ext3_da_indirect {
+	struct rb_node node;
+	__u32 offset;			/* Offset of indirect block */
+	unsigned short data_blocks;	/* Number of delayed allocated data
+					 * blocks below this indirect block */
+	unsigned short flags;
+};
+
 /*
  * third extended file system inode data in memory
  */
@@ -92,6 +106,9 @@ struct ext3_inode_info {
 	/* block reservation info */
 	struct ext3_block_alloc_info *i_block_alloc_info;
 
+	/* RB-tree with information about delayed-allocated indirect blocks */
+	struct rb_root i_da_indirect;
+
 	__u32	i_dir_start_lookup;
 #ifdef CONFIG_EXT3_FS_XATTR
 	/*
@@ -125,6 +142,9 @@ struct ext3_inode_info {
 
 	/* on-disk additional length */
 	__u16 i_extra_isize;
+#ifdef CONFIG_QUOTA
+	qsize_t i_reserved_quota;
+#endif
 
 	/*
 	 * truncate_mutex is for serialising ext3_truncate() against
diff --git a/include/linux/ext3_fs_sb.h b/include/linux/ext3_fs_sb.h
index 258088a..54909d0 100644
--- a/include/linux/ext3_fs_sb.h
+++ b/include/linux/ext3_fs_sb.h
@@ -21,6 +21,7 @@
 #include <linux/wait.h>
 #include <linux/blockgroup_lock.h>
 #include <linux/percpu_counter.h>
+#include <linux/delalloc_counter.h>
 #endif
 #include <linux/rbtree.h>
 
@@ -58,7 +59,7 @@ struct ext3_sb_info {
 	u32 s_hash_seed[4];
 	int s_def_hash_version;
 	int s_hash_unsigned;	/* 3 if hash should be signed, 0 if not */
-	struct percpu_counter s_freeblocks_counter;
+	struct delalloc_counter s_alloc_counter;
 	struct percpu_counter s_freeinodes_counter;
 	struct percpu_counter s_dirs_counter;
 	struct blockgroup_lock *s_blockgroup_lock;
-- 
1.6.4.2

