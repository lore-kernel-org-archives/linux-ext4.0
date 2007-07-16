From: akpm@linux-foundation.org
Subject: - jbd-commit-fix-transaction-dropping.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:48:04 -0700
Message-ID: <200707162048.l6GKm47P001009@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: jack@suse.cz, cebbert@redhat.com, dev@openvz.org,
	linux-ext4@vger.kernel.org, stable@kernel.org,
	mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     jbd commit: fix transaction dropping
has been removed from the -mm tree.  Its filename was
     jbd-commit-fix-transaction-dropping.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: jbd commit: fix transaction dropping
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

 fs/jbd/commit.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/jbd/commit.c~jbd-commit-fix-transaction-dropping fs/jbd/commit.c
--- a/fs/jbd/commit.c~jbd-commit-fix-transaction-dropping
+++ a/fs/jbd/commit.c
@@ -887,7 +887,8 @@ restart_loop:
 	journal->j_committing_transaction = NULL;
 	spin_unlock(&journal->j_state_lock);
 
-	if (commit_transaction->t_checkpoint_list == NULL) {
+	if (commit_transaction->t_checkpoint_list == NULL &&
+	    commit_transaction->t_checkpoint_io_list == NULL) {
 		__journal_drop_transaction(journal, commit_transaction);
 	} else {
 		if (journal->j_checkpoint_transactions == NULL) {
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
