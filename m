From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 56/74] libext2fs: various tweaks to the xattr editor APIs
Date: Tue, 10 Dec 2013 17:24:32 -0800
Message-ID: <20131211012432.30655.68629.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27294 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab3LKBYi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:24:38 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

A few tweaks to the extended attribute editing APIs:

 * Use size_t, not unsigned int, in the new extended attribute editing
   API.

 * Don't expose the _expand() call since there should be no external
   users.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/ext2fs.h   |    8 +++-----
 lib/ext2fs/ext_attr.c |   16 ++++++++--------
 2 files changed, 11 insertions(+), 13 deletions(-)


diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index f3cb3a0..9f631e6 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1159,20 +1159,18 @@ extern errcode_t ext2fs_adjust_ea_refcount3(ext2_filsys fs, blk64_t blk,
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
index 6eadca2..8101c7f 100644
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
@@ -756,7 +756,7 @@ out:
 
 errcode_t ext2fs_xattrs_iterate(struct ext2_xattr_handle *h,
 				int (*func)(char *name, char *value,
-					    void *data),
+					    size_t value_len, void *data),
 				void *data)
 {
 	struct ext2_xattr *x;
@@ -767,7 +767,7 @@ errcode_t ext2fs_xattrs_iterate(struct ext2_xattr_handle *h,
 		if (!x->name)
 			continue;
 
-		ret = func(x->name, x->value, data);
+		ret = func(x->name, x->value, x->value_len, data);
 		if (ret & XATTR_CHANGED)
 			h->dirty = 1;
 		if (ret & XATTR_ABORT)
@@ -778,7 +778,7 @@ errcode_t ext2fs_xattrs_iterate(struct ext2_xattr_handle *h,
 }
 
 errcode_t ext2fs_xattr_get(struct ext2_xattr_handle *h, const char *key,
-			   void **value, unsigned int *value_len)
+			   void **value, size_t *value_len)
 {
 	struct ext2_xattr *x;
 	void *val;
@@ -805,7 +805,7 @@ errcode_t ext2fs_xattr_get(struct ext2_xattr_handle *h, const char *key,
 errcode_t ext2fs_xattr_set(struct ext2_xattr_handle *handle,
 			   const char *key,
 			   const void *value,
-			   unsigned int value_len)
+			   size_t value_len)
 {
 	struct ext2_xattr *x, *last_empty;
 	char *new_value;

