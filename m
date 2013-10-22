From: Sandeep Joshi <sanjos100@gmail.com>
Subject: Re: process hangs in ext4_sync_file
Date: Tue, 22 Oct 2013 14:15:56 +0530
Message-ID: <CAEfL3KmqMeJphtNf4Oqr7xOPhvAYZ8jT8=dszex4HMEMDaOY8w@mail.gmail.com>
References: <CAEfL3KniKZNzehPH1Z4eWhhNF_RHrE4vHoRTHDPrfYj4t_2LtA@mail.gmail.com>
	<20131021125758.GA3253@gmail.com>
	<CAEfL3KnB_j-3v50Z3UF4T+uP2Rje2d0Zgjeb3h0byyQ7uFib2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Sandeep Joshi <sanjos100@gmail.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vc0-f180.google.com ([209.85.220.180]:60826 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab3JVIp5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Oct 2013 04:45:57 -0400
Received: by mail-vc0-f180.google.com with SMTP id lc6so147973vcb.11
        for <linux-ext4@vger.kernel.org>; Tue, 22 Oct 2013 01:45:56 -0700 (PDT)
In-Reply-To: <CAEfL3KnB_j-3v50Z3UF4T+uP2Rje2d0Zgjeb3h0byyQ7uFib2w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 22, 2013 at 8:54 AM, Sandeep Joshi <sanjos100@gmail.com> wrote:
> On Mon, Oct 21, 2013 at 6:27 PM, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
>> Hi Sandeep,
>>
>> On Mon, Oct 21, 2013 at 06:09:02PM +0530, Sandeep Joshi wrote:
>>> I am seeing a problem reported 4 years earlier
>>> https://lkml.org/lkml/2009/3/12/226
>>> (same stack as seen by Alexander)
>>>
>>> The problem is reproducible.  Let me know if you need any info in
>>> addition to that seen below.
>>>
>>> I have multiple threads in a process doing heavy IO on a ext4
>>> filesystem mounted with (discard, noatime) on a SSD or HDD.
>>>
>>> This is on Linux 3.8.0-29-generic #42~precise1-Ubuntu SMP Wed Aug 14
>>> 16:19:23 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
>>>
>>> For upto minutes at a time, one of the threads seems to hang in sync to disk.
>>>
>>> When I check the thread stack in /proc, I find that the stack is one
>>> of the following two
>>>
>>> <ffffffff81134a4e>] sleep_on_page+0xe/0x20
>>> [<ffffffff81134c88>] wait_on_page_bit+0x78/0x80
>>> [<ffffffff81134d9c>] filemap_fdatawait_range+0x10c/0x1a0
>>> [<ffffffff811367d8>] filemap_write_and_wait_range+0x68/0x80
>>> [<ffffffff81236a4f>] ext4_sync_file+0x6f/0x2b0
>>> [<ffffffff811cba9b>] vfs_fsync+0x2b/0x40
>>> [<ffffffff81168fb3>] sys_msync+0x143/0x1d0
>>> [<ffffffff816fc8dd>] system_call_fastpath+0x1a/0x1f
>>> [<ffffffffffffffff>] 0xffffffffffffffff
>>>
>>>
>>> OR
>>>
>>>
>>> [<ffffffff812947f5>] jbd2_log_wait_commit+0xb5/0x130
>>> [<ffffffff81297213>] jbd2_complete_transaction+0x53/0x90
>>> [<ffffffff81236bcd>] ext4_sync_file+0x1ed/0x2b0
>>> [<ffffffff811cba9b>] vfs_fsync+0x2b/0x40
>>> [<ffffffff81168fb3>] sys_msync+0x143/0x1d0
>>> [<ffffffff816fc8dd>] system_call_fastpath+0x1a/0x1f
>>> [<ffffffffffffffff>] 0xffffffffffffffff
>>>
>>> Any clues?
>>
>> Thanks for reporting this.  Could you please try your test in latest
>> mainline kernel?  Further, could you please run the following command?
>>   'echo w >/proc/sysrq-trigger'

this is the output of "echo w > /proc/sysrq-trigger"


Oct 22 14:01:17 svfs-server kernel: [ 9382.162980] SysRq : Show Blocked State
Oct 22 14:01:17 svfs-server kernel: [ 9382.162984]   task
          PC stack   pid father
