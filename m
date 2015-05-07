From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: ext4_es_lookup_extent causing rcu stalls.
Date: Thu, 7 May 2015 12:36:11 -0700
Message-ID: <20150507193611.GM5381@linux.vnet.ibm.com>
References: <20150507143552.GA19619@codemonkey.org.uk>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Dave Jones <davej@codemonkey.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150507143552.GA19619@codemonkey.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, May 07, 2015 at 10:35:52AM -0400, Dave Jones wrote:
> I got similar traces to these from the soft lockup detector until
> I disabled it.  It isn't so easy to disable RCU, so perhaps we could
> do something more creative..
> 
> Traces from 4.1-rc2
> 
> 	Dave
> 
> 
> INFO: rcu_sched self-detected stall on CPU
> 	5: (6499 ticks this GP) idle=861/140000000000001/0 softirq=18210/18210 fqs=6500 
> 	 (t=6500 jiffies g=57760 c=57759 q=0)
> Task dump for CPU 5:
> trinity-c1      R  running task    13136 17998  31742 0x0048000c
>  0000000000003350 00000000a3d4db28 ffff88043d943d58 ffffffffb30abd15
>  ffffffffb30abc32 0000000000000005 0000000000000000 0000000000000005
>  ffffffffb3c3b080 0000000000000082 ffff88043d943d78 ffffffffb30afaad
> Call Trace:
>  <IRQ>  [<ffffffffb30abd15>] sched_show_task+0x165/0x280
>  [<ffffffffb30abc32>] ? sched_show_task+0x82/0x280
>  [<ffffffffb30afaad>] dump_cpu_task+0x3d/0x50
>  [<ffffffffb30e3af1>] rcu_dump_cpu_stacks+0x91/0xd0
>  [<ffffffffb30ef21c>] rcu_check_callbacks+0x7ec/0xb30
>  [<ffffffffb31080ae>] ? tick_do_update_jiffies64+0xde/0x140
>  [<ffffffffb30f5389>] update_process_times+0x39/0x60
>  [<ffffffffb3107ef5>] tick_sched_handle.isra.20+0x25/0x60
>  [<ffffffffb3108191>] tick_sched_timer+0x41/0x80
>  [<ffffffffb30f643a>] __run_hrtimer+0xba/0x5f0
>  [<ffffffffb3108150>] ? tick_sched_do_timer+0x40/0x40
>  [<ffffffffb30f6e93>] hrtimer_interrupt+0x103/0x230
>  [<ffffffffb30b10e2>] ? vtime_common_account_irq_enter+0x32/0x50
>  [<ffffffffb3034fec>] local_apic_timer_interrupt+0x3c/0x70
>  [<ffffffffb372bf51>] smp_apic_timer_interrupt+0x41/0x60
>  [<ffffffffb372a980>] apic_timer_interrupt+0x70/0x80
>  <EOI>  [<ffffffffb30d19aa>] ? do_raw_read_lock+0x1a/0x50
>  [<ffffffffb37294a3>] _raw_read_lock+0x43/0x50
>  [<ffffffffb329ee3e>] ? ext4_es_lookup_extent+0x5e/0x470
>  [<ffffffffb329ee3e>] ext4_es_lookup_extent+0x5e/0x470
>  [<ffffffffb32561eb>] ext4_map_blocks+0x5b/0x590
>  [<ffffffffb329e81c>] ? ext4_es_find_delayed_extent_range+0x42c/0x480
>  [<ffffffffb324f271>] ext4_llseek+0x271/0x410
>  [<ffffffffb30cb0fd>] ? trace_hardirqs_on+0xd/0x10
>  [<ffffffffb31cd339>] SyS_lseek+0x99/0xc0
>  [<ffffffffb3729b97>] system_call_fastpath+0x12/0x6f
> INFO: rcu_sched detected stalls on CPUs/tasks:
> 	(detected by 0, t=6502 jiffies, g=75215, c=75214, q=0)
> All QSes seen, last rcu_sched kthread activity 6502 (4295121467-4295114965), jiffies_till_next_fqs=1, root ->qsmask 0x0
> trinity-c21     R  running task    12768 20468  30399 0x0008000c
>  00000000000031e0 00000000f34c833f ffff88043d803da8 ffffffffb30abd15
>  ffffffffb30abc32 ffffffffb3c3b500 0000000000001966 ffff88043d817580
>  ffffffffb3c3b080 0000000000000000 ffff88043d803e28 ffffffffb30ef556
> Call Trace:
>  <IRQ>  [<ffffffffb30abd15>] sched_show_task+0x165/0x280
>  [<ffffffffb30abc32>] ? sched_show_task+0x82/0x280
>  [<ffffffffb30ef556>] rcu_check_callbacks+0xb26/0xb30
>  [<ffffffffb30f5389>] update_process_times+0x39/0x60
>  [<ffffffffb3107ef5>] tick_sched_handle.isra.20+0x25/0x60
>  [<ffffffffb3108191>] tick_sched_timer+0x41/0x80
>  [<ffffffffb30f643a>] __run_hrtimer+0xba/0x5f0
>  [<ffffffffb3108150>] ? tick_sched_do_timer+0x40/0x40
>  [<ffffffffb30f6e93>] hrtimer_interrupt+0x103/0x230
>  [<ffffffffb30b10e2>] ? vtime_common_account_irq_enter+0x32/0x50
>  [<ffffffffb3034fec>] local_apic_timer_interrupt+0x3c/0x70
>  [<ffffffffb372bf51>] smp_apic_timer_interrupt+0x41/0x60
>  [<ffffffffb372a980>] apic_timer_interrupt+0x70/0x80
>  <EOI>  [<ffffffffb30cde67>] ? lock_acquire+0xd7/0x270
>  [<ffffffffb329e466>] ? ext4_es_find_delayed_extent_range+0x76/0x480
>  [<ffffffffb372949b>] _raw_read_lock+0x3b/0x50
>  [<ffffffffb329e466>] ? ext4_es_find_delayed_extent_range+0x76/0x480
>  [<ffffffffb329e466>] ext4_es_find_delayed_extent_range+0x76/0x480
>  [<ffffffffb324f291>] ext4_llseek+0x291/0x410
>  [<ffffffffb30cb0fd>] ? trace_hardirqs_on+0xd/0x10
>  [<ffffffffb31cd339>] SyS_lseek+0x99/0xc0
>  [<ffffffffb3729b97>] system_call_fastpath+0x12/0x6f
> rcu_sched kthread starved for 6502 jiffies!

