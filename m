From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 7/7] ext4: update EOFBLOCK flags after punch hole
Date: Fri, 28 Oct 2011 21:00:10 +0400
Message-ID: <1319821210-7374-8-git-send-email-dmonakhov@openvz.org>
References: <1319821210-7374-1-git-send-email-dmonakhov@openvz.org>
Cc: achender@linux.vnet.ibm.com, tytso@mit.edu,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64725 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab1J1RA2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Oct 2011 13:00:28 -0400
Received: by mail-bw0-f46.google.com with SMTP id zt4so624053bkb.19
        for <linux-ext4@vger.kernel.org>; Fri, 28 Oct 2011 10:00:28 -0700 (PDT)
In-Reply-To: <1319821210-7374-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Clear EOFBLOCK if punched extent is the only uninitialized extent
beyond eof, unfortunately we can not reuse check_eofblock_fl()
logic here because it purpose to handle file expansion,
but in our case we have to recheck base invariant that:
clear_eof_flag = (eof_block >= last_allocated_block)

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents.c |   53 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index a77cde2..40f1248 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3235,7 +3235,7 @@ ext4_ext_handle_punched_extent(handle_t *handle, struct inode *inode,
 	struct ext4_map_blocks punch_map;
 	ext4_fsblk_t partial_cluster = 0;
 	unsigned int punched_out = 0;
-   	int err;
+   	int err, inode_changed = 0;
 
 	/* Punch out the map length, but only to the end of the extent */
 	punched_out = ee_len - (map->m_lblk - ee_block);
@@ -3286,8 +3286,55 @@ ext4_ext_handle_punched_extent(handle_t *handle, struct inode *inode,
 
 	err = ext4_ext_rm_leaf(handle, inode, path, &partial_cluster,
 			       map->m_lblk, map->m_lblk + punched_out);
-	if (!err && ext4_ext_try_shrink(handle, inode))
-		err = ext4_mark_inode_dirty(handle, inode);
+	if (err)
+		goto out;
+
+	inode_changed = ext4_ext_try_shrink(handle, inode);
+	/*
+	 * We have punched out an extent, if it was the only extent beyond
+	 * i_size  eofblocks flag should be cleared.
+	 */
+	if (ext4_test_inode_flag(inode, EXT4_INODE_EOFBLOCKS)) {
+		ext4_fsblk_t eof_block =
+			(inode->i_size + (1 << inode->i_blkbits) - 1) >>
+				inode->i_blkbits;
+		/* find the latest extent */
+		ext4_ext_drop_refs(path);
+		kfree(path);
+		path = ext4_ext_find_extent(inode, EXT_MAX_BLOCKS -1, NULL);
+		if (IS_ERR(path)) {
+			err = PTR_ERR(path);
+			path = NULL;
+			goto out;
+		}
+		ex = path[path->p_depth].p_ext;
+		if (ex) {
+			ee_len = ext4_ext_get_actual_len(ex);
+			ee_block = le32_to_cpu(ex->ee_block);
+		} else {
+			/* Inode is empty */
+			ee_block = ee_len = 0;
+		}
+		if (eof_block >= ee_block + ee_len) {
+			ext4_clear_inode_flag(inode, EXT4_INODE_EOFBLOCKS);
+			inode_changed = 1;
+		} else if (!ext4_ext_is_uninitialized(ex)) {
+			EXT4_ERROR_INODE(inode, "initialized extent beyond "
+					"EOF i_size: %lld, ex[%u:%u] "
+					"depth: %d pblock %lld",
+					inode->i_size, ee_block, ee_len,
+					path->p_depth,
+					path[path->p_depth].p_block);
+			err = -EIO;
+			/* Continue, because inode shrink should be
+			 * accomplished regardless to staled eof blocks */
+		}
+	}
+	if (inode_changed) {
+		int err2 = ext4_mark_inode_dirty(handle, inode);
+		if (!err)
+			err = err2;
+	}
 out:
 	ext4_update_inode_fsync_trans(handle, inode, 0);
 	if (path) {
-- 
1.7.1

