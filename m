From: Waiman Long <Waiman.Long@hpe.com>
Subject: [PATCH v2 1/4] percpu_stats: Simple per-cpu statistics count helper functions
Date: Fri,  8 Apr 2016 12:16:19 -0400
Message-ID: <1460132182-11690-2-git-send-email-Waiman.Long@hpe.com>
References: <1460132182-11690-1-git-send-email-Waiman.Long@hpe.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Scott J Norton <scott.norton@hpe.com>,
	Douglas Hatch <doug.hatch@hpe.com>,
	Toshimitsu Kani <toshi.kani@hpe.com>,
	Waiman Long <Waiman.Long@hpe.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1460132182-11690-1-git-send-email-Waiman.Long@hpe.com>
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
   void percpu_stats_add(struct percpu_stats *pcs, int stat, int cnt)
   Increment, decrement and add to the given per-cpu statistics count.

 - unsigned long percpu_stats_sum(struct percpu_stats *pcs, int stat)
   Return the current aggregated sum of the given statistics count.

Signed-off-by: Waiman Long <Waiman.Long@hpe.com>
---
 include/linux/percpu_stats.h |   42 +++++++++++++++++++++++++++
 lib/Makefile                 |    2 +-
 lib/percpu_stats.c           |   64 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 107 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/percpu_stats.h
 create mode 100644 lib/percpu_stats.c

diff --git a/include/linux/percpu_stats.h b/include/linux/percpu_stats.h
new file mode 100644
index 0000000..ed6e8ac
--- /dev/null
+++ b/include/linux/percpu_stats.h
@@ -0,0 +1,42 @@
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
+extern void percpu_stats_destroy(struct percpu_stats *pcs);
+extern int  percpu_stats_init(struct percpu_stats *pcs, int num);
+extern uint64_t percpu_stats_sum(struct percpu_stats *pcs, int stat);
+
+/**
+ * percpu_stats_add - Add the given value to a statistics count
+ * @pcs:  Pointer to percpu_stats structure
+ * @stat: The statistics count that needs to be updated
+ * @cnt:  The value to be added to the statistics count
+ */
+static inline void
+percpu_stats_add(struct percpu_stats *pcs, int stat, int cnt)
+{
+	BUG_ON((unsigned int)stat >= pcs->nstats);
+	this_cpu_add(pcs->stats[stat], cnt);
+}
+
+static inline void percpu_stats_inc(struct percpu_stats *pcs, int stat)
+{
+	percpu_stats_add(pcs, stat, 1);
+}
+
+static inline void percpu_stats_dec(struct percpu_stats *pcs, int stat)
+{
+	percpu_stats_add(pcs, stat, -1);
+}
+
+#endif /* _LINUX_PERCPU_STATS_H */
diff --git a/lib/Makefile b/lib/Makefile
index 7bd6fd4..5037c62 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -40,7 +40,7 @@ obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 gcd.o lcm.o list_sort.o uuid.o flex_array.o iov_iter.o clz_ctz.o \
 	 bsearch.o find_bit.o llist.o memweight.o kfifo.o \
 	 percpu-refcount.o percpu_ida.o rhashtable.o reciprocal_div.o \
-	 once.o
+	 once.o percpu_stats.o
 obj-y += string_helpers.o
 obj-$(CONFIG_TEST_STRING_HELPERS) += test-string_helpers.o
 obj-y += hexdump.o
diff --git a/lib/percpu_stats.c b/lib/percpu_stats.c
new file mode 100644
index 0000000..bc9f26d
--- /dev/null
+++ b/lib/percpu_stats.c
@@ -0,0 +1,64 @@
+/*
+ * Simple per-cpu statistics counts that have less overhead than the
+ * per-cpu counters.
+ */
+#include <linux/percpu_stats.h>
+#include <linux/bug.h>
+
+/**
+ * percpu_stats_init - allocate memory for the percpu statistics counts
+ * @pcs: Pointer to percpu_stats structure
+ * @num: Number of statistics counts to be used
+ * Return: 0 if successful, -ENOMEM if memory allocation fails.
+ */
+int percpu_stats_init(struct percpu_stats *pcs, int num)
+{
+	int cpu;
+
+	pcs->nstats = num;
+	pcs->stats  = __alloc_percpu(sizeof(unsigned long) * num,
+				     __alignof__(unsigned long));
+	if (!pcs->stats)
+		return -ENOMEM;
+
+	for_each_possible_cpu(cpu) {
+		unsigned long *pstats =  per_cpu_ptr(pcs->stats, cpu);
+		int stat;
+
+		for (stat = 0; stat < pcs->nstats; stat++, pstats++)
+			*pstats = 0;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(percpu_stats_init);
+
+/**
+ * percpu_stats_destroy - free the memory used by the statistics counts
+ * @pcs: Pointer to percpu_stats structure
+ */
+void percpu_stats_destroy(struct percpu_stats *pcs)
+{
+	free_percpu(pcs->stats);
+	pcs->stats  = NULL;
+	pcs->nstats = 0;
+}
+EXPORT_SYMBOL(percpu_stats_destroy);
+
+/**
+ * percpu_stats_sum - compute the percpu sum of the given statistics count
+ * @pcs  : Pointer to percpu_stats structure
+ * @stat : The statistics count whose sum needs to be computed
+ * Return: Sum of percpu count values
+ */
+uint64_t percpu_stats_sum(struct percpu_stats *pcs, int stat)
+{
+	int cpu;
+	uint64_t sum = 0;
+
+	BUG_ON((unsigned int)stat >= pcs->nstats);
+
+	for_each_possible_cpu(cpu)
+		sum += per_cpu(pcs->stats[stat], cpu);
+	return sum;
+}
+EXPORT_SYMBOL(percpu_stats_sum);
-- 
1.7.1
