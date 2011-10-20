From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 6/6] ext4: update EOFBLOCKS flag on fallocate properly
Date: Fri, 21 Oct 2011 01:08:59 +0400
Message-ID: <1319144939-28801-7-git-send-email-dmonakhov@openvz.org>
References: <1319144939-28801-1-git-send-email-dmonakhov@openvz.org>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org, tytso@mit.edu,
	achender@linux.vnet.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47056 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986Ab1JTVI7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Oct 2011 17:08:59 -0400
Received: by mail-bw0-f46.google.com with SMTP id zt19so4002126bkb.19
        for <linux-ext4@vger.kernel.org>; Thu, 20 Oct 2011 14:08:58 -0700 (PDT)
In-Reply-To: <1319144939-28801-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

EOFBLOCK_FL should be updated if called w/o FALLOCATE_FL_KEEP_SIZE
Currently it happens only if new extent was allocated
TESTCASE:
fallocate test_file -n -l4096
fallocate test_file -l4096
Last fallocate cmd has updated size, but keept EOFBLOCK_FL set. And fsck
will complain about that.

Also remove ping pong in ext4_fallocate() in case of new extents, where
ext4_ext_map_blocks() clear EOFBLOCKS bit, and later
ext4_falloc_update_inode() restore it again.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/ext4.h    |    2 ++
 fs/ext4/extents.c |   34 +++++++++++++++++++---------------
 fs/ext4/inode.c   |    6 ++++--
 3 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 5655582..60c6a76 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -542,6 +542,8 @@ struct ext4_new_group_data {
 #define EXT4_GET_BLOCKS_PUNCH_OUT_EXT		0x0020
 	/* Don't normalize allocation size (used for fallocate) */
 #define EXT4_GET_BLOCKS_NO_NORMALIZE		0x0040
+	/* Request will not result in inode size update (user for fallocate) */
+#define EXT4_GET_BLOCKS_KEEP_SIZE		0x0080
 
 /*
  * Flags used by ext4_free_blocks
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 877e61b..8fab23b 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3647,14 +3647,8 @@ ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *inode,
 
 	/* buffered write, writepage time, convert*/
 	ret = ext4_ext_convert_to_initialized(handle, inode, map, path);
-	if (ret >= 0) {
+	if (ret >= 0)
 		ext4_update_inode_fsync_trans(handle, inode, 1);
-		err = check_eofblocks_fl(handle, inode, map->m_lblk, path,
-					 map->m_len);
-		if (err < 0)
-			goto out2;
-	}
-
 out:
 	if (ret <= 0) {
 		err = ret;
@@ -3695,6 +3689,12 @@ out:
 
 map_out:
 	map->m_flags |= EXT4_MAP_MAPPED;
+	if ((flags & EXT4_GET_BLOCKS_KEEP_SIZE) == 0) {
+		err = check_eofblocks_fl(handle, inode, map->m_lblk, path,
+					 map->m_len);
+		if (err < 0)
+			goto out2;
+	}
 out1:
 	if (allocated > map->m_len)
 		allocated = map->m_len;
@@ -4103,12 +4103,13 @@ got_allocated_blocks:
 				 ext4_ext_get_actual_len(&newex), fb_flags);
 		goto out2;
 	}
-	err = check_eofblocks_fl(handle, inode, map->m_lblk, path, ar.len);
-	if (err) {
-		ext4_discard_preallocations(inode);
-		goto out2;
+	if ((flags & EXT4_GET_BLOCKS_KEEP_SIZE) == 0) {
+		err = check_eofblocks_fl(handle, inode, map->m_lblk, path, ar.len);
+		if (err) {
+			ext4_discard_preallocations(inode);
+			goto out2;
+		}
 	}
-
 	/* previous routine could use block we allocated */
 	newblock = ext4_ext_pblock(&newex);
 	allocated = ext4_ext_get_actual_len(&newex);
@@ -4349,6 +4350,7 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	int ret = 0;
 	int ret2 = 0;
 	int retries = 0;
+	int flags;
 	struct ext4_map_blocks map;
 	unsigned int credits, blkbits = inode->i_blkbits;
 
@@ -4385,6 +4387,10 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 		trace_ext4_fallocate_exit(inode, offset, max_blocks, ret);
 		return ret;
 	}
+	flags = EXT4_GET_BLOCKS_CREATE_UNINIT_EXT |
+		EXT4_GET_BLOCKS_NO_NORMALIZE;
+	if (mode & FALLOC_FL_KEEP_SIZE)
+		flags |= EXT4_GET_BLOCKS_KEEP_SIZE;
 retry:
 	while (ret >= 0 && ret < max_blocks) {
 		map.m_lblk = map.m_lblk + ret;
@@ -4394,9 +4400,7 @@ retry:
 			ret = PTR_ERR(handle);
 			break;
 		}
-		ret = ext4_map_blocks(handle, inode, &map,
-				      EXT4_GET_BLOCKS_CREATE_UNINIT_EXT |
-				      EXT4_GET_BLOCKS_NO_NORMALIZE);
+		ret = ext4_map_blocks(handle, inode, &map, flags);
 		if (ret <= 0) {
 #ifdef EXT4FS_DEBUG
 			WARN_ON(ret <= 0);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1380cd2..8efb3ab 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -477,9 +477,11 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 	 */
 	down_read((&EXT4_I(inode)->i_data_sem));
 	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
-		retval = ext4_ext_map_blocks(handle, inode, map, 0);
+		retval = ext4_ext_map_blocks(handle, inode, map, flags &
+					     EXT4_GET_BLOCKS_KEEP_SIZE);
 	} else {
-		retval = ext4_ind_map_blocks(handle, inode, map, 0);
+		retval = ext4_ind_map_blocks(handle, inode, map, flags &
+					     EXT4_GET_BLOCKS_KEEP_SIZE);
 	}
 	up_read((&EXT4_I(inode)->i_data_sem));
 
-- 
1.7.1

