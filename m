From: akpm@linux-foundation.org
Subject: - ext3-lighten-up-resize-transaction-requirements-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 16 Oct 2007 15:31:03 -0700
Message-ID: <200710162231.l9GMV3o1021099@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: akpm@linux-foundation.org, adilger@clusterfs.com,
	linux-ext4@vger.kernel.org, sandeen@redhat.com,
	mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3-lighten-up-resize-transaction-requirements-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     ext3-lighten-up-resize-transaction-requirements-checkpatch-fixes.patch

This patch was dropped because it was folded into ext3-lighten-up-resize-transaction-requirements.patch

------------------------------------------------------
Subject: ext3-lighten-up-resize-transaction-requirements-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: do not use assignment in if condition
#58: FILE: fs/ext3/resize.c:173:
+		if ((err = ext3_journal_restart(handle, EXT3_MAX_TRANS_DATA)))

ERROR: use tabs not spaces
#60: FILE: fs/ext3/resize.c:175:
+^I$

ERROR: do not use assignment in if condition
#60: FILE: fs/ext3/resize.c:175:
+	        if ((err = ext3_journal_get_write_access(handle, bh)))

ERROR: use tabs not spaces
#62: FILE: fs/ext3/resize.c:177:
$

ERROR: do not use assignment in if condition
#87: FILE: fs/ext3/resize.c:233:
+		if ((err = extend_or_restart_transaction(handle, 1, bh)))

ERROR: do not use assignment in if condition
#97: FILE: fs/ext3/resize.c:261:
+		if ((err = extend_or_restart_transaction(handle, 1, bh)))

ERROR: do not use assignment in if condition
#108: FILE: fs/ext3/resize.c:286:
+		if ((err = extend_or_restart_transaction(handle, 1, bh)))

ERROR: do not use assignment in if condition
#119: FILE: fs/ext3/resize.c:298:
+	if ((err = extend_or_restart_transaction(handle, 2, bh)))

Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Cc: <linux-ext4@vger.kernel.org>
Cc: Andreas Dilger <adilger@clusterfs.com>
Cc: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/ext3/resize.c~ext3-lighten-up-resize-transaction-requirements-checkpatch-fixes fs/ext3/resize.c
--- a/fs/ext3/resize.c~ext3-lighten-up-resize-transaction-requirements-checkpatch-fixes
+++ a/fs/ext3/resize.c
@@ -170,11 +170,13 @@ static int extend_or_restart_transaction
 	if (err < 0)
 		return err;
 	if (err) {
-		if ((err = ext3_journal_restart(handle, EXT3_MAX_TRANS_DATA)))
+		err = ext3_journal_restart(handle, EXT3_MAX_TRANS_DATA);
+		if (err)
 			return err;
-	        if ((err = ext3_journal_get_write_access(handle, bh)))
+		err = ext3_journal_get_write_access(handle, bh);
+		if (err)
 			return err;
-        }
+	}
 
 	return 0;
 }
