From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12579] New: ext4 filesystem hang
Date: Thu, 29 Jan 2009 21:03:42 -0800 (PST)
Message-ID: <bug-12579-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34081 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750955AbZA3FER (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Jan 2009 00:04:17 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0U53gUm004640
	for <linux-ext4@vger.kernel.org>; Thu, 29 Jan 2009 21:03:43 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12579

           Summary: ext4 filesystem hang
           Product: File System
           Version: 2.5
     KernelVersion: 2.6.29-rc2-git1
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: sandeen@redhat.com


Latest working kernel version:
Earliest failing kernel version: 2.6.29 rc2 git1
Distribution: Rawhide
Hardware Environment: x86_64
Software Environment: Rawhide
Problem Description:

Deadlock/hang:

SysRq : Show Blocked State
  task                        PC stack   pid father
livecd-creato D ffff880001869f30  3096 11953   3276
 ffff880064cc1b18 0000000000000046 0000000000000001 0000000000000002
 ffffffff818fe700 ffffffff818fe700 ffff8800836cf000 ffff880010f28000
 ffff88006389a390 ffff880010f283b8 0000000000000000 0000000000000046
Call Trace:
 [<ffffffff81016ec0>] ? read_tsc+0xe/0x24
 [<ffffffff81066749>] ? getnstimeofday+0x58/0xb4
 [<ffffffff81380f70>] io_schedule+0x63/0xa5
 [<ffffffff810a7029>] sync_page+0x49/0x4d
 [<ffffffff8138136a>] __wait_on_bit_lock+0x45/0x79
 [<ffffffff810a6fe0>] ? sync_page+0x0/0x4d
 [<ffffffff810a6f93>] __lock_page+0x63/0x6a
 [<ffffffff8105f0c8>] ? wake_bit_function+0x0/0x2a
 [<ffffffff810ae25b>] write_cache_pages+0x1fc/0x3a4
 [<ffffffffa0020231>] ? __mpage_da_writepage+0x0/0x163 [ext4]
 [<ffffffffa0005329>] ? jbd2_journal_start+0xef/0x119 [jbd2]
 [<ffffffffa0005329>] ? jbd2_journal_start+0xef/0x119 [jbd2]
 [<ffffffffa001ffe1>] ext4_da_writepages+0x2c0/0x457 [ext4]
 [<ffffffff8138164c>] ? mutex_unlock+0x9/0xb
 [<ffffffff810a8b01>] ? generic_file_aio_write+0x74/0xc5
 [<ffffffff8106ebcb>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffffa0021310>] ? ext4_da_get_block_write+0x0/0x130 [ext4]
 [<ffffffff810ae456>] do_writepages+0x2b/0x3b
 [<ffffffff810a7b3f>] __filemap_fdatawrite_range+0x51/0x59
 [<ffffffff810a889a>] filemap_fdatawrite+0x1a/0x1c
 [<ffffffff810fbbe5>] vfs_fsync+0x53/0xac
 [<ffffffff810fbc70>] do_fsync+0x32/0x48
 [<ffffffff810fbc94>] sys_fdatasync+0xe/0x12
 [<ffffffff810112ba>] system_call_fastpath+0x16/0x1b
kjournald2    D ffff88000c475e28  5040 11969      2
 ffff88000c475d40 0000000000000046 0000000000000000 0000000000000046
 ffffffff818fe700 ffffffff818fe700 0000000000000000 ffff880014882390
 ffff88007eb88000 ffff880014882748 000000000c475ce0 0000000000000046
Call Trace:
 [<ffffffff8105f215>] ? prepare_to_wait+0x1c/0x5e
 [<ffffffff81383055>] ? _spin_unlock_irqrestore+0x47/0x57
 [<ffffffff8106d609>] ? trace_hardirqs_on_caller+0x1f/0x153
 [<ffffffff8119a55f>] ? _raw_spin_unlock+0x8e/0x93
 [<ffffffffa00057e8>] jbd2_journal_commit_transaction+0x25c/0x159c [jbd2]
 [<ffffffff81054bf5>] ? lock_timer_base+0x26/0x4a
 [<ffffffff81383055>] ? _spin_unlock_irqrestore+0x47/0x57
 [<ffffffff8106d609>] ? trace_hardirqs_on_caller+0x1f/0x153
 [<ffffffff8105f090>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff81054c67>] ? try_to_del_timer_sync+0x4e/0x5c
 [<ffffffffa000a68c>] kjournald2+0x172/0x3a8 [jbd2]
 [<ffffffff8105f090>] ? autoremove_wake_function+0x0/0x38
 [<ffffffffa000a51a>] ? kjournald2+0x0/0x3a8 [jbd2]
 [<ffffffff8105ed18>] kthread+0x49/0x76
 [<ffffffff8101262a>] child_rip+0xa/0x20
 [<ffffffff81383002>] ? _spin_unlock_irq+0x2b/0x37
 [<ffffffff8106d74a>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff81011f3e>] ? restore_args+0x0/0x30
 [<ffffffff8105ecaa>] ? kthreadd+0x176/0x19b
 [<ffffffff8105eccf>] ? kthread+0x0/0x76
 [<ffffffff81012620>] ? child_rip+0x0/0x20
pdflush       D ffff880001878350   992 12227      2
 ffff880050975960 0000000000000046 0000000000000000 ffff8800724d8ea0
 ffffffff818fe700 ffffffff818fe700 ffff8800509758e0 ffff880076c48000
 ffffffff815334f0 ffff880076c483b8 0000000000000046 0000000000000046
Call Trace:
 [<ffffffff8105f173>] ? prepare_to_wait_exclusive+0x1c/0x5e
 [<ffffffff81016ec0>] ? read_tsc+0xe/0x24
 [<ffffffff81066749>] ? getnstimeofday+0x58/0xb4
 [<ffffffff81380f70>] io_schedule+0x63/0xa5
 [<ffffffff810a7029>] sync_page+0x49/0x4d
 [<ffffffff8138136a>] __wait_on_bit_lock+0x45/0x79
 [<ffffffff810a6fe0>] ? sync_page+0x0/0x4d
 [<ffffffff810a6f93>] __lock_page+0x63/0x6a
 [<ffffffff8105f0c8>] ? wake_bit_function+0x0/0x2a
 [<ffffffff810ae25b>] write_cache_pages+0x1fc/0x3a4
 [<ffffffffa0020231>] ? __mpage_da_writepage+0x0/0x163 [ext4]
 [<ffffffffa0005329>] ? jbd2_journal_start+0xef/0x119 [jbd2]
 [<ffffffffa001ffe1>] ext4_da_writepages+0x2c0/0x457 [ext4]
 [<ffffffff810ae375>] ? write_cache_pages+0x316/0x3a4
 [<ffffffff8106ebcb>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff8103b23a>] ? account_group_exec_runtime+0x2c/0x44
 [<ffffffff8106ebcb>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffffa0021310>] ? ext4_da_get_block_write+0x0/0x130 [ext4]
 [<ffffffff810ae456>] do_writepages+0x2b/0x3b
 [<ffffffff810f893e>] __writeback_single_inode+0x187/0x2fc
 [<ffffffff810f8ee0>] ? generic_sync_sb_inodes+0x275/0x362
 [<ffffffff810f8e86>] generic_sync_sb_inodes+0x21b/0x362
 [<ffffffff810f91c3>] writeback_inodes+0xa2/0xfa
 [<ffffffff810aeaaf>] background_writeout+0x92/0xcb
 [<ffffffff810af0eb>] pdflush+0x14e/0x201
 [<ffffffff810aea1d>] ? background_writeout+0x0/0xcb
 [<ffffffff810aef9d>] ? pdflush+0x0/0x201
 [<ffffffff8105ed18>] kthread+0x49/0x76
 [<ffffffff8101262a>] child_rip+0xa/0x20
 [<ffffffff81383002>] ? _spin_unlock_irq+0x2b/0x37
 [<ffffffff8106d74a>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff81011f3e>] ? restore_args+0x0/0x30
 [<ffffffff8105ecaa>] ? kthreadd+0x176/0x19b
 [<ffffffff8105eccf>] ? kthread+0x0/0x76
 [<ffffffff81012620>] ? child_rip+0x0/0x20
Sched Debug Version: v0.08, 2.6.29-0.53.rc2.git1.fc11.x86_64 #1
now at 8999693.829504 msecs
  .sysctl_sched_latency                    : 40.000000
  .sysctl_sched_min_granularity            : 8.000000
  .sysctl_sched_wakeup_granularity         : 10.000000
  .sysctl_sched_child_runs_first           : 0.000001
  .sysctl_sched_features                   : 24191

cpu#0, 2666.818 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 5337240
  .nr_load_updates               : 3406197
  .nr_uninterruptible            : -5686
  .jiffies                       : 4303666545
  .next_balance                  : 4303.666549
  .curr->pid                     : 0
  .clock                         : 8999757.002901
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 0
  .cpu_load[2]                   : 0
  .cpu_load[3]                   : 0
  .cpu_load[4]                   : 0
  .yld_exp_empty                 : 0
  .yld_act_empty                 : 0
  .yld_both_empty                : 0
  .yld_count                     : 693
  .sched_switch                  : 0
  .sched_count                   : 5466466
  .sched_goidle                  : 1234594
  .ttwu_count                    : 3148627
  .ttwu_local                    : 2728322
  .bkl_count                     : 50886

cfs_rq[0]:/
  .exec_clock                    : 2295440.884259
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 42668359.480395
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 336023
  .shares                        : 0

rt_rq[0]:/
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime       
 sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

cpu#1, 2666.818 MHz
  .nr_running                    : 1
  .load                          : 1024
  .nr_switches                   : 4843840
  .nr_load_updates               : 3459888
  .nr_uninterruptible            : 5693
  .jiffies                       : 4303666545
  .next_balance                  : 4303.666801
  .curr->pid                     : 13252
  .clock                         : 8999249.133201
  .cpu_load[0]                   : 1024
  .cpu_load[1]                   : 561
  .cpu_load[2]                   : 448
  .cpu_load[3]                   : 422
  .cpu_load[4]                   : 476
  .yld_exp_empty                 : 0
  .yld_act_empty                 : 0
  .yld_both_empty                : 0
  .yld_count                     : 1603
  .sched_switch                  : 0
  .sched_count                   : 5039690
  .sched_goidle                  : 1429690
  .ttwu_count                    : 2758073
  .ttwu_local                    : 2199222
  .bkl_count                     : 38801

cfs_rq[1]:/
  .exec_clock                    : 1717848.884015
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 50983710.080737
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 8315350.600342
  .nr_running                    : 1
  .load                          : 1024
  .nr_spread_over                : 385373
  .shares                        : 0

rt_rq[1]:/
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime       
 sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
R           bash 13252  50983710.080737       245   120  50983710.080737      
868.862431     66420.517493 /



Steps to reproduce:

Run livecd-creator from rawhide to create a desktop spin:

livecd-creator --config
/usr/share/spin-kickstarts/fedora-livecd-desktop-en_US.ks --cache
/mnt/test/livecd/cache --tmpdir /mnt/test/livecd/tmp

kickstart file modified to create image on ext4

haven't dug into this yet but wanted to capture it.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