Oct 22 14:01:17 svfs-server kernel: [ 9382.163039] nfsd            D
ffff880444e29a20     0  7287      2 0x00000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163042]  ffff88011d545868
0000000000000046 ffff88011d5457f0 ffff88045fd13f40
Oct 22 14:01:17 svfs-server kernel: [ 9382.163044]  ffff88011d545fd8
ffff88011d545fd8 ffff88011d545fd8 0000000000013f40
Oct 22 14:01:17 svfs-server kernel: [ 9382.163046]  ffff880249692e80
ffff880111158000 ffff88011d545868 ffff88045fd147f8
Oct 22 14:01:17 svfs-server kernel: [ 9382.163048] Call Trace:
Oct 22 14:01:17 svfs-server kernel: [ 9382.163054]
[<ffffffff81134a40>] ? __lock_page+0x70/0x70
Oct 22 14:01:17 svfs-server kernel: [ 9382.163057]
[<ffffffff816f2b59>] schedule+0x29/0x70
Oct 22 14:01:17 svfs-server kernel: [ 9382.163058]
[<ffffffff816f2c2f>] io_schedule+0x8f/0xd0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163061]
[<ffffffff81134a4e>] sleep_on_page+0xe/0x20
Oct 22 14:01:17 svfs-server kernel: [ 9382.163064]
[<ffffffff816f13fa>] __wait_on_bit_lock+0x5a/0xc0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163066]
[<ffffffff81134a37>] __lock_page+0x67/0x70
Oct 22 14:01:17 svfs-server kernel: [ 9382.163069]
[<ffffffff8107fdb0>] ? autoremove_wake_function+0x40/0x40
Oct 22 14:01:17 svfs-server kernel: [ 9382.163073]
[<ffffffff811cb5dc>] __generic_file_splice_read+0x59c/0x5d0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163076]
[<ffffffff8113ea7e>] ? free_hot_cold_page_list+0x4e/0xc0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163077]
[<ffffffff8113776a>] ? find_get_pages+0xca/0x150
Oct 22 14:01:17 svfs-server kernel: [ 9382.163080]
[<ffffffff81141452>] ? pagevec_lookup+0x22/0x30
Oct 22 14:01:17 svfs-server kernel: [ 9382.163083]
[<ffffffff81142b40>] ? invalidate_inode_pages2_range+0xb0/0x2c0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163085]
[<ffffffff811c9150>] ? page_cache_pipe_buf_release+0x30/0x30
Oct 22 14:01:17 svfs-server kernel: [ 9382.163087]
[<ffffffff811cb64e>] generic_file_splice_read+0x3e/0x80
Oct 22 14:01:17 svfs-server kernel: [ 9382.163088]
[<ffffffff811c985b>] do_splice_to+0x7b/0xa0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163090]
[<ffffffff811c9927>] splice_direct_to_actor+0xa7/0x1b0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163103]
[<ffffffffa0270f30>] ? wait_for_concurrent_writes+0x110/0x110 [nfsd]
Oct 22 14:01:17 svfs-server kernel: [ 9382.163107]
[<ffffffffa0271329>] nfsd_vfs_read.isra.13+0x119/0x160 [nfsd]
Oct 22 14:01:17 svfs-server kernel: [ 9382.163111]
[<ffffffffa0272370>] nfsd_read+0x1f0/0x2c0 [nfsd]
Oct 22 14:01:17 svfs-server kernel: [ 9382.163115]
[<ffffffffa027b192>] nfsd3_proc_read+0xd2/0x170 [nfsd]
Oct 22 14:01:17 svfs-server kernel: [ 9382.163118]
[<ffffffffa026cd6b>] nfsd_dispatch+0xeb/0x230 [nfsd]
Oct 22 14:01:17 svfs-server kernel: [ 9382.163130]
[<ffffffffa01f84c5>] svc_process_common+0x345/0x690 [sunrpc]
Oct 22 14:01:17 svfs-server kernel: [ 9382.163136]
[<ffffffffa01f8b63>] svc_process+0x103/0x160 [sunrpc]
Oct 22 14:01:17 svfs-server kernel: [ 9382.163139]
[<ffffffffa026c8cf>] nfsd+0xbf/0x130 [nfsd]
Oct 22 14:01:17 svfs-server kernel: [ 9382.163142]
[<ffffffffa026c810>] ? nfsd_destroy+0x80/0x80 [nfsd]
Oct 22 14:01:17 svfs-server kernel: [ 9382.163144]
[<ffffffff8107f1b0>] kthread+0xc0/0xd0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163146]
[<ffffffff8107f0f0>] ? flush_kthread_worker+0xb0/0xb0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163149]
[<ffffffff816fc82c>] ret_from_fork+0x7c/0xb0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163150]
[<ffffffff8107f0f0>] ? flush_kthread_worker+0xb0/0xb0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163155] svfuse_start    D
ffff880444e29a20     0  7323   7024 0x00000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163156]  ffff8802a577fca8
0000000000000086 ffff8802a577fc78 ffff88045fc13f40
Oct 22 14:01:17 svfs-server kernel: [ 9382.163158]  ffff8802a577ffd8
ffff8802a577ffd8 ffff8802a577ffd8 0000000000013f40
Oct 22 14:01:17 svfs-server kernel: [ 9382.163160]  ffffffff81c15440
ffff880442d0ae80 ffff8802a577fca8 ffff88045fc147f8
Oct 22 14:01:17 svfs-server kernel: [ 9382.163162] Call Trace:
Oct 22 14:01:17 svfs-server kernel: [ 9382.163164]
[<ffffffff81134a40>] ? __lock_page+0x70/0x70
Oct 22 14:01:17 svfs-server kernel: [ 9382.163165]
[<ffffffff816f2b59>] schedule+0x29/0x70
Oct 22 14:01:17 svfs-server kernel: [ 9382.163167]
[<ffffffff816f2c2f>] io_schedule+0x8f/0xd0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163169]
[<ffffffff81134a4e>] sleep_on_page+0xe/0x20
Oct 22 14:01:17 svfs-server kernel: [ 9382.163171]
[<ffffffff816f154f>] __wait_on_bit+0x5f/0x90
Oct 22 14:01:17 svfs-server kernel: [ 9382.163173]
[<ffffffff811355eb>] ? find_get_pages_tag+0xcb/0x170
Oct 22 14:01:17 svfs-server kernel: [ 9382.163175]
[<ffffffff81134c88>] wait_on_page_bit+0x78/0x80
Oct 22 14:01:17 svfs-server kernel: [ 9382.163177]
[<ffffffff8107fdb0>] ? autoremove_wake_function+0x40/0x40
Oct 22 14:01:17 svfs-server kernel: [ 9382.163179]
[<ffffffff81134d9c>] filemap_fdatawait_range+0x10c/0x1a0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163182]
[<ffffffff81163447>] ? find_vma+0x47/0x90
Oct 22 14:01:17 svfs-server kernel: [ 9382.163184]
[<ffffffff81140820>] ? do_writepages+0x20/0x40
Oct 22 14:01:17 svfs-server kernel: [ 9382.163186]
[<ffffffff811367d8>] filemap_write_and_wait_range+0x68/0x80
Oct 22 14:01:17 svfs-server kernel: [ 9382.163188]
[<ffffffff81236a4f>] ext4_sync_file+0x6f/0x2b0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163190]
[<ffffffff811cba9b>] vfs_fsync+0x2b/0x40
Oct 22 14:01:17 svfs-server kernel: [ 9382.163192]
[<ffffffff81168fb3>] sys_msync+0x143/0x1d0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163194]
[<ffffffff816fc8dd>] system_call_fastpath+0x1a/0x1f
Oct 22 14:01:17 svfs-server kernel: [ 9382.163196] svfuse_start    D
ffff880444e29a20     0  7335   7024 0x00000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163197]  ffff88026684bca8
0000000000000086 ffff88026684bc78 ffff88045fd93f40
Oct 22 14:01:17 svfs-server kernel: [ 9382.163199]  ffff88026684bfd8
ffff88026684bfd8 ffff88026684bfd8 0000000000013f40
Oct 22 14:01:17 svfs-server kernel: [ 9382.163201]  ffff880248d945c0
ffff880248d95d00 ffff88026684bca8 ffff88045fd947f8
Oct 22 14:01:17 svfs-server kernel: [ 9382.163202] Call Trace:
Oct 22 14:01:17 svfs-server kernel: [ 9382.163204]
[<ffffffff81134a40>] ? __lock_page+0x70/0x70
Oct 22 14:01:17 svfs-server kernel: [ 9382.163206]
[<ffffffff816f2b59>] schedule+0x29/0x70
Oct 22 14:01:17 svfs-server kernel: [ 9382.163207]
[<ffffffff816f2c2f>] io_schedule+0x8f/0xd0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163209]
[<ffffffff81134a4e>] sleep_on_page+0xe/0x20
Oct 22 14:01:17 svfs-server kernel: [ 9382.163211]
[<ffffffff816f154f>] __wait_on_bit+0x5f/0x90
Oct 22 14:01:17 svfs-server kernel: [ 9382.163212]
[<ffffffff811355eb>] ? find_get_pages_tag+0xcb/0x170
Oct 22 14:01:17 svfs-server kernel: [ 9382.163214]
[<ffffffff81134c88>] wait_on_page_bit+0x78/0x80
Oct 22 14:01:17 svfs-server kernel: [ 9382.163216]
[<ffffffff8107fdb0>] ? autoremove_wake_function+0x40/0x40
Oct 22 14:01:17 svfs-server kernel: [ 9382.163218]
[<ffffffff81134d9c>] filemap_fdatawait_range+0x10c/0x1a0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163220]
[<ffffffff81140820>] ? do_writepages+0x20/0x40
Oct 22 14:01:17 svfs-server kernel: [ 9382.163222]
[<ffffffff811367d8>] filemap_write_and_wait_range+0x68/0x80
Oct 22 14:01:17 svfs-server kernel: [ 9382.163223]
[<ffffffff81236a4f>] ext4_sync_file+0x6f/0x2b0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163225]
[<ffffffff810bb198>] ? do_futex+0xd8/0x1b0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163227]
[<ffffffff811cba9b>] vfs_fsync+0x2b/0x40
Oct 22 14:01:17 svfs-server kernel: [ 9382.163229]
[<ffffffff81168fb3>] sys_msync+0x143/0x1d0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163230]
[<ffffffff816fc8dd>] system_call_fastpath+0x1a/0x1f
Oct 22 14:01:17 svfs-server kernel: [ 9382.163242] Sched Debug
Version: v0.10, 3.8.0-29-generic #42~precise1-Ubuntu
Oct 22 14:01:17 svfs-server kernel: [ 9382.163243] ktime
                    : 9337201.943298
