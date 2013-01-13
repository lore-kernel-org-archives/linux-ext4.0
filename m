From: Wang shilong <wangshilong1991@gmail.com>
Subject: [PATCH V1 2/2] Ext3: return ENOMEM rather than EIO if sb_getblk fails
Date: Sun, 13 Jan 2013 18:44:55 +0800
Message-ID: <1358073895-1734-1-git-send-email-wangshilong1991@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Wang shilong <wangshilong1991@gmail.com>,
	Wang Shilong <wangsl-fnst@cn.fujitsu.com>
To: jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:54004 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807Ab3AMKpu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 Jan 2013 05:45:50 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

It will be better to have ENOMEM return rather than EIO,because
the only reason that sb_getblk fails is allocation fails.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 fs/ext3/inode.c  | 6 +++---
 fs/ext3/resize.c | 6 +++---
 fs/ext3/xattr.c  | 2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index c91f8bf..d5315d5 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1084,7 +1084,7 @@ struct buffer_head *ext3_getblk(handle_t *handle, struct inode *inode,
 		struct buffer_head *bh;
 		bh = sb_getblk(inode->i_sb, dummy.b_blocknr);
 		if (unlikely(!bh)) {
-			*errp = -EIO;
+			*errp = -ENOMEM;
 			goto err;
 		}
 		if (buffer_new(&dummy)) {
@@ -2739,7 +2739,7 @@ static int __ext3_get_inode_loc(struct inode *inode,
 				"unable to read inode block - "
 				"inode=%lu, block="E3FSBLK,
 				 inode->i_ino, block);
-		return -EIO;
+		return -ENOMEM;
 	}
 	if (!buffer_uptodate(bh)) {
 		lock_buffer(bh);
@@ -2833,7 +2833,7 @@ make_io:
 					"inode=%lu, block="E3FSBLK,
 					inode->i_ino, block);
 			brelse(bh);
-			return -EIO;
+			return -ENOMEM;
 		}
 	}
 has_buffer:
diff --git a/fs/ext3/resize.c b/fs/ext3/resize.c
index 704e8ce..2710565 100644
--- a/fs/ext3/resize.c
+++ b/fs/ext3/resize.c
@@ -117,7 +117,7 @@ static struct buffer_head *bclean(handle_t *handle, struct super_block *sb,
 
 	bh = sb_getblk(sb, blk);
 	if (unlikely(!bh))
-		return ERR_PTR(-EIO);
+		return ERR_PTR(-ENOMEM);
 	if ((err = ext3_journal_get_write_access(handle, bh))) {
 		brelse(bh);
 		bh = ERR_PTR(err);
@@ -235,7 +235,7 @@ static int setup_new_group_blocks(struct super_block *sb,
 
 		gdb = sb_getblk(sb, block);
 		if (unlikely(!gdb)) {
-			err = -EIO;
+			err = -ENOMEM;
 			goto exit_bh;
 		}
 		if ((err = ext3_journal_get_write_access(handle, gdb))) {
@@ -723,7 +723,7 @@ static void update_backups(struct super_block *sb,
 
 		bh = sb_getblk(sb, group * bpg + blk_off);
 		if (unlikely(!bh)) {
-			err = -EIO;
+			err = -ENOMEM;
 			break;
 		}
 		ext3_debug("update metadata backup %#04lx\n",
diff --git a/fs/ext3/xattr.c b/fs/ext3/xattr.c
index 9f57470..b1fc963 100644
--- a/fs/ext3/xattr.c
+++ b/fs/ext3/xattr.c
@@ -816,7 +816,7 @@ inserted:
 			if (unlikely(!new_bh)) {
 getblk_failed:
 				ext3_free_blocks(handle, inode, block, 1);
-				error = -EIO;
+				error = -ENOMEM;
 				goto cleanup;
 			}
 			lock_buffer(new_bh);
-- 
1.7.11.7

