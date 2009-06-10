From: akpm@linux-foundation.org
Subject: [merged] jbd-fix-race-in-buffer-processing-in-commit-code.patch removed from -mm tree
Date: Wed, 10 Jun 2009 10:44:05 -0700
Message-ID: <200906101744.n5AHi56b030864@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: jack@suse.cz, linux-ext4@vger.kernel.org, stable@kernel.org,
	mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     jbd: fix race in buffer processing in commit code
has been removed from the -mm tree.  Its filename was
     jbd-fix-race-in-buffer-processing-in-commit-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jbd: fix race in buffer processing in commit code
From: Jan Kara <jack@suse.cz>

In commit code, we scan buffers attached to a transaction.  During this
scan, we sometimes have to drop j_list_lock and then we recheck whether
the journal buffer head didn't get freed by journal_try_to_free_buffers().
 But checking for buffer_jbd(bh) isn't enough because a new journal head
could get attached to our buffer head.  So add a check whether the journal
head remained the same and whether it's still at the same transaction and
list.

This is a nasty bug and can cause problems like memory corruption (use after
free) or trigger various assertions in JBD code (observed).

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: <stable@kernel.org>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/commit.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/jbd/commit.c~jbd-fix-race-in-buffer-processing-in-commit-code fs/jbd/commit.c
--- a/fs/jbd/commit.c~jbd-fix-race-in-buffer-processing-in-commit-code
+++ a/fs/jbd/commit.c
@@ -241,7 +241,7 @@ write_out_data:
 			spin_lock(&journal->j_list_lock);
 		}
 		/* Someone already cleaned up the buffer? */
-		if (!buffer_jbd(bh)
+		if (!buffer_jbd(bh) || bh2jh(bh) != jh
 			|| jh->b_transaction != commit_transaction
 			|| jh->b_jlist != BJ_SyncData) {
 			jbd_unlock_bh_state(bh);
@@ -478,7 +478,9 @@ void journal_commit_transaction(journal_
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
_

Patches currently in -mm which might be from jack@suse.cz are

linux-next.patch
jbd2-clean-up-jbd2_journal_try_to_free_buffers.patch
vfs-split-generic_forget_inode-so-that-hugetlbfs-does-not-have-to-copy-it.patch
mm-remove-__invalidate_mapping_pages-variant.patch
writeback-skip-new-or-to-be-freed-inodes.patch
ext2-do-not-update-mtime-of-a-moved-directory.patch
ext3-fix-chain-verification-in-ext3_get_blocks.patch
jbd-clean-up-journal_try_to_free_buffers.patch
ext3-make-sure-inode-is-deleted-from-orphan-list-after-truncate.patch
isofs-let-mode-and-dmode-mount-options-override-rock-ridge-mode-setting.patch
isofs-fix-setting-of-uid-and-gid-to-0.patch
isofs-cleanup-mount-option-processing.patch
reiser4-update-names-of-quota-methods.patch

