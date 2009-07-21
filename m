From: Jan Kara <jack@suse.cz>
Subject: [PATCH 3/5] jbd: Fix a race between checkpointing code and journal_get_write_access()
Date: Tue, 21 Jul 2009 12:04:17 +0200
Message-ID: <1248170659-11771-4-git-send-email-jack@suse.cz>
References: <1248170659-11771-1-git-send-email-jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:36320 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754590AbZGUKEV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Jul 2009 06:04:21 -0400
In-Reply-To: <1248170659-11771-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following race can happen:

  CPU1                          CPU2
                                checkpointing code checks the buffer, adds
                                  it to an array for writeback
do_get_write_access()
  ...
  lock_buffer()
  unlock_buffer()
                                  flush_batch() submits the buffer for IO
  __jbd_journal_file_buffer()

  So a buffer under writeout is returned from do_get_write_access(). Since
the filesystem code relies on the fact that journaled buffers cannot be
written out, it does not take the buffer lock and so it can modify buffer
while it is under writeout. That can lead to a filesystem corruption
if we crash at the right moment. The similar problem can happen with
the journal_get_create_access() path.
  We fix the problem by clearing the buffer dirty bit under buffer_lock
even if the buffer is on BJ_None list. Actually, we clear the dirty bit
regardless the list the buffer is in and warn about the fact if
the buffer is already journalled.

Thanks for spotting the problem goes to dingdinghua <dingdinghua85@gmail.com>.

Reported-by: dingdinghua <dingdinghua85@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd/transaction.c |   68 +++++++++++++++++++++++++------------------------
 1 files changed, 35 insertions(+), 33 deletions(-)

diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index 73242ba..c03ac11 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -489,34 +489,15 @@ void journal_unlock_updates (journal_t *journal)
 	wake_up(&journal->j_wait_transaction_locked);
 }
 
-/*
- * Report any unexpected dirty buffers which turn up.  Normally those
- * indicate an error, but they can occur if the user is running (say)
- * tune2fs to modify the live filesystem, so we need the option of
- * continuing as gracefully as possible.  #
- *
- * The caller should already hold the journal lock and
- * j_list_lock spinlock: most callers will need those anyway
- * in order to probe the buffer's journaling state safely.
- */
-static void jbd_unexpected_dirty_buffer(struct journal_head *jh)
+static void warn_dirty_buffer(struct buffer_head *bh)
 {
-	int jlist;
-
-	/* If this buffer is one which might reasonably be dirty
-	 * --- ie. data, or not part of this journal --- then
-	 * we're OK to leave it alone, but otherwise we need to
-	 * move the dirty bit to the journal's own internal
-	 * JBDDirty bit. */
-	jlist = jh->b_jlist;
+	char b[BDEVNAME_SIZE];
 
-	if (jlist == BJ_Metadata || jlist == BJ_Reserved ||
-	    jlist == BJ_Shadow || jlist == BJ_Forget) {
-		struct buffer_head *bh = jh2bh(jh);
-
-		if (test_clear_buffer_dirty(bh))
-			set_buffer_jbddirty(bh);
-	}
+	printk(KERN_WARNING
+	       "JBD: Spotted dirty metadata buffer (dev = %s, blocknr = %llu). "
+	       "There's a risk of filesystem corruption in case of system "
+	       "crash.\n",
+	       bdevname(bh->b_bdev, b), (unsigned long long)bh->b_blocknr);
 }
 
 /*
@@ -583,14 +564,16 @@ repeat:
 			if (jh->b_next_transaction)
 				J_ASSERT_JH(jh, jh->b_next_transaction ==
 							transaction);
+			warn_dirty_buffer(bh);
 		}
 		/*
 		 * In any case we need to clean the dirty flag and we must
 		 * do it under the buffer lock to be sure we don't race
 		 * with running write-out.
 		 */
-		JBUFFER_TRACE(jh, "Unexpected dirty buffer");
-		jbd_unexpected_dirty_buffer(jh);
+		JBUFFER_TRACE(jh, "Journalling dirty buffer");
+		clear_buffer_dirty(bh);
+		set_buffer_jbddirty(bh);
 	}
 
 	unlock_buffer(bh);
@@ -826,6 +809,15 @@ int journal_get_create_access(handle_t *handle, struct buffer_head *bh)
 	J_ASSERT_JH(jh, buffer_locked(jh2bh(jh)));
 
 	if (jh->b_transaction == NULL) {
+		/*
+		 * Previous journal_forget() could have left the buffer
+		 * with jbddirty bit set because it was being committed. When
+		 * the commit finished, we've filed the buffer for
+		 * checkpointing and marked it dirty. Now we are reallocating
+		 * the buffer so the transaction freeing it must have
+		 * committed and so it's safe to clear the dirty bit.
+		 */
+		clear_buffer_dirty(jh2bh(jh));
 		jh->b_transaction = transaction;
 
 		/* first access by this transaction */
@@ -1782,8 +1774,13 @@ static int __dispose_buffer(struct journal_head *jh, transaction_t *transaction)
 
 	if (jh->b_cp_transaction) {
 		JBUFFER_TRACE(jh, "on running+cp transaction");
+		/*
+		 * We don't want to write the buffer anymore, clear the
+		 * bit so that we don't confuse checks in
+		 * __journal_file_buffer
+		 */
+		clear_buffer_dirty(bh);
 		__journal_file_buffer(jh, transaction, BJ_Forget);
-		clear_buffer_jbddirty(bh);
 		may_free = 0;
 	} else {
 		JBUFFER_TRACE(jh, "on running transaction");
@@ -2041,12 +2038,17 @@ void __journal_file_buffer(struct journal_head *jh,
 	if (jh->b_transaction && jh->b_jlist == jlist)
 		return;
 
-	/* The following list of buffer states needs to be consistent
-	 * with __jbd_unexpected_dirty_buffer()'s handling of dirty
-	 * state. */
