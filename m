From: akpm@linux-foundation.org
Subject: + jbd-replace-potentially-false-assertion-with-if-block.patch added to -mm tree
Date: Mon, 05 May 2008 14:43:33 -0700
Message-ID: <200805052143.m45LhX1f006607@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: duaneg@dghda.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     jbd: replace potentially false assertion with if block
has been added to the -mm tree.  Its filename is
     jbd-replace-potentially-false-assertion-with-if-block.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

jbd-eliminate-duplicated-code-in-revocation-table-init-destroy-functions.patch
jbd-tidy-up-revoke-cache-initialisation-and-destruction.patch
jbd-replace-potentially-false-assertion-with-if-block.patch

