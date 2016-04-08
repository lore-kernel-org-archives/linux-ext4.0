From: Waiman Long <Waiman.Long@hpe.com>
Subject: [PATCH v2 2/4] percpu_stats: Enable 64-bit counts in 32-bit architectures
Date: Fri,  8 Apr 2016 12:16:20 -0400
Message-ID: <1460132182-11690-3-git-send-email-Waiman.Long@hpe.com>
References: <1460132182-11690-1-git-send-email-Waiman.Long@hpe.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Scott J Norton <scott.norton@hpe.com>,
	Douglas Hatch <doug.hatch@hpe.com>,
	Toshimitsu Kani <toshi.kani@hpe.com>,
	Waiman Long <Waiman.Long@hpe.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g2t4625.austin.hp.com ([15.73.212.76]:52346 "EHLO
	g2t4625.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758642AbcDHQQr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Apr 2016 12:16:47 -0400
Received: from g2t4623.austin.hp.com (g2t4623.austin.hp.com [15.73.212.78])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g2t4625.austin.hp.com (Postfix) with ESMTPS id 18F6A3855
	for <linux-ext4@vger.kernel.org>; Fri,  8 Apr 2016 16:16:46 +0000 (UTC)
In-Reply-To: <1460132182-11690-1-git-send-email-Waiman.Long@hpe.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The unsigned long type in 32-bit architectures is only 32-bit. This may
not be enough from some statistics counts that may well go over 2^32
over time. This patch optionally enables the use of 64-bit counts in
32-bit architecture, though it does add a bit of performance overhead
if enabled.

This patch adds a flags argument to the percpu_stats_init() function:

  int percpu_stats_init(struct percpu_stats *pcs, int num, int flags)

Currently, the following 2 flags are supported:

 1) PCPU_STAT_64BIT   - enable 64-bit counts
 2) PCPU_STAT_INTSAFE - make the 64-bit count update interrupt safe

The second flag isn't active if the first flag is not set.

Signed-off-by: Waiman Long <Waiman.Long@hpe.com>
---
 include/linux/percpu_stats.h |   28 +++++++++++-
 lib/percpu_stats.c           |   96 +++++++++++++++++++++++++++++++++++-------
 2 files changed, 105 insertions(+), 19 deletions(-)

diff --git a/include/linux/percpu_stats.h b/include/linux/percpu_stats.h
index ed6e8ac..641f211 100644
--- a/include/linux/percpu_stats.h
+++ b/include/linux/percpu_stats.h
@@ -6,15 +6,34 @@
  */
 #include <linux/percpu.h>
 #include <linux/types.h>
+#include <linux/u64_stats_sync.h>
+
+/*
+ * Supported flags for percpu_stats_init()
+ */
+#define PCPU_STAT_64BIT		1	/* Use 64-bit statistics count	  */
+#define PCPU_STAT_INTSAFE	2	/* Make percpu_add interrupt safe */
 
 struct percpu_stats {
-	unsigned long __percpu *stats;
+	union {
+		unsigned long __percpu	*stats;
+		uint64_t __percpu	*stats64;
+	};
+	struct u64_stats_sync sync;
 	int nstats;	/* Number of statistics counts in stats array */
+	int flags;
 };
 
 extern void percpu_stats_destroy(struct percpu_stats *pcs);
-extern int  percpu_stats_init(struct percpu_stats *pcs, int num);
+extern int  percpu_stats_init(struct percpu_stats *pcs, int num, int flags);
 extern uint64_t percpu_stats_sum(struct percpu_stats *pcs, int stat);
+extern void __percpu_stats_add(struct percpu_stats *pcs, int stat, int cnt);
+
+#ifdef CONFIG_64BIT
+#define PERCPU_STATS_FLAGS(pcs)	false
+#else
+#define PERCPU_STATS_FLAGS(pcs)	((pcs)->flags)
+#endif
 
 /**
  * percpu_stats_add - Add the given value to a statistics count
@@ -26,7 +45,10 @@ static inline void
 percpu_stats_add(struct percpu_stats *pcs, int stat, int cnt)
 {
 	BUG_ON((unsigned int)stat >= pcs->nstats);
-	this_cpu_add(pcs->stats[stat], cnt);
+	if (unlikely(PERCPU_STATS_FLAGS(pcs)))
+		__percpu_stats_add(pcs, stat, cnt);
+	else
+		this_cpu_add(pcs->stats[stat], cnt);
 }
 
 static inline void percpu_stats_inc(struct percpu_stats *pcs, int stat)
diff --git a/lib/percpu_stats.c b/lib/percpu_stats.c
index bc9f26d..2ec739e 100644
--- a/lib/percpu_stats.c
+++ b/lib/percpu_stats.c
@@ -5,29 +5,47 @@
 #include <linux/percpu_stats.h>
 #include <linux/bug.h>
 
+#ifdef CONFIG_64BIT
+/*
+ * Ignore PCPU_STAT_64BIT & PCPU_STAT_INTSAFE flags for 64-bit architectures
+ * as 64-bit count is the default.
+ */
+#define IS_STATS64(pcs)	false
+#define GET_FLAGS(f)	((f) & ~(PCPU_STAT_64BIT | PCPU_STAT_INTSAFE))
+#else
+#define IS_STATS64(pcs)	((pcs)->flags & PCPU_STAT_64BIT)
+#define GET_FLAGS(f)	(f)
+#endif
+
 /**
  * percpu_stats_init - allocate memory for the percpu statistics counts
- * @pcs: Pointer to percpu_stats structure
- * @num: Number of statistics counts to be used
+ * @pcs  : Pointer to percpu_stats structure
+ * @num  : Number of statistics counts to be used
+ * @flags: Optional feature bits
  * Return: 0 if successful, -ENOMEM if memory allocation fails.
  */
