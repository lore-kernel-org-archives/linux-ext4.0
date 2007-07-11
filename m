From: akpm@linux-foundation.org
Subject: + jbd-commit-fix-transaction-dropping.patch added to -mm tree
Date: Wed, 11 Jul 2007 11:32:26 -0700
Message-ID: <200707111832.l6BIWQvx007644@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: jack@suse.cz, cebbert@redhat.com, dev@openvz.org,
	linux-ext4@vger.kernel.org, stable@kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     jbd commit: fix transaction dropping
has been added to the -mm tree.  Its filename is
     jbd-commit-fix-transaction-dropping.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 2 insertions(+), 1 deletion(-)

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

jbd-commit-fix-transaction-dropping.patch
jbd2-commit-fix-transaction-dropping.patch
ext2-fix-a-comment-when-ext2_release_file-is-called.patch
ext3-fix-deadlock-in-ext3_remount-and-orphan-list-handling.patch
ext4-fix-deadlock-in-ext4_remount-and-orphan-list-handling.patch
