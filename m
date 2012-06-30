From: Tao Ma <tm@tao.ma>
Subject: [PATCH V5 17/23] ext4: let empty_dir handle inline dir.
Date: Sat, 30 Jun 2012 23:45:18 +0800
Message-ID: <1341071124-4976-17-git-send-email-tm@tao.ma>
References: <1341070917-4889-1-git-send-email-tm@tao.ma>
 <1341071124-4976-1-git-send-email-tm@tao.ma>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:39982 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754103Ab2F3Pt4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 30 Jun 2012 11:49:56 -0400
Received: from [221.217.40.18] (port=40170 helo=localhost.localdomain)
	by box585.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.76)
	(envelope-from <tm@tao.ma>)
	id 1SkzuF-0006eg-4k
	for linux-ext4@vger.kernel.org; Sat, 30 Jun 2012 09:48:20 -0600
In-Reply-To: <1341071124-4976-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

empty_dir is used when deleting a dir. So it should handle
inline dir properly.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/inline.c |   69 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/namei.c  |    8 ++++++
 fs/ext4/xattr.h  |    6 ++++
 3 files changed, 83 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 5383487..025a9f3 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1529,6 +1529,75 @@ out:
 	return err;
 }
 
+int empty_inline_dir(struct inode *dir, int *has_inline_data)
+{
+	int err, inline_size;
+	struct ext4_iloc iloc;
+	void *inline_pos;
+	unsigned int offset;
+	struct ext4_dir_entry_2 *de, *de1;
+	int ret = 1;
+
+	err = ext4_get_inode_loc(dir, &iloc);
+	if (err) {
+		EXT4_ERROR_INODE(dir, "error %d getting inode %lu block",
+				 err, dir->i_ino);
+		return 1;
+	}
+
+	down_read(&EXT4_I(dir)->xattr_sem);
+	if (!ext4_has_inline_data(dir)) {
+		*has_inline_data = 0;
+		goto out;
+	}
+
+	de = ext4_get_inline_entry(dir, &iloc, 0,
+				   &inline_pos, &inline_size);
+	de1 = ext4_get_inline_entry(dir, &iloc,
+			ext4_rec_len_from_disk(de->rec_len, inline_size),
+			&inline_pos, &inline_size);
+	if (le32_to_cpu(de->inode) != dir->i_ino ||
+			!le32_to_cpu(de1->inode) ||
+			strcmp(".", de->name) ||
+			strcmp("..", de1->name)) {
+		ext4_warning(dir->i_sb,
+			     "bad directory (dir #%lu) - no `.' or `..'",
+			     dir->i_ino);
+		ret = 1;
+		goto out;
+	}
+
+	offset = ext4_rec_len_from_disk(de->rec_len, inline_size) +
+		 ext4_rec_len_from_disk(de1->rec_len, inline_size);
+	while (offset < dir->i_size) {
+		de = ext4_get_inline_entry(dir, &iloc, offset,
+					   &inline_pos, &inline_size);
+		if (ext4_check_dir_entry(dir, NULL, de,
+					 iloc.bh, inline_pos,
+					 inline_size, offset)) {
+			ext4_warning(dir->i_sb,
+				     "bad inline directory (dir #%lu) - "
+				     "inode %u, rec_len %u, name_len %d"
+				     "inline size %d\n",
+				     dir->i_ino, le32_to_cpu(de->inode),
+				     le16_to_cpu(de->rec_len), de->name_len,
+				     inline_size);
+			ret = 1;
+			goto out;
+		}
+		if (le32_to_cpu(de->inode)) {
+			ret = 0;
+			goto out;
+		}
+		offset += ext4_rec_len_from_disk(de->rec_len, inline_size);
+	}
+
+out:
+	up_read(&EXT4_I(dir)->xattr_sem);
+	brelse(iloc.bh);
+	return ret;
+}
+
 int ext4_destroy_inline_data(handle_t *handle, struct inode *inode)
 {
 	int ret;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 9e47412..93dee3a 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2380,6 +2380,14 @@ static int empty_dir(struct inode *inode)
 	struct super_block *sb;
 	int err = 0;
 
+	if (ext4_has_inline_data(inode)) {
+		int has_inline_data = 1;
+
+		err = empty_inline_dir(inode, &has_inline_data);
+		if (has_inline_data)
+			return err;
+	}
+
 	sb = inode->i_sb;
 	if (inode->i_size < EXT4_DIR_REC_LEN(1) + EXT4_DIR_REC_LEN(2) ||
 	    !(bh = ext4_bread(NULL, inode, 0, 0, &err))) {
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index a4319ad..0063bee 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -178,6 +178,7 @@ extern int ext4_delete_inline_entry(handle_t *handle,
 				    struct inode *dir,
 				    struct ext4_dir_entry_2 *de_del,
 				    struct buffer_head *bh);
+extern int empty_inline_dir(struct inode *dir, int *has_inline_data);
 # else  /* CONFIG_EXT4_FS_XATTR */
 
 static inline int
@@ -375,6 +376,11 @@ static inline int ext4_delete_inline_entry(handle_t *handle,
 {
 	return 0;
 }
+
+static inline int empty_inline_dir(struct inode *dir, int *has_inline_data)
+{
+	return 0;
+}
 # endif  /* CONFIG_EXT4_FS_XATTR */
 
 #ifdef CONFIG_EXT4_FS_SECURITY
-- 
1.7.0.4