Oct 22 14:01:17 svfs-server kernel: [ 9382.163244] sched_clk
                    : 9382163.241506

Oct 22 14:01:17 svfs-server kernel: [ 9382.163245] cpu_clk
                    : 9382163.241531
Oct 22 14:01:17 svfs-server kernel: [ 9382.163246] jiffies
                    : 4297226596
Oct 22 14:01:17 svfs-server kernel: [ 9382.163247] sched_clock_stable
                    : 1
Oct 22 14:01:17 svfs-server kernel: [ 9382.163247]
Oct 22 14:01:17 svfs-server kernel: [ 9382.163248] sysctl_sched
Oct 22 14:01:17 svfs-server kernel: [ 9382.163249]
.sysctl_sched_latency                    : 18.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163250]
.sysctl_sched_min_granularity            : 2.250000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163251]
.sysctl_sched_wakeup_granularity         : 3.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163252]
.sysctl_sched_child_runs_first           : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163252]
.sysctl_sched_features                   : 24187
Oct 22 14:01:17 svfs-server kernel: [ 9382.163254]
.sysctl_sched_tunable_scaling            : 1 (logaritmic)
Oct 22 14:01:17 svfs-server kernel: [ 9382.163255]
Oct 22 14:01:17 svfs-server kernel: [ 9382.163255] cpu#0, 3092.974 MHz
Oct 22 14:01:17 svfs-server kernel: [ 9382.163256]   .nr_running
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163257]   .load
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163258]   .nr_switches
             : 62323138
Oct 22 14:01:17 svfs-server kernel: [ 9382.163258]   .nr_load_updates
             : 1016805
Oct 22 14:01:17 svfs-server kernel: [ 9382.163259]
.nr_uninterruptible            : 40784
Oct 22 14:01:17 svfs-server kernel: [ 9382.163260]   .next_balance
             : 4297.226692
Oct 22 14:01:17 svfs-server kernel: [ 9382.163261]   .curr->pid
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163262]   .clock
             : 9382163.258246
Oct 22 14:01:17 svfs-server kernel: [ 9382.163263]   .cpu_load[0]
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163263]   .cpu_load[1]
             : 625
Oct 22 14:01:17 svfs-server kernel: [ 9382.163264]   .cpu_load[2]
             : 657
Oct 22 14:01:17 svfs-server kernel: [ 9382.163265]   .cpu_load[3]
             : 590
Oct 22 14:01:17 svfs-server kernel: [ 9382.163266]   .cpu_load[4]
             : 568
Oct 22 14:01:17 svfs-server kernel: [ 9382.163266]   .yld_count
             : 124
Oct 22 14:01:17 svfs-server kernel: [ 9382.163267]   .sched_count
             : 62341314
Oct 22 14:01:17 svfs-server kernel: [ 9382.163268]   .sched_goidle
             : 13776573
Oct 22 14:01:17 svfs-server kernel: [ 9382.163269]   .avg_idle
             : 114295
Oct 22 14:01:17 svfs-server kernel: [ 9382.163269]   .ttwu_count
             : 38801083
Oct 22 14:01:17 svfs-server kernel: [ 9382.163270]   .ttwu_local
             : 15994716
Oct 22 14:01:17 svfs-server kernel: [ 9382.163272]
Oct 22 14:01:17 svfs-server kernel: [ 9382.163272] cfs_rq[0]:/autogroup-139
Oct 22 14:01:17 svfs-server kernel: [ 9382.163273]   .exec_clock
             : 2772.728199
Oct 22 14:01:17 svfs-server kernel: [ 9382.163274]   .MIN_vruntime
             : 0.000001
Oct 22 14:01:17 svfs-server kernel: [ 9382.163275]   .min_vruntime
             : 2770.267635
Oct 22 14:01:17 svfs-server kernel: [ 9382.163275]   .max_vruntime
             : 0.000001
Oct 22 14:01:17 svfs-server kernel: [ 9382.163276]   .spread
             : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163277]   .spread0
             : -7039829.441650
Oct 22 14:01:17 svfs-server kernel: [ 9382.163278]   .nr_spread_over
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163279]   .nr_running
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163279]   .load
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163280]
.runnable_load_avg             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163281]   .blocked_load_avg
             : 2
