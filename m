From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Patch queue update
Date: Sun, 15 Jun 2008 22:51:36 +0530
Message-ID: <20080615172136.GA7293@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:59198 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758540AbYFORWL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 15 Jun 2008 13:22:11 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id m5FHLWn9032701
	for <linux-ext4@vger.kernel.org>; Mon, 16 Jun 2008 03:21:32 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5FHM80v207056
	for <linux-ext4@vger.kernel.org>; Mon, 16 Jun 2008 03:22:08 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5FHM7Dm010723
	for <linux-ext4@vger.kernel.org>; Mon, 16 Jun 2008 03:22:08 +1000
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Mingming,

Attached below are new patches for the patchqueue. Some of patches
update already existing patches, mostly to get them apply
cleanly after adding new patches or to fix sparse warning. The modified
patches should not have any functionality change. The diff between
the patchqueue and updated queue is attached below. That should help
to look at the changes easily.  The patch queue looked at is
as of commit 22d4c3124d50803222c14116b3fdf08dc447a119

The updated series file
http://www.radian.org/~kvaneesh/ext4/jun-15-2008/series
The patches
http://www.radian.org/~kvaneesh/ext4/jun-15-2008/
The complete patchset.
http://www.radian.org/~kvaneesh/ext4/jun-15-2008/patches.tar.gz


-aneesh


diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 03a168f..7315adc 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -47,7 +47,7 @@ static int ext4_block_in_group(struct super_block *sb, ext4_fsblk_t block,
 			ext4_group_t block_group)
 {
 	ext4_group_t actual_group;
-	ext4_get_group_no_and_offset(sb, block, &actual_group, 0);
+	ext4_get_group_no_and_offset(sb, block, &actual_group, NULL);
 	if (actual_group == block_group)
 		return 1;
 	return 0;
@@ -538,7 +538,7 @@ void ext4_rsv_window_add(struct super_block *sb,
  * from the filesystem reservation window rb tree. Must be called with
  * rsv_lock hold.
  */
-void rsv_window_remove(struct super_block *sb,
+static void rsv_window_remove(struct super_block *sb,
 			      struct ext4_reserve_window_node *rsv)
 {
 	rsv->rsv_start = EXT4_RESERVE_WINDOW_NOT_ALLOCATED;
@@ -1706,7 +1706,12 @@ ext4_fsblk_t ext4_old_new_blocks(handle_t *handle, struct inode *inode,
 	}
 
 	sbi = EXT4_SB(sb);
-	*count = ext4_has_free_blocks(sbi, *count);
+	if (!EXT4_I(inode)->i_delalloc_reserved_flag) {
+		/*
+		 * With delalloc we already reserved the blocks
+		 */
+		*count = ext4_has_free_blocks(sbi, *count);
+	}
 	if (*count == 0) {
 		*errp = -ENOSPC;
 		return 0;	/*return with ENOSPC error */
@@ -1907,7 +1912,8 @@ ext4_fsblk_t ext4_old_new_blocks(handle_t *handle, struct inode *inode,
 	le16_add_cpu(&gdp->bg_free_blocks_count, -num);
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, group_no, gdp);
 	spin_unlock(sb_bgl_lock(sbi, group_no));
-	percpu_counter_sub(&sbi->s_freeblocks_counter, num);
+	if (!EXT4_I(inode)->i_delalloc_reserved_flag)
+		percpu_counter_sub(&sbi->s_freeblocks_counter, num);
 
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi, group_no);
@@ -1977,52 +1983,53 @@ static ext4_fsblk_t do_blk_alloc(handle_t *handle, struct inode *inode,
 
 	ret = ext4_mb_new_blocks(handle, &ar, errp);
 	*count = ar.len;
-	/*
-	 * Account for the allocated meta blocks
-	 */
-	if (!(*errp) && (flags & EXT4_META_BLOCK)) {
-		spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
-		EXT4_I(inode)->i_allocated_meta_blocks += ar.len;
-		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
-	}
 	return ret;
 }
 
 /*
- * ext4_new_meta_block() -- allocate block for meta data (indexing) blocks
+ * ext4_new_meta_blocks() -- allocate block for meta data (indexing) blocks
  *
  * @handle:             handle to this transaction
  * @inode:              file inode
  * @goal:               given target block(filesystem wide)
+ * @count:		total number of blocks need
  * @errp:               error code
  *
- * Return allocated block number on success
+ * Return 1st allocated block numberon success, *count stores total account
+ * error stores in errp pointer
  */
-ext4_fsblk_t ext4_new_meta_block(handle_t *handle, struct inode *inode,
-		ext4_fsblk_t goal, int *errp)
+ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
+		ext4_fsblk_t goal, unsigned long *count, int *errp)
 {
-	unsigned long count = 1;
-	return do_blk_alloc(handle, inode, 0, goal,
-			&count, errp, EXT4_META_BLOCK);
+	ext4_fsblk_t ret;
+	ret = do_blk_alloc(handle, inode, 0, goal,
+				count, errp, EXT4_META_BLOCK);
+	/*
+	 * Account for the allocated meta blocks
+	 */
+	if (!(*errp)) {
+		spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
+		EXT4_I(inode)->i_allocated_meta_blocks += *count;
+		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
+	}
+	return ret;
 }
 
 /*
- * ext4_new_meta_blocks() -- allocate block for meta data (indexing) blocks
+ * ext4_new_meta_block() -- allocate block for meta data (indexing) blocks
  *
  * @handle:             handle to this transaction
  * @inode:              file inode
  * @goal:               given target block(filesystem wide)
- * @count:		total number of blocks need
  * @errp:               error code
  *
- * Return 1st allocated block numberon success, *count stores total account
- * error stores in errp pointer
+ * Return allocated block number on success
  */
-ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
-		ext4_fsblk_t goal, unsigned long *count, int *errp)
+ext4_fsblk_t ext4_new_meta_block(handle_t *handle, struct inode *inode,
+		ext4_fsblk_t goal, int *errp)
 {
-	return do_blk_alloc(handle, inode, 0, goal,
-			count, errp, EXT4_META_BLOCK);
+	unsigned long count = 1;
+	return ext4_new_meta_blocks(handle, inode, goal, &count, errp);
 }
 
 /*
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index fdd8983..92d3aab 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -592,11 +592,15 @@ ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
 	}
 
 	path[ppos].p_depth = i;
+	path[ppos].p_ext = NULL;
 	path[ppos].p_idx = NULL;
 
 	/* find extent */
 	ext4_ext_binsearch(inode, path + ppos, block);
-	path[ppos].p_block = ext_pblock(path[ppos].p_ext);
+	/* if not an empty leaf */
+	if (path[ppos].p_ext)
+		path[ppos].p_block = ext_pblock(path[ppos].p_ext);
+
 
 	ext4_ext_show_path(inode, path);
 
@@ -3120,7 +3124,7 @@ long ext4_fallocate(struct inode *inode, int mode, loff_t offset, loff_t len)
 	struct fiemap		*fiemap_s;
 	struct fiemap_extent	fm_extent;
 	size_t			tot_mapping_len;
-	char			*cur_ext_ptr;
+	char __user		*cur_ext_ptr;
 	int			current_extent;
 	int			err;
 };
@@ -3128,7 +3132,7 @@ long ext4_fallocate(struct inode *inode, int mode, loff_t offset, loff_t len)
 /*
  * Callback function called for each extent to gather FIEMAP information.
  */
-int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_path *path,
+static int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_path *path,
 		       struct ext4_ext_cache *newex, struct ext4_extent *ex,
 		       void *data)
 {
@@ -3252,7 +3256,7 @@ int ext4_fiemap(struct inode *inode, unsigned long arg)
 	start_blk = fiemap_s->fm_start >> inode->i_sb->s_blocksize_bits;
 	fiemap_i.fiemap_s = fiemap_s;
 	fiemap_i.tot_mapping_len = 0;
-	fiemap_i.cur_ext_ptr = (char *)(arg + sizeof(*fiemap_s));
+	fiemap_i.cur_ext_ptr = (char __user *)(arg + sizeof(*fiemap_s));
 	fiemap_i.current_extent = 0;
 	fiemap_i.err = 0;
 
@@ -3277,18 +3281,18 @@ int ext4_fiemap(struct inode *inode, unsigned long arg)
 	if (fiemap_i.current_extent != 0 &&
 	    fiemap_i.current_extent < fiemap_s->fm_extent_count &&
 	    !(fiemap_s->fm_flags & FIEMAP_FLAG_NUM_EXTENTS)) {
-		char *dest;
+		char __user *dest;
 
 		last_extent = &fiemap_i.fm_extent;
 		last_extent->fe_flags |= FIEMAP_EXTENT_LAST;
-		dest = (char *)arg + sizeof(*fiemap_s) + fm_extent_size *
+		dest = (char __user *)arg + sizeof(*fiemap_s) + fm_extent_size *
 						(fiemap_s->fm_extent_count - 1);
 		err = copy_to_user(dest, last_extent, fm_extent_size);
 		if (err)
 			goto out_free;
 	}
 
-	err = copy_to_user((void *)arg, fiemap_s, sizeof(*fiemap_s));
+	err = copy_to_user((void __user *)arg, fiemap_s, sizeof(*fiemap_s));
 
 out_free:
 	kfree(fiemap_s);
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 7823405..dc8bfc4 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -820,7 +820,6 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode * dir, int mode)
 	ei->i_state = EXT4_STATE_NEW;
 
 	ei->i_extra_isize = EXT4_SB(sb)->s_want_extra_isize;
-	jbd2_journal_init_jbd_inode(&ei->jinode, inode);
 
 	ret = inode;
 	if(DQUOT_ALLOC_INODE(inode)) {
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5aee4b0..fef2574 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -525,7 +525,7 @@ static int ext4_alloc_blocks(handle_t *handle, struct inode *inode,
 				ext4_fsblk_t new_blocks[4], int *err)
 {
 	int target, i;
-	long count = 0, blk_allocated = 0;
+	unsigned long count = 0, blk_allocated = 0;
 	int index = 0;
 	ext4_fsblk_t current_block = 0;
 	int ret = 0;
@@ -1561,7 +1561,7 @@ static int ext4_da_get_block_write(struct inode *inode, sector_t iblock,
 	handle_t *handle = NULL;
 
 	handle = ext4_journal_current_handle();
-	BUG_ON(handle == 0);
+	BUG_ON(handle == NULL);
 	BUG_ON(create == 0);
 
 	ret = ext4_get_blocks_wrap(handle, inode, iblock, max_blocks,
@@ -1606,11 +1606,12 @@ static int ext4_bh_unmapped_or_delay(handle_t *handle, struct buffer_head *bh)
 	return !buffer_mapped(bh) || buffer_delay(bh);
 }
 
-/* FIXME!! only support data=writeback mode */
 /*
  * get called vi ext4_da_writepages after taking page lock
  * We may end up doing block allocation here in case
  * mpage_da_map_blocks failed to allocate blocks.
+ *
+ * We also get called via journal_submit_inode_data_buffers
  */
 static int ext4_da_writepage(struct page *page,
 				struct writeback_control *wbc)
@@ -1629,6 +1630,7 @@ static int ext4_da_writepage(struct page *page,
 		 * ext4_da_writepages() but directly (shrink_page_list).
 		 * We cannot easily start a transaction here so we just skip
 		 * writing the page in case we would have to do so.
+		 * We reach here also via journal_submit_inode_data_buffers
 		 */
 		size = i_size_read(inode);
 
@@ -1644,8 +1646,11 @@ static int ext4_da_writepage(struct page *page,
 			 * We can't do block allocation under
 			 * page lock without a handle . So redirty
 			 * the page and return
+			 * We may reach here when we do a journal commit
+			 * via journal_submit_inode_data_buffers.
+			 * If we don't have mapping block we just ignore
+			 * them
 			 */
-			BUG_ON(wbc->sync_mode != WB_SYNC_NONE);
 			redirty_page_for_writepage(wbc, page);
 			unlock_page(page);
 			return 0;
@@ -1660,7 +1665,6 @@ static int ext4_da_writepage(struct page *page,
 	return ret;
 }
 
-
 /*
  * For now just follow the DIO way to estimate the max credits
  * needed to write out EXT4_MAX_WRITEBACK_PAGES.
@@ -1693,7 +1697,7 @@ static int ext4_da_writepages(struct address_space *mapping,
 		return 0;
 
 	/*
-	 *  Estimate the worse case needed credits to write out
+	 * Estimate the worse case needed credits to write out
 	 * EXT4_MAX_BUF_BLOCKS pages
 	 */
 	needed_blocks = EXT4_MAX_WRITEBACK_CREDITS;
@@ -1715,6 +1719,19 @@ static int ext4_da_writepages(struct address_space *mapping,
 			ret = PTR_ERR(handle);
 			goto out_writepages;
 		}
+		if (ext4_should_order_data(inode)) {
+			/*
+			 * With ordered mode we need to add
+			 * the inode to the journal handle
+			 * when we do block allocation.
+			 */
+			ret = ext4_jbd2_file_inode(handle, inode);
+			if (ret) {
+				ext4_journal_stop(handle);
+				goto out_writepages;
+			}
+
+		}
 		/*
 		 * set the max dirty pages could be write at a time
 		 * to fit into the reserved transaction credits
@@ -1749,15 +1766,17 @@ static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
 				loff_t pos, unsigned len, unsigned flags,
 				struct page **pagep, void **fsdata)
 {
-	int ret;
+	int ret, retries = 0;
 	struct page *page;
 	pgoff_t index;
 	unsigned from, to;
+	struct inode *inode = mapping->host;
 
 	index = pos >> PAGE_CACHE_SHIFT;
 	from = pos & (PAGE_CACHE_SIZE - 1);
 	to = from + len;
 
+retry:
 	page = __grab_cache_page(mapping, index);
 	if (!page)
 		return -ENOMEM;
@@ -1769,6 +1788,8 @@ static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
 		unlock_page(page);
 		page_cache_release(page);
 	}
+	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
+		goto retry;
 
 	return ret;
 }
@@ -2228,7 +2249,10 @@ static int ext4_journalled_set_page_dirty(struct page *page)
 
 void ext4_set_aops(struct inode *inode)
 {
-	if (ext4_should_order_data(inode))
+	if (ext4_should_order_data(inode) &&
+		test_opt(inode->i_sb, DELALLOC))
+		inode->i_mapping->a_ops = &ext4_da_aops;
+	else if (ext4_should_order_data(inode))
 		inode->i_mapping->a_ops = &ext4_ordered_aops;
 	else if (ext4_should_writeback_data(inode) &&
 		 test_opt(inode->i_sb, DELALLOC))
@@ -3887,18 +3911,6 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 	return err;
 }
 
-static int ext4_bh_prepare_fill(handle_t *handle, struct buffer_head *bh)
-{
-	if (!buffer_mapped(bh)) {
-		/*
-		 * Mark buffer as dirty so that
-		 * block_write_full_page() writes it
-		 */
-		set_buffer_dirty(bh);
-	}
-	return 0;
-}
-
 static int ext4_bh_unmapped(handle_t *handle, struct buffer_head *bh)
 {
 	return !buffer_mapped(bh);
@@ -3908,13 +3920,10 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page)
 {
 	loff_t size;
 	unsigned long len;
-	int err, ret = -EINVAL;
-	handle_t *handle;
+	int ret = -EINVAL;
 	struct file *file = vma->vm_file;
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct address_space *mapping = inode->i_mapping;
-	struct writeback_control wbc = { .sync_mode = WB_SYNC_NONE,
-					 .nr_to_write = 1 };
 
 	/*
 	 * Get i_alloc_sem to stop truncates messing with the inode. We cannot
@@ -3941,38 +3950,23 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page)
 		if (!walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
 				       ext4_bh_unmapped))
 			goto out_unlock;
-		/*
-		 * Now mark all the  buffer head dirty so
-		 * that writepage can write it
-		 */
-		walk_page_buffers(NULL, page_buffers(page), 0, len,
-					NULL, ext4_bh_prepare_fill);
 	}
 	/*
-	 * OK, we need to fill the hole... Lock the page and do writepage.
-	 * We can't do write_begin and write_end here because we don't
-	 * have inode_mutex and that allow parallel write_begin, write_end call.
-	 * (lock_page prevent this from happening on the same page though)
+	 * OK, we need to fill the hole... Do write_begin write_end
+	 * to do block allocation/reservation.We are not holding
+	 * inode.i__mutex here. That allow * parallel write_begin,
+	 * write_end call. lock_page prevent this from happening
+	 * on the same page though
 	 */
-	handle = ext4_journal_start(inode, ext4_writepage_trans_blocks(inode));
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
+	ret = mapping->a_ops->write_begin(file, mapping, page_offset(page),
+			len, AOP_FLAG_UNINTERRUPTIBLE, &page, NULL);
+	if (ret < 0)
 		goto out_unlock;
-	}
-	lock_page(page);
-	wbc.range_start = page_offset(page);
-	wbc.range_end = page_offset(page) + len;
-	if (!ext4_should_journal_data(inode)) {
-		ret = __ext4_normal_writepage(page, &wbc);
-		if (!ret && ext4_should_order_data(inode))
-			ret = ext4_jbd2_file_inode(handle, inode);
-	} else {
-		ret = __ext4_journalled_writepage(page, &wbc);
-	}
-	/* Page got unlocked in writepage */
-	err = ext4_journal_stop(handle);
-	if (!ret)
-		ret = err;
+	ret = mapping->a_ops->write_end(file, mapping, page_offset(page),
+			len, len, page, NULL);
+	if (ret < 0)
+		goto out_unlock;
+	ret = 0;
 out_unlock:
 	up_read(&inode->i_alloc_sem);
 	return ret;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6fa08ca..fde1ae9 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -578,6 +578,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	ei->i_allocated_meta_blocks = 0;
 	ei->i_delalloc_reserved_flag = 0;
 	spin_lock_init(&(ei->i_block_reservation_lock));
+	jbd2_journal_init_jbd_inode(&ei->jinode, &ei->vfs_inode);
 	return &ei->vfs_inode;
 }
 
@@ -1878,8 +1879,8 @@ static unsigned long ext4_get_stripe_size(struct ext4_sb_info *sbi)
 }
 
 static int ext4_fill_super (struct super_block *sb, void *data, int silent)
