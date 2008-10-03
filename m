From: akpm@linux-foundation.org
Subject: - percpu-counters-clean-up-percpu_counter_sum_and_set-interface.patch removed from -mm tree
Date: Fri, 03 Oct 2008 14:29:15 -0700
Message-ID: <200810032129.m93LTFBU016677@imap1.linux-foundation.org>
To: cmm@us.ibm.com, a.p.zijlstra@chello.nl, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42392 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752834AbYJCVed (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Oct 2008 17:34:33 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     percpu-counters: clean up percpu_counter_sum_and_set() interface
has been removed from the -mm tree.  Its filename was
     percpu-counters-clean-up-percpu_counter_sum_and_set-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: percpu-counters: clean up percpu_counter_sum_and_set() interface
From: Mingming Cao <cmm@us.ibm.com>

percpu_counter_sum_and_set() and percpu_counter_sum() is the same except
the former update the global counter after accounting.  Since we are
taking the fbc->lock to calculate the precise value of the counter in
percpu_counter_sum() anyway, it should simply set fbc->count too, as the
percpu_counter_sum_and_set() dose.

This patch merges these two interfaces into one.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/balloc.c               |    2 +-
 include/linux/percpu_counter.h |   12 +++---------
 lib/percpu_counter.c           |    8 +++-----
 3 files changed, 7 insertions(+), 15 deletions(-)

diff -puN fs/ext4/balloc.c~percpu-counters-clean-up-percpu_counter_sum_and_set-interface fs/ext4/balloc.c
--- a/fs/ext4/balloc.c~percpu-counters-clean-up-percpu_counter_sum_and_set-interface
+++ a/fs/ext4/balloc.c
@@ -1624,7 +1624,7 @@ ext4_fsblk_t ext4_has_free_blocks(struct
 #ifdef CONFIG_SMP
 	if (free_blocks - root_blocks < FBC_BATCH)
 		free_blocks =
-			percpu_counter_sum_and_set(&sbi->s_freeblocks_counter);
+			percpu_counter_sum(&sbi->s_freeblocks_counter);
 #endif
 	if (free_blocks <= root_blocks)
 		/* we don't have free space */
diff -puN include/linux/percpu_counter.h~percpu-counters-clean-up-percpu_counter_sum_and_set-interface include/linux/percpu_counter.h
--- a/include/linux/percpu_counter.h~percpu-counters-clean-up-percpu_counter_sum_and_set-interface
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
diff -puN lib/percpu_counter.c~percpu-counters-clean-up-percpu_counter_sum_and_set-interface lib/percpu_counter.c
--- a/lib/percpu_counter.c~percpu-counters-clean-up-percpu_counter_sum_and_set-interface
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
@@ -62,11 +62,9 @@ s64 __percpu_counter_sum(struct percpu_c
 	for_each_online_cpu(cpu) {
 		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
 		ret += *pcount;
-		if (set)
-			*pcount = 0;
+		*pcount = 0;
 	}
-	if (set)
-		fbc->count = ret;
+	fbc->count = ret;
 
 	spin_unlock(&fbc->lock);
 	return ret;
_

Patches currently in -mm which might be from cmm@us.ibm.com are

git-ext4.patch
vmscan-set-try_to_release_pages-gfp_mask-to-0.patch
ext2-fix-ext2-block-reservation-early-enospc-issue.patch
ext3-fix-ext3-block-reservation-early-enospc-issue.patch

