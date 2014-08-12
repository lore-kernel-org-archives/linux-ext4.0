From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/2] Use ext4_ext_next_allocated_block instead of mext_next_extent
Date: Tue, 12 Aug 2014 18:48:24 +0400
Message-ID: <1407854905-4611-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:45898 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216AbaHLOsn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Aug 2014 10:48:43 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This allow to make mext_next_extent static.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/ext4.h        |    2 --
 fs/ext4/extents.c     |   18 ++++++------------
 fs/ext4/move_extent.c |    2 +-
 3 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 5b19760..f8d85f7 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2739,8 +2739,6 @@ extern void ext4_double_up_write_data_sem(struct inode *orig_inode,
 extern int ext4_move_extents(struct file *o_filp, struct file *d_filp,
 			     __u64 start_orig, __u64 start_donor,
 			     __u64 len, __u64 *moved_len);
-extern int mext_next_extent(struct inode *inode, struct ext4_ext_path *path,
-			    struct ext4_extent **extent);
 
 /* page-io.c */
 extern int __init ext4_init_pageio(void);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 76c2df3..2e38ecb 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5304,7 +5304,7 @@ ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
 	struct ext4_ext_path *path;
 	int ret = 0, depth;
 	struct ext4_extent *extent;
-	ext4_lblk_t stop_block, current_block;
+	ext4_lblk_t stop_block;
 	ext4_lblk_t ex_start, ex_end;
 
 	/* Let path point to the last extent */
@@ -5365,18 +5365,12 @@ ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
 					 (unsigned long) start);
 			return -EIO;
 		}
-
-		current_block = le32_to_cpu(extent->ee_block);
-		if (start > current_block) {
+		if (start > le32_to_cpu(extent->ee_block)) {
 			/* Hole, move to the next extent */
-			ret = mext_next_extent(inode, path, &extent);
-			if (ret != 0) {
-				ext4_ext_drop_refs(path);
-				kfree(path);
-				if (ret == 1)
-					ret = 0;
-				break;
-			}
+			start = ext4_ext_next_allocated_block(path);
+			ext4_ext_drop_refs(path);
+			kfree(path);
+			continue;
 		}
 		ret = ext4_ext_shift_path_extents(path, shift, inode,
 				handle, &start);
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 671a74b..123a51b 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -76,7 +76,7 @@ copy_extent_status(struct ext4_extent *src, struct ext4_extent *dest)
  * ext4_ext_path structure refers to the last extent, or a negative error
  * value on failure.
  */
-int
+static int
 mext_next_extent(struct inode *inode, struct ext4_ext_path *path,
 		      struct ext4_extent **extent)
 {
-- 
1.7.1

