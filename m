From: Jan Kara <jack@suse.cz>
Subject: [PATCH 3/5] jbd2: Simplify code flow in do_get_write_access()
Date: Thu,  2 Apr 2015 15:58:18 +0200
Message-ID: <1427983100-29889-4-git-send-email-jack@suse.cz>
References: <1427983100-29889-1-git-send-email-jack@suse.cz>
Cc: Ted Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51224 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbbDBN61 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Apr 2015 09:58:27 -0400
In-Reply-To: <1427983100-29889-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Check for the simple case of unjournaled buffer first, handle it and
bail out. This allows us to remove one if and unindent the difficult case
by one tab. The result is easier to read.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/transaction.c | 130 +++++++++++++++++++++++---------------------------
 1 file changed, 59 insertions(+), 71 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 1995ea539e96..5207825d1038 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -893,6 +893,20 @@ repeat:
        jh->b_modified = 0;
 
 	/*
+	 * If the buffer is not journaled right now, we need to make sure it
+	 * doesn't get written to disk before the caller actually commits the
+	 * new data
+	 */
+	if (!jh->b_transaction) {
+		JBUFFER_TRACE(jh, "no transaction");
+		J_ASSERT_JH(jh, !jh->b_next_transaction);
+		JBUFFER_TRACE(jh, "file as BJ_Reserved");
+		spin_lock(&journal->j_list_lock);
+		__jbd2_journal_file_buffer(jh, transaction, BJ_Reserved);
+		spin_unlock(&journal->j_list_lock);
+		goto done;
+	}
+	/*
 	 * If there is already a copy-out version of this buffer, then we don't
 	 * need to make another one
 	 */
@@ -903,84 +917,58 @@ repeat:
 		goto done;
 	}
 
-	/* Is there data here we need to preserve? */
+	JBUFFER_TRACE(jh, "owned by older transaction");
+	J_ASSERT_JH(jh, jh->b_next_transaction == NULL);
+	J_ASSERT_JH(jh, jh->b_transaction == journal->j_committing_transaction);
 
-	if (jh->b_transaction && jh->b_transaction != transaction) {
-		JBUFFER_TRACE(jh, "owned by older transaction");
-		J_ASSERT_JH(jh, jh->b_next_transaction == NULL);
-		J_ASSERT_JH(jh, jh->b_transaction ==
-					journal->j_committing_transaction);
+	/*
+	 * There is one case we have to be very careful about.  If the
+	 * committing transaction is currently writing this buffer out to disk
+	 * and has NOT made a copy-out, then we cannot modify the buffer
+	 * contents at all right now.  The essence of copy-out is that it is
+	 * the extra copy, not the primary copy, which gets journaled.  If the
+	 * primary copy is already going to disk then we cannot do copy-out
+	 * here.
+	 */
+	if (buffer_shadow(bh)) {
+		JBUFFER_TRACE(jh, "on shadow: sleep");
+		jbd_unlock_bh_state(bh);
+		wait_on_bit_io(&bh->b_state, BH_Shadow, TASK_UNINTERRUPTIBLE);
+		goto repeat;
+	}
 
-		/* There is one case we have to be very careful about.
-		 * If the committing transaction is currently writing
-		 * this buffer out to disk and has NOT made a copy-out,
-		 * then we cannot modify the buffer contents at all
-		 * right now.  The essence of copy-out is that it is the
-		 * extra copy, not the primary copy, which gets
-		 * journaled.  If the primary copy is already going to
-		 * disk then we cannot do copy-out here. */
-
-		if (buffer_shadow(bh)) {
-			JBUFFER_TRACE(jh, "on shadow: sleep");
+	/*
+	 * Only do the copy if the currently-owning transaction still needs it.
+	 * If buffer isn't on BJ_Metadata list, the committing transaction is
+	 * past that stage (here we use the fact that BH_Shadow is set under
+	 * bh_state lock together with refiling to BJ_Shadow list and at this
+	 * point we know the buffer doesn't have BH_Shadow set).
+	 *
+	 * Subtle point, though: if this is a get_undo_access, then we will be
+	 * relying on the frozen_data to contain the new value of the
+	 * committed_data record after the transaction, so we HAVE to force the
+	 * frozen_data copy in that case.
+	 */
+	if (jh->b_jlist == BJ_Metadata || force_copy) {
+		JBUFFER_TRACE(jh, "generate frozen data");
+		if (!frozen_buffer) {
+			JBUFFER_TRACE(jh, "allocate memory for buffer");
 			jbd_unlock_bh_state(bh);
-			wait_on_bit_io(&bh->b_state, BH_Shadow,
-				       TASK_UNINTERRUPTIBLE);
-			goto repeat;
-		}
-
-		/*
-		 * Only do the copy if the currently-owning transaction still
-		 * needs it. If buffer isn't on BJ_Metadata list, the
-		 * committing transaction is past that stage (here we use the
-		 * fact that BH_Shadow is set under bh_state lock together with
-		 * refiling to BJ_Shadow list and at this point we know the
-		 * buffer doesn't have BH_Shadow set).
-		 *
-		 * Subtle point, though: if this is a get_undo_access,
-		 * then we will be relying on the frozen_data to contain
-		 * the new value of the committed_data record after the
-		 * transaction, so we HAVE to force the frozen_data copy
-		 * in that case.
-		 */
-		if (jh->b_jlist == BJ_Metadata || force_copy) {
-			JBUFFER_TRACE(jh, "generate frozen data");
+			frozen_buffer = jbd2_alloc(jh2bh(jh)->b_size, GFP_NOFS);
 			if (!frozen_buffer) {
-				JBUFFER_TRACE(jh, "allocate memory for buffer");
-				jbd_unlock_bh_state(bh);
-				frozen_buffer =
-					jbd2_alloc(jh2bh(jh)->b_size,
-							 GFP_NOFS);
-				if (!frozen_buffer) {
-					printk(KERN_ERR
-					       "%s: OOM for frozen_buffer\n",
-					       __func__);
-					JBUFFER_TRACE(jh, "oom!");
-					error = -ENOMEM;
-					goto out;
-				}
-				goto repeat;
+				printk(KERN_ERR "%s: OOM for frozen_buffer\n",
+				       __func__);
+				JBUFFER_TRACE(jh, "oom!");
+				error = -ENOMEM;
+				goto out;
 			}
-			jh->b_frozen_data = frozen_buffer;
-			frozen_buffer = NULL;
-			jbd2_freeze_jh_data(jh);
+			goto repeat;
 		}
-		jh->b_next_transaction = transaction;
-	}
-
