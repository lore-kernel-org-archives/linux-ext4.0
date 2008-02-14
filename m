From: akpm@linux-foundation.org
Subject: + jbd-sparse-warnings-in-revokec-journalc.patch added to -mm tree
Date: Wed, 13 Feb 2008 16:48:03 -0800
Message-ID: <200802140048.m1E0m3eQ023045@imap1.linux-foundation.org>
Cc: harvey.harrison@gmail.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43181 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757880AbYBNAsH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Feb 2008 19:48:07 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     jbd: sparse warnings in revoke.c, journal.c
has been added to the -mm tree.  Its filename is
     jbd-sparse-warnings-in-revokec-journalc.patch

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
Subject: jbd: sparse warnings in revoke.c, journal.c
From: Harvey Harrison <harvey.harrison@gmail.com>

fs/jbd/revoke.c:176:29: warning: Using plain integer as NULL pointer
fs/jbd/revoke.c:182:28: warning: Using plain integer as NULL pointer
fs/jbd/journal.c:1622:2: warning: Using plain integer as NULL pointer
fs/jbd/journal.c:1629:28: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/journal.c |    4 ++--
 fs/jbd/revoke.c  |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/jbd/journal.c~jbd-sparse-warnings-in-revokec-journalc fs/jbd/journal.c
--- a/fs/jbd/journal.c~jbd-sparse-warnings-in-revokec-journalc
+++ a/fs/jbd/journal.c
@@ -1619,14 +1619,14 @@ static int journal_init_journal_head_cac
 {
 	int retval;
 
-	J_ASSERT(journal_head_cache == 0);
+	J_ASSERT(!journal_head_cache);
 	journal_head_cache = kmem_cache_create("journal_head",
 				sizeof(struct journal_head),
 				0,		/* offset */
 				SLAB_TEMPORARY,	/* flags */
 				NULL);		/* ctor */
 	retval = 0;
-	if (journal_head_cache == 0) {
+	if (!journal_head_cache) {
 		retval = -ENOMEM;
 		printk(KERN_EMERG "JBD: no memory for journal_head cache\n");
 	}
diff -puN fs/jbd/revoke.c~jbd-sparse-warnings-in-revokec-journalc fs/jbd/revoke.c
--- a/fs/jbd/revoke.c~jbd-sparse-warnings-in-revokec-journalc
+++ a/fs/jbd/revoke.c
@@ -173,13 +173,13 @@ int __init journal_init_revoke_caches(vo
 					   0,
 					   SLAB_HWCACHE_ALIGN|SLAB_TEMPORARY,
 					   NULL);
-	if (revoke_record_cache == 0)
+	if (!revoke_record_cache)
 		return -ENOMEM;
 
 	revoke_table_cache = kmem_cache_create("revoke_table",
 					   sizeof(struct jbd_revoke_table_s),
 					   0, SLAB_TEMPORARY, NULL);
-	if (revoke_table_cache == 0) {
+	if (!revoke_table_cache) {
 		kmem_cache_destroy(revoke_record_cache);
 		revoke_record_cache = NULL;
 		return -ENOMEM;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
include-linux-remove-all-users-of-fastcall-macro.patch
rcupdate-fix-comment.patch
remove-final-fastcall-users.patch
final-removal-of-fastcall-fastcall.patch
git-x86.patch
x86-remove-pt_regs-arg-from-smp_thermal_interrupt.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
jbd-sparse-warnings-in-revokec-journalc.patch
jbd2-sparse-warnings-in-revokec-journalc.patch
