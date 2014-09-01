From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 09/10] ext4: reuse path object in ext4_move_extents()
Date: Mon,  1 Sep 2014 00:06:50 -0400
Message-ID: <1409544411-31544-10-git-send-email-tytso@mit.edu>
References: <1409544411-31544-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58462 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbaIAEG4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Sep 2014 00:06:56 -0400
In-Reply-To: <1409544411-31544-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Reuse the path object in ext4_move_extents() so we don't unnecessarily
free and reallocate it.

Also clean up the get_ext_path() wrapper so that it has the same
semantics of freeing the path object on error as ext4_ext_find_extent().

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/move_extent.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index a34c076..7bf970d 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -32,20 +32,21 @@
  */
 static inline int
 get_ext_path(struct inode *inode, ext4_lblk_t lblock,
-		struct ext4_ext_path **orig_path)
+		struct ext4_ext_path **ppath)
 {
-	int ret = 0;
 	struct ext4_ext_path *path;
 
-	path = ext4_ext_find_extent(inode, lblock, orig_path, EXT4_EX_NOCACHE);
+	path = ext4_ext_find_extent(inode, lblock, ppath, EXT4_EX_NOCACHE);
 	if (IS_ERR(path))
-		ret = PTR_ERR(path);
-	else if (path[ext_depth(inode)].p_ext == NULL)
-		ret = -ENODATA;
-	else
-		*orig_path = path;
-
-	return ret;
+		return PTR_ERR(path);
+	if (path[ext_depth(inode)].p_ext == NULL) {
+		ext4_ext_drop_refs(path);
+		kfree(path);
+		*ppath = NULL;
+		return -ENODATA;
+	}
+	*ppath = path;
+	return 0;
 }
 
 /**
@@ -667,7 +668,7 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp, __u64 orig_blk,
 			}
 			d_start += next_blk - o_start;
 			o_start = next_blk;
-			goto repeat;
+			continue;
 		/* Check hole after the start pos */
 		} else if (cur_blk > o_start) {
 			/* Skip hole */
@@ -708,10 +709,6 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp, __u64 orig_blk,
 			break;
 		o_start += cur_len;
 		d_start += cur_len;
-	repeat:
-		ext4_ext_drop_refs(path);
-		kfree(path);
-		path = NULL;
 	}
 	*moved_len = o_start - orig_blk;
 	if (*moved_len > len)
-- 
2.1.0

