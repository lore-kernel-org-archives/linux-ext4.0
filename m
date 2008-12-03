From: <gregkh@suse.de>
Subject: patch ext4-fix-duplicate-entries-returned-from-getdents-system-call.patch added to 2.6.27-stable tree
Date: Wed, 03 Dec 2008 10:55:54 -0800
Message-ID: <20081203185920.7336849046@coco.kroah.org>
References: <1226851540-8032-15-git-send-email-tytso@mit.edu>
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
To: tytso@mit.edu, gregkh@suse.de, linux-ext4@vger.kernel.org,
	markus@trippelsdorf.de
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:60918 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751886AbYLCS7V (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Dec 2008 13:59:21 -0500
In-Reply-To: <1226851540-8032-15-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

    Subject: ext4: Fix duplicate entries returned from getdents() system call

to the 2.6.27-stable tree.  Its filename is

    ext4-fix-duplicate-entries-returned-from-getdents-system-call.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From tytso@mit.edu  Wed Dec  3 10:43:07 2008
From: "Theodore Ts'o" <tytso@mit.edu>
Date: Sun, 16 Nov 2008 11:05:34 -0500
Subject: ext4: Fix duplicate entries returned from getdents() system call
To: stable@kernel.org
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>
Message-ID: <1226851540-8032-15-git-send-email-tytso@mit.edu>

From: "Theodore Ts'o" <tytso@mit.edu>

(cherry picked from commit 3c37fc86d20fe35be656f070997d62f75c2e4874)

Fix a regression caused by commit d0156417, "ext4: fix ext4_dx_readdir
hash collision handling", where deleting files in a large directory
(requiring more than one getdents system call), results in some
filenames being returned twice.  This was caused by a failure to
update info->curr_hash and info->curr_minor_hash, so that if the
directory had gotten modified since the last getdents() system call
(as would be the case if the user is running "rm -r" or "git clean"),
a directory entry would get returned twice to the userspace.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

This patch fixes the bug reported by Markus Trippelsdorf at:
http://bugzilla.kernel.org/show_bug.cgi?id=11844

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Tested-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/dir.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -458,17 +458,8 @@ static int ext4_dx_readdir(struct file *
 	if (info->extra_fname) {
 		if (call_filldir(filp, dirent, filldir, info->extra_fname))
 			goto finished;
-
 		info->extra_fname = NULL;
-		info->curr_node = rb_next(info->curr_node);
-		if (!info->curr_node) {
-			if (info->next_hash == ~0) {
-				filp->f_pos = EXT4_HTREE_EOF;
-				goto finished;
-			}
-			info->curr_hash = info->next_hash;
-			info->curr_minor_hash = 0;
-		}
+		goto next_node;
 	} else if (!info->curr_node)
 		info->curr_node = rb_first(&info->root);
 
@@ -500,9 +491,14 @@ static int ext4_dx_readdir(struct file *
 		info->curr_minor_hash = fname->minor_hash;
 		if (call_filldir(filp, dirent, filldir, fname))
 			break;
-
+	next_node:
 		info->curr_node = rb_next(info->curr_node);
-		if (!info->curr_node) {
+		if (info->curr_node) {
+			fname = rb_entry(info->curr_node, struct fname,
+					 rb_hash);
+			info->curr_hash = fname->hash;
+			info->curr_minor_hash = fname->minor_hash;
+		} else {
 			if (info->next_hash == ~0) {
 				filp->f_pos = EXT4_HTREE_EOF;
 				break;


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
