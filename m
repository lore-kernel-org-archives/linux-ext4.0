From: akpm@linux-foundation.org
Subject: - jbd-strictly-check-for-write-errors-on-data-buffers.patch removed from -mm tree
Date: Mon, 09 Jun 2008 15:12:04 -0700
Message-ID: <200806092212.m59MC553010889@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: hidehiro.kawai.ez@hitachi.com, hidehiro.kawai.ez@hitacih.com,
	jack@suse.cz, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     jbd: strictly check for write errors on data buffers
has been removed from the -mm tree.  Its filename was
     jbd-strictly-check-for-write-errors-on-data-buffers.patch

This patch was dropped because I don't think we want to go read-only on file data write errors

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jbd: strictly check for write errors on data buffers
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>

In ordered mode, we should abort journaling when an I/O error has occurred
on a file data buffer in the committing transaction.  But there can be
data buffers which are not checked for error:

  (a) the buffer which has already been written out by pdflush
  (b) the buffer which has been unlocked before scanned in the
      t_locked_list loop

This patch adds missing error checks and aborts journaling
appropriately.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitacih.com>
Acked-by: Jan Kara <jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/commit.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN fs/jbd/commit.c~jbd-strictly-check-for-write-errors-on-data-buffers fs/jbd/commit.c
--- a/fs/jbd/commit.c~jbd-strictly-check-for-write-errors-on-data-buffers
+++ a/fs/jbd/commit.c
@@ -172,7 +172,7 @@ static void journal_do_submit_data(struc
 /*
  *  Submit all the data buffers to disk
  */
-static void journal_submit_data_buffers(journal_t *journal,
+static int journal_submit_data_buffers(journal_t *journal,
 				transaction_t *commit_transaction)
 {
 	struct journal_head *jh;
@@ -180,6 +180,7 @@ static void journal_submit_data_buffers(
 	int locked;
 	int bufs = 0;
 	struct buffer_head **wbuf = journal->j_wbuf;
+	int err = 0;
 
 	/*
 	 * Whenever we unlock the journal and sleep, things can get added
@@ -253,6 +254,8 @@ write_out_data:
 			put_bh(bh);
 		} else {
 			BUFFER_TRACE(bh, "writeout complete: unfile");
+			if (unlikely(!buffer_uptodate(bh)))
+				err = -EIO;
 			__journal_unfile_buffer(jh);
 			jbd_unlock_bh_state(bh);
 			if (locked)
@@ -271,6 +274,8 @@ write_out_data:
 	}
 	spin_unlock(&journal->j_list_lock);
 	journal_do_submit_data(wbuf, bufs);
+
+	return err;
 }
 
 /*
@@ -410,8 +415,7 @@ void journal_commit_transaction(journal_
 	 * Now start flushing things to disk, in the order they appear
 	 * on the transaction lists.  Data blocks go first.
 	 */
-	err = 0;
-	journal_submit_data_buffers(journal, commit_transaction);
+	err = journal_submit_data_buffers(journal, commit_transaction);
 
 	/*
 	 * Wait for all previously submitted IO to complete.
@@ -426,10 +430,10 @@ void journal_commit_transaction(journal_
 		if (buffer_locked(bh)) {
 			spin_unlock(&journal->j_list_lock);
 			wait_on_buffer(bh);
-			if (unlikely(!buffer_uptodate(bh)))
-				err = -EIO;
 			spin_lock(&journal->j_list_lock);
 		}
+		if (unlikely(!buffer_uptodate(bh)))
+			err = -EIO;
 		if (!inverted_lock(journal, bh)) {
 			put_bh(bh);
 			spin_lock(&journal->j_list_lock);
_

Patches currently in -mm which might be from hidehiro.kawai.ez@hitachi.com are

jbd-strictly-check-for-write-errors-on-data-buffers.patch
jbd-ordered-data-integrity-fix.patch
jbd-abort-when-failed-to-log-metadata-buffers.patch
jbd-fix-error-handling-for-checkpoint-io.patch
ext3-abort-ext3-if-the-journal-has-aborted.patch
ext3-abort-ext3-if-the-journal-has-aborted-warning-fix.patch

