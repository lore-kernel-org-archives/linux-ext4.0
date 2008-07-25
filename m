From: akpm@linux-foundation.org
Subject: - jbd-dont-abort-if-flushing-file-data-failed.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:56:52 -0700
Message-ID: <200807252256.m6PMuq0J003125@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: hidehiro.kawai.ez@hitachi.com, jack@suse.cz,
	linux-ext4@vger.kernel.org, mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     jbd: don't abort if flushing file data failed
has been removed from the -mm tree.  Its filename was
     jbd-dont-abort-if-flushing-file-data-failed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jbd: don't abort if flushing file data failed
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>

In ordered mode, the current jbd aborts the journal if a file data buffer
has an error.  But this behavior is unintended, and we found that it has
been adopted accidentally.

This patch undoes it and just calls printk() instead of aborting the
journal.  Additionally, set AS_EIO into the address_space object of the
failed buffer which is submitted by journal_do_submit_data() so that
fsync() can get -EIO.

Missing error checkings are also added to inform errors on file data
buffers to the user.  The following buffers are targeted.

  (a) the buffer which has already been written out by pdflush
  (b) the buffer which has been unlocked before scanned in the
      t_locked_list loop

[akpm@linux-foundation.org: improve grammar in a printk]
Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Acked-by: Jan Kara <jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/commit.c |   35 ++++++++++++++++++++++++++++-------
 1 file changed, 28 insertions(+), 7 deletions(-)

diff -puN fs/jbd/commit.c~jbd-dont-abort-if-flushing-file-data-failed fs/jbd/commit.c
--- a/fs/jbd/commit.c~jbd-dont-abort-if-flushing-file-data-failed
+++ a/fs/jbd/commit.c
@@ -185,7 +185,7 @@ static void journal_do_submit_data(struc
 /*
  *  Submit all the data buffers to disk
  */
-static void journal_submit_data_buffers(journal_t *journal,
+static int journal_submit_data_buffers(journal_t *journal,
 				transaction_t *commit_transaction)
 {
 	struct journal_head *jh;
@@ -193,6 +193,7 @@ static void journal_submit_data_buffers(
 	int locked;
 	int bufs = 0;
 	struct buffer_head **wbuf = journal->j_wbuf;
+	int err = 0;
 
 	/*
 	 * Whenever we unlock the journal and sleep, things can get added
@@ -266,6 +267,8 @@ write_out_data:
 			put_bh(bh);
 		} else {
 			BUFFER_TRACE(bh, "writeout complete: unfile");
+			if (unlikely(!buffer_uptodate(bh)))
+				err = -EIO;
 			__journal_unfile_buffer(jh);
 			jbd_unlock_bh_state(bh);
 			if (locked)
@@ -284,6 +287,8 @@ write_out_data:
 	}
 	spin_unlock(&journal->j_list_lock);
 	journal_do_submit_data(wbuf, bufs);
+
+	return err;
 }
 
 /*
@@ -423,8 +428,7 @@ void journal_commit_transaction(journal_
 	 * Now start flushing things to disk, in the order they appear
 	 * on the transaction lists.  Data blocks go first.
 	 */
-	err = 0;
-	journal_submit_data_buffers(journal, commit_transaction);
+	err = journal_submit_data_buffers(journal, commit_transaction);
 
 	/*
 	 * Wait for all previously submitted IO to complete.
@@ -439,10 +443,21 @@ void journal_commit_transaction(journal_
 		if (buffer_locked(bh)) {
 			spin_unlock(&journal->j_list_lock);
 			wait_on_buffer(bh);
-			if (unlikely(!buffer_uptodate(bh)))
-				err = -EIO;
 			spin_lock(&journal->j_list_lock);
 		}
+		if (unlikely(!buffer_uptodate(bh))) {
+			if (TestSetPageLocked(bh->b_page)) {
+				spin_unlock(&journal->j_list_lock);
+				lock_page(bh->b_page);
+				spin_lock(&journal->j_list_lock);
+			}
+			if (bh->b_page->mapping)
+				set_bit(AS_EIO, &bh->b_page->mapping->flags);
+
+			unlock_page(bh->b_page);
+			SetPageError(bh->b_page);
+			err = -EIO;
+		}
 		if (!inverted_lock(journal, bh)) {
 			put_bh(bh);
 			spin_lock(&journal->j_list_lock);
@@ -461,8 +476,14 @@ void journal_commit_transaction(journal_
 	}
 	spin_unlock(&journal->j_list_lock);
 
-	if (err)
-		journal_abort(journal, err);
+	if (err) {
+		char b[BDEVNAME_SIZE];
+
+		printk(KERN_WARNING
+			"JBD: Detected IO errors while flushing file data "
+			"on %s\n", bdevname(journal->j_fs_dev, b));
+		err = 0;
+	}
 
 	journal_write_revoke_records(journal, commit_transaction);
 
_

Patches currently in -mm which might be from hidehiro.kawai.ez@hitachi.com are

origin.patch

