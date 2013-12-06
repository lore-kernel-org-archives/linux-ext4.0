From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v3 06/30] libext2fs: remove redundant code
Date: Fri,  6 Dec 2013 17:57:53 +0800
Message-ID: <1386323897-2354-7-git-send-email-wenqing.lz@taobao.com>
References: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:42004 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757460Ab3LFJzh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Dec 2013 04:55:37 -0500
Received: by mail-pd0-f177.google.com with SMTP id q10so742083pdj.22
        for <linux-ext4@vger.kernel.org>; Fri, 06 Dec 2013 01:55:37 -0800 (PST)
In-Reply-To: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/ext_attr.c |   39 +++++++++++++++++----------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index 81f60ca..1b65c4b 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -466,7 +466,7 @@ errcode_t ext2fs_xattrs_write(struct ext2_xattr_handle *handle)
 	__u32 ea_inode_magic;
 	blk64_t blk;
 	unsigned int storage_size;
-	unsigned int i, written;
+	unsigned int i;
 	errcode_t err;
 
 	if (!EXT2_HAS_COMPAT_FEATURE(handle->fs->super,
@@ -531,26 +531,24 @@ write_ea_block:
 		goto out2;
 	}
 
-	if (block_buf) {
-		/* Write a header on the EA block */
-		header = block_buf;
-		header->h_magic = EXT2_EXT_ATTR_MAGIC;
-		header->h_refcount = 1;
-		header->h_blocks = 1;
+	/* Write a header on the EA block */
+	header = block_buf;
+	header->h_magic = EXT2_EXT_ATTR_MAGIC;
+	header->h_refcount = 1;
+	header->h_blocks = 1;
 
-		/* Get a new block for writing */
-		err = prep_ea_block_for_write(handle->fs, handle->ino, inode);
-		if (err)
-			goto out2;
+	/* Get a new block for writing */
+	err = prep_ea_block_for_write(handle->fs, handle->ino, inode);
+	if (err)
+		goto out2;
 
-		/* Finally, write the new EA block */
-		blk = ext2fs_file_acl_block(handle->fs,
-					    (struct ext2_inode *)inode);
-		err = ext2fs_write_ext_attr3(handle->fs, blk, block_buf,
-					     handle->ino);
-		if (err)
-			goto out2;
-	}
+	/* Finally, write the new EA block */
+	blk = ext2fs_file_acl_block(handle->fs,
+				    (struct ext2_inode *)inode);
+	err = ext2fs_write_ext_attr3(handle->fs, blk, block_buf,
+				     handle->ino);
+	if (err)
+		goto out2;
 
 skip_ea_block:
 	blk = ext2fs_file_acl_block(handle->fs, (struct ext2_inode *)inode);
@@ -663,7 +661,6 @@ static errcode_t read_xattrs_from_buffer(struct ext2_xattr_handle *handle,
 errcode_t ext2fs_xattrs_read(struct ext2_xattr_handle *handle)
 {
 	struct ext2_xattr *attrs = NULL, *x;
-	unsigned int attrs_len;
 	struct ext2_inode_large *inode;
 	struct ext2_ext_attr_header *header;
 	__u32 ea_inode_magic;
@@ -765,8 +762,6 @@ out:
 	return err;
 }
 
-#define XATTR_ABORT	1
-#define XATTR_CHANGED	2
 errcode_t ext2fs_xattrs_iterate(struct ext2_xattr_handle *h,
 				int (*func)(char *name, char *value,
 					    size_t value_len, void *data),
-- 
1.7.9.7

