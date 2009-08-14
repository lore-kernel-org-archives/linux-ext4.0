From: Jan Kara <jack@suse.cz>
Subject: [PATCH 3/4] jbd2: Annotate transaction start also for jbd2_journal_restart()
Date: Fri, 14 Aug 2009 14:26:11 +0200
Message-ID: <1250252772-13302-4-git-send-email-jack@suse.cz>
References: <1250252772-13302-1-git-send-email-jack@suse.cz>
Cc: tytso@mit.edu, Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:49026 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756662AbZHNM0O (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 Aug 2009 08:26:14 -0400
In-Reply-To: <1250252772-13302-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

lockdep annotation for a transaction start has been at the end of
jbd2_journal_start(). But a transaction is also started from
jbd2_journal_restart(). Move the lockdep annotation to start_this_handle()
which covers both cases.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/transaction.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 6213ac7..8b6a692 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -238,6 +238,8 @@ repeat_locked:
 		  __jbd2_log_space_left(journal));
 	spin_unlock(&transaction->t_handle_lock);
 	spin_unlock(&journal->j_state_lock);
+
+	lock_map_acquire(&handle->h_lockdep_map);
 out:
 	if (unlikely(new_transaction))		/* It's usually NULL */
 		kfree(new_transaction);
@@ -303,8 +305,6 @@ handle_t *jbd2_journal_start(journal_t *journal, int nblocks)
 		handle = ERR_PTR(err);
 		goto out;
 	}
