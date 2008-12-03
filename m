From: <gregkh@suse.de>
Subject: patch ext4-jbd2-avoid-warn-messages-when-failing-to-write-to-the-superblock.patch added to 2.6.27-stable tree
Date: Wed, 03 Dec 2008 10:56:00 -0800
Message-ID: <20081203185926.DB9324904B@coco.kroah.org>
References: <1226851540-8032-8-git-send-email-tytso@mit.edu>
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
To: tytso@mit.edu, gregkh@suse.de, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:60940 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752117AbYLCS72 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Dec 2008 13:59:28 -0500
In-Reply-To: <1226851540-8032-8-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

    Subject: ext4/jbd2: Avoid WARN() messages when failing to write to the superblock

to the 2.6.27-stable tree.  Its filename is

    ext4-jbd2-avoid-warn-messages-when-failing-to-write-to-the-superblock.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From tytso@mit.edu  Wed Dec  3 10:02:23 2008
From: "Theodore Ts'o" <tytso@mit.edu>
Date: Sun, 16 Nov 2008 11:05:27 -0500
Subject: ext4/jbd2: Avoid WARN() messages when failing to write to the superblock
To: stable@kernel.org
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>
Message-ID: <1226851540-8032-8-git-send-email-tytso@mit.edu>

From: "Theodore Ts'o" <tytso@mit.edu>

(cherry picked from commit 914258bf2cb22bf4336a1b1d90c551b4b11ca5aa)

This fixes some very common warnings reported by kerneloops.org

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/super.c   |   23 ++++++++++++++++++++++-
 fs/jbd2/journal.c |   27 +++++++++++++++++++++++++--
 2 files changed, 47 insertions(+), 3 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2804,13 +2804,34 @@ static void ext4_commit_super(struct sup
 
 	if (!sbh)
 		return;
+	if (buffer_write_io_error(sbh)) {
+		/*
+		 * Oh, dear.  A previous attempt to write the
+		 * superblock failed.  This could happen because the
+		 * USB device was yanked out.  Or it could happen to
+		 * be a transient write error and maybe the block will
+		 * be remapped.  Nothing we can do but to retry the
+		 * write and hope for the best.
+		 */
+		printk(KERN_ERR "ext4: previous I/O error to "
+		       "superblock detected for %s.\n", sb->s_id);
+		clear_buffer_write_io_error(sbh);
+		set_buffer_uptodate(sbh);
+	}
 	es->s_wtime = cpu_to_le32(get_seconds());
 	ext4_free_blocks_count_set(es, ext4_count_free_blocks(sb));
 	es->s_free_inodes_count = cpu_to_le32(ext4_count_free_inodes(sb));
 	BUFFER_TRACE(sbh, "marking dirty");
 	mark_buffer_dirty(sbh);
-	if (sync)
+	if (sync) {
 		sync_dirty_buffer(sbh);
+		if (buffer_write_io_error(sbh)) {
+			printk(KERN_ERR "ext4: I/O error while writing "
+			       "superblock for %s.\n", sb->s_id);
+			clear_buffer_write_io_error(sbh);
+			set_buffer_uptodate(sbh);
+		}
+	}
 }
 
 
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1259,6 +1259,22 @@ void jbd2_journal_update_superblock(jour
 		goto out;
 	}
 
+	if (buffer_write_io_error(bh)) {
+		/*
+		 * Oh, dear.  A previous attempt to write the journal
+		 * superblock failed.  This could happen because the
+		 * USB device was yanked out.  Or it could happen to
+		 * be a transient write error and maybe the block will
+		 * be remapped.  Nothing we can do but to retry the
+		 * write and hope for the best.
+		 */
+		printk(KERN_ERR "JBD2: previous I/O error detected "
+		       "for journal superblock update for %s.\n",
+		       journal->j_devname);
+		clear_buffer_write_io_error(bh);
+		set_buffer_uptodate(bh);
+	}
+
 	spin_lock(&journal->j_state_lock);
 	jbd_debug(1,"JBD: updating superblock (start %ld, seq %d, errno %d)\n",
 		  journal->j_tail, journal->j_tail_sequence, journal->j_errno);
@@ -1270,9 +1286,16 @@ void jbd2_journal_update_superblock(jour
 
 	BUFFER_TRACE(bh, "marking dirty");
 	mark_buffer_dirty(bh);
-	if (wait)
+	if (wait) {
 		sync_dirty_buffer(bh);
-	else
+		if (buffer_write_io_error(bh)) {
+			printk(KERN_ERR "JBD2: I/O error detected "
+			       "when updating journal superblock for %s.\n",
+			       journal->j_devname);
+			clear_buffer_write_io_error(bh);
+			set_buffer_uptodate(bh);
+		}
+	} else
 		ll_rw_block(SWRITE, 1, &bh);
 
 out:


Patches currently in stable-queue which might be from tytso@mit.edu are

queue-2.6.27/ext4-update-flex_bg-free-blocks-and-free-inodes-counters-when-resizing.patch
queue-2.6.27/ext4-fix-11321-create-proc-ext4-stats-more-carefully.patch
queue-2.6.27/jbd2-fix-proc-setup-for-devices-that-contain-in-their-names.patch
queue-2.6.27/ext4-add-missing-unlock-in-ext4_check_descriptors-on-error-path.patch
queue-2.6.27/ext4-elevate-write-count-for-migrate-ioctl.patch
queue-2.6.27/ext4-renumber-ext4_ioc_migrate.patch
queue-2.6.27/ext4-jbd2-avoid-warn-messages-when-failing-to-write-to-the-superblock.patch
queue-2.6.27/ext4-fix-initialization-of-uninit-bitmap-blocks.patch
queue-2.6.27/jbd2-abort-instead-of-waiting-for-nonexistent-transaction.patch
queue-2.6.27/jbd2-fix-buffer-head-leak-when-writing-the-commit-block.patch
queue-2.6.27/ext4-fix-xattr-deadlock.patch
queue-2.6.27/ext4-free-ext4_prealloc_space-using-kmem_cache_free.patch
queue-2.6.27/ext4-do-mballoc-init-before-doing-filesystem-recovery.patch
queue-2.6.27/ext4-fix-duplicate-entries-returned-from-getdents-system-call.patch
queue-2.6.27/jbd2-don-t-give-up-looking-for-space-so-easily-in-__jbd2_log_wait_for_space.patch
queue-2.6.27/ext4-convert-to-host-order-before-using-the-values.patch
queue-2.6.27/ext4-wait-on-all-pending-commits-in-ext4_sync_fs.patch
queue-2.6.27/ext4-calculate-journal-credits-correctly.patch
queue-2.6.27/ext4-mark-the-buffer_heads-as-dirty-and-uptodate-after-prepare_write.patch
queue-2.6.27/ext4-add-checksum-calculation-when-clearing-uninit-flag-in-ext4_new_inode.patch
queue-2.6.27/ext3-fix-ext3_dx_readdir-hash-collision-handling.patch
queue-2.6.27/ext3-fix-duplicate-entries-returned-from-getdents-system-call.patch
queue-2.6.27/ext2-fix-ext2-block-reservation-early-enospc-issue.patch
queue-2.6.27/ext3-fix-ext3-block-reservation-early-enospc-issue.patch
