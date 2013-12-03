From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v2 07/28] libext2fs: free key/value pairs before reading
Date: Tue,  3 Dec 2013 20:11:34 +0800
Message-ID: <1386072715-9869-8-git-send-email-wenqing.lz@taobao.com>
References: <1386072715-9869-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:60267 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329Ab3LCMJX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Dec 2013 07:09:23 -0500
Received: by mail-pd0-f170.google.com with SMTP id g10so20088906pdj.1
        for <linux-ext4@vger.kernel.org>; Tue, 03 Dec 2013 04:09:23 -0800 (PST)
In-Reply-To: <1386072715-9869-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

Before loading extended attributes, free any key/value pairs that
might already be associated with the file.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/ext_attr.c |   26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index 934ad6f..0e9a9ab 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -654,6 +654,20 @@ static errcode_t read_xattrs_from_buffer(struct ext2_xattr_handle *handle,
 	return 0;
 }
 
+static void xattrs_free_keys(struct ext2_xattr_handle *h)
+{
+	struct ext2_xattr *a = h->attrs;
+	size_t i;
+
+	for (i = 0; i < h->length; i++) {
+		if (a[i].name)
+			ext2fs_free_mem(&a[i].name);
+		if (a[i].value)
+			ext2fs_free_mem(&a[i].value);
+	}
+	h->count = 0;
+}
+
 errcode_t ext2fs_xattrs_read(struct ext2_xattr_handle *handle)
 {
 	struct ext2_xattr *attrs = NULL, *x;
@@ -679,6 +693,8 @@ errcode_t ext2fs_xattrs_read(struct ext2_xattr_handle *handle)
 	if (err)
 		goto out;
 
+	xattrs_free_keys(handle);
+
 	/* Does the inode have size for EA? */
 	if (EXT2_INODE_SIZE(handle->fs->super) <= EXT2_GOOD_OLD_INODE_SIZE +
 						  inode->i_extra_isize +
@@ -919,9 +935,7 @@ errcode_t ext2fs_xattrs_open(ext2_filsys fs, ext2_ino_t ino,
 
 errcode_t ext2fs_xattrs_close(struct ext2_xattr_handle **handle)
 {
-	unsigned int i;
 	struct ext2_xattr_handle *h = *handle;
-	struct ext2_xattr *a = h->attrs;
 	errcode_t err;
 
 	if (h->dirty) {
@@ -930,13 +944,7 @@ errcode_t ext2fs_xattrs_close(struct ext2_xattr_handle **handle)
 			return err;
 	}
 
-	for (i = 0; i < h->length; i++) {
-		if (a[i].name)
-			ext2fs_free_mem(&a[i].name);
-		if (a[i].value)
-			ext2fs_free_mem(&a[i].value);
-	}
