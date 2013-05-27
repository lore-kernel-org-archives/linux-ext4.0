From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [BUG] xfstest269 causes deadlock on linux-3.9.0 (ext4)
Date: Mon, 27 May 2013 12:16:01 +0400
Message-ID: <8738t8on26.fsf@openvz.org>
References: <51908CF4.2000703@rs.jp.nec.com> <20130514213755.GA10769@quack.suse.cz> <5192F998.6080706@rs.jp.nec.com> <51A2BB97.7030802@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Akira Fujita <a-fujita@rs.jp.nec.com>, Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:37815 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756774Ab3E0IQG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 May 2013 04:16:06 -0400
Received: by mail-la0-f47.google.com with SMTP id fq12so6130164lab.6
        for <linux-ext4@vger.kernel.org>; Mon, 27 May 2013 01:16:04 -0700 (PDT)
In-Reply-To: <51A2BB97.7030802@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 27 May 2013 10:49:11 +0900, Akira Fujita <a-fujita@rs.jp.nec.com> wrote:
> Hi Jan,
> 
> (2013/05/15 11:57), Akira Fujita wrote:
> > Hi,
> > 
> > (2013/05/15 6:37), Jan Kara wrote:
> >>     Hello,
> >>
> >> On Mon 13-05-13 15:49:24, Akira Fujita wrote:
> >>> I ran into the deaclock with xfs_test 269 on linux-3.9.0.
> >>> It seems happen between jbd2_log_wait_commit, sleep_on_buffer
> >>> and writeback_indoes (Please see ps log below).
> >>> Once it occurs we can't touch FS anymore.
> >>> In my case 300 - 1000 trials to occur. Is this known issue?
> >>>
> >>> The following kernels seems to have same problem:
> >>> - linux-3.5-rc5
> >>> - linux-3.8.5
> >>> - linux-3.9-rc7
> >>> And now I'm trying it on linux-3.10-rc1.
> >>>
> >>> # ./check generic/269
> >>> FSTYP         -- ext4
> >>> PLATFORM      -- Linux/x86_64 mcds1 3.9.0
> >>> MKFS_OPTIONS  -- /dev/sda12
> >>> MOUNT_OPTIONS -- -o acl,user_xattr /dev/sda12 /mnt/mp2
> >>>
> >>>
> >>> # ps -eo pid,tid,class,rtprio,ni,pri,psr,pcpu,stat,wchan:16,comm
> >>>     PID   TID CLS RTPRIO  NI PRI PSR %CPU STAT WCHAN            COMMAND
> >>>       1     1 TS       -   0  19   0  0.0 Ss   poll_schedule_ti init
> >>>       2     2 TS       -   0  19   0  0.0 S    kthreadd         kthreadd
> >>>       3     3 TS       -   0  19   0  0.0 S    smpboot_thread_f ksoftirqd/0
> >>> ...
> >>>    2391  2391 TS       -   0  19   2  0.1 D    jbd2_log_wait_co flush-8:0
> >>> ...
> >>> 22647 22647 TS       -   0  19   3  0.0 S    worker_thread    kworker/3:1
> >>> 22655 22655 TS       -   0  19   0  0.0 S    hrtimer_nanoslee sleep
> >>> 22657 22657 TS       -   0  19   2  0.0 R+   -                ps
> >>> 25330 25330 TS       -   0  19   0  0.0 S    worker_thread    kworker/0:0
> >>> 28963 28963 TS       -   0  19   1  0.0 S+   wait             loop_xfstests.s
> >>> 28964 28964 TS       -   0  19   1  0.0 S+   wait             check
> >>> 29180 29180 TS       -   0  19   3  0.0 S    kjournald2       jbd2/sda11-8
> >>> 29181 29181 TS       - -20  39   3  0.0 S<   rescuer_thread   ext4-dio-unwrit
> >>> 29199 29199 TS       -   0  19   3  0.0 S+   wait             269
> >>> 29391 29391 TS       -   0  19   0  0.6 D    sleep_on_buffer  jbd2/sda12-8
> >>> 29392 29392 TS       - -20  39   3  0.0 S<   rescuer_thread   ext4-dio-unwrit
> >>> 29394 29394 TS       -   0  19   0  0.0 S    wait             fsstress
> >>> 29505 29505 TS       -   0  19   3  0.0 D    writeback_inodes fsstress
> >>>
> >>> # df -T /dev/sda11 /dev/sda12
> >>> Filesystem    Type   1K-blocks      Used Available Use% Mounted on
> >>> /dev/sda11    ext4     9857264     22308   9327564   1% /mnt/mp1
> >>> /dev/sda12    ext4      499656    499656         0 100% /mnt/mp2
> >>     Thanks for report. No I don't think this problem has been reported
> >> before. Seeing that sda12 is out of space and fsstress hangs in
> >> writeback_inodes(), I suspect we have some deadlock in ENOSPC recovery path
> >> when we want to flush data to disk to reduce delalloc uncertainty. Can you
> >> run 'echo w >/proc/sysrq-trigger' when the deadlock happens and post your
> >> dmesg here? Thanks!
> >>
> > 
> > Thanks for reply.
> > I'll take that information when the deadlock happens again.
> 
> Finally, I got the following messages on linux-3.9.0.
> Could you take a look?
Is it a real deadlock?
umount wait for flush-8:0
flush wait for jbd2
jbd2 wait for bh.
All buffer-heads will be written at sooner or later.
It probably will require significant amount of time, because fs is too
fragmented(that is what this test all about), but it is not a deadlock.
> 
> #echo w > /proc/sysrq-trigger
> /var/log/messages:
> -----------------------
> May 23 19:15:50 mcds1 kernel: [210728.230978] SysRq : Show Blocked State
> May 23 19:15:50 mcds1 kernel: [210728.230985]   task                        PC stack   pid father
> May 23 19:15:50 mcds1 kernel: [210728.230992] flush-8:0       D ffffffff81806d60  3192  2361      2 0x00000000
> May 23 19:15:50 mcds1 kernel: [210728.230997]  ffff880214d27a08 0000000000000046 0000000000000282 ffff88021608d330
> May 23 19:15:50 mcds1 kernel: [210728.231001]  0000000000000000 ffff880215d95ac0 0000000000012980 ffff880214d27fd8
> May 23 19:15:50 mcds1 kernel: [210728.231005]  ffff880214d26010 0000000000012980 0000000000012980 ffff880214d27fd8
> May 23 19:15:50 mcds1 kernel: [210728.231008] Call Trace:
> May 23 19:15:50 mcds1 kernel: [210728.231018]  [<ffffffff81798ae4>] schedule+0x24/0x70
> May 23 19:15:50 mcds1 kernel: [210728.231023]  [<ffffffff81204b95>] jbd2_log_wait_commit+0xb5/0x130
> May 23 19:15:50 mcds1 kernel: [210728.231029]  [<ffffffff81060830>] ? wake_up_bit+0x40/0x40
> May 23 19:15:50 mcds1 kernel: [210728.231033]  [<ffffffff81204cb4>] ? __jbd2_log_start_commit+0xa4/0xb0
> May 23 19:15:50 mcds1 kernel: [210728.231037]  [<ffffffff81204e4b>] jbd2_journal_force_commit_nested+0x5b/0xa0
> May 23 19:15:50 mcds1 kernel: [210728.231041]  [<ffffffff811b75c8>] ext4_da_writepages+0x348/0x5a0
> May 23 19:15:50 mcds1 kernel: [210728.231045]  [<ffffffff81074e77>] ? check_preempt_wakeup+0x1b7/0x2a0
> May 23 19:15:50 mcds1 kernel: [210728.231051]  [<ffffffff810f0f5b>] do_writepages+0x1b/0x30
> May 23 19:15:50 mcds1 kernel: [210728.231056]  [<ffffffff8115d9d4>] __writeback_single_inode+0x44/0x220
> May 23 19:15:50 mcds1 kernel: [210728.231061]  [<ffffffff8115e93f>] writeback_sb_inodes+0x23f/0x430
> May 23 19:15:50 mcds1 kernel: [210728.231065]  [<ffffffff8115ed6d>] wb_writeback+0xed/0x2b0
> May 23 19:15:50 mcds1 kernel: [210728.231071]  [<ffffffff8104c537>] ? lock_timer_base+0x37/0x70
> May 23 19:15:50 mcds1 kernel: [210728.231075]  [<ffffffff8115efcd>] wb_do_writeback+0x9d/0x240
> May 23 19:15:50 mcds1 kernel: [210728.231079]  [<ffffffff8104c570>] ? lock_timer_base+0x70/0x70
> May 23 19:15:50 mcds1 kernel: [210728.231084]  [<ffffffff8115f212>] bdi_writeback_thread+0xa2/0x230
> May 23 19:15:50 mcds1 kernel: [210728.231088]  [<ffffffff8115f170>] ? wb_do_writeback+0x240/0x240
> May 23 19:15:50 mcds1 kernel: [210728.231092]  [<ffffffff8115f170>] ? wb_do_writeback+0x240/0x240
> May 23 19:15:50 mcds1 kernel: [210728.231095]  [<ffffffff81060136>] kthread+0xc6/0xd0
> May 23 19:15:50 mcds1 kernel: [210728.231099]  [<ffffffff81060070>] ? kthread_freezable_should_stop+0x70/0x70
> May 23 19:15:50 mcds1 kernel: [210728.231104]  [<ffffffff817a19ac>] ret_from_fork+0x7c/0xb0
> May 23 19:15:50 mcds1 kernel: [210728.231108]  [<ffffffff81060070>] ? kthread_freezable_should_stop+0x70/0x70
> May 23 19:15:50 mcds1 kernel: [210728.231124] jbd2/sda12-8    D ffffffff81806d60  4736 25056      2 0x00000000
> May 23 19:15:50 mcds1 kernel: [210728.231128]  ffff8801e436db78 0000000000000046 ffff880215c06f00 ffffffff81c10420
> May 23 19:15:50 mcds1 kernel: [210728.231131]  ffff880200011200 ffff8801f8f296b0 0000000000012980 ffff8801e436dfd8
> May 23 19:15:50 mcds1 kernel: [210728.231135]  ffff8801e436c010 0000000000012980 0000000000012980 ffff8801e436dfd8
> May 23 19:15:50 mcds1 kernel: [210728.231138] Call Trace:
> May 23 19:15:50 mcds1 kernel: [210728.231142]  [<ffffffff81166c50>] ? __wait_on_buffer+0x30/0x30
> May 23 19:15:50 mcds1 kernel: [210728.231146]  [<ffffffff81798ae4>] schedule+0x24/0x70
> May 23 19:15:50 mcds1 kernel: [210728.231150]  [<ffffffff81798bb7>] io_schedule+0x87/0xd0
> May 23 19:15:50 mcds1 kernel: [210728.231154]  [<ffffffff81166c59>] sleep_on_buffer+0x9/0x10
> May 23 19:15:50 mcds1 kernel: [210728.231157]  [<ffffffff817971d7>] __wait_on_bit+0x57/0x80
> May 23 19:15:50 mcds1 kernel: [210728.231161]  [<ffffffff81165f7c>] ? submit_bh+0x13c/0x1f0
> May 23 19:15:50 mcds1 kernel: [210728.231164]  [<ffffffff81166c50>] ? __wait_on_buffer+0x30/0x30
> May 23 19:15:50 mcds1 kernel: [210728.231168]  [<ffffffff81797273>] out_of_line_wait_on_bit+0x73/0x90
> May 23 19:15:50 mcds1 kernel: [210728.231172]  [<ffffffff81060870>] ? autoremove_wake_function+0x40/0x40
> May 23 19:15:50 mcds1 kernel: [210728.231175]  [<ffffffff81166c46>] __wait_on_buffer+0x26/0x30
> May 23 19:15:50 mcds1 kernel: [210728.231179]  [<ffffffff811ff130>] jbd2_journal_commit_transaction+0xee0/0x1960
> May 23 19:15:50 mcds1 kernel: [210728.231183]  [<ffffffff817984fd>] ? __schedule+0x3ad/0x7a0
> May 23 19:15:50 mcds1 kernel: [210728.231188]  [<ffffffff8104c537>] ? lock_timer_base+0x37/0x70
> May 23 19:15:50 mcds1 kernel: [210728.231191]  [<ffffffff81204f62>] kjournald2+0xc2/0x240
> May 23 19:15:50 mcds1 kernel: [210728.231195]  [<ffffffff81060830>] ? wake_up_bit+0x40/0x40
> May 23 19:15:50 mcds1 kernel: [210728.231199]  [<ffffffff81204ea0>] ? commit_timeout+0x10/0x10
> May 23 19:15:50 mcds1 kernel: [210728.231202]  [<ffffffff81060136>] kthread+0xc6/0xd0
> May 23 19:15:50 mcds1 kernel: [210728.231206]  [<ffffffff81060070>] ? kthread_freezable_should_stop+0x70/0x70
> May 23 19:15:50 mcds1 kernel: [210728.231210]  [<ffffffff817a19ac>] ret_from_fork+0x7c/0xb0
> May 23 19:15:50 mcds1 kernel: [210728.231213]  [<ffffffff81060070>] ? kthread_freezable_should_stop+0x70/0x70
> May 23 19:15:50 mcds1 kernel: [210728.231216] umount          D ffffffff81806d60  5448 25241  24864 0x00000000
> May 23 19:15:50 mcds1 kernel: [210728.231220]  ffff8801f3a89c28 0000000000000086 ffff88021fc929f0 ffff88021608cba0
> May 23 19:15:50 mcds1 kernel: [210728.231223]  ffff8801f3a89bf8 ffff8801f84d8790 0000000000012980 ffff8801f3a89fd8
> May 23 19:15:50 mcds1 kernel: [210728.231226]  ffff8801f3a88010 0000000000012980 0000000000012980 ffff8801f3a89fd8
> May 23 19:15:50 mcds1 kernel: [210728.231230] Call Trace:
> May 23 19:15:50 mcds1 kernel: [210728.231234]  [<ffffffff81798ae4>] schedule+0x24/0x70
> May 23 19:15:50 mcds1 kernel: [210728.231237]  [<ffffffff81796f4d>] schedule_timeout+0x15d/0x1f0
> May 23 19:15:50 mcds1 kernel: [210728.231241]  [<ffffffff8106f2b5>] ? __cond_resched+0x25/0x40
> May 23 19:15:50 mcds1 kernel: [210728.231245]  [<ffffffff81798f64>] wait_for_completion+0x94/0x100
> May 23 19:15:50 mcds1 kernel: [210728.231248]  [<ffffffff81070ca0>] ? try_to_wake_up+0x2a0/0x2a0
> May 23 19:15:50 mcds1 kernel: [210728.231252]  [<ffffffff8115ddb1>] ? bdi_queue_work+0x81/0x110
> May 23 19:15:50 mcds1 kernel: [210728.231256]  [<ffffffff8115dec3>] writeback_inodes_sb_nr+0x83/0xb0
> May 23 19:15:50 mcds1 kernel: [210728.231261]  [<ffffffff8115df4a>] writeback_inodes_sb+0x5a/0x70
> May 23 19:15:50 mcds1 kernel: [210728.231264]  [<ffffffff8116463a>] __sync_filesystem+0x4a/0x50
> May 23 19:15:50 mcds1 kernel: [210728.231267]  [<ffffffff81164672>] sync_filesystem+0x32/0x60
> May 23 19:15:50 mcds1 kernel: [210728.231273]  [<ffffffff81137be6>] generic_shutdown_super+0x36/0xe0
> May 23 19:15:50 mcds1 kernel: [210728.231277]  [<ffffffff81137cbc>] kill_block_super+0x2c/0x80
> May 23 19:15:50 mcds1 kernel: [210728.231281]  [<ffffffff811381f5>] deactivate_locked_super+0x45/0x70
> May 23 19:15:50 mcds1 kernel: [210728.231284]  [<ffffffff81139025>] deactivate_super+0x45/0x60
> May 23 19:15:50 mcds1 kernel: [210728.231287]  [<ffffffff81152f63>] mntput_no_expire+0xf3/0x150
> May 23 19:15:50 mcds1 kernel: [210728.231290]  [<ffffffff811537dd>] sys_umount+0xcd/0x3f0
> May 23 19:15:50 mcds1 kernel: [210728.231294]  [<ffffffff817a1a52>] system_call_fastpath+0x16/0x1b
> 
> Regards,
> Akira Fujita
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
