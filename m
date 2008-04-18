From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: [PATCH 1/4] jbd: strictly check for write errors on data buffers
Date: Fri, 18 Apr 2008 22:36:22 +0900
Message-ID: <4808A3D6.3050608@hitachi.com>
References: <48089B86.5020108@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jack@suse.cz, sugita <yumiko.sugita.yf@hitachi.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
To: akpm@linux-foundation.org, sct@redhat.com
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757493AbYDRNgo@vger.kernel.org>
In-Reply-To: <48089B86.5020108@hitachi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Subject: [PATCH 1/4] jbd: strictly check for write errors on data buffers

In ordered mode, we should abort journaling when an I/O error has
occurred on a file data buffer in the committing transaction.  But
there can be data buffers which are not checked for error:

  (a) the buffer which has already been written out by pdflush
  (b) the buffer which has been unlocked before scanned in the
      t_locked_list loop

This patch adds missing error checks and aborts journaling
appropriately.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitacih.com>
---
 fs/jbd/commit.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

Index: linux-2.6.25/fs/jbd/commit.c
===================================================================
--- linux-2.6.25.orig/fs/jbd/commit.c
+++ linux-2.6.25/fs/jbd/commit.c
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
@@ -426,8 +431,7 @@ void journal_commit_transaction(journal_
 	 * Now start flushing things to disk, in the order they appear
 	 * on the transaction lists.  Data blocks go first.
 	 */
-	err = 0;
-	journal_submit_data_buffers(journal, commit_transaction);
+	err = journal_submit_data_buffers(journal, commit_transaction);
 
 	/*
 	 * Wait for all previously submitted IO to complete.
@@ -442,10 +446,10 @@ void journal_commit_transaction(journal_
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
