From: akpm@linux-foundation.org
Subject: - jbd-replace-potentially-false-assertion-with-if-block.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:56:25 -0700
Message-ID: <200807252256.m6PMuPBl003086@imap1.linux-foundation.org>
To: duaneg@dghda.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47002 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754295AbYGYXGa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jul 2008 19:06:30 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     jbd: replace potentially false assertion with if block
has been removed from the -mm tree.  Its filename was
     jbd-replace-potentially-false-assertion-with-if-block.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jbd: replace potentially false assertion with if block
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

Patches currently in -mm which might be from duaneg@dghda.com are

origin.patch

