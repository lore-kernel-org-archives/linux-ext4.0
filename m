From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH v2 1/3] ext4:Add a function merging extent right and left.
Date: Mon,  2 May 2011 19:04:59 -0700
Message-ID: <1304388301-9452-2-git-send-email-xiaoqiangnk@gmail.com>
References: <1304388301-9452-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: tytso@mit.edu, achender@linux.vnet.ibm.com, cmm@us.ibm.com,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f170.google.com ([209.85.212.170]:55352 "EHLO
	mail-px0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab1ECCI6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 May 2011 22:08:58 -0400
Received: by mail-px0-f170.google.com with SMTP id 19so2589779pxi.1
        for <linux-ext4@vger.kernel.org>; Mon, 02 May 2011 19:08:57 -0700 (PDT)
In-Reply-To: <1304388301-9452-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

1] Rename ext4_ext_try_to_merge() to ext4_ext_try_to_merge_right().

2] Add a new function ext4_ext_try_to_merge() which tries to merge
   an extent both left and right.

3] Use the new function in ext4_ext_convert_unwritten_endio() and
   ext4_ext_insert_extent().

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
Tested-by: Allison Henderson <achender@linux.vnet.ibm.com>
---
 fs/ext4/extents.c |   65 ++++++++++++++++++++++++++++------------------------
 1 files changed, 35 insertions(+), 30 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index dd2cb50..11f30d2 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1563,7 +1563,7 @@ ext4_can_extents_be_merged(struct inode *inode, struct ext4_extent *ex1,
  * Returns 0 if the extents (ex and ex+1) were _not_ merged and returns
  * 1 if they got merged.
  */
-static int ext4_ext_try_to_merge(struct inode *inode,
+static int ext4_ext_try_to_merge_right(struct inode *inode,
 				 struct ext4_ext_path *path,
 				 struct ext4_extent *ex)
 {
@@ -1603,6 +1603,31 @@ static int ext4_ext_try_to_merge(struct inode *inode,
 }
 
 /*
+ * This function tries to merge the @ex extent to neighbours in the tree.
+ * return 1 if merge left else 0.
+ */
+static int ext4_ext_try_to_merge(struct inode *inode,
+				  struct ext4_ext_path *path,
+				  struct ext4_extent *ex) {
+	struct ext4_extent_header *eh;
+	unsigned int depth;
+	int merge_done = 0;
+	int ret = 0;
+
+	depth = ext_depth(inode);
+	BUG_ON(path[depth].p_hdr == NULL);
+	eh = path[depth].p_hdr;
+
+	if (ex > EXT_FIRST_EXTENT(eh))
+		merge_done = ext4_ext_try_to_merge_right(inode, path, ex - 1);
+
+	if (!merge_done)
+		ret = ext4_ext_try_to_merge_right(inode, path, ex);
+
+	return ret;
+}
+
+/*
  * check if a portion of the "newext" extent overlaps with an
  * existing extent.
  *
@@ -3039,6 +3064,7 @@ fix_extent_len:
 	ext4_ext_dirty(handle, inode, path + depth);
 	return err;
 }
+
 static int ext4_convert_unwritten_extents_endio(handle_t *handle,
 					      struct inode *inode,
 					      struct ext4_ext_path *path)
@@ -3047,46 +3073,25 @@ static int ext4_convert_unwritten_extents_endio(handle_t *handle,
 	struct ext4_extent_header *eh;
 	int depth;
 	int err = 0;
-	int ret = 0;
 
 	depth = ext_depth(inode);
 	eh = path[depth].p_hdr;
 	ex = path[depth].p_ext;
 
+	ext_debug("ext4_convert_unwritten_extents_endio: inode %lu, logical"
+		"block %llu, max_blocks %u\n", inode->i_ino,
+		(unsigned long long)le32_to_cpu(ex->ee_block),
+		ext4_ext_get_actual_len(ex));
+
 	err = ext4_ext_get_access(handle, inode, path + depth);
 	if (err)
 		goto out;
 	/* first mark the extent as initialized */
 	ext4_ext_mark_initialized(ex);
 
-	/*
-	 * We have to see if it can be merged with the extent
-	 * on the left.
-	 */
-	if (ex > EXT_FIRST_EXTENT(eh)) {
-		/*
-		 * To merge left, pass "ex - 1" to try_to_merge(),
-		 * since it merges towards right _only_.
-		 */
-		ret = ext4_ext_try_to_merge(inode, path, ex - 1);
-		if (ret) {
-			err = ext4_ext_correct_indexes(handle, inode, path);
-			if (err)
-				goto out;
-			depth = ext_depth(inode);
-			ex--;
-		}
-	}
-	/*
-	 * Try to Merge towards right.
-	 */
-	ret = ext4_ext_try_to_merge(inode, path, ex);
-	if (ret) {
-		err = ext4_ext_correct_indexes(handle, inode, path);
-		if (err)
-			goto out;
-		depth = ext_depth(inode);
-	}
+	/* correct indexes is nt needed becasue borders are not changed */
+	ext4_ext_try_to_merge(inode, path, ex);
+
 	/* Mark modified extent as dirty */
 	err = ext4_ext_dirty(handle, inode, path + depth);
 out:
-- 
1.7.4.4