-				__releases(kernel_sem)
-				__acquires(kernel_sem)
+				__releases(kernel_lock)
+				__acquires(kernel_lock)
 
 {
 	struct buffer_head * bh;
@@ -1996,7 +1997,6 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
 	 * Use -o nodelalloc to turn it off
 	 */
 	set_opt(sbi->s_mount_opt, DELALLOC);
-	set_opt(sbi->s_mount_opt, WRITEBACK_DATA);
 
 
 	if (!parse_options ((char *) data, sb, &journal_inum, &journal_devnum,
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 483183d..32ca3c3 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -22,6 +22,8 @@
 #include <linux/pagemap.h>
 #include <linux/jiffies.h>
 #include <linux/crc32.h>
+#include <linux/writeback.h>
+#include <linux/backing-dev.h>
 
 /*
  * Default IO end handler for temporary BJ_IO buffer_heads.
@@ -185,6 +187,30 @@ static int journal_wait_on_commit_record(struct buffer_head *bh)
 }
 
 /*
+ * write the filemap data using writepage() address_space_operations.
+ * We don't do block allocation here even for delalloc. We don't
+ * use writepages() because with dealyed allocation we may be doing
+ * block allocation in writepages().
+ */
+static int journal_submit_inode_data_buffers(struct address_space *mapping)
+{
+	int ret;
+	struct writeback_control wbc = {
+		.sync_mode =  WB_SYNC_ALL,
+		.nr_to_write = mapping->nrpages * 2,
+		.range_start = 0,
+		.range_end = i_size_read(mapping->host),
+		.for_writepages = 1,
+	};
+
+	if (!mapping_cap_writeback_dirty(mapping))
+		return 0;
+
+	ret = generic_writepages(mapping, &wbc);
+	return ret;
+}
+
+/*
  * Submit all the data buffers of inode associated with the transaction to
  * disk.
  *
@@ -192,7 +218,7 @@ static int journal_wait_on_commit_record(struct buffer_head *bh)
  * our inode list. We use JI_COMMIT_RUNNING flag to protect inode we currently
  * operate on from being released while we write out pages.
  */
-static int journal_submit_inode_data_buffers(journal_t *journal,
+static int journal_submit_data_buffers(journal_t *journal,
 		transaction_t *commit_transaction)
 {
 	struct jbd2_inode *jinode;
@@ -204,8 +230,13 @@ static int journal_submit_inode_data_buffers(journal_t *journal,
 		mapping = jinode->i_vfs_inode->i_mapping;
 		jinode->i_flags |= JI_COMMIT_RUNNING;
 		spin_unlock(&journal->j_list_lock);
-		err = filemap_fdatawrite_range(mapping, 0,
-					i_size_read(jinode->i_vfs_inode));
+		/*
+		 * submit the inode data buffers. We use writepage
+		 * instead of writepages. Because writepages can do
+		 * block allocation  with delalloc. We need to write
+		 * only allocated blocks here.
+		 */
+		err = journal_submit_inode_data_buffers(mapping);
 		if (!ret)
 			ret = err;
 		spin_lock(&journal->j_list_lock);
@@ -228,7 +259,7 @@ static int journal_finish_inode_data_buffers(journal_t *journal,
 	struct jbd2_inode *jinode, *next_i;
 	int err, ret = 0;
 
-	/* For locking, see the comment in journal_submit_inode_data_buffers() */
+	/* For locking, see the comment in journal_submit_data_buffers() */
 	spin_lock(&journal->j_list_lock);
 	list_for_each_entry(jinode, &commit_transaction->t_inode_list, i_list) {
 		jinode->i_flags |= JI_COMMIT_RUNNING;
@@ -431,7 +462,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	 * Now start flushing things to disk, in the order they appear
 	 * on the transaction lists.  Data blocks go first.
 	 */
-	err = journal_submit_inode_data_buffers(journal, commit_transaction);
+	err = journal_submit_data_buffers(journal, commit_transaction);
 	if (err)
 		jbd2_journal_abort(journal, err);
 
