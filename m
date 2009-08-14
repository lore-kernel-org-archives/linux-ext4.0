From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/4] jbd: Annotate transaction start also for journal_restart()
Date: Fri, 14 Aug 2009 14:26:09 +0200
Message-ID: <1250252772-13302-2-git-send-email-jack@suse.cz>
References: <1250252772-13302-1-git-send-email-jack@suse.cz>
Cc: tytso@mit.edu, Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51438 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756657AbZHNM0N (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 Aug 2009 08:26:13 -0400
In-Reply-To: <1250252772-13302-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

lockdep annotation for a transaction start has been at the end of
journal_start(). But a transaction is also started from journal_restart(). Move
the lockdep annotation to start_this_handle() which covers both cases.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd/transaction.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index 833c167..006f9ad 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -229,6 +229,8 @@ repeat_locked:
 		  __log_space_left(journal));
 	spin_unlock(&transaction->t_handle_lock);
 	spin_unlock(&journal->j_state_lock);
+
+	lock_map_acquire(&handle->h_lockdep_map);
 out:
 	if (unlikely(new_transaction))		/* It's usually NULL */
 		kfree(new_transaction);
@@ -293,9 +295,6 @@ handle_t *journal_start(journal_t *journal, int nblocks)
 		handle = ERR_PTR(err);
 		goto out;
 	}
-
-	lock_map_acquire(&handle->h_lockdep_map);
