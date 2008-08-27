From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V3 01/11] percpu_counters: make fbc->count read atomic on 32 bit architecture
Date: Wed, 27 Aug 2008 20:58:26 +0530
Message-ID: <1219850916-8986-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757364AbYH0P3I@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

fbc->count is of type s64. The change was introduced by
0216bfcffe424a5473daa4da47440881b36c1f4 which changed the type
from long to s64. Moving to s64 also means on 32 bit architectures
we can get wrong values on fbc->count. Since fbc->count is read
more frequently and updated rarely use seqlocks. This should
reduce the impact of locking in the read path for 32bit arch.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
---
 include/linux/percpu_counter.h |   28 ++++++++++++++++++++++++----
 lib/percpu_counter.c           |   20 ++++++++++----------
 2 files changed, 34 insertions(+), 14 deletions(-)

diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
index 9007ccd..1b711a1 100644
--- a/include/linux/percpu_counter.h
+++ b/include/linux/percpu_counter.h
@@ -6,7 +6,7 @@
  * WARNING: these things are HUGE.  4 kbytes per counter on 32-way P4.
  */
 
-#include <linux/spinlock.h>
+#include <linux/seqlock.h>
 #include <linux/smp.h>
 #include <linux/list.h>
 #include <linux/threads.h>
@@ -16,7 +16,7 @@
 #ifdef CONFIG_SMP
 
 struct percpu_counter {
-	spinlock_t lock;
+	seqlock_t lock;
 	s64 count;
 #ifdef CONFIG_HOTPLUG_CPU
 	struct list_head list;	/* All percpu_counters are on a list */
@@ -53,10 +53,30 @@ static inline s64 percpu_counter_sum(struct percpu_counter *fbc)
 	return __percpu_counter_sum(fbc);
 }
 
-static inline s64 percpu_counter_read(struct percpu_counter *fbc)
+#if BITS_PER_LONG == 64
+static inline s64 fbc_count(struct percpu_counter *fbc)
 {
 	return fbc->count;
 }
+#else
+/* doesn't have atomic 64 bit operation */
+static inline s64 fbc_count(struct percpu_counter *fbc)
+{
+	s64 ret;
+	unsigned seq;
+	do {
+		seq = read_seqbegin(&fbc->lock);
+		ret = fbc->count;
+	} while (read_seqretry(&fbc->lock, seq));
+	return ret;
+
+}
+#endif
+
+static inline s64 percpu_counter_read(struct percpu_counter *fbc)
+{
+	return fbc_count(fbc);
+}
 
 /*
  * It is possible for the percpu_counter_read() to return a small negative
@@ -65,7 +85,7 @@ static inline s64 percpu_counter_read(struct percpu_counter *fbc)
  */
 static inline s64 percpu_counter_read_positive(struct percpu_counter *fbc)
 {
-	s64 ret = fbc->count;
+	s64 ret = fbc_count(fbc);
 
 	barrier();		/* Prevent reloads of fbc->count */
 	if (ret >= 0)
diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index a866389..83bb809 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -18,13 +18,13 @@ void percpu_counter_set(struct percpu_counter *fbc, s64 amount)
 {
 	int cpu;
 
-	spin_lock(&fbc->lock);
+	write_seqlock(&fbc->lock);
 	for_each_possible_cpu(cpu) {
 		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
 		*pcount = 0;
 	}
 	fbc->count = amount;
-	spin_unlock(&fbc->lock);
+	write_sequnlock(&fbc->lock);
 }
 EXPORT_SYMBOL(percpu_counter_set);
 
@@ -37,10 +37,10 @@ void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)
 	pcount = per_cpu_ptr(fbc->counters, cpu);
 	count = *pcount + amount;
 	if (count >= batch || count <= -batch) {
-		spin_lock(&fbc->lock);
+		write_seqlock(&fbc->lock);
 		fbc->count += count;
 		*pcount = 0;
-		spin_unlock(&fbc->lock);
+		write_sequnlock(&fbc->lock);
 	} else {
 		*pcount = count;
 	}
@@ -57,7 +57,7 @@ s64 __percpu_counter_sum(struct percpu_counter *fbc)
 	s64 ret;
 	int cpu;
 
-	spin_lock(&fbc->lock);
+	write_seqlock(&fbc->lock);
 	ret = fbc->count;
 	for_each_online_cpu(cpu) {
 		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
@@ -66,7 +66,7 @@ s64 __percpu_counter_sum(struct percpu_counter *fbc)
 	}
 	fbc->count = ret;
 
-	spin_unlock(&fbc->lock);
+	write_sequnlock(&fbc->lock);
 	return ret;
 }
 EXPORT_SYMBOL(__percpu_counter_sum);
@@ -75,7 +75,7 @@ EXPORT_SYMBOL(__percpu_counter_sum);
 
 int percpu_counter_init(struct percpu_counter *fbc, s64 amount)
 {
-	spin_lock_init(&fbc->lock);
+	seqlock_init(&fbc->lock);
 	fbc->count = amount;
 	fbc->counters = alloc_percpu(s32);
 	if (!fbc->counters)
@@ -95,7 +95,7 @@ int percpu_counter_init_irq(struct percpu_counter *fbc, s64 amount)
 
 	err = percpu_counter_init(fbc, amount);
 	if (!err)
-		lockdep_set_class(&fbc->lock, &percpu_counter_irqsafe);
+		lockdep_set_class(&fbc->lock.lock, &percpu_counter_irqsafe);
 	return err;
 }
 
@@ -130,11 +130,11 @@ static int __cpuinit percpu_counter_hotcpu_callback(struct notifier_block *nb,
 		s32 *pcount;
 		unsigned long flags;
 
-		spin_lock_irqsave(&fbc->lock, flags);
+		write_seqlock_irqsave(&fbc->lock, flags);
 		pcount = per_cpu_ptr(fbc->counters, cpu);
 		fbc->count += *pcount;
 		*pcount = 0;
-		spin_unlock_irqrestore(&fbc->lock, flags);
+		write_sequnlock_irqrestore(&fbc->lock, flags);
 	}
 	mutex_unlock(&percpu_counters_lock);
 	return NOTIFY_OK;
-- 
1.6.0.1.90.g27a6e
