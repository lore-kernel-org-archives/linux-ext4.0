From: akpm@linux-foundation.org
Subject: - jbd2-replace-potentially-false-assertion-with-if-block.patch removed from -mm tree
Date: Mon, 10 Mar 2008 12:43:52 -0700
Message-ID: <200803101943.m2AJhqT6002206@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: duaneg@dghda.com, adilger@sun.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     jbd2: replace potentially false assertion with if block
has been removed from the -mm tree.  Its filename was
     jbd2-replace-potentially-false-assertion-with-if-block.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jbd2: replace potentially false assertion with if block
From: "Duane Griffin" <duaneg@dghda.com>

If an error occurs during jbd2 cache initialisation it is possible for the
journal_head_cache to be NULL when jbd2_journal_destroy_journal_head_cache is
called.  Replace the J_ASSERT with an if block to handle the situation
correctly.

Note that even with this fix things will break badly if jbd2 is statically
compiled in and cache initialisation fails.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd2/journal.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/jbd2/journal.c~jbd2-replace-potentially-false-assertion-with-if-block fs/jbd2/journal.c
--- a/fs/jbd2/journal.c~jbd2-replace-potentially-false-assertion-with-if-block
+++ a/fs/jbd2/journal.c
@@ -1991,9 +1991,10 @@ static int journal_init_jbd2_journal_hea
 
 static void jbd2_journal_destroy_jbd2_journal_head_cache(void)
 {
-	J_ASSERT(jbd2_journal_head_cache != NULL);
-	kmem_cache_destroy(jbd2_journal_head_cache);
-	jbd2_journal_head_cache = NULL;
+	if (jbd2_journal_head_cache) {
+		kmem_cache_destroy(jbd2_journal_head_cache);
+		jbd2_journal_head_cache = NULL;
+	}
 }
 
 /*
_

Patches currently in -mm which might be from duaneg@dghda.com are

jbd-only-create-debugfs-entries-if-cache-initialisation-is-successful.patch
jbd2-replace-potentially-false-assertion-with-if-block.patch
jbd2-only-create-debugfs-and-stats-entries-if-cache-initialisation-is-successful.patch

