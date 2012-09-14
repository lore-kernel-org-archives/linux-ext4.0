From: Tao Ma <tm@tao.ma>
Subject: [PATCH V6 14/23] ext4: let ext4_find_entry handle inline data.
Date: Fri, 14 Sep 2012 19:25:02 +0800
Message-ID: <1347621911-4104-14-git-send-email-tm@tao.ma>
References: <1347621512-3660-1-git-send-email-tm@tao.ma>
 <1347621911-4104-1-git-send-email-tm@tao.ma>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:45285 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753167Ab2INLeJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Sep 2012 07:34:09 -0400
Received: from [182.92.247.2] (port=60014 helo=tma-laptop1.taobao.ali.com)
	by box585.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.76)
	(envelope-from <tm@tao.ma>)
	id 1TCU1c-0001sO-R1
	for linux-ext4@vger.kernel.org; Fri, 14 Sep 2012 05:25:33 -0600
In-Reply-To: <1347621911-4104-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

Create a new ext4_find_inline_entry to handle the case
of inline data.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/inline.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/namei.c  |   10 +++++++++-
 fs/ext4/xattr.h  |   12 ++++++++++++
 3 files changed, 69 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 8270265..f205d09 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1456,6 +1456,54 @@ out:
 	return ret;
 }
 
+struct buffer_head *ext4_find_inline_entry(struct inode *dir,
+					const struct qstr *d_name,
+					struct ext4_dir_entry_2 **res_dir,
+					int *has_inline_data)
+{
+	int ret;
+	struct ext4_iloc iloc;
+	void *inline_start;
+	int inline_size;
+
+	if (ext4_get_inode_loc(dir, &iloc))
+		return NULL;
+
+	down_read(&EXT4_I(dir)->xattr_sem);
+	if (!ext4_has_inline_data(dir)) {
+		*has_inline_data = 0;
+		goto out;
+	}
+
+	inline_start = (void *)ext4_raw_inode(&iloc)->i_block +
+						EXT4_INLINE_DOTDOT_SIZE;
+	inline_size = EXT4_MIN_INLINE_DATA_SIZE - EXT4_INLINE_DOTDOT_SIZE;
+	ret = search_dir(iloc.bh, inline_start, inline_size,
+			 dir, d_name, 0, res_dir);
+	if (ret == 1)
+		goto out_find;
+	if (ret < 0)
+		goto out;
+
+	if (ext4_get_inline_size(dir) == EXT4_MIN_INLINE_DATA_SIZE)
+		goto out;
+
+	inline_start = ext4_get_inline_xattr_pos(dir, &iloc);
+	inline_size = ext4_get_inline_size(dir) - EXT4_MIN_INLINE_DATA_SIZE;
+
+	ret = search_dir(iloc.bh, inline_start, inline_size,
+			 dir, d_name, 0, res_dir);
+	if (ret == 1)
+		goto out_find;
+
+out:
+	brelse(iloc.bh);
+	iloc.bh = NULL;
+out_find:
+	up_read(&EXT4_I(dir)->xattr_sem);
+	return iloc.bh;
+}
+
 int ext4_destroy_inline_data(handle_t *handle, struct inode *inode)
 {
 	int ret;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index d3fc040..edcfee4 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1113,7 +1113,6 @@ static inline int search_dirblock(struct buffer_head *bh,
 			  d_name, offset, res_dir);
 }
 
-
 /*
  *	ext4_find_entry()
  *
@@ -1148,6 +1147,15 @@ static struct buffer_head * ext4_find_entry (struct inode *dir,
 	namelen = d_name->len;
 	if (namelen > EXT4_NAME_LEN)
 		return NULL;
+
+	if (ext4_has_inline_data(dir)) {
+		int has_inline_data = 1;
+		ret = ext4_find_inline_entry(dir, d_name, res_dir,
+					     &has_inline_data);
+		if (has_inline_data)
+			return ret;
+	}
+
 	if ((namelen <= 2) && (name[0] == '.') &&
 	    (name[1] == '.' || name[1] == '\0')) {
 		/*
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 7162662..01ab0b7 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -171,6 +171,10 @@ extern int ext4_try_create_inline_dir(handle_t *handle,
 extern int ext4_read_inline_dir(struct file *filp,
 				void *dirent, filldir_t filldir,
 				int *has_inline_data);
+extern struct buffer_head *ext4_find_inline_entry(struct inode *dir,
+					const struct qstr *d_name,
+					struct ext4_dir_entry_2 **res_dir,
+					int *has_inline_data);
 # else  /* CONFIG_EXT4_FS_XATTR */
 
 static inline int
@@ -354,6 +358,14 @@ static inline int ext4_read_inline_dir(struct file *filp,
 {
 	return 0;
 }
+
+struct buffer_head *ext4_find_inline_entry(struct inode *dir,
+					const struct qstr *d_name,
+					struct ext4_dir_entry_2 **res_dir,
+					int *has_inline_data)
+{
+	return NULL;
+}
 # endif  /* CONFIG_EXT4_FS_XATTR */
 
 #ifdef CONFIG_EXT4_FS_SECURITY
-- 
1.7.1

