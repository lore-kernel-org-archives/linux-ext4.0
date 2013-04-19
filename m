From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: ext4: mext_insert_extents should update extent block checksum
Date: Thu, 18 Apr 2013 22:50:12 -0700
Message-ID: <20130419055012.GB5617@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <gnehzuil.liu@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44568 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab3DSFuS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Apr 2013 01:50:18 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we alter any part of the extent tree that is not part of the inode during
on online defrag, we must update the extent header's checksum before dirtying
the block.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext4/ext4_extents.h |    5 +++++
 fs/ext4/extents.c      |    7 ++-----
 fs/ext4/move_extent.c  |   13 +------------
 3 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/fs/ext4/ext4_extents.h b/fs/ext4/ext4_extents.h
index 8643ff5..51bc821 100644
--- a/fs/ext4/ext4_extents.h
+++ b/fs/ext4/ext4_extents.h
@@ -270,5 +270,10 @@ static inline void ext4_idx_store_pblock(struct ext4_extent_idx *ix,
 				     0xffff);
 }
 
+#define ext4_ext_dirty(handle, inode, path) \
+		__ext4_ext_dirty(__func__, __LINE__, (handle), (inode), (path))
+int __ext4_ext_dirty(const char *where, unsigned int line, handle_t *handle,
+		     struct inode *inode, struct ext4_ext_path *path);
+
 #endif /* _EXT4_EXTENTS */
 
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 9c6d06d..cd43b4c 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -157,11 +157,8 @@ static int ext4_ext_get_access(handle_t *handle, struct inode *inode,
  *  - ENOMEM
  *  - EIO
  */
-#define ext4_ext_dirty(handle, inode, path) \
-		__ext4_ext_dirty(__func__, __LINE__, (handle), (inode), (path))
-static int __ext4_ext_dirty(const char *where, unsigned int line,
-			    handle_t *handle, struct inode *inode,
-			    struct ext4_ext_path *path)
+int __ext4_ext_dirty(const char *where, unsigned int line, handle_t *handle,
+		     struct inode *inode, struct ext4_ext_path *path)
 {
 	int err;
 	if (path->p_bh) {
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 33e1c08..9a20c91 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -407,18 +407,7 @@ mext_insert_extents(handle_t *handle, struct inode *orig_inode,
 		mext_insert_inside_block(o_start, o_end, start_ext, new_ext,
 						end_ext, eh, range_to_move);
 
-	if (depth) {
-		ret = ext4_handle_dirty_metadata(handle, orig_inode,
-						 orig_path->p_bh);
-		if (ret)
-			return ret;
-	} else {
-		ret = ext4_mark_inode_dirty(handle, orig_inode);
-		if (ret < 0)
-			return ret;
-	}
