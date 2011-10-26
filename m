From: Tao Ma <tm@tao.ma>
Subject: [PATCH V1 11/17] ext4: Let ext4_readdir handle inline data.
Date: Wed, 26 Oct 2011 15:34:22 +0800
Message-ID: <1319614468-11227-11-git-send-email-tm@tao.ma>
References: <4EA7B788.3040503@tao.ma>
 <1319614468-11227-1-git-send-email-tm@tao.ma>
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org, adilger@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:53815 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754842Ab1JZHlV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Oct 2011 03:41:21 -0400
In-Reply-To: <1319614468-11227-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/dir.c |  101 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 101 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 6c2199e..8b88cfa 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -27,6 +27,7 @@
 #include <linux/slab.h>
 #include <linux/rbtree.h>
 #include "ext4.h"
+#include "xattr.h"
 
 static unsigned char ext4_filetype_table[] = {
 	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK, DT_FIFO, DT_SOCK, DT_LNK
@@ -64,6 +65,9 @@ static unsigned char get_dtype(struct super_block *sb, int filetype)
  * Return 0 if the directory entry is OK, and 1 if there is a problem
  *
  * Note: this is the opposite of what ext2 and ext3 historically returned...
+ *
+ * bh passed here can be an inode block or a dir data block, depending
+ * on the inode inline data flag.
  */
 int __ext4_check_dir_entry(const char *function, unsigned int line,
 			   struct inode *dir, struct file *filp,
@@ -107,6 +111,100 @@ int __ext4_check_dir_entry(const char *function, unsigned int line,
 	return 1;
 }
 
+static int ext4_read_inline_dir(struct file *filp,
+				void *dirent, filldir_t filldir)
+{
+	int error = 0;
+	unsigned int offset;
+	int i, stored;
+	struct ext4_dir_entry_2 *de;
+	struct super_block *sb;
+	struct inode *inode = filp->f_path.dentry->d_inode;
+	int ret, inline_size;
+	void *inline_pos;
+	struct ext4_iloc iloc;
+
+	ret = ext4_get_inode_loc(inode, &iloc);
+	if (ret)
+		return ret;
+
+	sb = inode->i_sb;
+	stored = 0;
+	offset = filp->f_pos & (sb->s_blocksize - 1);
+	inline_pos = ext4_get_inline_data_pos(inode, &iloc);
+	inline_size = ext4_get_max_inline_size(inode);
+
+	ext4_show_inline_dir(inode, iloc.bh, inline_pos, inline_size);
+
+	while (!error && !stored && filp->f_pos < inode->i_size) {
+revalidate:
+		/* If the version has changed since the last call to
+		 * readdir(2), then we might be pointing to an invalid
+		 * dirent right now.  Scan from the start of the block
+		 * to make sure. */
+		if (filp->f_version != inode->i_version) {
+			for (i = 0; i < inode->i_size && i < offset; ) {
+				de = (struct ext4_dir_entry_2 *)
+					(inline_pos + i);
+				/* It's too expensive to do a full
+				 * dirent test each time round this
+				 * loop, but we do have to test at
+				 * least that it is non-zero.  A
+				 * failure will be detected in the
+				 * dirent test below. */
+				if (ext4_rec_len_from_disk(de->rec_len,
+					inline_size) < EXT4_DIR_REC_LEN(1))
+					break;
+				i += ext4_rec_len_from_disk(de->rec_len,
+							    inline_size);
+			}
+			offset = i;
+			filp->f_pos = offset;
+			filp->f_version = inode->i_version;
+		}
+
+		while (!error && filp->f_pos < inode->i_size
+		       && offset < inline_size) {
+			de = (struct ext4_dir_entry_2 *) (inline_pos + offset);
+			if (ext4_check_dir_entry(inode, filp, de,
+						 iloc.bh, inline_pos,
+						 inline_size, offset)) {
+				ret = stored;
+				goto out;
+			}
+			offset += ext4_rec_len_from_disk(de->rec_len,
+							 inline_size);
+			if (le32_to_cpu(de->inode)) {
+				/* We might block in the next section
+				 * if the data destination is
+				 * currently swapped out.  So, use a
+				 * version stamp to detect whether or
+				 * not the directory has been modified
+				 * during the copy operation.
+				 */
+				u64 version = filp->f_version;
+
+				error = filldir(dirent, de->name,
+						de->name_len,
+						filp->f_pos,
+						le32_to_cpu(de->inode),
+						get_dtype(sb, de->file_type));
+				if (error)
+					break;
+				if (version != filp->f_version)
+					goto revalidate;
+				stored++;
+			}
+			filp->f_pos += ext4_rec_len_from_disk(de->rec_len,
+							      inline_size);
+		}
+		offset = 0;
+	}
+out:
+	brelse(iloc.bh);
+	return ret;
+}
+
 static int ext4_readdir(struct file *filp,
 			 void *dirent, filldir_t filldir)
 {
@@ -122,6 +220,9 @@ static int ext4_readdir(struct file *filp,
 
 	sb = inode->i_sb;
 
+	if (ext4_has_inline_data(inode))
+		return ext4_read_inline_dir(filp, dirent, filldir);
+
 	if (EXT4_HAS_COMPAT_FEATURE(inode->i_sb,
 				    EXT4_FEATURE_COMPAT_DIR_INDEX) &&
 	    ((ext4_test_inode_flag(inode, EXT4_INODE_INDEX)) ||
-- 
1.7.0.4

