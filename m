From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v2 06/28] libext2fs: remove redundant code
Date: Tue,  3 Dec 2013 20:11:33 +0800
Message-ID: <1386072715-9869-7-git-send-email-wenqing.lz@taobao.com>
References: <1386072715-9869-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:39411 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329Ab3LCMJV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Dec 2013 07:09:21 -0500
Received: by mail-pb0-f49.google.com with SMTP id jt11so20843918pbb.36
        for <linux-ext4@vger.kernel.org>; Tue, 03 Dec 2013 04:09:21 -0800 (PST)
In-Reply-To: <1386072715-9869-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/ext_attr.c |   39 +++++++++++++++++----------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index 3e09d58..934ad6f 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -466,7 +466,7 @@ errcode_t ext2fs_xattrs_write(struct ext2_xattr_handle *handle)
 	__u32 ea_inode_magic;
 	blk64_t blk;
 	unsigned int storage_size;
-	unsigned int i, written;
+	unsigned int i;
 	errcode_t err;
 
 	i = EXT2_INODE_SIZE(handle->fs->super);
@@ -527,26 +527,24 @@ write_ea_block:
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
@@ -659,7 +657,6 @@ static errcode_t read_xattrs_from_buffer(struct ext2_xattr_handle *handle,
 errcode_t ext2fs_xattrs_read(struct ext2_xattr_handle *handle)
 {
 	struct ext2_xattr *attrs = NULL, *x;
-	unsigned int attrs_len;
 	struct ext2_inode_large *inode;
 	struct ext2_ext_attr_header *header;
 	__u32 ea_inode_magic;
@@ -757,8 +754,6 @@ out:
 	return err;
 }
 
-#define XATTR_ABORT	1
-#define XATTR_CHANGED	2
 errcode_t ext2fs_xattrs_iterate(struct ext2_xattr_handle *h,
 				int (*func)(char *name, char *value,
 					    size_t value_len, void *data),
-- 
1.7.9.7

