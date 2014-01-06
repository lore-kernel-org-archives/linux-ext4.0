From: Sandeep Joshi <sanjos100@gmail.com>
Subject: Re: process hangs in ext4_sync_file
Date: Mon, 6 Jan 2014 15:58:58 +0530
Message-ID: <CAEfL3K=vEaZ+-pj=QCogJvcvf0xgsEsAT9DX8eExMjSiNmcNLQ@mail.gmail.com>
References: <CAEfL3KniKZNzehPH1Z4eWhhNF_RHrE4vHoRTHDPrfYj4t_2LtA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:41286 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbaAFK27 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Jan 2014 05:28:59 -0500
Received: by mail-ie0-f177.google.com with SMTP id tp5so17535000ieb.8
        for <linux-ext4@vger.kernel.org>; Mon, 06 Jan 2014 02:28:59 -0800 (PST)
In-Reply-To: <CAEfL3KniKZNzehPH1Z4eWhhNF_RHrE4vHoRTHDPrfYj4t_2LtA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I reported a problem with process hanging in ext4 sync on a SSD a few weeks ago
See this thread http://www.spinics.net/lists/linux-ext4/msg40369.html

That was on a SSD with discard option enabled.  I was asked to turn
that off which I did and never hit the issue again.

Today I saw the same problem on an ext4 filesystem mounted on a loop
device.  The stack is *identical*.

