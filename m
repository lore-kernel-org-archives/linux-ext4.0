From: Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH] clean up percpu_counter_sum_and_set() interface
Date: Wed, 20 Aug 2008 16:44:59 -0700
Message-ID: <1219275899.7895.58.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu
To: LKML <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:55260 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788AbYHTXpD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Aug 2008 19:45:03 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

percpu counter: clean up percpu_counter_sum_and_set() interface

From: Mingming Cao <cmm@us.ibm.com>

percpu_counter_sum_and_set() and percpu_counter_sum() is the same except
the former update the global counter after accounting.  Since we are
taking the fbc->lock to calculate the precise value of the
counter in percpu_counter_sum() anyway, it should simply set fbc->count
too, as the percpu_counter_sum_and_set() dose.

This patch merge these two interfaces into one.
 
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/balloc.c               |    2 +-
 include/linux/percpu_counter.h |   12 +++---------
 lib/percpu_counter.c           |    8 +++-----
 3 files changed, 7 insertions(+), 15 deletions(-)

Index: linux-2.6.27-rc3/fs/ext4/balloc.c
===================================================================
--- linux-2.6.27-rc3.orig/fs/ext4/balloc.c	2008-08-20 16:23:26.000000000 -0700
+++ linux-2.6.27-rc3/fs/ext4/balloc.c	2008-08-20 16:25:21.000000000 -0700
@@ -1624,7 +1624,7 @@
 #ifdef CONFIG_SMP
 	if (free_blocks - root_blocks < FBC_BATCH)
 		free_blocks =
-			percpu_counter_sum_and_set(&sbi->s_freeblocks_counter);
+			percpu_counter_sum(&sbi->s_freeblocks_counter);
 #endif
 	if (free_blocks <= root_blocks)
 		/* we don't have free space */
Index: linux-2.6.27-rc3/include/linux/percpu_counter.h
===================================================================
--- linux-2.6.27-rc3.orig/include/linux/percpu_counter.h	2008-08-20 16:23:51.000000000 -0700
+++ linux-2.6.27-rc3/include/linux/percpu_counter.h	2008-08-20 16:29:17.000000000 -0700
@@ -35,7 +35,7 @@
 void percpu_counter_destroy(struct percpu_counter *fbc);
 void percpu_counter_set(struct percpu_counter *fbc, s64 amount);
 void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch);
-s64 __percpu_counter_sum(struct percpu_counter *fbc, int set);
+s64 __percpu_counter_sum(struct percpu_counter *fbc);
 
 static inline void percpu_counter_add(struct percpu_counter *fbc, s64 amount)
 {
@@ -44,19 +44,13 @@
 
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
Index: linux-2.6.27-rc3/lib/percpu_counter.c
===================================================================
--- linux-2.6.27-rc3.orig/lib/percpu_counter.c	2008-08-20 16:24:50.000000000 -0700
+++ linux-2.6.27-rc3/lib/percpu_counter.c	2008-08-20 16:26:55.000000000 -0700
@@ -52,7 +52,7 @@
  * Add up all the per-cpu counts, return the result.  This is a more accurate
  * but much slower version of percpu_counter_read_positive()
  */
-s64 __percpu_counter_sum(struct percpu_counter *fbc, int set)
+s64 __percpu_counter_sum(struct percpu_counter *fbc)
 {
 	s64 ret;
 	int cpu;
@@ -62,11 +62,9 @@
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


