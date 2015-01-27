From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 05/54] libext2fs: avoid pointless EA block allocation
Date: Mon, 26 Jan 2015 23:36:06 -0800
Message-ID: <20150127073606.13308.68905.stgit@birch.djwong.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32927 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbbA0HgL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jan 2015 02:36:11 -0500
In-Reply-To: <20150127073533.13308.44994.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use qsort to move the inlinedata attribute to the front of the list
and the empty entries to the end.  Then we can use handle->count to
decide if we're done writing xattrs, which helps us to avoid the
situation where we're midway through the attribute list, so we
allocate an EA block to store more, but have no idea that there's
actually nothing left in the list.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/ext_attr.c |   40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)


diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index c6fcf54..e8544dc 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -254,22 +254,20 @@ static struct ea_name_index ea_names[] = {
 	{0, NULL},
 };
 
-static void move_inline_data_to_front(struct ext2_xattr_handle *h)
+/* Push empty attributes to the end and inlinedata to the front. */
+static int attr_compare(const void *a, const void *b)
 {
-	struct ext2_xattr *x;
-	struct ext2_xattr tmp;
-
-	for (x = h->attrs + 1; x < h->attrs + h->length; x++) {
-		if (!x->name)
-			continue;
-
-		if (strcmp(x->name, "system.data") == 0) {
-			memcpy(&tmp, x, sizeof(tmp));
-			memcpy(x, h->attrs, sizeof(tmp));
-			memcpy(h->attrs, &tmp, sizeof(tmp));
-			return;
-		}
-	}
+	const struct ext2_xattr *xa = a, *xb = b;
+
+	if (xa->name == NULL)
+		return +1;
+	else if (xb->name == NULL)
+		return -1;
+	else if (!strcmp(xa->name, "system.data"))
+		return -1;
+	else if (!strcmp(xb->name, "system.data"))
+		return +1;
+	return 0;
 }
 
 static const char *find_ea_prefix(int index)
@@ -531,9 +529,13 @@ errcode_t ext2fs_xattrs_write(struct ext2_xattr_handle *handle)
 		inode->i_extra_isize = extra;
 	}
 
-	move_inline_data_to_front(handle);
-
+	/*
+	 * Force the inlinedata attr to the front and the empty entries
+	 * to the end.
+	 */
 	x = handle->attrs;
+	qsort(x, handle->length, sizeof(struct ext2_xattr), attr_compare);
+
 	/* Does the inode have size for EA? */
 	if (EXT2_INODE_SIZE(handle->fs->super) <= EXT2_GOOD_OLD_INODE_SIZE +
 						  inode->i_extra_isize +
@@ -554,11 +556,11 @@ errcode_t ext2fs_xattrs_write(struct ext2_xattr_handle *handle)
 	if (err)
 		goto out;
 
+write_ea_block:
 	/* Are we done? */
-	if (x == handle->attrs + handle->length)
+	if (x >= handle->attrs + handle->count)
 		goto skip_ea_block;
 
-write_ea_block:
 	/* Write the EA block */
 	err = ext2fs_get_memzero(handle->fs->blocksize, &block_buf);
 	if (err)

