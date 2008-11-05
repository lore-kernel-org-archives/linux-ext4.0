From: akpm@linux-foundation.org
Subject: + quota-add-reservation-support-for-delayed-block-allocation-checkpatch-fixes.patch added to -mm tree
Date: Tue, 04 Nov 2008 17:33:39 -0800
Message-ID: <200811050133.mA51XdGK018615@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, cmm@us.ibm.com, jack@ucw.cz,
	linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     quota-add-reservation-support-for-delayed-block-allocation-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     quota-add-reservation-support-for-delayed-block-allocation-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quota-add-reservation-support-for-delayed-block-allocation-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#193: FILE: fs/dquot.c:1279:
+         * re-enter the quota code and are already holding the mutex$

ERROR: code indent should use tabs where possible
#194: FILE: fs/dquot.c:1280:
+         */$

WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
#254: FILE: fs/dquot.c:2352:
+EXPORT_SYMBOL(dquot_reserve_space);

WARNING: line over 80 characters
#274: FILE: include/linux/quota.h:295:
+	int (*reserve_space) (struct inode *, qsize_t, int); /* reserve quota for delayed block allocation */

total: 2 errors, 2 warnings, 244 lines checked

./patches/quota-add-reservation-support-for-delayed-block-allocation.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: <linux-ext4@vger.kernel.org>
Cc: Jan Kara <jack@ucw.cz>
Cc: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dquot.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/dquot.c~quota-add-reservation-support-for-delayed-block-allocation-checkpatch-fixes fs/dquot.c
--- a/fs/dquot.c~quota-add-reservation-support-for-delayed-block-allocation-checkpatch-fixes
+++ a/fs/dquot.c
@@ -1276,8 +1276,8 @@ int dquot_alloc_space(struct inode *inod
 
 	/*
 	 * First test before acquiring mutex - solves deadlocks when we
-         * re-enter the quota code and are already holding the mutex
-         */
+	 * re-enter the quota code and are already holding the mutex
+	 */
 	if (IS_NOQUOTA(inode)) {
 		inode_add_bytes(inode, number);
 		return ret;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

autofs4-collect-version-check-return-checkpatch-fixes.patch
maintainers-make-ioat-easier-to-find.patch
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
scsi-dpt_i2o-is-bust-on-ia64.patch
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
quota-add-reservation-support-for-delayed-block-allocation-checkpatch-fixes.patch
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

