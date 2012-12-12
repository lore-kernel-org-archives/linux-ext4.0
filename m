From: Jan Kara <jack@suse.cz>
Subject: [PATCH] jbd2: Fix assertion failure in jbd2_journal_flush()
Date: Wed, 12 Dec 2012 16:17:42 +0100
Message-ID: <1355325462-26757-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	stable@vger.kernel.org
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41049 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593Ab2LLPRy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Dec 2012 10:17:54 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following race is possible between start_this_handle() and someone
calling jbd2_journal_flush().

Process A                              Process B
start_this_handle().
  if (journal->j_barrier_count) # false
  if (!journal->j_running_transaction) { #true
    read_unlock(&journal->j_state_lock);
                                       jbd2_journal_lock_updates()
                                       jbd2_journal_flush()
                                         write_lock(&journal->j_state_lock);
                                         if (journal->j_running_transaction) {
                                           # false
                                         ... wait for committing trans ...
                                         write_unlock(&journal->j_state_lock);
    ...
    write_lock(&journal->j_state_lock);
    if (!journal->j_running_transaction) { # true
      jbd2_get_transaction(journal, new_transaction);
    write_unlock(&journal->j_state_lock);
    goto repeat; # eventually blocks on j_barrier_count > 0
                                         ...
                                         J_ASSERT(!journal->j_running_transaction);
                                           # fails

We fix the race by rechecking j_barrier_count after reacquiring j_state_lock
in exclusive mode.

CC: stable@vger.kernel.org
Reported-by:yjwsignal@empal.com
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/transaction.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index a74ba46..6873d24 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -209,7 +209,8 @@ repeat:
 		if (!new_transaction)
 			goto alloc_transaction;
 		write_lock(&journal->j_state_lock);
-		if (!journal->j_running_transaction) {
+		if (!journal->j_running_transaction &&
+		    !journal->j_barrier_count) {
 			jbd2_get_transaction(journal, new_transaction);
 			new_transaction = NULL;
 		}
-- 
1.7.1

