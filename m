From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v2 05/28] libext2fs: fix block leak when releasing xattr block
Date: Tue,  3 Dec 2013 20:11:32 +0800
Message-ID: <1386072715-9869-6-git-send-email-wenqing.lz@taobao.com>
References: <1386072715-9869-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:55911 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab3LCMJT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Dec 2013 07:09:19 -0500
Received: by mail-pd0-f169.google.com with SMTP id v10so20038110pde.0
        for <linux-ext4@vger.kernel.org>; Tue, 03 Dec 2013 04:09:19 -0800 (PST)
In-Reply-To: <1386072715-9869-1-git-send-email-wenqing.lz@taobao.com>
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
index 94bc89b..3e09d58 100644
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
@@ -549,13 +552,9 @@ skip_ea_block:
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

