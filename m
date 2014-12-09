From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] ext2fs: fix integer overflow in rb_get_bmap_range
Date: Tue,  9 Dec 2014 23:30:16 +0400
Message-ID: <1418153416-17750-1-git-send-email-dmonakhov@openvz.org>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:2666 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306AbaLITaZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Dec 2014 14:30:25 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

bmap_rb_extent is defined as __u64:blk __u64:count. So count can exceed INT_MAX on
populated filesystems

TESTCASE: xfstest ext4/004

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 lib/ext2fs/blkmap64_rb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/ext2fs/blkmap64_rb.c b/lib/ext2fs/blkmap64_rb.c
index 8d1778d..e290ade 100644
--- a/lib/ext2fs/blkmap64_rb.c
+++ b/lib/ext2fs/blkmap64_rb.c
@@ -733,7 +733,7 @@ static errcode_t rb_get_bmap_range(ext2fs_generic_bitmap bitmap,
 	struct rb_node *parent = NULL, *next, **n;
 	struct ext2fs_rb_private *bp;
 	struct bmap_rb_extent *ext;
-	int count;
+	__u64 count;
 	__u64 pos;
 
 	bp = (struct ext2fs_rb_private *) bitmap->private;
@@ -765,9 +765,9 @@ static errcode_t rb_get_bmap_range(ext2fs_generic_bitmap bitmap,
 		if (pos >= start + num)
 			break;
 		if (pos < start) {
-			count -= start - pos;
-			if (count < 0)
+			if (pos + count <  start)
 				continue;
+			count -= start - pos;
 			pos = start;
 		}
 		if (pos + count > start + num)
-- 
1.8.3.1

