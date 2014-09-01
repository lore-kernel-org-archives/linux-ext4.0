From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 08/10] ext4: reuse path object in ext4_ext_shift_extents()
Date: Mon,  1 Sep 2014 00:06:49 -0400
Message-ID: <1409544411-31544-9-git-send-email-tytso@mit.edu>
References: <1409544411-31544-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58464 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbaIAEG4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Sep 2014 00:06:56 -0400
In-Reply-To: <1409544411-31544-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Now that the semantics of ext4_ext_find_extent() are much cleaner,
it's safe and more efficient to reuse the path object across the
multiple calls to ext4_ext_find_extent() in ext4_ext_shift_extents().

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/extents.c | 25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index fd840e9..bfae63b 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5305,26 +5305,21 @@ ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
 
 	depth = path->p_depth;
 	extent = path[depth].p_ext;
-	if (!extent) {
-		ext4_ext_drop_refs(path);
-		kfree(path);
-		return ret;
-	}
+	if (!extent)
+		goto out;
 
 	stop_block = le32_to_cpu(extent->ee_block) +
 			ext4_ext_get_actual_len(extent);
-	ext4_ext_drop_refs(path);
-	kfree(path);
 
 	/* Nothing to shift, if hole is at the end of file */
 	if (start >= stop_block)
-		return ret;
+		goto out;
 
 	/*
 	 * Don't start shifting extents until we make sure the hole is big
 	 * enough to accomodate the shift.
 	 */
-	path = ext4_ext_find_extent(inode, start - 1, NULL, 0);
+	path = ext4_ext_find_extent(inode, start - 1, &path, 0);
 	if (IS_ERR(path))
 		return PTR_ERR(path);
 	depth = path->p_depth;
@@ -5337,8 +5332,6 @@ ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
 		ex_start = 0;
 		ex_end = 0;
 	}
-	ext4_ext_drop_refs(path);
-	kfree(path);
 
 	if ((start == ex_start && shift > ex_start) ||
 	    (shift > start - ex_end))
@@ -5346,7 +5339,7 @@ ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
 
 	/* Its safe to start updating extents */
 	while (start < stop_block) {
-		path = ext4_ext_find_extent(inode, start, NULL, 0);
+		path = ext4_ext_find_extent(inode, start, &path, 0);
 		if (IS_ERR(path))
 			return PTR_ERR(path);
 		depth = path->p_depth;
@@ -5362,19 +5355,17 @@ ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
 				path[depth].p_ext++;
 			} else {
 				start = ext4_ext_next_allocated_block(path);
-				ext4_ext_drop_refs(path);
-				kfree(path);
 				continue;
 			}
 		}
 		ret = ext4_ext_shift_path_extents(path, shift, inode,
 				handle, &start);
-		ext4_ext_drop_refs(path);
-		kfree(path);
 		if (ret)
 			break;
 	}
