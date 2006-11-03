From: akpm@osdl.org
Subject: + ext4-uninline-large-functions.patch added to -mm tree
Date: Fri, 03 Nov 2006 12:00:37 -0800
Message-ID: <200611032000.kA3K0bne031677@shell0.pdx.osdl.net>
Cc: akpm@osdl.org, acme@mandriva.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:4770 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932081AbWKCUAn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Nov 2006 15:00:43 -0500
To: mm-commits@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext4: uninline large functions
has been added to the -mm tree.  Its filename is
     ext4-uninline-large-functions.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext4: uninline large functions
From: Andrew Morton <akpm@osdl.org>

Saves nearly 4kbytes on x86.

Cc: Arnaldo Carvalho de Melo <acme@mandriva.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext4/Makefile          |    3 -
 fs/ext4/ext4_jbd2.c       |   59 +++++++++++++++++++++++++++
 include/linux/ext4_jbd2.h |   76 ++++++++----------------------------
 3 files changed, 78 insertions(+), 60 deletions(-)

diff -puN fs/ext4/Makefile~ext4-uninline-large-functions fs/ext4/Makefile
--- a/fs/ext4/Makefile~ext4-uninline-large-functions
+++ a/fs/ext4/Makefile
@@ -5,7 +5,8 @@
 obj-$(CONFIG_EXT4DEV_FS) += ext4dev.o
 
 ext4dev-y	:= balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o \
-	   ioctl.o namei.o super.o symlink.o hash.o resize.o extents.o
+		   ioctl.o namei.o super.o symlink.o hash.o resize.o extents.o \
+		   ext4_jbd2.o
 
 ext4dev-$(CONFIG_EXT4DEV_FS_XATTR)	+= xattr.o xattr_user.o xattr_trusted.o
 ext4dev-$(CONFIG_EXT4DEV_FS_POSIX_ACL)	+= acl.o