@@ -230,7 +232,8 @@ static int setup_new_group_blocks(struct
 
 		ext3_debug("update backup group %#04lx (+%d)\n", block, bit);
 
-		if ((err = extend_or_restart_transaction(handle, 1, bh)))
+		err = extend_or_restart_transaction(handle, 1, bh);
+		if (err)
 			goto exit_bh;
 
 		gdb = sb_getblk(sb, block);
@@ -258,7 +261,8 @@ static int setup_new_group_blocks(struct
 
 		ext3_debug("clear reserved block %#04lx (+%d)\n", block, bit);
 
-		if ((err = extend_or_restart_transaction(handle, 1, bh)))
+		err = extend_or_restart_transaction(handle, 1, bh);
+		if (err)
 			goto exit_bh;
 
 		if (IS_ERR(gdb = bclean(handle, sb, block))) {
@@ -283,7 +287,8 @@ static int setup_new_group_blocks(struct
 
 		ext3_debug("clear inode block %#04lx (+%d)\n", block, bit);
 
-		if ((err = extend_or_restart_transaction(handle, 1, bh)))
+		err = extend_or_restart_transaction(handle, 1, bh);
+		if (err)
 			goto exit_bh;
 
 		if (IS_ERR(it = bclean(handle, sb, block))) {
@@ -295,7 +300,8 @@ static int setup_new_group_blocks(struct
 		ext3_set_bit(bit, bh->b_data);
 	}
 
-	if ((err = extend_or_restart_transaction(handle, 2, bh)))
+	err = extend_or_restart_transaction(handle, 2, bh);
+	if (err)
 		goto exit_bh;
 
 	mark_bitmap_end(input->blocks_count, EXT3_BLOCKS_PER_GROUP(sb),
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-bdi-init-hooks.patch
mm-per-device-dirty-threshold.patch
mm-dirty-balancing-for-tasks.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters.patch
oom-change-all_unreclaimable-zone-member-to-flags.patch
oom-do-not-take-callback_mutex.patch
writeback-dont-propagate-aop_writepage_activate.patch
softlockup-add-a-proc-tuning-parameter.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91.patch
do_sys_poll-simplify-playing-with-on-stack-data.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
add-in-sunos-41x-compatible-mode-for-ufs.patch
core_pattern-fix-up-a-few-miscellaneous-bugs.patch
printk-add-interfaces-for-external-access-to-the-log-buffer.patch
deprecate-aout-elf-interpreters.patch
ext2-ext3-ext4-add-block-bitmap-validation.patch
pie-executable-randomization.patch
binfmt_flat-warning-fixes.patch
i2o-fix-defined-but-not-used-build-warnings.patch
reiserfs-workaround-for-dead-loop-in-finish_unfinished.patch
tty-expose-new-methods-needed-for-drivers-to-get-termios-right.patch
userc-ifdef-mq_bytes.patch
ext3-lighten-up-resize-transaction-requirements.patch
ext3-lighten-up-resize-transaction-requirements-checkpatch-fixes.patch
drivers-char-ip2-fix-used-uninitd-bug-checkpatch-fixes.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
writeback-fix-time-ordering-of-the-per-superblock-inode-lists-8.patch
writeback-remove-pages_skipped-accounting-in-__block_write_full_page-fix.patch
revert-faster-ext2_clear_inode.patch
ext2-reservations-fix-for-percpu_counter-changes.patch
md-software-raid-autodetect-dev-list-not-array.patch
do-cpu_dead-migrating-under-read_locktasklist-instead-of-write_lock_irqtasklist-fix.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
jbd-config_jbd_debug-cannot-create-proc-entry-fix.patch
peterz-vs-ext4-mballoc-core.patch
64-bit-i_version-afs-fixes.patch
pnp-use-dev_info-dev_err-etc-in-core-fix.patch
pnp-add-debug-message-for-adding-new-device-fix-fix.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
task-containersv11-basic-task-container-framework-fix.patch
task-containersv11-shared-container-subsystem-group-arrays-include-fix.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
lockdep-fix-mismatched-lockdep_depth-curr_chain_hash-checkpatch-fixes.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
cpuset-sched_load_balance-flag-fix.patch
cpusets-decrustify-cpuset-mask-update-code-checkpatch-fixes.patch
memory-controller-memory-accounting-v7-fix.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memcontrol-move-oom-task-exclusion-to-tasklist-fix.patch
remove-bits_to_type-macro-fix.patch
use-helpers-to-obtain-task-pid-in-printks-drm-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified-checkpatch-fixes.patch
powerpc-lock-bitops-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix-2.patch
use-extended-crashkernel-command-line-on-i386.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work-checkpatch-fixes.patch
hook-up-group-scheduler-with-control-groups-fix.patch
linux-kernel-markers-checkpatch-fixes.patch
linux-kernel-markers-samples-checkpatch-fixes.patch
uninline-forkc-exitc-checkpatch-fixes.patch
fuse-fix-race-between-getattr-and-write-checkpatch-fixes.patch
fuse-add-file-handle-to-getattr-operation-checkpatch-fixes.patch
sparse-pointer-use-of-zero-as-null-checkpatch-fixes.patch
reiser4.patch
git-block-vs-reiser4.patch
git-nfsd-broke-reiser4.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
profile-likely-unlikely-macros-fix.patch
getblk-handle-2tb-devices.patch
w1-build-fix.patch
