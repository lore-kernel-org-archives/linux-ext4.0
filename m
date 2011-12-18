From: Tao Ma <tm@tao.ma>
Subject: [PATCH V3 14/21] ext4: let ext4_find_entry handle inline data.
Date: Sun, 18 Dec 2011 22:24:31 +0800
Message-ID: <1324218278-2460-14-git-send-email-tm@tao.ma>
References: <4EEDF6B1.7050206@tao.ma>
 <1324218278-2460-1-git-send-email-tm@tao.ma>
Cc: adilger@dilger.ca, tytso@mit.edu, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1324218278-2460-1-git-send-email-tm@tao.ma>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

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
index 0a41d64..7e80416 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1327,6 +1327,53 @@ out:
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
index 6e97dd2..92f7b67 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -844,7 +844,6 @@ static inline int search_dirblock(struct buffer_head *bh,
 			  d_name, offset, res_dir);
 }
 
-
 /*
  *	ext4_find_entry()
  *
@@ -879,6 +878,15 @@ static struct buffer_head * ext4_find_entry (struct inode *dir,
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
index e9e23ba..45f3ce9 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -168,6 +168,10 @@ extern int ext4_try_create_inline_dir(handle_t *handle,
 				      struct inode *inode);
 extern int ext4_read_inline_dir(struct file *filp,
 				void *dirent, filldir_t filldir);
+extern struct buffer_head *ext4_find_inline_entry(struct inode *dir,
+					const struct qstr *d_name,
+					struct ext4_dir_entry_2 **res_dir,
+					int *has_inline_data);
 # else  /* CONFIG_EXT4_FS_XATTR */
 
 static inline int
@@ -350,6 +354,14 @@ static inline int ext4_read_inline_dir(struct file *filp,
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
