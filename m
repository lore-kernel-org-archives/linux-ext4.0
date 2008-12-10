From: akpm@linux-foundation.org
Subject: - revert-percpu_counter-new-function-percpu_counter_sum_and_set.patch removed from -mm tree
Date: Wed, 10 Dec 2008 11:28:47 -0800
Message-ID: <200812101928.mBAJSlRM021381@imap1.linux-foundation.org>
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, cmm@us.ibm.com,
	dada1@cosmosbay.com, davem@davemloft.net,
	linux-ext4@vger.kernel.org, stable@kernel.org,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45908 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755451AbYLJT3v (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Dec 2008 14:29:51 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     revert "percpu_counter: new function percpu_counter_sum_and_set"
has been removed from the -mm tree.  Its filename was
     revert-percpu_counter-new-function-percpu_counter_sum_and_set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: revert "percpu_counter: new function percpu_counter_sum_and_set"
From: Andrew Morton <akpm@linux-foundation.org>

Revert

    commit e8ced39d5e8911c662d4d69a342b9d053eaaac4e
    Author: Mingming Cao <cmm@us.ibm.com>
    Date:   Fri Jul 11 19:27:31 2008 -0400

        percpu_counter: new function percpu_counter_sum_and_set


As described in

	revert "percpu counter: clean up percpu_counter_sum_and_set()"

the new percpu_counter_sum_and_set() is racy against updates to the
cpu-local accumulators on other CPUs.  Revert that change.

This means that ext4 will be slow again.  But correct.

Reported-by: Eric Dumazet <dada1@cosmosbay.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mingming Cao <cmm@us.ibm.com>
Cc: <linux-ext4@vger.kernel.org>
Cc: <stable@kernel.org>		[2.6.27.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/balloc.c               |    4 ++--
 include/linux/percpu_counter.h |   12 +++---------
 lib/percpu_counter.c           |    7 +------
 3 files changed, 6 insertions(+), 17 deletions(-)

diff -puN fs/ext4/balloc.c~revert-percpu_counter-new-function-percpu_counter_sum_and_set fs/ext4/balloc.c
--- a/fs/ext4/balloc.c~revert-percpu_counter-new-function-percpu_counter_sum_and_set
+++ a/fs/ext4/balloc.c
@@ -609,8 +609,8 @@ int ext4_has_free_blocks(struct ext4_sb_
 
 	if (free_blocks - (nblocks + root_blocks + dirty_blocks) <
 						EXT4_FREEBLOCKS_WATERMARK) {
-		free_blocks  = percpu_counter_sum_and_set(fbc);
-		dirty_blocks = percpu_counter_sum_and_set(dbc);
+		free_blocks  = percpu_counter_sum_positive(fbc);
+		dirty_blocks = percpu_counter_sum_positive(dbc);
 		if (dirty_blocks < 0) {
 			printk(KERN_CRIT "Dirty block accounting "
 					"went wrong %lld\n",
diff -puN include/linux/percpu_counter.h~revert-percpu_counter-new-function-percpu_counter_sum_and_set include/linux/percpu_counter.h
--- a/include/linux/percpu_counter.h~revert-percpu_counter-new-function-percpu_counter_sum_and_set
+++ a/include/linux/percpu_counter.h
@@ -35,7 +35,7 @@ int percpu_counter_init_irq(struct percp
 void percpu_counter_destroy(struct percpu_counter *fbc);
 void percpu_counter_set(struct percpu_counter *fbc, s64 amount);
 void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch);
-s64 __percpu_counter_sum(struct percpu_counter *fbc, int set);
+s64 __percpu_counter_sum(struct percpu_counter *fbc);
 
 static inline void percpu_counter_add(struct percpu_counter *fbc, s64 amount)
 {
@@ -44,19 +44,13 @@ static inline void percpu_counter_add(st
 
 static inline s64 percpu_counter_sum_positive(struct percpu_counter *fbc)
 {
-	s64 ret = __percpu_counter_sum(fbc, 0);
+	s64 ret = __percpu_counter_sum(fbc);
 	return ret < 0 ? 0 : ret;
 }
 
-static inline s64 percpu_counter_sum_and_set(struct percpu_counter *fbc)
-{
-	return __percpu_counter_sum(fbc, 1);
-}
-
-
 static inline s64 percpu_counter_sum(struct percpu_counter *fbc)
 {
-	return __percpu_counter_sum(fbc, 0);
+	return __percpu_counter_sum(fbc);
 }
 
 static inline s64 percpu_counter_read(struct percpu_counter *fbc)
diff -puN lib/percpu_counter.c~revert-percpu_counter-new-function-percpu_counter_sum_and_set lib/percpu_counter.c
--- a/lib/percpu_counter.c~revert-percpu_counter-new-function-percpu_counter_sum_and_set
+++ a/lib/percpu_counter.c
@@ -52,7 +52,7 @@ EXPORT_SYMBOL(__percpu_counter_add);
  * Add up all the per-cpu counts, return the result.  This is a more accurate
  * but much slower version of percpu_counter_read_positive()
  */
-s64 __percpu_counter_sum(struct percpu_counter *fbc, int set)
+s64 __percpu_counter_sum(struct percpu_counter *fbc)
 {
 	s64 ret;
 	int cpu;
@@ -62,12 +62,7 @@ s64 __percpu_counter_sum(struct percpu_c
 	for_each_online_cpu(cpu) {
 		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
 		ret += *pcount;
-		if (set)
-			*pcount = 0;
 	}
-	if (set)
-		fbc->count = ret;
-
 	spin_unlock(&fbc->lock);
 	return ret;
 }
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