If you don't let RCU's grace-period kthreads run, they aren't going to
be able to help you much.  Could you please try building with
CONFIG_RCU_KTHREAD_PRIO=5 (say) and see if that helps?

							Thanx, Paul

> INFO: rcu_sched detected stalls on CPUs/tasks:
> 	(detected by 0, t=26007 jiffies, g=75215, c=75214, q=0)
> All QSes seen, last rcu_sched kthread activity 26007 (4295140972-4295114965), jiffies_till_next_fqs=1, root ->qsmask 0x0
> trinity-c21     R  running task    12768 20468  30399 0x0008000c
>  00000000000031e0 00000000f34c833f ffff88043d803da8 ffffffffb30abd15
>  ffffffffb30abc32 ffffffffb3c3b500 0000000000006597 ffff88043d817580
>  ffffffffb3c3b080 0000000000000000 ffff88043d803e28 ffffffffb30ef556
> Call Trace:
>  <IRQ>  [<ffffffffb30abd15>] sched_show_task+0x165/0x280
>  [<ffffffffb30abc32>] ? sched_show_task+0x82/0x280
>  [<ffffffffb30ef556>] rcu_check_callbacks+0xb26/0xb30
>  [<ffffffffb30f5389>] update_process_times+0x39/0x60
>  [<ffffffffb3107ef5>] tick_sched_handle.isra.20+0x25/0x60
>  [<ffffffffb3108191>] tick_sched_timer+0x41/0x80
>  [<ffffffffb30f643a>] __run_hrtimer+0xba/0x5f0
>  [<ffffffffb3108150>] ? tick_sched_do_timer+0x40/0x40
>  [<ffffffffb30f6e93>] hrtimer_interrupt+0x103/0x230
>  [<ffffffffb30b10e2>] ? vtime_common_account_irq_enter+0x32/0x50
>  [<ffffffffb3034fec>] local_apic_timer_interrupt+0x3c/0x70
>  [<ffffffffb372bf51>] smp_apic_timer_interrupt+0x41/0x60
>  [<ffffffffb372a980>] apic_timer_interrupt+0x70/0x80
>  <EOI>  [<ffffffffb30dfa5f>] ? debug_lockdep_rcu_enabled+0x2f/0x40
>  [<ffffffffb329e6bd>] ext4_es_find_delayed_extent_range+0x2cd/0x480
>  [<ffffffffb329e40a>] ? ext4_es_find_delayed_extent_range+0x1a/0x480
>  [<ffffffffb324f291>] ext4_llseek+0x291/0x410
>  [<ffffffffb30cb0fd>] ? trace_hardirqs_on+0xd/0x10
>  [<ffffffffb31cd339>] SyS_lseek+0x99/0xc0
>  [<ffffffffb3729b97>] system_call_fastpath+0x12/0x6f
> rcu_sched kthread starved for 26007 jiffies!
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
