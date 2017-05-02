From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/7] jbd2: Cleanup write flags handling from jbd2_write_superblock()
Date: Tue,  2 May 2017 17:03:46 +0200
Message-ID: <20170502150351.29452-3-jack@suse.cz>
References: <20170502150351.29452-1-jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: <linux-fsdevel@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170502150351.29452-1-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Currently jbd2_write_superblock() silently adds REQ_SYNC to flags with
which journal superblock is written. Make this explicit by making flags
passed down to jbd2_write_superblock() contain REQ_SYNC.

CC: "Theodore Ts'o" <tytso@mit.edu>
CC: linux-ext4@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/journal.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index e768126f6a72..cc2038f2f41a 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -913,7 +913,8 @@ int __jbd2_update_log_tail(journal_t *journal, tid_t tid, unsigned long block)
 	 * space and if we lose sb update during power failure we'd replay
 	 * old transaction with possibly newly overwritten data.
 	 */
-	ret = jbd2_journal_update_sb_log_tail(journal, tid, block, REQ_FUA);
+	ret = jbd2_journal_update_sb_log_tail(journal, tid, block,
+					      REQ_SYNC | REQ_FUA);
 	if (ret)
 		goto out;
 
@@ -1314,7 +1315,7 @@ static int journal_reset(journal_t *journal)
 		jbd2_journal_update_sb_log_tail(journal,
 						journal->j_tail_sequence,
 						journal->j_tail,
-						REQ_FUA);
+						REQ_SYNC | REQ_FUA);
 		mutex_unlock(&journal->j_checkpoint_mutex);
 	}
 	return jbd2_journal_start_thread(journal);
@@ -1348,7 +1349,7 @@ static int jbd2_write_superblock(journal_t *journal, int write_flags)
 	jbd2_superblock_csum_set(journal, sb);
 	get_bh(bh);
 	bh->b_end_io = end_buffer_write_sync;
-	ret = submit_bh(REQ_OP_WRITE, write_flags | REQ_SYNC, bh);
+	ret = submit_bh(REQ_OP_WRITE, write_flags, bh);
 	wait_on_buffer(bh);
 	if (buffer_write_io_error(bh)) {
 		clear_buffer_write_io_error(bh);
@@ -1454,7 +1455,7 @@ void jbd2_journal_update_sb_errno(journal_t *journal)
 	sb->s_errno    = cpu_to_be32(journal->j_errno);
 	read_unlock(&journal->j_state_lock);
 
-	jbd2_write_superblock(journal, REQ_FUA);
+	jbd2_write_superblock(journal, REQ_SYNC | REQ_FUA);
 }
 EXPORT_SYMBOL(jbd2_journal_update_sb_errno);
 
@@ -1721,7 +1722,7 @@ int jbd2_journal_destroy(journal_t *journal)
 			write_unlock(&journal->j_state_lock);
 
 			jbd2_mark_journal_empty(journal,
-					REQ_PREFLUSH | REQ_FUA);
+					REQ_SYNC | REQ_PREFLUSH | REQ_FUA);
 			mutex_unlock(&journal->j_checkpoint_mutex);
 		} else
 			err = -EIO;
@@ -1980,7 +1981,7 @@ int jbd2_journal_flush(journal_t *journal)
 	 * the magic code for a fully-recovered superblock.  Any future
 	 * commits of data to the journal will restore the current
 	 * s_start value. */
-	jbd2_mark_journal_empty(journal, REQ_FUA);
+	jbd2_mark_journal_empty(journal, REQ_SYNC | REQ_FUA);
 	mutex_unlock(&journal->j_checkpoint_mutex);
 	write_lock(&journal->j_state_lock);
 	J_ASSERT(!journal->j_running_transaction);
@@ -2026,7 +2027,7 @@ int jbd2_journal_wipe(journal_t *journal, int write)
 	if (write) {
 		/* Lock to make assertions happy... */
 		mutex_lock(&journal->j_checkpoint_mutex);
-		jbd2_mark_journal_empty(journal, REQ_FUA);
+		jbd2_mark_journal_empty(journal, REQ_SYNC | REQ_FUA);
 		mutex_unlock(&journal->j_checkpoint_mutex);
 	}
 
-- 
2.12.0
