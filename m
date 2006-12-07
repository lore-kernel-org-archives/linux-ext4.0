From: akpm@osdl.org
Subject: - ext3-uninline-large-functions.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:04:07 -0800
Message-ID: <200612072304.kB7N47sW030017@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
To: akpm@osdl.org, acme@mandriva.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3: uninline large functions
has been removed from the -mm tree.  Its filename was
     ext3-uninline-large-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ext3: uninline large functions
From: Andrew Morton <akpm@osdl.org>

Saves nearly 4kbytes on x86.

Cc: Arnaldo Carvalho de Melo <acme@mandriva.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext3/Makefile         |    2 
 fs/ext3/ext3_jbd.c       |   59 ++++++++++++++++++++++++++++
 include/linux/ext3_jbd.h |   76 ++++++++-----------------------------
 3 files changed, 77 insertions(+), 60 deletions(-)

diff -puN fs/ext3/Makefile~ext3-uninline-large-functions fs/ext3/Makefile
--- a/fs/ext3/Makefile~ext3-uninline-large-functions
+++ a/fs/ext3/Makefile
@@ -5,7 +5,7 @@
 obj-$(CONFIG_EXT3_FS) += ext3.o
 
 ext3-y	:= balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o \
-	   ioctl.o namei.o super.o symlink.o hash.o resize.o
+	   ioctl.o namei.o super.o symlink.o hash.o resize.o ext3_jbd.o
 
 ext3-$(CONFIG_EXT3_FS_XATTR)	 += xattr.o xattr_user.o xattr_trusted.o
 ext3-$(CONFIG_EXT3_FS_POSIX_ACL) += acl.o
