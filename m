From: Tao Ma <tm@tao.ma>
Subject: [PATCH V1 09/17] ext4: Create __ext4_insert_dentry for dir entry insertion.
Date: Wed, 26 Oct 2011 15:34:20 +0800
Message-ID: <1319614468-11227-9-git-send-email-tm@tao.ma>
References: <4EA7B788.3040503@tao.ma>
 <1319614468-11227-1-git-send-email-tm@tao.ma>
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org, adilger@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1319614468-11227-1-git-send-email-tm@tao.ma>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

The old add_dirent_to_buf handles all the work related to the
work of adding dir entry to a dir block. Now we have inline data,
so create 2 new function __ext4_find_dest_de and __ext4_insert_dentry
that do the real work and let add_dirent_to_buf call them.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/namei.c |  104 ++++++++++++++++++++++++++++++++++++-------------------
 1 files changed, 68 insertions(+), 36 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index d7661cb..2e83b92 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1243,6 +1243,66 @@ errout:
 	return NULL;
 }
 
+static inline int __ext4_find_dest_de(struct inode *dir, struct inode *inode,
+				      struct buffer_head *bh,
+				      void *buf, int buf_size,
+				      const char *name, int namelen,
+				      struct ext4_dir_entry_2 **dest_de)
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
+static inline void __ext4_insert_dentry(struct inode *inode,
+					struct ext4_dir_entry_2 *de,
+					int buf_size,
+					const char *name, int namelen)
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
@@ -1258,31 +1318,17 @@ static int add_dirent_to_buf(handle_t *handle, struct dentry *dentry,
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
+		err = __ext4_find_dest_de(dir, inode,
+					  bh, bh->b_data, blocksize,
+					  name, namelen, &de);
+		if (err)
+			return err;
 	}
 	BUFFER_TRACE(bh, "get_write_access");
 	err = ext4_journal_get_write_access(handle, bh);
@@ -1292,22 +1338,8 @@ static int add_dirent_to_buf(handle_t *handle, struct dentry *dentry,
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
+	__ext4_insert_dentry(inode, de, blocksize, name, namelen);
+
 	/*
 	 * XXX shouldn't update any times until successful
 	 * completion of syscall, but too many callers depend
-- 
1.7.0.4
