From: Shen Feng <shen@cn.fujitsu.com>
Subject: [PATCH] ext4: Fix the error declaration of ext4_mb_free_blocks
Date: Tue, 17 Jun 2008 15:10:31 +0800
Message-ID: <48576367.2070906@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56231 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752128AbYFQHN5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Jun 2008 03:13:57 -0400
Received: from tang.cn.fujitsu.com (tang.cn.fujitsu.com [10.167.250.3])
	by song.cn.fujitsu.com (Postfix) with ESMTP id 0BFAA1701A3
	for <linux-ext4@vger.kernel.org>; Tue, 17 Jun 2008 15:13:54 +0800 (CST)
Received: from fnst.cn.fujitsu.com (localhost.localdomain [127.0.0.1])
	by tang.cn.fujitsu.com (8.13.1/8.13.1) with ESMTP id m5H7DrmA010899
	for <linux-ext4@vger.kernel.org>; Tue, 17 Jun 2008 15:13:53 +0800
Received: from localhost.localdomain (unknown [10.167.141.45])
	by fnst.cn.fujitsu.com (Postfix) with ESMTP id CF54ED40A9
	for <linux-ext4@vger.kernel.org>; Tue, 17 Jun 2008 15:16:51 +0800 (CST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The third parameter @block of ext4_mb_free_blocks is
declared as unsigned long. But it should be
ext4_fsblk_t.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
---
 fs/ext4/ext4.h    |    2 +-
 fs/ext4/mballoc.c |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 8158083..30cfb20 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1015,7 +1015,7 @@ extern void ext4_mb_discard_inode_preallocations(struct inode *);
 extern int __init init_ext4_mballoc(void);
 extern void exit_ext4_mballoc(void);
 extern void ext4_mb_free_blocks(handle_t *, struct inode *,
-		unsigned long, unsigned long, int, unsigned long *);
+		ext4_fsblk_t, unsigned long, int, unsigned long *);
 
 
 /* inode.c */
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index c9900aa..5fa1b7c 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4189,7 +4189,7 @@ ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
  * Main entry point into mballoc to free blocks
  */
 void ext4_mb_free_blocks(handle_t *handle, struct inode *inode,
-			unsigned long block, unsigned long count,
+			ext4_fsblk_t block, unsigned long count,
 			int metadata, unsigned long *freed)
 {
 	struct buffer_head *bitmap_bh = NULL;
@@ -4217,11 +4217,11 @@ void ext4_mb_free_blocks(handle_t *handle, struct inode *inode,
 	    block + count > ext4_blocks_count(es)) {
 		ext4_error(sb, __func__,
 			    "Freeing blocks not in datazone - "
-			    "block = %lu, count = %lu", block, count);
+			    "block = %llu, count = %lu", block, count);
 		goto error_return;
 	}
 
-	ext4_debug("freeing block %lu\n", block);
+	ext4_debug("freeing block %llu\n", block);
 
 	ac = kmem_cache_alloc(ext4_ac_cachep, GFP_NOFS);
 	if (ac) {
@@ -4258,7 +4258,7 @@ do_more:
 
 		ext4_error(sb, __func__,
 			   "Freeing blocks in system zone - "
-			   "Block = %lu, count = %lu", block, count);
+			   "Block = %llu, count = %lu", block, count);
 		/* err = 0. ext4_std_error should be a no op */
 		goto error_return;
 	}
-- 
1.5.5.1
