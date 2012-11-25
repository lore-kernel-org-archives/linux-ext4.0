From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/6] libext2fs: optimize rb_set_bmap_range()
Date: Sat, 24 Nov 2012 19:36:29 -0500
Message-ID: <1353803794-11593-2-git-send-email-tytso@mit.edu>
References: <1353803794-11593-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34500 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678Ab2KYAgh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 24 Nov 2012 19:36:37 -0500
In-Reply-To: <1353803794-11593-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This speeds up reading bitmaps from disk for very large (and full)
disks by significant amounts (i.e., up to two CPU minutes for a 4T
file system).

Addresses-Google-Bug: #7534813

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/blkmap64_rb.c | 32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/lib/ext2fs/blkmap64_rb.c b/lib/ext2fs/blkmap64_rb.c
index a42eda1..816f44f 100644
--- a/lib/ext2fs/blkmap64_rb.c
+++ b/lib/ext2fs/blkmap64_rb.c
@@ -674,16 +674,42 @@ static errcode_t rb_set_bmap_range(ext2fs_generic_bitmap bitmap,
 				     __u64 start, size_t num, void *in)
 {
 	struct ext2fs_rb_private *bp;
+	unsigned char *cp;
 	size_t i;
+	int first_set = -1;
 	int ret;
 
 	bp = (struct ext2fs_rb_private *) bitmap->private;
 
 	for (i = 0; i < num; i++) {
-		ret = ext2fs_test_bit(i, in);
-		if (ret)
-			rb_insert_extent(start + i - bitmap->start, 1, bp);
+		if (i & 7 == 0) {
+			unsigned char c = cp[i/8];
+			if (c == 0xFF) {
+				if (first_set == -1)
+					first_set = i;
+				i += 7;
+				continue;
+			}
+			if ((c == 0x00) && (first_set == -1)) {
+				i += 7;
+				continue;
+			}
+		}
+		if (ext2fs_test_bit(i, in)) {
+			if (first_set == -1)
+				first_set = i;
+			continue;
+		}
+		if (first_set == -1)
+			continue;
+
+		rb_insert_extent(start + first_set - bitmap->start,
+				 i - first_set, bp);
+		first_set = -1;
 	}
+	if (first_set != -1)
+		rb_insert_extent(start + first_set - bitmap->start,
+				 num - first_set, bp);
 
 	return 0;
 }
-- 
1.7.12.rc0.22.gcdd159b