diff -puN /dev/null fs/ext3/ext3_jbd.c
--- /dev/null
+++ a/fs/ext3/ext3_jbd.c
@@ -0,0 +1,59 @@
+/*
+ * Interface between ext3 and JBD
+ */
+
+#include <linux/ext3_jbd.h>
+
+int __ext3_journal_get_undo_access(const char *where, handle_t *handle,
+				struct buffer_head *bh)
+{
+	int err = journal_get_undo_access(handle, bh);
+	if (err)
+		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
+	return err;
+}
+
+int __ext3_journal_get_write_access(const char *where, handle_t *handle,
+				struct buffer_head *bh)
+{
+	int err = journal_get_write_access(handle, bh);
+	if (err)
+		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
+	return err;
+}
+
+int __ext3_journal_forget(const char *where, handle_t *handle,
+				struct buffer_head *bh)
+{
+	int err = journal_forget(handle, bh);
+	if (err)
+		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
+	return err;
+}
+
+int __ext3_journal_revoke(const char *where, handle_t *handle,
+				unsigned long blocknr, struct buffer_head *bh)
+{
+	int err = journal_revoke(handle, blocknr, bh);
+	if (err)
+		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
+	return err;
+}
+
+int __ext3_journal_get_create_access(const char *where,
+				handle_t *handle, struct buffer_head *bh)
+{
+	int err = journal_get_create_access(handle, bh);
+	if (err)
+		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
+	return err;
+}
+
+int __ext3_journal_dirty_metadata(const char *where,
+				handle_t *handle, struct buffer_head *bh)
+{
+	int err = journal_dirty_metadata(handle, bh);
+	if (err)
+		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
+	return err;
+}
diff -puN include/linux/ext3_jbd.h~ext3-uninline-large-functions include/linux/ext3_jbd.h
--- a/include/linux/ext3_jbd.h~ext3-uninline-large-functions
+++ a/include/linux/ext3_jbd.h
@@ -109,74 +109,32 @@ int ext3_mark_inode_dirty(handle_t *hand
  * been done yet.
  */
 
-void ext3_journal_abort_handle(const char *caller, const char *err_fn,
-		struct buffer_head *bh, handle_t *handle, int err);
-
-static inline int
-__ext3_journal_get_undo_access(const char *where, handle_t *handle,
-				struct buffer_head *bh)
+static inline void ext3_journal_release_buffer(handle_t *handle,
+						struct buffer_head *bh)
 {
-	int err = journal_get_undo_access(handle, bh);
-	if (err)
-		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
-	return err;
+	journal_release_buffer(handle, bh);
 }
 
-static inline int
-__ext3_journal_get_write_access(const char *where, handle_t *handle,
-				struct buffer_head *bh)
-{
-	int err = journal_get_write_access(handle, bh);
-	if (err)
-		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
-	return err;
-}
+void ext3_journal_abort_handle(const char *caller, const char *err_fn,
+		struct buffer_head *bh, handle_t *handle, int err);
 
-static inline void
-ext3_journal_release_buffer(handle_t *handle, struct buffer_head *bh)
-{
-	journal_release_buffer(handle, bh);
-}
+int __ext3_journal_get_undo_access(const char *where, handle_t *handle,
+				struct buffer_head *bh);
 
-static inline int
-__ext3_journal_forget(const char *where, handle_t *handle, struct buffer_head *bh)
-{
-	int err = journal_forget(handle, bh);
-	if (err)
-		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
-	return err;
-}
+int __ext3_journal_get_write_access(const char *where, handle_t *handle,
+				struct buffer_head *bh);
 
-static inline int
-__ext3_journal_revoke(const char *where, handle_t *handle,
-		      unsigned long blocknr, struct buffer_head *bh)
-{
-	int err = journal_revoke(handle, blocknr, bh);
-	if (err)
-		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
-	return err;
-}
+int __ext3_journal_forget(const char *where, handle_t *handle,
+				struct buffer_head *bh);
 
-static inline int
-__ext3_journal_get_create_access(const char *where,
-				 handle_t *handle, struct buffer_head *bh)
-{
-	int err = journal_get_create_access(handle, bh);
-	if (err)
-		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
-	return err;
-}
+int __ext3_journal_revoke(const char *where, handle_t *handle,
+				unsigned long blocknr, struct buffer_head *bh);
 
-static inline int
-__ext3_journal_dirty_metadata(const char *where,
-			      handle_t *handle, struct buffer_head *bh)
-{
-	int err = journal_dirty_metadata(handle, bh);
-	if (err)
-		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
-	return err;
-}
+int __ext3_journal_get_create_access(const char *where,
+				handle_t *handle, struct buffer_head *bh);
 
+int __ext3_journal_dirty_metadata(const char *where,
+				handle_t *handle, struct buffer_head *bh);
 
 #define ext3_journal_get_undo_access(handle, bh) \
 	__ext3_journal_get_undo_access(__FUNCTION__, (handle), (bh))
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
workqueue-tweaks.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
bridge-avoid-using-noautorel-workqueues.patch
revert-generic_file_buffered_write-handle-zero-length-iovec-segments.patch
revert-generic_file_buffered_write-deadlock-on-vectored-write.patch
generic_file_buffered_write-cleanup.patch
mm-fix-pagecache-write-deadlocks.patch
fs-prepare_write-fixes-fuse-fix.patch
fs-prepare_write-fixes-fat-fix.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-acpi.patch
git-acpi-fixup.patch
acpi-dont-select-pm.patch
implementation-of-acpi_video_get_next_level.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register.patch
acpi-asus-s3-resume-fix.patch
sony_apci-resume.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register-sony_acpi-fix.patch
git-alsa.patch
git-alsa-fixup.patch
alsa-workqueue-fixes.patch
git-cpufreq-prep.patch
git-cpufreq.patch
git-cpufreq-fixup.patch
platform_driver_probe-can-save-codespace-save-codespace.patch
git-drm.patch
git-dvb.patch
git-dvb-fixup.patch
git-ia64.patch
git-ieee1394-fixup.patch
git-input.patch
git-input-fixup.patch
git-input-vs-git-alsa.patch
kbuild-fix-rr-is-now-default.patch
pata_cs5530-suspend-resume-support-tweak.patch
pata_sil680-suspend-resume-tidy.patch
pata_via-suspend-resume-support-fix.patch
pata_it8213-add-new-driver-for-the-it8213-card.patch
git-lxdialog-fixup.patch
git-mmc-fixup.patch
git-mmc-tifm_sd-warning-fix.patch
git-mtd.patch
git-mtd-ssfdc-build-fix.patch
git-ubi.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
net-uninline-skb_put.patch
ioat-warning-fix.patch
pci-fix-multiple-problems-with-via-hardware.patch
pci-legacy-resource-fix-tidy.patch
git-s390.patch
s390-workqueue-fixes.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-in2000-scsi_cmnd-convertion.patch
aic79xx-wrong-max-memory-at-driver-init.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver-fix.patch
git-qla3xxx-fixup.patch
nokia-e70-is-an-unusual-device.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
x86_64-fix-boot-hang-due-to-nmi-watchdog-init-code-tidy.patch
x86_64-fix-boot-hang-due-to-nmi-watchdog-init-code-tidy-tidy-2.patch
touchkit-ps-2-touchscreen-driver.patch
node-aware-skb-allocation-fix-for-device-tree-changes.patch
congestion-wait-dont-wait-when-there-are-no-pages-under-writeback.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index-tweaks.patch
add-include-linux-freezerh-and-move-definitions-from-ucb1400_ts-fix.patch
ubi-versus-add-include-linux-freezerh-and-move-definitions-from.patch
deprecate-smbfs-in-favour-of-cifs.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
drivers-add-lcd-support-3-Kconfig-fix.patch
drivers-add-lcd-support-workqueue-fixups.patch
touch_atime-cleanup.patch
ocfs2-relative-atime-support-tweaks.patch
optimize-o_direct-on-block-device-v3-tweak.patch
add-retain_initrd-boot-option-tweak.patch
io-accounting-core-statistics.patch
clean-up-__set_page_dirty_nobuffers.patch
io-accounting-write-accounting.patch
io-accounting-write-cancel-accounting.patch
io-accounting-read-accounting-2.patch
io-accounting-read-accounting-nfs-fix.patch
io-accounting-read-accounting-cifs-fix.patch
io-accounting-direct-io.patch
io-accounting-report-in-procfs.patch
cleanup-taskstatsh.patch
io-accounting-via-taskstats.patch
getdelays-various-fixes.patch
io-accounting-add-to-getdelays.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
tty-signal-tty-locking-post-viro-trainwreck.patch
tty-signal-tty-locking-post-viro-trainwreck-fix.patch
tty-signal-tty-locking-post-viro-trainwreck-fix-fix.patch
pktcdvd-bio-write-congestion-using-blk_congestion_wait-fix.patch
bug-test-1.patch
net-use-bitrev8-tidy.patch
fsstack-introduce-fsstack_copy_attrinode_-tidy.patch
ecryptfs-use-fsstacks-generic-copy-inode-attr-tidy-fix-fix.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel-fix.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel-vs-git-cryptodev.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel-ppc-fix.patch
add-process_session-helper-routine-deprecate-old-field-tidy.patch
add-process_session-helper-routine-deprecate-old-field-fix-warnings.patch
add-process_session-helper-routine-deprecate-old-field-fix-warnings-2.patch
mxser-session-warning-fix.patch
mxser-workqueue-fixes.patch
tty-switch-to-ktermios-and-new-framework-warning-fix.patch
tty-switch-to-ktermios-and-new-framework-irda-fix.patch
tty-switch-to-ktermios-bluetooth-fix.patch
tty_ioctl-use-termios-for-the-old-structure-and-termios2-fix.patch
drivers-isdn-handcrafted-min-max-macro-removal-fix.patch
fault-injection-capabilities-infrastructure-tidy.patch
fault-injection-capabilities-infrastructure-tweaks.patch
fault-injection-Kconfig-cleanup.patch
fault-injection-stacktrace-filtering-kconfig-fix.patch
sched-add-option-to-serialize-load-balancing-fix.patch
kernel-schedc-whitespace-cleanups-more.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
sysctl-fix-sys_sysctl-interface-of-ipc-sysctls-fix-3.patch
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
hpt3xx-rework-rate-filtering-tidy.patch
jmicron-warning-fix.patch
video-get-the-default-mode-from-the-right-database.patch
various-fbdev-files-mark-structs-fix.patch
backlight-lcd-remove-dependenct-from-the-framebuffer-layer-tidy.patch
gxfb-fixups-for-the-amd-geode-gx-tidy.patch
gxfb-support-flat-panel-timings-tidy.patch
gxfb-support-command-line-options-tidy.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-fix.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-2.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release-fix.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch
gtod-persistent-clock-support-i386.patch
hrtimers-clean-up-locking-fix.patch
updated-hrtimers-state-tracking.patch
updated-i386-convert-to-clock-event-devices.patch
updated-i386-convert-to-clock-event-devices-fix.patch
updated-gtod-mark-tsc-unusable-for-highres-timers.patch
round_jiffies-infrastructure-fix.patch
clocksource-small-cleanup-2-fix.patch
kvm-make-the-vcpu-execution-loop-an-arch-operation-build-fix.patch
kvm-make-__set_efer-an-arch-operation-build-fix.patch
slim-main-include-fix.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
x86-kmap_atomic-debugging.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
zeromap_pte_range-debug.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch

