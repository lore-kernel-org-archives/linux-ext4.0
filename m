From: akpm@linux-foundation.org
Subject: - quota-add-quota-claim-and-release-reserved-quota-blocks-operations-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 06 Nov 2008 15:51:19 -0800
Message-ID: <200811062351.mA6NpJwS030257@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: akpm@linux-foundation.org, cmm@us.ibm.com, jack@ucw.cz,
	linux-ext4@vger.kernel.org, mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     quota-add-quota-claim-and-release-reserved-quota-blocks-operations-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     quota-add-quota-claim-and-release-reserved-quota-blocks-operations-checkpatch-fixes.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quota-add-quota-claim-and-release-reserved-quota-blocks-operations-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#68: FILE: include/linux/quota.h:296:
+	int (*claim_space) (struct inode *, qsize_t); /* claim reserved quota for delayed block allocation */

WARNING: line over 80 characters
#69: FILE: include/linux/quota.h:297:
+	void (*release_rsv) (struct inode *, qsize_t); /* release reserved quota for delayed block allocation */

ERROR: space required before the open brace '{'
#98: FILE: include/linux/quotaops.h:209:
+	if (sb_any_quota_active(inode->i_sb)){

ERROR: else should follow close brace '}'
#102: FILE: include/linux/quotaops.h:213:
+	}
+	else

WARNING: line over 80 characters
#112: FILE: include/linux/quotaops.h:223:
+static inline void vfs_dq_release_reservation_space(struct inode *inode, qsize_t nr)

WARNING: line over 80 characters
#130: FILE: include/linux/quotaops.h:380:
+static inline int vfs_dq_release_reservation_space(struct inode *inode, qsize_t nr)

WARNING: line over 80 characters
#150: FILE: include/linux/quotaops.h:437:
+	vfs_dq_release_reservation_space(inode, nr << inode->i_sb->s_blocksize_bits);

WARNING: printk() should include KERN_ facility level
#180: FILE: fs/dquot.c:856:
+		printk("WARNING: reserved quota %llu is not enough for"

WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
#270: FILE: fs/dquot.c:2436:
+EXPORT_SYMBOL(dquot_claim_space);

WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
#271: FILE: fs/dquot.c:2437:
+EXPORT_SYMBOL(dquot_release_reserved_space);

total: 2 errors, 8 warnings, 194 lines checked

./patches/quota-add-quota-claim-and-release-reserved-quota-blocks-operations.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: <linux-ext4@vger.kernel.org>
Cc: Jan Kara <jack@ucw.cz>
Cc: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/quotaops.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN include/linux/quotaops.h~quota-add-quota-claim-and-release-reserved-quota-blocks-operations-checkpatch-fixes include/linux/quotaops.h
--- a/include/linux/quotaops.h~quota-add-quota-claim-and-release-reserved-quota-blocks-operations-checkpatch-fixes
+++ a/include/linux/quotaops.h
@@ -206,11 +206,10 @@ static inline int vfs_dq_alloc_inode(str
  */
 static inline int vfs_dq_claim_space(struct inode *inode, qsize_t nr)
 {
-	if (sb_any_quota_active(inode->i_sb)){
+	if (sb_any_quota_active(inode->i_sb)) {
 		if (inode->i_sb->dq_op->claim_space(inode, nr) == NO_QUOTA)
 			return 1;
-	}
-	else
+	} else
 		inode_add_bytes(inode, nr);
 
 	mark_inode_dirty(inode);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

autofs4-collect-version-check-return.patch
maintainers-make-ioat-easier-to-find.patch
binfmtsh-include-listh-fix.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
linux-timexh-cleanup-for-userspace.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
pci-uninline-pci_ioremap_bar.patch
pcie-add-option-to-passively-listen-for-pcie-hotplug-events-checkpatch-fixes.patch
cpusets-update-mems-allowed-in-page-allocator-fix.patch
bdi-register-sysfs-bdi-device-only-once-per-queue-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
alsa-fix-snd_bug_on-and-friends.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-more-terminate-quickly.patch
init-properly-placing-noinline-keyword.patch
spi_gpio-driver-cleanups.patch
rtc-rtc-wm8350-add-support-for-wm8350-rtc.patch
rtc-basic-implementation-of-epson-rx-8581-i2c-real-time-clock-fix.patch
quota-permit-separately-enabling-quota-accounting-and-enforcing-limits-fix.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix-2.patch
quota-convert-union-in-mem_dqinfo-to-a-pointer-cleanup.patch
quota-support-64-bit-quota-format-fix.patch
quota-support-64-bit-quota-format-fix-2.patch
quota-add-quota-claim-and-release-reserved-quota-blocks-operations-checkpatch-fixes.patch
ext4-quota-handling-for-delayed-allocation-checkpatch-fixes.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes.patch
w1-export-w1_read_8-function-checkpatch-fixes.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
reiser4-broke.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

