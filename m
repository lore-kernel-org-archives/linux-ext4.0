From: Jan Kara <jack@suse.cz>
Subject: [PATCH 4/6] jbd2: Remove always true condition in __journal_try_to_free_buffer()
Date: Wed, 11 Jan 2012 01:31:10 +0100
Message-ID: <1326241872-20142-5-git-send-email-jack@suse.cz>
References: <1326241872-20142-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56928 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757157Ab2AKAb2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jan 2012 19:31:28 -0500
In-Reply-To: <1326241872-20142-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The check b_jlist == BJ_None in __journal_try_to_free_buffer() is
always true (__jbd2_journal_temp_unlink_buffer() also checks this in
an assertion) so just remove it.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/transaction.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index acd08be..52154c9 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1645,10 +1645,8 @@ __journal_try_to_free_buffer(journal_t *journal, struct buffer_head *bh)
 	spin_lock(&journal->j_list_lock);
 	if (jh->b_cp_transaction != NULL && jh->b_transaction == NULL) {
 		/* written-back checkpointed metadata buffer */
-		if (jh->b_jlist == BJ_None) {
-			JBUFFER_TRACE(jh, "remove from checkpoint list");
-			__jbd2_journal_remove_checkpoint(jh);
-		}
+		JBUFFER_TRACE(jh, "remove from checkpoint list");
+		__jbd2_journal_remove_checkpoint(jh);
 	}
 	spin_unlock(&journal->j_list_lock);
 out:
-- 
1.7.1

