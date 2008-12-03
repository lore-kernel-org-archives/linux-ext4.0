From: <gregkh@suse.de>
Subject: patch ext4-renumber-ext4_ioc_migrate.patch added to 2.6.27-stable tree
Date: Wed, 03 Dec 2008 10:56:01 -0800
Message-ID: <20081203185928.6CA9D4904C@coco.kroah.org>
References: <1226851540-8032-7-git-send-email-tytso@mit.edu>
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
To: tytso@mit.edu, gregkh@suse.de, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:60943 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752022AbYLCS73 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Dec 2008 13:59:29 -0500
In-Reply-To: <1226851540-8032-7-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

    Subject: ext4: Renumber EXT4_IOC_MIGRATE

to the 2.6.27-stable tree.  Its filename is

    ext4-renumber-ext4_ioc_migrate.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From tytso@mit.edu  Wed Dec  3 09:59:19 2008
From: "Theodore Ts'o" <tytso@mit.edu>
Date: Sun, 16 Nov 2008 11:05:26 -0500
Subject: ext4: Renumber EXT4_IOC_MIGRATE
To: stable@kernel.org
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>
Message-ID: <1226851540-8032-7-git-send-email-tytso@mit.edu>

From: "Theodore Ts'o" <tytso@mit.edu>

(cherry picked from commit 8eea80d52b9d87cfd771055534bd2c24f73704d7)

Pick an ioctl number for EXT4_IOC_MIGRATE that won't conflict with
other ext4 ioctl's.  Since there haven't been any major userspace
users of this ioctl, we can afford to change this now, to avoid
potential problems later.

Also, reorder the ioctl numbers in ext4.h to avoid this sort of
mistake in the future.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/ext4.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -291,8 +291,6 @@ struct ext4_new_group_data {
 #define	EXT4_IOC_SETFLAGS		FS_IOC_SETFLAGS
 #define	EXT4_IOC_GETVERSION		_IOR('f', 3, long)
 #define	EXT4_IOC_SETVERSION		_IOW('f', 4, long)
-#define EXT4_IOC_GROUP_EXTEND		_IOW('f', 7, unsigned long)
-#define EXT4_IOC_GROUP_ADD		_IOW('f', 8,struct ext4_new_group_input)
 #define	EXT4_IOC_GETVERSION_OLD		FS_IOC_GETVERSION
 #define	EXT4_IOC_SETVERSION_OLD		FS_IOC_SETVERSION
 #ifdef CONFIG_JBD2_DEBUG
@@ -300,7 +298,10 @@ struct ext4_new_group_data {
 #endif
 #define EXT4_IOC_GETRSVSZ		_IOR('f', 5, long)
 #define EXT4_IOC_SETRSVSZ		_IOW('f', 6, long)
-#define EXT4_IOC_MIGRATE		_IO('f', 7)
+#define EXT4_IOC_GROUP_EXTEND		_IOW('f', 7, unsigned long)
+#define EXT4_IOC_GROUP_ADD		_IOW('f', 8, struct ext4_new_group_input)
+#define EXT4_IOC_MIGRATE		_IO('f', 9)
+ /* note ioctl 11 reserved for filesystem-independent FIEMAP ioctl */
 
 /*
  * ioctl commands in 32 bit emulation


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
