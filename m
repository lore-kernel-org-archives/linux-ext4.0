From: <gregkh@suse.de>
Subject: patch jbd2-don-t-give-up-looking-for-space-so-easily-in-__jbd2_log_wait_for_space.patch added to 2.6.27-stable tree
Date: Wed, 03 Dec 2008 10:56:05 -0800
Message-ID: <20081203185933.BCB1249050@coco.kroah.org>
References: <1226851540-8032-16-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
To: tytso@mit.edu, duaneg@dghda.com, gregkh@suse.de,
	linux-ext4@vger.kernel.org, toshi.okajima@jp.fujitsu.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:60970 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752376AbYLCS7f (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Dec 2008 13:59:35 -0500
In-Reply-To: <1226851540-8032-16-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


This is a note to let you know that we have just queued up the patch ti=
tled

    Subject: jbd2: don't give up looking for space so easily in __jbd2_=
log_wait_for_space

to the 2.6.27-stable tree.  Its filename is

    jbd2-don-t-give-up-looking-for-space-so-easily-in-__jbd2_log_wait_f=
or_space.patch

A git repo of this tree can be found at=20
    http://www.kernel.org/git/?p=3Dlinux/kernel/git/stable/stable-queue=
=2Egit;a=3Dsummary


=46rom tytso@mit.edu  Wed Dec  3 10:43:25 2008
=46rom: "Theodore Ts'o" <tytso@mit.edu>
Date: Sun, 16 Nov 2008 11:05:35 -0500
Subject: jbd2: don't give up looking for space so easily in __jbd2_log_=
wait_for_space
To: stable@kernel.org
Cc: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>, Ext4 Developers L=
ist <linux-ext4@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>, Duan=
e Griffin <duaneg@dghda.com>
Message-ID: <1226851540-8032-16-git-send-email-tytso@mit.edu>

=46rom: "Theodore Ts'o" <tytso@mit.edu>

(cherry picked from commit 8c3f25d8950c3e9fe6c9849f88679b3f2a071550)

Commit 23f8b79e introducd a regression because it assumed that if
there were no transactions ready to be checkpointed, that no progress
could be made on making space available in the journal, and so the
journal should be aborted.  This assumption is false; it could be the
case that simply calling jbd2_cleanup_journal_tail() will recover the
necessary space, or, for small journals, the currently committing
transaction could be responsible for chewing up the required space in
the log, so we need to wait for the currently committing transaction
to finish before trying to force a checkpoint operation.

This patch fixes a bug reported by Mihai Harpau at:
https://bugzilla.redhat.com/show_bug.cgi?id=3D469582

This patch fixes a bug reported by Fran=C3=A7ois Valenduc at:
http://bugzilla.kernel.org/show_bug.cgi?id=3D11840

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Duane Griffin <duaneg@dghda.com>
Cc: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/jbd2/checkpoint.c |   32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -114,7 +114,7 @@ static int __try_to_free_cp_buf(struct j
  */
 void __jbd2_log_wait_for_space(journal_t *journal)
 {
-	int nblocks;
+	int nblocks, space_left;
 	assert_spin_locked(&journal->j_state_lock);
=20
 	nblocks =3D jbd_space_needed(journal);
@@ -127,25 +127,43 @@ void __jbd2_log_wait_for_space(journal_t
 		/*
 		 * Test again, another process may have checkpointed while we
 		 * were waiting for the checkpoint lock. If there are no
-		 * outstanding transactions there is nothing to checkpoint and
-		 * we can't make progress. Abort the journal in this case.
+		 * transactions ready to be checkpointed, try to recover
+		 * journal space by calling cleanup_journal_tail(), and if
+		 * that doesn't work, by waiting for the currently committing
+		 * transaction to complete.  If there is absolutely no way
+		 * to make progress, this is either a BUG or corrupted
+		 * filesystem, so abort the journal and leave a stack
+		 * trace for forensic evidence.
 		 */
 		spin_lock(&journal->j_state_lock);
 		spin_lock(&journal->j_list_lock);
 		nblocks =3D jbd_space_needed(journal);
-		if (__jbd2_log_space_left(journal) < nblocks) {
+		space_left =3D __jbd2_log_space_left(journal);
+		if (space_left < nblocks) {
 			int chkpt =3D journal->j_checkpoint_transactions !=3D NULL;
+			tid_t tid =3D 0;
=20
+			if (journal->j_committing_transaction)
+				tid =3D journal->j_committing_transaction->t_tid;
 			spin_unlock(&journal->j_list_lock);
 			spin_unlock(&journal->j_state_lock);
 			if (chkpt) {
 				jbd2_log_do_checkpoint(journal);
+			} else if (jbd2_cleanup_journal_tail(journal) =3D=3D 0) {
+				/* We were able to recover space; yay! */
+				;
+			} else if (tid) {
+				jbd2_log_wait_commit(journal, tid);
 			} else {
-				printk(KERN_ERR "%s: no transactions\n",
-				       __func__);
+				printk(KERN_ERR "%s: needed %d blocks and "
+				       "only had %d space available\n",
+				       __func__, nblocks, space_left);
+				printk(KERN_ERR "%s: no way to get more "
+				       "journal space in %s\n", __func__,
+				       journal->j_devname);
+				WARN_ON(1);
 				jbd2_journal_abort(journal, 0);
 			}
-
 			spin_lock(&journal->j_state_lock);
 		} else {
 			spin_unlock(&journal->j_list_lock);


Patches currently in stable-queue which might be from tytso@mit.edu are

queue-2.6.27/ext4-update-flex_bg-free-blocks-and-free-inodes-counters-w=
hen-resizing.patch
queue-2.6.27/ext4-fix-11321-create-proc-ext4-stats-more-carefully.patch
queue-2.6.27/jbd2-fix-proc-setup-for-devices-that-contain-in-their-name=
s.patch
queue-2.6.27/ext4-add-missing-unlock-in-ext4_check_descriptors-on-error=
-path.patch
queue-2.6.27/ext4-elevate-write-count-for-migrate-ioctl.patch
queue-2.6.27/ext4-renumber-ext4_ioc_migrate.patch
queue-2.6.27/ext4-jbd2-avoid-warn-messages-when-failing-to-write-to-the=
-superblock.patch
queue-2.6.27/ext4-fix-initialization-of-uninit-bitmap-blocks.patch
queue-2.6.27/jbd2-abort-instead-of-waiting-for-nonexistent-transaction.=
patch
queue-2.6.27/jbd2-fix-buffer-head-leak-when-writing-the-commit-block.pa=
tch
queue-2.6.27/ext4-fix-xattr-deadlock.patch
queue-2.6.27/ext4-free-ext4_prealloc_space-using-kmem_cache_free.patch
queue-2.6.27/ext4-do-mballoc-init-before-doing-filesystem-recovery.patc=
h
queue-2.6.27/ext4-fix-duplicate-entries-returned-from-getdents-system-c=
all.patch
queue-2.6.27/jbd2-don-t-give-up-looking-for-space-so-easily-in-__jbd2_l=
og_wait_for_space.patch
queue-2.6.27/ext4-convert-to-host-order-before-using-the-values.patch
queue-2.6.27/ext4-wait-on-all-pending-commits-in-ext4_sync_fs.patch
queue-2.6.27/ext4-calculate-journal-credits-correctly.patch
queue-2.6.27/ext4-mark-the-buffer_heads-as-dirty-and-uptodate-after-pre=
pare_write.patch
queue-2.6.27/ext4-add-checksum-calculation-when-clearing-uninit-flag-in=
-ext4_new_inode.patch
queue-2.6.27/ext3-fix-ext3_dx_readdir-hash-collision-handling.patch
queue-2.6.27/ext3-fix-duplicate-entries-returned-from-getdents-system-c=
all.patch
queue-2.6.27/ext2-fix-ext2-block-reservation-early-enospc-issue.patch
queue-2.6.27/ext3-fix-ext3-block-reservation-early-enospc-issue.patch
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
