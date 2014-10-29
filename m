From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: RCU related deadlock in AIO?   (in 3.18-rc2)
Date: Wed, 29 Oct 2014 09:21:34 -0700
Message-ID: <20141029162134.GA23989@linux.vnet.ibm.com>
References: <nsxk33jjfsw.fsf@closure.thunk.org>
 <20141029125751.GM5718@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-aio@kvack.org,
        Zach Brown <zab@zabbo.net>, Benjamin LaHaise <bcrl@kvack.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20141029125751.GM5718@linux.vnet.ibm.com>
Sender: owner-linux-aio@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 29, 2014 at 05:57:51AM -0700, Paul E. McKenney wrote:
> On Wed, Oct 29, 2014 at 07:06:39AM -0400, Theodore Ts'o wrote:
> > 
> > I have a vague memory of seeing discussion about a stack trace that
> > looks similar to this in the past few weeks.  Does this ring a bell at
> > all?
> > 
> > The following hang happened while running xfstests generic/323 under
> > ext4 in no-journal mode, running on a 3.18-rc2 kernel.  This is a
> > recently added test, to deal with a proble which I thought had already
> > been fixed in mainline.
> > 
> > # Run aio-last-ref-held-by-io - last put of ioctx not in process
> > # context. We've had a couple of instances in the past where having the
> > # last reference to an ioctx be held by the IO (instead of the
> > # process) would cause problems (hung system, crashes).

Oh, and there is one other RCU issue that I am currently chasing.
However, it shows up about once every hundred hours of rcutorture time
(I don't yet have a statistically valid sample), and only occurs if
CONFIG_RCU_BOOST=y and there is lots of CPU hotplug activity.  It appears
to have been latent for some years, and appears to have been exposed by
a recent rcutorture change that dumps 60,000 callbacks in three bursts
of 20,000 each, with each burst separated by one jiffy.  That will teach
me not to improve rcutorture!!!  ;-)

Given that RCU priority boosting is typically used as a "guardrail" for
real-time workloads which tend not to do CPU-hotplug operations except
at initialization time (to "clean" the worker CPUs of extraneous
processing, believe it or not), I doubt that anyone is running into
this.  But, just in case!

I don't have root cause for this one yet, much less a patch.  Given
the low probability of occurrence, it may be some time before I have
a fix that I have any confidence in.  ;-)

							Thanx, Paul

