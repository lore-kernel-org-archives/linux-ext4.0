From: Jan Kara <jack@suse.cz>
Subject: [PATCH] jbd: Fix a race between checkpointing code and journal_get_write_access()
Date: Wed, 24 Jun 2009 18:02:39 +0200
Message-ID: <1245859360-5261-1-git-send-email-jack@suse.cz>
Cc: tytso@mit.edu, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43316 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758697AbZFXQCl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Jun 2009 12:02:41 -0400
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
if we crash at the right moment.
  We fix the problem by clearing the buffer dirty bit under buffer_lock
even if the buffer is on BJ_None list. Actually, we clear the dirty bit
regardless the list the buffer is in and warn about the fact if
the buffer is already journalled.

Thanks for spotting the problem goes to dingdinghua <dingdinghua85@gmail.com>.

Reported-by: dingdinghua <dingdinghua85@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd/transaction.c |   52 +++++++++++++++++++------------------------------
 1 files changed, 20 insertions(+), 32 deletions(-)

diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index 73242ba..e9e141d 100644
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
-
-	if (jlist == BJ_Metadata || jlist == BJ_Reserved ||
-	    jlist == BJ_Shadow || jlist == BJ_Forget) {
-		struct buffer_head *bh = jh2bh(jh);
+	char b[BDEVNAME_SIZE];
 
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
@@ -2041,12 +2024,17 @@ void __journal_file_buffer(struct journal_head *jh,
 	if (jh->b_transaction && jh->b_jlist == jlist)
 		return;
 
-	/* The following list of buffer states needs to be consistent
-	 * with __jbd_unexpected_dirty_buffer()'s handling of dirty
-	 * state. */
