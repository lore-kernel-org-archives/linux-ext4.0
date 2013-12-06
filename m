From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v3 04/30] libext2fs: fix memory leaks in extended attribute code
Date: Fri,  6 Dec 2013 17:57:51 +0800
Message-ID: <1386323897-2354-5-git-send-email-wenqing.lz@taobao.com>
References: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:55662 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757235Ab3LFJzd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Dec 2013 04:55:33 -0500
Received: by mail-pd0-f178.google.com with SMTP id y10so745155pdj.23
        for <linux-ext4@vger.kernel.org>; Fri, 06 Dec 2013 01:55:31 -0800 (PST)
In-Reply-To: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

Fix some memory leaks and data disclosure problems in the extended
attribute writing code.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/ext_attr.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index f7d623a..a8a8c93 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -364,7 +364,7 @@ static errcode_t prep_ea_block_for_write(ext2_filsys fs, ext2_ino_t ino,
 
 		/* Single-user block.  We're done here. */
 		if (header->h_refcount == 1)
-			return 0;
+			goto out2;
 
 		/* We need to CoW the block. */
 		header->h_refcount--;
@@ -384,10 +384,11 @@ static errcode_t prep_ea_block_for_write(ext2_filsys fs, ext2_ino_t ino,
 	goal = ext2fs_inode_table_loc(fs, grp);
 	err = ext2fs_alloc_block2(fs, goal, NULL, &blk);
 	if (err)
-		return err;
+		goto out2;
 	ext2fs_file_acl_block_set(fs, (struct ext2_inode *)inode, blk);
 out2:
-	ext2fs_free_mem(&block_buf);
+	if (block_buf)
+		ext2fs_free_mem(&block_buf);
 out:
 	return err;
 }
@@ -509,7 +510,7 @@ errcode_t ext2fs_xattrs_write(struct ext2_xattr_handle *handle)
 
 write_ea_block:
 	/* Write the EA block */
-	err = ext2fs_get_mem(handle->fs->blocksize, &block_buf);
+	err = ext2fs_get_memzero(handle->fs->blocksize, &block_buf);
 	if (err)
 		goto out;
 
-- 
1.7.9.7

