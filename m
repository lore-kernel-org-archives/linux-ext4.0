From: Tao Ma <tm@tao.ma>
Subject: [PATCH V4 21/22] ext4: let ext4_truncate handle inline data correctly.
Date: Mon, 20 Feb 2012 15:01:55 +0800
Message-ID: <1329721316-4955-21-git-send-email-tm@tao.ma>
References: <4F41EF95.2000909@tao.ma>
 <1329721316-4955-1-git-send-email-tm@tao.ma>
Cc: linux-fsdevel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy9.bluehost.com ([69.89.24.6]:57084 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751710Ab2BTHI7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Feb 2012 02:08:59 -0500
In-Reply-To: <1329721316-4955-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

Signed-off-by: Robin Dong <sanbai@taobao.com>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/inline.c |   74 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/inode.c  |    5 +++
 fs/ext4/xattr.h  |    8 ++++++
 3 files changed, 87 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index b8576be..0d32a39 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1651,3 +1651,77 @@ out:
 	brelse(iloc.bh);
 	return error;
 }
+
+void ext4_inline_data_truncate(struct inode *inode)
+{
+	handle_t *handle;
+	int inline_size = ext4_get_inline_size(inode);
+	size_t isize = i_size_read(inode);
+	int needed_blocks, value_len;
+	void *value = NULL;
+	struct ext4_xattr_ibody_find is = {
+		.s = { .not_found = -ENODATA, },
+	};
+	struct ext4_xattr_info i = {
+		.name_index = EXT4_XATTR_INDEX_SYSTEM_DATA,
+		.name = EXT4_XATTR_SYSTEM_DATA_NAME,
+	};
+
+	needed_blocks = ext4_writepage_trans_blocks(inode);
+	handle = ext4_journal_start(inode, needed_blocks);
+	if (IS_ERR(handle))
+		return;
+
+	if (ext4_orphan_add(handle, inode))
+		goto out;
+
+	EXT4_I(inode)->i_disksize = inode->i_size;
+
+	if (isize < ext4_get_max_inline_size(inode)) {
+		if (ext4_get_inode_loc(inode, &is.iloc))
+			goto out;
+
+		if (isize < EXT4_MIN_INLINE_DATA_SIZE)
+			memset(ext4_raw_inode(&is.iloc)->i_block + isize, 0,
+					EXT4_MIN_INLINE_DATA_SIZE - isize);
+		if (inline_size > EXT4_MIN_INLINE_DATA_SIZE &&
+				isize < inline_size) {
+			if (ext4_xattr_ibody_find(inode, &i, &is))
+				goto out_bh;
+
+			BUG_ON(!is.s.not_found);
+
+			value_len = le32_to_cpu(is.s.here->e_value_size);
+			value = kmalloc(value_len, GFP_NOFS);
+
+			if (ext4_xattr_ibody_get(inode, i.name_index, i.name,
+						value, value_len))
+				goto out_bh;
+
+			i.value = value;
+			i.value_len = isize - EXT4_MIN_INLINE_DATA_SIZE;
+			if (ext4_xattr_ibody_inline_set(handle, inode, &i, &is))
+				goto out_bh;
+		}
+		if (isize < inline_size)
+			EXT4_I(inode)->i_inline_size = isize <
+				EXT4_MIN_INLINE_DATA_SIZE ?
+				EXT4_MIN_INLINE_DATA_SIZE : isize;
+out_bh:
+		if (value)
+			kfree(value);
+		brelse(is.iloc.bh);
+	} else
+		ext4_convert_inline_data_to_extent(inode->i_mapping, inode, 0);
+
+out:
+	if (inode->i_nlink)
+		ext4_orphan_del(handle, inode);
+
+	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
+	ext4_mark_inode_dirty(handle, inode);
+	if (IS_SYNC(inode))
+		ext4_handle_sync(handle);
+
+	ext4_journal_stop(handle);
+}
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 549af8f..805709b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3496,6 +3496,11 @@ void ext4_truncate(struct inode *inode)
 	if (inode->i_size == 0 && !test_opt(inode->i_sb, NO_AUTO_DA_ALLOC))
 		ext4_set_inode_state(inode, EXT4_STATE_DA_ALLOC_CLOSE);
 
+	if (ext4_has_inline_data(inode)) {
+		ext4_inline_data_truncate(inode);
+		return;
+	}
+
 	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
 		ext4_ext_truncate(inode);
 	else
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index d74df33..4f12d02 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -187,6 +187,8 @@ extern int ext4_inline_data_fiemap(struct inode *inode,
 extern int ext4_try_to_evict_inline_data(handle_t *handle,
 					 struct inode *inode,
 					 int needed);
+extern void ext4_inline_data_truncate(struct inode *inode);
+
 # else  /* CONFIG_EXT4_FS_XATTR */
 
 static inline int
@@ -404,6 +406,12 @@ static inline int ext4_inline_data_fiemap(struct inode *inode,
 {
 	return 0;
 }
+
+static inline void ext4_inline_data_truncate(struct inode *inode)
+{
+	return;
+}
+
 # endif  /* CONFIG_EXT4_FS_XATTR */
 
 #ifdef CONFIG_EXT4_FS_SECURITY
-- 
1.7.0.4

