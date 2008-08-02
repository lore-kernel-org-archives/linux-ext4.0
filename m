From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH] ext4: don't assume extents can't cross block groups when truncating
Date: Sat, 02 Aug 2008 01:28:26 -0400
Message-ID: <E1KP9fG-0002Th-1k@closure.thunk.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:47926 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751688AbYHBF21 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Aug 2008 01:28:27 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


With the FLEX_BG layout, there is no reason why extents can't cross
block groups, so make the truncate code reserve enough credits so we
don't BUG if we come across such an extent.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index b050259..4a61ca5 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1916,9 +1916,13 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 			BUG_ON(b != ex_ee_block + ex_ee_len - 1);
 		}
 
-		/* at present, extent can't cross block group: */
-		/* leaf + bitmap + group desc + sb + inode */
-		credits = 5;
+		/*
+		 * 3 for leaf, sb, and inode plus 2 (bmap and group
+		 * descriptor) for each block group; assume two block
+		 * groups plus ex_ee_len/blocks_per_block_group for
+		 * the worst case
+		 */
+		credits = 7 + 2*(ex_ee_len/EXT4_BLOCKS_PER_GROUP(inode->i_sb));
 		if (ex == EXT_FIRST_EXTENT(eh)) {
 			correct_index = 1;
 			credits += (ext_depth(inode)) + 1;
