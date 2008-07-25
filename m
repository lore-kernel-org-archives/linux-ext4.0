From: akpm@linux-foundation.org
Subject: [patch 064/277] jbd: replace potentially false assertion with if block
Date: Fri, 25 Jul 2008 01:46:19 -0700
Message-ID: <200807250846.m6P8kJH5001099@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, duaneg@dghda.com,
	linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51986 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753215AbYGYJJ5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jul 2008 05:09:57 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: "Duane Griffin" <duaneg@dghda.com>

If an error occurs during jbd cache initialisation it is possible for the
journal_head_cache to be NULL when journal_destroy_journal_head_cache is
called.  Replace the J_ASSERT with an if block to handle the situation
correctly.

Note that even with this fix things will break badly if jbd is statically
compiled in and cache initialisation fails.

Signed-off-by: Duane Griffin <duaneg@dghda.com
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/journal.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/jbd/journal.c~jbd-replace-potentially-false-assertion-with-if-block fs/jbd/journal.c
--- a/fs/jbd/journal.c~jbd-replace-potentially-false-assertion-with-if-block
+++ a/fs/jbd/journal.c
@@ -1636,9 +1636,10 @@ static int journal_init_journal_head_cac
 
 static void journal_destroy_journal_head_cache(void)
 {
-	J_ASSERT(journal_head_cache != NULL);
-	kmem_cache_destroy(journal_head_cache);
-	journal_head_cache = NULL;
+	if (journal_head_cache) {
+		kmem_cache_destroy(journal_head_cache);
+		journal_head_cache = NULL;
+	}
 }
 
 /*
_
