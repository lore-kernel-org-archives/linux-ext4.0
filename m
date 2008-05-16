From: Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH] JBD: Fix DIO EIO error caused by race between free buffer
	and commit trasanction
Date: Fri, 16 May 2008 14:01:33 -0700
Message-ID: <1210971693.3608.46.camel@localhost.localdomain>
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
	 <1210947250.3608.18.camel@localhost.localdomain>
	 <1210957976.4231.31.camel@badari-desktop>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>, akpm@linux-foundation.org,
	Badari Pulavarty <pbadari@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:52086 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbYEPVBn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 May 2008 17:01:43 -0400
In-Reply-To: <1210957976.4231.31.camel@badari-desktop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch fixed a few races between direct IO and kjournald commit transaction.
An unexpected EIO error gets returned to direct IO caller when it failed to
free those data buffers. This could be reproduced easily with parallel 
direct write and buffered write to the same file

More specific, those races could cause journal_try_to_free_buffers()
fail to free the data buffers, when jbd is committing the transaction that has
those data buffers on its t_syncdata_list or t_locked_list. 
journal_commit_transaction() still holds the reference to those buffers
 before data reach to disk and buffers are removed from the 
t_syncdata_list of t_locked_list. This prevent the concurrent 
journal_try_to_free_buffers() to free those buffers at the same time, but cause
EIO error returns back to direct IO.

With this patch, in case of direct IO and when try_to_free_buffers() failed,
let's waiting for journal_commit_transaction() to finish
flushing the current committing transaction's data buffers to disk, 
then try to free those buffers again.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Reviewed-by: Badari Pulavarty <pbadari@us.ibm.com> 
---
 fs/jbd/transaction.c |   57 +++++++++++++++++++++++++++++++++++++++++++++++++--
 mm/truncate.c        |    3 +-
 2 files changed, 57 insertions(+), 3 deletions(-)

Index: linux-2.6.26-rc2/fs/jbd/transaction.c
===================================================================
--- linux-2.6.26-rc2.orig/fs/jbd/transaction.c	2008-05-16 11:51:02.000000000 -0700
+++ linux-2.6.26-rc2/fs/jbd/transaction.c	2008-05-16 13:43:02.000000000 -0700
@@ -1648,12 +1648,39 @@ out:
 	return;
 }
 
+/*
+ * journal_try_to_free_buffers() could race with journal_commit_transaction()
+ * The later might still hold the reference count to the buffers when inspecting
+ * them on t_syncdata_list or t_locked_list.
+ *
+ * Journal_try_to_free_buffers() will call this function to
+ * wait for the current transaction to finish syncing data buffers, before
+ * try to free that buffer.
+ *
+ * Called with journal->j_state_lock hold.
+ */
+static void journal_wait_for_transaction_sync_data(journal_t *journal)
+{
+	transaction_t *transaction = NULL;
+	tid_t tid;
+
+	transaction = journal->j_committing_transaction;
+
+	if (!transaction)
+		return;
+
+	tid = transaction->t_tid;
+	spin_unlock(&journal->j_state_lock);
+	log_wait_commit(journal, tid);
+	spin_lock(&journal->j_state_lock);
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
@@ -1682,9 +1709,11 @@ out:
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
@@ -1713,7 +1742,31 @@ int journal_try_to_free_buffers(journal_
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
+	 * holds the reference to the buffers to free while processing them.
+	 * try_to_free_buffers() failed to free those buffers,
+	 * resulting in an unexpected EIO error
+	 * returns back to the generic_file_direct_IO()
+	 *
+	 * So let's wait for the current transaction to finish flush of
+	 * dirty data buffers before we try to free those buffers
+	 * again. This wait is needed by direct IO code path only,
+	 * gfp_mask __GFP_REPEAT is passed from the direct IO code
+	 * path to flag if we need to wait and retry free buffers.
+	 */
+	if (ret == 0 && gfp_mask & __GFP_REPEAT) {
+        	spin_lock(&journal->j_state_lock);
+		journal_wait_for_transaction_sync_data(journal);
+		ret = try_to_free_buffers(page);
+		spin_unlock(&journal->j_state_lock);
+	}
+
 busy:
 	return ret;
 }
Index: linux-2.6.26-rc2/mm/truncate.c
===================================================================
--- linux-2.6.26-rc2.orig/mm/truncate.c	2008-05-16 11:51:02.000000000 -0700
+++ linux-2.6.26-rc2/mm/truncate.c	2008-05-16 13:42:18.000000000 -0700
@@ -346,7 +346,8 @@ invalidate_complete_page2(struct address
 	if (page->mapping != mapping)
 		return 0;
 
-	if (PagePrivate(page) && !try_to_release_page(page, GFP_KERNEL))
+	if (PagePrivate(page) &&
+			!try_to_release_page(page,GFP_KERNEL|__GFP_REPEAT))
 		return 0;
 
 	write_lock_irq(&mapping->tree_lock);


