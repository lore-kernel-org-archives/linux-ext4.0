From: Tao Ma <tm@tao.ma>
Subject: [PATCH V5 14/23] ext4: let ext4_find_entry handle inline data.
Date: Sat, 30 Jun 2012 23:45:15 +0800
Message-ID: <1341071124-4976-14-git-send-email-tm@tao.ma>
References: <1341070917-4889-1-git-send-email-tm@tao.ma>
 <1341071124-4976-1-git-send-email-tm@tao.ma>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:40502 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754274Ab2F3Pt6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 30 Jun 2012 11:49:58 -0400
Received: from [221.217.40.18] (port=40170 helo=localhost.localdomain)
	by box585.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.76)
	(envelope-from <tm@tao.ma>)
	id 1Skzu7-0006eg-F9
	for linux-ext4@vger.kernel.org; Sat, 30 Jun 2012 09:48:12 -0600
In-Reply-To: <1341071124-4976-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

Create a new ext4_find_inline_entry to handle the case
of inline data.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/inline.c |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/namei.c  |   10 +++++++++-
 fs/ext4/xattr.h  |   12 ++++++++++++
 3 files changed, 68 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 0315ce6..2085bdd 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1431,6 +1431,53 @@ out:
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
+	inline_start = ext4_raw_inode(&iloc)->i_block;
+	inline_size = EXT4_MIN_INLINE_DATA_SIZE;
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
index ddb38cd..3cff036 100644
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
index 0c8285f..46030f0 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -170,6 +170,10 @@ extern int ext4_try_create_inline_dir(handle_t *handle,
 				      struct inode *inode);
 extern int ext4_read_inline_dir(struct file *filp,
 				void *dirent, filldir_t filldir);
+extern struct buffer_head *ext4_find_inline_entry(struct inode *dir,
+					const struct qstr *d_name,
+					struct ext4_dir_entry_2 **res_dir,
+					int *has_inline_data);
 # else  /* CONFIG_EXT4_FS_XATTR */
 
 static inline int
@@ -352,6 +356,14 @@ static inline int ext4_read_inline_dir(struct file *filp,
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
1.7.0.4

