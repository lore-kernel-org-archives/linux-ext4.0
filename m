From: akpm@linux-foundation.org
Subject: + jbd2-sparse-warnings-in-revokec-journalc.patch added to -mm tree
Date: Wed, 13 Feb 2008 16:50:56 -0800
Message-ID: <200802140050.m1E0ovLo023103@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: harvey.harrison@gmail.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     jbd2: sparse warnings in revoke.c, journal.c
has been added to the -mm tree.  Its filename is
     jbd2-sparse-warnings-in-revokec-journalc.patch

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
Subject: jbd2: sparse warnings in revoke.c, journal.c
From: Harvey Harrison <harvey.harrison@gmail.com>

fs/jbd2/revoke.c:177:34: warning: Using plain integer as NULL pointer
fs/jbd2/revoke.c:183:33: warning: Using plain integer as NULL pointer
fs/jbd2/journal.c:222:2: warning: Using plain integer as NULL pointer
fs/jbd2/journal.c:222:2: warning: Using plain integer as NULL pointer
fs/jbd2/journal.c:234:3: warning: Using plain integer as NULL pointer
fs/jbd2/journal.c:234:3: warning: Using plain integer as NULL pointer
fs/jbd2/journal.c:1972:2: warning: Using plain integer as NULL pointer
fs/jbd2/journal.c:1979:33: warning: Using plain integer as NULL pointer
fs/jbd2/journal.c:2005:13: warning: Using plain integer as NULL pointer
fs/jbd2/journal.c:2012:17: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd2/journal.c |   12 ++++++------
 fs/jbd2/revoke.c  |    4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff -puN fs/jbd/journal.c~jbd2-sparse-warnings-in-revokec-journalc fs/jbd/journal.c
diff -puN fs/jbd/revoke.c~jbd2-sparse-warnings-in-revokec-journalc fs/jbd/revoke.c
diff -puN fs/jbd2/journal.c~jbd2-sparse-warnings-in-revokec-journalc fs/jbd2/journal.c
--- a/fs/jbd2/journal.c~jbd2-sparse-warnings-in-revokec-journalc
+++ a/fs/jbd2/journal.c
@@ -219,7 +219,7 @@ static int jbd2_journal_start_thread(jou
 	if (IS_ERR(t))
 		return PTR_ERR(t);
 
-	wait_event(journal->j_wait_done_commit, journal->j_task != 0);
+	wait_event(journal->j_wait_done_commit, journal->j_task != NULL);
 	return 0;
 }
 
@@ -231,7 +231,7 @@ static void journal_kill_thread(journal_
 	while (journal->j_task) {
 		wake_up(&journal->j_wait_commit);
 		spin_unlock(&journal->j_state_lock);
-		wait_event(journal->j_wait_done_commit, journal->j_task == 0);
+		wait_event(journal->j_wait_done_commit, journal->j_task == NULL);
 		spin_lock(&journal->j_state_lock);
 	}
 	spin_unlock(&journal->j_state_lock);
@@ -1974,14 +1974,14 @@ static int journal_init_jbd2_journal_hea
 {
 	int retval;
 
-	J_ASSERT(jbd2_journal_head_cache == 0);
+	J_ASSERT(!jbd2_journal_head_cache);
 	jbd2_journal_head_cache = kmem_cache_create("jbd2_journal_head",
 				sizeof(struct journal_head),
 				0,		/* offset */
 				SLAB_TEMPORARY,	/* flags */
 				NULL);		/* ctor */
 	retval = 0;
-	if (jbd2_journal_head_cache == 0) {
+	if (!jbd2_journal_head_cache) {
 		retval = -ENOMEM;
 		printk(KERN_EMERG "JBD: no memory for journal_head cache\n");
 	}
@@ -2007,14 +2007,14 @@ static struct journal_head *journal_allo
 	atomic_inc(&nr_journal_heads);
 #endif
 	ret = kmem_cache_alloc(jbd2_journal_head_cache, GFP_NOFS);
-	if (ret == 0) {
+	if (!ret) {
 		jbd_debug(1, "out of memory for journal_head\n");
 		if (time_after(jiffies, last_warning + 5*HZ)) {
 			printk(KERN_NOTICE "ENOMEM in %s, retrying.\n",
 			       __FUNCTION__);
 			last_warning = jiffies;
 		}
-		while (ret == 0) {
+		while (!ret) {
 			yield();
 			ret = kmem_cache_alloc(jbd2_journal_head_cache, GFP_NOFS);
 		}
diff -puN fs/jbd2/revoke.c~jbd2-sparse-warnings-in-revokec-journalc fs/jbd2/revoke.c
--- a/fs/jbd2/revoke.c~jbd2-sparse-warnings-in-revokec-journalc
+++ a/fs/jbd2/revoke.c
@@ -174,13 +174,13 @@ int __init jbd2_journal_init_revoke_cach
 					   0,
 					   SLAB_HWCACHE_ALIGN|SLAB_TEMPORARY,
 					   NULL);
-	if (jbd2_revoke_record_cache == 0)
+	if (!jbd2_revoke_record_cache)
 		return -ENOMEM;
 
 	jbd2_revoke_table_cache = kmem_cache_create("jbd2_revoke_table",
 					   sizeof(struct jbd2_revoke_table_s),
 					   0, SLAB_TEMPORARY, NULL);
-	if (jbd2_revoke_table_cache == 0) {
+	if (!jbd2_revoke_table_cache) {
 		kmem_cache_destroy(jbd2_revoke_record_cache);
 		jbd2_revoke_record_cache = NULL;
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
