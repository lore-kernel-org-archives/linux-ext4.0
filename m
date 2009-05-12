From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/6] ext4: Rename ext4_get_blocks_handle() to be ext4_ind_get_blocks()
Date: Tue, 12 May 2009 18:48:48 -0400
Message-ID: <1242168532-1063-3-git-send-email-tytso@mit.edu>
References: <1242168532-1063-1-git-send-email-tytso@mit.edu>
 <1242168532-1063-2-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44288 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbZELWs4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 May 2009 18:48:56 -0400
In-Reply-To: <1242168532-1063-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The static function ext4_get_blocks_handle() is badly named.  Of
*course* it takes a handle.  Since its counterpart for extent-based
file is ext4_ext_get_blocks(), rename it to be ext4_ind_get_blocks().

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 0968e6d..61a9579 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -914,7 +914,7 @@ err_out:
  * down_read(&EXT4_I(inode)->i_data_sem) if not allocating file system block
  * (ie, create is zero). Otherwise down_write(&EXT4_I(inode)->i_data_sem)
  */
-static int ext4_get_blocks_handle(handle_t *handle, struct inode *inode,
+static int ext4_ind_get_blocks(handle_t *handle, struct inode *inode,
 				  ext4_lblk_t iblock, unsigned int maxblocks,
 				  struct buffer_head *bh_result,
 				  int create, int extend_disksize)
@@ -1129,7 +1129,7 @@ static void ext4_da_update_reserve_space(struct inode *inode, int used)
  * mapped.
  *
  * If file type is extents based, it will call ext4_ext_get_blocks(),
- * Otherwise, call with ext4_get_blocks_handle() to handle indirect mapping
+ * Otherwise, call with ext4_ind_get_blocks() to handle indirect mapping
  * based files
  *
  * On success, it returns the number of blocks being mapped or allocate.
@@ -1160,8 +1160,8 @@ int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
 		retval =  ext4_ext_get_blocks(handle, inode, block, max_blocks,
 				bh, 0, 0);
 	} else {
-		retval = ext4_get_blocks_handle(handle,
-				inode, block, max_blocks, bh, 0, 0);
+		retval = ext4_ind_get_blocks(handle, inode, block, max_blocks,
+					     bh, 0, 0);
 	}
 	up_read((&EXT4_I(inode)->i_data_sem));
 
@@ -1209,7 +1209,7 @@ int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
 		retval =  ext4_ext_get_blocks(handle, inode, block, max_blocks,
 				bh, create, extend_disksize);
 	} else {
-		retval = ext4_get_blocks_handle(handle, inode, block,
+		retval = ext4_ind_get_blocks(handle, inode, block,
 				max_blocks, bh, create, extend_disksize);
 
 		if (retval > 0 && buffer_new(bh)) {
@@ -1291,7 +1291,7 @@ struct buffer_head *ext4_getblk(handle_t *handle, struct inode *inode,
 	err = ext4_get_blocks_wrap(handle, inode, block, 1,
 					&dummy, create, 1, 0);
 	/*
-	 * ext4_get_blocks_handle() returns number of blocks
+	 * ext4_get_blocks_wrap() returns number of blocks
 	 * mapped. 0 in case of a HOLE.
 	 */
 	if (err > 0) {
-- 
1.6.3.rc4.1.g3e14.dirty

