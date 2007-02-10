From: akpm@linux-foundation.org
Subject: - return-enoent-from-ext3_link-when-racing-with-unlink-fix.patch removed from -mm tree
Date: Sat, 10 Feb 2007 00:21:03 -0800
Message-ID: <200702100821.l1A8L3Ee007133@shell0.pdx.osdl.net>
To: akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	sandeen@redhat.com, mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39545 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003AbXBJIVO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 10 Feb 2007 03:21:14 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     return-enoent-from-ext3_link-when-racing-with-unlink-fix
has been removed from the -mm tree.  Its filename was
     return-enoent-from-ext3_link-when-racing-with-unlink-fix.patch

This patch was dropped because it was folded into return-enoent-from-ext3_link-when-racing-with-unlink.patch

------------------------------------------------------
Subject: return-enoent-from-ext3_link-when-racing-with-unlink-fix
From: Andrew Morton <akpm@osdl.org>

sigh.

Cc: Eric Sandeen <sandeen@redhat.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext3/namei.c |    4 ++++
 fs/ext4/namei.c |    4 ++++
 2 files changed, 8 insertions(+)

diff -puN fs/ext3/namei.c~return-enoent-from-ext3_link-when-racing-with-unlink-fix fs/ext3/namei.c
--- a/fs/ext3/namei.c~return-enoent-from-ext3_link-when-racing-with-unlink-fix
+++ a/fs/ext3/namei.c
@@ -2191,6 +2191,10 @@ static int ext3_link (struct dentry * ol
 
 	if (inode->i_nlink >= EXT3_LINK_MAX)
 		return -EMLINK;
+	/*
+	 * Return -ENOENT if we've raced with unlink and i_nlink is 0.  Doing
+	 * otherwise has the potential to corrupt the orphan inode list.
+	 */
 	if (inode->i_nlink == 0)
 		return -ENOENT;
 
diff -puN fs/ext4/namei.c~return-enoent-from-ext3_link-when-racing-with-unlink-fix fs/ext4/namei.c
--- a/fs/ext4/namei.c~return-enoent-from-ext3_link-when-racing-with-unlink-fix
+++ a/fs/ext4/namei.c
@@ -2189,6 +2189,10 @@ static int ext4_link (struct dentry * ol
 
 	if (inode->i_nlink >= EXT4_LINK_MAX)
 		return -EMLINK;
+	/*
+	 * Return -ENOENT if we've raced with unlink and i_nlink is 0.  Doing
+	 * otherwise has the potential to corrupt the orphan inode list.
+	 */
 	if (inode->i_nlink == 0)
 		return -ENOENT;
 
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
avoid-excessive-sorting-of-early_node_map.patch
proc-zoneinfo-fix-vm-stats-display.patch
use-zvc-for-inactive-and-active-counts.patch
drop-free_pages.patch
optional-zone_dma-in-the-vm.patch
swsusp-change-code-ordering-in-userc-sanity.patch
drivers-add-lcd-support-3.patch
count_vm_events-warning-fix.patch
add-taint_user-and-ability-to-set-taint-flags-from-userspace.patch
remove-invalidate_inode_pages.patch
add-an-rcu-version-of-list-splicing.patch
sysctl-warning-fix.patch
proc_misc-warning-fix.patch
rtc-framework-driver-for-cmos-rtcs.patch
return-enoent-from-ext3_link-when-racing-with-unlink.patch
return-enoent-from-ext3_link-when-racing-with-unlink-fix.patch
filesystem-disk-errors-at-boot-time-caused-by-probe-tidy.patch
filesystem-disk-errors-at-boot-time-caused-by-probe-tidy-fixes.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
register_chrdev_region-dont-hand-out-the-local-experimental-majors.patch
register_blkdev-dont-hand-out-the-local-experimental-majors.patch
factor-outstanding-i-o-error-handling-tidy.patch
sync_sb_inodes-propagate-errors.patch
spi-controller-driver-for-omap-microwire-tidy.patch
spi-controller-driver-for-omap-microwire-update-fix.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
vmi-versus-hrtimers.patch
add-a-functions-to-handle-interrupt-affinity-setting-alpha-fix.patch
i386-use-gtod-persistent-clock-support.patch
hrtimers-namespace-and-enum-cleanup-vs-git-input.patch
hrtimers-cleanup-locking.patch
hrtimers-add-state-tracking.patch
clockevents-i383-drivers.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
revert-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-fix.patch
reapply-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
schedule_on_each_cpu-use-preempt_disable.patch
implement-flush_work-sanity.patch
implement-flush_work_keventd.patch
flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-2.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release-fix.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
omap-gpio-wrappers-tidy.patch
at91-gpio-wrappers-tidy.patch
ecryptfs-public-key-packet-management-slab-fix.patch
ecryptfs-generalize-metadata-read-write-fix.patch
fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine-gfs2-fix.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix.patch
aio-is-unlikely.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
dynamic-kernel-command-line-ia64-fix.patch
kvm-add-a-global-list-of-all-virtual-machines-tidy.patch
readahead-kconfig-options-fix.patch
readahead-minmax_ra_pages.patch
readahead-sysctl-parameters.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
readahead-context-based-method-locking-fix.patch
readahead-context-based-method-locking-fix-2.patch
readahead-call-scheme-ifdef-fix.patch
readahead-call-scheme-build-fix.patch
readahead-nfsd-case-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
resier4-add-include-linux-freezerh-and-move-definitions-from.patch
make-kmem_cache_destroy-return-void-reiser4.patch
reiser4-hardirq-include-fix.patch
reiser4-run-truncate_inode_pages-in-reiser4_delete_inode.patch
reiser4-get_sb_dev-fix.patch
reiser4-vs-zoned-allocator.patch
reiser4-temp-fix.patch
reiser4-kmem_cache_t-removal.patch
reiser4-test_clear_page_dirty.patch
reiser4-vs-git-block.patch
reiser4-vs-git-block-2.patch
cyber2010-framebuffer-on-arm-netwinder-fix-tidy.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
slim-main-include-fix.patch
mark-struct-file_operations-const-2-fix.patch
mark-struct-file_operations-const-4-fix.patch
scheduled-removal-of-sa_xxx-interrupt-flags-ata-fix.patch
sysctl-c99-convert-ctl_tables-in-ntfs-and-remove-sys_sysctl-support-fix.patch
sysctl-move-utsname-sysctls-to-their-own-file-fix-2.patch
sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry-warning-fix.patch
sysctl-factor-out-sysctl_head_next-from-do_sysctl-warning-fix.patch
sysctl-reimplement-the-sysctl-proc-support-warning-fix.patch
sysctl-reimplement-the-sysctl-proc-support-fix-2.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-ntfs-fix.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
ia64-enable-config_debug_spinlock_sleep.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch
