From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [patch 6/6] jbd2: remove dependency on __GFP_NOFAIL
Date: Fri, 23 Jul 2010 10:10:54 -0400
Message-ID: <20100723141054.GE13090@thunk.org>
References: <alpine.DEB.2.00.1007201936210.8728@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1007201943340.8728@chino.kir.corp.google.com>
 <20100722141437.GA14882@thunk.org>
 <alpine.DEB.2.00.1007221108360.30080@chino.kir.corp.google.com>
 <20100722230935.GB16373@thunk.org>
 <alpine.DEB.2.00.1007221618001.4856@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger@sun.com>,
	Jiri Kosina <jkosina@suse.cz>, linux-mm@kvack.org,
	linux-ext4@vger.kernel.org
To: David Rientjes <rientjes@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:47156 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870Ab0GWOLQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 Jul 2010 10:11:16 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1007221618001.4856@chino.kir.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 22, 2010 at 04:24:23PM -0700, David Rientjes wrote:
> 
> I didn't think about converting the existing GFP_NOFS | __GFP_NOFAIL 
> callers into the do-while loop above until you mentioned it, thanks.  I'll 
> send patches to do that shortly.

Here's what I'm planning on queueing for the next merge window, along
with patches to ext4 to use jbd2__journal_start(..., GFP_KERNEL) in
places where we can afford to fail.  After doing some analysis, the
places where we can afford to fail are also the places where we can
use GFP_KERNEL instead of GFP_NOFS, so conveniently, I'm using the
lack of __GFP_FS to indicate that we should do the retry loop in
start_this_handle().  I also added the congestion_wait() call since
there's no point busy-looping the CPU while we're waiting for pages to
get swapped or paged out.

Comments would be appreciated.

    	      	    	    	      	     - Ted

>From 814be805d5e3d12343e590631ff9bc2d65c8f60a Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Fri, 23 Jul 2010 10:06:53 -0400
Subject: [PATCH] jbd2: Remove __GFP_NOFAIL from jbd2 layer

__GFP_NOFAIL is going away, so add our own retry loop.  Also add
jbd2__journal_start() and jbd2__journal_restart() which take a gfp
mask, so that file systems can optionally (re)start transaction
handles using GFP_KERNEL.  If they do this, then they need to be
prepared to handle receiving an PTR_ERR(-ENOMEM) error, and be ready
to reflect that error up to userspace.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/jbd2/journal.c     |   14 +++++++++--
 fs/jbd2/transaction.c |   60 +++++++++++++++++++++++++++++++++---------------
 include/linux/jbd2.h  |    4 ++-
 3 files changed, 55 insertions(+), 23 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index f7bf157..eb84fbd 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -48,8 +48,6 @@
 #include <asm/uaccess.h>
 #include <asm/page.h>
 
-EXPORT_SYMBOL(jbd2_journal_start);
-EXPORT_SYMBOL(jbd2_journal_restart);
 EXPORT_SYMBOL(jbd2_journal_extend);
 EXPORT_SYMBOL(jbd2_journal_stop);
 EXPORT_SYMBOL(jbd2_journal_lock_updates);
@@ -311,7 +309,17 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
 	 */
 	J_ASSERT_BH(bh_in, buffer_jbddirty(bh_in));
 
-	new_bh = alloc_buffer_head(GFP_NOFS|__GFP_NOFAIL);
+retry_alloc:
+	new_bh = alloc_buffer_head(GFP_NOFS);
+	if (!new_bh) {
+		/*
+		 * Failure is not an option, but __GFP_NOFAIL is going
+		 * away; so we retry ourselves here.
+		 */
+		congestion_wait(BLK_RW_ASYNC, HZ/50);
+		goto retry_alloc;
+	}
+
 	/* keep subsequent assertions sane */
 	new_bh->b_state = 0;
 	init_buffer(new_bh, NULL, NULL);
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index e214d68..43241c0 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -83,30 +83,39 @@ jbd2_get_transaction(journal_t *journal, transaction_t *transaction)
  * transaction's buffer credits.
  */
 
