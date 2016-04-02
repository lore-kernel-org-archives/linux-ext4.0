From: Waiman Long <Waiman.Long@hpe.com>
Subject: [PATCH 2/3] percpu_stats: Simple per-cpu statistics count helper functions
Date: Fri,  1 Apr 2016 23:09:37 -0400
Message-ID: <1459566578-30221-3-git-send-email-Waiman.Long@hpe.com>
References: <1459566578-30221-1-git-send-email-Waiman.Long@hpe.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Scott J Norton <scott.norton@hpe.com>,
	Douglas Hatch <doug.hatch@hpe.com>,
	Toshimitsu Kani <toshi.kani@hpe.com>,
	Waiman Long <Waiman.Long@hpe.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459566578-30221-1-git-send-email-Waiman.Long@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch introduces a set of simple per-cpu statictics count helper
functions that can be used by other kernel subsystems for keeping
track of the number of events that happens. It is per-cpu based to
reduce overhead and improve accuracy of the counter. Using per-cpu
counter is usually overkill for such purpose.

The following APIs are provided:

 - int percpu_stats_init(struct percpu_stats *pcs, int num)
   Initialize the per-cpu statictics counts structure which should have
   the given number of statistics counts. Return -ENOMEM on error.

 - void percpu_stats_destroy(struct percpu_stats *pcs)
   Free the percpu memory allocated.

 - void percpu_stats_inc(struct percpu_stats *pcs, int stat)
   void percpu_stats_dec(struct percpu_stats *pcs, int stat)
   Increment and decrement the given per-cpu statistics count.

 - unsigned long percpu_stats_sum(struct percpu_stats *pcs, int stat)
   Return the current aggregated sum of the given statistics count.

 - void percpu_stats_reset(struct percpu_stats *pcs)
   Clear all the statistics counts defined in the given percpu_stats
   structure.

Signed-off-by: Waiman Long <Waiman.Long@hpe.com>
---
 include/linux/percpu_stats.h |  103 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 103 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/percpu_stats.h

diff --git a/include/linux/percpu_stats.h b/include/linux/percpu_stats.h
new file mode 100644
index 0000000..a4f715e
--- /dev/null
+++ b/include/linux/percpu_stats.h
@@ -0,0 +1,103 @@
+#ifndef _LINUX_PERCPU_STATS_H
+#define _LINUX_PERCPU_STATS_H
+/*
+ * Simple per-cpu statistics counts that have less overhead than the
+ * per-cpu counters.
+ */
+#include <linux/percpu.h>
+#include <linux/types.h>
+
+struct percpu_stats {
+	unsigned long __percpu *stats;
+	int nstats;	/* Number of statistics counts in stats array */
+};
+
+/*
+ * Reset the all statistics counts to 0 in the percpu_stats structure
+ */
+static inline void percpu_stats_reset(struct percpu_stats *pcs)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		unsigned long *pstats =  per_cpu_ptr(pcs->stats, cpu);
+		int stat;
+
+		for (stat = 0; stat < pcs->nstats; stat++, pstats++)
+			*pstats = 0;
+	}
+
+	/*
+	 * If a statistics count is in the middle of being updated, it
+	 * is possible that the above clearing may not work. So we need
+	 * to double check again to make sure that the counters are really
+	 * cleared. Still there is a still a very small chance that the
+	 * second clearing does not work.
+	 */
+	for_each_possible_cpu(cpu) {
+		unsigned long *pstats =  per_cpu_ptr(pcs->stats, cpu);
+		int stat;
+
+		for (stat = 0; stat < pcs->nstats; stat++, pstats++)
+			if (*pstats)
+				*pstats = 0;
+	}
+}
+
+static inline int percpu_stats_init(struct percpu_stats *pcs, int num)
+{
+	pcs->nstats = num;
+	pcs->stats  = __alloc_percpu(sizeof(unsigned long) * num,
+				     __alignof__(unsigned long));
+	if (!pcs->stats)
+		return -ENOMEM;
+
+	percpu_stats_reset(pcs);
+	return 0;
+}
+
+static inline void percpu_stats_destroy(struct percpu_stats *pcs)
+{
+	free_percpu(pcs->stats);
+	pcs->stats  = NULL;
+	pcs->nstats = 0;
+}
+
+static inline void
+__percpu_stats_add(struct percpu_stats *pcs, int stat, int cnt)
+{
+	unsigned long *pstat;
+
+	if ((unsigned int)stat >= pcs->nstats)
+		return;
+	preempt_disable();
+	pstat = this_cpu_ptr(&pcs->stats[stat]);
+	*pstat += cnt;
+	preempt_enable();
+}
+
+static inline void percpu_stats_inc(struct percpu_stats *pcs, int stat)
+{
+	__percpu_stats_add(pcs, stat, 1);
+}
+
+static inline void percpu_stats_dec(struct percpu_stats *pcs, int stat)
+{
+	__percpu_stats_add(pcs, stat, -1);
+}
+
+static inline unsigned long
+percpu_stats_sum(struct percpu_stats *pcs, int stat)
+{
+	int cpu;
+	unsigned long sum = 0;
+
+	if ((unsigned int)stat >= pcs->nstats)
+		return sum;
+
+	for_each_possible_cpu(cpu)
+		sum += per_cpu(pcs->stats[stat], cpu);
+	return sum;
+}
+
+#endif /* _LINUX_PERCPU_STATS_H */
-- 
1.7.1
