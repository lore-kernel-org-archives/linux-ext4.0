From: Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH][take 5] JBD2: Fix race between free buffer and commit
	trasanction
Date: Wed, 28 May 2008 17:18:19 -0700
Message-ID: <1212020299.3791.57.camel@localhost.localdomain>
References: <1210971693.3608.46.camel@localhost.localdomain>
	 <20080518223739.GB11006@atrey.karlin.mff.cuni.cz>
	 <1211227158.3663.25.camel@localhost.localdomain>
	 <20080519132553.de9b78b0.akpm@linux-foundation.org>
	 <1211234829.3663.39.camel@localhost.localdomain>
	 <1211306575.3664.19.camel@localhost.localdomain>
	 <20080520235303.GB23521@atrey.karlin.mff.cuni.cz>
	 <1211390093.5571.16.camel@BVR-FS.beaverton.ibm.com>
	 <20080524224447.GE20563@atrey.karlin.mff.cuni.cz>
	 <1211998739.3791.20.camel@localhost.localdomain>
	 <20080528185554.GA16018@duck.suse.cz>
	 <1212020216.3791.54.camel@localhost.localdomain>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:41906 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753391AbYE2ASZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 May 2008 20:18:25 -0400
In-Reply-To: <1212020216.3791.54.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

journal_try_to_free_buffers() could race with jbd commit transaction when
the later is holding the buffer reference while waiting for the data buffer
to flush to disk. If the caller of journal_try_to_free_buffers() request
tries hard to release the buffers, it will treat the failure as error and return
back to the caller. We have seen the directo IO failed due to this race. 
Some of the caller of releasepage() also expecting the buffer to be dropped
when passed with GFP_KERNEL mask to the releasepage()->journal_try_to_free_buffers().

With this patch, if the caller is passing the __GFP_WAIT and __GFP_FS 
to indicating this call could wait, in case of try_to_free_buffers() failed,
let's waiting for journal_commit_transaction() to finish commit the 
current committing transaction, then try to free those buffers again.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Reviewed-by: Badari Pulavarty <pbadari@us.ibm.com>
Acked-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/transaction.c |   59 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 57 insertions(+), 2 deletions(-)

Index: linux-2.6.26-rc3/fs/jbd2/transaction.c
===================================================================
--- linux-2.6.26-rc3.orig/fs/jbd2/transaction.c	2008-05-28 16:10:41.000000000 -0700
+++ linux-2.6.26-rc3/fs/jbd2/transaction.c	2008-05-28 16:13:16.000000000 -0700
@@ -1656,12 +1656,42 @@ out:
 	return;
 }
 
+/*
+ * jbd2_journal_try_to_free_buffers() could race with jbd2_journal_commit_transaction()
+ * The later might still hold the reference count to the buffers when inspecting
+ * them on t_syncdata_list or t_locked_list.
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
@@ -1721,7 +1753,30 @@ int jbd2_journal_try_to_free_buffers(jou
 		if (buffer_jbd(bh))
 			goto busy;
 	} while ((bh = bh->b_this_page) != head);
+
 	ret = try_to_free_buffers(page);
+
+ 	/*
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
+        	spin_lock(&journal->j_state_lock);
+		jbd2_journal_wait_for_transaction_sync_data(journal);
+		ret = try_to_free_buffers(page);
+		spin_unlock(&journal->j_state_lock);
+	}
+
 busy:
 	return ret;
 }


