From: Andrew Morton <akpm@osdl.org>
Subject: Re: [patch 003/152] jbd: fix commit of ordered data buffers
Date: Fri, 29 Sep 2006 13:20:57 -0700
Message-ID: <20060929132057.3039bac8.akpm@osdl.org>
References: <200609260630.k8Q6UrvQ011999@shell0.pdx.osdl.net>
	<20060929122026.62ec29eb.akpm@osdl.org>
	<20060929191759.GA19304@elte.hu>
	<200609292154.30234.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Ingo Molnar <mingo@elte.hu>, Badari Pulavarty <pbadari@us.ibm.com>,
	Jan Kara <jack@suse.cz>, torvalds@osdl.org, stable@kernel.org,
	ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:11693 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1422813AbWI2UZH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Sep 2006 16:25:07 -0400
To: Andi Kleen <ak@suse.de>
In-Reply-To: <200609292154.30234.ak@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 29 Sep 2006 21:54:30 +0200
Andi Kleen <ak@suse.de> wrote:

> On Friday 29 September 2006 21:18, Ingo Molnar wrote:
> > 
> > * Andrew Morton <akpm@osdl.org> wrote:
> > 
> > > gad, there have been so many all-CPU-backtrace patches over the years.
> > > 
> > > <optimistically cc's Ingo>
> > > 
> > > Ingo, do you think that's something which we shuld have in the 
> > > spinlock debugging code?  A trace to let us see which CPU is holding 
> > > that lock, and where from?  I guess if the other cpu is stuck in 
> > > spin_lock_irqsave() then we'll get stuck delivering the IPI, so it'd 
> > > need to be async.
> > 
> > used to have this in -rt for i686 and x86_64 for the NMI watchdog tick 
> > to print on all CPUs, in the next tick (i.e. no need to actually 
> > initiate an IPI) - but it was all a bit hacky [but worked]. It fell 
> > victim to some recent flux in that area.
> 
> You mean spinlock debugging setting a global variable and the NMI
> watchdog testing that?  Makes sense. I can put it on my todo list.

It does make sense.

<type, type>

Something like this?  (compiled only)

From: Andrew Morton <akpm@osdl.org>

When a spinlock lockup occurs, arrange for the NMI code to emit an all-cpu
backtrace, so we get to see which CPU is holding the lock, and where.

Cc: Andi Kleen <ak@muc.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/nmi.c   |   14 ++++++++++++++
 arch/x86_64/kernel/nmi.c |   17 ++++++++++++++++-
 include/asm-i386/nmi.h   |    3 +++
 include/asm-x86_64/nmi.h |    3 +++
 include/linux/nmi.h      |    5 +++++
 lib/spinlock_debug.c     |    4 ++++
 6 files changed, 45 insertions(+), 1 deletion(-)

diff -puN lib/spinlock_debug.c~spinlock-debug-all-cpu-backtrace lib/spinlock_debug.c
--- a/lib/spinlock_debug.c~spinlock-debug-all-cpu-backtrace
+++ a/lib/spinlock_debug.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/spinlock.h>
+#include <linux/nmi.h>
 #include <linux/interrupt.h>
 #include <linux/debug_locks.h>
 #include <linux/delay.h>
@@ -116,6 +117,9 @@ static void __spin_lock_debug(spinlock_t
 				raw_smp_processor_id(), current->comm,
 				current->pid, lock);
 			dump_stack();
+#ifdef CONFIG_SMP
+			trigger_all_cpu_backtrace();
+#endif
 		}
 	}
 }
diff -puN arch/i386/kernel/nmi.c~spinlock-debug-all-cpu-backtrace arch/i386/kernel/nmi.c
--- a/arch/i386/kernel/nmi.c~spinlock-debug-all-cpu-backtrace
+++ a/arch/i386/kernel/nmi.c
@@ -23,6 +23,7 @@
 #include <linux/percpu.h>
 #include <linux/dmi.h>
 #include <linux/kprobes.h>
+#include <linux/cpumask.h>
 
 #include <asm/smp.h>
 #include <asm/nmi.h>
@@ -40,6 +41,8 @@
 static DEFINE_PER_CPU(unsigned long, perfctr_nmi_owner);
 static DEFINE_PER_CPU(unsigned long, evntsel_nmi_owner[3]);
 
+static cpumask_t backtrace_mask = CPU_MASK_NONE;
+
 /* this number is calculated from Intel's MSR_P4_CRU_ESCR5 register and it's
  * offset from MSR_P4_BSU_ESCR0.  It will be the max for all platforms (for now)
  */
@@ -905,6 +908,12 @@ __kprobes int nmi_watchdog_tick(struct p
 		touched = 1;
 	}
 
+	if (cpu_isset(cpu, backtrace_mask)) {
+		cpu_clear(cpu, backtrace_mask);
+		printk("NMI backtrace for cpu %d\n", cpu);
+		dump_stack();
+	}
+
 	sum = per_cpu(irq_stat, cpu).apic_timer_irqs;
 
 	/* if the apic timer isn't firing, this cpu isn't doing much */
