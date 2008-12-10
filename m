From: akpm@linux-foundation.org
Subject: - revert-percpu-counter-clean-up-percpu_counter_sum_and_set.patch removed from -mm tree
Date: Wed, 10 Dec 2008 11:28:44 -0800
Message-ID: <200812101928.mBAJSi3P021352@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, cmm@us.ibm.com,
	dada1@cosmosbay.com, davem@davemloft.net,
	linux-ext4@vger.kernel.org, mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     revert "percpu counter: clean up percpu_counter_sum_and_set()"
has been removed from the -mm tree.  Its filename was
     revert-percpu-counter-clean-up-percpu_counter_sum_and_set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: revert "percpu counter: clean up percpu_counter_sum_and_set()"
From: Andrew Morton <akpm@linux-foundation.org>

Revert

    commit 1f7c14c62ce63805f9574664a6c6de3633d4a354
    Author: Mingming Cao <cmm@us.ibm.com>
    Date:   Thu Oct 9 12:50:59 2008 -0400

        percpu counter: clean up percpu_counter_sum_and_set()

Before this patch we had the following:

percpu_counter_sum(): return the percpu_counter's value

percpu_counter_sum_and_set(): return the percpu_counter's value, copying
that value into the central value and zeroing the per-cpu counters before
returning.

After this patch, percpu_counter_sum_and_set() has gone, and
percpu_counter_sum() gets the old percpu_counter_sum_and_set()
functionality.

Problem is, as Eric points out, the old percpu_counter_sum_and_set()
functionality was racy and wrong.  It zeroes out counters on "other" cpus,
without holding any locks which will prevent races agaist updates from
those other CPUS.

This patch reverts 1f7c14c62ce63805f9574664a6c6de3633d4a354.  This means
that percpu_counter_sum_and_set() still has the race, but
percpu_counter_sum() does not.

Note that this is not a simple revert - ext4 has since started using
percpu_counter_sum() for its dirty_blocks counter as well.


Note that this revert patch changes percpu_counter_sum() semantics. 

Before the patch, a call to percpu_counter_sum() will bring the counter's
central counter mostly up-to-date, so a following percpu_counter_read()
will return a close value.

After this patch, a call to percpu_counter_sum() will leave the counter's
central accumulator unaltered, so a subsequent call to
percpu_counter_read() can now return a significantly inaccurate result.

If there is any code in the tree which was introduced after
e8ced39d5e8911c662d4d69a342b9d053eaaac4e was merged, and which depends
upon the new percpu_counter_sum() semantics, that code will break.


Reported-by: Eric Dumazet <dada1@cosmosbay.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mingming Cao <cmm@us.ibm.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/balloc.c               |    4 ++--
 include/linux/percpu_counter.h |   12 +++++++++---
 lib/percpu_counter.c           |    8 +++++---
 3 files changed, 16 insertions(+), 8 deletions(-)

