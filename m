From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v3 07/30] libext2fs: free key/value pairs before reading
Date: Fri,  6 Dec 2013 17:57:54 +0800
Message-ID: <1386323897-2354-8-git-send-email-wenqing.lz@taobao.com>
References: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:40372 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756253Ab3LFJzk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Dec 2013 04:55:40 -0500
Received: by mail-pb0-f45.google.com with SMTP id rp16so785294pbb.18
        for <linux-ext4@vger.kernel.org>; Fri, 06 Dec 2013 01:55:39 -0800 (PST)
In-Reply-To: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
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
index 1b65c4b..09e13b2 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -658,6 +658,20 @@ static errcode_t read_xattrs_from_buffer(struct ext2_xattr_handle *handle,
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
@@ -687,6 +701,8 @@ errcode_t ext2fs_xattrs_read(struct ext2_xattr_handle *handle)
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
