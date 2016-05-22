From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/2] mke2fs: fix project quota creation
Date: Sat, 21 May 2016 22:19:19 -0400
Message-ID: <1463883560-2442-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49426 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964AbcEVCT1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 21 May 2016 22:19:27 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Creating a file system with project quotas can fail if mke2fs is built
using hardening options.  This is because quota_compute_usage() used
ext2fs_get_next_inode() instead of ext2fs_get_inode_full(), and a
small inode was passed into quota_data_add, when a large inode needs
to be used.  As a result get_dq() would end up dereferencing undefined
space in the stack.  Without the hardening options, this would be
zero, so "mke2fs -t ext4 -O project.quota -I 256 test.img" would work
essentially by accident.

Fix this by using ext2fs_get_inode_full() so that a large inode is
available to quota_data_inodes().

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 lib/support/mkquota.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/lib/support/mkquota.c b/lib/support/mkquota.c
index c5dd140..a432d4e 100644
--- a/lib/support/mkquota.c
+++ b/lib/support/mkquota.c
@@ -448,7 +448,8 @@ errcode_t quota_compute_usage(quota_ctx_t qctx)
 	ext2_filsys fs;
 	ext2_ino_t ino;
 	errcode_t ret;
-	struct ext2_inode inode;
+	struct ext2_inode *inode;
+	int inode_size;
 	qsize_t space;
 	ext2_inode_scan scan;
 
@@ -461,27 +462,31 @@ errcode_t quota_compute_usage(quota_ctx_t qctx)
 		log_err("while opening inode scan. ret=%ld", ret);
 		return ret;
 	}
-
+	inode_size = fs->super->s_inode_size;
+	inode = malloc(inode_size);
+	if (!inode)
+		return ENOMEM;
 	while (1) {
-		ret = ext2fs_get_next_inode(scan, &ino, &inode);
+		ret = ext2fs_get_next_inode_full(scan, &ino, inode, inode_size);
 		if (ret) {
 			log_err("while getting next inode. ret=%ld", ret);
 			ext2fs_close_inode_scan(scan);
+			free(inode);
 			return ret;
 		}
 		if (ino == 0)
 			break;
-		if (inode.i_links_count &&
+		if (inode->i_links_count &&
 		    (ino == EXT2_ROOT_INO ||
 		     ino >= EXT2_FIRST_INODE(fs->super))) {
-			space = ext2fs_inode_i_blocks(fs, &inode) << 9;
-			quota_data_add(qctx, &inode, ino, space);
-			quota_data_inodes(qctx, &inode, ino, +1);
+			space = ext2fs_inode_i_blocks(fs, inode) << 9;
+			quota_data_add(qctx, inode, ino, space);
+			quota_data_inodes(qctx, inode, ino, +1);
 		}
 	}
 
 	ext2fs_close_inode_scan(scan);