Oct 22 14:01:17 svfs-server kernel: [ 9382.163281]   .tg_load_avg
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163282]   .tg_load_contrib
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163283]
.tg_runnable_contrib           : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163284]   .tg->runnable_avg
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163285]   .se->exec_start
             : 9382157.960542
Oct 22 14:01:17 svfs-server kernel: [ 9382.163285]   .se->vruntime
             : 7042584.042803
Oct 22 14:01:17 svfs-server kernel: [ 9382.163286]
.se->sum_exec_runtime          : 2773.215153
Oct 22 14:01:17 svfs-server kernel: [ 9382.163287]
.se->statistics.wait_start     : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163288]
.se->statistics.sleep_start    : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163289]
.se->statistics.block_start    : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163290]
.se->statistics.sleep_max      : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163290]
.se->statistics.block_max      : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163291]
.se->statistics.exec_max       : 79.050590
Oct 22 14:01:17 svfs-server kernel: [ 9382.163292]
.se->statistics.slice_max      : 14.180503
Oct 22 14:01:17 svfs-server kernel: [ 9382.163293]
.se->statistics.wait_max       : 89.509056
Oct 22 14:01:17 svfs-server kernel: [ 9382.163294]
.se->statistics.wait_sum       : 816.450636
Oct 22 14:01:17 svfs-server kernel: [ 9382.163294]
.se->statistics.wait_count     : 93430
Oct 22 14:01:17 svfs-server kernel: [ 9382.163295]   .se->load.weight
             : 2
Oct 22 14:01:17 svfs-server kernel: [ 9382.163296]
.se->avg.runnable_avg_sum      : 42
Oct 22 14:01:17 svfs-server kernel: [ 9382.163297]
.se->avg.runnable_avg_period   : 47869
Oct 22 14:01:17 svfs-server kernel: [ 9382.163297]
.se->avg.load_avg_contrib      : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163298]
.se->avg.decay_count           : 8947524
Oct 22 14:01:17 svfs-server kernel: [ 9382.163299]
Oct 22 14:01:17 svfs-server kernel: [ 9382.163299] cfs_rq[0]:/autogroup-127
Oct 22 14:01:17 svfs-server kernel: [ 9382.163300]   .exec_clock
             : 7853.944507
Oct 22 14:01:17 svfs-server kernel: [ 9382.163301]   .MIN_vruntime
             : 0.000001
Oct 22 14:01:17 svfs-server kernel: [ 9382.163302]   .min_vruntime
             : 7868.319613
Oct 22 14:01:17 svfs-server kernel: [ 9382.163303]   .max_vruntime
             : 0.000001
Oct 22 14:01:17 svfs-server kernel: [ 9382.163303]   .spread
             : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163304]   .spread0
             : -7034731.432465
Oct 22 14:01:17 svfs-server kernel: [ 9382.163305]   .nr_spread_over
             : 4
Oct 22 14:01:17 svfs-server kernel: [ 9382.163306]   .nr_running
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163307]   .load
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163307]
.runnable_load_avg             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163308]   .blocked_load_avg
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163309]   .tg_load_avg
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163309]   .tg_load_contrib
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163310]
.tg_runnable_contrib           : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163311]   .tg->runnable_avg
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163312]   .se->exec_start
             : 9382124.583794
Oct 22 14:01:17 svfs-server kernel: [ 9382.163312]   .se->vruntime
             : 7042550.967246
Oct 22 14:01:17 svfs-server kernel: [ 9382.163313]
.se->sum_exec_runtime          : 7879.133905
Oct 22 14:01:17 svfs-server kernel: [ 9382.163314]
.se->statistics.wait_start     : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163315]
.se->statistics.sleep_start    : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163316]
.se->statistics.block_start    : 0.000000

Oct 22 14:01:17 svfs-server kernel: [ 9382.163316]
.se->statistics.sleep_max      : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163317]
.se->statistics.block_max      : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163318]
.se->statistics.exec_max       : 285.173620
Oct 22 14:01:17 svfs-server kernel: [ 9382.163319]
.se->statistics.slice_max      : 183.199804
Oct 22 14:01:17 svfs-server kernel: [ 9382.163320]
.se->statistics.wait_max       : 509.724018
Oct 22 14:01:17 svfs-server kernel: [ 9382.163320]
.se->statistics.wait_sum       : 13624.926861
Oct 22 14:01:17 svfs-server kernel: [ 9382.163321]
.se->statistics.wait_count     : 22406
Oct 22 14:01:17 svfs-server kernel: [ 9382.163322]   .se->load.weight
             : 2
Oct 22 14:01:17 svfs-server kernel: [ 9382.163323]
.se->avg.runnable_avg_sum      : 10
Oct 22 14:01:17 svfs-server kernel: [ 9382.163323]
.se->avg.runnable_avg_period   : 46391
Oct 22 14:01:17 svfs-server kernel: [ 9382.163324]
.se->avg.load_avg_contrib      : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163325]
.se->avg.decay_count           : 8947492
Oct 22 14:01:17 svfs-server kernel: [ 9382.163326]
Oct 22 14:01:17 svfs-server kernel: [ 9382.163326] cfs_rq[0]:/autogroup-46
Oct 22 14:01:17 svfs-server kernel: [ 9382.163327]   .exec_clock
             : 18761.676240
Oct 22 14:01:17 svfs-server kernel: [ 9382.163328]   .MIN_vruntime
             : 0.000001
Oct 22 14:01:17 svfs-server kernel: [ 9382.163329]   .min_vruntime
             : 17308.575257
Oct 22 14:01:17 svfs-server kernel: [ 9382.163329]   .max_vruntime
             : 0.000001
Oct 22 14:01:17 svfs-server kernel: [ 9382.163330]   .spread
             : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163331]   .spread0
             : -7025291.212363
Oct 22 14:01:17 svfs-server kernel: [ 9382.163332]   .nr_spread_over
             : 1
Oct 22 14:01:17 svfs-server kernel: [ 9382.163332]   .nr_running
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163333]   .load
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163334]
.runnable_load_avg             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163334]   .blocked_load_avg
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163335]   .tg_load_avg
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163336]   .tg_load_contrib
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163336]
.tg_runnable_contrib           : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163337]   .tg->runnable_avg
             : 3
Oct 22 14:01:17 svfs-server kernel: [ 9382.163338]   .se->exec_start
             : 9382160.893101
Oct 22 14:01:17 svfs-server kernel: [ 9382.163339]   .se->vruntime
             : 7042588.911108
