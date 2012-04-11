From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/3] jbd: protect all log tail updates with j_checkpoint_mutex
Date: Wed, 11 Apr 2012 21:58:37 +0200
Message-ID: <1334174318-11735-3-git-send-email-jack@suse.cz>
References: <1334174318-11735-1-git-send-email-jack@suse.cz>
Cc: Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57639 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933023Ab2DKT6p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Apr 2012 15:58:45 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id C706490072
	for <linux-ext4@vger.kernel.org>; Wed, 11 Apr 2012 21:58:44 +0200 (CEST)
In-Reply-To: <1334174318-11735-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There are some log tail updates that are not protected by j_checkpoint_mutex.
Some of these are harmless because they happen during startup or shutdown but
updates in journal_commit_transaction() and journal_flush() can really race
with other log tail updates (e.g. someone doing journal_flush() with someone
running cleanup_journal_tail()). So protect all log tail updates with
j_checkpoint_mutex.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd/commit.c  |    2 ++
 fs/jbd/journal.c |   15 ++++++++++++++-
 2 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index dba9cfd..1b27f46 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -308,7 +308,9 @@ void journal_commit_transaction(journal_t *journal)
 	/* Do we need to erase the effects of a prior journal_flush? */
 	if (journal->j_flags & JFS_FLUSHED) {
 		jbd_debug(3, "super block updated\n");
+		mutex_lock(&journal->j_checkpoint_mutex);
 		journal_update_sb_log_tail(journal);
+		mutex_unlock(&journal->j_checkpoint_mutex);
 	} else {
 		jbd_debug(3, "superblock not updated\n");
 	}
diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 44c104a..0f89174 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -936,8 +936,11 @@ static int journal_reset(journal_t *journal)
 			journal->j_errno);
 		journal->j_flags |= JFS_FLUSHED;
 	} else {
+		/* Lock here to make assertions happy... */
+		mutex_lock(&journal->j_checkpoint_mutex);
 		/* Add the dynamic fields and write it to disk. */
 		journal_update_sb_log_tail(journal);
+		mutex_unlock(&journal->j_checkpoint_mutex);
 	}
 	return journal_start_thread(journal);
 }
@@ -1061,6 +1064,7 @@ void journal_update_sb_log_tail(journal_t *journal)
 {
 	journal_superblock_t *sb = journal->j_superblock;
 
+	BUG_ON(!mutex_is_locked(&journal->j_checkpoint_mutex));
 	spin_lock(&journal->j_state_lock);
 	jbd_debug(1,"JBD: updating superblock (start %u, seq %d, errno %d)\n",
 		  journal->j_tail, journal->j_tail_sequence, journal->j_errno);
@@ -1089,6 +1093,7 @@ static void mark_journal_empty(journal_t *journal)
 {
 	journal_superblock_t *sb = journal->j_superblock;
 
+	BUG_ON(!mutex_is_locked(&journal->j_checkpoint_mutex));
 	spin_lock(&journal->j_state_lock);
 	jbd_debug(1, "JBD: Marking journal as empty (seq %d)\n",
         	  journal->j_tail_sequence);
@@ -1308,9 +1313,11 @@ int journal_destroy(journal_t *journal)
 
 	if (journal->j_sb_buffer) {
 		if (!is_journal_aborted(journal)) {
+			mutex_lock(&journal->j_checkpoint_mutex);
 			journal->j_tail_sequence =
 				++journal->j_transaction_sequence;
 			mark_journal_empty(journal);
+			mutex_unlock(&journal->j_checkpoint_mutex);
 		} else
 			err = -EIO;
 		brelse(journal->j_sb_buffer);
@@ -1528,6 +1535,7 @@ int journal_flush(journal_t *journal)
 	if (is_journal_aborted(journal))
 		return -EIO;
 
+	mutex_lock(&journal->j_checkpoint_mutex);
 	cleanup_journal_tail(journal);
 
 	/* Finally, mark the journal as really needing no recovery.
@@ -1536,6 +1544,7 @@ int journal_flush(journal_t *journal)
 	 * commits of data to the journal will restore the current
 	 * s_start value. */
 	mark_journal_empty(journal);
+	mutex_unlock(&journal->j_checkpoint_mutex);
 	spin_lock(&journal->j_state_lock);
 	J_ASSERT(!journal->j_running_transaction);
 	J_ASSERT(!journal->j_committing_transaction);
@@ -1576,8 +1585,12 @@ int journal_wipe(journal_t *journal, int write)
 		write ? "Clearing" : "Ignoring");
 
 	err = journal_skip_recovery(journal);
-	if (write)
+	if (write) {
+		/* Lock to make assertions happy... */
+		mutex_lock(&journal->j_checkpoint_mutex);
 		mark_journal_empty(journal);
+		mutex_unlock(&journal->j_checkpoint_mutex);
+	}
 
  no_recovery:
 	return err;
-- 
1.7.1