diff -puN fs/ext4/balloc.c~revert-percpu-counter-clean-up-percpu_counter_sum_and_set fs/ext4/balloc.c
--- a/fs/ext4/balloc.c~revert-percpu-counter-clean-up-percpu_counter_sum_and_set
+++ a/fs/ext4/balloc.c
@@ -609,8 +609,8 @@ int ext4_has_free_blocks(struct ext4_sb_
 
 	if (free_blocks - (nblocks + root_blocks + dirty_blocks) <
 						EXT4_FREEBLOCKS_WATERMARK) {
-		free_blocks  = percpu_counter_sum(fbc);
-		dirty_blocks = percpu_counter_sum(dbc);
+		free_blocks  = percpu_counter_sum_and_set(fbc);
+		dirty_blocks = percpu_counter_sum_and_set(dbc);
 		if (dirty_blocks < 0) {
 			printk(KERN_CRIT "Dirty block accounting "
 					"went wrong %lld\n",
diff -puN include/linux/percpu_counter.h~revert-percpu-counter-clean-up-percpu_counter_sum_and_set include/linux/percpu_counter.h
--- a/include/linux/percpu_counter.h~revert-percpu-counter-clean-up-percpu_counter_sum_and_set
+++ a/include/linux/percpu_counter.h
@@ -35,7 +35,7 @@ int percpu_counter_init_irq(struct percp
 void percpu_counter_destroy(struct percpu_counter *fbc);
 void percpu_counter_set(struct percpu_counter *fbc, s64 amount);
 void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch);
-s64 __percpu_counter_sum(struct percpu_counter *fbc);
+s64 __percpu_counter_sum(struct percpu_counter *fbc, int set);
 
 static inline void percpu_counter_add(struct percpu_counter *fbc, s64 amount)
 {
@@ -44,13 +44,19 @@ static inline void percpu_counter_add(st
 
 static inline s64 percpu_counter_sum_positive(struct percpu_counter *fbc)
 {
-	s64 ret = __percpu_counter_sum(fbc);
+	s64 ret = __percpu_counter_sum(fbc, 0);
 	return ret < 0 ? 0 : ret;
 }
 
+static inline s64 percpu_counter_sum_and_set(struct percpu_counter *fbc)
+{
+	return __percpu_counter_sum(fbc, 1);
+}
+
+
 static inline s64 percpu_counter_sum(struct percpu_counter *fbc)
 {
-	return __percpu_counter_sum(fbc);
+	return __percpu_counter_sum(fbc, 0);
 }
 
 static inline s64 percpu_counter_read(struct percpu_counter *fbc)
diff -puN lib/percpu_counter.c~revert-percpu-counter-clean-up-percpu_counter_sum_and_set lib/percpu_counter.c
--- a/lib/percpu_counter.c~revert-percpu-counter-clean-up-percpu_counter_sum_and_set
+++ a/lib/percpu_counter.c
@@ -52,7 +52,7 @@ EXPORT_SYMBOL(__percpu_counter_add);
  * Add up all the per-cpu counts, return the result.  This is a more accurate
  * but much slower version of percpu_counter_read_positive()
  */
-s64 __percpu_counter_sum(struct percpu_counter *fbc)
+s64 __percpu_counter_sum(struct percpu_counter *fbc, int set)
 {
 	s64 ret;
 	int cpu;
@@ -62,9 +62,11 @@ s64 __percpu_counter_sum(struct percpu_c
 	for_each_online_cpu(cpu) {
 		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
 		ret += *pcount;
-		*pcount = 0;
+		if (set)
+			*pcount = 0;
 	}
-	fbc->count = ret;
+	if (set)
+		fbc->count = ret;
 
 	spin_unlock(&fbc->lock);
 	return ret;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-remove-the-might_sleep-from-lock_page.patch
make-linx-next-apply.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
linux-timexh-cleanup-for-userspace.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
pci-uninline-pci_ioremap_bar.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-more-terminate-quickly.patch
swapfile-change-discard-pgoff_t-to-sector_t-fix.patch
fs-truncate-blocks-outside-i_size-after-o_direct-write-error-fix.patch
vmscan-shrink_active_list-reduce-lru_lock-hold-time.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-mmapc-fix-coding-style-fix.patch
init-properly-placing-noinline-keyword.patch
add-pr_prefix-to-pr_xyz-macros-checkpatch-fixes.patch
poll-allow-f_op-poll-to-sleep-take6.patch
binfmtsh-include-listh-fix.patch
max3100-spi-uart-driver-select-serial_core-fix.patch
spi_gpio-driver-cleanups.patch
kprobes-support-probing-module-__exit-function-fix.patch
kprobes-support-probing-module-__exit-function-fix-2.patch
nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0-checkpatch-fixes.patch
nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0-checkpatch-fixes-checkpatch-fixes.patch
rtc-au1000-on-chip-counter0-as-rtc-driver-fix.patch
cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup-checkpatch-fixes.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes.patch
edac-x38-use-the-architectures-readq-function-fix.patch
edac-x38-use-the-architectures-readq-function-fix-fix.patch
parport-ieee1284-use-del_timer_sync-in-parport_wait_event-checkpatch-fixes.patch
romfs-romfs_iget-unsigned-ino-=-0-is-always-true-checkpatch-fixes.patch
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
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

