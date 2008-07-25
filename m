From: akpm@linux-foundation.org
Subject: - ext3-handle-corrupted-orphan-list-at-mount-fix.patch removed from -mm tree
Date: Thu, 24 Jul 2008 17:16:53 -0700
Message-ID: <200807250016.m6P0Gr6n013626@imap1.linux-foundation.org>
To: akpm@linux-foundation.org, duaneg@dghda.com,
	linux-ext4@vger.kernel.org, sliedes@cc.hut.fi,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36620 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752632AbYGYARB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Jul 2008 20:17:01 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     ext3-handle-corrupted-orphan-list-at-mount-fix
has been removed from the -mm tree.  Its filename was
     ext3-handle-corrupted-orphan-list-at-mount-fix.patch

This patch was dropped because it was folded into ext3-handle-corrupted-orphan-list-at-mount.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3-handle-corrupted-orphan-list-at-mount-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: <linux-ext4@vger.kernel.org>
Cc: Duane Griffin <duaneg@dghda.com>
Cc: Sami Liedes <sliedes@cc.hut.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/ialloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ext3/ialloc.c~ext3-handle-corrupted-orphan-list-at-mount-fix fs/ext3/ialloc.c
--- a/fs/ext3/ialloc.c~ext3-handle-corrupted-orphan-list-at-mount-fix
+++ a/fs/ext3/ialloc.c
@@ -698,7 +698,7 @@ bad_orphan:
 		printk(KERN_NOTICE "NEXT_ORPHAN(inode)=%u\n",
 		       NEXT_ORPHAN(inode));
 		printk(KERN_NOTICE "max_ino=%lu\n", max_ino);
-		printk(KERN_NOTICE "i_nlink=%lu\n", inode->i_nlink);
+		printk(KERN_NOTICE "i_nlink=%u\n", inode->i_nlink);
 		/* Avoid freeing blocks if we got a bad deleted inode */
 		if (inode->i_nlink == 0)
 			inode->i_blocks = 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm.patch
build-kernel-profileo-only-when-requested-cleanups.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
exec-remove-some-includes.patch
inflate-refactor-inflate-malloc-code.patch
drivers-misc-hpiloc-needs-config_pci.patch
add-a-warn-macro-this-is-warn_on-printk-arguments.patch
gpio-sysfs-interface-updated.patch
gpio-add-bt8xxgpio-driver.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction.patch
ext3-handle-corrupted-orphan-list-at-mount.patch
ext3-handle-corrupted-orphan-list-at-mount-fix.patch
ext3-handle-corrupted-orphan-list-at-mount-cleanup-fix.patch
ext3-handle-deleting-corrupted-indirect-blocks-fix.patch
jbd-dont-abort-if-flushing-file-data-failed-fix.patch
reiserfs-convert-j_flush_sem-to-mutex.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix.patch
quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix-fix.patch
cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup-fix.patch
cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup-checkpatch-fixes.patch
devcgroup-code-cleanup-fix.patch
memcg-remove-refcnt-from-page_cgroup-fix-2.patch
memcg-limit-change-shrink-usage-checkpatch-fixes.patch
coredump-format_corename-fix-the-core_uses_pid-logic-checkpatch-fixes.patch
workqueues-make-get_online_cpus-useable-for-work-func-fix.patch
ipc-semc-convert-undo-structures-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-convert-sem_arraysem_pending-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-rewrite-undo-list-locking-checkpatch-fixes.patch
fs-partition-checkc-fix-return-value-warning-v2-cleanup.patch
block-ioctlc-and-fs-partition-checkc-checkpatch-fixes.patch
getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes.patch
edac-mpc85xx-fix-pci-ofdev-2nd-pass-checkpatch-fixes.patch

