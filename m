From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] percpu_counter: Fix __percpu_counter_sum()
Date: Mon, 15 Dec 2008 23:23:52 +1030
Message-ID: <200812152323.53592.rusty@rustcorp.com.au>
References: <4936D287.6090206@cosmosbay.com> <493F4EF4.4080205@cosmosbay.com> <20081209214921.b3944687.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Eric Dumazet <dada1@cosmosbay.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Theodore Tso <tytso@mit.edu>,
	linux kernel <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org,
	Christoph Lameter <clameter@sgi.com>,
	Paul Mackerras <paulus@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:56523 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbYLOMx7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Dec 2008 07:53:59 -0500
In-Reply-To: <20081209214921.b3944687.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wednesday 10 December 2008 16:19:21 Andrew Morton wrote:
> Rusty, Christoph: talk to me.  If we add a new user of local_t in core
> kernel, will we regret it?

Interesting.  There's new local_t infrastructure, but it's not used.

Here's a benchmark patch showing some results.  x86 is pretty close to
optimal already, though my results on Power show atomic_long is a bad choice
there.

I'll do an audit of the users, then send out some local_t cleanup patches etc.

Benchmarks for local_t variants

(This patch also fixes the x86 cpu_local_* macros, which are obviously
unused).

I chose a large array (1M longs) for the inc/add/add_return tests so
the trivalue case would show some cache pressure.

The cpu_local_inc case is always cache-hot, so it's not comparable to
the others.

Time in ns per iteration (brackets is with CONFIG_PREEMPT=y):

		inc	add	add_return	cpu_local_inc	read
x86-32: 2.13 Ghz Core Duo 2
atomic_long	118	118	115		17		17
irqsave/rest	77	78	77		23		16
trivalue	45	45	127		3(6)		21
local_t		36	36	36		1(5)		17

x86-64: 2.6 GHz Dual-Core AMD Opteron 2218
atomic_long	55	60	-		6		19
irqsave/rest	54	54	-		11		19
trivalue	47	47	-		5		28
local_t		47	46	-		1		19

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/include/asm/local.h |   20 ++--
 init/main.c                  |  198 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 208 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/local.h b/arch/x86/include/asm/local.h
--- a/arch/x86/include/asm/local.h
+++ b/arch/x86/include/asm/local.h
@@ -220,16 +220,16 @@ static inline long local_sub_return(long
 	preempt_enable();		\
 })					\
 
-#define cpu_local_read(l)    cpu_local_wrap_v(local_read(&__get_cpu_var((l))))
-#define cpu_local_set(l, i)  cpu_local_wrap(local_set(&__get_cpu_var((l)), (i)))
-#define cpu_local_inc(l)     cpu_local_wrap(local_inc(&__get_cpu_var((l))))
-#define cpu_local_dec(l)     cpu_local_wrap(local_dec(&__get_cpu_var((l))))
-#define cpu_local_add(i, l)  cpu_local_wrap(local_add((i), &__get_cpu_var((l))))
-#define cpu_local_sub(i, l)  cpu_local_wrap(local_sub((i), &__get_cpu_var((l))))
+#define cpu_local_read(l)    cpu_local_wrap_v(local_read(&__get_cpu_var(l)))
+#define cpu_local_set(l, i)  cpu_local_wrap(local_set(&__get_cpu_var(l), (i)))
+#define cpu_local_inc(l)     cpu_local_wrap(local_inc(&__get_cpu_var(l)))
+#define cpu_local_dec(l)     cpu_local_wrap(local_dec(&__get_cpu_var(l)))
+#define cpu_local_add(i, l)  cpu_local_wrap(local_add((i), &__get_cpu_var(l)))
+#define cpu_local_sub(i, l)  cpu_local_wrap(local_sub((i), &__get_cpu_var(l)))
 
-#define __cpu_local_inc(l)	cpu_local_inc((l))
-#define __cpu_local_dec(l)	cpu_local_dec((l))
-#define __cpu_local_add(i, l)	cpu_local_add((i), (l))
-#define __cpu_local_sub(i, l)	cpu_local_sub((i), (l))
+#define __cpu_local_inc(l)	cpu_local_inc(l)
+#define __cpu_local_dec(l)	cpu_local_dec(l)
+#define __cpu_local_add(i, l)	cpu_local_add((i), l)
+#define __cpu_local_sub(i, l)	cpu_local_sub((i), l)
 
 #endif /* _ASM_X86_LOCAL_H */
diff --git a/init/main.c b/init/main.c
--- a/init/main.c
+++ b/init/main.c
@@ -539,6 +539,200 @@ void __init __weak thread_info_cache_ini
 {
 }
 
