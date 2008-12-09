From: akpm@linux-foundation.org
Subject: [patch 07/19] revert "percpu_counter: new function percpu_counter_sum_and_set"
Date: Tue, 09 Dec 2008 13:14:14 -0800
Message-ID: <200812092114.mB9LEFOe027046@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, cmm@us.ibm.com,
	dada1@cosmosbay.com, davem@davemloft.net,
	linux-ext4@vger.kernel.org, stable@kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58972 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754129AbYLIVOf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Dec 2008 16:14:35 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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