This is the stack of the hanging thread from /proc/self/task/*/stack

[<ffffffffffffffff>] 0xffffffffffffffff
[<ffffffff812763b5>] jbd2_log_wait_commit+0xb5/0x130
[<ffffffff81278d13>] jbd2_complete_transaction+0x53/0x90
[<ffffffff8121ed3d>] ext4_sync_file+0x1ed/0x2b0
[<ffffffff811b6f6b>] vfs_fsync+0x2b/0x40
[<ffffffff81158fd4>] sys_msync+0x144/0x1d0
[<ffffffff816a5ae9>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff

And I also have the output of "echo w > /proc/sysrq-trigger".

[Mon Jan  6 15:08:12 2014] SysRq : Show Blocked State
[Mon Jan  6 15:08:12 2014]   task                        PC stack   pid father
[Mon Jan  6 15:08:12 2014] jbd2/sda2-8     D ffffffff8180cbe0     0
253      2 0x00000000
[Mon Jan  6 15:08:12 2014]  ffff880036637bd0 0000000000000046
0000000000000008 0000000000000001
[Mon Jan  6 15:08:12 2014]  ffff880036637fd8 ffff880036637fd8
ffff880036637fd8 00000000000139c0
[Mon Jan  6 15:08:12 2014]  ffffffff81c13460 ffff8800369dc500
ffff880036637bb0 ffff880100214258
[Mon Jan  6 15:08:12 2014] Call Trace:
[Mon Jan  6 15:08:12 2014]  [<ffffffff811b9340>] ? __wait_on_buffer+0x30/0x30
[Mon Jan  6 15:08:12 2014]  [<ffffffff8169c349>] schedule+0x29/0x70
[Mon Jan  6 15:08:12 2014]  [<ffffffff8169c41f>] io_schedule+0x8f/0xd0
[Mon Jan  6 15:08:12 2014]  [<ffffffff811b934e>] sleep_on_buffer+0xe/0x20
[Mon Jan  6 15:08:12 2014]  [<ffffffff8169acef>] __wait_on_bit+0x5f/0x90
[Mon Jan  6 15:08:12 2014]  [<ffffffff811b9340>] ? __wait_on_buffer+0x30/0x30
[Mon Jan  6 15:08:12 2014]  [<ffffffff8169ad9c>]
out_of_line_wait_on_bit+0x7c/0x90
[Mon Jan  6 15:08:12 2014]  [<ffffffff810785e0>] ?
autoremove_wake_function+0x40/0x40
[Mon Jan  6 15:08:12 2014]  [<ffffffff811b933e>] __wait_on_buffer+0x2e/0x30
[Mon Jan  6 15:08:12 2014]  [<ffffffff81272406>]
jbd2_journal_commit_transaction+0x1216/0x13a0
[Mon Jan  6 15:08:12 2014]  [<ffffffff8108382b>] ?
perf_event_task_sched_out+0x8b/0xa0
[Mon Jan  6 15:08:12 2014]  [<ffffffff81064952>] ?
try_to_del_timer_sync+0x92/0x130
[Mon Jan  6 15:08:12 2014]  [<ffffffff812765d6>] kjournald2+0xb6/0x240
[Mon Jan  6 15:08:12 2014]  [<ffffffff810785a0>] ? add_wait_queue+0x60/0x60
[Mon Jan  6 15:08:12 2014]  [<ffffffff81276520>] ? commit_timeout+0x10/0x10
[Mon Jan  6 15:08:12 2014]  [<ffffffff81077cc3>] kthread+0x93/0xa0
[Mon Jan  6 15:08:12 2014]  [<ffffffff816a6de4>] kernel_thread_helper+0x4/0x10
[Mon Jan  6 15:08:12 2014]  [<ffffffff81077c30>] ?
flush_kthread_worker+0xb0/0xb0
[Mon Jan  6 15:08:12 2014]  [<ffffffff816a6de0>] ? gs_change+0x13/0x13
[Mon Jan  6 15:08:12 2014] SnapMain_0      D ffffffff8180cbe0     0
3633   2994 0x00000000
[Mon Jan  6 15:08:12 2014]  ffff88002ba4bdf8 0000000000000086
ffff88002ba4bd98 0000000300000001
[Mon Jan  6 15:08:12 2014]  ffff88002ba4bfd8 ffff88002ba4bfd8
ffff88002ba4bfd8 00000000000139c0
[Mon Jan  6 15:08:12 2014]  ffffffff81c13460 ffff88001e469700
ffff88002ba4be08 ffff880036964800
[Mon Jan  6 15:08:12 2014] Call Trace:
[Mon Jan  6 15:08:12 2014]  [<ffffffff8169c349>] schedule+0x29/0x70
[Mon Jan  6 15:08:12 2014]  [<ffffffff812763b5>] jbd2_log_wait_commit+0xb5/0x130
[Mon Jan  6 15:08:12 2014]  [<ffffffff810785a0>] ? add_wait_queue+0x60/0x60
[Mon Jan  6 15:08:12 2014]  [<ffffffff81278d13>]
jbd2_complete_transaction+0x53/0x90
[Mon Jan  6 15:08:12 2014]  [<ffffffff8121ed3d>] ext4_sync_file+0x1ed/0x2b0
[Mon Jan  6 15:08:12 2014]  [<ffffffff811b6f6b>] vfs_fsync+0x2b/0x40
[Mon Jan  6 15:08:12 2014]  [<ffffffff81158fd4>] sys_msync+0x144/0x1d0
[Mon Jan  6 15:08:12 2014]  [<ffffffff816a5ae9>] system_call_fastpath+0x16/0x1b
[Mon Jan  6 15:08:12 2014] Sched Debug Version: v0.10,
3.5.0-36-generic #57~precise1-Ubuntu
[Mon Jan  6 15:08:12 2014] ktime                                   :
7013149.339565
[Mon Jan  6 15:08:12 2014] sched_clk                               :
7002828.965208
[Mon Jan  6 15:08:12 2014] cpu_clk                                 :
7002828.965308
[Mon Jan  6 15:08:12 2014] jiffies                                 : 4296645583
[Mon Jan  6 15:08:12 2014] sched_clock_stable                      : 1

[Mon Jan  6 15:08:12 2014] sysctl_sched
[Mon Jan  6 15:08:12 2014]   .sysctl_sched_latency
: 18.000000
[Mon Jan  6 15:08:12 2014]   .sysctl_sched_min_granularity            : 2.250000
[Mon Jan  6 15:08:12 2014]   .sysctl_sched_wakeup_granularity         : 3.000000
[Mon Jan  6 15:08:12 2014]   .sysctl_sched_child_runs_first           : 0
[Mon Jan  6 15:08:12 2014]   .sysctl_sched_features                   : 24119
[Mon Jan  6 15:08:12 2014]   .sysctl_sched_tunable_scaling
: 1 (logaritmic)

[Mon Jan  6 15:08:12 2014] cpu#0, 2095.285 MHz
[Mon Jan  6 15:08:12 2014]   .nr_running                    : 1
[Mon Jan  6 15:08:12 2014]   .load                          : 453
[Mon Jan  6 15:08:12 2014]   .nr_switches                   : 2718557
[Mon Jan  6 15:08:12 2014]   .nr_load_updates               : 337562
[Mon Jan  6 15:08:12 2014]   .nr_uninterruptible            : -25773
[Mon Jan  6 15:08:12 2014]   .next_balance                  : 4296.645597
[Mon Jan  6 15:08:12 2014]   .curr->pid                     : 4294
[Mon Jan  6 15:08:12 2014]   .clock                         : 7002828.754709
[Mon Jan  6 15:08:12 2014]   .cpu_load[0]                   : 453
[Mon Jan  6 15:08:12 2014]   .cpu_load[1]                   : 296
[Mon Jan  6 15:08:12 2014]   .cpu_load[2]                   : 166
[Mon Jan  6 15:08:12 2014]   .cpu_load[3]                   : 88
[Mon Jan  6 15:08:12 2014]   .cpu_load[4]                   : 46
[Mon Jan  6 15:08:12 2014]   .yld_count                     : 0
[Mon Jan  6 15:08:12 2014]   .sched_count                   : 2722416
[Mon Jan  6 15:08:12 2014]   .sched_goidle                  : 1243880
[Mon Jan  6 15:08:12 2014]   .avg_idle                      : 1000000
[Mon Jan  6 15:08:12 2014]   .ttwu_count                    : 1520306
[Mon Jan  6 15:08:12 2014]   .ttwu_local                    : 899801

[Mon Jan  6 15:08:12 2014] cfs_rq[0]:/autogroup-161
[Mon Jan  6 15:08:12 2014]   .exec_clock                    : 8985.839170
[Mon Jan  6 15:08:12 2014]   .MIN_vruntime                  : 0.000001
[Mon Jan  6 15:08:12 2014]   .min_vruntime                  : 9156.582730
[Mon Jan  6 15:08:12 2014]   .max_vruntime                  : 0.000001
[Mon Jan  6 15:08:12 2014]   .spread                        : 0.000000
[Mon Jan  6 15:08:12 2014]   .spread0                       : -375467.512247
[Mon Jan  6 15:08:12 2014]   .nr_spread_over                : 52
[Mon Jan  6 15:08:12 2014]   .nr_running                    : 1
[Mon Jan  6 15:08:12 2014]   .load                          : 1024
[Mon Jan  6 15:08:12 2014]   .load_avg                      : 6419.983872
[Mon Jan  6 15:08:12 2014]   .load_period                   : 6.136326
[Mon Jan  6 15:08:12 2014]   .load_contrib                  : 1023
[Mon Jan  6 15:08:12 2014]   .load_tg                       : 1772
[Mon Jan  6 15:08:12 2014]   .se->exec_start                : 7002828.754709
[Mon Jan  6 15:08:12 2014]   .se->vruntime                  : 384624.094977
[Mon Jan  6 15:08:12 2014]   .se->sum_exec_runtime          : 8987.072928
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_start     : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.sleep_start    : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.block_start    : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.sleep_max      : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.block_max      : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.exec_max       : 4.014519
[Mon Jan  6 15:08:12 2014]   .se->statistics.slice_max      : 8.593618
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_max       : 3.657385
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_sum       : 43.378137
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_count     : 4076
[Mon Jan  6 15:08:12 2014]   .se->load.weight               : 453

[Mon Jan  6 15:08:12 2014] cfs_rq[0]:/autogroup-139
[Mon Jan  6 15:08:12 2014]   .exec_clock                    : 625.581004
[Mon Jan  6 15:08:12 2014]   .MIN_vruntime                  : 0.000001
[Mon Jan  6 15:08:12 2014]   .min_vruntime                  : 623.811869
[Mon Jan  6 15:08:12 2014]   .max_vruntime                  : 0.000001
[Mon Jan  6 15:08:12 2014]   .spread                        : 0.000000
[Mon Jan  6 15:08:12 2014]   .spread0                       : -384000.283108
[Mon Jan  6 15:08:12 2014]   .nr_spread_over                : 0
[Mon Jan  6 15:08:12 2014]   .nr_running                    : 0
[Mon Jan  6 15:08:12 2014]   .load                          : 0
[Mon Jan  6 15:08:12 2014]   .load_avg                      : 2559.999744
[Mon Jan  6 15:08:12 2014]   .load_period                   : 6.946394
[Mon Jan  6 15:08:12 2014]   .load_contrib                  : 368
[Mon Jan  6 15:08:12 2014]   .load_tg                       : 368
[Mon Jan  6 15:08:12 2014]   .se->exec_start                : 7002814.758487
[Mon Jan  6 15:08:12 2014]   .se->vruntime                  : 384594.985269
[Mon Jan  6 15:08:12 2014]   .se->sum_exec_runtime          : 626.803838
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_start     : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.sleep_start    : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.block_start    : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.sleep_max      : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.block_max      : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.exec_max       : 3.997610
[Mon Jan  6 15:08:12 2014]   .se->statistics.slice_max      : 3.936548
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_max       : 5.877198
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_sum       : 172.946964
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_count     : 3130
[Mon Jan  6 15:08:12 2014]   .se->load.weight               : 2

[Mon Jan  6 15:08:12 2014] cfs_rq[0]:/autogroup-135
[Mon Jan  6 15:08:12 2014]   .exec_clock                    : 30171.980622
[Mon Jan  6 15:08:12 2014]   .MIN_vruntime                  : 0.000001
[Mon Jan  6 15:08:12 2014]   .min_vruntime                  : 154916.630835
[Mon Jan  6 15:08:12 2014]   .max_vruntime                  : 0.000001
[Mon Jan  6 15:08:12 2014]   .spread                        : 0.000000
[Mon Jan  6 15:08:12 2014]   .spread0                       : -229707.464142
[Mon Jan  6 15:08:12 2014]   .nr_spread_over                : 24
[Mon Jan  6 15:08:12 2014]   .nr_running                    : 0
[Mon Jan  6 15:08:12 2014]   .load                          : 0
[Mon Jan  6 15:08:12 2014]   .load_avg                      : 1397.520512
[Mon Jan  6 15:08:12 2014]   .load_period                   : 7.120098
[Mon Jan  6 15:08:12 2014]   .load_contrib                  : 196
[Mon Jan  6 15:08:12 2014]   .load_tg                       : 1402
[Mon Jan  6 15:08:12 2014]   .se->exec_start                : 7002815.322518
[Mon Jan  6 15:08:12 2014]   .se->vruntime                  : 384615.094977
[Mon Jan  6 15:08:12 2014]   .se->sum_exec_runtime          : 30184.747915
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_start     : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.sleep_start    : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.block_start    : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.sleep_max      : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.block_max      : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.exec_max       : 5.122189
[Mon Jan  6 15:08:12 2014]   .se->statistics.slice_max      : 6.577029
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_max       : 15.976693
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_sum       : 1290.827084
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_count     : 83714
[Mon Jan  6 15:08:12 2014]   .se->load.weight               : 2

[Mon Jan  6 15:08:12 2014] cfs_rq[0]:/
[Mon Jan  6 15:08:12 2014]   .exec_clock                    : 313751.543656
[Mon Jan  6 15:08:12 2014]   .MIN_vruntime                  : 0.000001
[Mon Jan  6 15:08:12 2014]   .min_vruntime                  : 384624.094977
[Mon Jan  6 15:08:12 2014]   .max_vruntime                  : 0.000001
[Mon Jan  6 15:08:12 2014]   .spread                        : 0.000000
[Mon Jan  6 15:08:12 2014]   .spread0                       : 0.000000
[Mon Jan  6 15:08:12 2014]   .nr_spread_over                : 93
[Mon Jan  6 15:08:12 2014]   .nr_running                    : 1
[Mon Jan  6 15:08:12 2014]   .load                          : 453
[Mon Jan  6 15:08:12 2014]   .load_avg                      : 0.000000
[Mon Jan  6 15:08:12 2014]   .load_period                   : 0.000000
[Mon Jan  6 15:08:12 2014]   .load_contrib                  : 0
[Mon Jan  6 15:08:12 2014]   .load_tg                       : 0

[Mon Jan  6 15:08:12 2014] rt_rq[0]:/
[Mon Jan  6 15:08:12 2014]   .rt_nr_running                 : 0
[Mon Jan  6 15:08:12 2014]   .rt_throttled                  : 0
[Mon Jan  6 15:08:12 2014]   .rt_time                       : 0.000000
[Mon Jan  6 15:08:12 2014]   .rt_runtime                    : 950.000000

[Mon Jan  6 15:08:12 2014] runnable tasks:
[Mon Jan  6 15:08:12 2014]             task   PID         tree-key
switches  prio     exec-runtime         sum-exec        sum-sleep
[Mon Jan  6 15:08:12 2014]
----------------------------------------------------------------------------------------------------------
[Mon Jan  6 15:08:12 2014] R             sh  4294      9156.582730
    0   120      9156.582730         1.843599         0.000000
/autogroup-161

[Mon Jan  6 15:08:12 2014] cpu#1, 2095.285 MHz
[Mon Jan  6 15:08:12 2014]   .nr_running                    : 0
[Mon Jan  6 15:08:12 2014]   .load                          : 0
[Mon Jan  6 15:08:12 2014]   .nr_switches                   : 1868375
[Mon Jan  6 15:08:12 2014]   .nr_load_updates               : 286473
[Mon Jan  6 15:08:12 2014]   .nr_uninterruptible            : 17269
[Mon Jan  6 15:08:12 2014]   .next_balance                  : 4296.645584
[Mon Jan  6 15:08:12 2014]   .curr->pid                     : 0
[Mon Jan  6 15:08:12 2014]   .clock                         : 7002827.654865
[Mon Jan  6 15:08:12 2014]   .cpu_load[0]                   : 0
[Mon Jan  6 15:08:12 2014]   .cpu_load[1]                   : 0
[Mon Jan  6 15:08:12 2014]   .cpu_load[2]                   : 0
[Mon Jan  6 15:08:12 2014]   .cpu_load[3]                   : 0
[Mon Jan  6 15:08:12 2014]   .cpu_load[4]                   : 0
[Mon Jan  6 15:08:12 2014]   .yld_count                     : 0
[Mon Jan  6 15:08:12 2014]   .sched_count                   : 1872086
[Mon Jan  6 15:08:12 2014]   .sched_goidle                  : 852505
[Mon Jan  6 15:08:12 2014]   .avg_idle                      : 935618
[Mon Jan  6 15:08:12 2014]   .ttwu_count                    : 914151
[Mon Jan  6 15:08:12 2014]   .ttwu_local                    : 423442

[Mon Jan  6 15:08:12 2014] cfs_rq[1]:/autogroup-83
[Mon Jan  6 15:08:12 2014]   .exec_clock                    : 90.115520
[Mon Jan  6 15:08:12 2014]   .MIN_vruntime                  : 0.000001
[Mon Jan  6 15:08:12 2014]   .min_vruntime                  : 65.872022
[Mon Jan  6 15:08:12 2014]   .max_vruntime                  : 0.000001
[Mon Jan  6 15:08:12 2014]   .spread                        : 0.000000
[Mon Jan  6 15:08:12 2014]   .spread0                       : -384558.222955
[Mon Jan  6 15:08:12 2014]   .nr_spread_over                : 0
[Mon Jan  6 15:08:12 2014]   .nr_running                    : 0
[Mon Jan  6 15:08:12 2014]   .load                          : 0
[Mon Jan  6 15:08:12 2014]   .load_avg                      : 5178.837504
[Mon Jan  6 15:08:12 2014]   .load_period                   : 8.080554
[Mon Jan  6 15:08:12 2014]   .load_contrib                  : 640
[Mon Jan  6 15:08:12 2014]   .load_tg                       : 1610
[Mon Jan  6 15:08:12 2014]   .se->exec_start                : 7002825.393509
[Mon Jan  6 15:08:12 2014]   .se->vruntime                  : 215987.420691
[Mon Jan  6 15:08:12 2014]   .se->sum_exec_runtime          : 90.153425
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_start     : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.sleep_start    : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.block_start    : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.sleep_max      : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.block_max      : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.exec_max       : 3.992597
[Mon Jan  6 15:08:12 2014]   .se->statistics.slice_max      : 1.675316
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_max       : 2.136037
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_sum       : 5.079449
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_count     : 327
[Mon Jan  6 15:08:12 2014]   .se->load.weight               : 2

[Mon Jan  6 15:08:12 2014] cfs_rq[1]:/autogroup-161
[Mon Jan  6 15:08:12 2014]   .exec_clock                    : 5098.713594
[Mon Jan  6 15:08:12 2014]   .MIN_vruntime                  : 0.000001
[Mon Jan  6 15:08:12 2014]   .min_vruntime                  : 5185.878267
[Mon Jan  6 15:08:12 2014]   .max_vruntime                  : 0.000001
[Mon Jan  6 15:08:12 2014]   .spread                        : 0.000000
[Mon Jan  6 15:08:12 2014]   .spread0                       : -379438.216710
[Mon Jan  6 15:08:12 2014]   .nr_spread_over                : 43
[Mon Jan  6 15:08:12 2014]   .nr_running                    : 0
[Mon Jan  6 15:08:12 2014]   .load                          : 0
[Mon Jan  6 15:08:12 2014]   .load_avg                      : 1279.999872
[Mon Jan  6 15:08:12 2014]   .load_period                   : 5.314134
[Mon Jan  6 15:08:12 2014]   .load_contrib                  : 240
[Mon Jan  6 15:08:12 2014]   .load_tg                       : 1763
[Mon Jan  6 15:08:12 2014]   .se->exec_start                : 7002815.347677
[Mon Jan  6 15:08:12 2014]   .se->vruntime                  : 215987.687120
[Mon Jan  6 15:08:12 2014]   .se->sum_exec_runtime          : 5098.752334
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_start     : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.sleep_start    : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.block_start    : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.sleep_max      : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.block_max      : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.exec_max       : 4.045003
[Mon Jan  6 15:08:12 2014]   .se->statistics.slice_max      : 10.320001
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_max       : 2.422401
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_sum       : 19.870420
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_count     : 2336
[Mon Jan  6 15:08:12 2014]   .se->load.weight               : 2

[Mon Jan  6 15:08:12 2014] cfs_rq[1]:/autogroup-137
[Mon Jan  6 15:08:12 2014]   .exec_clock                    : 6656.794153
[Mon Jan  6 15:08:12 2014]   .MIN_vruntime                  : 0.000001
[Mon Jan  6 15:08:12 2014]   .min_vruntime                  : 4693.791136
[Mon Jan  6 15:08:12 2014]   .max_vruntime                  : 0.000001
[Mon Jan  6 15:08:12 2014]   .spread                        : 0.000000
[Mon Jan  6 15:08:12 2014]   .spread0                       : -379930.303841
[Mon Jan  6 15:08:12 2014]   .nr_spread_over                : 37
[Mon Jan  6 15:08:12 2014]   .nr_running                    : 0
[Mon Jan  6 15:08:12 2014]   .load                          : 0
[Mon Jan  6 15:08:12 2014]   .load_avg                      : 1279.999872
[Mon Jan  6 15:08:12 2014]   .load_period                   : 5.449662
[Mon Jan  6 15:08:12 2014]   .load_contrib                  : 234
[Mon Jan  6 15:08:12 2014]   .load_tg                       : 234
[Mon Jan  6 15:08:12 2014]   .se->exec_start                : 7002814.619804
[Mon Jan  6 15:08:12 2014]   .se->vruntime                  : 215987.077880
[Mon Jan  6 15:08:12 2014]   .se->sum_exec_runtime          : 6663.179226
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_start     : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.sleep_start    : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.block_start    : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.sleep_max      : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.block_max      : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.exec_max       : 4.400290
[Mon Jan  6 15:08:12 2014]   .se->statistics.slice_max      : 9.002337
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_max       : 16.101949
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_sum       : 556.207602
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_count     : 24845
[Mon Jan  6 15:08:12 2014]   .se->load.weight               : 2

[Mon Jan  6 15:08:12 2014] cfs_rq[1]:/autogroup-125
[Mon Jan  6 15:08:12 2014]   .exec_clock                    : 21840.440840
[Mon Jan  6 15:08:12 2014]   .MIN_vruntime                  : 0.000001
[Mon Jan  6 15:08:12 2014]   .min_vruntime                  : 21839.392264
[Mon Jan  6 15:08:12 2014]   .max_vruntime                  : 0.000001
[Mon Jan  6 15:08:12 2014]   .spread                        : 0.000000
[Mon Jan  6 15:08:12 2014]   .spread0                       : -362784.702713
[Mon Jan  6 15:08:12 2014]   .nr_spread_over                : 0
[Mon Jan  6 15:08:12 2014]   .nr_running                    : 0
[Mon Jan  6 15:08:12 2014]   .load                          : 0
[Mon Jan  6 15:08:12 2014]   .load_avg                      : 1459.128448
[Mon Jan  6 15:08:12 2014]   .load_period                   : 5.730405
[Mon Jan  6 15:08:12 2014]   .load_contrib                  : 254
[Mon Jan  6 15:08:12 2014]   .load_tg                       : 1232
[Mon Jan  6 15:08:12 2014]   .se->exec_start                : 7002815.010524
[Mon Jan  6 15:08:12 2014]   .se->vruntime                  : 215996.212750
[Mon Jan  6 15:08:12 2014]   .se->sum_exec_runtime          : 21843.526782
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_start     : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.sleep_start    : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.block_start    : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.sleep_max      : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.block_max      : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.exec_max       : 4.475589
[Mon Jan  6 15:08:12 2014]   .se->statistics.slice_max      : 3.646572
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_max       : 26.683651
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_sum       : 894.436623
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_count     : 50335
[Mon Jan  6 15:08:12 2014]   .se->load.weight               : 2

[Mon Jan  6 15:08:12 2014] cfs_rq[1]:/
[Mon Jan  6 15:08:12 2014]   .exec_clock                    : 179841.868724
[Mon Jan  6 15:08:12 2014]   .MIN_vruntime                  : 0.000001
[Mon Jan  6 15:08:12 2014]   .min_vruntime                  : 215996.212750
[Mon Jan  6 15:08:12 2014]   .max_vruntime                  : 0.000001
[Mon Jan  6 15:08:12 2014]   .spread                        : 0.000000
[Mon Jan  6 15:08:12 2014]   .spread0                       : -168627.882227
[Mon Jan  6 15:08:12 2014]   .nr_spread_over                : 71
[Mon Jan  6 15:08:12 2014]   .nr_running                    : 0
[Mon Jan  6 15:08:12 2014]   .load                          : 0
[Mon Jan  6 15:08:12 2014]   .load_avg                      : 0.000000
[Mon Jan  6 15:08:12 2014]   .load_period                   : 0.000000
[Mon Jan  6 15:08:12 2014]   .load_contrib                  : 0
[Mon Jan  6 15:08:12 2014]   .load_tg                       : 0

[Mon Jan  6 15:08:12 2014] rt_rq[1]:/
[Mon Jan  6 15:08:12 2014]   .rt_nr_running                 : 0
[Mon Jan  6 15:08:12 2014]   .rt_throttled                  : 0
[Mon Jan  6 15:08:12 2014]   .rt_time                       : 0.000000
[Mon Jan  6 15:08:12 2014]   .rt_runtime                    : 950.000000

[Mon Jan  6 15:08:12 2014] runnable tasks:
[Mon Jan  6 15:08:12 2014]             task   PID         tree-key
switches  prio     exec-runtime         sum-exec        sum-sleep
[Mon Jan  6 15:08:12 2014]
----------------------------------------------------------------------------------------------------------

[Mon Jan  6 15:08:12 2014] cpu#2, 2095.285 MHz
[Mon Jan  6 15:08:12 2014]   .nr_running                    : 0
[Mon Jan  6 15:08:12 2014]   .load                          : 0
[Mon Jan  6 15:08:12 2014]   .nr_switches                   : 1422290
[Mon Jan  6 15:08:12 2014]   .nr_load_updates               : 142708
[Mon Jan  6 15:08:12 2014]   .nr_uninterruptible            : 3634
[Mon Jan  6 15:08:12 2014]   .next_balance                  : 4296.645614
[Mon Jan  6 15:08:12 2014]   .curr->pid                     : 0
[Mon Jan  6 15:08:12 2014]   .clock                         : 7002829.260758
[Mon Jan  6 15:08:12 2014]   .cpu_load[0]                   : 1400
[Mon Jan  6 15:08:12 2014]   .cpu_load[1]                   : 903
[Mon Jan  6 15:08:12 2014]   .cpu_load[2]                   : 596
[Mon Jan  6 15:08:12 2014]   .cpu_load[3]                   : 349
[Mon Jan  6 15:08:12 2014]   .cpu_load[4]                   : 189
[Mon Jan  6 15:08:12 2014]   .yld_count                     : 0
[Mon Jan  6 15:08:12 2014]   .sched_count                   : 1425916
[Mon Jan  6 15:08:12 2014]   .sched_goidle                  : 641604
[Mon Jan  6 15:08:12 2014]   .avg_idle                      : 457043
[Mon Jan  6 15:08:12 2014]   .ttwu_count                    : 729334
[Mon Jan  6 15:08:12 2014]   .ttwu_local                    : 364824

[Mon Jan  6 15:08:12 2014] cfs_rq[2]:/autogroup-125
[Mon Jan  6 15:08:12 2014]   .exec_clock                    : 2639.680571
[Mon Jan  6 15:08:12 2014]   .MIN_vruntime                  : 0.000001
[Mon Jan  6 15:08:12 2014]   .min_vruntime                  : 2638.631995
[Mon Jan  6 15:08:12 2014]   .max_vruntime                  : 0.000001
[Mon Jan  6 15:08:12 2014]   .spread                        : 0.000000
[Mon Jan  6 15:08:12 2014]   .spread0                       : -381985.462982
[Mon Jan  6 15:08:12 2014]   .nr_spread_over                : 0
[Mon Jan  6 15:08:12 2014]   .nr_running                    : 0
[Mon Jan  6 15:08:12 2014]   .load                          : 0
[Mon Jan  6 15:08:12 2014]   .load_avg                      : 5804.353536
[Mon Jan  6 15:08:12 2014]   .load_period                   : 5.930709
[Mon Jan  6 15:08:12 2014]   .load_contrib                  : 978
[Mon Jan  6 15:08:12 2014]   .load_tg                       : 1232
[Mon Jan  6 15:08:12 2014]   .se->exec_start                : 7002828.982947
[Mon Jan  6 15:08:12 2014]   .se->vruntime                  : 209023.636820
[Mon Jan  6 15:08:12 2014]   .se->sum_exec_runtime          : 2641.215771
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_start     : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.sleep_start    : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.block_start    : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.sleep_max      : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.block_max      : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.exec_max       : 4.503085
[Mon Jan  6 15:08:12 2014]   .se->statistics.slice_max      : 2.685182
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_max       : 6.746186
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_sum       : 274.180017
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_count     : 6728
[Mon Jan  6 15:08:12 2014]   .se->load.weight               : 2

[Mon Jan  6 15:08:12 2014] cfs_rq[2]:/autogroup-135
[Mon Jan  6 15:08:12 2014]   .exec_clock                    : 10384.641212
[Mon Jan  6 15:08:12 2014]   .MIN_vruntime                  : 0.000001
[Mon Jan  6 15:08:12 2014]   .min_vruntime                  : 87852.985511
[Mon Jan  6 15:08:12 2014]   .max_vruntime                  : 0.000001
[Mon Jan  6 15:08:12 2014]   .spread                        : 0.000000
[Mon Jan  6 15:08:12 2014]   .spread0                       : -296771.109466
[Mon Jan  6 15:08:12 2014]   .nr_spread_over                : 31
[Mon Jan  6 15:08:12 2014]   .nr_running                    : 0
[Mon Jan  6 15:08:12 2014]   .load                          : 0
[Mon Jan  6 15:08:12 2014]   .load_avg                      : 5850.143744
[Mon Jan  6 15:08:12 2014]   .load_period                   : 5.885131
[Mon Jan  6 15:08:12 2014]   .load_contrib                  : 994
[Mon Jan  6 15:08:12 2014]   .load_tg                       : 1402
[Mon Jan  6 15:08:12 2014]   .se->exec_start                : 7002829.073722
[Mon Jan  6 15:08:12 2014]   .se->vruntime                  : 209030.092143
[Mon Jan  6 15:08:12 2014]   .se->sum_exec_runtime          : 10393.875381
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_start     : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.sleep_start    : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.block_start    : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.sleep_max      : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.block_max      : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.exec_max       : 5.403008
[Mon Jan  6 15:08:12 2014]   .se->statistics.slice_max      : 7.951567
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_max       : 7.722018
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_sum       : 886.674608
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_count     : 24204
[Mon Jan  6 15:08:12 2014]   .se->load.weight               : 2

[Mon Jan  6 15:08:12 2014] cfs_rq[2]:/autogroup-133
[Mon Jan  6 15:08:12 2014]   .exec_clock                    : 803.205189
[Mon Jan  6 15:08:12 2014]   .MIN_vruntime                  : 0.000001
[Mon Jan  6 15:08:12 2014]   .min_vruntime                  : 667.397190
[Mon Jan  6 15:08:12 2014]   .max_vruntime                  : 0.000001
[Mon Jan  6 15:08:12 2014]   .spread                        : 0.000000
[Mon Jan  6 15:08:12 2014]   .spread0                       : -383956.697787
[Mon Jan  6 15:08:12 2014]   .nr_spread_over                : 0
[Mon Jan  6 15:08:12 2014]   .nr_running                    : 0
[Mon Jan  6 15:08:12 2014]   .load                          : 0
[Mon Jan  6 15:08:12 2014]   .load_avg                      : 2559.999744
[Mon Jan  6 15:08:12 2014]   .load_period                   : 7.127479
[Mon Jan  6 15:08:12 2014]   .load_contrib                  : 359
[Mon Jan  6 15:08:12 2014]   .load_tg                       : 359
[Mon Jan  6 15:08:12 2014]   .se->exec_start                : 7002821.587403
[Mon Jan  6 15:08:12 2014]   .se->vruntime                  : 209018.943049
[Mon Jan  6 15:08:12 2014]   .se->sum_exec_runtime          : 803.545800
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_start     : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.sleep_start    : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.block_start    : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.sleep_max      : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.block_max      : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.exec_max       : 0.453284
[Mon Jan  6 15:08:12 2014]   .se->statistics.slice_max      : 0.152335
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_max       : 1.274565
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_sum       : 10.608523
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_count     : 10281
[Mon Jan  6 15:08:12 2014]   .se->load.weight               : 2

[Mon Jan  6 15:08:12 2014] cfs_rq[2]:/autogroup-161
[Mon Jan  6 15:08:12 2014]   .exec_clock                    : 1491.672237
[Mon Jan  6 15:08:12 2014]   .MIN_vruntime                  : 0.000001
[Mon Jan  6 15:08:12 2014]   .min_vruntime                  : 1995.514203
[Mon Jan  6 15:08:12 2014]   .max_vruntime                  : 0.000001
[Mon Jan  6 15:08:12 2014]   .spread                        : 0.000000
[Mon Jan  6 15:08:12 2014]   .spread0                       : -382628.580774
[Mon Jan  6 15:08:12 2014]   .nr_spread_over                : 48
[Mon Jan  6 15:08:12 2014]   .nr_running                    : 0
[Mon Jan  6 15:08:12 2014]   .load                          : 0
[Mon Jan  6 15:08:12 2014]   .load_avg                      : 2388.100736
[Mon Jan  6 15:08:12 2014]   .load_period                   : 7.485079
[Mon Jan  6 15:08:12 2014]   .load_contrib                  : 319
[Mon Jan  6 15:08:12 2014]   .load_tg                       : 1763
[Mon Jan  6 15:08:12 2014]   .se->exec_start                : 7002819.660084
[Mon Jan  6 15:08:12 2014]   .se->vruntime                  : 209032.062106
[Mon Jan  6 15:08:12 2014]   .se->sum_exec_runtime          : 1491.772150
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_start     : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.sleep_start    : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.block_start    : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.sleep_max      : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.block_max      : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.exec_max       : 4.001979
[Mon Jan  6 15:08:12 2014]   .se->statistics.slice_max      : 0.182867
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_max       : 2.313101
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_sum       : 18.874066
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_count     : 2352
[Mon Jan  6 15:08:12 2014]   .se->load.weight               : 2

[Mon Jan  6 15:08:12 2014] cfs_rq[2]:/
[Mon Jan  6 15:08:12 2014]   .exec_clock                    : 124966.592176
[Mon Jan  6 15:08:12 2014]   .MIN_vruntime                  : 0.000001
[Mon Jan  6 15:08:12 2014]   .min_vruntime                  : 209030.092143
[Mon Jan  6 15:08:12 2014]   .max_vruntime                  : 0.000001
[Mon Jan  6 15:08:12 2014]   .spread                        : 0.000000
[Mon Jan  6 15:08:12 2014]   .spread0                       : -175594.002834
[Mon Jan  6 15:08:12 2014]   .nr_spread_over                : 125
[Mon Jan  6 15:08:12 2014]   .nr_running                    : 0
[Mon Jan  6 15:08:12 2014]   .load                          : 0
[Mon Jan  6 15:08:12 2014]   .load_avg                      : 0.000000
[Mon Jan  6 15:08:12 2014]   .load_period                   : 0.000000
[Mon Jan  6 15:08:12 2014]   .load_contrib                  : 0
[Mon Jan  6 15:08:12 2014]   .load_tg                       : 0

[Mon Jan  6 15:08:12 2014] rt_rq[2]:/
[Mon Jan  6 15:08:12 2014]   .rt_nr_running                 : 0
[Mon Jan  6 15:08:12 2014]   .rt_throttled                  : 0
[Mon Jan  6 15:08:12 2014]   .rt_time                       : 0.000000
[Mon Jan  6 15:08:12 2014]   .rt_runtime                    : 950.000000

[Mon Jan  6 15:08:12 2014] runnable tasks:
[Mon Jan  6 15:08:12 2014]             task   PID         tree-key
switches  prio     exec-runtime         sum-exec        sum-sleep
[Mon Jan  6 15:08:12 2014]
----------------------------------------------------------------------------------------------------------

[Mon Jan  6 15:08:12 2014] cpu#3, 2095.285 MHz
[Mon Jan  6 15:08:12 2014]   .nr_running                    : 1
[Mon Jan  6 15:08:12 2014]   .load                          : 473
[Mon Jan  6 15:08:12 2014]   .nr_switches                   : 1387076
[Mon Jan  6 15:08:12 2014]   .nr_load_updates               : 146538
[Mon Jan  6 15:08:12 2014]   .nr_uninterruptible            : 4872
[Mon Jan  6 15:08:12 2014]   .next_balance                  : 4296.645583
[Mon Jan  6 15:08:12 2014]   .curr->pid                     : 2072
[Mon Jan  6 15:08:12 2014]   .clock                         : 7002830.314721
[Mon Jan  6 15:08:12 2014]   .cpu_load[0]                   : 1024
[Mon Jan  6 15:08:12 2014]   .cpu_load[1]                   : 512
[Mon Jan  6 15:08:12 2014]   .cpu_load[2]                   : 256
[Mon Jan  6 15:08:12 2014]   .cpu_load[3]                   : 128
[Mon Jan  6 15:08:12 2014]   .cpu_load[4]                   : 64
[Mon Jan  6 15:08:12 2014]   .yld_count                     : 0
[Mon Jan  6 15:08:12 2014]   .sched_count                   : 1390721
[Mon Jan  6 15:08:12 2014]   .sched_goidle                  : 630894
[Mon Jan  6 15:08:12 2014]   .avg_idle                      : 712624
[Mon Jan  6 15:08:12 2014]   .ttwu_count                    : 687434
[Mon Jan  6 15:08:12 2014]   .ttwu_local                    : 280159

[Mon Jan  6 15:08:12 2014] cfs_rq[3]:/autogroup-83
[Mon Jan  6 15:08:12 2014]   .exec_clock                    : 72.742705
[Mon Jan  6 15:08:12 2014]   .MIN_vruntime                  : 0.000001
[Mon Jan  6 15:08:12 2014]   .min_vruntime                  : 70.160315
[Mon Jan  6 15:08:12 2014]   .max_vruntime                  : 0.000001
[Mon Jan  6 15:08:12 2014]   .spread                        : 0.000000
[Mon Jan  6 15:08:12 2014]   .spread0                       : -384553.934662
[Mon Jan  6 15:08:12 2014]   .nr_spread_over                : 0
[Mon Jan  6 15:08:12 2014]   .nr_running                    : 0
[Mon Jan  6 15:08:12 2014]   .load                          : 0
[Mon Jan  6 15:08:12 2014]   .load_avg                      : 5818.785280
[Mon Jan  6 15:08:12 2014]   .load_period                   : 5.995892
[Mon Jan  6 15:08:12 2014]   .load_contrib                  : 970
[Mon Jan  6 15:08:12 2014]   .load_tg                       : 1610
[Mon Jan  6 15:08:12 2014]   .se->exec_start                : 7002829.039001
[Mon Jan  6 15:08:12 2014]   .se->vruntime                  : 191271.750543
[Mon Jan  6 15:08:12 2014]   .se->sum_exec_runtime          : 72.776929
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_start     : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.sleep_start    : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.block_start    : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.sleep_max      : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.block_max      : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.exec_max       : 3.981469
[Mon Jan  6 15:08:12 2014]   .se->statistics.slice_max      : 4.286821
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_max       : 2.255420
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_sum       : 9.740552
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_count     : 186
[Mon Jan  6 15:08:12 2014]   .se->load.weight               : 2

[Mon Jan  6 15:08:12 2014] cfs_rq[3]:/autogroup-161
[Mon Jan  6 15:08:12 2014]   .exec_clock                    : 952.023061
[Mon Jan  6 15:08:12 2014]   .MIN_vruntime                  : 0.000001
[Mon Jan  6 15:08:12 2014]   .min_vruntime                  : 1546.342613
[Mon Jan  6 15:08:12 2014]   .max_vruntime                  : 0.000001
[Mon Jan  6 15:08:12 2014]   .spread                        : 0.000000
[Mon Jan  6 15:08:12 2014]   .spread0                       : -383077.752364
[Mon Jan  6 15:08:12 2014]   .nr_spread_over                : 42
[Mon Jan  6 15:08:12 2014]   .nr_running                    : 0
[Mon Jan  6 15:08:12 2014]   .load                          : 0
[Mon Jan  6 15:08:12 2014]   .load_avg                      : 1279.999872
[Mon Jan  6 15:08:12 2014]   .load_period                   : 7.071395
[Mon Jan  6 15:08:12 2014]   .load_contrib                  : 181
[Mon Jan  6 15:08:12 2014]   .load_tg                       : 1763
[Mon Jan  6 15:08:12 2014]   .se->exec_start                : 7002815.037270
[Mon Jan  6 15:08:12 2014]   .se->vruntime                  : 191255.283208
[Mon Jan  6 15:08:12 2014]   .se->sum_exec_runtime          : 952.076072
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_start     : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.sleep_start    : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.block_start    : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.sleep_max      : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.block_max      : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.exec_max       : 4.000648
[Mon Jan  6 15:08:12 2014]   .se->statistics.slice_max      : 2.056290
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_max       : 4.052183
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_sum       : 13.134402
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_count     : 593
[Mon Jan  6 15:08:12 2014]   .se->load.weight               : 2

[Mon Jan  6 15:08:12 2014] cfs_rq[3]:/autogroup-135
[Mon Jan  6 15:08:12 2014]   .exec_clock                    : 12515.295968
[Mon Jan  6 15:08:12 2014]   .MIN_vruntime                  : 0.000001
[Mon Jan  6 15:08:12 2014]   .min_vruntime                  : 10965.966152
[Mon Jan  6 15:08:12 2014]   .max_vruntime                  : 0.000001
[Mon Jan  6 15:08:12 2014]   .spread                        : 0.000000
[Mon Jan  6 15:08:12 2014]   .spread0                       : -373658.128825
[Mon Jan  6 15:08:12 2014]   .nr_spread_over                : 32
[Mon Jan  6 15:08:12 2014]   .nr_running                    : 1
[Mon Jan  6 15:08:12 2014]   .load                          : 1024
[Mon Jan  6 15:08:12 2014]   .load_avg                      : 1522.461568
[Mon Jan  6 15:08:12 2014]   .load_period                   : 8.156608
[Mon Jan  6 15:08:12 2014]   .load_contrib                  : 212
[Mon Jan  6 15:08:12 2014]   .load_tg                       : 1402
[Mon Jan  6 15:08:12 2014]   .se->exec_start                : 7002830.314721
[Mon Jan  6 15:08:12 2014]   .se->vruntime                  : 191264.649353
[Mon Jan  6 15:08:12 2014]   .se->sum_exec_runtime          : 12526.556587
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_start     : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.sleep_start    : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.block_start    : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.sleep_max      : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.block_max      : 0.000000
[Mon Jan  6 15:08:12 2014]   .se->statistics.exec_max       : 5.043517
[Mon Jan  6 15:08:12 2014]   .se->statistics.slice_max      : 3.711222
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_max       : 10.161542
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_sum       : 842.979467
[Mon Jan  6 15:08:12 2014]   .se->statistics.wait_count     : 35055
[Mon Jan  6 15:08:12 2014]   .se->load.weight               : 473

[Mon Jan  6 15:08:12 2014] cfs_rq[3]:/
[Mon Jan  6 15:08:12 2014]   .exec_clock                    : 132194.315954
[Mon Jan  6 15:08:12 2014]   .MIN_vruntime                  : 0.000001
[Mon Jan  6 15:08:12 2014]   .min_vruntime                  : 191271.750543
[Mon Jan  6 15:08:12 2014]   .max_vruntime                  : 0.000001
[Mon Jan  6 15:08:12 2014]   .spread                        : 0.000000
[Mon Jan  6 15:08:12 2014]   .spread0                       : -193352.344434
[Mon Jan  6 15:08:12 2014]   .nr_spread_over                : 78
[Mon Jan  6 15:08:12 2014]   .nr_running                    : 1
[Mon Jan  6 15:08:12 2014]   .load                          : 473
[Mon Jan  6 15:08:12 2014]   .load_avg                      : 0.000000
[Mon Jan  6 15:08:12 2014]   .load_period                   : 0.000000
[Mon Jan  6 15:08:12 2014]   .load_contrib                  : 0
[Mon Jan  6 15:08:12 2014]   .load_tg                       : 0

[Mon Jan  6 15:08:12 2014] rt_rq[3]:/
[Mon Jan  6 15:08:12 2014]   .rt_nr_running                 : 0
[Mon Jan  6 15:08:12 2014]   .rt_throttled                  : 0
[Mon Jan  6 15:08:12 2014]   .rt_time                       : 0.000000
[Mon Jan  6 15:08:12 2014]   .rt_runtime                    : 950.000000

[Mon Jan  6 15:08:12 2014] runnable tasks:
[Mon Jan  6 15:08:12 2014]             task   PID         tree-key
switches  prio     exec-runtime         sum-exec        sum-sleep
[Mon Jan  6 15:08:12 2014]
----------------------------------------------------------------------------------------------------------
[Mon Jan  6 15:08:12 2014] R         compiz  2072     10966.857173
100262   120     10966.857173     36795.137918   6901478.352667
/autogroup-135
[Mon Jan  6 15:08:12 2014]





On Mon, Oct 21, 2013 at 6:09 PM, Sandeep Joshi <sanjos100@gmail.com> wrote:
>
> I am seeing a problem reported 4 years earlier
> https://lkml.org/lkml/2009/3/12/226
> (same stack as seen by Alexander)
>
> The problem is reproducible.  Let me know if you need any info in
> addition to that seen below.
>
> I have multiple threads in a process doing heavy IO on a ext4
> filesystem mounted with (discard, noatime) on a SSD or HDD.
>
> This is on Linux 3.8.0-29-generic #42~precise1-Ubuntu SMP Wed Aug 14
> 16:19:23 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
>
> For upto minutes at a time, one of the threads seems to hang in sync to disk.
>
> When I check the thread stack in /proc, I find that the stack is one
> of the following two
>
> <ffffffff81134a4e>] sleep_on_page+0xe/0x20
> [<ffffffff81134c88>] wait_on_page_bit+0x78/0x80
> [<ffffffff81134d9c>] filemap_fdatawait_range+0x10c/0x1a0
> [<ffffffff811367d8>] filemap_write_and_wait_range+0x68/0x80
> [<ffffffff81236a4f>] ext4_sync_file+0x6f/0x2b0
> [<ffffffff811cba9b>] vfs_fsync+0x2b/0x40
> [<ffffffff81168fb3>] sys_msync+0x143/0x1d0
> [<ffffffff816fc8dd>] system_call_fastpath+0x1a/0x1f
> [<ffffffffffffffff>] 0xffffffffffffffff
>
>
> OR
>
>
> [<ffffffff812947f5>] jbd2_log_wait_commit+0xb5/0x130
> [<ffffffff81297213>] jbd2_complete_transaction+0x53/0x90
> [<ffffffff81236bcd>] ext4_sync_file+0x1ed/0x2b0
> [<ffffffff811cba9b>] vfs_fsync+0x2b/0x40
> [<ffffffff81168fb3>] sys_msync+0x143/0x1d0
> [<ffffffff816fc8dd>] system_call_fastpath+0x1a/0x1f
> [<ffffffffffffffff>] 0xffffffffffffffff
>
> Any clues?
>
> -Sandeep
