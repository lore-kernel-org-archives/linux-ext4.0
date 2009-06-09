From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: [PATCH] jbd/jbd2 :clean up journal_try_to_free_buffers
Date: Tue, 09 Jun 2009 09:06:22 +0900
Message-ID: <6.0.0.20.2.20090604194409.071baf80@172.19.0.2>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>,
	Theodore Tso <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi.

I delete the following patch 
"commit 3f31fddfa26b7594b44ff2b34f9a04ba409e0f91
Author: Mingming Cao <cmm@us.ibm.com>
Date:   Fri Jul 25 01:46:22 2008 -0700

    jbd: fix race between free buffer and commit transaction
" 
This patch is no longer needed because if race between freeing buffer
and committing transaction functionality occurs and dio gets error,
currently dio falls back to buffered IO by the following patch.

	commit 6ccfa806a9cfbbf1cd43d5b6aa47ef2c0eb518fd
	Author: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
	Date:   Tue Sep 2 14:35:40 2008 -0700

   	VFS: fix dio write returning EIO when try_to_release_page fails 

Thanks.

Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

diff -Nrup linux-2.6.30-rc8.org/fs/jbd/transaction.c linux-2.6.30-rc8.ext3_4/fs/jbd/transaction.c
--- linux-2.6.30-rc8.org/fs/jbd/transaction.c	2009-06-04 16:26:26.000000000 +0900
+++ linux-2.6.30-rc8.ext3_4/fs/jbd/transaction.c	2009-06-04 19:14:53.000000000 +0900
@@ -1686,35 +1686,6 @@ out:
 	return;
 }
 
-/*
- * journal_try_to_free_buffers() could race with journal_commit_transaction()
- * The latter might still hold the a count on buffers when inspecting
- * them on t_syncdata_list or t_locked_list.
- *
- * journal_try_to_free_buffers() will call this function to
- * wait for the current transaction to finish syncing data buffers, before
- * tryinf to free that buffer.
- *
- * Called with journal->j_state_lock held.
- */
-static void journal_wait_for_transaction_sync_data(journal_t *journal)
-{
-	transaction_t *transaction = NULL;
-	tid_t tid;
-
-	spin_lock(&journal->j_state_lock);
-	transaction = journal->j_committing_transaction;
-
-	if (!transaction) {
-		spin_unlock(&journal->j_state_lock);
-		return;
-	}
-
-	tid = transaction->t_tid;
-	spin_unlock(&journal->j_state_lock);
-	log_wait_commit(journal, tid);
-}
-
 /**
  * int journal_try_to_free_buffers() - try to free page buffers.
  * @journal: journal for operation
@@ -1786,25 +1757,6 @@ int journal_try_to_free_buffers(journal_
 
 	ret = try_to_free_buffers(page);
 
-	/*
-	* There are a number of places where journal_try_to_free_buffers()
-	* could race with journal_commit_transaction(), the later still
-	* holds the reference to the buffers to free while processing them.
-	* try_to_free_buffers() failed to free those buffers. Some of the
-	* caller of releasepage() request page buffers to be dropped, otherwise
-	* treat the fail-to-free as errors (such as generic_file_direct_IO())
-	*
-	* So, if the caller of try_to_release_page() wants the synchronous
-	* behaviour(i.e make sure buffers are dropped upon return),
-	* let's wait for the current transaction to finish flush of
-	* dirty data buffers, then try to free those buffers again,
-	* with the journal locked.
-	*/
-	if (ret == 0 && (gfp_mask & __GFP_WAIT) && (gfp_mask & __GFP_FS)) {
-		journal_wait_for_transaction_sync_data(journal);
-		ret = try_to_free_buffers(page);
-	}
-
 busy:
 	return ret;
 }
diff -Nrup linux-2.6.30-rc8.org/fs/jbd2/transaction.c linux-2.6.30-rc8.ext3_4/fs/jbd2/transaction.c
--- linux-2.6.30-rc8.org/fs/jbd2/transaction.c	2009-06-04 16:26:26.000000000 +0900
+++ linux-2.6.30-rc8.ext3_4/fs/jbd2/transaction.c	2009-06-04 19:17:12.000000000 +0900
@@ -1547,36 +1547,6 @@ out:
 	return;
 }
 
-/*
- * jbd2_journal_try_to_free_buffers() could race with
- * jbd2_journal_commit_transaction(). The later might still hold the
- * reference count to the buffers when inspecting them on
- * t_syncdata_list or t_locked_list.
- *
- * jbd2_journal_try_to_free_buffers() will call this function to
- * wait for the current transaction to finish syncing data buffers, before
- * try to free that buffer.
- *
- * Called with journal->j_state_lock hold.
- */
-static void jbd2_journal_wait_for_transaction_sync_data(journal_t *journal)
-{
-	transaction_t *transaction;
-	tid_t tid;
-
-	spin_lock(&journal->j_state_lock);
-	transaction = journal->j_committing_transaction;
-
-	if (!transaction) {
-		spin_unlock(&journal->j_state_lock);
-		return;
-	}
-
-	tid = transaction->t_tid;
-	spin_unlock(&journal->j_state_lock);
-	jbd2_log_wait_commit(journal, tid);
-}
-
 /**
  * int jbd2_journal_try_to_free_buffers() - try to free page buffers.
  * @journal: journal for operation
@@ -1649,25 +1619,6 @@ int jbd2_journal_try_to_free_buffers(jou
 
 	ret = try_to_free_buffers(page);
 
-	/*
-	* There are a number of places where jbd2_journal_try_to_free_buffers()
-	* could race with jbd2_journal_commit_transaction(), the later still
-	* holds the reference to the buffers to free while processing them.
-	* try_to_free_buffers() failed to free those buffers. Some of the
-	* caller of releasepage() request page buffers to be dropped, otherwise
-	* treat the fail-to-free as errors (such as generic_file_direct_IO())
-	*
-	* So, if the caller of try_to_release_page() wants the synchronous
-	* behaviour(i.e make sure buffers are dropped upon return),
-	* let's wait for the current transaction to finish flush of
-	* dirty data buffers, then try to free those buffers again,
-	* with the journal locked.
-	*/
-	if (ret == 0 && (gfp_mask & __GFP_WAIT) && (gfp_mask & __GFP_FS)) {
-		jbd2_journal_wait_for_transaction_sync_data(journal);
-		ret = try_to_free_buffers(page);
-	}
-
 busy:
 	return ret;
 }

