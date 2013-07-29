From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: fix retry handling in ext4_ext_truncate()
Date: Mon, 29 Jul 2013 12:15:02 -0400
Message-ID: <1375114502-21261-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, stable@vger.kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37036 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754172Ab3G2QPF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Jul 2013 12:15:05 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We tested for ENOMEM instead of -ENOMEM.   Oops.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@vger.kernel.org
---
 fs/ext4/extents.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index a618738..72ba470 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4412,7 +4412,7 @@ void ext4_ext_truncate(handle_t *handle, struct inode *inode)
 retry:
 	err = ext4_es_remove_extent(inode, last_block,
 				    EXT_MAX_BLOCKS - last_block);
-	if (err == ENOMEM) {
+	if (err == -ENOMEM) {
 		cond_resched();
 		congestion_wait(BLK_RW_ASYNC, HZ/50);
 		goto retry;
-- 
1.7.12.rc0.22.gcdd159b

