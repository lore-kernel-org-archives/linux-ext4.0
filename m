From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v3 02/30] libext2fs: various tweaks to the xattr editor APIs
Date: Fri,  6 Dec 2013 17:57:49 +0800
Message-ID: <1386323897-2354-3-git-send-email-wenqing.lz@taobao.com>
References: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:57427 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab3LFJz1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Dec 2013 04:55:27 -0500
Received: by mail-pb0-f41.google.com with SMTP id jt11so798451pbb.0
        for <linux-ext4@vger.kernel.org>; Fri, 06 Dec 2013 01:55:27 -0800 (PST)
In-Reply-To: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

A few tweaks to the extended attribute editing APIs:

 * Use size_t, not unsigned int, in the new extended attribute editing
   API.

 * Don't expose the _expand() call since there should be no external
   users.

 * Add a function to return the number of attributes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/ext2fs.h   |    8 +++-----
 lib/ext2fs/ext_attr.c |   16 ++++++++--------
 2 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 30bd4cf..57db793 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1149,20 +1149,18 @@ extern errcode_t ext2fs_adjust_ea_refcount3(ext2_filsys fs, blk64_t blk,
 					   char *block_buf,
 					   int adjust, __u32 *newcount,
 					   ext2_ino_t inum);
-errcode_t ext2fs_xattrs_expand(struct ext2_xattr_handle *h,
-			       unsigned int expandby);
 errcode_t ext2fs_xattrs_write(struct ext2_xattr_handle *handle);
 errcode_t ext2fs_xattrs_read(struct ext2_xattr_handle *handle);
 errcode_t ext2fs_xattrs_iterate(struct ext2_xattr_handle *h,
 				int (*func)(char *name, char *value,
-					    void *data),
+					    size_t value_len, void *data),
 				void *data);
 errcode_t ext2fs_xattr_get(struct ext2_xattr_handle *h, const char *key,
-			   void **value, unsigned int *value_len);
+			   void **value, size_t *value_len);
 errcode_t ext2fs_xattr_set(struct ext2_xattr_handle *handle,
 			   const char *key,
 			   const void *value,
-			   unsigned int value_len);
+			   size_t value_len);
 errcode_t ext2fs_xattr_remove(struct ext2_xattr_handle *handle,
 			      const char *key);
 errcode_t ext2fs_xattrs_open(ext2_filsys fs, ext2_ino_t ino,
diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index c54925f..fa082ad 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -191,19 +191,19 @@ errcode_t ext2fs_adjust_ea_refcount(ext2_filsys fs, blk_t blk,
 struct ext2_xattr {
 	char *name;
 	void *value;
-	unsigned int value_len;
+	size_t value_len;
 };
 
 struct ext2_xattr_handle {
 	ext2_filsys fs;
 	struct ext2_xattr *attrs;
-	unsigned int length;
+	size_t length;
 	ext2_ino_t ino;
 	int dirty;
 };
 
-errcode_t ext2fs_xattrs_expand(struct ext2_xattr_handle *h,
-			       unsigned int expandby)
+static errcode_t ext2fs_xattrs_expand(struct ext2_xattr_handle *h,
+				      unsigned int expandby)
 {
 	struct ext2_xattr *new_attrs;
 	errcode_t err;
@@ -767,7 +767,7 @@ out:
 #define XATTR_CHANGED	2
 errcode_t ext2fs_xattrs_iterate(struct ext2_xattr_handle *h,
 				int (*func)(char *name, char *value,
-					    void *data),
+					    size_t value_len, void *data),
 				void *data)
 {
 	struct ext2_xattr *x;
@@ -778,7 +778,7 @@ errcode_t ext2fs_xattrs_iterate(struct ext2_xattr_handle *h,
 		if (!x->name)
 			continue;
 
-		ret = func(x->name, x->value, data);
+		ret = func(x->name, x->value, x->value_len, data);
 		if (ret & XATTR_CHANGED)
 			h->dirty = 1;
 		if (ret & XATTR_ABORT)
@@ -789,7 +789,7 @@ errcode_t ext2fs_xattrs_iterate(struct ext2_xattr_handle *h,
 }
 
 errcode_t ext2fs_xattr_get(struct ext2_xattr_handle *h, const char *key,
-			   void **value, unsigned int *value_len)
+			   void **value, size_t *value_len)
 {
 	struct ext2_xattr *x;
 	void *val;
@@ -816,7 +816,7 @@ errcode_t ext2fs_xattr_get(struct ext2_xattr_handle *h, const char *key,
 errcode_t ext2fs_xattr_set(struct ext2_xattr_handle *handle,
 			   const char *key,
 			   const void *value,
-			   unsigned int value_len)
+			   size_t value_len)
 {
 	struct ext2_xattr *x, *last_empty;
 	char *new_value;
-- 
1.7.9.7

