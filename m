From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 43/52] percpu_counter: new function percpu_counter_sum_and_set
Date: Sat,  5 Jul 2008 13:36:09 -0400
Message-ID: <1215279378-30504-44-git-send-email-tytso@mit.edu>
References: <1215279378-30504-1-git-send-email-tytso@mit.edu>
 <1215279378-30504-2-git-send-email-tytso@mit.edu>
 <1215279378-30504-3-git-send-email-tytso@mit.edu>
 <1215279378-30504-4-git-send-email-tytso@mit.edu>
 <1215279378-30504-5-git-send-email-tytso@mit.edu>
 <1215279378-30504-6-git-send-email-tytso@mit.edu>
 <1215279378-30504-7-git-send-email-tytso@mit.edu>
 <1215279378-30504-8-git-send-email-tytso@mit.edu>
 <1215279378-30504-9-git-send-email-tytso@mit.edu>
 <1215279378-30504-10-git-send-email-tytso@mit.edu>
 <1215279378-30504-11-git-send-email-tytso@mit.edu>
 <1215279378-30504-12-git-send-email-tytso@mit.edu>
 <1215279378-30504-13-git-send-email-tytso@mit.edu>
 <1215279378-30504-14-git-send-email-tytso@mit.edu>
 <1215279378-30504-15-git-send-email-tytso@mit.edu>
 <1215279378-30504-16-git-send-email-tytso@mit.edu>
 <1215279378-30504-17-git-send-email-tytso@mit.edu>
 <1215279378-30504-18-git-send-email-tytso@mit.edu>
 <1215279378-30504-19-git-send-email-tytso@mit.edu>
 <1215279378-30504-20-git-send-email-tytso@mit.edu>
 <1215279378-30504-21-git-send-email-tytso@mit.edu>
 <1215279378-30504-22-git-send-email-tytso@mit.edu>
 <1215279378-30504-23-git-send-email-tytso@mit.edu>
 <1215279378-30504-24-git-send-email-tytso@mit.edu>
 <1215279378-30504-25-git-send-email-tytso@mit.edu>
 <1215279378-30504-26-git-send-email-tytso@mit.edu>
 <1215279378-30504-27-git-send-email-tytso@mit.edu>
 <1215279378-30504-28-git-send-email-tytso@mit.edu>
 <1215279378-30504-29-git-send-email-tytso@mit.edu>
 <1215279378-30504-30-git-send-email-tytso@mit.edu>
 <1215279378-30504-31-git-send-email-tytso@mit.edu>
 <1215279378-30504-32-git-send-email-tytso@mit.edu>
 <1215279378-30504-33-git-send-email-tytso@mit.edu>
 <1215279378-30504-34-git-send-email-tytso@mit.edu>
 <1215279378-30504-35-git-send-email-tytso@mit.edu>
 <1215279378-30504-36-git-send-email-tytso@mit.edu>
 <1215279378-30504-37-git-send-email-tytso@mit.edu>
 <1215279378-30504-38-git-send-email-tytso@mit.edu>
 <1215279378-30504-39-git-send-email-tytso@mit.edu>
 <1215279378-30504-40-git-send-email-tytso@mit.edu>
 <1215279378-30504-41-git-send-email-tytso@mit.edu>
 <1215279378-30504-42-git-send-email-tytso@mit.edu>
 <1215279378-30504-43-git-send-email-tytso@mit.edu>
Cc: Mingming Cao <cmm@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33034 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754382AbYGERg3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Jul 2008 13:36:29 -0400
In-Reply-To: <1215279378-30504-43-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Mingming Cao <cmm@us.ibm.com>

Delayed allocation need to check free blocks at every write time.
percpu_counter_read_positive() is not quit accurate. delayed
allocation need a more accurate accounting, but using
percpu_counter_sum_positive() is frequently is quite expensive.

This patch added a new function to update center counter when sum
per-cpu counter, to increase the accurate rate for next
percpu_counter_read() and require less calling expensive
percpu_counter_sum().

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/balloc.c               |    2 +-
 include/linux/percpu_counter.h |   12 +++++++++---
 lib/percpu_counter.c           |    7 ++++++-
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 25f63d8..6369bac 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -1621,7 +1621,7 @@ ext4_fsblk_t ext4_has_free_blocks(struct ext4_sb_info *sbi,
 #ifdef CONFIG_SMP
 	if (free_blocks - root_blocks < FBC_BATCH)
 		free_blocks =
-			percpu_counter_sum_positive(&sbi->s_freeblocks_counter);
+			percpu_counter_sum_and_set(&sbi->s_freeblocks_counter);
 #endif
 	if (free_blocks - root_blocks < nblocks)
 		return free_blocks - root_blocks;
diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
index 9007ccd..2083888 100644
--- a/include/linux/percpu_counter.h
+++ b/include/linux/percpu_counter.h
@@ -35,7 +35,7 @@ int percpu_counter_init_irq(struct percpu_counter *fbc, s64 amount);
 void percpu_counter_destroy(struct percpu_counter *fbc);
 void percpu_counter_set(struct percpu_counter *fbc, s64 amount);
 void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch);
-s64 __percpu_counter_sum(struct percpu_counter *fbc);
+s64 __percpu_counter_sum(struct percpu_counter *fbc, int set);
 
 static inline void percpu_counter_add(struct percpu_counter *fbc, s64 amount)
 {
@@ -44,13 +44,19 @@ static inline void percpu_counter_add(struct percpu_counter *fbc, s64 amount)
 
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
diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index 1191744..4a8ba4b 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -52,7 +52,7 @@ EXPORT_SYMBOL(__percpu_counter_add);
  * Add up all the per-cpu counts, return the result.  This is a more accurate
  * but much slower version of percpu_counter_read_positive()
  */
-s64 __percpu_counter_sum(struct percpu_counter *fbc)
+s64 __percpu_counter_sum(struct percpu_counter *fbc, int set)
 {
 	s64 ret;
 	int cpu;
@@ -62,7 +62,12 @@ s64 __percpu_counter_sum(struct percpu_counter *fbc)
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
-- 
1.5.6.rc3.1.g36b7.dirty

