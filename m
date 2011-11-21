From: Tao Ma <tm@tao.ma>
Subject: [PATCH V2 10/19] ext4: Create __ext4_insert_dentry for dir entry insertion.
Date: Tue, 22 Nov 2011 00:39:48 +0800
Message-ID: <1321893597-11024-10-git-send-email-tm@tao.ma>
References: <4ECA7DB3.9040605@tao.ma>
 <1321893597-11024-1-git-send-email-tm@tao.ma>
Cc: tytso@mit.edu, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, adilger@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1321893597-11024-1-git-send-email-tm@tao.ma>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

The old add_dirent_to_buf handles all the work related to the
work of adding dir entry to a dir block. Now we have inline data,
so create 2 new function __ext4_find_dest_de and __ext4_insert_dentry
that do the real work and let add_dirent_to_buf call them.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/ext4.h  |   15 +++++++
 fs/ext4/namei.c |  111 +++++++++++++++++++++++++++++++++---------------------
 2 files changed, 83 insertions(+), 43 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index bcc29b1..620c168 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1815,6 +1815,21 @@ extern int ext4_htree_store_dirent(struct file *dir_file, __u32 hash,
 				    __u32 minor_hash,
 				    struct ext4_dir_entry_2 *dirent);
 extern void ext4_htree_free_dir_info(struct dir_private_info *p);
+extern int ext4_find_dest_de(struct inode *dir, struct inode *inode,
+			     struct buffer_head *bh,
+			     void *buf, int buf_size,
+			     const char *name, int namelen,
+			     struct ext4_dir_entry_2 **dest_de);
+void ext4_insert_dentry(struct inode *inode,
+			struct ext4_dir_entry_2 *de,
+			int buf_size,
+			const char *name, int namelen);
+static inline void ext4_update_dx_flag(struct inode *inode)
+{
+	if (!EXT4_HAS_COMPAT_FEATURE(inode->i_sb,
+				     EXT4_FEATURE_COMPAT_DIR_INDEX))
+		ext4_clear_inode_flag(inode, EXT4_INODE_INDEX);
+}
 
 /* fsync.c */
 extern int ext4_sync_file(struct file *, loff_t, loff_t, int);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index aae0f5b..21acbc9 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -775,13 +775,6 @@ static void dx_insert_block(struct dx_frame *frame, u32 hash, ext4_lblk_t block)
 	dx_set_count(entries, count + 1);
 }
 
