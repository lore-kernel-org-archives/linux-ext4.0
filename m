From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext4: Fix the complie warning if CONFIG_EXT4_FS_XATTR isn't set.
Date: Wed,  5 Dec 2012 21:36:23 +0800
Message-ID: <1354714583-3187-1-git-send-email-tm@tao.ma>
Cc: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy12-pub.bluehost.com ([50.87.16.10]:33555 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932067Ab2LENgl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Dec 2012 08:36:41 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

Fix the compile warning created by copy/paste.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/xattr.h |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 39ef0d6..f959e6c 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -261,9 +261,10 @@ ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
 	return -EOPNOTSUPP;
 }
 
-extern int ext4_xattr_ibody_get(struct inode *inode, int name_index,
-				const char *name,
-				void *buffer, size_t buffer_size)
+static inline int
+ext4_xattr_ibody_get(struct inode *inode, int name_index,
+		     const char *name,
+		     void *buffer, size_t buffer_size)
 {
 	return -EOPNOTSUPP;
 }
@@ -377,13 +378,15 @@ static inline int ext4_read_inline_dir(struct file *filp,
 	return 0;
 }
 
-struct buffer_head *ext4_find_inline_entry(struct inode *dir,
-					const struct qstr *d_name,
-					struct ext4_dir_entry_2 **res_dir,
-					int *has_inline_data)
+static inline struct buffer_head *
+ext4_find_inline_entry(struct inode *dir,
+		       const struct qstr *d_name,
+		       struct ext4_dir_entry_2 **res_dir,
+		       int *has_inline_data)
 {
 	return NULL;
 }
+
 static inline int ext4_delete_inline_entry(handle_t *handle,
 					   struct inode *dir,
 					   struct ext4_dir_entry_2 *de_del,
@@ -419,7 +422,7 @@ static inline void ext4_inline_data_truncate(struct inode *inode,
 	return;
 }
 
-static int ext4_convert_inline_data(struct inode *inode)
+static inline int ext4_convert_inline_data(struct inode *inode)
 {
 	return 0;
 }
-- 
1.7.1

