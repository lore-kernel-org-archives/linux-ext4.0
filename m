From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH] jbd2: use kmem_cache_zalloc for allocating journal head
Date: Mon, 29 Apr 2013 17:08:27 +0800
Message-ID: <1367226507-2990-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:34456 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab3D2IvH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Apr 2013 04:51:07 -0400
Received: by mail-pa0-f41.google.com with SMTP id kq12so2814081pab.14
        for <linux-ext4@vger.kernel.org>; Mon, 29 Apr 2013 01:51:07 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

This commit tries to use kmem_cache_zalloc instead of kmem_cache_alloc/
memset when a new journal head is alloctated.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
---
Hi Ted,

This patch could be folded into the commit: (28daf4fa)
    jbd2: use kmem_cache_zalloc instead of kmem_cache_alloc/memset

Regards,
						- Zheng

 fs/jbd2/journal.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index a62f57a..e90c0bf 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2327,13 +2327,13 @@ static struct journal_head *journal_alloc_journal_head(void)
 #ifdef CONFIG_JBD2_DEBUG
 	atomic_inc(&nr_journal_heads);
 #endif
-	ret = kmem_cache_alloc(jbd2_journal_head_cache, GFP_NOFS);
+	ret = kmem_cache_zalloc(jbd2_journal_head_cache, GFP_NOFS);
 	if (!ret) {
 		jbd_debug(1, "out of memory for journal_head\n");
 		pr_notice_ratelimited("ENOMEM in %s, retrying.\n", __func__);
 		while (!ret) {
 			yield();
-			ret = kmem_cache_alloc(jbd2_journal_head_cache, GFP_NOFS);
+			ret = kmem_cache_zalloc(jbd2_journal_head_cache, GFP_NOFS);
 		}
 	}
 	return ret;
@@ -2395,10 +2395,8 @@ struct journal_head *jbd2_journal_add_journal_head(struct buffer_head *bh)
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