-int percpu_stats_init(struct percpu_stats *pcs, int num)
+int percpu_stats_init(struct percpu_stats *pcs, int num, int flags)
 {
-	int cpu;
+	int cpu, size;
 
+	pcs->flags  = GET_FLAGS(flags);
 	pcs->nstats = num;
-	pcs->stats  = __alloc_percpu(sizeof(unsigned long) * num,
-				     __alignof__(unsigned long));
-	if (!pcs->stats)
-		return -ENOMEM;
+	if (IS_STATS64(pcs)) {
+		size = sizeof(uint64_t) * num;
+		pcs->stats64 = __alloc_percpu(size, __alignof__(uint64_t));
+		if (!pcs->stats64)
+			return -ENOMEM;
+		u64_stats_init(&pcs->sync);
+	} else {
+		size = sizeof(unsigned long) * num;
+		pcs->stats = __alloc_percpu(size, __alignof__(unsigned long));
+		if (!pcs->stats)
+			return -ENOMEM;
+	}
 
-	for_each_possible_cpu(cpu) {
-		unsigned long *pstats =  per_cpu_ptr(pcs->stats, cpu);
-		int stat;
+	for_each_possible_cpu(cpu)
+		memset(per_cpu_ptr(pcs->stats, cpu), 0, size);
 
-		for (stat = 0; stat < pcs->nstats; stat++, pstats++)
-			*pstats = 0;
-	}
 	return 0;
 }
 EXPORT_SYMBOL(percpu_stats_init);
@@ -57,8 +75,54 @@ uint64_t percpu_stats_sum(struct percpu_stats *pcs, int stat)
 
 	BUG_ON((unsigned int)stat >= pcs->nstats);
 
-	for_each_possible_cpu(cpu)
-		sum += per_cpu(pcs->stats[stat], cpu);
+	if (IS_STATS64(pcs)) {
+		for_each_possible_cpu(cpu) {
+			uint64_t val;
+			unsigned int seq;
+
+			do {
+				seq = u64_stats_fetch_begin(&pcs->sync);
+				val = per_cpu(pcs->stats64[stat], cpu);
+			} while (u64_stats_fetch_retry(&pcs->sync, seq));
+			sum += val;
+		}
+	} else {
+		for_each_possible_cpu(cpu)
+			sum += per_cpu(pcs->stats[stat], cpu);
+	}
 	return sum;
 }
 EXPORT_SYMBOL(percpu_stats_sum);
+
+/**
+ * __percpu_stats_add - add given count to percpu value
+ * @pcs : Pointer to percpu_stats structure
+ * @stat: The statistics count that needs to be updated
+ * @cnt:  The value to be added to the statistics count
+ */
+void __percpu_stats_add(struct percpu_stats *pcs, int stat, int cnt)
+{
+	/*
+	 * u64_stats_update_begin/u64_stats_update_end alone are not safe
+	 * against recursive add on the same CPU caused by interrupt.
+	 * So we need to set the PCPU_STAT_INTSAFE flag if this is required.
+	 */
+	if (IS_STATS64(pcs)) {
+		uint64_t *pstats64;
+		unsigned long flags;
+
+		pstats64 = get_cpu_ptr(pcs->stats64);
+		if (pcs->flags & PCPU_STAT_INTSAFE)
+			local_irq_save(flags);
+
+		u64_stats_update_begin(&pcs->sync);
+		pstats64[stat] += cnt;
+		u64_stats_update_end(&pcs->sync);
+
+		if (pcs->flags & PCPU_STAT_INTSAFE)
+			local_irq_restore(flags);
+
+		put_cpu_ptr(pcs->stats64);
+	}
+}
+EXPORT_SYMBOL(__percpu_stats_add);
-- 
1.7.1

