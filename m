From: Jan Kara <jack@suse.cz>
Subject: [PATCH] jbd2: Clear dirty bit in jbd2_journal_get_create_access() and __dispose_buffer()
Date: Mon, 13 Jul 2009 21:34:58 +0200
Message-ID: <1247513698-6415-1-git-send-email-jack@suse.cz>
Cc: tytso@mit.edu, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35857 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755386AbZGMTe7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Jul 2009 15:34:59 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In case we reallocate previously freed buffer, it can happen that the buffer we
reallocate is dirty (jbd2_journal_forget() got called while the previous
transaction was still committing). At the time we reallocate the buffer, the
transaction freeing the buffer must be already committed so we can just remove
the dirty bit.
  We also change __dispose_buffer() to first clear the dirty bit and only
after that file the buffer into BJ_Forget list.
  These two changes silence the warning in jbd2_journal_file_buffer() about
metadata buffer being dirty.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/transaction.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

  Ted, this is the new fix I was talking about and should replace the fix
"jbd2: Clear dirty bit in jbd2_journal_get_create_access()". It makes sence to
fold it into the patch "jbd2: Fix a race between checkpointing code and
journal_get_write_access()" which is what I did for JBD but that's upto you.

								Honza

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 86144aa..6213ac7 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -826,6 +826,15 @@ int jbd2_journal_get_create_access(handle_t *handle, struct buffer_head *bh)
 	J_ASSERT_JH(jh, buffer_locked(jh2bh(jh)));
 
 	if (jh->b_transaction == NULL) {
+		/*
+		 * Previous jbd2_journal_forget() could have left the buffer
+		 * with jbddirty bit set because it was being committed. When
+		 * the commit finished, we've filed the buffer for
+		 * checkpointing and marked it dirty. Now we are reallocating
+		 * the buffer so the transaction freeing it must have
+		 * committed and so it's safe to clear the dirty bit.
+		 */
+		clear_buffer_dirty(jh2bh(jh));
 		jh->b_transaction = transaction;
 
 		/* first access by this transaction */
@@ -1627,8 +1636,13 @@ static int __dispose_buffer(struct journal_head *jh, transaction_t *transaction)
 
 	if (jh->b_cp_transaction) {
 		JBUFFER_TRACE(jh, "on running+cp transaction");
+		/*
+		 * We don't want to write the buffer anymore, clear the
+		 * bit so that we don't confuse checks in
+		 * __journal_file_buffer
+		 */
+		clear_buffer_dirty(bh);
 		__jbd2_journal_file_buffer(jh, transaction, BJ_Forget);
-		clear_buffer_jbddirty(bh);
 		may_free = 0;
 	} else {
 		JBUFFER_TRACE(jh, "on running transaction");
-- 
1.6.0.2