Oct 22 14:01:17 svfs-server kernel: [ 9382.163340]
.se->sum_exec_runtime          : 18795.779552
Oct 22 14:01:17 svfs-server kernel: [ 9382.163340]
.se->statistics.wait_start     : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163341]
.se->statistics.sleep_start    : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163342]
.se->statistics.block_start    : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163343]
.se->statistics.sleep_max      : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163343]
.se->statistics.block_max      : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163344]
.se->statistics.exec_max       : 137.475479
Oct 22 14:01:17 svfs-server kernel: [ 9382.163345]
.se->statistics.slice_max      : 137.475479
Oct 22 14:01:17 svfs-server kernel: [ 9382.163346]
.se->statistics.wait_max       : 492.652782
Oct 22 14:01:17 svfs-server kernel: [ 9382.163346]
.se->statistics.wait_sum       : 27671.433228
Oct 22 14:01:17 svfs-server kernel: [ 9382.163347]
.se->statistics.wait_count     : 795102
Oct 22 14:01:17 svfs-server kernel: [ 9382.163348]   .se->load.weight
             : 2
Oct 22 14:01:17 svfs-server kernel: [ 9382.163349]
.se->avg.runnable_avg_sum      : 67
Oct 22 14:01:17 svfs-server kernel: [ 9382.163349]
.se->avg.runnable_avg_period   : 47759
Oct 22 14:01:17 svfs-server kernel: [ 9382.163350]
.se->avg.load_avg_contrib      : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163351]
.se->avg.decay_count           : 8947526
Oct 22 14:01:17 svfs-server kernel: [ 9382.163352]
Oct 22 14:01:17 svfs-server kernel: [ 9382.163352] cfs_rq[0]:/autogroup-130
Oct 22 14:01:17 svfs-server kernel: [ 9382.163353]   .exec_clock
             : 79261.108489
Oct 22 14:01:17 svfs-server kernel: [ 9382.163353]   .MIN_vruntime
             : 0.000001
Oct 22 14:01:17 svfs-server kernel: [ 9382.163354]   .min_vruntime
             : 78631.002921
Oct 22 14:01:17 svfs-server kernel: [ 9382.163355]   .max_vruntime
             : 0.000001
Oct 22 14:01:17 svfs-server kernel: [ 9382.163356]   .spread
             : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163356]   .spread0
             : -6963968.784699
Oct 22 14:01:17 svfs-server kernel: [ 9382.163357]   .nr_spread_over
             : 3
Oct 22 14:01:17 svfs-server kernel: [ 9382.163358]   .nr_running
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163359]   .load
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163359]
.runnable_load_avg             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163360]   .blocked_load_avg
             : 0

Oct 22 14:01:17 svfs-server kernel: [ 9382.163361]   .tg_load_avg
             : 407
Oct 22 14:01:17 svfs-server kernel: [ 9382.163361]   .tg_load_contrib
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163362]
.tg_runnable_contrib           : 21
Oct 22 14:01:17 svfs-server kernel: [ 9382.163363]   .tg->runnable_avg
             : 92
Oct 22 14:01:17 svfs-server kernel: [ 9382.163364]   .se->exec_start
             : 9382141.095527
Oct 22 14:01:17 svfs-server kernel: [ 9382.163365]   .se->vruntime
             : 7042572.790186
Oct 22 14:01:17 svfs-server kernel: [ 9382.163365]
.se->sum_exec_runtime          : 79330.732292
Oct 22 14:01:17 svfs-server kernel: [ 9382.163366]
.se->statistics.wait_start     : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163367]
.se->statistics.sleep_start    : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163368]
.se->statistics.block_start    : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163368]
.se->statistics.sleep_max      : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163369]
.se->statistics.block_max      : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163370]
.se->statistics.exec_max       : 492.615993
Oct 22 14:01:17 svfs-server kernel: [ 9382.163371]
.se->statistics.slice_max      : 46.539586
Oct 22 14:01:17 svfs-server kernel: [ 9382.163372]
.se->statistics.wait_max       : 689.616146
Oct 22 14:01:17 svfs-server kernel: [ 9382.163372]
.se->statistics.wait_sum       : 56394.039564
Oct 22 14:01:17 svfs-server kernel: [ 9382.163373]
.se->statistics.wait_count     : 836878
Oct 22 14:01:17 svfs-server kernel: [ 9382.163374]   .se->load.weight
             : 2
Oct 22 14:01:17 svfs-server kernel: [ 9382.163375]
.se->avg.runnable_avg_sum      : 993
Oct 22 14:01:17 svfs-server kernel: [ 9382.163375]
.se->avg.runnable_avg_period   : 46299
Oct 22 14:01:17 svfs-server kernel: [ 9382.163376]
.se->avg.load_avg_contrib      : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163377]
.se->avg.decay_count           : 8947507
Oct 22 14:01:17 svfs-server kernel: [ 9382.163378]
Oct 22 14:01:17 svfs-server kernel: [ 9382.163378] cfs_rq[0]:/autogroup-141
Oct 22 14:01:17 svfs-server kernel: [ 9382.163379]   .exec_clock
             : 1770196.740787
Oct 22 14:01:17 svfs-server kernel: [ 9382.163379]   .MIN_vruntime
             : 0.000001
Oct 22 14:01:17 svfs-server kernel: [ 9382.163380]   .min_vruntime
             : 604917.223056
Oct 22 14:01:17 svfs-server kernel: [ 9382.163381]   .max_vruntime
             : 0.000001
Oct 22 14:01:17 svfs-server kernel: [ 9382.163382]   .spread
             : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163382]   .spread0
             : -6437682.564564

Oct 22 14:01:17 svfs-server kernel: [ 9382.163383]   .nr_spread_over
             : 671
Oct 22 14:01:17 svfs-server kernel: [ 9382.163384]   .nr_running
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163384]   .load
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163385]
.runnable_load_avg             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163386]   .blocked_load_avg
             : 906
Oct 22 14:01:17 svfs-server kernel: [ 9382.163386]   .tg_load_avg
             : 2928
Oct 22 14:01:17 svfs-server kernel: [ 9382.163387]   .tg_load_contrib
             : 896
Oct 22 14:01:17 svfs-server kernel: [ 9382.163388]
.tg_runnable_contrib           : 406
Oct 22 14:01:17 svfs-server kernel: [ 9382.163389]   .tg->runnable_avg
             : 1573
Oct 22 14:01:17 svfs-server kernel: [ 9382.163389]   .se->exec_start
             : 9382163.309702
