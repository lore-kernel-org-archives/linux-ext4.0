From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v1 12/22] debugfs: handle inline_data in punch command
Date: Fri,  2 Aug 2013 17:49:39 +0800
Message-ID: <1375436989-18948-13-git-send-email-wenqing.lz@taobao.com>
References: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:56003 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758281Ab3HBJvA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Aug 2013 05:51:00 -0400
Received: by mail-pb0-f49.google.com with SMTP id xb4so499306pbc.8
        for <linux-ext4@vger.kernel.org>; Fri, 02 Aug 2013 02:51:00 -0700 (PDT)
In-Reply-To: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Now punch command only can truncate an inode with inline_data.  The
start block must be 0 because the size of an inode shouldn't be greater
than one block.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/ext2fsP.h     |    3 +++
 lib/ext2fs/inline_data.c |    9 +++----
 lib/ext2fs/punch.c       |   59 ++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 63 insertions(+), 8 deletions(-)

diff --git a/lib/ext2fs/ext2fsP.h b/lib/ext2fs/ext2fsP.h
index ed89272..1e5aa32 100644
--- a/lib/ext2fs/ext2fsP.h
+++ b/lib/ext2fs/ext2fsP.h
@@ -110,6 +110,9 @@ extern errcode_t ext2fs_inline_data_find(ext2_filsys fs,
 					 struct inline_data *data);
 extern errcode_t ext2fs_inline_data_convert(ext2_filsys fs, ext2_ino_t ino,
 					    void *priv_data);
+extern errcode_t ext2fs_inline_data_destory_data(ext2_filsys fs, ext2_ino_t ino,
+					   struct ext2_inode_large *inode,
+					   struct inline_data *data);
 
 /* Generic numeric progress meter */
 
diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index 5ca95ee..52ac133 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -28,9 +28,6 @@ static void ext2fs_inline_data_finish_convert(ext2_filsys fs, ext2_ino_t ino,
 					      int inline_size);
 static void ext2fs_update_final_de(ext2_filsys fs, char *de_buf,
 				   int old_size, int new_size);
-static errcode_t ext2fs_inline_data_destory_data(ext2_filsys fs, ext2_ino_t ino,
-					   struct ext2_inode_large *inode,
-					   struct inline_data *data);
 
 errcode_t ext2fs_inline_data_find(ext2_filsys fs,
 				  struct ext2_inode_large *inode,
@@ -78,9 +75,9 @@ static void *ext2fs_get_inline_xattr_pos(struct ext2_inode_large *inode,
 	return (void *) (IFIRST(header) + entry->e_value_offs);
 }
 
-static errcode_t ext2fs_inline_data_destory_data(ext2_filsys fs, ext2_ino_t ino,
-						 struct ext2_inode_large *inode,
-						 struct inline_data *data)
+errcode_t ext2fs_inline_data_destory_data(ext2_filsys fs, ext2_ino_t ino,
+					  struct ext2_inode_large *inode,
+					  struct inline_data *data)
 {
 	struct ext2_ext_attr_ibody_header *header;
 	struct ext2_ext_attr_search s = {
diff --git a/lib/ext2fs/punch.c b/lib/ext2fs/punch.c
index b53653a..3bfbd4d 100644
--- a/lib/ext2fs/punch.c
+++ b/lib/ext2fs/punch.c
@@ -19,6 +19,7 @@
 
 #include "ext2_fs.h"
 #include "ext2fs.h"
+#include "ext2fsP.h"
 
 #undef PUNCH_DEBUG
 
@@ -281,7 +282,59 @@ errout:
 	ext2fs_extent_free(handle);
 	return retval;
 }
-	
+
+static errcode_t ext2fs_punch_inline_data(ext2_filsys fs, ext2_ino_t ino,
+					  blk64_t start, blk64_t end)
+{
+	struct ext2_inode_large *inode;
+	struct inline_data data;
+	errcode_t retval;
+
+	/*
+	 * 'start' must be 0 because here it's a block and the size of
+	 * an inode shouldn't greater than a block.
+	 */
+	if (start != 0)
+		return 0;
+
+	/* Punching hole for inline_data is not supported */
+	if ((unsigned int)end != ~0U)
+		return EXT2_ET_OP_NOT_SUPPORTED;
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
+	retval = ext2fs_inline_data_find(fs, inode, &data);
+	if (retval)
+		goto out;
+
+	if (!data.inline_off)
+		goto out;
+
+	if (inode->i_extra_isize > (EXT2_INODE_SIZE(fs->super) -
+				    EXT2_GOOD_OLD_INODE_SIZE)) {
+		retval = EXT2_ET_BAD_EXTRA_SIZE;
+		goto out;
+	}
+
+	retval = ext2fs_inline_data_destory_data(fs, ino, inode, &data);
+	if (retval)
+		goto out;
+
+	inode->i_size = 0;
+	retval = ext2fs_write_inode_full(fs, ino, (void *)inode,
+					 EXT2_INODE_SIZE(fs->super));
+out:
+	ext2fs_free_mem(&inode);
+	return retval;
+}
+
 /*
  * Deallocate all logical blocks starting at start to end, inclusive.
  * If end is ~0, then this is effectively truncate.
@@ -307,7 +360,9 @@ extern errcode_t ext2fs_punch(ext2_filsys fs, ext2_ino_t ino,
 			return retval;
 		inode = &inode_buf;
 	}
-	if (inode->i_flags & EXT4_EXTENTS_FL)
+	if (inode->i_flags & EXT4_INLINE_DATA_FL)
+		return ext2fs_punch_inline_data(fs, ino, start, end);
+	else if (inode->i_flags & EXT4_EXTENTS_FL)
 		retval = ext2fs_punch_extent(fs, ino, inode, start, end);
 	else {
 		blk_t	count;
-- 
1.7.9.7