diff -puN /dev/null fs/ext4/ext4_jbd2.c
--- /dev/null
+++ a/fs/ext4/ext4_jbd2.c
@@ -0,0 +1,59 @@
+/*
+ * Interface between ext4 and JBD
+ */
+
+#include <linux/ext4_jbd2.h>
+
+int __ext4_journal_get_undo_access(const char *where, handle_t *handle,
+				struct buffer_head *bh)
+{
+	int err = jbd2_journal_get_undo_access(handle, bh);
+	if (err)
+		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
+	return err;
+}
+
+int __ext4_journal_get_write_access(const char *where, handle_t *handle,
+				struct buffer_head *bh)
+{
+	int err = jbd2_journal_get_write_access(handle, bh);
+	if (err)
+		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
+	return err;
+}
+
+int __ext4_journal_forget(const char *where, handle_t *handle,
+				struct buffer_head *bh)
+{
+	int err = jbd2_journal_forget(handle, bh);
+	if (err)
+		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
+	return err;
+}
+
+int __ext4_journal_revoke(const char *where, handle_t *handle,
+				ext4_fsblk_t blocknr, struct buffer_head *bh)
+{
+	int err = jbd2_journal_revoke(handle, blocknr, bh);
+	if (err)
+		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
+	return err;
+}
+
+int __ext4_journal_get_create_access(const char *where,
+				handle_t *handle, struct buffer_head *bh)
+{
+	int err = jbd2_journal_get_create_access(handle, bh);
+	if (err)
+		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
+	return err;
+}
+
+int __ext4_journal_dirty_metadata(const char *where,
+				handle_t *handle, struct buffer_head *bh)
+{
+	int err = jbd2_journal_dirty_metadata(handle, bh);
+	if (err)
+		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
+	return err;
+}
diff -puN include/linux/ext4_jbd2.h~ext4-uninline-large-functions include/linux/ext4_jbd2.h
--- a/include/linux/ext4_jbd2.h~ext4-uninline-large-functions
+++ a/include/linux/ext4_jbd2.h
@@ -114,74 +114,32 @@ int ext4_mark_inode_dirty(handle_t *hand
  * been done yet.
  */
 
-void ext4_journal_abort_handle(const char *caller, const char *err_fn,
-		struct buffer_head *bh, handle_t *handle, int err);
-
-static inline int
-__ext4_journal_get_undo_access(const char *where, handle_t *handle,
-				struct buffer_head *bh)
+static inline void ext4_journal_release_buffer(handle_t *handle,
+						struct buffer_head *bh)
 {
-	int err = jbd2_journal_get_undo_access(handle, bh);
-	if (err)
-		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
-	return err;
+	jbd2_journal_release_buffer(handle, bh);
 }
 
-static inline int
-__ext4_journal_get_write_access(const char *where, handle_t *handle,
-				struct buffer_head *bh)
-{
-	int err = jbd2_journal_get_write_access(handle, bh);
-	if (err)
-		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
-	return err;
-}
+void ext4_journal_abort_handle(const char *caller, const char *err_fn,
+		struct buffer_head *bh, handle_t *handle, int err);
 
-static inline void
-ext4_journal_release_buffer(handle_t *handle, struct buffer_head *bh)
-{
-	jbd2_journal_release_buffer(handle, bh);
-}
+int __ext4_journal_get_undo_access(const char *where, handle_t *handle,
+				struct buffer_head *bh);
 
-static inline int
-__ext4_journal_forget(const char *where, handle_t *handle, struct buffer_head *bh)
-{
-	int err = jbd2_journal_forget(handle, bh);
-	if (err)
-		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
-	return err;
-}
+int __ext4_journal_get_write_access(const char *where, handle_t *handle,
+				struct buffer_head *bh);
 
-static inline int
-__ext4_journal_revoke(const char *where, handle_t *handle,
-		      ext4_fsblk_t blocknr, struct buffer_head *bh)
-{
-	int err = jbd2_journal_revoke(handle, blocknr, bh);
-	if (err)
-		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
-	return err;
-}
+int __ext4_journal_forget(const char *where, handle_t *handle,
+				struct buffer_head *bh);
 
-static inline int
-__ext4_journal_get_create_access(const char *where,
-				 handle_t *handle, struct buffer_head *bh)
-{
-	int err = jbd2_journal_get_create_access(handle, bh);
-	if (err)
-		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
-	return err;
-}
+int __ext4_journal_revoke(const char *where, handle_t *handle,
+				ext4_fsblk_t blocknr, struct buffer_head *bh);
 
-static inline int
-__ext4_journal_dirty_metadata(const char *where,
-			      handle_t *handle, struct buffer_head *bh)
-{
-	int err = jbd2_journal_dirty_metadata(handle, bh);
-	if (err)
-		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
-	return err;
-}
+int __ext4_journal_get_create_access(const char *where,
+				handle_t *handle, struct buffer_head *bh);
 
+int __ext4_journal_dirty_metadata(const char *where,
+				handle_t *handle, struct buffer_head *bh);
 
 #define ext4_journal_get_undo_access(handle, bh) \
 	__ext4_journal_get_undo_access(__FUNCTION__, (handle), (bh))
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
md-check-bio-address-after-mapping-through-partitions-tidy.patch
printk-timed-ratelimit.patch
schedule-removal-of-futex_fd.patch
acpi_noirq-section-fix.patch
spi-section-fix.patch
revert-pci-i386-x86_84-disable-pci-resource-decode-on-device-disable.patch
revert-pci-quirk-for-ibm-dock-ii-cardbus-controllers.patch
revert-generic_file_buffered_write-handle-zero-length-iovec-segments.patch
revert-generic_file_buffered_write-deadlock-on-vectored-write.patch
generic_file_buffered_write-cleanup.patch
mm-fix-pagecache-write-deadlocks.patch
fs-prepare_write-fixes-fuse-fix.patch
fs-prepare_write-fixes-fat-fix.patch
git-acpi.patch
acpi-asus-s3-resume-fix.patch
sony_apci-resume.patch
hdspm-printk-warning-fix.patch
git-cpufreq-prep.patch
git-cpufreq.patch
nozomi-warning-fixes.patch
nozomi-irq-flags-fixes.patch
update-uio_interrupt.patch
git-dvb.patch
git-ia64.patch
git-input.patch
git-input-fixup.patch
git-libata-all.patch
via-pata-controller-xfer-fixes-fix.patch
git-mtd.patch
git-netdev-all.patch
libphy-dont-do-that.patch
git-net-configh-got-removed.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
netxen-build-fix.patch
netxen-more-build-fixes.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
net-uninline-xfrm_selector_match.patch
ioat-warning-fix.patch
revert-scsi-ips-soft-lockup-during-reset-initialization.patch
scsi-ips-soft-lockup-during-reset-initialization-2.patch
git-watchdog.patch
revert-x86_64-mm-cpa-clflush.patch
prep-for-paravirt-be-careful-about-touching-bios-warning-fix.patch
prep-for-paravirt-desch-clearer-parameter-names-fix.patch
xfs-rename-uio_read.patch
touchkit-ps-2-touchscreen-driver.patch
get-rid-of-zone_table.patch
new-scheme-to-preempt-swap-token-tidy.patch
balance_pdgat-cleanup.patch
vmalloc-optimization-cleanup-bugfixes-tweak.patch
radix-tree-rcu-lockless-readside.patch
acx1xx-wireless-driver.patch
swsusp-add-resume_offset-command-line-parameter-rev-2.patch
add-include-linux-freezerh-and-move-definitions-from-ueagle-fix.patch
deprecate-smbfs-in-favour-of-cifs.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
kbuild-dont-put-temp-files-in-the-source-tree.patch
lockdep-annotate-nfs-nfsd-in-kernel-sockets-tidy.patch
drivers-add-lcd-support-3-Kconfig-fix.patch
setup_irq-better-mismatch-debugging.patch
probe_kernel_address-needs-to-do-set_fs.patch
slab-use-probe_kernel_address.patch
lockdep-spin_lock_irqsave_nested-fix.patch
lockdep-spin_lock_irqsave_nested-fix-2.patch
aio-use-prepare_to_wait.patch
exar-quad-port-serial-fix.patch
vfs_getattr-remove-dead-code.patch
ext3-uninline-large-functions.patch
ext4-uninline-large-functions.patch
pktcdvd-bio-write-congestion-using-blk_congestion_wait-fix.patch
bug-test-1.patch
fsstack-introduce-fsstack_copy_attrinode_-tidy.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel-fix.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel-vs-git-cryptodev.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel-ppc-fix.patch
add-process_session-helper-routine-deprecate-old-field-tidy.patch
add-process_session-helper-routine-deprecate-old-field-fix-warnings.patch
add-process_session-helper-routine-deprecate-old-field-fix-warnings-2.patch
fs-cache-provide-a-filesystem-specific-syncable-page-bit-ext4.patch
fs-cache-make-kafs-use-fs-cache-fix.patch
fs-cache-make-kafs-use-fs-cache-vs-streamline-generic_file_-interfaces-and-filemap.patch
nfs-use-local-caching-12-fix.patch
fs-cache-cachefiles-a-cache-that-backs-onto-a-mounted-filesystem-log2-fix.patch
mxser-session-warning-fix.patch
tty-switch-to-ktermios-and-new-framework-warning-fix.patch
tty-switch-to-ktermios-bluetooth-fix.patch
drivers-isdn-handcrafted-min-max-macro-removal-fix.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
readahead-sysctl-parameters.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
resier4-add-include-linux-freezerh-and-move-definitions-from.patch
make-kmem_cache_destroy-return-void-reiser4.patch
reiser4-hardirq-include-fix.patch
reiser4-run-truncate_inode_pages-in-reiser4_delete_inode.patch
reiser4-get_sb_dev-fix.patch
reiser4-vs-zoned-allocator.patch
hpt3xx-rework-rate-filtering-tidy.patch
various-fbdev-files-mark-structs-fix.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
gtod-persistent-clock-support-i386.patch
hrtimers-state-tracking.patch
clockevents-drivers-for-i386.patch
gtod-mark-tsc-unusable-for-highres-timers.patch
round_jiffies-infrastructure-fix.patch
kevent-core-files-fix.patch
kevent-core-files-s390-hack.patch
kevent-socket-notifications-fix-2.patch
kevent-socket-notifications-fix-4.patch
kevent-timer-notifications-fix.patch
kevent_user_wait-retval-fix.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
x86-kmap_atomic-debugging.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
acpi_format_exception-debug.patch
jmicron-warning-fix.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch
