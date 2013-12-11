From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 60/74] libext2fs: ensure that inline data is always written to
 ibody
Date: Tue, 10 Dec 2013 17:24:58 -0800
Message-ID: <20131211012458.30655.66423.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43815 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab3LKBZF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:25:05 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When writing xattrs to disk, move the inline_data attribute to the
front of the list so that inline data always ends up in the inode body
(and not a separate EA block).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/ext_attr.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)


diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index e69275e..50f7300 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -238,6 +238,24 @@ static struct ea_name_index ea_names[] = {
 	{0, NULL},
 };
 
+static void move_inline_data_to_front(struct ext2_xattr_handle *h)
+{
+	struct ext2_xattr *x;
+	struct ext2_xattr tmp;
+
+	for (x = h->attrs + 1; x < h->attrs + h->length; x++) {
+		if (!x->name)
+			continue;
+
+		if (strcmp(x->name, "system.data") == 0) {
+			memcpy(&tmp, x, sizeof(tmp));
+			memcpy(x, h->attrs, sizeof(tmp));
+			memcpy(h->attrs, &tmp, sizeof(tmp));
+			return;
+		}
+	}
+}
+
 static const char *find_ea_prefix(int index)
 {
 	struct ea_name_index *e;
@@ -484,6 +502,8 @@ errcode_t ext2fs_xattrs_write(struct ext2_xattr_handle *handle)
 	if (err)
 		goto out;
 
+	move_inline_data_to_front(handle);
+
 	x = handle->attrs;
 	/* Does the inode have size for EA? */
 	if (EXT2_INODE_SIZE(handle->fs->super) <= EXT2_GOOD_OLD_INODE_SIZE +

