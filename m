From: Eric Dumazet <dada1@cosmosbay.com>
Subject: [PATCH] percpu_counter: use local_t and atomic_long_t if possible
Date: Fri, 12 Dec 2008 12:08:39 +0100
Message-ID: <49424637.3010107@cosmosbay.com>
References: <4936D287.6090206@cosmosbay.com> <20081209214921.b3944687.akpm@linux-foundation.org> <49404925.7090902@cosmosbay.com> <200812121847.06432.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Rusty Russell <rusty@rustcorp.com.au>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Theodore Tso <tytso@mit.edu>,
	linux kernel <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org,
	Christoph Lameter <cl@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gw1.cosmosbay.com ([86.65.150.130]:48482 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbYLLLJT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Dec 2008 06:09:19 -0500
In-Reply-To: <200812121847.06432.rusty@rustcorp.com.au>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

After discussions on percpu_counter subject, I cooked following patch

My goals were :

- IRQ safe percpu_counter (needed for net-next-2.6)
- 64bit platforms can avoid spin_lock and reduce size of percpu_counter
- No increase of API

Final result, on x86_64, __percpu_counter_add() is really fast and irq safe :

0000000000000000 <__percpu_counter_add>:
   0:   55                      push   %rbp
   1:   48 89 d1                mov    %rdx,%rcx
   4:   48 8b 47 18             mov    0x18(%rdi),%rax
   8:   48 89 e5                mov    %rsp,%rbp
   b:   65 8b 14 25 24 00 00    mov    %gs:0x24,%edx
  12:   00
  13:   48 f7 d0                not    %rax
  16:   89 d2                   mov    %edx,%edx
  18:   48 8b 14 d0             mov    (%rax,%rdx,8),%rdx
  1c:   48 89 f0                mov    %rsi,%rax
  1f:   48 0f c1 02             xadd   %rax,(%rdx)
  23:   48 01 f0                add    %rsi,%rax
  26:   48 39 c1                cmp    %rax,%rcx
  29:   7e 0d                   jle    38 <__percpu_counter_add+0x38>
  2b:   48 f7 d9                neg    %rcx
  2e:   48 39 c1                cmp    %rax,%rcx
  31:   7d 05                   jge    38 <__percpu_counter_add+0x38>
  33:   c9                      leaveq
  34:   c3                      retq
  35:   0f 1f 00                nopl   (%rax)
  38:   48 29 02                sub    %rax,(%rdx)
  3b:   f0 48 01 07             lock add %rax,(%rdi)
  3f:   c9                      leaveq
  40:   c3                      retq

Changes are :

We use local_t instead of s32 for the local storage (for each cpu)

We use atomic_long_t instead of s64 on 64bit arches, to avoid spin_lock.

On 32bit arches, we guard the shared s64 value with an irqsafe spin_lock.
As this spin_lock is not taken in fast path, this should not make a real
difference.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
---
 include/linux/percpu_counter.h |   38 +++++++++--
 lib/percpu_counter.c           |  104 ++++++++++++++++++-------------
 2 files changed, 94 insertions(+), 48 deletions(-)

diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
index 9007ccd..f5133ce 100644
--- a/include/linux/percpu_counter.h
+++ b/include/linux/percpu_counter.h
@@ -12,16 +12,42 @@
 #include <linux/threads.h>
 #include <linux/percpu.h>
 #include <linux/types.h>
+#include <asm/local.h>
 
 #ifdef CONFIG_SMP
 
+#ifdef CONFIG_64BIT
+struct s64_counter {
+	atomic_long_t val;
+};
+
+static inline s64 s64c_read(struct s64_counter *c)
+{
+	return atomic_long_read(&c->val);
+}
+#else
+struct s64_counter {
+	spinlock_t	lock;
+	s64		val;
+};
+
+static inline s64 s64c_read(struct s64_counter *c)
+{
+	/*
+	 * Previous percpu_counter implementation used to
+	 * read s64 without locking. Thats racy.
+	 */
+	return c->val;
+}
+
+#endif
+
 struct percpu_counter {
-	spinlock_t lock;
-	s64 count;
+	struct s64_counter counter;
 #ifdef CONFIG_HOTPLUG_CPU
 	struct list_head list;	/* All percpu_counters are on a list */
 #endif
-	s32 *counters;
+	local_t		*counters;
 };
 
 #if NR_CPUS >= 16
@@ -34,7 +60,7 @@ int percpu_counter_init(struct percpu_counter *fbc, s64 amount);
 int percpu_counter_init_irq(struct percpu_counter *fbc, s64 amount);
 void percpu_counter_destroy(struct percpu_counter *fbc);
 void percpu_counter_set(struct percpu_counter *fbc, s64 amount);
-void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch);
+void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, long batch);
 s64 __percpu_counter_sum(struct percpu_counter *fbc);
 
 static inline void percpu_counter_add(struct percpu_counter *fbc, s64 amount)
