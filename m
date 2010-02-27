From: "Jayson R. King" <dev@jaysonking.com>
Subject: [02/11] percpu counter: clean up percpu_counter_sum_and_set()
Date: Sat, 27 Feb 2010 00:32:19 -0600
Message-ID: <4B88BC73.8030900@jaysonking.com>
References: <4B88BA1B.4050500@jaysonking.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Mingming Cao <cmm@us.ibm.com>, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Jayson King <dev@jaysonking.com>
To: LKML <linux-kernel@vger.kernel.org>,
	Stable team <stable@kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bosmailout01.eigbox.net ([66.96.188.1]:38433 "EHLO
	bosmailout01.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab0B0HV5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 27 Feb 2010 02:21:57 -0500
In-Reply-To: <4B88BA1B.4050500@jaysonking.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Mingming Cao <cmm@us.ibm.com>
Date: Thu Oct 9 12:50:59 2008 -0400
Subject: percpu counter: clean up percpu_counter_sum_and_set()

commit 1f7c14c62ce63805f9574664a6c6de3633d4a354 upstream.

percpu_counter_sum_and_set() and percpu_counter_sum() is the same except
the former updates the global counter after accounting.  Since we are
taking the fbc->lock to calculate the precise value of the counter in
percpu_counter_sum() anyway, it should simply set fbc->count too, as the
percpu_counter_sum_and_set() does.

This patch merges these two interfaces into one.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Jayson R. King <dev@jaysonking.com>

---
 fs/ext4/balloc.c               |    2 +-
 include/linux/percpu_counter.h |   12 +++---------
 lib/percpu_counter.c           |    8 +++-----
 3 files changed, 7 insertions(+), 15 deletions(-)

diff -urNp linux-2.6.27.orig/fs/ext4/balloc.c linux-2.6.27/fs/ext4/balloc.c
--- linux-2.6.27.orig/fs/ext4/balloc.c	2010-02-26 14:10:41.167252303 -0600
+++ linux-2.6.27/fs/ext4/balloc.c	2010-02-26 14:18:30.811252658 -0600
@@ -1778,7 +1778,7 @@ ext4_fsblk_t ext4_has_free_blocks(struct
 #ifdef CONFIG_SMP
 	if (free_blocks - root_blocks < FBC_BATCH)
 		free_blocks =
-			percpu_counter_sum_and_set(&sbi->s_freeblocks_counter);
+			percpu_counter_sum(&sbi->s_freeblocks_counter);
 #endif
 	if (free_blocks <= root_blocks)
 		/* we don't have free space */
diff -urNp linux-2.6.27.orig/include/linux/percpu_counter.h linux-2.6.27/include/linux/percpu_counter.h
--- linux-2.6.27.orig/include/linux/percpu_counter.h	2010-02-26 14:10:41.961252665 -0600
+++ linux-2.6.27/include/linux/percpu_counter.h	2010-02-26 14:18:30.811252658 -0600
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
diff -urNp linux-2.6.27.orig/lib/percpu_counter.c linux-2.6.27/lib/percpu_counter.c
--- linux-2.6.27.orig/lib/percpu_counter.c	2010-02-26 14:10:42.176252671 -0600
+++ linux-2.6.27/lib/percpu_counter.c	2010-02-26 14:18:30.811252658 -0600
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