-static void ext4_update_dx_flag(struct inode *inode)
-{
-	if (!EXT4_HAS_COMPAT_FEATURE(inode->i_sb,
-				     EXT4_FEATURE_COMPAT_DIR_INDEX))
-		ext4_clear_inode_flag(inode, EXT4_INODE_INDEX);
-}
-
 /*
  * NOTE! unlike strncmp, ext4_match returns 1 for success, 0 for failure.
  *
@@ -1243,6 +1236,66 @@ errout:
 	return NULL;
 }
 
+int ext4_find_dest_de(struct inode *dir, struct inode *inode,
+		      struct buffer_head *bh,
+		      void *buf, int buf_size,
+		      const char *name, int namelen,
+		      struct ext4_dir_entry_2 **dest_de)
+{
+	struct ext4_dir_entry_2 *de;
+	unsigned short reclen = EXT4_DIR_REC_LEN(namelen);
+	int nlen, rlen;
+	unsigned int offset = 0;
+	char *top;
+
+	de = (struct ext4_dir_entry_2 *)buf;
+	top = buf + buf_size - reclen;
+	while ((char *) de <= top) {
+		if (ext4_check_dir_entry(dir, NULL, de, bh,
+					 buf, buf_size, offset))
+			return -EIO;
+		if (ext4_match(namelen, name, de))
+			return -EEXIST;
+		nlen = EXT4_DIR_REC_LEN(de->name_len);
+		rlen = ext4_rec_len_from_disk(de->rec_len, buf_size);
+		if ((de->inode ? rlen - nlen : rlen) >= reclen)
+			break;
+		de = (struct ext4_dir_entry_2 *)((char *)de + rlen);
+		offset += rlen;
+	}
+	if ((char *) de > top)
+		return -ENOSPC;
+
+	*dest_de = de;
+	return 0;
+}
+
+void ext4_insert_dentry(struct inode *inode,
+			struct ext4_dir_entry_2 *de,
+			int buf_size,
+			const char *name, int namelen)
+{
+
+	int nlen, rlen;
+
+	nlen = EXT4_DIR_REC_LEN(de->name_len);
+	rlen = ext4_rec_len_from_disk(de->rec_len, buf_size);
+	if (de->inode) {
+		struct ext4_dir_entry_2 *de1 =
+				(struct ext4_dir_entry_2 *)((char *)de + nlen);
+		de1->rec_len = ext4_rec_len_to_disk(rlen - nlen, buf_size);
+		de->rec_len = ext4_rec_len_to_disk(nlen, buf_size);
+		de = de1;
+	}
+	de->file_type = EXT4_FT_UNKNOWN;
+	if (inode) {
+		de->inode = cpu_to_le32(inode->i_ino);
+		ext4_set_de_type(inode->i_sb, de, inode->i_mode);
+	} else
+		de->inode = 0;
+	de->name_len = namelen;
+	memcpy(de->name, name, namelen);
+}
 /*
  * Add a new entry into a directory (leaf) block.  If de is non-NULL,
  * it points to a directory entry which is guaranteed to be large
@@ -1258,31 +1311,17 @@ static int add_dirent_to_buf(handle_t *handle, struct dentry *dentry,
 	struct inode	*dir = dentry->d_parent->d_inode;
 	const char	*name = dentry->d_name.name;
 	int		namelen = dentry->d_name.len;
-	unsigned int	offset = 0;
 	unsigned int	blocksize = dir->i_sb->s_blocksize;
 	unsigned short	reclen;
-	int		nlen, rlen, err;
-	char		*top;
+	int		err;
 
 	reclen = EXT4_DIR_REC_LEN(namelen);
 	if (!de) {
-		de = (struct ext4_dir_entry_2 *)bh->b_data;
-		top = bh->b_data + blocksize - reclen;
-		while ((char *) de <= top) {
-			if (ext4_check_dir_entry(dir, NULL, de, bh, bh->b_data,
-						 bh->b_size, offset))
-				return -EIO;
-			if (ext4_match(namelen, name, de))
-				return -EEXIST;
-			nlen = EXT4_DIR_REC_LEN(de->name_len);
-			rlen = ext4_rec_len_from_disk(de->rec_len, blocksize);
-			if ((de->inode? rlen - nlen: rlen) >= reclen)
-				break;
-			de = (struct ext4_dir_entry_2 *)((char *)de + rlen);
-			offset += rlen;
-		}
-		if ((char *) de > top)
-			return -ENOSPC;
+		err = ext4_find_dest_de(dir, inode,
+					bh, bh->b_data, blocksize,
+					name, namelen, &de);
+		if (err)
+			return err;
 	}
 	BUFFER_TRACE(bh, "get_write_access");
 	err = ext4_journal_get_write_access(handle, bh);
@@ -1292,22 +1331,8 @@ static int add_dirent_to_buf(handle_t *handle, struct dentry *dentry,
 	}
 
 	/* By now the buffer is marked for journaling */
-	nlen = EXT4_DIR_REC_LEN(de->name_len);
-	rlen = ext4_rec_len_from_disk(de->rec_len, blocksize);
-	if (de->inode) {
-		struct ext4_dir_entry_2 *de1 = (struct ext4_dir_entry_2 *)((char *)de + nlen);
-		de1->rec_len = ext4_rec_len_to_disk(rlen - nlen, blocksize);
-		de->rec_len = ext4_rec_len_to_disk(nlen, blocksize);
-		de = de1;
-	}
-	de->file_type = EXT4_FT_UNKNOWN;
-	if (inode) {
-		de->inode = cpu_to_le32(inode->i_ino);
-		ext4_set_de_type(dir->i_sb, de, inode->i_mode);
-	} else
-		de->inode = 0;
-	de->name_len = namelen;
-	memcpy(de->name, name, namelen);
+	ext4_insert_dentry(inode, de, blocksize, name, namelen);
+
 	/*
 	 * XXX shouldn't update any times until successful
 	 * completion of syscall, but too many callers depend
-- 
1.7.0.4

