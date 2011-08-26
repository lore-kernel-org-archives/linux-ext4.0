From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH -v3] jbd2: add debugging information to jbd2_journal_dirty_metadata()
Date: Thu, 25 Aug 2011 22:35:15 -0400
Message-ID: <1314326115-25651-1-git-send-email-tytso@mit.edu>
References: <CAO81RMYGK18-_5OKjeBzyku7AYUioJgGAic12Tyt87zMuvnVWQ@mail.gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, curtw@google.com
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:39409 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754921Ab1HZCfS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Aug 2011 22:35:18 -0400
In-Reply-To: <CAO81RMYGK18-_5OKjeBzyku7AYUioJgGAic12Tyt87zMuvnVWQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add debugging information in case jbd2_journal_dirty_metadata() is
called with a buffer_head which didn't have
jbd2_journal_get_write_access() called on it, or if the journal_head
has the wrong transaction in it.  In addition, return an error code.
This won't change anything for ocfs2, which will BUG_ON() the non-zero
exit code.

For ext4, the caller of this function is ext4_handle_dirty_metadata(),
and on seeing a non-zero return code, will call
ext4_journal_abort_handle(), which will print the function and line
number of the calling function that screwed up and abort the journal.
This will allow us to recover instead of bug halting, which is better
from a robustness and reliability point of view.

Cc: curtw@google.com
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---

This is a revised version of a patch originally called "jbd2: instrument
jh on wrong transaction BUG_ON's".  I now believe that what is going on
is that the bug is caused by jbd2_journal_dirty_metadata() being called
on a buffer head that did not have jbd2_journal_get_write_access()
called on it first.  In that case the BH_JBD flag will not be set in
b_state, and b_private is undefined, but usually zero.  That would
explain some of the crashes that we have seen.   This patch makes
jbd2_journal_dirty_metadata() more robust, in that it will detect any
potential programming errors of this type, and in such a way that the it
will be easy to determine which function was at fault.

 fs/jbd2/transaction.c |   59 ++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 53 insertions(+), 6 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 2d71094..8c640f0 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1049,6 +1049,10 @@ void jbd2_buffer_abort_trigger(struct journal_head *jh,
  * mark dirty metadata which needs to be journaled as part of the current
  * transaction.
  *
+ * The buffer must have previously had jbd2_journal_get_write_access()
+ * called so that it has a valid journal_head attached to the buffer
+ * head.
+ *
  * The buffer is placed on the transaction's metadata list and is marked
  * as belonging to the transaction.
  *
@@ -1065,11 +1069,16 @@ int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
 	transaction_t *transaction = handle->h_transaction;
 	journal_t *journal = transaction->t_journal;
 	struct journal_head *jh = bh2jh(bh);
+	int ret = 0;
 
 	jbd_debug(5, "journal_head %p\n", jh);
 	JBUFFER_TRACE(jh, "entry");
 	if (is_handle_aborted(handle))
 		goto out;
+	if (!buffer_jbd(bh)) {
+		ret = -EUCLEAN;
+		goto out;
+	}
 
 	jbd_lock_bh_state(bh);
 
@@ -1093,8 +1102,20 @@ int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
 	 */
 	if (jh->b_transaction == transaction && jh->b_jlist == BJ_Metadata) {
 		JBUFFER_TRACE(jh, "fastpath");
-		J_ASSERT_JH(jh, jh->b_transaction ==
-					journal->j_running_transaction);
+		if (unlikely(jh->b_transaction !=
+			     journal->j_running_transaction)) {
+			printk(KERN_EMERG "JBD: %s: "
+			       "jh->b_transaction (%llu, %p, %u) != "
+			       "journal->j_running_transaction (%p, %u)",
+			       journal->j_devname,
+			       (unsigned long long) bh->b_blocknr,
+			       jh->b_transaction,
+			       jh->b_transaction ? jh->b_transaction->t_tid : 0,
+			       journal->j_running_transaction,
+			       journal->j_running_transaction ?
+			         journal->j_running_transaction->t_tid : 0);
+			ret = -EINVAL;
+		}
 		goto out_unlock_bh;
 	}
 
@@ -1108,9 +1129,33 @@ int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
 	 */
 	if (jh->b_transaction != transaction) {
 		JBUFFER_TRACE(jh, "already on other transaction");
-		J_ASSERT_JH(jh, jh->b_transaction ==
-					journal->j_committing_transaction);
-		J_ASSERT_JH(jh, jh->b_next_transaction == transaction);
+		if (unlikely(jh->b_transaction !=
+			     journal->j_committing_transaction)) {
+			printk(KERN_EMERG "JBD: %s: "
+			       "jh->b_transaction (%llu, %p, %u) != "
+			       "journal->j_committing_transaction (%p, %u)",
+			       journal->j_devname,
+			       (unsigned long long) bh->b_blocknr,
+			       jh->b_transaction,
+			       jh->b_transaction ? jh->b_transaction->t_tid : 0,
+			       journal->j_committing_transaction,
+			       journal->j_committing_transaction ?
+			         journal->j_committing_transaction->t_tid : 0);
+			ret = -EINVAL;
+		}
+		if (unlikely(jh->b_next_transaction != transaction)) {
+			printk(KERN_EMERG "JBD: %s: "
+			       "jh->b_next_transaction (%llu, %p, %u) != "
+			       "transaction (%p, %u)",
+			       journal->j_devname,
+			       (unsigned long long) bh->b_blocknr,
+			       jh->b_next_transaction,
+			       jh->b_next_transaction ?
+			         jh->b_next_transaction->t_tid : 0,
+			       transaction,
+			       transaction ? transaction->t_tid : 0);
+			ret = -EINVAL;
+		}
 		/* And this case is illegal: we can't reuse another
 		 * transaction's data buffer, ever. */
 		goto out_unlock_bh;
@@ -1127,7 +1172,9 @@ out_unlock_bh:
 	jbd_unlock_bh_state(bh);
 out:
 	JBUFFER_TRACE(jh, "exit");
-	return 0;
+	if (ret)
+		__WARN();	/* All errors are bugs, so dump the stack */
+	return ret;
 }
 
 /*
-- 
1.7.4.1.22.gec8e1.dirty

