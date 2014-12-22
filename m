From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 35/31] libext2fs: avoid pointless EA block allocation
Date: Mon, 22 Dec 2014 10:57:04 -0800
Message-ID: <20141222185704.GJ5368@birch.djwong.org>
References: <20141220211640.25563.80596.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46838 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555AbaLVS5J (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Dec 2014 13:57:09 -0500
Content-Disposition: inline
In-Reply-To: <20141220211640.25563.80596.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use qsort to move the inlinedata attribute to the front of the list
and the empty entries to the end.  Then we can use handle->count to
decide if we're done writing xattrs, which helps us to avoid the
situation where we're midway through the attribute list so we
allocate an EA block to store more, but have no idea that there's
actually nothing left in the list.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/ext_attr.c |   40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index 551c1f2..8210814 100644
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
@@ -530,9 +528,13 @@ errcode_t ext2fs_xattrs_write(struct ext2_xattr_handle *handle)
 		inode->i_extra_isize = extra;
 	}
 
-	move_inline_data_to_front(handle);