Oct 22 14:01:17 svfs-server kernel: [ 9382.163390]   .se->vruntime
             : 7042599.787620
Oct 22 14:01:17 svfs-server kernel: [ 9382.163391]
.se->sum_exec_runtime          : 1770497.002064
Oct 22 14:01:17 svfs-server kernel: [ 9382.163392]
.se->statistics.wait_start     : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163393]
.se->statistics.sleep_start    : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163393]
.se->statistics.block_start    : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163394]
.se->statistics.sleep_max      : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163395]
.se->statistics.block_max      : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163396]
.se->statistics.exec_max       : 1194.107122
Oct 22 14:01:17 svfs-server kernel: [ 9382.163396]
.se->statistics.slice_max      : 222.295350
Oct 22 14:01:17 svfs-server kernel: [ 9382.163397]
.se->statistics.wait_max       : 795.379622
Oct 22 14:01:17 svfs-server kernel: [ 9382.163398]
.se->statistics.wait_sum       : 486007.262173
Oct 22 14:01:17 svfs-server kernel: [ 9382.163399]
.se->statistics.wait_count     : 31601128
Oct 22 14:01:17 svfs-server kernel: [ 9382.163399]   .se->load.weight
             : 2
Oct 22 14:01:17 svfs-server kernel: [ 9382.163400]
.se->avg.runnable_avg_sum      : 18392
Oct 22 14:01:17 svfs-server kernel: [ 9382.163401]
.se->avg.runnable_avg_period   : 46737
Oct 22 14:01:17 svfs-server kernel: [ 9382.163401]
.se->avg.load_avg_contrib      : 257
Oct 22 14:01:17 svfs-server kernel: [ 9382.163402]
.se->avg.decay_count           : 8947529
Oct 22 14:01:17 svfs-server kernel: [ 9382.163403]
Oct 22 14:01:17 svfs-server kernel: [ 9382.163403] cfs_rq[0]:/
Oct 22 14:01:17 svfs-server kernel: [ 9382.163404]   .exec_clock
             : 2449932.325515

Oct 22 14:01:17 svfs-server kernel: [ 9382.163406]   .MIN_vruntime
             : 7042590.787620
Oct 22 14:01:17 svfs-server kernel: [ 9382.163407]   .min_vruntime
             : 7042599.787620
Oct 22 14:01:17 svfs-server kernel: [ 9382.163408]   .max_vruntime
             : 7042590.787620
Oct 22 14:01:17 svfs-server kernel: [ 9382.163409]   .spread
             : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163410]   .spread0
             : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163410]   .nr_spread_over
             : 1299
Oct 22 14:01:17 svfs-server kernel: [ 9382.163411]   .nr_running
             : 1
Oct 22 14:01:17 svfs-server kernel: [ 9382.163412]   .load
             : 1024
Oct 22 14:01:17 svfs-server kernel: [ 9382.163412]
.runnable_load_avg             : 54
Oct 22 14:01:17 svfs-server kernel: [ 9382.163413]   .blocked_load_avg
             : 245
Oct 22 14:01:17 svfs-server kernel: [ 9382.163414]   .tg_load_avg
             : 1478
Oct 22 14:01:17 svfs-server kernel: [ 9382.163415]   .tg_load_contrib
             : 299
Oct 22 14:01:17 svfs-server kernel: [ 9382.163415]
.tg_runnable_contrib           : 477
Oct 22 14:01:17 svfs-server kernel: [ 9382.163416]   .tg->runnable_avg
             : 1902
Oct 22 14:01:17 svfs-server kernel: [ 9382.163417]
.avg->runnable_avg_sum         : 21709
Oct 22 14:01:17 svfs-server kernel: [ 9382.163418]
.avg->runnable_avg_period      : 47097
Oct 22 14:01:17 svfs-server kernel: [ 9382.163421]
Oct 22 14:01:17 svfs-server kernel: [ 9382.163421] rt_rq[0]:/
Oct 22 14:01:17 svfs-server kernel: [ 9382.163422]   .rt_nr_running
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163423]   .rt_throttled
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163424]   .rt_time
             : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163424]   .rt_runtime
             : 800.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163425]
Oct 22 14:01:17 svfs-server kernel: [ 9382.163425] runnable tasks:
Oct 22 14:01:17 svfs-server kernel: [ 9382.163425]             task
PID         tree-key  switches  prio     exec-runtime         sum-exec
       sum-sleep
Oct 22 14:01:17 svfs-server kernel: [ 9382.163425]
----------------------------------------------------------------------------------------------------------
Oct 22 14:01:17 svfs-server kernel: [ 9382.163438]
Oct 22 14:01:17 svfs-server kernel: [ 9382.163438] cpu#1, 3092.974
MHzOct 22 14:01:17 svfs-server kernel: [ 9382.163439]   .nr_running
                : 3
Oct 22 14:01:17 svfs-server kernel: [ 9382.163440]   .load
             : 589
Oct 22 14:01:17 svfs-server kernel: [ 9382.163441]   .nr_switches
             : 59296672
Oct 22 14:01:17 svfs-server kernel: [ 9382.163441]   .nr_load_updates
             : 1068144
Oct 22 14:01:17 svfs-server kernel: [ 9382.163442]
.nr_uninterruptible            : -25694
Oct 22 14:01:17 svfs-server kernel: [ 9382.163443]   .next_balance
             : 4297.226610
Oct 22 14:01:17 svfs-server kernel: [ 9382.163444]   .curr->pid
             : 7327
Oct 22 14:01:17 svfs-server kernel: [ 9382.163445]   .clock
             : 9382163.441304
Oct 22 14:01:17 svfs-server kernel: [ 9382.163446]   .cpu_load[0]
             : 936
Oct 22 14:01:17 svfs-server kernel: [ 9382.163446]   .cpu_load[1]
             : 560
Oct 22 14:01:17 svfs-server kernel: [ 9382.163447]   .cpu_load[2]
             : 363
Oct 22 14:01:17 svfs-server kernel: [ 9382.163448]   .cpu_load[3]
             : 362
Oct 22 14:01:17 svfs-server kernel: [ 9382.163448]   .cpu_load[4]
             : 430
Oct 22 14:01:17 svfs-server kernel: [ 9382.163449]   .yld_count
             : 282
Oct 22 14:01:17 svfs-server kernel: [ 9382.163450]   .sched_count
             : 59322252
