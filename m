From: Mingming Cao <cmm@us.ibm.com>
Subject: [RFC][PATCH 6/6] delalloc ENOSPC: improve percpu counter
	accounting accurate
Date: Sun, 01 Jun 2008 16:36:25 -0700
Message-ID: <1212363385.4368.69.camel@localhost.localdomain>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:43910 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbYFAXgc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Jun 2008 19:36:32 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m51NaVVE014532
	for <linux-ext4@vger.kernel.org>; Sun, 1 Jun 2008 19:36:31 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m51NaVpP089748
	for <linux-ext4@vger.kernel.org>; Sun, 1 Jun 2008 17:36:31 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m51NaUb8005415
	for <linux-ext4@vger.kernel.org>; Sun, 1 Jun 2008 17:36:31 -0600
Received: from [9.67.174.55] (wecm-9-67-174-55.wecm.ibm.com [9.67.174.55])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id m51NaTQU005390
	for <linux-ext4@vger.kernel.org>; Sun, 1 Jun 2008 17:36:30 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

percpu counter: update center counter when sum per-cpu counter

From: Mingming cao <cmm@us.ibm.com>

Delayed allocation need to check free blocks at every write time.
percpu_counter_read_positive() is not quit accurate
 but using percpu_counter_sum_positive() for every write
frequently is quite expensive.

This patch added a new function to update center counter when
sum up per-cpu counters, to increase the accurate rate
for next percpu_counter_read()(which reads only the center counter
and require less calling expensive percpu_counter_sum().(in
ext4_has_free_blocks)

Signed-off-by: Mingming cao <cmm@us.ibm.com>

---
 fs/ext4/balloc.c               |    2 +-
 include/linux/percpu_counter.h |   12 +++++++++---
 lib/percpu_counter.c           |    7 ++++++-
 3 files changed, 16 insertions(+), 5 deletions(-)

Index: linux-2.6.26-rc4/include/linux/percpu_counter.h
===================================================================
--- linux-2.6.26-rc4.orig/include/linux/percpu_counter.h	2008-06-01 15:33:09.000000000 -0700
+++ linux-2.6.26-rc4/include/linux/percpu_counter.h	2008-06-01 15:33:14.000000000 -0700
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
Index: linux-2.6.26-rc4/lib/percpu_counter.c
===================================================================
--- linux-2.6.26-rc4.orig/lib/percpu_counter.c	2008-06-01 15:33:09.000000000 -0700
+++ linux-2.6.26-rc4/lib/percpu_counter.c	2008-06-01 15:33:14.000000000 -0700
@@ -52,7 +52,7 @@ EXPORT_SYMBOL(__percpu_counter_add);
  * Add up all the per-cpu counts, return the result.  This is a more accurate
  * but much slower version of percpu_counter_read_positive()
  */
-s64 __percpu_counter_sum(struct percpu_counter *fbc)
+s64 __percpu_counter_sum(struct percpu_counter *fbc, int set)
 {
 	s64 ret;
 	int cpu;
@@ -62,7 +62,12 @@ s64 __percpu_counter_sum(struct percpu_c
 	for_each_online_cpu(cpu) {
 		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
 		ret += *pcount;
+		if (set)
+			*pcount = 0;
 	}
+	if (set)
+		fbc->count = ret;
+
 	spin_unlock(&fbc->lock);
 	return ret;
 }
Index: linux-2.6.26-rc4/fs/ext4/balloc.c
===================================================================
--- linux-2.6.26-rc4.orig/fs/ext4/balloc.c	2008-06-01 15:33:36.000000000 -0700
+++ linux-2.6.26-rc4/fs/ext4/balloc.c	2008-06-01 15:34:28.000000000 -0700
@@ -1626,7 +1626,7 @@ ext4_fsblk_t ext4_has_free_blocks(struct
 
 	if (free_blocks - root_blocks < FBC_BATCH)
 		free_blocks =
-			percpu_counter_sum_positive(&sbi->s_freeblocks_counter);
+		    percpu_counter_sum_positive_set(&sbi->s_freeblocks_counter);
 	if (free_blocks - root_blocks < nblocks )
 		return free_blocks -root_blocks;
 	return nblocks;



