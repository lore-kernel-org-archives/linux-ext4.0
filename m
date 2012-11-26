From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 5/6 -v2] libext2fs: optimize rb_get_bmap_range() for mostly allocated bmaps
Date: Mon, 26 Nov 2012 11:39:39 -0500
Message-ID: <1353947981-15219-6-git-send-email-tytso@mit.edu>
References: <1353947981-15219-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34891 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754972Ab2KZQpw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Nov 2012 11:45:52 -0500
In-Reply-To: <1353947981-15219-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This optimizies the CPU utilization of the rb_get_bmap_range()
function when most of the bitmap is allocated.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Lukas Czerner <lczerner@redhat.com>
---
 lib/ext2fs/blkmap64_rb.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/lib/ext2fs/blkmap64_rb.c b/lib/ext2fs/blkmap64_rb.c
index eb56c85..7196e90 100644
--- a/lib/ext2fs/blkmap64_rb.c
+++ b/lib/ext2fs/blkmap64_rb.c
@@ -721,6 +721,7 @@ static errcode_t rb_get_bmap_range(ext2fs_generic_bitmap bitmap,
 	struct rb_node *parent = NULL, *next, **n;
 	struct ext2fs_rb_private *bp;
 	struct bmap_rb_extent *ext;
+	int count;
 	__u64 pos;
 
 	bp = (struct ext2fs_rb_private *) bitmap->private;
@@ -748,14 +749,32 @@ static errcode_t rb_get_bmap_range(ext2fs_generic_bitmap bitmap,
 		ext = ext2fs_rb_entry(parent, struct bmap_rb_extent, node);
 
 		pos = ext->start;
-		if (pos < start)
+		count = ext->count;
+		if (pos >= start + num)
+			break;
+		if (pos < start) {
+			count -= start - pos;
+			if (count < 0)
+				continue;
 			pos = start;
-
-		while (pos < (ext->start + ext->count)) {
-			if ((pos - start) >= num)
-				return 0;
+		}
+		if (pos + count > start + num)
+			count = start + num - pos;
+
+		while (count > 0) {
+			if ((count >= 8) &&
+			    ((pos - start) % 8) == 0) {
+				int nbytes = count >> 3;
+				int offset = (pos - start) >> 3;
+
+				memset(out + offset, 0xFF, nbytes);
+				pos += nbytes << 3;
+				count -= nbytes << 3;
+				continue;
+			}
 			ext2fs_fast_set_bit64((pos - start), out);
 			pos++;
+			count--;
 		}
 	}
 	return 0;
-- 
1.7.12.rc0.22.gcdd159b

