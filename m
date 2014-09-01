From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 03/10] ext4: drop EXT4_EX_NOFREE_ON_ERR in convert_initialized_extent()
Date: Mon,  1 Sep 2014 00:06:44 -0400
Message-ID: <1409544411-31544-4-git-send-email-tytso@mit.edu>
References: <1409544411-31544-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58454 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbaIAEG4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Sep 2014 00:06:56 -0400
In-Reply-To: <1409544411-31544-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Transfer responsibility of freeing struct ext4_ext_path on error to
ext4_ext_find_extent().

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/extents.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 985848d..ceab095 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3921,9 +3921,10 @@ get_reserved_cluster_alloc(struct inode *inode, ext4_lblk_t lblk_start,
 static int
 convert_initialized_extent(handle_t *handle, struct inode *inode,
 			   struct ext4_map_blocks *map,
-			   struct ext4_ext_path *path, int flags,
+			   struct ext4_ext_path **ppath, int flags,
 			   unsigned int allocated, ext4_fsblk_t newblock)
 {
+	struct ext4_ext_path *path = *ppath;
 	struct ext4_extent *ex;
 	ext4_lblk_t ee_block;
 	unsigned int ee_len;
@@ -3952,8 +3953,7 @@ convert_initialized_extent(handle_t *handle, struct inode *inode,
 		if (err < 0)
 			return err;
 		ext4_ext_drop_refs(path);
-		path = ext4_ext_find_extent(inode, map->m_lblk, &path,
-					    EXT4_EX_NOFREE_ON_ERR);
+		path = ext4_ext_find_extent(inode, map->m_lblk, ppath, 0);
 		if (IS_ERR(path))
 			return PTR_ERR(path);
 		depth = ext_depth(inode);
@@ -4331,8 +4331,8 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 			if ((!ext4_ext_is_unwritten(ex)) &&
 			    (flags & EXT4_GET_BLOCKS_CONVERT_UNWRITTEN)) {
 				allocated = convert_initialized_extent(
-						handle, inode, map, path, flags,
-						allocated, newblock);
+						handle, inode, map, &path,
+						flags, allocated, newblock);
 				goto out2;
 			} else if (!ext4_ext_is_unwritten(ex))
 				goto out;
-- 
2.1.0

