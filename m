From: <gregkh@suse.de>
Subject: patch ext4-wait-on-all-pending-commits-in-ext4_sync_fs.patch added to 2.6.27-stable tree
Date: Wed, 03 Dec 2008 10:56:03 -0800
Message-ID: <20081203185931.053244904E@coco.kroah.org>
References: <1226851540-8032-18-git-send-email-tytso@mit.edu>
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
To: tytso@mit.edu, ajones@riverbed.com, akpm@linux-foundation.org,
	gregkh@suse.de, linux-ext4@vger.kernel.org, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:60953 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752123AbYLCS7c (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Dec 2008 13:59:32 -0500
In-Reply-To: <1226851540-8032-18-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

    Subject: ext4: wait on all pending commits in ext4_sync_fs()

to the 2.6.27-stable tree.  Its filename is

    ext4-wait-on-all-pending-commits-in-ext4_sync_fs.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From tytso@mit.edu  Wed Dec  3 10:44:07 2008
From: "Theodore Ts'o" <tytso@mit.edu>
Date: Sun, 16 Nov 2008 11:05:37 -0500
Subject: ext4: wait on all pending commits in ext4_sync_fs()
To: stable@kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>, Arthur Jones <ajones@riverbed.com>
Message-ID: <1226851540-8032-18-git-send-email-tytso@mit.edu>

From: "Theodore Ts'o" <tytso@mit.edu>

(cherry picked from commit 14ce0cb411c88681ab8f3a4c9caa7f42e97a3184)

In ext4_sync_fs, we only wait for a commit to finish if we started it,
but there may be one already in progress which will not be synced.

In the case of a data=ordered umount with pending long symlinks which
are delayed due to a long list of other I/O on the backing block
device, this causes the buffer associated with the long symlinks to
not be moved to the inode dirty list in the second phase of
fsync_super.  Then, before they can be dirtied again, kjournald exits,
seeing the UMOUNT flag and the dirty pages are never written to the
backing block device, causing long symlink corruption and exposing new
or previously freed block data to userspace.

To ensure all commits are synced, we flush all journal commits now
when sync_fs'ing ext4.

Signed-off-by: Arthur Jones <ajones@riverbed.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/super.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2920,12 +2920,9 @@ int ext4_force_commit(struct super_block
 /*
  * Ext4 always journals updates to the superblock itself, so we don't
  * have to propagate any other updates to the superblock on disk at this
- * point.  Just start an async writeback to get the buffers on their way
- * to the disk.
- *
- * This implicitly triggers the writebehind on sync().
+ * point.  (We can probably nuke this function altogether, and remove
+ * any mention to sb->s_dirt in all of fs/ext4; eventual cleanup...)
  */
-
 static void ext4_write_super(struct super_block *sb)
 {
 	if (mutex_trylock(&sb->s_lock) != 0)
@@ -2935,14 +2932,14 @@ static void ext4_write_super(struct supe
 
 static int ext4_sync_fs(struct super_block *sb, int wait)
 {
-	tid_t target;
+	int ret = 0;
 
 	sb->s_dirt = 0;
-	if (jbd2_journal_start_commit(EXT4_SB(sb)->s_journal, &target)) {
-		if (wait)
-			jbd2_log_wait_commit(EXT4_SB(sb)->s_journal, target);
-	}
-	return 0;
+	if (wait)
+		ret = ext4_force_commit(sb);
+	else
+		jbd2_journal_start_commit(EXT4_SB(sb)->s_journal, NULL);
+	return ret;
 }
 
 /*


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
