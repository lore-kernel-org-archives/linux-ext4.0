From: akpm@linux-foundation.org
Subject: - ext3-fix-lock-inversion-in-direct-io-fix.patch removed from -mm tree
Date: Tue, 05 Feb 2008 23:39:12 -0800
Message-ID: <200802060738.m167crNf032134@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: akpm@linux-foundation.org, jack@suse.cz,
	linux-ext4@vger.kernel.org, pbadari@us.ibm.com,
	zach.brown@oracle.com, mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3-fix-lock-inversion-in-direct-io-fix
has been removed from the -mm tree.  Its filename was
     ext3-fix-lock-inversion-in-direct-io-fix.patch

This patch was dropped because it was folded into ext3-fix-lock-inversion-in-direct-io.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3-fix-lock-inversion-in-direct-io-fix
From: Andrew Morton <akpm@linux-foundation.org>

fs/ext3/inode.c: In function 'ext3_get_block':
fs/ext3/inode.c:964: error: 'sb' undeclared (first use in this function)
fs/ext3/inode.c:964: error: (Each undeclared identifier is reported only once
fs/ext3/inode.c:964: error: for each function it appears in.)

Cc: <linux-ext4@vger.kernel.org>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Zach Brown <zach.brown@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ext3/inode.c~ext3-fix-lock-inversion-in-direct-io-fix fs/ext3/inode.c
--- a/fs/ext3/inode.c~ext3-fix-lock-inversion-in-direct-io-fix
+++ a/fs/ext3/inode.c
@@ -961,7 +961,7 @@ static int ext3_get_block(struct inode *
 		if (max_blocks > DIO_MAX_BLOCKS)
 			max_blocks = DIO_MAX_BLOCKS;
 		handle = ext3_journal_start(inode, DIO_CREDITS +
-				2 * EXT3_QUOTA_TRANS_BLOCKS(sb));
+				2 * EXT3_QUOTA_TRANS_BLOCKS(inode->i_sb));
 		if (IS_ERR(handle)) {
 			ret = PTR_ERR(handle);
 			goto out;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
kernel-printkc-concerns-about-the-console-handover.patch
riscom8-fix-smp-brokenness.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void.patch
genericizing-iova-fix.patch
parallel-port-convert-port_mutex-to-the-mutex-api.patch
remove-support-for-un-needed-_extratext-section.patch
allow-auto-destruction-of-loop-devices.patch
read_current_time-cleanups.patch
address-hfs-on-disk-corruption-robustness-review-comments.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open.patch
kallsyms-should-prefer-non-weak-symbols.patch
quota-improve-inode-list-scanning-in-add_dquot_ref.patch
tty-enable-the-echoing-of-c-in-the-n_tty-discipline.patch
stopmachine-semaphore-to-mutex.patch
parport-add-support-for-the-quatech-sppxp-100-parallel-port-pci-expresscard.patch
debug_smp_processor_id-fixlets.patch
use-ilog2-in-fs-namespacec.patch
system-timer-fix-crash-in-100hz-system-timer.patch
speed-up-jiffies-conversion-functions-if-hz==user_hz.patch
drivers-isdn-hardware-eicon-debugc-fix-uninitialized-var-warning.patch
ecryptfs-make-show_options-reflect-actual-mount-options.patch
rtc-ds1302-rtc-support.patch
add-hpet-rtc-emulation-to-rtc_drv_cmos.patch
fbmon-cleanup-trailing-whitespaces.patch
neofb-avoid-overwriting-fb_info-fields.patch
vermilionc-use-align-not-__align_mask.patch
declare-pnp-option-parsing-functions-as-__init.patch
isapnp-driver-semaphore-to-mutex.patch
ext3-fix-lock-inversion-in-direct-io.patch
ext3-fix-lock-inversion-in-direct-io-fix.patch
kill-filp_open-checkpatch-fixes.patch
rename-open_namei-to-open_pathname-fix.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-checkpatch-fixes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
r-o-bind-mounts-elevate-write-count-opened-files-oops-fix.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly-checkpatch-fixes.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
keep-track-of-mnt_writer-state-of-struct-file-fix-warn_on-fix.patch
cgroup-simplify-space-stripping-fix.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-mm_cgroup-to-header-file-fix.patch
memcontrol-move-mm_cgroup-to-header-file-fix-2.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-memorystat-file.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup-cleanup.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup-checkpatch-fixes.patch
hotplug-cpu-move-tasks-in-empty-cpusets-to-parent-checkpatch-fixes.patch
cpusets-update_cpumask-revision-fix.patch
cpusets-update_cpumask-revision-checkpatch-fixes.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
introduce-flags-for-reserve_bootmem-powerpc-fix.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-unionfs-from-using-iget-and-read_inode-fix-2.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-vs-git-unionfs.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-cifs-fix.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-smack-fix.patch
introduce-path_put-cifs-fix.patch
one-less-parameter-to-__d_path-checkpatch-fixes.patch
d_path-use-struct-path-in-struct-avc_audit_data-checkpatch-fixes.patch
d_path-make-get_dcookie-use-a-struct-path-argument-checkpatch-fixes.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
d_path-make-d_path-use-a-struct-path-fix.patch
cleanup-the-code-managed-with-the-user_ns-option-checkpatch-fixes.patch
cleanup-the-code-managed-with-pid_ns-option-checkpatch-fixes.patch
proc-detect-duplicate-names-on-registration-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-2.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-3.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-nommu-fix.patch
proc-fix-openless-usage-due-to-proc_fops-flip-checkpatch-fixes.patch
intel-iommu-fault_reason_index_cleanuppatch-fix.patch
modules-make-module_address_lookup-safe-fix.patch
wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace-fix.patch
pid-sys_wait-fixes-v2-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-git-x86.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-sanitize-the-type-of-struct-useru_ar0.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth-alpha-fix.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
rewrite-rd-fixes.patch
fs-remove-fastcall-it-is-always-empty-checkpatch-fixes.patch
kernel-remove-fastcall-in-kernel-checkpatch-fixes.patch
lib-remove-fastcall-from-lib-checkpatch-fixes.patch
remove-fastcall-from-linux-include-checkpatch-fixes.patch
constify-tables-in-kernel-sysctl_checkc-fix.patch
aoe-statically-initialise-devlist_lock.patch
xfs-convert-bex_add-to-bex_add_cpu-new-common-api-fix.patch
ufs-fix-symlink-creation-on-ufs2-fix.patch
libfs-allow-error-return-from-simple-attributes-fix.patch
fs-hfsplus-unicodec-fix-uninitialized-var-warning.patch
fs-afs-securityc-fix-uninitialized-var-warning.patch
mount-options-fix-tmpfs-fix.patch
char-applicom-use-pci_match_id-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix-2.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
page-owner-tracking-leak-detector-broken-on-s390.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
w1-build-fix.patch
