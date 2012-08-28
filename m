From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 3/3] ext4: reimplement uninit extent optimization for move_extent_per_page
Date: Tue, 28 Aug 2012 20:21:43 +0400
Message-ID: <1346170903-7563-3-git-send-email-dmonakhov@openvz.org>
References: <1346170903-7563-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, a-fujita@rs.jp.nec.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41439 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963Ab2H1QWG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Aug 2012 12:22:06 -0400
Received: by lbbgj3 with SMTP id gj3so3379819lbb.19
        for <linux-ext4@vger.kernel.org>; Tue, 28 Aug 2012 09:22:04 -0700 (PDT)
In-Reply-To: <1346170903-7563-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Uninitialized extent may became initialized(parallel writeback task)
at any moment after we drop i_data_sem, so we have to recheck extent's
state after we hold page's lock and i_data_sem.

If we about to change page's mapping we must hold page's lock in order to
serialize other users.
---
 fs/ext4/move_extent.c |   96 ++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 87 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index c5ca317..b62defa 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -629,6 +629,42 @@ mext_calc_swap_extents(struct ext4_extent *tmp_dext,
 }
 
 /**
+ * mext_check_range_coverage - Check that all extents in range has the same type
+ *
+ * @inode:		inode in question
+ * @from:		block offset of inode
+ * @count:		block count to be checked
+ * @uninit:		extents expected to be uninitialized
+ * @err:		pointer to save error value
+ *
+ * Return 1 if all extents in range has expected type, and zero otherwise.
+ */
+int mext_check_range_coverage(struct inode *inode, ext4_lblk_t from, ext4_lblk_t count,
+			  int uninit, int *err)
+{
+	struct ext4_ext_path *path = NULL;
+	struct ext4_extent *ext;
+	ext4_lblk_t last = from;
+	while (from < last) {
+		*err = get_ext_path(inode, from, &path);
+		if (*err)
+			return 0;
+		ext = path[ext_depth(inode)].p_ext;
+		if (!ext) {
+			ext4_ext_drop_refs(path);
+			return 0;
+		}
+		if (uninit != ext4_ext_is_uninitialized(ext)) {
+			ext4_ext_drop_refs(path);
+			return 0;
+		}
+		from += ext4_ext_get_actual_len(ext);
+		ext4_ext_drop_refs(path);
+	}
+	return 1;
+}
+
+/**
  * mext_replace_branches - Replace original extents with new extents
  *
  * @handle:		journal handle
@@ -663,9 +699,6 @@ mext_replace_branches(handle_t *handle, struct inode *orig_inode,
 	int replaced_count = 0;
 	int dext_alen;
 
-	/* Protect extent trees against block allocations via delalloc */
-	double_down_write_data_sem(orig_inode, donor_inode);
-
 	/* Get the original extent for the block "orig_off" */
 	*err = get_ext_path(orig_inode, orig_off, &orig_path);
 	if (*err)
@@ -764,8 +797,6 @@ out:
 	ext4_ext_invalidate_cache(orig_inode);
 	ext4_ext_invalidate_cache(donor_inode);
 
-	double_up_write_data_sem(orig_inode, donor_inode);
-
 	return replaced_count;
 }
 
@@ -807,10 +838,6 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
 	int replaced_count = 0;
 	int blocks_per_page = PAGE_CACHE_SIZE >> orig_inode->i_blkbits;
 
-	/*
-	 * It needs twice the amount of ordinary journal buffers because
-	 * inode and donor_inode may change each different metadata blocks.
-	 */
 	jblocks = ext4_writepage_trans_blocks(orig_inode) * 2;
 
 	if (segment_eq(get_fs(), KERNEL_DS))
@@ -819,6 +846,55 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
 	orig_blk_offset = orig_page_offset * blocks_per_page +
 		data_offset_in_page;
 
+	/*
+	 * If orig extent was uninitialized, but it can become initialized at any
+	 * time after i_data_sem was dropped, in order to serialize with delalloc
+	 * we have recheck extent while we hold page's lock, if it is still the
+	 * case data copy is not necessery, just swap data blocks between orig
+	 * and donor.
+	 */
+	if (uninit) {
+		handle = ext4_journal_start(orig_inode, jblocks);
+		if (!handle) {
+			*err = -ENOMEM;
+			return 0;
+		}
+		page = find_or_create_page(mapping,orig_page_offset, GFP_NOFS);
+		if (!page) {
+			ext4_journal_stop(handle);
+			*err = -ENOMEM;
+			return 0;
+		}
+		double_down_write_data_sem(orig_inode, donor_inode);
+		/* If any of extents in range became initialized we have to
+		 * fallback to data copying */
+		if (!mext_check_range_coverage(orig_inode, orig_blk_offset,
+					   block_len_in_page, 1, err) ||
+		    !mext_check_range_coverage(donor_inode, orig_blk_offset,
+					   block_len_in_page, 1, &err2)) {
+			double_up_write_data_sem(orig_inode, donor_inode);
+			unlock_page(page);
+			page_cache_release(page);
+			ext4_journal_stop(handle);
+			if (*err || err2)
+				goto out;
+			goto data_copy;
+		}
+		if (!try_to_release_page(page, 0))
+			goto drop_data_sem;
+
+		if (!PageUptodate(page)) {
+			zero_user(page, 0, PAGE_SIZE);
+			SetPageUptodate(page);
+		}
+		replaced_count = mext_replace_branches(handle, orig_inode,
+						donor_inode, orig_blk_offset,
+						block_len_in_page, err);
+	drop_data_sem:
+		double_up_write_data_sem(orig_inode, donor_inode);
+		goto drop_page;
+	}
+data_copy:
 	offs = (long long)orig_blk_offset << orig_inode->i_blkbits;
 
 	/* Calculate data_size */
@@ -884,9 +960,11 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
 	if (ext4_journal_extend(handle, jblocks) < 0)
 		goto write_end;
 
+	double_down_write_data_sem(orig_inode, donor_inode);
 	replaced_count = mext_replace_branches(handle, orig_inode, donor_inode,
 					orig_blk_offset, block_len_in_page,
 					&err2);
+	double_up_write_data_sem(orig_inode, donor_inode);
 	if (err2) {
 		if (replaced_count) {
 			block_len_in_page = replaced_count;
-- 
1.7.7.6

