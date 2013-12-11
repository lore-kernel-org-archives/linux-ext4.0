From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 58/74] libext2fs: free key/value pairs before reading
Date: Tue, 10 Dec 2013 17:24:45 -0800
Message-ID: <20131211012445.30655.26989.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43759 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab3LKBYw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:24:52 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Before loading extended attributes, free any key/value pairs that
might already be associated with the file.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/ext_attr.c |   26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)


diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index 772bb07..e69275e 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -656,6 +656,20 @@ static errcode_t read_xattrs_from_buffer(struct ext2_xattr_handle *handle,
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
@@ -681,6 +695,8 @@ errcode_t ext2fs_xattrs_read(struct ext2_xattr_handle *handle)
 	if (err)
 		goto out;
 
+	xattrs_free_keys(handle);
+
 	/* Does the inode have size for EA? */
 	if (EXT2_INODE_SIZE(handle->fs->super) <= EXT2_GOOD_OLD_INODE_SIZE +
 						  inode->i_extra_isize +
@@ -927,9 +943,7 @@ errcode_t ext2fs_xattrs_open(ext2_filsys fs, ext2_ino_t ino,
 
 errcode_t ext2fs_xattrs_close(struct ext2_xattr_handle **handle)
 {
-	unsigned int i;
 	struct ext2_xattr_handle *h = *handle;
-	struct ext2_xattr *a = h->attrs;
 	errcode_t err;
 
 	if (h->dirty) {
@@ -938,13 +952,7 @@ errcode_t ext2fs_xattrs_close(struct ext2_xattr_handle **handle)
 			return err;
 	}
 
-	for (i = 0; i < h->length; i++) {
-		if (a[i].name)
-			ext2fs_free_mem(&a[i].name);
-		if (a[i].value)
-			ext2fs_free_mem(&a[i].value);
-	}
