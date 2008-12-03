From: <gregkh@suse.de>
Subject: patch jbd2-fix-buffer-head-leak-when-writing-the-commit-block.patch added to 2.6.27-stable tree
Date: Wed, 03 Dec 2008 10:56:06 -0800
Message-ID: <20081203185935.5C38949051@coco.kroah.org>
References: <1226851540-8032-11-git-send-email-tytso@mit.edu>
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
To: tytso@mit.edu, gregkh@suse.de, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:60974 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751975AbYLCS7g (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Dec 2008 13:59:36 -0500
In-Reply-To: <1226851540-8032-11-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

    Subject: jbd2: Fix buffer head leak when writing the commit block

to the 2.6.27-stable tree.  Its filename is

    jbd2-fix-buffer-head-leak-when-writing-the-commit-block.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From tytso@mit.edu  Wed Dec  3 10:04:23 2008
From: "Theodore Ts'o" <tytso@mit.edu>
Date: Sun, 16 Nov 2008 11:05:30 -0500
Subject: jbd2: Fix buffer head leak when writing the commit block
To: stable@kernel.org
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>
Message-ID: <1226851540-8032-11-git-send-email-tytso@mit.edu>

From: "Theodore Ts'o" <tytso@mit.edu>

(cherry picked from commit 45a90bfd90c1215bf824c0f705b409723f52361b)

Also make sure the buffer heads are marked clean before submitting bh
for writing.  The previous code was marking the buffer head dirty,
which would have forced an unneeded write (and seek) to the journal
for no good reason.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/jbd2/commit.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -126,8 +126,7 @@ static int journal_submit_commit_record(
 
 	JBUFFER_TRACE(descriptor, "submit commit block");
 	lock_buffer(bh);
-	get_bh(bh);
-	set_buffer_dirty(bh);
+	clear_buffer_dirty(bh);
 	set_buffer_uptodate(bh);
 	bh->b_end_io = journal_end_buffer_io_sync;
 
@@ -160,7 +159,7 @@ static int journal_submit_commit_record(
 		/* And try again, without the barrier */
 		lock_buffer(bh);
 		set_buffer_uptodate(bh);
-		set_buffer_dirty(bh);
+		clear_buffer_dirty(bh);
 		ret = submit_bh(WRITE, bh);
 	}
 	*cbh = bh;


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
