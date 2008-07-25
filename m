From: akpm@linux-foundation.org
Subject: - ext3-handle-deleting-corrupted-indirect-blocks-fix.patch removed from -mm tree
Date: Thu, 24 Jul 2008 17:17:44 -0700
Message-ID: <200807250017.m6P0Hij7013735@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: akpm@linux-foundation.org, duaneg@dghda.com,
	linux-ext4@vger.kernel.org, mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3-handle-deleting-corrupted-indirect-blocks-fix
has been removed from the -mm tree.  Its filename was
     ext3-handle-deleting-corrupted-indirect-blocks-fix.patch

This patch was dropped because it was folded into ext3-handle-deleting-corrupted-indirect-blocks.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3-handle-deleting-corrupted-indirect-blocks-fix
From: Andrew Morton <akpm@linux-foundation.org>

fs/ext3/inode.c: In function 'ext3_free_data':
fs/ext3/inode.c:2146: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'sector_t'

Cc: <linux-ext4@vger.kernel.org>
Cc: Duane Griffin <duaneg@dghda.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/inode.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/ext3/inode.c~ext3-handle-deleting-corrupted-indirect-blocks-fix fs/ext3/inode.c
--- a/fs/ext3/inode.c~ext3-handle-deleting-corrupted-indirect-blocks-fix
+++ a/fs/ext3/inode.c
@@ -2142,8 +2142,9 @@ static void ext3_free_data(handle_t *han
 		else
 			ext3_error(inode->i_sb, "ext3_free_data",
 				   "circular indirect block detected, "
-				   "inode=%lu, block="E3FSBLK,
-				   inode->i_ino, this_bh->b_blocknr);
+				   "inode=%lu, block=%llu",
+				   inode->i_ino,
+				   (unsigned long long)this_bh->b_blocknr);
 	}
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
ext3-handle-deleting-corrupted-indirect-blocks.patch
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