@@ -1031,6 +1040,11 @@ int proc_nmi_enabled(struct ctl_table *t
 
 #endif
 
+void __trigger_all_cpu_backtrace(void)
+{
+	backtrace_mask = CPU_MASK_ALL;
+}
+
 EXPORT_SYMBOL(nmi_active);
 EXPORT_SYMBOL(nmi_watchdog);
 EXPORT_SYMBOL(avail_to_resrv_perfctr_nmi);
diff -puN arch/x86_64/kernel/nmi.c~spinlock-debug-all-cpu-backtrace arch/x86_64/kernel/nmi.c
--- a/arch/x86_64/kernel/nmi.c~spinlock-debug-all-cpu-backtrace
+++ a/arch/x86_64/kernel/nmi.c
@@ -12,14 +12,15 @@
  *  Mikael Pettersson	: PM converted to driver model. Disable/enable API.
  */
 
+#include <linux/nmi.h>
 #include <linux/mm.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/sysdev.h>
-#include <linux/nmi.h>
 #include <linux/sysctl.h>
 #include <linux/kprobes.h>
+#include <linux/cpumask.h>
 
 #include <asm/smp.h>
 #include <asm/nmi.h>
@@ -37,6 +38,8 @@
 static DEFINE_PER_CPU(unsigned, perfctr_nmi_owner);
 static DEFINE_PER_CPU(unsigned, evntsel_nmi_owner[2]);
 
+static cpumask_t backtrace_mask = CPU_MASK_NONE;
+
 /* this number is calculated from Intel's MSR_P4_CRU_ESCR5 register and it's
  * offset from MSR_P4_BSU_ESCR0.  It will be the max for all platforms (for now)
  */
@@ -778,6 +781,7 @@ int __kprobes nmi_watchdog_tick(struct p
 {
 	int sum;
 	int touched = 0;
+	int cpu = smp_processor_id();
 	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
 	u64 dummy;
 	int rc=0;
@@ -795,6 +799,12 @@ int __kprobes nmi_watchdog_tick(struct p
 		touched = 1;
 	}
 
+	if (cpu_isset(cpu, backtrace_mask)) {
+		cpu_clear(cpu, backtrace_mask);
+		printk("NMI backtrace for cpu %d\n", cpu);
+		dump_stack();
+	}
+
 #ifdef CONFIG_X86_MCE
 	/* Could check oops_in_progress here too, but it's safer
 	   not too */
@@ -927,6 +937,11 @@ int proc_nmi_enabled(struct ctl_table *t
 
 #endif
 
+void __trigger_all_cpu_backtrace(void)
+{
+	backtrace_mask = CPU_MASK_ALL;
+}
+
 EXPORT_SYMBOL(nmi_active);
 EXPORT_SYMBOL(nmi_watchdog);
 EXPORT_SYMBOL(avail_to_resrv_perfctr_nmi);
diff -puN include/linux/nmi.h~spinlock-debug-all-cpu-backtrace include/linux/nmi.h
--- a/include/linux/nmi.h~spinlock-debug-all-cpu-backtrace
+++ a/include/linux/nmi.h
@@ -14,9 +14,14 @@
  * disables interrupts for a long time. This call is stateless.
  */
 #ifdef ARCH_HAS_NMI_WATCHDOG
+#include <asm/nmi.h>
 extern void touch_nmi_watchdog(void);
 #else
 # define touch_nmi_watchdog() do { } while(0)
 #endif
 
+#ifndef trigger_all_cpu_backtrace
+#define trigger_all_cpu_backtrace() do { } while (0)
+#endif
+
 #endif
diff -puN include/asm-i386/nmi.h~spinlock-debug-all-cpu-backtrace include/asm-i386/nmi.h
--- a/include/asm-i386/nmi.h~spinlock-debug-all-cpu-backtrace
+++ a/include/asm-i386/nmi.h
@@ -36,4 +36,7 @@ extern unsigned int nmi_watchdog;
 #define NMI_LOCAL_APIC	2
 #define NMI_INVALID	3
 
+void __trigger_all_cpu_backtrace(void);
+#define trigger_all_cpu_backtrace() __trigger_all_cpu_backtrace()
+
 #endif /* ASM_NMI_H */
diff -puN include/asm-x86_64/nmi.h~spinlock-debug-all-cpu-backtrace include/asm-x86_64/nmi.h
--- a/include/asm-x86_64/nmi.h~spinlock-debug-all-cpu-backtrace
+++ a/include/asm-x86_64/nmi.h
@@ -70,4 +70,7 @@ extern unsigned int nmi_watchdog;
 #define NMI_LOCAL_APIC	2
 #define NMI_INVALID	3
 
+void __trigger_all_cpu_backtrace(void);
+#define trigger_all_cpu_backtrace() __trigger_all_cpu_backtrace()
+
 #endif /* ASM_NMI_H */
_