Oct 22 14:01:17 svfs-server kernel: [ 9382.163450]   .sched_goidle
             : 13302389
Oct 22 14:01:17 svfs-server kernel: [ 9382.163451]   .avg_idle
             : 60654
Oct 22 14:01:17 svfs-server kernel: [ 9382.163452]   .ttwu_count
             : 40488695
Oct 22 14:01:17 svfs-server kernel: [ 9382.163453]   .ttwu_local
             : 16571033
Oct 22 14:01:17 svfs-server kernel: [ 9382.163454]
Oct 22 14:01:17 svfs-server kernel: [ 9382.163454] cfs_rq[1]:/autogroup-142
Oct 22 14:01:17 svfs-server kernel: [ 9382.163455]   .exec_clock
             : 37506.312540
Oct 22 14:01:17 svfs-server kernel: [ 9382.163455]   .MIN_vruntime
             : 0.000001
Oct 22 14:01:17 svfs-server kernel: [ 9382.163456]   .min_vruntime
             : 39425.880443
Oct 22 14:01:17 svfs-server kernel: [ 9382.163457]   .max_vruntime
             : 0.000001
Oct 22 14:01:17 svfs-server kernel: [ 9382.163458]   .spread
             : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163458]   .spread0
             : -7003173.907177
Oct 22 14:01:17 svfs-server kernel: [ 9382.163459]   .nr_spread_over
             : 222
Oct 22 14:01:17 svfs-server kernel: [ 9382.163460]   .nr_running
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163461]   .load
             : 0

Oct 22 14:01:17 svfs-server kernel: [ 9382.163461]
.runnable_load_avg             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163462]   .blocked_load_avg
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163463]   .tg_load_avg
             : 1058
Oct 22 14:01:17 svfs-server kernel: [ 9382.163463]   .tg_load_contrib
             : 88
Oct 22 14:01:17 svfs-server kernel: [ 9382.163464]
.tg_runnable_contrib           : 1
Oct 22 14:01:17 svfs-server kernel: [ 9382.163465]   .tg->runnable_avg
             : 84
Oct 22 14:01:17 svfs-server kernel: [ 9382.163465]   .se->exec_start
             : 9382161.434222
Oct 22 14:01:17 svfs-server kernel: [ 9382.163466]   .se->vruntime
             : 6917412.543171
Oct 22 14:01:17 svfs-server kernel: [ 9382.163467]
.se->sum_exec_runtime          : 37513.425648
Oct 22 14:01:17 svfs-server kernel: [ 9382.163468]
.se->statistics.wait_start     : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163469]
.se->statistics.sleep_start    : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163469]
.se->statistics.block_start    : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163470]
.se->statistics.sleep_max      : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163471]
.se->statistics.block_max      : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163472]
.se->statistics.exec_max       : 451.744397
Oct 22 14:01:17 svfs-server kernel: [ 9382.163472]
.se->statistics.slice_max      : 61.134929
Oct 22 14:01:17 svfs-server kernel: [ 9382.163473]
.se->statistics.wait_max       : 427.810957
Oct 22 14:01:17 svfs-server kernel: [ 9382.163474]
.se->statistics.wait_sum       : 6877.061064
Oct 22 14:01:17 svfs-server kernel: [ 9382.163475]
.se->statistics.wait_count     : 243773
Oct 22 14:01:17 svfs-server kernel: [ 9382.163475]   .se->load.weight
             : 2
Oct 22 14:01:17 svfs-server kernel: [ 9382.163476]
.se->avg.runnable_avg_sum      : 294
Oct 22 14:01:17 svfs-server kernel: [ 9382.163477]
.se->avg.runnable_avg_period   : 48635
Oct 22 14:01:17 svfs-server kernel: [ 9382.163477]
.se->avg.load_avg_contrib      : 4
Oct 22 14:01:17 svfs-server kernel: [ 9382.163478]
.se->avg.decay_count           : 8947527
Oct 22 14:01:17 svfs-server kernel: [ 9382.163479]
Oct 22 14:01:17 svfs-server kernel: [ 9382.163479] cfs_rq[1]:/autogroup-139
Oct 22 14:01:17 svfs-server kernel: [ 9382.163480]   .exec_clock
             : 1410.070092
Oct 22 14:01:17 svfs-server kernel: [ 9382.163481]   .MIN_vruntime
             : 0.000001
Oct 22 14:01:17 svfs-server kernel: [ 9382.163482]   .min_vruntime
             : 2028.249007
Oct 22 14:01:17 svfs-server kernel: [ 9382.163482]   .max_vruntime
             : 0.000001
Oct 22 14:01:17 svfs-server kernel: [ 9382.163483]   .spread
             : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163484]   .spread0
             : -7040571.538613
Oct 22 14:01:17 svfs-server kernel: [ 9382.163484]   .nr_spread_over
             : 55
Oct 22 14:01:17 svfs-server kernel: [ 9382.163485]   .nr_running
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163486]   .load
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163486]
.runnable_load_avg             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163487]   .blocked_load_avg
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163488]   .tg_load_avg
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163489]   .tg_load_contrib
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163489]
.tg_runnable_contrib           : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163490]   .tg->runnable_avg
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163491]   .se->exec_start
             : 9382157.418592
Oct 22 14:01:17 svfs-server kernel: [ 9382.163492]   .se->vruntime
             : 6917410.069957
Oct 22 14:01:17 svfs-server kernel: [ 9382.163492]
.se->sum_exec_runtime          : 1410.364725
Oct 22 14:01:17 svfs-server kernel: [ 9382.163493]
.se->statistics.wait_start     : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163494]
.se->statistics.sleep_start    : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163495]
.se->statistics.block_start    : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163495]
.se->statistics.sleep_max      : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163496]
.se->statistics.block_max      : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163497]
.se->statistics.exec_max       : 45.957852
Oct 22 14:01:17 svfs-server kernel: [ 9382.163498]
.se->statistics.slice_max      : 20.116419
Oct 22 14:01:17 svfs-server kernel: [ 9382.163498]
.se->statistics.wait_max       : 341.467156
Oct 22 14:01:17 svfs-server kernel: [ 9382.163499]
.se->statistics.wait_sum       : 1994.434062
Oct 22 14:01:17 svfs-server kernel: [ 9382.163500]
.se->statistics.wait_count     : 38834
Oct 22 14:01:17 svfs-server kernel: [ 9382.163501]   .se->load.weight
             : 2
