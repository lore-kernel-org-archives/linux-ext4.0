From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v3 18/30] debugfs: handle inline data feature in punch command
Date: Fri,  6 Dec 2013 17:58:05 +0800
Message-ID: <1386323897-2354-19-git-send-email-wenqing.lz@taobao.com>
References: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:58361 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757598Ab3LFJ4H (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Dec 2013 04:56:07 -0500
Received: by mail-pd0-f175.google.com with SMTP id w10so746139pde.6
        for <linux-ext4@vger.kernel.org>; Fri, 06 Dec 2013 01:56:07 -0800 (PST)
In-Reply-To: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Now punch command only can remove all inline data because now
punch command is based on block unit and the size of inline data is
never beyond a block size.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/ext2fsP.h     |    1 +
 lib/ext2fs/inline_data.c |    2 +-
 lib/ext2fs/punch.c       |   28 +++++++++++++++++++++++++++-
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/ext2fsP.h b/lib/ext2fs/ext2fsP.h
index b2da21a..bfc321c 100644
--- a/lib/ext2fs/ext2fsP.h
+++ b/lib/ext2fs/ext2fsP.h
@@ -91,6 +91,7 @@ extern int ext2fs_process_dir_block(ext2_filsys  	fs,
 extern errcode_t ext2fs_inline_data_init(ext2_filsys fs, ext2_ino_t ino);
 extern errcode_t ext2fs_inline_data_size(ext2_filsys fs, ext2_ino_t ino,
 					 size_t *size);
+extern errcode_t ext2fs_inline_data_ea_remove(ext2_filsys fs, ext2_ino_t ino);
 extern errcode_t ext2fs_inline_data_expand(ext2_filsys fs, ext2_ino_t ino);
 extern errcode_t ext2fs_inline_data_dir_iterate(ext2_filsys fs,
 				      ext2_ino_t ino,
diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index 3144427..a25c5bd 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -238,7 +238,7 @@ out:
 	return retval & BLOCK_ERROR ? ctx->errcode : retval;
 }
 
-static errcode_t ext2fs_inline_data_ea_remove(ext2_filsys fs, ext2_ino_t ino)
+errcode_t ext2fs_inline_data_ea_remove(ext2_filsys fs, ext2_ino_t ino)
 {
 	struct ext2_xattr_handle *handle;
 	errcode_t retval;
diff --git a/lib/ext2fs/punch.c b/lib/ext2fs/punch.c
index 4471f46..d6c9004 100644
--- a/lib/ext2fs/punch.c
+++ b/lib/ext2fs/punch.c
@@ -300,6 +300,30 @@ errout:
 	return retval;
 }
 	
+static errcode_t ext2fs_punch_inline_data(ext2_filsys fs, ext2_ino_t ino,
+					  struct ext2_inode *inode,
+					  blk64_t start, blk64_t end)
+{
+	errcode_t retval;
+
+	/*
+	 * In libext2fs ext2fs_punch is based on block unit.  So that
+	 * means that if start > 0 we don't need to do nothing.  Due
+	 * to this we will remove all inline data in ext2fs_punch()
+	 * now.
+	 */
+	if (start > 0)
+		return 0;
+
+	memset((char *)inode->i_block, 0, EXT4_MIN_INLINE_DATA_SIZE);
+	inode->i_size = 0;
+	retval = ext2fs_write_inode(fs, ino, inode);
+	if (retval)
+		return retval;
+
+	return ext2fs_inline_data_ea_remove(fs, ino);
+}
+
 /*
  * Deallocate all logical blocks starting at start to end, inclusive.
  * If end is ~0, then this is effectively truncate.
@@ -322,7 +346,9 @@ extern errcode_t ext2fs_punch(ext2_filsys fs, ext2_ino_t ino,
 			return retval;
 		inode = &inode_buf;
 	}
-	if (inode->i_flags & EXT4_EXTENTS_FL)
+	if (inode->i_flags & EXT4_INLINE_DATA_FL)
+		return ext2fs_punch_inline_data(fs, ino, inode, start, end);
+	else if (inode->i_flags & EXT4_EXTENTS_FL)
 		retval = ext2fs_punch_extent(fs, ino, inode, start, end);
 	else {
 		blk_t	count;
-- 
1.7.9.7

