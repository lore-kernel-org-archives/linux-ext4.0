From: akpm@linux-foundation.org
Subject: + jbd2-replace-potentially-false-assertion-with-if-block.patch added to -mm tree
Date: Fri, 07 Mar 2008 00:57:19 -0800
Message-ID: <200803070857.m278vJRk014109@imap1.linux-foundation.org>
Cc: duaneg@dghda.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51556 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754083AbYCGI5X (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Mar 2008 03:57:23 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     jbd2: replace potentially false assertion with if block
has been added to the -mm tree.  Its filename is
     jbd2-replace-potentially-false-assertion-with-if-block.patch

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

jbd-eliminate-duplicated-code-in-revocation-table-init-destroy-functions.patch
jbd-replace-potentially-false-assertion-with-if-block.patch
jbd-only-create-debugfs-entries-if-cache-initialisation-is-successful.patch
jbd2-eliminate-duplicated-code-in-revocation-table-init-destroy-functions.patch
jbd2-replace-potentially-false-assertion-with-if-block.patch
jbd2-only-create-debugfs-and-stats-entries-if-cache-initialisation-is-successful.patch

