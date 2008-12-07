From: Eric Dumazet <dada1@cosmosbay.com>
Subject: [PATCH, take2] percpu_counter: FBC_BATCH might be too big
Date: Sun, 07 Dec 2008 10:25:45 +0100
Message-ID: <493B9699.8080603@cosmosbay.com>
References: <4939513C.3090101@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Mike Travis <travis@sgi.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux kernel <linux-kernel@vger.kernel.org>,
	Christoph Lameter <cl@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gw1.cosmosbay.com ([86.65.150.130]:44528 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbYLGJgA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Dec 2008 04:36:00 -0500
In-Reply-To: <4939513C.3090101@cosmosbay.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In this second version I guarded hotcpu_notifier() call by
a #ifdef CONFIG_HOTPLUG_CPU

I wonder why hotcpu_notifier() is not a null op if !CONFIG_HOTPLUG_CPU

Thank you

[PATCH] percpu_counter: FBC_BATCH might be too big

For NR_CPUS >= 16 values, FBC_BATCH is 2*NR_CPUS

Considering more and more distros are using high NR_CPUS values,
it makes sense to use a more sensible value for FBC_BATCH.

A sensible value is 2*num_online_cpus(), with a minimum value of 32
(This minimum value helps branch prediction in __percpu_counter_add())

We already have a hotcpu notifier, so we can adjust FBC_BATCH dynamically.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/percpu_counter.h |    6 +-----
 lib/percpu_counter.c           |   16 +++++++++++++++-
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
index 9007ccd..c42a184 100644
--- a/include/linux/percpu_counter.h
+++ b/include/linux/percpu_counter.h
@@ -24,11 +24,7 @@ struct percpu_counter {
 	s32 *counters;
 };
 
-#if NR_CPUS >= 16
-#define FBC_BATCH	(NR_CPUS*2)
-#else
-#define FBC_BATCH	(NR_CPUS*4)
-#endif
+extern int FBC_BATCH;
 
 int percpu_counter_init(struct percpu_counter *fbc, s64 amount);
 int percpu_counter_init_irq(struct percpu_counter *fbc, s64 amount);
diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index a866389..e21ce7c 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -114,6 +114,16 @@ void percpu_counter_destroy(struct percpu_counter *fbc)
 }
 EXPORT_SYMBOL(percpu_counter_destroy);
 
+int FBC_BATCH __read_mostly = 32;
+EXPORT_SYMBOL(FBC_BATCH);
+
+static void compute_batch_value(void)
+{
+	int nr = num_online_cpus();
+
+	FBC_BATCH = max(32, nr*2);
+}
+
 #ifdef CONFIG_HOTPLUG_CPU
 static int __cpuinit percpu_counter_hotcpu_callback(struct notifier_block *nb,
 					unsigned long action, void *hcpu)
@@ -121,6 +131,7 @@ static int __cpuinit percpu_counter_hotcpu_callback(struct notifier_block *nb,
 	unsigned int cpu;
 	struct percpu_counter *fbc;
 
+	compute_batch_value();
 	if (action != CPU_DEAD)
 		return NOTIFY_OK;
 
@@ -139,11 +150,14 @@ static int __cpuinit percpu_counter_hotcpu_callback(struct notifier_block *nb,
 	mutex_unlock(&percpu_counters_lock);
 	return NOTIFY_OK;
 }
+#endif
 
 static int __init percpu_counter_startup(void)
 {
+	compute_batch_value();
+#ifdef CONFIG_HOTPLUG_CPU
 	hotcpu_notifier(percpu_counter_hotcpu_callback, 0);
+#endif
 	return 0;
 }
 module_init(percpu_counter_startup);
-#endif
