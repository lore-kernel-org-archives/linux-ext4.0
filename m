From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 8/9 v2 bigalloc] ext4: align fallocate size to a whole cluster
Date: Fri, 18 Nov 2011 18:43:03 +0800
Message-ID: <1321612984-10228-9-git-send-email-hao.bigrat@gmail.com>
References: <1321612984-10228-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62580 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab1KRKnc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Nov 2011 05:43:32 -0500
Received: by mail-iy0-f174.google.com with SMTP id e36so3428378iag.19
        for <linux-ext4@vger.kernel.org>; Fri, 18 Nov 2011 02:43:32 -0800 (PST)
In-Reply-To: <1321612984-10228-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ext4/extents.c |   34 ++++++++++++++++++++++++++++++++--
 1 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 7799973..c7dc340 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3533,8 +3533,11 @@ ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *inode,
 			struct ext4_ext_path *path, int flags,
 			unsigned int allocated, ext4_fsblk_t newblock)
 {
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	struct ext4_map_blocks convert_map;
 	int ret = 0;
 	int err = 0;
+	int offset;
 	ext4_io_end_t *io = EXT4_I(inode)->cur_aio_dio;
 
 	ext_debug("ext4_ext_handle_uninitialized_extents: inode %lu, logical"
@@ -3598,8 +3601,14 @@ ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *inode,
 	}
 
 	/* buffered write, writepage time, convert*/
-	ret = ext4_ext_convert_to_initialized(handle, inode, map, path);
+	offset = map->m_lblk & (sbi->s_cluster_ratio - 1);
+	convert_map.m_len =
+		EXT4_C2B(sbi, EXT4_NUM_B2C(sbi, offset + map->m_len));
+	convert_map.m_lblk = map->m_lblk - offset;
+	ret = ext4_ext_convert_to_initialized(handle, inode,
+			&convert_map, path);
 	if (ret >= 0) {
+		ret = map->m_len;
 		ext4_update_inode_fsync_trans(handle, inode, 1);
 		err = check_eofblocks_fl(handle, inode, map->m_lblk, path,
 					 map->m_len);
@@ -4318,8 +4327,9 @@ static void ext4_falloc_update_inode(struct inode *inode,
 long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	handle_t *handle;
-	loff_t new_size;
+	loff_t new_size, old_size;
 	unsigned int max_blocks;
 	int ret = 0;
 	int ret2 = 0;
@@ -4349,6 +4359,8 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	 */
 	max_blocks = (EXT4_BLOCK_ALIGN(len + offset, blkbits) >> blkbits)
 		- map.m_lblk;
+
+	old_size = i_size_read(inode);
 	/*
 	 * credits to insert 1 extent into extent tree
 	 */
@@ -4403,6 +4415,24 @@ retry:
 		goto retry;
 	}
 	mutex_unlock(&inode->i_mutex);
+
+	/* if the fallocate expand the file size, we need to zeroout
+	 * extra pages in cluster */
+	if (len + offset > old_size) {
+		credits = ext4_chunk_trans_blocks(inode, sbi->s_cluster_ratio);
+		handle = ext4_journal_start(inode, credits);
+		if (IS_ERR(handle)) {
+			ret = PTR_ERR(handle);
+			goto out;
+		}
+		ext4_ext_truncate_zero_pages(handle, inode, old_size);
+		if (IS_SYNC(inode))
+			ext4_handle_sync(handle);
+		ext4_mark_inode_dirty(handle, inode);
+		ext4_journal_stop(handle);
+	}
+
+out:
 	trace_ext4_fallocate_exit(inode, offset, max_blocks,
 				ret > 0 ? ret2 : ret);
 	return ret > 0 ? ret2 : ret;
-- 
1.7.3.2

