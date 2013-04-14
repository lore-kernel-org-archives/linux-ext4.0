From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/5] ext4: convert write_begin methods to stable_page_writes semantics
Date: Sun, 14 Apr 2013 23:01:33 +0400
Message-ID: <1365966097-8968-1-git-send-email-dmonakhov@openvz.org>
Cc: jack@suse.cz, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:25636 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299Ab3DNTCm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Apr 2013 15:02:42 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

use wait_for_stable_page() instead of wait_on_page_writeback()

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/inode.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 62189c8..1be5827 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1028,7 +1028,8 @@ retry_journal:
 		ext4_journal_stop(handle);
 		goto retry_grab;
 	}
-	wait_on_page_writeback(page);
+	/* In case writeback began while the page was unlocked */
+	wait_for_stable_page(page);
 
 	if (ext4_should_dioread_nolock(inode))
 		ret = __block_write_begin(page, pos, len, ext4_get_block_write);
@@ -2715,7 +2716,7 @@ retry_journal:
 		goto retry_grab;
 	}
 	/* In case writeback began while the page was unlocked */
-	wait_on_page_writeback(page);
+	wait_for_stable_page(page);
 
 	ret = __block_write_begin(page, pos, len, ext4_da_get_block_prep);
 	if (ret < 0) {
-- 
1.7.1

