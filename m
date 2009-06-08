From: Jan Kara <jack@suse.cz>
Subject: [PATCH] jbd: Fix race in buffer processing in commit code
Date: Mon,  8 Jun 2009 19:21:46 +0200
Message-ID: <1244481706-26804-1-git-send-email-jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
	Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:35297 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754893AbZFHRVp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Jun 2009 13:21:45 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In commit code, we scan buffers attached to a transaction. During this
scan, we sometimes have to drop j_list_lock and then we recheck whether
the journal buffer head didn't get freed by journal_try_to_free_buffers().
But checking for buffer_jbd(bh) isn't enough because a new journal head
could get attached to our buffer head. So add a check whether the journal
head remained the same and whether it's still at the same transaction and
list.

This is a nasty bug and can cause problems like memory corruption (use after
free) or trigger various assertions in JBD code (observed).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd/commit.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

 Andrew, would you please merge it? Thanks. BTW, JBD2 does not have the problem
since we handle ordered mode data buffers differently there.

diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index 06560c5..618e21c 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -241,7 +241,7 @@ write_out_data:
 			spin_lock(&journal->j_list_lock);
 		}
 		/* Someone already cleaned up the buffer? */
-		if (!buffer_jbd(bh)
+		if (!buffer_jbd(bh) || bh2jh(bh) != jh
 			|| jh->b_transaction != commit_transaction
 			|| jh->b_jlist != BJ_SyncData) {
 			jbd_unlock_bh_state(bh);
@@ -478,7 +478,9 @@ void journal_commit_transaction(journal_t *journal)
 			spin_lock(&journal->j_list_lock);
 			continue;
 		}
-		if (buffer_jbd(bh) && jh->b_jlist == BJ_Locked) {
+		if (buffer_jbd(bh) && bh2jh(bh) == jh &&
+		    jh->b_transaction == commit_transaction &&
+		    jh->b_jlist == BJ_Locked) {
 			__journal_unfile_buffer(jh);
 			jbd_unlock_bh_state(bh);
 			journal_remove_journal_head(bh);
-- 
1.6.0.2

