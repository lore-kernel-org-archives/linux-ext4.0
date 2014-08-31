From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: refactor ext4_move_extents code base v5
Date: Sun, 31 Aug 2014 15:48:30 -0400
Message-ID: <20140831194830.GH8974@thunk.org>
References: <1408195026-2313-1-git-send-email-dmonakhov@openvz.org>
 <1408195026-2313-2-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, lczerner@redhat.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58119 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbaHaTsg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 31 Aug 2014 15:48:36 -0400
Content-Disposition: inline
In-Reply-To: <1408195026-2313-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 16, 2014 at 05:17:06PM +0400, Dmitry Monakhov wrote:
> ext4_move_extents is too complex for review. It has duplicate almost each function
> available in the rest of other codebase. It has useless artificial restriction
> orig_offset == donor_offset. But in fact logic of ext4_move_extents
> is very simple:
> 
> Iterate extents one by one (similar to ext4_fill_fiemap_extents)
>    ->Iterate each page covered extent (similar to generic_perform_write)
>      ->swap extents for covered by page (can be shared with IOC_MOVE_DATA)

Applied, thanks.  I applied a clean up patch to fix up some issues I
found, the most significant was that if ext4_ext_find_extent() return
an error, it could potentially cause a kernel OOPS.

	 	  	     			- Ted

>From 06d9961c15245961c90eab3e5f08307866a4b1d8 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Sun, 31 Aug 2014 15:03:14 -0400
Subject: [PATCH] ext4: fix ext4_swap_extents() error handling

If ext4_ext_find_extent() returns an error, we have to clear path1 or
path2 or else we would end up trying to free an ERR_PTR, which would
be bad.

Also eliminate some redundant code and mark the error paths as unlikely()

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/extents.c | 62 ++++++++++++++++++++++++++-----------------------------
 1 file changed, 29 insertions(+), 33 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 8555940..bc3b49f 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -862,7 +862,7 @@ ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
 	if (!path) {
 		path = kzalloc(sizeof(struct ext4_ext_path) * (depth + 2),
 				GFP_NOFS);
-		if (!path)
+		if (unlikely(!path))
 			return ERR_PTR(-ENOMEM);
 		alloc = 1;
 	}
@@ -882,7 +882,7 @@ ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
 
 		bh = read_extent_tree_block(inode, path[ppos].p_block, --i,
 					    flags);
