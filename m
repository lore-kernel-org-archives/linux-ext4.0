From: shilong wang <wangshilong1991@gmail.com>
Subject: [PATCH] Ext4: use unlikely to improve the efficiency of the kernel
Date: Sat, 12 Jan 2013 01:57:13 -0800
Message-ID: <CAP9B-Qn1pnXaq2VaeMQvCct6AftGrxy+53zS9BDWLZAXNNaP2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61323 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab3ALJ5P (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 12 Jan 2013 04:57:15 -0500
Received: by mail-ee0-f46.google.com with SMTP id e49so1199884eek.5
        for <linux-ext4@vger.kernel.org>; Sat, 12 Jan 2013 01:57:14 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

Because the function 'sb_getblk' seldomly fails to return NULL
value,it will be better to use 'unlikely' to optimize it.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 fs/ext4/extents.c |    6 +++---
 fs/ext4/inode.c   |    6 +++---
 fs/ext4/mmp.c     |    2 +-
 fs/ext4/resize.c  |   10 +++++-----
 fs/ext4/xattr.c   |    2 +-
 5 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index aabbb3f..8d5f818 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -942,7 +942,7 @@ static int ext4_ext_split(handle_t *handle, struct
inode *inode,
 		goto cleanup;
 	}
 	bh = sb_getblk(inode->i_sb, newblock);
-	if (!bh) {
+	if (unlikely(!bh)) {
 		err = -EIO;
 		goto cleanup;
 	}
@@ -1015,7 +1015,7 @@ static int ext4_ext_split(handle_t *handle,
struct inode *inode,
 		oldblock = newblock;
 		newblock = ablocks[--a];
 		bh = sb_getblk(inode->i_sb, newblock);
-		if (!bh) {
+		if (unlikely(!bh)) {
 			err = -EIO;
 			goto cleanup;
 		}
@@ -1128,7 +1128,7 @@ static int ext4_ext_grow_indepth(handle_t
*handle, struct inode *inode,
 		return err;

 	bh = sb_getblk(inode->i_sb, newblock);
-	if (!bh) {
+	if (unlikely(!bh)) {
 		err = -EIO;
 		ext4_std_error(inode->i_sb, err);
 		return err;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index dff171c..7c7cbf0 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -739,7 +739,7 @@ struct buffer_head *ext4_getblk(handle_t *handle,
struct inode *inode,
 	*errp = 0;

 	bh = sb_getblk(inode->i_sb, map.m_pblk);
-	if (!bh) {
+	if (unlikely(!bh)) {
 		*errp = -EIO;
 		return NULL;
 	}
@@ -3590,7 +3590,7 @@ static int __ext4_get_inode_loc(struct inode *inode,
 	iloc->offset = (inode_offset % inodes_per_block) * EXT4_INODE_SIZE(sb);

 	bh = sb_getblk(sb, block);
-	if (!bh) {
+	if (unlikely(!bh)) {
 		EXT4_ERROR_INODE_BLOCK(inode, block,
 				       "unable to read itable block");
 		return -EIO;
@@ -3626,7 +3626,7 @@ static int __ext4_get_inode_loc(struct inode *inode,

 			/* Is the inode bitmap in cache? */
 			bitmap_bh = sb_getblk(sb, ext4_inode_bitmap(sb, gdp));
-			if (!bitmap_bh)
+			if (unlikely(!bitmap_bh))
 				goto make_io;

 			/*
diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index fe7c63f..5ea3726 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -91,7 +91,7 @@ static int read_mmp_block(struct super_block *sb,
struct buffer_head **bh,
 			*bh = NULL;
 		}
 	}
-	if (!*bh) {
+	if (unlikely(!*bh)) {
 		ext4_warning(sb, "Error while reading MMP block %llu",
 			     mmp_block);
 		return -EIO;
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 41f6ef6..66be5b0 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -309,7 +309,7 @@ static struct buffer_head *bclean(handle_t
*handle, struct super_block *sb,
 	int err;

 	bh = sb_getblk(sb, blk);
-	if (!bh)
+	if (unlikely(!bh))
 		return ERR_PTR(-EIO);
 	if ((err = ext4_journal_get_write_access(handle, bh))) {
 		brelse(bh);
@@ -386,7 +386,7 @@ static int set_flexbg_block_bitmap(struct
super_block *sb, handle_t *handle,
 			return err;

 		bh = sb_getblk(sb, flex_gd->groups[group].block_bitmap);
-		if (!bh)
+		if (unlikely(!bh))
 			return -EIO;

 		err = ext4_journal_get_write_access(handle, bh);
@@ -461,7 +461,7 @@ static int setup_new_flex_group_blocks(struct
super_block *sb,
 				goto out;

 			gdb = sb_getblk(sb, block);
-			if (!gdb) {
+			if (unlikely(!gdb)) {
 				err = -EIO;
 				goto out;
 			}
@@ -983,7 +983,7 @@ static void update_backups(struct super_block *sb,
 			break;

 		bh = sb_getblk(sb, group * bpg + blk_off);
-		if (!bh) {
+		if (unlikely(!bh)) {
 			err = -EIO;
 			break;
 		}
@@ -1074,7 +1074,7 @@ static int ext4_add_new_descs(handle_t *handle,
struct super_block *sb,
 static struct buffer_head *ext4_get_bitmap(struct super_block *sb, __u64 block)
 {
 	struct buffer_head *bh = sb_getblk(sb, block);
-	if (!bh)
+	if (unlikely(!bh))
 		return NULL;

 	if (bitmap_uptodate(bh))
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 2cdb98d..3b05198 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -897,7 +897,7 @@ inserted:
 				  (unsigned long long)block);

 			new_bh = sb_getblk(sb, block);
-			if (!new_bh) {
+			if (unlikely(!new_bh)) {
 getblk_failed:
 				ext4_free_blocks(handle, inode, NULL, block, 1,
 						 EXT4_FREE_BLOCKS_METADATA);
-- 
1.7.7.6
