From: Joe Perches <joe@perches.com>
Subject: [PATCH 4/9] ext4: Add no_printk argument validation, fix fallout
Date: Thu, 15 Mar 2012 17:07:32 -0700
Message-ID: <12b7235b4eeb7c50ac888b7f28bc1cf737bc397b.1331856300.git.joe@perches.com>
References: <cover.1331856299.git.joe@perches.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:60552 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161802Ab2CPAIi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Mar 2012 20:08:38 -0400
In-Reply-To: <cover.1331856299.git.joe@perches.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add argument validation to debug functions.
Use ##__VA_ARGS__.

Fix format and argument mismatches.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ext4/ext4.h         |    2 +-
 fs/ext4/ext4_extents.h |    4 ++--
 fs/ext4/inode.c        |    2 +-
 fs/ext4/xattr.c        |   13 ++++++++-----
 4 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 30d32e2..2aaf549 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -50,7 +50,7 @@
 	pr_debug("DEBUG (%s, %d): %s:" fmt,				\
 		 __FILE__, __LINE__, __func__, ##__VA_ARGS__)
 #else
-#define ext4_debug(f, a...)	do {} while (0)
+#define ext4_debug(fmt, ...)	no_printk(fmt, ##__VA_ARGS__)
 #endif
 
 #define EXT4_ERROR_INODE(inode, fmt, a...) \
diff --git a/fs/ext4/ext4_extents.h b/fs/ext4/ext4_extents.h
index a52db3a..0f58b86 100644
--- a/fs/ext4/ext4_extents.h
+++ b/fs/ext4/ext4_extents.h
@@ -47,9 +47,9 @@
  */
 #define EXT_DEBUG__
 #ifdef EXT_DEBUG
-#define ext_debug(a...)		printk(a)
+#define ext_debug(fmt, ...)	printk(fmt, ##__VA_ARGS__)
 #else
-#define ext_debug(a...)
+#define ext_debug(fmt, ...)	no_printk(fmt, ##__VA_ARGS__)
 #endif
 
 /*
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c67be80..a2a1ae4 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2766,7 +2766,7 @@ static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
 		goto out;
 
 	ext_debug("ext4_end_io_dio(): io_end 0x%p "
-		  "for inode %lu, iocb 0x%p, offset %llu, size %llu\n",
+		  "for inode %lu, iocb 0x%p, offset %llu, size %zd\n",
  		  iocb->private, io_end->inode->i_ino, iocb, offset,
 		  size);
 
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index a8674d2..5bc718c 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -78,8 +78,8 @@ do {									\
 		 (unsigned long)bh->b_blocknr, ##__VA_ARGS__);		\
 } while (0)
 #else
-# define ea_idebug(f...)
-# define ea_bdebug(f...)
+# define ea_idebug(inode, fmt, ...)	no_printk(fmt, ##__VA_ARGS__)
+# define ea_bdebug(bh, fmt, ...)	no_printk(fmt, ##__VA_ARGS__)
 #endif
 
 static void ext4_xattr_cache_insert(struct buffer_head *);
@@ -213,7 +213,8 @@ ext4_xattr_block_get(struct inode *inode, int name_index, const char *name,
 	error = -ENODATA;
 	if (!EXT4_I(inode)->i_file_acl)
 		goto cleanup;
-	ea_idebug(inode, "reading block %u", EXT4_I(inode)->i_file_acl);
+	ea_idebug(inode, "reading block %llu",
+		  (unsigned long long)EXT4_I(inode)->i_file_acl);
 	bh = sb_bread(inode->i_sb, EXT4_I(inode)->i_file_acl);
 	if (!bh)
 		goto cleanup;
@@ -356,7 +357,8 @@ ext4_xattr_block_list(struct dentry *dentry, char *buffer, size_t buffer_size)
 	error = 0;
 	if (!EXT4_I(inode)->i_file_acl)
 		goto cleanup;
-	ea_idebug(inode, "reading block %u", EXT4_I(inode)->i_file_acl);
+	ea_idebug(inode, "reading block %llu",
+		  (unsigned long long)EXT4_I(inode)->i_file_acl);
 	bh = sb_bread(inode->i_sb, EXT4_I(inode)->i_file_acl);
 	error = -EIO;
 	if (!bh)
@@ -828,7 +830,8 @@ inserted:
 			if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
 				BUG_ON(block > EXT4_MAX_BLOCK_FILE_PHYS);
 
-			ea_idebug(inode, "creating block %d", block);
+			ea_idebug(inode, "creating block %llu",
+				  (unsigned long long)block);
 
 			new_bh = sb_getblk(sb, block);
 			if (!new_bh) {
-- 
1.7.8.111.gad25c.dirty