+/* There are three obvious ways to implement local_t on an arch which
+ * can't do single-instruction inc/dec etc.
+ * 1) atomic_long
+ * 2) irq_save/irq_restore
+ * 3) multiple counters.
+ *
+ * This does a very rough benchmark on each one.
+ */
+struct local1 {
+	atomic_long_t v;
+};
+struct local2 {
+	unsigned long v;
+};
+struct local3 {
+	unsigned long v[3];
+};
+
+/* Enough to put some pressure on the caches. */
+#define NUM_LOCAL_TEST (1024*1024)
+#define NUM_LOCAL_RUNS (NUM_LOCAL_TEST*32)
+/* This will make it jump around looking random */
+#define STRIDE 514001
+
+static void *test_local_variants_mem;
+
+static void init_test_local_variants(void)
+{
+	unsigned long size;
+	size = max(sizeof(struct local1),
+		   max(sizeof(struct local2),
+		       max(sizeof(struct local3), sizeof(local_t))))
+		* NUM_LOCAL_TEST;
+	/* Assume this works in early boot. */
+	test_local_variants_mem = alloc_bootmem_nopanic(size);
+
+	if (!test_local_variants_mem) {
+		printk("test_local_variants: failed to allocate %lu bytes\n",
+		       size);
+		return;
+	}
+}
+
+static void print_result(const char *str,
+			 struct timespec start, struct timespec end)
+{
+	s64 diff;
+
+	diff = ktime_to_ns(ktime_sub(timespec_to_ktime(end), timespec_to_ktime(start)));
+	printk("%s=%lli/%lli ",
+	       str, diff, diff/NUM_LOCAL_RUNS);
+}
+
+static unsigned int warm_local_test_cache(const void *mem, size_t len)
+{
+	unsigned int i, total = 0;
+	for (i = 0; i < len; i++)
+		total += ((char *)mem)[i];
+	return total;
+}
+
+#define TEST_LOOP(expr)				\
+	n = 0;					\
+	getnstimeofday(&start);			\
+	for (i = 0; i < NUM_LOCAL_RUNS; i++) {	\
+		expr;				\
+		n += STRIDE;			\
+		n %= NUM_LOCAL_TEST;		\
+	}					\
+	getnstimeofday(&end);
+
+/* This doesn't test cache effects at all */
+#define NUM_PERCPU_VARS		16
+DEFINE_PER_CPU(struct local1[NUM_PERCPU_VARS], local1_test);
+DEFINE_PER_CPU(struct local2[NUM_PERCPU_VARS], local2_test);
+DEFINE_PER_CPU(struct local3[NUM_PERCPU_VARS], local3_test);
+DEFINE_PER_CPU(local_t[NUM_PERCPU_VARS], local4_test);
+
+static void test_local_variants(void)
+{
+	struct timespec start, end;
+	unsigned int i, n;
+	unsigned long total, warm_total = 0;
+	struct local1 *l1;
+	struct local2 *l2;
+	struct local3 *l3;
+	local_t *l4;
+
+	if (!test_local_variants_mem)
+		return;
+		
+	printk("Running local_t variant benchmarks\n");
+	l1 = test_local_variants_mem;
+	l2 = test_local_variants_mem;
+	l3 = test_local_variants_mem;
+	l4 = test_local_variants_mem;
+
+	printk("atomic_long: ");
+	memset(l1, 0, sizeof(*l1)*NUM_LOCAL_TEST);
+	TEST_LOOP(atomic_long_inc(&l1[n].v));
+	print_result("local_inc", start, end);
+
+	warm_total += warm_local_test_cache(l1, sizeof(*l1)*NUM_LOCAL_TEST);
+	TEST_LOOP(atomic_long_add(1234, &l1[n].v));
+	print_result("local_add", start, end);
+
+	warm_total += warm_local_test_cache(l1, sizeof(*l1)*NUM_LOCAL_TEST);
+	TEST_LOOP(atomic_long_inc(&__get_cpu_var(local1_test)[n%NUM_PERCPU_VARS].v));
+	print_result("cpu_local_inc", start, end);
+
+	warm_total += warm_local_test_cache(l1, sizeof(*l1)*NUM_LOCAL_TEST);
+	total = 0;
+	TEST_LOOP(total += atomic_long_read(&l1[n].v));
+	print_result("local_read", start, end);
+
+	printk("(total was %lu)\n", total);
+
+	printk("irqsave/restore: ");
+	memset(l2, 0, sizeof(*l2)*NUM_LOCAL_TEST);
+	TEST_LOOP(unsigned long flags;
+		  local_irq_save(flags);
+		  l2[n].v++;
+		  local_irq_restore(flags));
+	print_result("local_inc", start, end);
+
+	warm_total += warm_local_test_cache(l2, sizeof(*l2)*NUM_LOCAL_TEST);
+	TEST_LOOP(unsigned long flags;
+		  local_irq_save(flags);
+		  l2[n].v += 1234;
+		  local_irq_restore(flags));
+	print_result("local_add", start, end);
+
+	warm_total += warm_local_test_cache(l2, sizeof(*l2)*NUM_LOCAL_TEST);
+	TEST_LOOP(unsigned long flags;
+		  local_irq_save(flags);
+		  __get_cpu_var(local2_test)[n%NUM_PERCPU_VARS].v++;
+		  local_irq_restore(flags));
+	print_result("cpu_local_inc", start, end);
+
+	warm_total += warm_local_test_cache(l2, sizeof(*l2)*NUM_LOCAL_TEST);
+	total = 0;
+	TEST_LOOP(total += l2[n].v);
+	print_result("local_read", start, end);
+	printk("(total was %lu)\n", total);
+
+	printk("trivalue: ");
+	memset(l3, 0, sizeof(*l3)*NUM_LOCAL_TEST);
+	TEST_LOOP(unsigned int idx
+			= !(preempt_count() & (HARDIRQ_MASK | SOFTIRQ_MASK)) +
+			!(preempt_count() & HARDIRQ_MASK);
+		  l3[n].v[idx]++);
+	print_result("local_inc", start, end);
+
+	warm_total += warm_local_test_cache(l3, sizeof(*l3)*NUM_LOCAL_TEST);
+	TEST_LOOP(unsigned int idx
+			= !(preempt_count() & (HARDIRQ_MASK | SOFTIRQ_MASK)) +
+			!(preempt_count() & HARDIRQ_MASK);
+		  l3[n].v[idx] += 1234);
+	print_result("local_add", start, end);
+
+	warm_total += warm_local_test_cache(l3, sizeof(*l3)*NUM_LOCAL_TEST);
+	TEST_LOOP(unsigned int idx
+			= !(preempt_count() & (HARDIRQ_MASK | SOFTIRQ_MASK)) +
+			!(preempt_count() & HARDIRQ_MASK);
+		  get_cpu_var(local3_test)[n%NUM_PERCPU_VARS].v[idx]++;
+		  put_cpu_var());
+	print_result("cpu_local_inc", start, end);
+
+	warm_total += warm_local_test_cache(l3, sizeof(*l3)*NUM_LOCAL_TEST);
+	total = 0;
+	TEST_LOOP(total += l3[n].v[0] + l3[n].v[1] + l3[n].v[2]);
+	print_result("local_read", start, end);
+	printk("(total was %lu)\n", total);
+
+	printk("local_t: ");
+	memset(l4, 0, sizeof(*l4)*NUM_LOCAL_TEST);
+	TEST_LOOP(local_inc(&l4[n]));
+	print_result("local_inc", start, end);
+
+	warm_total += warm_local_test_cache(l4, sizeof(*l4)*NUM_LOCAL_TEST);
+	TEST_LOOP(local_add(1234, &l4[n]));
+	print_result("local_add", start, end);
+
+	warm_total += warm_local_test_cache(l4, sizeof(*l4)*NUM_LOCAL_TEST);
+	TEST_LOOP(cpu_local_inc(local4_test[n%NUM_PERCPU_VARS]));
+	print_result("cpu_local_inc", start, end);
+
+	warm_total += warm_local_test_cache(l4, sizeof(*l4)*NUM_LOCAL_TEST);
+	total = 0;
+	TEST_LOOP(total += local_read(&l4[n]));
+	print_result("local_read", start, end);
+	printk("(total was %lu, warm_total %lu)\n", total, warm_total);
+}
+
 asmlinkage void __init start_kernel(void)
 {
 	char * command_line;
@@ -635,6 +829,8 @@ asmlinkage void __init start_kernel(void
 	 */
 	locking_selftest();
 
+	init_test_local_variants();
+
 #ifdef CONFIG_BLK_DEV_INITRD
 	if (initrd_start && !initrd_below_start_ok &&
 	    page_to_pfn(virt_to_page((void *)initrd_start)) < min_low_pfn) {
@@ -692,6 +888,8 @@ asmlinkage void __init start_kernel(void
 	acpi_early_init(); /* before LAPIC and SMP init */
 
 	ftrace_init();
+
+	test_local_variants();
 
 	/* Do the rest non-__init'ed, we're now alive */
 	rest_init();