-static int start_this_handle(journal_t *journal, handle_t *handle)
+static int start_this_handle(journal_t *journal, handle_t *handle,
+			     int gfp_mask)
 {
 	transaction_t *transaction;
 	int needed;
 	int nblocks = handle->h_buffer_credits;
 	transaction_t *new_transaction = NULL;
-	int ret = 0;
 	unsigned long ts = jiffies;
 
 	if (nblocks > journal->j_max_transaction_buffers) {
 		printk(KERN_ERR "JBD: %s wants too many credits (%d > %d)\n",
 		       current->comm, nblocks,
 		       journal->j_max_transaction_buffers);
-		ret = -ENOSPC;
-		goto out;
+		return -ENOSPC;
 	}
 
 alloc_transaction:
 	if (!journal->j_running_transaction) {
-		new_transaction = kzalloc(sizeof(*new_transaction),
-						GFP_NOFS|__GFP_NOFAIL);
+	retry_alloc:
+		new_transaction = kzalloc(sizeof(*new_transaction), gfp_mask);
 		if (!new_transaction) {
-			ret = -ENOMEM;
-			goto out;
+			/*
+			 * If __GFP_FS is not present, then we may be
+			 * being called from inside the fs writeback
+			 * layer, so we MUST NOT fail.  Since
+			 * __GFP_NOFAIL is going away, we will arrange
+			 * to retry the allocation ourselves.
+			 */
+			if ((gfp & __GFP_FS) == 0) {
+				congestion_wait(BLK_RW_ASYNC, HZ/50);
+				goto retry_alloc;
+			}
+			return -ENOMEM;
 		}
 	}
 
@@ -123,8 +132,8 @@ repeat_locked:
 	if (is_journal_aborted(journal) ||
 	    (journal->j_errno != 0 && !(journal->j_flags & JBD2_ACK_ERR))) {
 		spin_unlock(&journal->j_state_lock);
-		ret = -EROFS;
-		goto out;
+		kfree(new_transaction);
+		return -EROFS;
 	}
 
 	/* Wait on the journal's transaction barrier if necessary */
@@ -240,10 +249,8 @@ repeat_locked:
 	spin_unlock(&journal->j_state_lock);
 
 	lock_map_acquire(&handle->h_lockdep_map);
-out:
-	if (unlikely(new_transaction))		/* It's usually NULL */
-		kfree(new_transaction);
-	return ret;
+	kfree(new_transaction);
+	return 0;
 }
 
 static struct lock_class_key jbd2_handle_key;
@@ -278,7 +285,7 @@ static handle_t *new_handle(int nblocks)
  *
  * Return a pointer to a newly allocated handle, or NULL on failure
  */
-handle_t *jbd2_journal_start(journal_t *journal, int nblocks)
+handle_t *jbd2__journal_start(journal_t *journal, int nblocks, int gfp_mask)
 {
 	handle_t *handle = journal_current_handle();
 	int err;
@@ -298,7 +305,7 @@ handle_t *jbd2_journal_start(journal_t *journal, int nblocks)
 
 	current->journal_info = handle;
 
-	err = start_this_handle(journal, handle);
+	err = start_this_handle(journal, handle, GFP_NOFS);
 	if (err < 0) {
 		jbd2_free_handle(handle);
 		current->journal_info = NULL;
@@ -308,6 +315,15 @@ handle_t *jbd2_journal_start(journal_t *journal, int nblocks)
 out:
 	return handle;
 }
+EXPORT_SYMBOL(jbd2__journal_start);
+
+
+handle_t *jbd2_journal_start(journal_t *journal, int nblocks)
+{
+	return jbd2__journal_start(journal, nblocks, GFP_NOFS);
+}
+EXPORT_SYMBOL(jbd2_journal_start);
+
 
 /**
  * int jbd2_journal_extend() - extend buffer credits.
@@ -394,8 +410,7 @@ out:
  * transaction capabable of guaranteeing the requested number of
  * credits.
  */
-
-int jbd2_journal_restart(handle_t *handle, int nblocks)
+int jbd2__journal_restart(handle_t *handle, int nblocks, int gfp_mask)
 {
 	transaction_t *transaction = handle->h_transaction;
 	journal_t *journal = transaction->t_journal;
@@ -428,10 +443,17 @@ int jbd2_journal_restart(handle_t *handle, int nblocks)
 
 	lock_map_release(&handle->h_lockdep_map);
 	handle->h_buffer_credits = nblocks;
-	ret = start_this_handle(journal, handle);
+	ret = start_this_handle(journal, handle, GFP_NOFS);
 	return ret;
 }
+EXPORT_SYMBOL(jbd2__journal_restart);
+
 
+int jbd2_journal_restart(handle_t *handle, int nblocks)
+{
+	return jbd2__journal_restart(handle, nblocks, GFP_NOFS);
+}
+EXPORT_SYMBOL(jbd2_journal_restart);
 
 /**
  * void jbd2_journal_lock_updates () - establish a transaction barrier.
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index a4d2e9f..5a72bc7 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1081,7 +1081,9 @@ static inline handle_t *journal_current_handle(void)
  */
 
 extern handle_t *jbd2_journal_start(journal_t *, int nblocks);
-extern int	 jbd2_journal_restart (handle_t *, int nblocks);
+extern handle_t *jbd2__journal_start(journal_t *, int nblocks, int gfp_mask);
+extern int	 jbd2_journal_restart(handle_t *, int nblocks);
+extern int	 jbd2__journal_restart(handle_t *, int nblocks, int gfp_mask);
 extern int	 jbd2_journal_extend (handle_t *, int nblocks);
 extern int	 jbd2_journal_get_write_access(handle_t *, struct buffer_head *);
 extern int	 jbd2_journal_get_create_access (handle_t *, struct buffer_head *);
-- 
1.7.0.4


