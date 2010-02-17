From: James Cloos <cloos@jhcloos.com>
Subject: Re: [Regression] Filesystem I/O is CPU-bound in
	rc7 and rc8
Date: Wed, 17 Feb 2010 15:04:47 -0500
Message-ID: <m3d403632g.fsf@lugabout.jhcloos.org>
References: <m3pr48bjfg.fsf@lugabout.jhcloos.org>
	<20100215154516.GB11057@think>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>
To: linux-kernel@vger.kernel.org
Return-path: <jfs-discussion-bounces@lists.sourceforge.net>
In-Reply-To: <20100215154516.GB11057@think> (Chris Mason's message of "Mon, 15
	Feb 2010 10:45:16 -0500")
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/jfs-discussion>,
	<mailto:jfs-discussion-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=jfs-discussion>
List-Post: <mailto:jfs-discussion@lists.sourceforge.net>
List-Help: <mailto:jfs-discussion-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/jfs-discussion>,
	<mailto:jfs-discussion-request@lists.sourceforge.net?subject=subscribe>
Errors-To: jfs-discussion-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

While getting re-aquainted with perf, and after upgrading to the current
version, I see that do_page_fault, unmap_vmas, get_page_from_freelist,
handle_mm_fault, __do_fault and T.1339 tend to get the most time when the
kernel is spinning.

T.1339 is in this part of kallsyms:

,----< grep -E -C9 ^c1027750 /proc/kallsyms >
| c10266a0 T sched_setscheduler_nocheck
| c10266c0 T sched_setscheduler
| c10266e0 t do_sched_setscheduler
| c1026770 T sys_sched_setparam
| c1026790 T sys_sched_setscheduler
| c10267c0 T sched_fork
| c1026900 T task_oncpu_function_call
| c1026960 T print_cfs_rq
| c1027640 T scheduler_tick
| c1027750 t T.1339
| c10277f0 T schedule_tail
| c1027830 t ftrace_raw_output_sched_kthread_stop
| c1027930 t ftrace_raw_output_sched_kthread_stop_ret
| c1027a30 t ftrace_raw_output_sched_wait_task
| c1027b40 t ftrace_raw_output_sched_switch
| c1027c90 t ftrace_raw_output_sched_migrate_task
| c1027da0 t ftrace_raw_output_sched_process_wait
| c1027eb0 t ftrace_raw_output_sched_process_fork
| c1027fc0 t ftrace_raw_output_sched_stat_runtime
`----

suggesting that T.1339 is part of sched.

This leaves the impression that the issue is related to either
scheduling or paging.

I don't see any commits in the rc6..rc7 timeframe which stand out
as likely suspects.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6

------------------------------------------------------------------------------
SOLARIS 10 is the OS for Data Centers - provides features such as DTrace,
Predictive Self Healing and Award Winning ZFS. Get Solaris 10 NOW
http://p.sf.net/sfu/solaris-dev2dev
