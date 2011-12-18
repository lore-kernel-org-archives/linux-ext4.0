From: Tao Ma <tm@tao.ma>
Subject: [PATCH V3 16/21] ext4: let ext4_delete_entry handle inline data.
Date: Sun, 18 Dec 2011 22:24:33 +0800
Message-ID: <1324218278-2460-16-git-send-email-tm@tao.ma>
References: <4EEDF6B1.7050206@tao.ma>
 <1324218278-2460-1-git-send-email-tm@tao.ma>
Cc: adilger@dilger.ca, tytso@mit.edu, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:33777 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751515Ab1LROgj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 18 Dec 2011 09:36:39 -0500
In-Reply-To: <1324218278-2460-1-git-send-email-tm@tao.ma>
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
index 7e80416..1d5cfd0 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1374,6 +1374,57 @@ out_find:
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
+					inline_start, inline_size);
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
index f706b0f..cefcec6 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1741,6 +1741,15 @@ static int ext4_delete_entry(handle_t *handle,
 {
 	int err;
 
+	if (ext4_has_inline_data(dir)) {
+		err = ext4_delete_inline_entry(handle, dir, de_del, bh);
+		if (err) {
+			if (err == 1)
+				err = 0;
+			return err;
+		}
+	}
+
 	BUFFER_TRACE(bh, "get_write_access");
 	err = ext4_journal_get_write_access(handle, bh);
 	if (unlikely(err))
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 45f3ce9..e26b7a6 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -172,6 +172,10 @@ extern struct buffer_head *ext4_find_inline_entry(struct inode *dir,
 					const struct qstr *d_name,
 					struct ext4_dir_entry_2 **res_dir,
 					int *has_inline_data);
+extern int ext4_delete_inline_entry(handle_t *handle,
+				    struct inode *dir,
+				    struct ext4_dir_entry_2 *de_del,
+				    struct buffer_head *bh);
 # else  /* CONFIG_EXT4_FS_XATTR */
 
 static inline int
@@ -362,6 +366,13 @@ struct buffer_head *ext4_find_inline_entry(struct inode *dir,
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