> This looks different to me, but there have been some RCU-related hang
> issues over the past week.  Here are the fixes, which are in my -rcu tree
> at git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git:
> 
> b2c4623dcd07 (rcu: More on deadlock between CPU hotplug and expedited grace periods)
> 
> 	But I don't see any sign of CPU hotplug in your dmesg.
> 
> d7e29933969e (rcu: Make rcu_barrier() understand about missing rcuo kthreads)
> 
> 	But in this case, I would expect to see _rcu_barrier() in your
> 	stack trace.
> 
> 61687ee70952 (rcu: Kick rcuo kthreads after their CPU goes offline)
> 
> 	As far as I can tell, this one is currently strictly theoretical.
> 
> 659cddc70090 (rcu: Fix for rcuo online-time-creation reorganization bug)
> 
> 	For this one to happen, your system has to bring CPUs online
> 	in non-numerical order.
> 
> But despite my doubts, we all know that bugs can manifest themselves
> in unexpected ways, so please do feel free to give them a try!
> 
> > Thanks,
> > 
> >                                                 - Ted
> > 
> > generic/323 123s ...	[06:42:18][30020.393779] ------------[ cut here ]------------
> > [30020.394962] WARNING: CPU: 1 PID: 0 at /usr/projects/linux/ext4/lib/percpu-refcount.c:151 percpu_ref_switch_to_atomic_rcu+0x9f/0xbc()
> > [30020.397073] percpu ref (free_ioctx_reqs) <= 0 (-65534) after switching to atomic
> 
> All that said, this looks to me like a mismatched reference count, namely
> releasing a reference that was never acquired, thus forcing the reference
> counter to go negative.  Might that be the real root cause?
> 
> 							Thanx, Paul
> 
> > [30020.397073] Modules linked in:
> > [30020.397073] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.18.0-rc2-00005-gb790865 #2277
> > [30020.401678] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> > [30020.402522]  00000000 00000000 f553ff28 c088aba8 f553ff54 f553ff44 c0170af6 00000097
> > [30020.406004]  c046cf41 df614874 ca3cd9f8 7fff0004 f553ff5c c0170b38 00000009 f553ff54
> > [30020.408552]  c0b9dcf8 f553ff70 f553ff88 c046cf41 c0b9dc8d 00000097 c0b9dcf8 c028233d
> > [30020.410484] Call Trace:
> > [30020.410828]  [<c088aba8>] dump_stack+0x48/0x60
> > [30020.411578]  [<c0170af6>] warn_slowpath_common+0x6c/0x83
> > [30020.412701]  [<c046cf41>] ? percpu_ref_switch_to_atomic_rcu+0x9f/0xbc
> > [30020.413541]  [<c0170b38>] warn_slowpath_fmt+0x2b/0x2f
> > [30020.413715]  [<c046cf41>] percpu_ref_switch_to_atomic_rcu+0x9f/0xbc
> > [30020.414267]  [<c028233d>] ? rcu_lock_acquire+0x1c/0x1c
> > [30020.415101]  [<c01b767b>] rcu_process_callbacks+0x2b5/0x433
> > [30020.415763]  [<c01b767b>] ? rcu_process_callbacks+0x2b5/0x433
> > [30020.417024]  [<c046cea2>] ? percpu_ref_reinit+0x50/0x50
> > [30020.417273]  [<c0173f8f>] ? __local_bh_disable_ip+0x6e/0x6e
> > [30020.417959]  [<c01740fc>] __do_softirq+0x16d/0x376
> > [30020.418688]  [<c0173f8f>] ? __local_bh_disable_ip+0x6e/0x6e
> > [30020.419324]  [<c01381ec>] do_softirq_own_stack+0x26/0x2c
> > [30020.420372]  <IRQ>  [<c01744f9>] irq_exit+0x42/0x8f
> > [30020.420796]  [<c0137b94>] do_IRQ+0x89/0x9d
> > [30020.421606]  [<c08943f1>] common_interrupt+0x31/0x38
> > [30020.422162]  [<c013007b>] ? add_atomic_switch_msr+0x173/0x173
> > [30020.422850]  [<c0164b9c>] ? native_safe_halt+0x5/0x7
> > [30020.423696]  [<c013dee4>] default_idle+0x22/0x4b
> > [30020.424321]  [<c013e49a>] arch_cpu_idle+0xe/0x10
> > [30020.424967]  [<c019b7f0>] cpu_startup_entry+0x130/0x250
> > [30020.425604]  [<c015a3a3>] start_secondary+0x15d/0x166
> > [30020.426333] ---[ end trace 4f7947d25059a4b4 ]---
> > [30240.260397] INFO: task aio-last-ref-he:9183 blocked for more than 120 seconds.[30240.261418]       Tainted: G        W      3.18.0-rc2-00005-gb790865 #2277
> > [30240.262399] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [30240.263575]  d7e99e78 00000046 c0f6b280 c0f6b280 a9372026 00001b4d cdfc5800 00001b4d
> > [30240.264979]  d9758350 f6250880 d7e99e60 c0192666 000396f0 00000000 a9371bab 00001b4d
> > [30240.266194]  a9371cc6 00001b4d a9371bab 00001b4d d97588c4 c0f6b880 00000001 d7e99e8c
> > [30240.267449] Call Trace:
> > [30240.267795]  [<c0192666>] ? sched_clock_local+0x10/0x10e
> > [30240.268515]  [<c019298f>] ? sched_clock_cpu+0xd1/0xec
> > [30240.269207]  [<c0192666>] ? sched_clock_local+0x10/0x10e
> > [30240.269929]  [<c088fdaf>] schedule+0x5a/0x5c
> > [30240.270530]  [<c0892b2b>] schedule_timeout+0x1a/0x9c
> > [30240.271245]  [<c01929f4>] ? local_clock+0x18/0x22
> > [30240.271890]  [<c01a0085>] ? lock_release_holdtime.part.25+0x60/0x6d
> > [30240.272736]  [<c089343b>] ? _raw_spin_unlock_irq+0x27/0x36
> > [30240.273480]  [<c01a1a20>] ? trace_hardirqs_on_caller+0x15f/0x17a
> > [30240.274329]  [<c01a1a46>] ? trace_hardirqs_on+0xb/0xd
> > [30240.275054]  [<c0893440>] ? _raw_spin_unlock_irq+0x2c/0x36
> > [30240.275798]  [<c0890584>] __wait_for_common+0xcb/0xf5
> > [30240.276485]  [<c0892b11>] ? console_conditional_schedule+0x29/0x29
> > [30240.277343]  [<c01909aa>] ? wake_up_state+0x11/0x11
> > [30240.278016]  [<c08905c7>] wait_for_completion+0x19/0x1c
> > [30240.278727]  [<c0282f60>] SYSC_io_destroy+0x7a/0xaf
> > [30240.279409]  [<c08904ea>] ? __wait_for_common+0x31/0xf5
> > [30240.280116]  [<c02837dc>] SyS_io_destroy+0x10/0x12
> > [30240.280815]  [<c046895a>] ? trace_hardirqs_on_thunk+0xc/0x10
> > [30240.281583]  [<c02837dc>] ? SyS_io_destroy+0x10/0x12
> > [30240.282271]  [<c0893e2a>] syscall_call+0x7/0x7
> > [30240.282881]  [<c0890000>] ? schedule_preempt_disabled+0xd/0x1d
> > [30240.283692] no locks held by aio-last-ref-he/9183.
> > 

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
