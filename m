From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH RFC] ext4: collapse a single extent tree block into the inode if possible
Date: Thu,  9 Aug 2012 08:44:43 -0400
Message-ID: <1344516283-4430-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43796 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932076Ab2HIMoq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Aug 2012 08:44:46 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If an inode has more than 4 extents, but then later some of the
extents are merged together, we can optimize the file system by moving
the extents up into the inode, and discarding extent tree block.  This
is important, because if there are a large number of inodes with an
external extent tree blocks where the contents could fit in the inode,
this can significantly increase the fsck time of the file system.

Google-Bug-Id: 6801242

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/extents.c | 76 +++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 62 insertions(+), 14 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index cd0c7ed..544d28c 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1656,16 +1656,64 @@ static int ext4_ext_try_to_merge_right(struct inode *inode,
 }
 
 /*
+ * This function does a very simple check to see if we can collapse
+ * an extent tree with a single extent tree leaf block into the inode.
+ */
+static void ext4_ext_try_to_merge_up(handle_t *handle,
+				     struct inode *inode,
+				     struct ext4_ext_path *path)
+{
+	size_t s;
+	unsigned max_root = ext4_ext_space_root(inode, 0);
+	ext4_fsblk_t blk;
+
+	if ((path[0].p_depth != 1) ||
+	    (le16_to_cpu(path[0].p_hdr->eh_entries) != 1) ||
+	    (le16_to_cpu(path[1].p_hdr->eh_entries) > max_root))
+		return;
+
+	/*
+	 * We need to modify the block allocation bitmap and the block
+	 * group descriptor to release the extent tree block.  If we
+	 * can't get the journal credits, give up.
+	 */
+	if (ext4_journal_extend(handle, 2))
+		return;
+
+	/*
+	 * Copy the extent data up to the inode
+	 */
+	blk = ext4_idx_pblock(path[0].p_idx);
+	s = le16_to_cpu(path[1].p_hdr->eh_entries) *
+		sizeof(struct ext4_extent_idx);
+	s += sizeof(struct ext4_extent_header);
+
+	memcpy(path[0].p_hdr, path[1].p_hdr, s);
+	path[0].p_depth = 0;
+	path[0].p_ext = EXT_FIRST_EXTENT(path[0].p_hdr) +
+		(path[1].p_ext - EXT_FIRST_EXTENT(path[1].p_hdr));
+	path[0].p_hdr->eh_max = cpu_to_le16(max_root);
+
+	brelse(path[1].p_bh);
+	ext4_free_blocks(handle, inode, NULL, blk, 1,
+			 EXT4_FREE_BLOCKS_METADATA | EXT4_FREE_BLOCKS_FORGET);
+	ext4_msg(inode->i_sb, KERN_ERR, "Merge up: ino %lu, blk %llu, "
+		 "extents %u",
+		 inode->i_ino, (unsigned long long) blk,
+		 le16_to_cpu(path[0].p_hdr->eh_entries));
+}
+
+/*
  * This function tries to merge the @ex extent to neighbours in the tree.
  * return 1 if merge left else 0.
  */
-static int ext4_ext_try_to_merge(struct inode *inode,
+static void ext4_ext_try_to_merge(handle_t *handle,
+				  struct inode *inode,
 				  struct ext4_ext_path *path,
 				  struct ext4_extent *ex) {
 	struct ext4_extent_header *eh;
 	unsigned int depth;
 	int merge_done = 0;
-	int ret = 0;
 
 	depth = ext_depth(inode);
 	BUG_ON(path[depth].p_hdr == NULL);
@@ -1675,9 +1723,9 @@ static int ext4_ext_try_to_merge(struct inode *inode,
 		merge_done = ext4_ext_try_to_merge_right(inode, path, ex - 1);
 
 	if (!merge_done)
-		ret = ext4_ext_try_to_merge_right(inode, path, ex);
+		(void) ext4_ext_try_to_merge_right(inode, path, ex);
 
-	return ret;
+	ext4_ext_try_to_merge_up(handle, inode, path);
 }
 
 /*
@@ -1893,7 +1941,7 @@ has_space:
 merge:
 	/* try to merge extents */
 	if (!(flag & EXT4_GET_BLOCKS_PRE_IO))
-		ext4_ext_try_to_merge(inode, path, nearex);
+		ext4_ext_try_to_merge(handle, inode, path, nearex);
 
 
 	/* time to correct all indexes above */
@@ -1901,7 +1949,7 @@ merge:
 	if (err)
 		goto cleanup;
 
-	err = ext4_ext_dirty(handle, inode, path + depth);
+	err = ext4_ext_dirty(handle, inode, path + path->p_depth);
 
 cleanup:
 	if (npath) {
@@ -2923,9 +2971,9 @@ static int ext4_split_extent_at(handle_t *handle,
 			ext4_ext_mark_initialized(ex);
 
 		if (!(flags & EXT4_GET_BLOCKS_PRE_IO))
-			ext4_ext_try_to_merge(inode, path, ex);
+			ext4_ext_try_to_merge(handle, inode, path, ex);
 
-		err = ext4_ext_dirty(handle, inode, path + depth);
+		err = ext4_ext_dirty(handle, inode, path + path->p_depth);
 		goto out;
 	}
 
@@ -2957,8 +3005,8 @@ static int ext4_split_extent_at(handle_t *handle,
 			goto fix_extent_len;
 		/* update the extent length and mark as initialized */
 		ex->ee_len = cpu_to_le16(ee_len);
-		ext4_ext_try_to_merge(inode, path, ex);
-		err = ext4_ext_dirty(handle, inode, path + depth);
+		ext4_ext_try_to_merge(handle, inode, path, ex);
+		err = ext4_ext_dirty(handle, inode, path + path->p_depth);
 		goto out;
 	} else if (err)
 		goto fix_extent_len;
@@ -3190,8 +3238,8 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 		if (err)
 			goto out;
 		ext4_ext_mark_initialized(ex);
-		ext4_ext_try_to_merge(inode, path, ex);
-		err = ext4_ext_dirty(handle, inode, path + depth);
+		ext4_ext_try_to_merge(handle, inode, path, ex);
+		err = ext4_ext_dirty(handle, inode, path + path->p_depth);
 		goto out;
 	}
 
@@ -3332,10 +3380,10 @@ static int ext4_convert_unwritten_extents_endio(handle_t *handle,
 	/* note: ext4_ext_correct_indexes() isn't needed here because
 	 * borders are not changed
 	 */
-	ext4_ext_try_to_merge(inode, path, ex);
+	ext4_ext_try_to_merge(handle, inode, path, ex);
 
 	/* Mark modified extent as dirty */
-	err = ext4_ext_dirty(handle, inode, path + depth);
+	err = ext4_ext_dirty(handle, inode, path + path->p_depth);
 out:
 	ext4_ext_show_leaf(inode, path);
 	return err;
-- 
1.7.12.rc0.22.gcdd159b

