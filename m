From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v3 05/30] libext2fs: fix block leak when releasing xattr block
Date: Fri,  6 Dec 2013 17:57:52 +0800
Message-ID: <1386323897-2354-6-git-send-email-wenqing.lz@taobao.com>
References: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:55362 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756772Ab3LFJze (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Dec 2013 04:55:34 -0500
Received: by mail-pd0-f176.google.com with SMTP id w10so749357pde.21
        for <linux-ext4@vger.kernel.org>; Fri, 06 Dec 2013 01:55:34 -0800 (PST)
In-Reply-To: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

If in the process of writing EAs to an inode we discover that we no
longer need the EA block, use the helper function to decrement the
block's usage count and release it, instead of (brokenly) open-coding
it.  Also we need to decrement i_blocks when freeing the EA block.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/ext_attr.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index a8a8c93..81f60ca 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -315,6 +315,9 @@ errcode_t ext2fs_free_ext_attr(ext2_filsys fs, ext2_ino_t ino,
 	ext2fs_file_acl_block_set(fs, (struct ext2_inode *)inode, 0);
 	if (header->h_refcount == 0)
 		ext2fs_block_alloc_stats2(fs, blk, -1);
+	err = ext2fs_iblk_sub_blocks(fs, (struct ext2_inode *)inode, 1);
+	if (err)
+		goto out2;
 
 	/* Write inode? */
 	if (inode == &i) {
@@ -553,13 +556,9 @@ skip_ea_block:
 	blk = ext2fs_file_acl_block(handle->fs, (struct ext2_inode *)inode);
 	if (!block_buf && blk) {
 		/* xattrs shrunk, free the block */
-		ext2fs_file_acl_block_set(handle->fs,
-					  (struct ext2_inode *)inode, 0);
-		err = ext2fs_iblk_sub_blocks(handle->fs,
-					     (struct ext2_inode *)inode, 1);
+		err = ext2fs_free_ext_attr(handle->fs, handle->ino, inode);
 		if (err)
 			goto out;
-		ext2fs_block_alloc_stats2(handle->fs, blk, -1);
 	}
 
 	/* Write the inode */
-- 
1.7.9.7

