From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4/6] ext4: convert ext4_bread() to use the ERR_PTR convention
Date: Fri, 22 Aug 2014 03:29:48 -0400
Message-ID: <1408692590-13346-5-git-send-email-tytso@mit.edu>
References: <1408692590-13346-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44054 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755890AbaHVHaB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Aug 2014 03:30:01 -0400
In-Reply-To: <1408692590-13346-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/dir.c   |  8 +++-----
 fs/ext4/ext4.h  |  3 +--
 fs/ext4/inode.c | 14 ++++----------
 fs/ext4/namei.c | 34 ++++++++++++++++++----------------
 fs/ext4/super.c | 18 ++++++++----------
 5 files changed, 34 insertions(+), 43 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 0bb3f9e..c24143e 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -151,13 +151,11 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 					&file->f_ra, file,
 					index, 1);
 			file->f_ra.prev_pos = (loff_t)index << PAGE_CACHE_SHIFT;
-			bh = ext4_bread(NULL, inode, map.m_lblk, 0, &err);
+			bh = ext4_bread(NULL, inode, map.m_lblk, 0);
+			if (IS_ERR(bh))
+				return PTR_ERR(bh);
 		}
 
-		/*
-		 * We ignore I/O errors on directories so users have a chance
-		 * of recovering data when there's a bad sector
-		 */
 		if (!bh) {
 			if (!dir_has_error) {
 				EXT4_ERROR_FILE(file, 0,
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 0258710..5424aa3 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2087,8 +2087,7 @@ extern int ext4_trim_fs(struct super_block *, struct fstrim_range *);
 
 /* inode.c */
 struct buffer_head *ext4_getblk(handle_t *, struct inode *, ext4_lblk_t, int);
-struct buffer_head *ext4_bread(handle_t *, struct inode *,
-						ext4_lblk_t, int, int *);
+struct buffer_head *ext4_bread(handle_t *, struct inode *, ext4_lblk_t, int);
 int ext4_get_block_write(struct inode *inode, sector_t iblock,
 			 struct buffer_head *bh_result, int create);
 int ext4_get_block(struct inode *inode, sector_t iblock,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 7757657..16c370f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -791,27 +791,21 @@ errout:
 }
 
 struct buffer_head *ext4_bread(handle_t *handle, struct inode *inode,
-			       ext4_lblk_t block, int create, int *err)
+			       ext4_lblk_t block, int create)
 {
 	struct buffer_head *bh;
 
-	*err = 0;
 	bh = ext4_getblk(handle, inode, block, create);
-	if (IS_ERR(bh)) {
-		*err = PTR_ERR(bh);
-		return NULL;
-	}
-	if (!bh)
+	if (IS_ERR(bh))
 		return bh;
-	if (buffer_uptodate(bh))
+	if (!bh || buffer_uptodate(bh))
 		return bh;
 	ll_rw_block(READ | REQ_META | REQ_PRIO, 1, &bh);
 	wait_on_buffer(bh);
 	if (buffer_uptodate(bh))
 		return bh;
 	put_bh(bh);
-	*err = -EIO;
-	return NULL;
+	return ERR_PTR(-EIO);
 }
 
 int ext4_walk_page_buffers(handle_t *handle,
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 53b53bc..8043398 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -53,7 +53,7 @@ static struct buffer_head *ext4_append(handle_t *handle,
 					ext4_lblk_t *block)
 {
 	struct buffer_head *bh;
-	int err = 0;
+	int err;
 
 	if (unlikely(EXT4_SB(inode->i_sb)->s_max_dir_size_kb &&
 		     ((inode->i_size >> 10) >=
@@ -62,9 +62,9 @@ static struct buffer_head *ext4_append(handle_t *handle,
 
 	*block = inode->i_size >> inode->i_sb->s_blocksize_bits;
 
-	bh = ext4_bread(handle, inode, *block, 1, &err);
-	if (!bh)
-		return ERR_PTR(err);
+	bh = ext4_bread(handle, inode, *block, 1);
+	if (IS_ERR(bh))
+		return bh;
 	inode->i_size += inode->i_sb->s_blocksize;
 	EXT4_I(inode)->i_disksize = inode->i_size;
 	BUFFER_TRACE(bh, "get_write_access");
@@ -94,20 +94,20 @@ static struct buffer_head *__ext4_read_dirblock(struct inode *inode,
 {
 	struct buffer_head *bh;
 	struct ext4_dir_entry *dirent;
-	int err = 0, is_dx_block = 0;
+	int is_dx_block = 0;
 
-	bh = ext4_bread(NULL, inode, block, 0, &err);
-	if (!bh) {
-		if (err == 0) {
-			ext4_error_inode(inode, __func__, line, block,
-					       "Directory hole found");
-			return ERR_PTR(-EIO);
-		}
+	bh = ext4_bread(NULL, inode, block, 0);
+	if (IS_ERR(bh)) {
 		__ext4_warning(inode->i_sb, __func__, line,
-			       "error reading directory block "
-			       "(ino %lu, block %lu)", inode->i_ino,
+			       "error %ld reading directory block "
+			       "(ino %lu, block %lu)", PTR_ERR(bh), inode->i_ino,
 			       (unsigned long) block);
-		return ERR_PTR(err);
+
+		return bh;
+	}
+	if (!bh) {
+		ext4_error_inode(inode, __func__, line, block, "Directory hole found");
+		return ERR_PTR(-EIO);
 	}
 	dirent = (struct ext4_dir_entry *) bh->b_data;
 	/* Determine whether or not we have an index block */
@@ -640,7 +640,9 @@ struct stats dx_show_entries(struct dx_hash_info *hinfo, struct inode *dir,
 		u32 range = i < count - 1? (dx_get_hash(entries + 1) - hash): ~hash;
 		struct stats stats;
 		printk("%s%3u:%03u hash %8x/%8x ",levels?"":"   ", i, block, hash, range);
-		if (!(bh = ext4_bread (NULL,dir, block, 0,&err))) continue;
+		bh = ext4_bread(NULL,dir, block, 0);
+		if (!bh || IS_ERR(bh))
+			continue;
 		stats = levels?
 		   dx_show_entries(hinfo, dir, ((struct dx_node *) bh->b_data)->entries, levels - 1):
 		   dx_show_leaf(hinfo, (struct ext4_dir_entry_2 *) bh->b_data, blocksize, 0);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 32b43ad..f9d8cf1 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5304,7 +5304,6 @@ static ssize_t ext4_quota_read(struct super_block *sb, int type, char *data,
 {
 	struct inode *inode = sb_dqopt(sb)->files[type];
 	ext4_lblk_t blk = off >> EXT4_BLOCK_SIZE_BITS(sb);
-	int err = 0;
 	int offset = off & (sb->s_blocksize - 1);
 	int tocopy;
 	size_t toread;
@@ -5319,9 +5318,9 @@ static ssize_t ext4_quota_read(struct super_block *sb, int type, char *data,
 	while (toread > 0) {
 		tocopy = sb->s_blocksize - offset < toread ?
 				sb->s_blocksize - offset : toread;
-		bh = ext4_bread(NULL, inode, blk, 0, &err);
-		if (err)
-			return err;
+		bh = ext4_bread(NULL, inode, blk, 0);
+		if (IS_ERR(bh))
+			return PTR_ERR(bh);
 		if (!bh)	/* A hole? */
 			memset(data, 0, tocopy);
 		else
@@ -5342,8 +5341,7 @@ static ssize_t ext4_quota_write(struct super_block *sb, int type,
 {
 	struct inode *inode = sb_dqopt(sb)->files[type];
 	ext4_lblk_t blk = off >> EXT4_BLOCK_SIZE_BITS(sb);
-	int err = 0;
-	int offset = off & (sb->s_blocksize - 1);
+	int err, offset = off & (sb->s_blocksize - 1);
 	struct buffer_head *bh;
 	handle_t *handle = journal_current_handle();
 
@@ -5364,14 +5362,16 @@ static ssize_t ext4_quota_write(struct super_block *sb, int type,
 		return -EIO;
 	}
 
-	bh = ext4_bread(handle, inode, blk, 1, &err);
+	bh = ext4_bread(handle, inode, blk, 1);
+	if (IS_ERR(bh))
+		return PTR_ERR(bh);
 	if (!bh)
 		goto out;
 	BUFFER_TRACE(bh, "get write access");
 	err = ext4_journal_get_write_access(handle, bh);
 	if (err) {
 		brelse(bh);
-		goto out;
+		return err;
 	}
 	lock_buffer(bh);
 	memcpy(bh->b_data+offset, data, len);
@@ -5380,8 +5380,6 @@ static ssize_t ext4_quota_write(struct super_block *sb, int type,
 	err = ext4_handle_dirty_metadata(handle, NULL, bh);
 	brelse(bh);
 out:
-	if (err)
-		return err;
 	if (inode->i_size < off + len) {
 		i_size_write(inode, off + len);
 		EXT4_I(inode)->i_disksize = inode->i_size;
-- 
2.1.0

