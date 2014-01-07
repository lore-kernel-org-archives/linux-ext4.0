From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 04/10] libext2fs: remove redundant code in rb_print_stats()
Date: Tue,  7 Jan 2014 09:53:08 -0500
Message-ID: <1389106394-31898-4-git-send-email-tytso@mit.edu>
References: <1389106394-31898-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46609 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705AbaAGOxW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Jan 2014 09:53:22 -0500
In-Reply-To: <1389106394-31898-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Addresses-Coverity-Id: #709550

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/blkmap64_rb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/ext2fs/blkmap64_rb.c b/lib/ext2fs/blkmap64_rb.c
index a22682e..a189590 100644
--- a/lib/ext2fs/blkmap64_rb.c
+++ b/lib/ext2fs/blkmap64_rb.c
@@ -819,7 +819,6 @@ static void rb_print_stats(ext2fs_generic_bitmap bitmap)
 
 	bp = (struct ext2fs_rb_private *) bitmap->private;
 
-	node = ext2fs_rb_first(&bp->root);
 	for (node = ext2fs_rb_first(&bp->root); node != NULL;
 	     node = ext2fs_rb_next(node)) {
 		ext = node_to_extent(node);
-- 
1.8.5.rc3.362.gdf10213

