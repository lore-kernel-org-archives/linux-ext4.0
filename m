From: Jan Kara <jack@suse.cz>
Subject: [PATCH 6/6] jbd2: Cleanup journal tail after transaction commit
Date: Wed, 11 Jan 2012 01:31:12 +0100
Message-ID: <1326241872-20142-7-git-send-email-jack@suse.cz>
References: <1326241872-20142-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56936 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757202Ab2AKAb3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jan 2012 19:31:29 -0500
In-Reply-To: <1326241872-20142-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Normally, we have to issue a cache flush before we can update journal
tail in journal superblock, effectively wiping out old transactions
from the journal. So use the fact that during transaction commit we
issue cache flush anyway and opportunistically push journal tail as
far as we can.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/commit.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 68d704d..6e99eea 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -331,6 +331,9 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	struct buffer_head *cbh = NULL; /* For transactional checksums */
 	__u32 crc32_sum = ~0;
 	struct blk_plug plug;
+	/* Tail of the journal */
+	unsigned long first_block;
+	tid_t first_tid;
 
 	/*
 	 * First job: lock down the current transaction and wait for
@@ -675,6 +678,14 @@ start_journal_io:
 	J_ASSERT(commit_transaction->t_state == T_COMMIT);
 	commit_transaction->t_state = T_COMMIT_DFLUSH;
 	write_unlock(&journal->j_state_lock);
+	/*
+	 * Get current oldest transaction in the log before we issue flush
+	 * to the filesystem device. After the flush we can be sure that
+	 * blocks of all older transactions are checkpointed to persistent
+	 * storage and we will be safe to update journal start in the
+	 * superblock with the numbers we get here.
+	 */
+	jbd2_journal_get_log_tail(journal, &first_tid, &first_block);
 	/* 
 	 * If the journal is not located on the file system device,
 	 * then we must flush the file system device before we issue
@@ -825,6 +836,14 @@ wait_for_iobuf:
 	if (err)
 		jbd2_journal_abort(journal, err);
 
+	/*
+	 * Now disk caches are flushed so we are safe to erase checkpointed
+	 * transactions from the log by updating journal superblock.
+	 */
+	if (jbd2_update_log_tail(journal, first_tid, first_block) &&
+	    !(journal->j_flags & JBD2_ABORT))
+		jbd2_journal_update_superblock(journal, 1);
+
 	/* End of a transaction!  Finally, we can do checkpoint
            processing: any buffers committed as a result of this
            transaction can be removed from any checkpoint list it was on
-- 
1.7.1

