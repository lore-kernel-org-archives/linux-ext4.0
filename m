From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 14/52] jbd2: fix race between jbd2_journal_try_to_free_buffers() and jbd2 commit transaction
Date: Sat,  5 Jul 2008 13:35:40 -0400
Message-ID: <1215279378-30504-15-git-send-email-tytso@mit.edu>
References: <1215279378-30504-1-git-send-email-tytso@mit.edu>
 <1215279378-30504-2-git-send-email-tytso@mit.edu>
 <1215279378-30504-3-git-send-email-tytso@mit.edu>
 <1215279378-30504-4-git-send-email-tytso@mit.edu>
 <1215279378-30504-5-git-send-email-tytso@mit.edu>
 <1215279378-30504-6-git-send-email-tytso@mit.edu>
 <1215279378-30504-7-git-send-email-tytso@mit.edu>
 <1215279378-30504-8-git-send-email-tytso@mit.edu>
 <1215279378-30504-9-git-send-email-tytso@mit.edu>
 <1215279378-30504-10-git-send-email-tytso@mit.edu>
 <1215279378-30504-11-git-send-email-tytso@mit.edu>
 <1215279378-30504-12-git-send-email-tytso@mit.edu>
 <1215279378-30504-13-git-send-email-tytso@mit.edu>
 <1215279378-30504-14-git-send-email-tytso@mit.edu>
Cc: Mingming Cao <cmm@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33089 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755942AbYGERgc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Jul 2008 13:36:32 -0400
In-Reply-To: <1215279378-30504-14-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Mingming Cao <cmm@us.ibm.com>

journal_try_to_free_buffers() could race with jbd commit transaction
when the later is holding the buffer reference while waiting for the
data buffer to flush to disk. If the caller of
journal_try_to_free_buffers() request tries hard to release the buffers,
it will treat the failure as error and return back to the caller. We
have seen the directo IO failed due to this race.  Some of the caller of
releasepage() also expecting the buffer to be dropped when passed with
GFP_KERNEL mask to the releasepage()->journal_try_to_free_buffers().

With this patch, if the caller is passing the GFP_KERNEL to indicating
this call could wait, in case of try_to_free_buffers() failed, let's
waiting for journal_commit_transaction() to finish commit the current
committing transaction , then try to free those buffers again with
journal locked.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Reviewed-by: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/jbd2/transaction.c |   62 +++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 58 insertions(+), 4 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index d6e006e..8525dff 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -41,7 +41,6 @@ static void __jbd2_journal_temp_unlink_buffer(struct journal_head *jh);
  *	new transaction	and we can't block without protecting against other
  *	processes trying to touch the journal while it is in transition.
  *
- * Called under j_state_lock
  */
 
 static transaction_t *
@@ -1656,12 +1655,43 @@ out:
 	return;
 }
 
+/*
+ * jbd2_journal_try_to_free_buffers() could race with
+ * jbd2_journal_commit_transaction(). The later might still hold the
+ * reference count to the buffers when inspecting them on
+ * t_syncdata_list or t_locked_list.
+ *
+ * jbd2_journal_try_to_free_buffers() will call this function to
+ * wait for the current transaction to finish syncing data buffers, before
+ * try to free that buffer.
+ *
+ * Called with journal->j_state_lock hold.
+ */
+static void jbd2_journal_wait_for_transaction_sync_data(journal_t *journal)
+{
+	transaction_t *transaction = NULL;
+	tid_t tid;
+
+	spin_lock(&journal->j_state_lock);
+	transaction = journal->j_committing_transaction;
+
+	if (!transaction) {
+		spin_unlock(&journal->j_state_lock);
+		return;
+	}
+
+	tid = transaction->t_tid;
+	spin_unlock(&journal->j_state_lock);
+	jbd2_log_wait_commit(journal, tid);
+}
 
 /**
  * int jbd2_journal_try_to_free_buffers() - try to free page buffers.
  * @journal: journal for operation
  * @page: to try and free
- * @unused_gfp_mask: unused
+ * @gfp_mask: we use the mask to detect how hard should we try to release
+ * buffers. If __GFP_WAIT and __GFP_FS is set, we wait for commit code to
+ * release the buffers.
  *
  *
  * For all the buffers on this page,
@@ -1690,9 +1720,11 @@ out:
  * journal_try_to_free_buffer() is changing its state.  But that
  * cannot happen because we never reallocate freed data as metadata
  * while the data is part of a transaction.  Yes?
+ *
+ * Return 0 on failure, 1 on success
  */
 int jbd2_journal_try_to_free_buffers(journal_t *journal,
-				struct page *page, gfp_t unused_gfp_mask)
+				struct page *page, gfp_t gfp_mask)
 {
 	struct buffer_head *head;
 	struct buffer_head *bh;
@@ -1708,7 +1740,8 @@ int jbd2_journal_try_to_free_buffers(journal_t *journal,
 		/*
 		 * We take our own ref against the journal_head here to avoid
 		 * having to add tons of locking around each instance of
-		 * jbd2_journal_remove_journal_head() and jbd2_journal_put_journal_head().
+		 * jbd2_journal_remove_journal_head() and
+		 * jbd2_journal_put_journal_head().
 		 */
 		jh = jbd2_journal_grab_journal_head(bh);
 		if (!jh)
@@ -1721,7 +1754,28 @@ int jbd2_journal_try_to_free_buffers(journal_t *journal,
 		if (buffer_jbd(bh))
 			goto busy;
 	} while ((bh = bh->b_this_page) != head);
+
 	ret = try_to_free_buffers(page);
+
+	/*
+	 * There are a number of places where jbd2_journal_try_to_free_buffers()
+	 * could race with jbd2_journal_commit_transaction(), the later still
+	 * holds the reference to the buffers to free while processing them.
+	 * try_to_free_buffers() failed to free those buffers. Some of the
+	 * caller of releasepage() request page buffers to be dropped, otherwise
+	 * treat the fail-to-free as errors (such as generic_file_direct_IO())
+	 *
+	 * So, if the caller of try_to_release_page() wants the synchronous
+	 * behaviour(i.e make sure buffers are dropped upon return),
+	 * let's wait for the current transaction to finish flush of
+	 * dirty data buffers, then try to free those buffers again,
+	 * with the journal locked.
+	 */
+	if (ret == 0 && (gfp_mask & __GFP_WAIT) && (gfp_mask & __GFP_FS)) {
+		jbd2_journal_wait_for_transaction_sync_data(journal);
+		ret = try_to_free_buffers(page);
+	}
+
 busy:
 	return ret;
 }
-- 
1.5.6.rc3.1.g36b7.dirty

