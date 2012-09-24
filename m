From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 4/4] ext4: reimplement uninit extent optimization for move_extent_per_page V2
Date: Mon, 24 Sep 2012 16:23:54 +0400
Message-ID: <1348489434-22778-5-git-send-email-dmonakhov@openvz.org>
References: <1348489434-22778-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, a-fujita@rs.jp.nec.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:50631 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223Ab2IXMYH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Sep 2012 08:24:07 -0400
Received: by mail-lb0-f174.google.com with SMTP id gj3so6602143lbb.19
        for <linux-ext4@vger.kernel.org>; Mon, 24 Sep 2012 05:24:06 -0700 (PDT)
In-Reply-To: <1348489434-22778-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Uninitialized extent may became initialized(parallel writeback task)
at any moment after we drop i_data_sem, so we have to recheck extent's
state after we hold page's lock and i_data_sem.

If we about to change page's mapping we must hold page's lock in order to
serialize other users.
Changes from V1 in response to Akira's comments:
- fix last block mistype
- Rerutn inital error code

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/move_extent.c |   81 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 76 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index f416f83..cbcca98 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -595,6 +595,43 @@ mext_calc_swap_extents(struct ext4_extent *tmp_dext,
 }
 
 /**
+ * mext_check_coverage - Check that all extents in range has the same type
+ *
+ * @inode:		inode in question
+ * @from:		block offset of inode
+ * @count:		block count to be checked
+ * @uninit:		extents expected to be uninitialized
+ * @err:		pointer to save error value
+ *
+ * Return 1 if all extents in range has expected type, and zero otherwise.
+ */
+static int
+mext_check_coverage(struct inode *inode, ext4_lblk_t from, ext4_lblk_t count,
+			  int uninit, int *err)
+{
+	struct ext4_ext_path *path = NULL;
+	struct ext4_extent *ext;
+	ext4_lblk_t last = from + count;
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
@@ -629,9 +666,6 @@ mext_replace_branches(handle_t *handle, struct inode *orig_inode,
 	int replaced_count = 0;
 	int dext_alen;
 
-	/* Protect extent trees against block allocations via delalloc */
-	double_down_write_data_sem(orig_inode, donor_inode);
-
 	/* Get the original extent for the block "orig_off" */
 	*err = get_ext_path(orig_inode, orig_off, &orig_path);
 	if (*err)
@@ -730,8 +764,6 @@ out:
 	ext4_ext_invalidate_cache(orig_inode);
 	ext4_ext_invalidate_cache(donor_inode);
 
-	double_up_write_data_sem(orig_inode, donor_inode);
-
 	return replaced_count;
 }
 
@@ -924,7 +956,46 @@ again:
 				     pagep);
 	if (unlikely(*err < 0))
 		goto stop_journal;
+	/*
+	 * If orig extent was uninitialized it can become initialized at any time
+	 * after i_data_sem was dropped, in order to serialize with delalloc
+	 * we have recheck extent while we hold page's lock, if it is still the
+	 * case data copy is not necessary, just swap data blocks between orig
+	 * and donor.
+	 */
+	if (uninit) {
+		double_down_write_data_sem(orig_inode, donor_inode);
+		/* If any of extents in range became initialized we have to
+		 * fallback to data copying */
+		uninit = mext_check_coverage(orig_inode, orig_blk_offset,
+					     block_len_in_page, 1, err);
+		if (*err)
+			goto drop_data_sem;
 
+		uninit &= mext_check_coverage(donor_inode, orig_blk_offset,
+					      block_len_in_page, 1, err);
+		if (*err)
+			goto drop_data_sem;
+
+		if (!uninit) {
+			double_up_write_data_sem(orig_inode, donor_inode);
+			goto data_copy;
+		}
+		if ((page_has_private(pagep[0]) &&
+		     !try_to_release_page(pagep[0], 0)) ||
+		    (page_has_private(pagep[1]) &&
+		     !try_to_release_page(pagep[1], 0))) {
+			*err = -EBUSY;
+			goto drop_data_sem;
+		}
+		replaced_count = mext_replace_branches(handle, orig_inode,
+						donor_inode, orig_blk_offset,
+						block_len_in_page, err);
+	drop_data_sem:
+		double_up_write_data_sem(orig_inode, donor_inode);
+		goto unlock_pages;
+	}
+data_copy:
 	*err = mext_page_mkuptodate(pagep[0], from, from + replaced_size);
 	if (*err)
 		goto unlock_pages;
-- 
1.7.7.6

