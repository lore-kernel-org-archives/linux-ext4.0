From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 12/21 v5] debugfs: handle inline_data in punch command
Date: Sat, 22 Sep 2012 12:01:00 +0800
Message-ID: <1348286469-31690-13-git-send-email-wenqing.lz@taobao.com>
References: <1348286469-31690-1-git-send-email-wenqing.lz@taobao.com>
Cc: tytso@mit.edu, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34114 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab2IVDvV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Sep 2012 23:51:21 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so3873873pbb.19
        for <linux-ext4@vger.kernel.org>; Fri, 21 Sep 2012 20:51:20 -0700 (PDT)
In-Reply-To: <1348286469-31690-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Now punch command only can truncate an inode with inline_data.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/ext2fs.h      |    2 +
 lib/ext2fs/inline_data.c |   80 ++++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/punch.c       |   10 +++++-
 3 files changed, 91 insertions(+), 1 deletions(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index b451a4a..4e467a0 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1360,6 +1360,8 @@ extern errcode_t ext2fs_try_to_write_inline_data(ext2_filsys fs, ext2_ino_t ino,
 						 unsigned int *written);
 extern errcode_t ext2fs_inline_data_dirsearch(ext2_filsys fs, ext2_ino_t ino,
 					      const char *name, size_t namelen);
+extern errcode_t ext2fs_punch_inline_data(ext2_filsys fs, ext2_ino_t ino,
+					  blk64_t start, blk64_t end);
 
 /* inode.c */
 extern errcode_t ext2fs_flush_icache(ext2_filsys fs);
diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index db33ddd..229e723 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -476,6 +476,86 @@ err:
 	ext2fs_free_mem(&inode);
 	return retval;
 }
+
+errcode_t ext2fs_punch_inline_data(ext2_filsys fs, ext2_ino_t ino,
+				   blk64_t start, blk64_t end)
+{
+	struct ext2_inode_large *inode;
+	struct inline_data data;
+	errcode_t retval = 0;
+	void *value;
+	int inline_size, value_len;
+
+	retval = ext2fs_get_mem(EXT2_INODE_SIZE(fs->super), &inode);
+	if (retval)
+		return retval;
+
+	retval = ext2fs_read_inode_full(fs, ino, (void *)inode,
+					EXT2_INODE_SIZE(fs->super));
+	if (retval)
+		goto out;
+
+	retval = ext2fs_iget_extra_inode(fs, inode, &data);
+	if (retval)
+		goto out;
+	inline_size = data.inline_size;
+
+	if (start > inline_size)
+		goto out;
+
+	if (start < inline_size) {
+		struct ext2_ext_attr_ibody_header *header;
+		struct ext2_ext_attr_search s = {
+			.not_found = -1,
+		};
+		struct ext2_ext_attr_info i = {
+			.name_index = EXT4_EXT_ATTR_INDEX_SYSTEM,
+			.name = EXT4_EXT_ATTR_SYSTEM_DATA,
+		};
+
+		if (!data.inline_off)
+			goto out;
+
+		if (inode->i_extra_isize > (EXT2_INODE_SIZE(fs->super) -
+					    EXT2_GOOD_OLD_INODE_SIZE)) {
+			retval = EXT2_ET_BAD_EXTRA_SIZE;
+			goto out;
+		}
+
+		(void)ext2fs_ibody_find_ext_attr(fs, inode, &i, &s);
+
+		value_len = ext2fs_le32_to_cpu(s.here->e_value_size);
+
+		retval = ext2fs_get_mem(s.here->e_value_size, &value);
+		if (retval)
+			goto out;
+
+		retval = ext2fs_ibody_get_ext_attr(fs, inode, i.name_index,
+						   i.name, value, value_len);
+
+		if (!s.not_found) {
+			i.value = value;
+			i.value_len = start > EXT4_MIN_INLINE_DATA_SIZE ?
+					start - EXT4_MIN_INLINE_DATA_SIZE : 0;
+		}
+		retval = ext2fs_set_entry_ext_attr(&i, &s);
+		if (retval)
+			goto out;
+	}
+
+	if (start < EXT4_MIN_INLINE_DATA_SIZE) {
+		memset((void *)inode->i_block + start, 0,
+			EXT4_MIN_INLINE_DATA_SIZE - start);
+	}
+
+	inode->i_size = start;
+	retval = ext2fs_write_inode_full(fs, ino, (void *)inode,
+					 EXT2_INODE_SIZE(fs->super));
+out:
+	ext2fs_free_mem(&inode);
+	return retval;
+}
+
 errcode_t ext2fs_convert_inline_data(ext2_filsys fs,
 				     ext2_ino_t  ino,
 				     void *priv_data)
diff --git a/lib/ext2fs/punch.c b/lib/ext2fs/punch.c
index b53653a..4b8d51c 100644
--- a/lib/ext2fs/punch.c
+++ b/lib/ext2fs/punch.c
@@ -307,7 +307,15 @@ extern errcode_t ext2fs_punch(ext2_filsys fs, ext2_ino_t ino,
 			return retval;
 		inode = &inode_buf;
 	}
-	if (inode->i_flags & EXT4_EXTENTS_FL)
+	if (inode->i_flags & EXT4_INLINE_DATA_FL) {
+		/* punching hole for inline_data is not supported */
+		if (end != ~0)
+			retval = EXT2_ET_OP_NOT_SUPPORTED;
+		else
+			retval = ext2fs_punch_inline_data(fs, ino, start, end);
+
+		return retval;
+	} else if (inode->i_flags & EXT4_EXTENTS_FL)
 		retval = ext2fs_punch_extent(fs, ino, inode, start, end);
 	else {
 		blk_t	count;
-- 
1.7.4.1

