From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH UPDATED] jbd: Use printk_ratelimited() in journal_alloc_journal_head()
Date: Mon,  4 Oct 2010 19:12:13 +0900
Message-ID: <1286187133-12475-1-git-send-email-namhyung@gmail.com>
References: <20101004094331.GC3589@quack.suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36175 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580Ab0JDKMT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Oct 2010 06:12:19 -0400
In-Reply-To: <20101004094331.GC3589@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use printk_ratelimited() instead of doing it manually.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/jbd/journal.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 6f20a75..f79767d 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -1718,7 +1718,6 @@ static void journal_destroy_journal_head_cache(void)
 static struct journal_head *journal_alloc_journal_head(void)
 {
 	struct journal_head *ret;
-	static unsigned long last_warning;
 
 #ifdef CONFIG_JBD_DEBUG
 	atomic_inc(&nr_journal_heads);
@@ -1726,11 +1725,9 @@ static struct journal_head *journal_alloc_journal_head(void)
 	ret = kmem_cache_alloc(journal_head_cache, GFP_NOFS);
 	if (ret == NULL) {
 		jbd_debug(1, "out of memory for journal_head\n");
-		if (time_after(jiffies, last_warning + 5*HZ)) {
-			printk(KERN_NOTICE "ENOMEM in %s, retrying.\n",
-			       __func__);
-			last_warning = jiffies;
-		}
+		printk_ratelimited(KERN_NOTICE "ENOMEM in %s, retrying.\n",
+				   __func__);
+
 		while (ret == NULL) {
 			yield();
 			ret = kmem_cache_alloc(journal_head_cache, GFP_NOFS);
-- 
1.7.0.4

