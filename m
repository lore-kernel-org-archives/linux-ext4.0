From: Tao Ma <tm@tao.ma>
Subject: [PATCH V5 16/23] ext4: let ext4_delete_entry handle inline data.
Date: Sat, 30 Jun 2012 23:45:17 +0800
Message-ID: <1341071124-4976-16-git-send-email-tm@tao.ma>
References: <1341070917-4889-1-git-send-email-tm@tao.ma>
 <1341071124-4976-1-git-send-email-tm@tao.ma>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:52482 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755645Ab2F3Pt5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 30 Jun 2012 11:49:57 -0400
Received: from [221.217.40.18] (port=40170 helo=localhost.localdomain)
	by box585.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.76)
	(envelope-from <tm@tao.ma>)
	id 1SkzuC-0006eg-NF
	for linux-ext4@vger.kernel.org; Sat, 30 Jun 2012 09:48:17 -0600
In-Reply-To: <1341071124-4976-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/inline.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/namei.c  |    9 +++++++++
 fs/ext4/xattr.h  |   11 +++++++++++
 3 files changed, 71 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 2085bdd..5383487 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1478,6 +1478,57 @@ out_find:
 	return iloc.bh;
 }
 
+int ext4_delete_inline_entry(handle_t *handle,
+			     struct inode *dir,
+			     struct ext4_dir_entry_2 *de_del,
+			     struct buffer_head *bh)
+{
+	int err, inline_size;
+	struct ext4_iloc iloc;
+	void *inline_start;
+
+	err = ext4_get_inode_loc(dir, &iloc);
+	if (err)
+		return err;
+
+	down_write(&EXT4_I(dir)->xattr_sem);
+	if (!ext4_has_inline_data(dir))
+		goto out;
+
+	if ((void *)de_del - ((void *)ext4_raw_inode(&iloc)->i_block) <
+		EXT4_MIN_INLINE_DATA_SIZE) {
+		inline_start = ext4_raw_inode(&iloc)->i_block;
+		inline_size = EXT4_MIN_INLINE_DATA_SIZE;
+	} else {
+		inline_start = ext4_get_inline_xattr_pos(dir, &iloc);
+		inline_size = ext4_get_inline_size(dir) -
+				EXT4_MIN_INLINE_DATA_SIZE;
+	}
+
+	err = ext4_journal_get_write_access(handle, bh);
+	if (err)
+		goto out;
+
+	err = ext4_generic_delete_entry(handle, dir, de_del, bh,
+					inline_start, inline_size, 0);
+	if (err)
+		goto out;
+
+	BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
+	err = ext4_mark_inode_dirty(handle, dir);
+	if (unlikely(err))
+		goto out;
+
+	ext4_show_inline_dir(dir, iloc.bh, inline_start, inline_size);
+	err = 1;
+out:
+	up_write(&EXT4_I(dir)->xattr_sem);
+	brelse(iloc.bh);
+	if (err != 1 && err != -ENOENT)
+		ext4_std_error(dir->i_sb, err);
+	return err;
+}
+
 int ext4_destroy_inline_data(handle_t *handle, struct inode *inode)
 {
 	int ret;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index b39da8b..9e47412 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2086,6 +2086,15 @@ static int ext4_delete_entry(handle_t *handle,
 {
 	int err, csum_size = 0;
 
+	if (ext4_has_inline_data(dir)) {
+		err = ext4_delete_inline_entry(handle, dir, de_del, bh);
+		if (err) {
+			if (err == 1)
+				err = 0;
+			return err;
+		}
+	}
+
 	if (EXT4_HAS_RO_COMPAT_FEATURE(dir->i_sb,
 				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
 		csum_size = sizeof(struct ext4_dir_entry_tail);
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 46030f0..a4319ad 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -174,6 +174,10 @@ extern struct buffer_head *ext4_find_inline_entry(struct inode *dir,
 					const struct qstr *d_name,
 					struct ext4_dir_entry_2 **res_dir,
 					int *has_inline_data);
+extern int ext4_delete_inline_entry(handle_t *handle,
+				    struct inode *dir,
+				    struct ext4_dir_entry_2 *de_del,
+				    struct buffer_head *bh);
 # else  /* CONFIG_EXT4_FS_XATTR */
 
 static inline int
@@ -364,6 +368,13 @@ struct buffer_head *ext4_find_inline_entry(struct inode *dir,
 {
 	return NULL;
 }
+static inline int ext4_delete_inline_entry(handle_t *handle,
+					   struct inode *dir,
+					   struct ext4_dir_entry_2 *de_del,
+					   struct buffer_head *bh)
+{
+	return 0;
+}
 # endif  /* CONFIG_EXT4_FS_XATTR */
 
 #ifdef CONFIG_EXT4_FS_SECURITY
-- 
1.7.0.4

