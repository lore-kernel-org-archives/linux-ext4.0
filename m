From: akpm@linux-foundation.org
Subject: [patch 1/1] jbd2: clean up jbd2_journal_try_to_free_buffers()
Date: Wed, 10 Jun 2009 12:55:41 -0700
Message-ID: <200906101955.n5AJtfKG008766@imap1.linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
	hifumi.hisashi@oss.ntt.co.jp, cmm@us.ibm.com, jack@suse.cz
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761512AbZFJTzt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Jun 2009 15:55:49 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

I delete the following patch
"commit 3f31fddfa26b7594b44ff2b34f9a04ba409e0f91
Author: Mingming Cao <cmm@us.ibm.com>
Date:   Fri Jul 25 01:46:22 2008 -0700

    jbd: fix race between free buffer and commit transaction


This patch is no longer needed because if race between freeing buffer and
committing transaction functionality occurs and dio gets error, currently
dio falls back to buffered IO by the following patch.

	commit 6ccfa806a9cfbbf1cd43d5b6aa47ef2c0eb518fd
	Author: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
	Date:   Tue Sep 2 14:35:40 2008 -0700

   	VFS: fix dio write returning EIO when try_to_release_page fails

Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Cc: Theodore Tso <tytso@mit.edu>
Cc: Mingming Cao <cmm@us.ibm.com>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd2/transaction.c |   49 ----------------------------------------
 1 file changed, 49 deletions(-)

diff -puN fs/jbd2/transaction.c~jbd2-clean-up-jbd2_journal_try_to_free_buffers fs/jbd2/transaction.c
--- a/fs/jbd2/transaction.c~jbd2-clean-up-jbd2_journal_try_to_free_buffers
+++ a/fs/jbd2/transaction.c
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
-	 * There are a number of places where jbd2_journal_try_to_free_buffers()
-	 * could race with jbd2_journal_commit_transaction(), the later still
-	 * holds the reference to the buffers to free while processing them.
-	 * try_to_free_buffers() failed to free those buffers. Some of the
-	 * caller of releasepage() request page buffers to be dropped, otherwise
-	 * treat the fail-to-free as errors (such as generic_file_direct_IO())
-	 *
-	 * So, if the caller of try_to_release_page() wants the synchronous
-	 * behaviour(i.e make sure buffers are dropped upon return),
-	 * let's wait for the current transaction to finish flush of
-	 * dirty data buffers, then try to free those buffers again,
-	 * with the journal locked.
-	 */
-	if (ret == 0 && (gfp_mask & __GFP_WAIT) && (gfp_mask & __GFP_FS)) {
-		jbd2_journal_wait_for_transaction_sync_data(journal);
-		ret = try_to_free_buffers(page);
-	}
