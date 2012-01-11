From: Jan Kara <jack@suse.cz>
Subject: [PATCH v2] jbd: Issue cache flush after checkpointing
Date: Wed, 11 Jan 2012 20:00:13 +0100
Message-ID: <1326308413-21483-1-git-send-email-jack@suse.cz>
Cc: Jan Kara <jack@suse.cz>, stable@kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49409 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933645Ab2AKTAU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jan 2012 14:00:20 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we reach cleanup_journal_tail(), there is no guarantee that
checkpointed buffers are on a stable storage - especially if buffers were
written out by log_do_checkpoint(), they are likely to be only in disk's
caches. Thus when we update journal superblock, effectively removing old
transaction from journal, this write of superblock can get to stable storage
before those checkpointed buffers which can result in filesystem corruption
after a crash.

A similar problem can happen if we replay the journal and wipe it before
flushing disk's caches.

Thus we must unconditionally issue a cache flush before we update journal
superblock in these cases. The fix is slightly complicated by the fact that we
have to get log tail before we issue cache flush but we can store it in the
journal superblock only after the cache flush. Otherwise we risk races where
new tail is written before appropriate cache flush is finished.

I managed to reproduce the corruption using somewhat tweaked Chris Mason's
barrier-test scheduler. Also this should fix occasional reports of 'Bit already
freed' filesystem errors which are totally unreproducible but inspection of
several fs images I've gathered over time points to a problem like this.

CC: stable@kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd/checkpoint.c |   27 ++++++++++++++++++++++-----
 fs/jbd/recovery.c   |    4 ++++
 2 files changed, 26 insertions(+), 5 deletions(-)

 Updated version of the patch. I've added missing cache flush also after
journal recovery and moved the cache flush in cleanup_journal_tail() before
updating the journal fields to avoid races between parallel invocations of
cleanup_journal_tail().

diff --git a/fs/jbd/checkpoint.c b/fs/jbd/checkpoint.c
index 5d1a00a..05f0754 100644
--- a/fs/jbd/checkpoint.c
+++ b/fs/jbd/checkpoint.c
@@ -453,8 +453,6 @@ out:
  *
  * Return <0 on error, 0 on success, 1 if there was nothing to clean up.
  *
- * Called with the journal lock held.
- *
  * This is the only part of the journaling code which really needs to be
  * aware of transaction aborts.  Checkpointing involves writing to the
  * main filesystem area rather than to the journal, so it can proceed
@@ -472,13 +470,14 @@ int cleanup_journal_tail(journal_t *journal)
 	if (is_journal_aborted(journal))
 		return 1;
 
-	/* OK, work out the oldest transaction remaining in the log, and
+	/*
+	 * OK, work out the oldest transaction remaining in the log, and
 	 * the log block it starts at.
 	 *
 	 * If the log is now empty, we need to work out which is the
 	 * next transaction ID we will write, and where it will
-	 * start. */
-
+	 * start.
+	 */
 	spin_lock(&journal->j_state_lock);
 	spin_lock(&journal->j_list_lock);
 	transaction = journal->j_checkpoint_transactions;
@@ -504,7 +503,25 @@ int cleanup_journal_tail(journal_t *journal)
 		spin_unlock(&journal->j_state_lock);
 		return 1;
 	}
+	spin_unlock(&journal->j_state_lock);
+
+	/*
+	 * We need to make sure that any blocks that were recently written out
+	 * --- perhaps by log_do_checkpoint() --- are flushed out before we
+	 * drop the transactions from the journal. It's unlikely this will be
+	 * necessary, especially with an appropriately sized journal, but we
+	 * need this to guarantee correctness.  Fortunately
+	 * cleanup_journal_tail() doesn't get called all that often.
+	 */
+	if (journal->j_flags & JFS_BARRIER)
+		blkdev_issue_flush(journal->j_fs_dev, GFP_KERNEL, NULL);
 
+	spin_lock(&journal->j_state_lock);
+	if (!tid_gt(first_tid, journal->j_tail_sequence)) {
+		spin_unlock(&journal->j_state_lock);
+		/* Someone else cleaned up journal so return 0 */
+		return 0;
+	}
 	/* OK, update the superblock to recover the freed space.
 	 * Physical blocks come first: have we wrapped beyond the end of
 	 * the log?  */
diff --git a/fs/jbd/recovery.c b/fs/jbd/recovery.c
index 5b43e96..008bf06 100644
--- a/fs/jbd/recovery.c
+++ b/fs/jbd/recovery.c
@@ -20,6 +20,7 @@
 #include <linux/fs.h>
 #include <linux/jbd.h>
 #include <linux/errno.h>
+#include <linux/blkdev.h>
 #endif
 
 /*
@@ -263,6 +264,9 @@ int journal_recover(journal_t *journal)
 	err2 = sync_blockdev(journal->j_fs_dev);
 	if (!err)
 		err = err2;
+	/* Flush disk caches to get replayed data on the permanent storage */
+	if (journal->j_flags & JFS_BARRIER)
+		blkdev_issue_flush(journal->j_fs_dev, GFP_KERNEL, NULL);
 
 	return err;
 }
-- 
1.7.1

