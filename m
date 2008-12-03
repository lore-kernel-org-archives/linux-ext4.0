From: <gregkh@suse.de>
Subject: patch ext4-calculate-journal-credits-correctly.patch added to 2.6.27-stable tree
Date: Wed, 03 Dec 2008 10:55:49 -0800
Message-ID: <20081203185912.A2F3648D90@coco.kroah.org>
References: <1226851540-8032-19-git-send-email-tytso@mit.edu>
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
To: tytso@mit.edu, gregkh@suse.de, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:60894 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751459AbYLCS7N (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Dec 2008 13:59:13 -0500
In-Reply-To: <1226851540-8032-19-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

    Subject: ext4: calculate journal credits correctly

to the 2.6.27-stable tree.  Its filename is

    ext4-calculate-journal-credits-correctly.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From tytso@mit.edu  Wed Dec  3 10:44:36 2008
From: "Theodore Ts'o" <tytso@mit.edu>
Date: Sun, 16 Nov 2008 11:05:38 -0500
Subject: ext4: calculate journal credits correctly
To: stable@kernel.org
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>
Message-ID: <1226851540-8032-19-git-send-email-tytso@mit.edu>

From: "Theodore Ts'o" <tytso@mit.edu>

(cherry picked from commit ac51d83705c2a38c71f39cde99708b14e6212a60)

This fixes a 2.6.27 regression which was introduced in commit a02908f1.

We weren't passing the chunk parameter down to the two subections,
ext4_indirect_trans_blocks() and ext4_ext_index_trans_blocks(), with
the result that massively overestimate the amount of credits needed by
ext4_da_writepages, especially in the non-extents case.  This causes
failures especially on /boot partitions, which tend to be small and
non-extent using since GRUB doesn't handle extents.

This patch fixes the bug reported by Joseph Fannin at:
http://bugzilla.kernel.org/show_bug.cgi?id=11964

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/inode.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4444,9 +4444,10 @@ static int ext4_indirect_trans_blocks(st
 static int ext4_index_trans_blocks(struct inode *inode, int nrblocks, int chunk)
 {
 	if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
-		return ext4_indirect_trans_blocks(inode, nrblocks, 0);
-	return ext4_ext_index_trans_blocks(inode, nrblocks, 0);
+		return ext4_indirect_trans_blocks(inode, nrblocks, chunk);
+	return ext4_ext_index_trans_blocks(inode, nrblocks, chunk);
 }
+
 /*
  * Account for index blocks, block groups bitmaps and block group
  * descriptor blocks if modify datablocks and index blocks


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
