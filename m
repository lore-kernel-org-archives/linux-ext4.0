From: Eric Dumazet <dada1@cosmosbay.com>
Subject: [PATCH] percpu_counter: FBC_BATCH should be a variable
Date: Mon, 08 Dec 2008 09:05:04 +0100
Message-ID: <493CD530.4020808@cosmosbay.com>
References: <4939513C.3090101@cosmosbay.com>	<493B9699.8080603@cosmosbay.com>	<20081207090918.595627b2.akpm@linux-foundation.org>	<493C1632.2000901@cosmosbay.com> <20081207203244.10372834.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Mike Travis <travis@sgi.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux kernel <linux-kernel@vger.kernel.org>,
	Christoph Lameter <cl@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gw1.cosmosbay.com ([86.65.150.130]:45575 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbYLHIKx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Dec 2008 03:10:53 -0500
In-Reply-To: <20081207203244.10372834.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andrew Morton a =E9crit :
> On Sun, 07 Dec 2008 19:30:10 +0100 Eric Dumazet <dada1@cosmosbay.com>=
 wrote:
>=20
>>> Do
>>>
>>> 	$EDITOR  $(grep -l hotcpu_notifier */*.c)
>>>
>>> and you'll see lots of code gets it right, and lots of code gets it=
 wrong.
>> I see nothing interesting, I must be blind.
>>
>> lib/percpu_counter.c: In function 'percpu_counter_startup':
>> lib/percpu_counter.c:158: error: 'percpu_counter_hotcpu_callback' un=
declared (first use in this function)
>> lib/percpu_counter.c:158: error: (Each undeclared identifier is repo=
rted only once
>> lib/percpu_counter.c:158: error: for each function it appears in.)
>> make[1]: *** [lib/percpu_counter.o] Error 1
>=20
> Perhaps you still had percpu_counter_hotcpu_callback inside #ifdef.
>=20
> That a look at kernel/workqueue.c, fs/buffer.c.  No #ifdef CONFIG_HOT=
PLUG_CPU
> needed at all.

We still need some #ifdef or we also must also delete them around "stru=
ct list_head list"
in include/linux/percpu_counter.h and grow struct percpu_counter.

lib/percpu_counter.c: In function 'percpu_counter_hotcpu_callback':
lib/percpu_counter.c:137: error: 'struct percpu_counter' has no member =
named 'list'
lib/percpu_counter.c:137: warning: type defaults to 'int' in declaratio=
n of '__mptr'
lib/percpu_counter.c:137: warning: initialization from incompatible poi=
nter type
=2E..


Thank you Andrew


[PATCH] percpu_counter: FBC_BATCH should be a variable

=46or NR_CPUS >=3D 16 values, FBC_BATCH is 2*NR_CPUS

Considering more and more distros are using high NR_CPUS values,
it makes sense to use a more sensible value for FBC_BATCH, and
get rid of NR_CPUS.

A sensible value is 2*num_online_cpus(), with a minimum value of 32
(This minimum value helps branch prediction in __percpu_counter_add())

We already have a hotcpu notifier, so we can adjust FBC_BATCH dynamical=
ly.

We rename FBC_BATCH to percpu_counter_batch since its not a constant
anymore.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 fs/ext4/ext4.h                 |    6 +++---
 fs/ext4/inode.c                |    2 +-
 include/linux/percpu_counter.h |    8 ++------
 lib/percpu_counter.c           |   18 ++++++++++++++----
 4 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b0537c8..6c46c64 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1225,11 +1225,11 @@ do {								\
 } while (0)
=20
 #ifdef CONFIG_SMP
-/* Each CPU can accumulate FBC_BATCH blocks in their local
+/* Each CPU can accumulate percpu_counter_batch blocks in their local
  * counters. So we need to make sure we have free blocks more
- * than FBC_BATCH  * nr_cpu_ids. Also add a window of 4 times.
+ * than percpu_counter_batch  * nr_cpu_ids. Also add a window of 4 tim=
es.
  */
-#define EXT4_FREEBLOCKS_WATERMARK (4 * (FBC_BATCH * nr_cpu_ids))
+#define EXT4_FREEBLOCKS_WATERMARK (4 * (percpu_counter_batch * nr_cpu_=
ids))
 #else
 #define EXT4_FREEBLOCKS_WATERMARK 0
 #endif
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index be21a5a..db661e7 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2497,7 +2497,7 @@ static int ext4_nonda_switch(struct super_block *=
sb)
 	/*
 	 * switch to non delalloc mode if we are running low
 	 * on free block. The free block accounting via percpu
-	 * counters can get slightly wrong with FBC_BATCH getting
+	 * counters can get slightly wrong with percpu_counter_batch getting
 	 * accumulated on each CPU without updating global counters
 	 * Delalloc need an accurate free block accounting. So switch
 	 * to non delalloc when we are near to error range.
diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_coun=
ter.h
index 9007ccd..99de7a3 100644
--- a/include/linux/percpu_counter.h
+++ b/include/linux/percpu_counter.h
@@ -24,11 +24,7 @@ struct percpu_counter {
 	s32 *counters;
 };
=20
-#if NR_CPUS >=3D 16
-#define FBC_BATCH	(NR_CPUS*2)
-#else
-#define FBC_BATCH	(NR_CPUS*4)
-#endif
+extern int percpu_counter_batch;
=20
 int percpu_counter_init(struct percpu_counter *fbc, s64 amount);
 int percpu_counter_init_irq(struct percpu_counter *fbc, s64 amount);
@@ -39,7 +35,7 @@ s64 __percpu_counter_sum(struct percpu_counter *fbc);
=20
 static inline void percpu_counter_add(struct percpu_counter *fbc, s64 =
amount)
 {
-	__percpu_counter_add(fbc, amount, FBC_BATCH);
+	__percpu_counter_add(fbc, amount, percpu_counter_batch);
 }
=20
 static inline s64 percpu_counter_sum_positive(struct percpu_counter *f=
bc)
diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index a866389..e73eb5b 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -9,10 +9,8 @@
 #include <linux/cpu.h>
 #include <linux/module.h>
=20
-#ifdef CONFIG_HOTPLUG_CPU
 static LIST_HEAD(percpu_counters);
 static DEFINE_MUTEX(percpu_counters_lock);
-#endif
=20
 void percpu_counter_set(struct percpu_counter *fbc, s64 amount)
 {
@@ -114,13 +112,24 @@ void percpu_counter_destroy(struct percpu_counter=
 *fbc)
 }
 EXPORT_SYMBOL(percpu_counter_destroy);
=20
-#ifdef CONFIG_HOTPLUG_CPU
+int percpu_counter_batch __read_mostly =3D 32;
+EXPORT_SYMBOL(percpu_counter_batch);
+
+static void compute_batch_value(void)
+{
+	int nr =3D num_online_cpus();
+
+	percpu_counter_batch =3D max(32, nr*2);
+}
+
 static int __cpuinit percpu_counter_hotcpu_callback(struct notifier_bl=
ock *nb,
 					unsigned long action, void *hcpu)
 {
+#ifdef CONFIG_HOTPLUG_CPU
 	unsigned int cpu;
 	struct percpu_counter *fbc;
=20
+	compute_batch_value();
 	if (action !=3D CPU_DEAD)
 		return NOTIFY_OK;
=20
@@ -137,13 +146,14 @@ static int __cpuinit percpu_counter_hotcpu_callba=
ck(struct notifier_block *nb,
 		spin_unlock_irqrestore(&fbc->lock, flags);
 	}
 	mutex_unlock(&percpu_counters_lock);
+#endif
 	return NOTIFY_OK;
 }
=20
 static int __init percpu_counter_startup(void)
 {
+	compute_batch_value();
 	hotcpu_notifier(percpu_counter_hotcpu_callback, 0);
 	return 0;
 }
 module_init(percpu_counter_startup);
-#endif

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
