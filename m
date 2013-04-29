From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH] jbd: use kmem_cache_zalloc for allocating journal head
Date: Mon, 29 Apr 2013 17:08:51 +0800
Message-ID: <1367226531-3027-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:34319 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757166Ab3D2Iv2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Apr 2013 04:51:28 -0400
Received: by mail-pd0-f170.google.com with SMTP id 15so496266pdi.29
        for <linux-ext4@vger.kernel.org>; Mon, 29 Apr 2013 01:51:27 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

This commit tries to use kmem_cache_zalloc instead of kmem_cache_alloc/
memset when a new journal head is alloctated.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Cc: Jan Kara <jack@suse.cz>
---
Hi Jan,

This patch could be folded into the commit that you have applied:
  jbd: use kmem_cache_zalloc instead of kmem_cache_alloc/memset

Regards,
						- Zheng

 fs/jbd/journal.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 81cc7ea..c5a6926 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -1845,7 +1845,7 @@ static struct journal_head *journal_alloc_journal_head(void)
 #ifdef CONFIG_JBD_DEBUG
 	atomic_inc(&nr_journal_heads);
 #endif
-	ret = kmem_cache_alloc(journal_head_cache, GFP_NOFS);
+	ret = kmem_cache_zalloc(journal_head_cache, GFP_NOFS);
 	if (ret == NULL) {
 		jbd_debug(1, "out of memory for journal_head\n");
 		printk_ratelimited(KERN_NOTICE "ENOMEM in %s, retrying.\n",
@@ -1853,7 +1853,7 @@ static struct journal_head *journal_alloc_journal_head(void)
 
 		while (ret == NULL) {
 			yield();
-			ret = kmem_cache_alloc(journal_head_cache, GFP_NOFS);
+			ret = kmem_cache_zalloc(journal_head_cache, GFP_NOFS);
 		}
 	}
 	return ret;
@@ -1915,10 +1915,8 @@ struct journal_head *journal_add_journal_head(struct buffer_head *bh)
 	struct journal_head *new_jh = NULL;
 
 repeat:
-	if (!buffer_jbd(bh)) {
+	if (!buffer_jbd(bh))
 		new_jh = journal_alloc_journal_head();
-		memset(new_jh, 0, sizeof(*new_jh));
-	}
 
 	jbd_lock_bh_journal_head(bh);
 	if (buffer_jbd(bh)) {
-- 
1.7.12.rc2.18.g61b472e

