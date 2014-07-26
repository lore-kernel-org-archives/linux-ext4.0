From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/6] libext2fs: fix rb_resize_bmap to handle the padding bits
Date: Sat, 26 Jul 2014 09:48:30 -0400
Message-ID: <1406382514-8662-3-git-send-email-tytso@mit.edu>
References: <1406382514-8662-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58041 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219AbaGZNsi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Jul 2014 09:48:38 -0400
In-Reply-To: <1406382514-8662-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The bits between end and real_end are set as a safety measure for the
kernel when it uses the bit scan instructions.  We need to take this
into account when shrinking or growing the block allocation bitmap,
before we can safely use rbtree bitmaps in resize2fs.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 lib/ext2fs/blkmap64_rb.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/lib/ext2fs/blkmap64_rb.c b/lib/ext2fs/blkmap64_rb.c
index a1dde6d..fdbd330 100644
--- a/lib/ext2fs/blkmap64_rb.c
+++ b/lib/ext2fs/blkmap64_rb.c
@@ -299,21 +299,19 @@ static errcode_t rb_resize_bmap(ext2fs_generic_bitmap bmap,
 {
 	struct ext2fs_rb_private *bp;
 
-	if (new_real_end >= bmap->real_end) {
-		bmap->end = new_end;
-		bmap->real_end = new_real_end;
-		return 0;
-	}
