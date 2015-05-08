From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: ext4_es_lookup_extent causing rcu stalls.
Date: Fri, 8 May 2015 09:02:01 -0700
Message-ID: <20150508160201.GT5381@linux.vnet.ibm.com>
References: <20150507143552.GA19619@codemonkey.org.uk>
 <20150507193611.GM5381@linux.vnet.ibm.com>
 <20150507222921.GA11085@codemonkey.org.uk>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Dave Jones <davej@codemonkey.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150507222921.GA11085@codemonkey.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, May 07, 2015 at 06:29:21PM -0400, Dave Jones wrote:
>  Content analysis details:   (-2.9 points, 5.0 required)
> 
>   pts rule name              description
>  ---- ---------------------- --------------------------------------------------
>  -1.0 ALL_TRUSTED            Passed through trusted hosts only via SMTP
>  -1.9 BAYES_00               BODY: Bayes spam probability is 0 to 1%
>                              [score: 0.0000]
> X-Authenticated-User: davej@codemonkey.org.uk
> X-ZLA-Header: unknown; 0
> X-ZLA-DetailInfo: BA=6.00003273; NDR=6.00000001; ZLA=6.00000002; ZF=6.00000004; ZB=6.00039413; ZH=6.00098335; ZP=6.00077780; ZU=6.00000001; UDB=6.00219514; UTC=2015-05-07 22:29:31
> x-cbid: 15050722-0037-0000-0000-000001281E1A
> X-IBM-ISS-SpamDetectors: Score=0.40962; BY=0.04766; FL=0; FP=0; FZ=0; HX=0;
>  KW=0; PH=0; RB=0; SC=0.40962; ST=0; TS=0; UL=0; ISC=
> X-IBM-ISS-DetailInfo:  BY=3.00003915; HX=3.00000235; KW=3.00000007;
>  PH=3.00000003; SC=3.00000078; SDB=6.00527008; UDB=6.00219514; UTC=2015-05-07
>  22:29:32
> X-TM-AS-MML: disable
> 
> On Thu, May 07, 2015 at 12:36:11PM -0700, Paul E. McKenney wrote:
> 
>  > > INFO: rcu_sched detected stalls on CPUs/tasks:
>  > > 	(detected by 0, t=6502 jiffies, g=75215, c=75214, q=0)
>  > > All QSes seen, last rcu_sched kthread activity 6502 (4295121467-4295114965), jiffies_till_next_fqs=1, root ->qsmask 0x0
>  > > trinity-c21     R  running task    12768 20468  30399 0x0008000c
>  > >  00000000000031e0 00000000f34c833f ffff88043d803da8 ffffffffb30abd15
>  > >  ffffffffb30abc32 ffffffffb3c3b500 0000000000001966 ffff88043d817580
>  > >  ffffffffb3c3b080 0000000000000000 ffff88043d803e28 ffffffffb30ef556
>  > > Call Trace:
>  > >  <IRQ>  [<ffffffffb30abd15>] sched_show_task+0x165/0x280
>  > >  [<ffffffffb30abc32>] ? sched_show_task+0x82/0x280
>  > >  [<ffffffffb30ef556>] rcu_check_callbacks+0xb26/0xb30
>  > >  [<ffffffffb30f5389>] update_process_times+0x39/0x60
>  > >  [<ffffffffb3107ef5>] tick_sched_handle.isra.20+0x25/0x60
>  > >  [<ffffffffb3108191>] tick_sched_timer+0x41/0x80
>  > >  [<ffffffffb30f643a>] __run_hrtimer+0xba/0x5f0
>  > >  [<ffffffffb3108150>] ? tick_sched_do_timer+0x40/0x40
>  > >  [<ffffffffb30f6e93>] hrtimer_interrupt+0x103/0x230
>  > >  [<ffffffffb30b10e2>] ? vtime_common_account_irq_enter+0x32/0x50
>  > >  [<ffffffffb3034fec>] local_apic_timer_interrupt+0x3c/0x70
>  > >  [<ffffffffb372bf51>] smp_apic_timer_interrupt+0x41/0x60
>  > >  [<ffffffffb372a980>] apic_timer_interrupt+0x70/0x80
>  > >  <EOI>  [<ffffffffb30cde67>] ? lock_acquire+0xd7/0x270
>  > >  [<ffffffffb329e466>] ? ext4_es_find_delayed_extent_range+0x76/0x480
>  > >  [<ffffffffb372949b>] _raw_read_lock+0x3b/0x50
>  > >  [<ffffffffb329e466>] ? ext4_es_find_delayed_extent_range+0x76/0x480
>  > >  [<ffffffffb329e466>] ext4_es_find_delayed_extent_range+0x76/0x480
>  > >  [<ffffffffb324f291>] ext4_llseek+0x291/0x410
>  > >  [<ffffffffb30cb0fd>] ? trace_hardirqs_on+0xd/0x10
>  > >  [<ffffffffb31cd339>] SyS_lseek+0x99/0xc0
>  > >  [<ffffffffb3729b97>] system_call_fastpath+0x12/0x6f
>  > > rcu_sched kthread starved for 6502 jiffies!
>  > 
>  > If you don't let RCU's grace-period kthreads run, they aren't going to
>  > be able to help you much.  Could you please try building with
>  > CONFIG_RCU_KTHREAD_PRIO=5 (say) and see if that helps?
> 
> Nope. Though the message is slightly different.
> 
> 
> INFO: rcu_sched self-detected stall on CPU
> 	1: (6499 ticks this GP) idle=5ed/140000000000001/0 softirq=6071/6071 fqs=6495 
> 	 (t=6500 jiffies g=17107 c=17106 q=0)
> Task dump for CPU 1:
> trinity-c6      R  running task    12576 26108    548 0x0008000c
>  0000000000003120 00000000aa7d3446 ffff88043d843d58 ffffffff8e0acb55
>  ffffffff8e0aca72 0000000000000001 0000000000000000 0000000000000001
>  ffffffff8ec3b0c0 0000000000000082 ffff88043d843d78 ffffffff8e0b090d
> Call Trace:
>  <IRQ>  [<ffffffff8e0acb55>] sched_show_task+0x165/0x280
>  [<ffffffff8e0aca72>] ? sched_show_task+0x82/0x280
>  [<ffffffff8e0b090d>] dump_cpu_task+0x3d/0x50
>  [<ffffffff8e0e4971>] rcu_dump_cpu_stacks+0x91/0xd0
>  [<ffffffff8e0f009c>] rcu_check_callbacks+0x7ec/0xb30
>  [<ffffffff8e10908e>] ? tick_do_update_jiffies64+0xde/0x140
>  [<ffffffff8e0f6299>] update_process_times+0x39/0x60
>  [<ffffffff8e108ed5>] tick_sched_handle.isra.20+0x25/0x60
>  [<ffffffff8e109171>] tick_sched_timer+0x41/0x80
>  [<ffffffff8e0f735a>] __run_hrtimer+0xba/0x5f0
>  [<ffffffff8e109130>] ? tick_sched_do_timer+0x40/0x40
>  [<ffffffff8e0f7db3>] hrtimer_interrupt+0x103/0x230
>  [<ffffffff8e0b1f42>] ? vtime_common_account_irq_enter+0x32/0x50
>  [<ffffffff8e0355dc>] local_apic_timer_interrupt+0x3c/0x70
>  [<ffffffff8e733251>] smp_apic_timer_interrupt+0x41/0x60
>  [<ffffffff8e731c80>] apic_timer_interrupt+0x70/0x80
>  <EOI>  [<ffffffff8e0cecc7>] ? lock_acquire+0xd7/0x270
>  [<ffffffff8e2a206e>] ? ext4_es_lookup_extent+0x5e/0x470
>  [<ffffffff8e73079b>] _raw_read_lock+0x3b/0x50
>  [<ffffffff8e2a206e>] ? ext4_es_lookup_extent+0x5e/0x470
>  [<ffffffff8e2a206e>] ext4_es_lookup_extent+0x5e/0x470
>  [<ffffffff8e25927b>] ext4_map_blocks+0x5b/0x590
>  [<ffffffff8e2a1a4c>] ? ext4_es_find_delayed_extent_range+0x42c/0x480
>  [<ffffffff8e252301>] ext4_llseek+0x271/0x410
>  [<ffffffff8e0cbf5d>] ? trace_hardirqs_on+0xd/0x10
>  [<ffffffff8e1cf479>] SyS_lseek+0x99/0xc0
>  [<ffffffff8e730e97>] system_call_fastpath+0x12/0x6f

OK, then I am going to guess either extreme lock contention or failure
to release the lock.  If you are running CONFIG_PROVE_LOCKING, that
would indicate contention rather than failure to release the lock.

							Thanx, Paul
