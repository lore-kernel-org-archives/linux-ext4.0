From: Theodore Ts'o <tytso@mit.edu>
Subject: xfstests failure generic/299
Date: Fri, 12 Apr 2013 17:03:12 -0400
Message-ID: <nsxvc7ra2cv.fsf@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33914 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754185Ab3DLVDR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 12 Apr 2013 17:03:17 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Dmitry,

I've been noticing that the relatively new test #299 (which I didn't use
in the previous development cycle) is failing for me, both for the
current ext4 dev branch, as well as v3.9-rc5-1-g8cde7ad (the
origin/branch point from Linus's tree for the dev branch).

Is this test passing for you, and is there some patch whic I'm missing
which addresses this?

Thanks,

                                        - Ted


generic/299             [16:34:59][  155.348963] fio (3364) used
greatest stack depth: 5280 bytes left
[  156.195750] fio (3366) used greatest stack depth: 5184 bytes left
[  156.243934] fio (3363) used greatest stack depth: 4960 bytes left
^[[A[  361.330343] INFO: task umount:3426 blocked for more than 120
seconds.
[  361.331097] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  361.331823]  f4361d90 00000046 f043a000 c16a0ac0 c16a0ac0 75e421ae
00000028 00000000
[  361.332620]  00000000 f5ba02a0 c016c753 75e41aee 00000000 f6ad4080
75e41739 00000028
[  361.333479]  00000001 00000000 f6ad4080 f4361da4 c020882b 00000000
f6ad4080 75e40f23
[  361.334250] Call Trace:
[  361.334728]  [<c016c753>] ? sched_clock+0x17/0x29
[  361.335272]  [<c020882b>] ? sched_clock_cpu+0x1e2/0x20e
[  361.335781]  [<c0f5a34e>] schedule+0xe3/0xf4
[  361.336182]  [<c0f57361>] schedule_timeout+0x28/0x12b
[  361.336681]  [<c023ce71>] ? mark_held_locks+0xc1/0xff
[  361.337156]  [<c0f5d16d>] ? _raw_spin_unlock_irq+0x5f/0xa9
[  361.337652]  [<c023d156>] ? trace_hardirqs_on_caller+0x2a7/0x332
[  361.338188]  [<c023d208>] ? trace_hardirqs_on+0x27/0x37
[  361.338631]  [<c0f5d180>] ? _raw_spin_unlock_irq+0x72/0xa9
[  361.339095]  [<c0f59fd8>] __wait_for_common+0xfa/0x1a5
[  361.339534]  [<c0f57339>] ? console_conditional_schedule+0x61/0x61
[  361.340119]  [<c020628f>] ? try_to_wake_up+0x377/0x377
[  361.340561]  [<c0f5a25a>] wait_for_completion+0x27/0x38
[  361.341014]  [<c0372aa1>] writeback_inodes_sb_nr+0x122/0x13b
[  361.341502]  [<c0f59f38>] ? __wait_for_common+0x5a/0x1a5
[  361.341963]  [<c0372bee>] writeback_inodes_sb+0x3a/0x4c
[  361.342413]  [<c037843a>] __sync_filesystem+0x3f/0xa8
[  361.342848]  [<c037850e>] sync_filesystem+0x6b/0xa8
[  361.343274]  [<c033782b>] generic_shutdown_super+0x56/0x18c
[  361.343833]  [<c0337991>] kill_block_super+0x30/0xd2
[  361.344418]  [<c0337b0f>] deactivate_locked_super+0x3e/0xb9
[  361.344919]  [<c0338bf3>] deactivate_super+0x69/0x7a
[  361.345350]  [<c0360827>] mntput_no_expire+0x23b/0x24e
[  361.345795]  [<c036229c>] sys_umount+0x5f4/0x60c
[  361.346199]  [<c03622d4>] sys_oldumount+0x20/0x30
[  361.346607]  [<c0f5d668>] syscall_call+0x7/0xb
[  361.347027] 1 lock held by umount/3426:
[  361.347361]  #0:  (&type->s_umount_key#18){++++..}, at: [<c0338bde>]
deactivate_super+0x54/0x7a
 [16:40:14] [failed, exit status 1] - output mismatch (see
 /root/xfstests/results/generic/299.out.bad)
    --- tests/generic/299.out   2013-04-05 21:41:17.000000000 -0400
    +++ /root/xfstests/results/generic/299.out.bad      2013-04-12
    16:40:14.678565323 -0400
    @@ -3,3 +3,6 @@
     Run fio with random aio-dio pattern
     
     Start fallocate/truncate loop
    +./common/rc: line 2055:  3353 Segmentation fault      "$@" >>
    $seqres.full 2>&1
    +failed: '/root/xfstests/bin/fio /tmp/3152-299.fio'
    +(see /root/xfstests/results/generic/299.full for details)
     ...
     (Run 'diff -u tests/generic/299.out
    /root/xfstests/results/generic/299.out.bad' to see the entire diff)
Ran: generic/299
Failures: generic/299
