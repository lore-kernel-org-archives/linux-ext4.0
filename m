From: Jan Kara <jack@suse.cz>
Subject: [PATCH 10/29] jbd2: Fix race in t_outstanding_credits update in jbd2_journal_extend()
Date: Mon,  8 Apr 2013 23:32:15 +0200
Message-ID: <1365456754-29373-11-git-send-email-jack@suse.cz>
References: <1365456754-29373-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53346 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936287Ab3DHVdB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Apr 2013 17:33:01 -0400
In-Reply-To: <1365456754-29373-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

jbd2_journal_extend() first checked whether transaction can accept extending
handle with more credits and then added credits to t_outstanding_credits.
This can race with start_this_handle() adding another handle to a transaction
and thus overbooking a transaction. Make jbd2_journal_extend() use
atomic_add_return() to close the race.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/transaction.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index aee40c9..9639e47 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -434,11 +434,13 @@ int jbd2_journal_extend(handle_t *handle, int nblocks)
 	}
 
 	spin_lock(&transaction->t_handle_lock);
-	wanted = atomic_read(&transaction->t_outstanding_credits) + nblocks;
+	wanted = atomic_add_return(nblocks,
+				   &transaction->t_outstanding_credits);
 
 	if (wanted > journal->j_max_transaction_buffers) {
 		jbd_debug(3, "denied handle %p %d blocks: "
 			  "transaction too large\n", handle, nblocks);
+		atomic_sub(nblocks, &transaction->t_outstanding_credits);
 		goto unlock;
 	}
 
@@ -446,6 +448,7 @@ int jbd2_journal_extend(handle_t *handle, int nblocks)
 	    jbd2_log_space_left(journal)) {
 		jbd_debug(3, "denied handle %p %d blocks: "
 			  "insufficient log space\n", handle, nblocks);
+		atomic_sub(nblocks, &transaction->t_outstanding_credits);
 		goto unlock;
 	}
 
@@ -457,7 +460,6 @@ int jbd2_journal_extend(handle_t *handle, int nblocks)
 
 	handle->h_buffer_credits += nblocks;
 	handle->h_requested_credits += nblocks;
-	atomic_add(nblocks, &transaction->t_outstanding_credits);
 	result = 0;
 
 	jbd_debug(3, "extended handle %p by %d\n", handle, nblocks);
-- 
1.7.1

