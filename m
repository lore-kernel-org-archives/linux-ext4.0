From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH] jbd: Use printk_ratelimit() in journal_alloc_journal_head()
Date: Mon,  4 Oct 2010 18:17:14 +0900
Message-ID: <1286183834-10548-1-git-send-email-namhyung@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38756 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814Ab0JDJRS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Oct 2010 05:17:18 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use printk_ratelimit() instead of doing it manually.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/jbd/journal.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 6f20a75..d66dd36 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -1718,7 +1718,6 @@ static void journal_destroy_journal_head_cache(void)
 static struct journal_head *journal_alloc_journal_head(void)
 {
 	struct journal_head *ret;
-	static unsigned long last_warning;
 
 #ifdef CONFIG_JBD_DEBUG
 	atomic_inc(&nr_journal_heads);
@@ -1726,11 +1725,10 @@ static struct journal_head *journal_alloc_journal_head(void)
 	ret = kmem_cache_alloc(journal_head_cache, GFP_NOFS);
 	if (ret == NULL) {
 		jbd_debug(1, "out of memory for journal_head\n");
-		if (time_after(jiffies, last_warning + 5*HZ)) {
+		if (printk_ratelimit())
 			printk(KERN_NOTICE "ENOMEM in %s, retrying.\n",
 			       __func__);
-			last_warning = jiffies;
-		}
+
 		while (ret == NULL) {
 			yield();
 			ret = kmem_cache_alloc(journal_head_cache, GFP_NOFS);
-- 
1.7.0.4

