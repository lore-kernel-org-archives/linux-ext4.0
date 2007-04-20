From: akpm@linux-foundation.org
Subject: + jbd-check-for-error-returned-by-kthread_create-on-creating-journal-thread.patch added to -mm tree
Date: Fri, 20 Apr 2007 15:38:17 -0700
Message-ID: <200704202238.l3KMcHML025474@shell0.pdx.osdl.net>
Cc: xemul@sw.ru, hch@lst.de, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60841 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754514AbXDTWic (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Apr 2007 18:38:32 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     jbd: check for error returned by kthread_create on creating journal thread
has been added to the -mm tree.  Its filename is
     jbd-check-for-error-returned-by-kthread_create-on-creating-journal-thread.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: jbd: check for error returned by kthread_create on creating journal thread
From: Pavel Emelianov <xemul@sw.ru>

If the thread failed to create the subsequent wait_event will hang forever.

This is likely to happen if kernel hits max_threads limit.

Will be critical for virtualization systems that limit the number of tasks
and kernel memory usage within the container.

(akpm: JBD should be converted fully to the kthread API: kthread_should_stop()
and kthread_stop()).

Cc: <linux-ext4@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/journal.c  |   13 +++++++++----
 fs/jbd2/journal.c |   13 +++++++++----
 2 files changed, 18 insertions(+), 8 deletions(-)

diff -puN fs/jbd/journal.c~jbd-check-for-error-returned-by-kthread_create-on-creating-journal-thread fs/jbd/journal.c
--- a/fs/jbd/journal.c~jbd-check-for-error-returned-by-kthread_create-on-creating-journal-thread
+++ a/fs/jbd/journal.c
@@ -210,10 +210,16 @@ end_loop:
 	return 0;
 }
 
-static void journal_start_thread(journal_t *journal)
+static int journal_start_thread(journal_t *journal)
 {
-	kthread_run(kjournald, journal, "kjournald");
+	struct task_struct *t;
+
+	t = kthread_run(kjournald, journal, "kjournald");
+	if (IS_ERR(t))
+		return PTR_ERR(t);
+
 	wait_event(journal->j_wait_done_commit, journal->j_task != 0);
+	return 0;
 }
 
 static void journal_kill_thread(journal_t *journal)
@@ -839,8 +845,7 @@ static int journal_reset(journal_t *jour
 
 	/* Add the dynamic fields and write it to disk. */
 	journal_update_superblock(journal, 1);
-	journal_start_thread(journal);
-	return 0;
+	return journal_start_thread(journal);
 }
 
 /**
diff -puN fs/jbd2/journal.c~jbd-check-for-error-returned-by-kthread_create-on-creating-journal-thread fs/jbd2/journal.c
--- a/fs/jbd2/journal.c~jbd-check-for-error-returned-by-kthread_create-on-creating-journal-thread
+++ a/fs/jbd2/journal.c
@@ -210,10 +210,16 @@ end_loop:
 	return 0;
 }
 
-static void jbd2_journal_start_thread(journal_t *journal)
+static int jbd2_journal_start_thread(journal_t *journal)
 {
-	kthread_run(kjournald2, journal, "kjournald2");
+	struct task_struct *t;
+
+	t = kthread_run(kjournald2, journal, "kjournald2");
+	if (IS_ERR(t))
+		return PTR_ERR(t);
+
 	wait_event(journal->j_wait_done_commit, journal->j_task != 0);
+	return 0;
 }
 
 static void journal_kill_thread(journal_t *journal)
@@ -839,8 +845,7 @@ static int journal_reset(journal_t *jour
 
 	/* Add the dynamic fields and write it to disk. */
 	jbd2_journal_update_superblock(journal, 1);
-	jbd2_journal_start_thread(journal);
-	return 0;
+	return jbd2_journal_start_thread(journal);
 }
 
 /**
_

Patches currently in -mm which might be from xemul@sw.ru are

origin.patch
lockdep-treats-down_write_trylock-like-regular-down_write.patch
introduce-a-handy-list_first_entry-macro-v2.patch
report-that-kernel-is-tainted-if-there-were-an-oops-before.patch
jbd-check-for-error-returned-by-kthread_create-on-creating-journal-thread.patch
