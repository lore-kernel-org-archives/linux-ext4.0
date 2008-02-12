From: akpm@linux-foundation.org
Subject: - xfs-convert-bex_add-to-bex_add_cpu-new-common-api-fix.patch removed from -mm tree
Date: Tue, 12 Feb 2008 14:30:49 -0800
Message-ID: <200802122230.m1CMUnu0025753@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: akpm@linux-foundation.org, dgc@sgi.com, linux-ext4@vger.kernel.org,
	marcin.slusarz@gmail.com, mark.fasheh@oracle.com, tes@sgi.com,
	mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     xfs-convert-bex_add-to-bex_add_cpu-new-common-api-fix
has been removed from the -mm tree.  Its filename was
     xfs-convert-bex_add-to-bex_add_cpu-new-common-api-fix.patch

This patch was dropped because it was folded into xfs-convert-bex_add-to-bex_add_cpu-new-common-api.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xfs-convert-bex_add-to-bex_add_cpu-new-common-api-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: <linux-ext4@vger.kernel.org>
Cc: David Chinner <dgc@sgi.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Timothy Shimmin <tes@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/xfs_log.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/xfs/xfs_log.c~xfs-convert-bex_add-to-bex_add_cpu-new-common-api-fix fs/xfs/xfs_log.c
--- a/fs/xfs/xfs_log.c~xfs-convert-bex_add-to-bex_add_cpu-new-common-api-fix
+++ a/fs/xfs/xfs_log.c
@@ -1490,9 +1490,9 @@ xlog_sync(xlog_t		*log,
 		 * case, though.
 		 */
 		for (i = 0; i < split; i += BBSIZE) {
-			be32_add((__be32 *)dptr, 1);
+			be32_add_cpu((__be32 *)dptr, 1);
 			if (be32_to_cpu(*(__be32 *)dptr) == XLOG_HEADER_MAGIC_NUM)
-				be32_add((__be32 *)dptr, 1);
+				be32_add_cpu((__be32 *)dptr, 1);
 			dptr += BBSIZE;
 		}
 
@@ -1581,7 +1581,7 @@ xlog_state_finish_copy(xlog_t		*log,
 {
 	spin_lock(&log->l_icloglock);
 
-	be32_add(&iclog->ic_header.h_num_logops, record_cnt);
+	be32_add_cpu(&iclog->ic_header.h_num_logops, record_cnt);
 	iclog->ic_offset += copy_bytes;
 
 	spin_unlock(&log->l_icloglock);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
softlockup-workaround.patch
revert-proc-fix-the-threaded-proc-self.patch
memstick-initial-commit-for-sony-memorystick-support.patch
include-linux-remove-all-users-of-fastcall-macro-checkpatch-fixes.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-audit-printk-warning-fix.patch
git-cifs.patch
revert-agk-dm-dm-loop.patch
drivers-pcmcia-i82092c-fix-up-after-pci_bus_region-changes.patch
git-drm.patch
drivers-media-video-em28xx-em28xx-corec-fix-use-of-potentially-uninitialized-variable.patch
adt7473-new-driver-for-analog-devices-adt7473-sensor-chip.patch
revert-git-hrt.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
git-kvm.patch
git-mmc.patch
typhoon-section-fix.patch
natsemi-section-fix.patch
bnx2x-section-fix.patch
bnx2c-section-fix.patch
via-velocity-section-fix.patch
starfire-secton-fix.patch
pppol2tp-fix-printk-warnings.patch
drivers-net-dm9000c-vague-probably-wrong-build-fix.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
cleanup-gregkh-pci-pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
git-sched.patch
git-sched-fix-git-conflicts.patch
git-sh.patch
git-scsi-misc.patch
scsi-aic94xx-cleanups.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
git-unionfs.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
usb-ohci-sm501-driver-v2-fix.patch
drivers-usb-serial-io_tic-remove-pointless-eye-candy-in-debug-statements.patch
git-watchdog.patch
git-watchdog-fixup.patch
git-x86.patch
git-x86-fix-git-conflicts.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
x86-amd-thermal-interrupt-support.patch
git-xfs-fix-git-conflicts.patch
git-xtensa.patch
mempolicy-silently-restrict-nodemask-to-allowed-nodes-v3-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
make-dev-kmem-a-config-option-fix.patch
rtc-add-support-for-the-s-35390a-rtc-chip-checkpatch-fixes.patch
kill-filp_open.patch
rename-open_namei-to-open_pathname.patch
rename-open_namei-to-open_pathname-vs-git-acpi.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls.patch
r-o-bind-mounts-elevate-write-count-opened-files.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
keep-track-of-mnt_writer-state-of-struct-file.patch
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
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
xfs-convert-bex_add-to-bex_add_cpu-new-common-api.patch
xfs-convert-bex_add-to-bex_add_cpu-new-common-api-fix.patch
procfs-task-exe-symlink-fix.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
w1-build-fix.patch
