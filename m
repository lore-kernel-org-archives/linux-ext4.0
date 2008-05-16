From: Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH] Fix DIO EIO error caused by race between
	jbd_commit_transaction() and journal_try_to_drop_buffers()
Date: Fri, 16 May 2008 07:14:10 -0700
Message-ID: <1210947250.3608.18.camel@localhost.localdomain>
References: <20080429124321.GD1987@duck.suse.cz>
	 <1209654981.27240.19.camel@badari-desktop>
	 <20080505170636.GK25722@duck.suse.cz>
	 <1210372072.3639.52.camel@localhost.localdomain>
	 <20080512155419.GD15856@duck.suse.cz>
	 <1210639184.3661.43.camel@localhost.localdomain>
	 <20080513145449.GC20806@duck.suse.cz>
	 <1210717389.3638.24.camel@localhost.localdomain>
	 <20080514170856.GH24363@duck.suse.cz>
	 <1210786872.3657.48.camel@localhost.localdomain>
	 <20080514181444.GI24363@duck.suse.cz>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Badari Pulavarty <pbadari@us.ibm.com>, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:55830 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420AbYEPOOX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 May 2008 10:14:23 -0400
In-Reply-To: <20080514181444.GI24363@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch fixed a few races between direct IO and kjournld commit transaction.
An unexpected EIO error gets returned to direct IO caller when it failed to
free those data buffers. This could be reproduced easily with parallel 
direct write and buffered write to the same file

More specific, those races could cause journal_try_to_free_buffers()
fail to free the data buffers, when jbd is committing the transaction that has
those data buffers on its t_syncdata_list or t_locked_list. 
journal_commit_transaction() still holds the reference to those buffers
 before data reach to disk and buffers are removed from the 
t_syncdata_list of t_locked_list. This prevent the concurrent 
journal_try_to_free_buffers() to free those buffers at the same time, and cause
EIO error returns back to direct IO.

With this patch, in case of direct IO and when try_to_free_buffers() failed,
let's waiting for journal_commit_transaction() to finish
flushing the current committing transaction's data buffers to disk, 
then try to free those buffers again.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Reviewed-by: Badari Pulavarty <pbadari@us.ibm.com> 
---
 fs/jbd/commit.c      |    1 +
 fs/jbd/journal.c     |    1 +
 fs/jbd/transaction.c |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/jbd.h  |    3 +++
 4 files changed, 51 insertions(+)

Index: linux-2.6.26-rc1/include/linux/jbd.h
===================================================================
--- linux-2.6.26-rc1.orig/include/linux/jbd.h	2008-05-14 16:36:41.000000000 -0700
+++ linux-2.6.26-rc1/include/linux/jbd.h	2008-05-15 14:12:10.000000000 -0700
@@ -667,6 +667,9 @@ struct journal_s
 	 */
 	wait_queue_head_t	j_wait_transaction_locked;
 
+	/* Wait queu for waiting for data buffers to flushed to disk*/
+	wait_queue_head_t	j_wait_data_flushed;
+
 	/* Wait queue for waiting for checkpointing to complete */
 	wait_queue_head_t	j_wait_logspace;
 
Index: linux-2.6.26-rc1/fs/jbd/commit.c
===================================================================
--- linux-2.6.26-rc1.orig/fs/jbd/commit.c	2008-05-03 11:59:44.000000000 -0700
+++ linux-2.6.26-rc1/fs/jbd/commit.c	2008-05-15 14:12:46.000000000 -0700
@@ -462,6 +462,7 @@ void journal_commit_transaction(journal_
 	 * clean by now, so check that it is in fact empty.
 	 */
 	J_ASSERT (commit_transaction->t_sync_datalist == NULL);
+	wake_up(&journal->j_wait_data_flushed)
 
 	jbd_debug (3, "JBD: commit phase 3\n");
 
Index: linux-2.6.26-rc1/fs/jbd/journal.c
===================================================================
--- linux-2.6.26-rc1.orig/fs/jbd/journal.c	2008-05-14 16:36:41.000000000 -0700
+++ linux-2.6.26-rc1/fs/jbd/journal.c	2008-05-15 14:13:02.000000000 -0700
@@ -660,6 +660,7 @@ static journal_t * journal_init_common (
 		goto fail;
 
 	init_waitqueue_head(&journal->j_wait_transaction_locked);
+	init_waitqueue_head(&journal->j_wait_data_flushed);
 	init_waitqueue_head(&journal->j_wait_logspace);
 	init_waitqueue_head(&journal->j_wait_done_commit);
 	init_waitqueue_head(&journal->j_wait_checkpoint);
Index: linux-2.6.26-rc1/fs/jbd/transaction.c
===================================================================
--- linux-2.6.26-rc1.orig/fs/jbd/transaction.c	2008-05-03 11:59:44.000000000 -0700
+++ linux-2.6.26-rc1/fs/jbd/transaction.c	2008-05-16 06:42:30.000000000 -0700
@@ -1648,12 +1648,47 @@ out:
 	return;
 }
 
+/*
+ * Journal_try_to_free_buffers() will call this function to w
+ * waiting for the current transaction finishing syncing data buffers, before
+ * try to free that buffer.
+ *
+ * journal_try_to_free_buffers() could race with journal_commit_transaction()
+ * The later might still hold the reference count to the buffers when inspecting
+ * them on t_syncdata_list or t_locked_list.
+ */
+static void journal_wait_for_transaction_sync_data(journal_t *journal)
+{
+        transaction_t *transaction = NULL;
+
+        transaction = journal->j_committing_transaction;
+
+        if (!transaction)
+                return;
+
+        /*
+         * If the current transaction is flushing and waiting for data buffers
+	 * (t_state is T_FLUSH), wait for the j_wait_data_flushed event
+         */
+        if (transaction->t_state == T_FLUSH) {
+                DEFINE_WAIT(wait);
+
+                prepare_to_wait(&journal->j_wait_data_flushed,
+                                        &wait, TASK_UNINTERRUPTIBLE);
+                spin_unlock(&journal->j_state_lock);
+                schedule();
+                finish_wait(&journal->j_wait_data_flushed, &wait);
+        	spin_lock(&journal->j_state_lock);
+        }
+	return;
+}
 
 /**
  * int journal_try_to_free_buffers() - try to free page buffers.
  * @journal: journal for operation
  * @page: to try and free
- * @unused_gfp_mask: unused
+ * @gfp_mask: unused for allocation purpose. Here is used
+ * 	      as a flag to tell if direct IO is attemping to free buffers.
  *
  *
  * For all the buffers on this page,
@@ -1682,13 +1717,16 @@ out:
  * journal_try_to_free_buffer() is changing its state.  But that
  * cannot happen because we never reallocate freed data as metadata
  * while the data is part of a transaction.  Yes?
+ *
+ * Return 0 on failure, 1 on success
  */
 int journal_try_to_free_buffers(journal_t *journal,
-				struct page *page, gfp_t unused_gfp_mask)
+				struct page *page, gfp_t gfp_mask)
 {
 	struct buffer_head *head;
 	struct buffer_head *bh;
 	int ret = 0;
+	int dio = gfp_mask & __GFP_REPEAT;
 
 	J_ASSERT(PageLocked(page));
 
@@ -1713,7 +1751,31 @@ int journal_try_to_free_buffers(journal_
 		if (buffer_jbd(bh))
 			goto busy;
 	} while ((bh = bh->b_this_page) != head);
+
 	ret = try_to_free_buffers(page);
+
+ 	/*
+	 * In the case of concurrent direct IO and buffered IO,
+	 * There are a number of places where we
+	 * could race with journal_commit_transaction(), the later still
+	 * helds the reference to the buffers to free while processing them.
+	 * try_to_free_buffers() failed to free those buffers,
+	 * resulting in an unexpected EIO error
+	 * returns back to the generic_file_direct_IO()
+	 *
+	 * So let's wait for the current transaction finished flush
+	 * dirty data buffers before we try to free those buffers
+	 * again. This wait is needed by direct IO code path only,
+	 * gfp_mask __GFP_REPEAT is passed from the direct IO code
+	 * path to flag if we need to wait and retry free buffers.
+	 */
+	if (ret == 0 && dio) {
+        	spin_lock(&journal->j_state_lock);
+		journal_wait_for_transaction_sync_data(journal);
+		ret = try_to_free_buffers(page);
+	       	spin_unlock(&journal->j_state_lock);
+	}
+
 busy:
 	return ret;
 }
Index: linux-2.6.26-rc1/mm/truncate.c
===================================================================
--- linux-2.6.26-rc1.orig/mm/truncate.c	2008-05-03 11:59:44.000000000 -0700
+++ linux-2.6.26-rc1/mm/truncate.c	2008-05-15 13:13:21.000000000 -0700
@@ -346,7 +346,8 @@ invalidate_complete_page2(struct address
 	if (page->mapping != mapping)
 		return 0;
 
-	if (PagePrivate(page) && !try_to_release_page(page, GFP_KERNEL))
+	if (PagePrivate(page) &&
+			!try_to_release_page(page,GFP_KERNEL|__GFP_REPEAT))
 		return 0;
 
 	write_lock_irq(&mapping->tree_lock);