Oct 22 14:01:17 svfs-server kernel: [ 9382.163501]
.se->avg.runnable_avg_sum      : 45
Oct 22 14:01:17 svfs-server kernel: [ 9382.163502]
.se->avg.runnable_avg_period   : 48124
Oct 22 14:01:17 svfs-server kernel: [ 9382.163503]
.se->avg.load_avg_contrib      : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163503]
.se->avg.decay_count           : 8947523
Oct 22 14:01:17 svfs-server kernel: [ 9382.163504]

Oct 22 14:01:17 svfs-server kernel: [ 9382.163504]
Oct 22 14:01:17 svfs-server kernel: [ 9382.163504] cfs_rq[1]:/autogroup-46
Oct 22 14:01:17 svfs-server kernel: [ 9382.163505]   .exec_clock
             : 16927.213369
Oct 22 14:01:17 svfs-server kernel: [ 9382.163506]   .MIN_vruntime
             : 0.000001
Oct 22 14:01:17 svfs-server kernel: [ 9382.163507]   .min_vruntime
             : 16113.219877
Oct 22 14:01:17 svfs-server kernel: [ 9382.163507]   .max_vruntime
             : 0.000001
Oct 22 14:01:17 svfs-server kernel: [ 9382.163508]   .spread
             : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163509]   .spread0
             : -7026486.567743
Oct 22 14:01:17 svfs-server kernel: [ 9382.163510]   .nr_spread_over
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163510]   .nr_running
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163511]   .load
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163512]
.runnable_load_avg             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163512]   .blocked_load_avg
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163513]   .tg_load_avg
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163514]   .tg_load_contrib
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163514]
.tg_runnable_contrib           : 3
Oct 22 14:01:17 svfs-server kernel: [ 9382.163515]   .tg->runnable_avg
             : 3
Oct 22 14:01:17 svfs-server kernel: [ 9382.163516]   .se->exec_start
             : 9382161.180011
Oct 22 14:01:17 svfs-server kernel: [ 9382.163517]   .se->vruntime
             : 6917412.281175
Oct 22 14:01:17 svfs-server kernel: [ 9382.163518]
.se->sum_exec_runtime          : 17008.684279
Oct 22 14:01:17 svfs-server kernel: [ 9382.163518]
.se->statistics.wait_start     : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163519]
.se->statistics.sleep_start    : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163520]
.se->statistics.block_start    : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163521]
.se->statistics.sleep_max      : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163521]
.se->statistics.block_max      : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163539]
.se->statistics.exec_max       : 505.558349
Oct 22 14:01:17 svfs-server kernel: [ 9382.163540]
.se->statistics.slice_max      : 30.102558
Oct 22 14:01:17 svfs-server kernel: [ 9382.163540]
.se->statistics.wait_max       : 428.143454
Oct 22 14:01:17 svfs-server kernel: [ 9382.163541]
.se->statistics.wait_sum       : 40636.016634
Oct 22 14:01:17 svfs-server kernel: [ 9382.163542]
.se->statistics.wait_count     : 550859
Oct 22 14:01:17 svfs-server kernel: [ 9382.163543]   .se->load.weight
             : 2
Oct 22 14:01:17 svfs-server kernel: [ 9382.163543]
.se->avg.runnable_avg_sum      : 154
Oct 22 14:01:17 svfs-server kernel: [ 9382.163544]
.se->avg.runnable_avg_period   : 46106
Oct 22 14:01:17 svfs-server kernel: [ 9382.163545]
.se->avg.load_avg_contrib      : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163545]
.se->avg.decay_count           : 8947527
Oct 22 14:01:17 svfs-server kernel: [ 9382.163546]
Oct 22 14:01:17 svfs-server kernel: [ 9382.163546] cfs_rq[1]:/autogroup-141
Oct 22 14:01:17 svfs-server kernel: [ 9382.163547]   .exec_clock
             : 1720603.505093
Oct 22 14:01:17 svfs-server kernel: [ 9382.163548]   .MIN_vruntime
             : 0.000001
Oct 22 14:01:17 svfs-server kernel: [ 9382.163549]   .min_vruntime
             : 565716.665036
Oct 22 14:01:17 svfs-server kernel: [ 9382.163549]   .max_vruntime
             : 0.000001
Oct 22 14:01:17 svfs-server kernel: [ 9382.163550]   .spread
             : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163551]   .spread0
             : -6476883.122584
Oct 22 14:01:17 svfs-server kernel: [ 9382.163552]   .nr_spread_over
             : 774
Oct 22 14:01:17 svfs-server kernel: [ 9382.163552]   .nr_running
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163553]   .load
             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163554]
.runnable_load_avg             : 0
Oct 22 14:01:17 svfs-server kernel: [ 9382.163554]   .blocked_load_avg
             : 704
Oct 22 14:01:17 svfs-server kernel: [ 9382.163555]   .tg_load_avg
             : 2937
Oct 22 14:01:17 svfs-server kernel: [ 9382.163556]   .tg_load_contrib
             : 661
Oct 22 14:01:17 svfs-server kernel: [ 9382.163557]
.tg_runnable_contrib           : 415
Oct 22 14:01:17 svfs-server kernel: [ 9382.163557]   .tg->runnable_avg
             : 1584
Oct 22 14:01:17 svfs-server kernel: [ 9382.163558]   .se->exec_start
             : 9382163.498953
Oct 22 14:01:17 svfs-server kernel: [ 9382.163559]   .se->vruntime
             : 6917424.524761
Oct 22 14:01:17 svfs-server kernel: [ 9382.163560]
.se->sum_exec_runtime          : 1720993.129342
Oct 22 14:01:17 svfs-server kernel: [ 9382.163560]
.se->statistics.wait_start     : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163561]
.se->statistics.sleep_start    : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163562]
.se->statistics.block_start    : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163563]
.se->statistics.sleep_max      : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163563]
.se->statistics.block_max      : 0.000000
Oct 22 14:01:17 svfs-server kernel: [ 9382.163564]
.se->statistics.exec_max       : 2389.453887

There are 400 more lines if you want them !


-Sandeep

>> After running this command, system will dump all blocked tasks in dmesg.
>>
>> Regards,
>>                                                 - Zheng
>
> Zheng
>
> The problem occurred as part of a larger system.  It might be too much
> effort to reuild the whole code on the latest mainline kernel.   Are
> there any ext4 bug fixes in the latest version which might make it
> worth the effort ?
>
> And are there any other debug options that I can turn on inside the
> kernel which might help ?
>
> -Sandeep
