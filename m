From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] jbd2: instrument jh on wrong transaction BUG_ON's
Date: Sat, 13 Aug 2011 22:53:38 -0400
Message-ID: <1313290418-12695-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, curtw@google.com
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53078 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272Ab1HNCxm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 13 Aug 2011 22:53:42 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

These assertions have been reported as being tripped.  Instrument them
so we get more information about what might be going on.

Cc: curtw@google.com
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---

Curt, you might want to see if you can replicate that jbd2 crash with
this patch applied.  Hopefully we'll get more information about what is
going on.

 fs/jbd2/transaction.c |   42 +++++++++++++++++++++++++++++++++++++-----
 1 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 2d71094..693fe63 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1093,8 +1093,19 @@ int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
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
+			       jh->b_transaction->t_tid,
+			       journal->j_running_transaction,
+			       journal->j_running_transaction->t_tid);
+			BUG_ON(1);
+		}
 		goto out_unlock_bh;
 	}
 
@@ -1108,9 +1119,30 @@ int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
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
+			       jh->b_transaction->t_tid,
+			       journal->j_committing_transaction,
+			       journal->j_committing_transaction->t_tid);
+			BUG_ON(1);
+		}
+		if (unlikely(jh->b_next_transaction != transaction)) {
+			printk(KERN_EMERG "JBD: %s: "
+			       "jh->b_next_transaction (%llu, %p, %u) != "
+			       "transaction (%p, %u)",
+			       journal->j_devname,
+			       (unsigned long long) bh->b_blocknr,
+			       jh->b_next_transaction,
+			       jh->b_next_transaction->t_tid,
+			       transaction, transaction->t_tid);
+			BUG_ON(1);
+		}
 		/* And this case is illegal: we can't reuse another
 		 * transaction's data buffer, ever. */
 		goto out_unlock_bh;
-- 
1.7.4.1.22.gec8e1.dirty

