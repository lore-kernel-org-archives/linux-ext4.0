From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4/6] libext2fs: optimize rb_get_bmap_range()
Date: Sat, 24 Nov 2012 19:36:32 -0500
Message-ID: <1353803794-11593-5-git-send-email-tytso@mit.edu>
References: <1353803794-11593-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34504 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732Ab2KYAgk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 24 Nov 2012 19:36:40 -0500
In-Reply-To: <1353803794-11593-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This simplifies the rb_get_bmap_range() function and speeds it up for
the case where most of the bitmap is zero.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/blkmap64_rb.c | 25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/lib/ext2fs/blkmap64_rb.c b/lib/ext2fs/blkmap64_rb.c
index 816f44f..0705cf2 100644
--- a/lib/ext2fs/blkmap64_rb.c
+++ b/lib/ext2fs/blkmap64_rb.c
@@ -741,32 +741,23 @@ static errcode_t rb_get_bmap_range(ext2fs_generic_bitmap bitmap,
 			break;
 	}
 
-	pos = start;
+	memset(out, 0, (num + 7) >> 3);
+
 	for (; parent != NULL; parent = next) {
 		next = ext2fs_rb_next(parent);
 		ext = ext2fs_rb_entry(parent, struct bmap_rb_extent, node);
 
-		while (((pos - start) < num) &&
-			(pos < ext->start)) {
-			ext2fs_fast_clear_bit64((pos - start), out);
-			pos++;
-		}
-
-		if ((pos - start) >= num)
-			return 0;
+		pos = ext->start;
+		if (pos < start)
+			pos = start;
 
-		while (((pos - start) < num) &&
-			(pos < (ext->start + ext->count))) {
+		while (pos < (ext->start + ext->count)) {
+			if ((pos - start) >= num)
+				return 0;
 			ext2fs_fast_set_bit64((pos - start), out);
 			pos++;
 		}
 	}
-
-	while ((pos - start) < num) {
-		ext2fs_fast_clear_bit64((pos - start), out);
-		pos++;
-	}
