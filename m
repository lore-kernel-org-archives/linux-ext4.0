From: akpm@linux-foundation.org
Subject: - jbd2-commit-fix-transaction-dropping.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:48:07 -0700
Message-ID: <200707162048.l6GKm71o001012@imap1.linux-foundation.org>
To: jack@suse.cz, cebbert@redhat.com, dev@openvz.org,
	linux-ext4@vger.kernel.org, stable@kernel.org,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57996 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753281AbXGPUs3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Jul 2007 16:48:29 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     jbd2 commit: fix transaction dropping
has been removed from the -mm tree.  Its filename was
     jbd2-commit-fix-transaction-dropping.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: jbd2 commit: fix transaction dropping
From: Jan Kara <jack@suse.cz>

We have to check that also the second checkpoint list is non-empty before
dropping the transaction.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Chuck Ebbert <cebbert@redhat.com>
Cc: Kirill Korotaev <dev@openvz.org>
Cc: <linux-ext4@vger.kernel.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd2/commit.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/jbd2/commit.c~jbd2-commit-fix-transaction-dropping fs/jbd2/commit.c
--- a/fs/jbd2/commit.c~jbd2-commit-fix-transaction-dropping
+++ a/fs/jbd2/commit.c
@@ -896,7 +896,8 @@ restart_loop:
 	journal->j_committing_transaction = NULL;
 	spin_unlock(&journal->j_state_lock);
 
-	if (commit_transaction->t_checkpoint_list == NULL) {
+	if (commit_transaction->t_checkpoint_list == NULL &&
+	    commit_transaction->t_checkpoint_io_list == NULL) {
 		__jbd2_journal_drop_transaction(journal, commit_transaction);
 	} else {
 		if (journal->j_checkpoint_transactions == NULL) {
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