@@ -55,7 +81,7 @@ static inline s64 percpu_counter_sum(struct percpu_counter *fbc)
 
 static inline s64 percpu_counter_read(struct percpu_counter *fbc)
 {
-	return fbc->count;
+	return s64c_read(&fbc->counter);
 }
 
 /*
@@ -65,7 +91,7 @@ static inline s64 percpu_counter_read(struct percpu_counter *fbc)
  */
 static inline s64 percpu_counter_read_positive(struct percpu_counter *fbc)
 {
-	s64 ret = fbc->count;
+	s64 ret = percpu_counter_read(fbc);
 
 	barrier();		/* Prevent reloads of fbc->count */
 	if (ret >= 0)
diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index b255b93..6ef4a44 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -14,35 +14,58 @@ static LIST_HEAD(percpu_counters);
 static DEFINE_MUTEX(percpu_counters_lock);
 #endif
 
+#ifdef CONFIG_64BIT
+static inline void s64c_add(s64 amount, struct s64_counter *c)
+{
+	atomic_long_add(amount, &c->val);
+}
+
+static inline void s64c_set(struct s64_counter *c, s64 amount)
+{
+	atomic_long_set(&c->val, amount);
+}
+
+#else
+
+static inline void s64c_add(s64 amount, struct s64_counter *c)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&c->lock, flags);
+	c->val += amount;
+	spin_unlock_irqrestore(&c->lock, flags);
+}
+
+static inline void s64c_set(struct s64_counter *c, s64 amount)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&c->lock, flags);
+	c->val = amount;
+	spin_unlock_irqrestore(&c->lock, flags);
+}
+#endif /* CONFIG_64BIT */
+
 void percpu_counter_set(struct percpu_counter *fbc, s64 amount)
 {
 	int cpu;
 
-	spin_lock(&fbc->lock);
-	for_each_possible_cpu(cpu) {
-		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
-		*pcount = 0;
-	}
-	fbc->count = amount;
-	spin_unlock(&fbc->lock);
+	for_each_possible_cpu(cpu)
+		local_set(per_cpu_ptr(fbc->counters, cpu), 0);
+	s64c_set(&fbc->counter, amount);
 }
 EXPORT_SYMBOL(percpu_counter_set);
 
-void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)
+void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, long batch)
 {
-	s64 count;
-	s32 *pcount;
-	int cpu = get_cpu();
-
-	pcount = per_cpu_ptr(fbc->counters, cpu);
-	count = *pcount + amount;
-	if (count >= batch || count <= -batch) {
-		spin_lock(&fbc->lock);
-		fbc->count += count;
-		*pcount = 0;
-		spin_unlock(&fbc->lock);
-	} else {
-		*pcount = count;
+	long count;
+	local_t *pcount;
+
+	pcount = per_cpu_ptr(fbc->counters, get_cpu());
+	count = local_add_return(amount, pcount);
+	if (unlikely(count >= batch || count <= -batch)) {
+		local_sub(count, pcount);
+		s64c_add(count, &fbc->counter);
 	}
 	put_cpu();
 }
@@ -57,24 +80,21 @@ s64 __percpu_counter_sum(struct percpu_counter *fbc)
 	s64 ret;
 	int cpu;
 
-	spin_lock(&fbc->lock);
-	ret = fbc->count;
-	for_each_online_cpu(cpu) {
-		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
-		ret += *pcount;
-	}
-	spin_unlock(&fbc->lock);
+	ret = s64c_read(&fbc->counter);
+	for_each_online_cpu(cpu)
+		ret += local_read(per_cpu_ptr(fbc->counters, cpu));
 	return ret;
 }
 EXPORT_SYMBOL(__percpu_counter_sum);
 
-static struct lock_class_key percpu_counter_irqsafe;
 
 int percpu_counter_init(struct percpu_counter *fbc, s64 amount)
 {
-	spin_lock_init(&fbc->lock);
-	fbc->count = amount;
-	fbc->counters = alloc_percpu(s32);
+#ifndef CONFIG_64BIT
+	spin_lock_init(&fbc->counter.lock);
+#endif
+	s64c_set(&fbc->counter, amount);
+	fbc->counters = alloc_percpu(local_t);
 	if (!fbc->counters)
 		return -ENOMEM;
 #ifdef CONFIG_HOTPLUG_CPU
@@ -91,8 +111,13 @@ int percpu_counter_init_irq(struct percpu_counter *fbc, s64 amount)
 	int err;
 
 	err = percpu_counter_init(fbc, amount);
-	if (!err)
-		lockdep_set_class(&fbc->lock, &percpu_counter_irqsafe);
+#ifndef CONFIG_64BIT
+	if (!err) {
+		static struct lock_class_key percpu_counter_irqsafe;
+
+		lockdep_set_class(&fbc->counter.lock, &percpu_counter_irqsafe);
+	}
+#endif
 	return err;
 }
 
@@ -124,14 +149,9 @@ static int __cpuinit percpu_counter_hotcpu_callback(struct notifier_block *nb,
 	cpu = (unsigned long)hcpu;
 	mutex_lock(&percpu_counters_lock);
 	list_for_each_entry(fbc, &percpu_counters, list) {
-		s32 *pcount;
-		unsigned long flags;