-		if (IS_ERR(bh)) {
+		if (unlikely(IS_ERR(bh))) {
 			ret = PTR_ERR(bh);
 			goto err;
 		}
@@ -5551,10 +5551,10 @@ ext4_swap_extents(handle_t *handle, struct inode *inode1,
 	BUG_ON(!mutex_is_locked(&inode1->i_mutex));
 
 	*erp = ext4_es_remove_extent(inode1, lblk1, count);
-	if (*erp)
+	if (unlikely(*erp))
 		return 0;
 	*erp = ext4_es_remove_extent(inode2, lblk2, count);
-	if (*erp)
+	if (unlikely(*erp))
 		return 0;
 
 	while (count) {
@@ -5564,20 +5564,24 @@ ext4_swap_extents(handle_t *handle, struct inode *inode1,
 		int split = 0;
 
 		path1 = ext4_ext_find_extent(inode1, lblk1, NULL, EXT4_EX_NOCACHE);
-		if (IS_ERR(path1)) {
+		if (unlikely(IS_ERR(path1))) {
 			*erp = PTR_ERR(path1);
-			break;
+			path1 = NULL;
+		finish:
+			count = 0;
+			goto repeat;
 		}
 		path2 = ext4_ext_find_extent(inode2, lblk2, NULL, EXT4_EX_NOCACHE);
-		if (IS_ERR(path2)) {
+		if (unlikely(IS_ERR(path2))) {
 			*erp = PTR_ERR(path2);
-			break;
+			path2 = NULL;
+			goto finish;
 		}
 		ex1 = path1[path1->p_depth].p_ext;
 		ex2 = path2[path2->p_depth].p_ext;
 		/* Do we have somthing to swap ? */
 		if (unlikely(!ex2 || !ex1))
-			break;
+			goto finish;
 
 		e1_blk = le32_to_cpu(ex1->ee_block);
 		e2_blk = le32_to_cpu(ex2->ee_block);
@@ -5599,7 +5603,7 @@ ext4_swap_extents(handle_t *handle, struct inode *inode1,
 				next2 = e1_blk;
 			/* Do we have something to swap */
 			if (next1 == EXT_MAX_BLOCKS || next2 == EXT_MAX_BLOCKS)
-				break;
+				goto finish;
 			/* Move to the rightest boundary */
 			len = next1 - lblk1;
 			if (len < next2 - lblk2)
@@ -5617,15 +5621,15 @@ ext4_swap_extents(handle_t *handle, struct inode *inode1,
 			split = 1;
 			*erp = ext4_force_split_extent_at(handle, inode1,
 						path1, lblk1, 0);
-			if (*erp)
-				break;
+			if (unlikely(*erp))
+				goto finish;
 		}
 		if (e2_blk < lblk2) {
 			split = 1;
 			*erp = ext4_force_split_extent_at(handle, inode2,
 						path2,  lblk2, 0);
-			if (*erp)
-				break;
+			if (unlikely(*erp))
+				goto finish;
 		}
 		/* ext4_split_extent_at() may retult in leaf extent split,
 		 * path must to be revalidated. */
@@ -5643,15 +5647,15 @@ ext4_swap_extents(handle_t *handle, struct inode *inode1,
 			split = 1;
 			*erp = ext4_force_split_extent_at(handle, inode1,
 						path1, lblk1 + len, 0);
-			if (*erp)
-				break;
+			if (unlikely(*erp))
+				goto finish;
 		}
 		if (len != e2_len) {
 			split = 1;
 			*erp = ext4_force_split_extent_at(handle, inode2,
 						path2, lblk2 + len, 0);
 			if (*erp)
-				break;
+				goto finish;
 		}
 		/* ext4_split_extent_at() may retult in leaf extent split,
 		 * path must to be revalidated. */
@@ -5660,11 +5664,11 @@ ext4_swap_extents(handle_t *handle, struct inode *inode1,
 
 		BUG_ON(e2_len != e1_len);
 		*erp = ext4_ext_get_access(handle, inode1, path1 + path1->p_depth);
-		if (*erp)
-			break;
+		if (unlikely(*erp))
+			goto finish;
 		*erp = ext4_ext_get_access(handle, inode2, path2 + path2->p_depth);
-		if (*erp)
-			break;
+		if (unlikely(*erp))
+			goto finish;
 
 		/* Both extents are fully inside boundaries. Swap it now */
 		tmp_ex = *ex1;
@@ -5681,8 +5685,8 @@ ext4_swap_extents(handle_t *handle, struct inode *inode1,
 		ext4_ext_try_to_merge(handle, inode1, path1, ex1);
 		*erp = ext4_ext_dirty(handle, inode2, path2 +
 				      path2->p_depth);
-		if (*erp)
-			break;
+		if (unlikely(*erp))
+			goto finish;
 		*erp = ext4_ext_dirty(handle, inode1, path1 +
 				      path1->p_depth);
 		/*
@@ -5691,8 +5695,8 @@ ext4_swap_extents(handle_t *handle, struct inode *inode1,
 		 * only due to journal error, so full transaction will be
 		 * aborted anyway.
 		 */
-		if (*erp)
-			break;
+		if (unlikely(*erp))
+			goto finish;
 		lblk1 += len;
 		lblk2 += len;
 		replaced_count += len;
@@ -5710,13 +5714,5 @@ ext4_swap_extents(handle_t *handle, struct inode *inode1,
 			path2 = NULL;
 		}
 	}
-	if (path1) {
-		ext4_ext_drop_refs(path1);
-		kfree(path1);
-	}
-	if (path2) {
-		ext4_ext_drop_refs(path2);
-		kfree(path2);
-	}
 	return replaced_count;
 }
-- 
2.1.0

