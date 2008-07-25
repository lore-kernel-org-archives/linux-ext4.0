From: akpm@linux-foundation.org
Subject: - ext3-handle-corrupted-orphan-list-at-mount-cleanup-fix.patch removed from -mm tree
Date: Thu, 24 Jul 2008 17:16:56 -0700
Message-ID: <200807250016.m6P0Guft013629@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: akpm@linux-foundation.org, duaneg@dghda.com,
	linux-ext4@vger.kernel.org, mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3-handle-corrupted-orphan-list-at-mount-cleanup-fix
has been removed from the -mm tree.  Its filename was
     ext3-handle-corrupted-orphan-list-at-mount-cleanup-fix.patch

This patch was dropped because it was folded into ext3-handle-corrupted-orphan-list-at-mount.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3-handle-corrupted-orphan-list-at-mount-cleanup-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: <linux-ext4@vger.kernel.org>
Cc: Duane Griffin <duaneg@dghda.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/inode.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN fs/ext3/inode.c~ext3-handle-corrupted-orphan-list-at-mount-cleanup-fix fs/ext3/inode.c
--- a/fs/ext3/inode.c~ext3-handle-corrupted-orphan-list-at-mount-cleanup-fix
+++ a/fs/ext3/inode.c
@@ -2258,15 +2258,14 @@ static void ext3_free_branches(handle_t 
 
 int ext3_can_truncate(struct inode *inode)
 {
+	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
+		return 0;
 	if (S_ISREG(inode->i_mode))
 		return 1;
 	if (S_ISDIR(inode->i_mode))
 		return 1;
-	if (S_ISLNK(inode->i_mode)) {
-		if (!ext3_inode_is_fast_symlink(inode) &&
-				!(IS_APPEND(inode) || IS_IMMUTABLE(inode)))
-			return 1;
-	}
+	if (S_ISLNK(inode->i_mode))
+		return !ext3_inode_is_fast_symlink(inode);
 	return 0;
 }
 
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

