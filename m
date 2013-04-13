From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: xfstests failure generic/299
Date: Sat, 13 Apr 2013 13:09:27 +0400
Message-ID: <87sj2uokzc.fsf@openvz.org>
References: <nsxvc7ra2cv.fsf@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:46797 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab3DMJJc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 13 Apr 2013 05:09:32 -0400
Received: by mail-lb0-f176.google.com with SMTP id y8so3305358lbh.35
        for <linux-ext4@vger.kernel.org>; Sat, 13 Apr 2013 02:09:31 -0700 (PDT)
In-Reply-To: <nsxvc7ra2cv.fsf@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 12 Apr 2013 17:03:12 -0400, Theodore Ts'o <tytso@mit.edu> wrote:
> Hi Dmitry,
> 
> I've been noticing that the relatively new test #299 (which I didn't use
> in the previous development cycle) is failing for me, both for the
> current ext4 dev branch, as well as v3.9-rc5-1-g8cde7ad (the
> origin/branch point from Linus's tree for the dev branch).
> 
> Is this test passing for you, and is there some patch whic I'm missing
> which addresses this?
> 
> Thanks,
> 
>                                         - Ted
> 
> 
> generic/299             [16:34:59][  155.348963] fio (3364) used
> greatest stack depth: 5280 bytes left
> [  156.195750] fio (3366) used greatest stack depth: 5184 bytes left
> [  156.243934] fio (3363) used greatest stack depth: 4960 bytes left
> ^[[A[  361.330343] INFO: task umount:3426 blocked for more than 120
> seconds.
> [  361.331097] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  361.331823]  f4361d90 00000046 f043a000 c16a0ac0 c16a0ac0 75e421ae
> 00000028 00000000
> [  361.332620]  00000000 f5ba02a0 c016c753 75e41aee 00000000 f6ad4080
> 75e41739 00000028
> [  361.333479]  00000001 00000000 f6ad4080 f4361da4 c020882b 00000000
> f6ad4080 75e40f23
> [  361.334250] Call Trace:
> [  361.334728]  [<c016c753>] ? sched_clock+0x17/0x29
> [  361.335272]  [<c020882b>] ? sched_clock_cpu+0x1e2/0x20e
> [  361.335781]  [<c0f5a34e>] schedule+0xe3/0xf4
> [  361.336182]  [<c0f57361>] schedule_timeout+0x28/0x12b
> [  361.336681]  [<c023ce71>] ? mark_held_locks+0xc1/0xff
> [  361.337156]  [<c0f5d16d>] ? _raw_spin_unlock_irq+0x5f/0xa9
> [  361.337652]  [<c023d156>] ? trace_hardirqs_on_caller+0x2a7/0x332
> [  361.338188]  [<c023d208>] ? trace_hardirqs_on+0x27/0x37
> [  361.338631]  [<c0f5d180>] ? _raw_spin_unlock_irq+0x72/0xa9
> [  361.339095]  [<c0f59fd8>] __wait_for_common+0xfa/0x1a5
> [  361.339534]  [<c0f57339>] ? console_conditional_schedule+0x61/0x61
> [  361.340119]  [<c020628f>] ? try_to_wake_up+0x377/0x377
> [  361.340561]  [<c0f5a25a>] wait_for_completion+0x27/0x38
> [  361.341014]  [<c0372aa1>] writeback_inodes_sb_nr+0x122/0x13b
> [  361.341502]  [<c0f59f38>] ? __wait_for_common+0x5a/0x1a5
> [  361.341963]  [<c0372bee>] writeback_inodes_sb+0x3a/0x4c
> [  361.342413]  [<c037843a>] __sync_filesystem+0x3f/0xa8
> [  361.342848]  [<c037850e>] sync_filesystem+0x6b/0xa8
> [  361.343274]  [<c033782b>] generic_shutdown_super+0x56/0x18c
> [  361.343833]  [<c0337991>] kill_block_super+0x30/0xd2
> [  361.344418]  [<c0337b0f>] deactivate_locked_super+0x3e/0xb9
> [  361.344919]  [<c0338bf3>] deactivate_super+0x69/0x7a
> [  361.345350]  [<c0360827>] mntput_no_expire+0x23b/0x24e
> [  361.345795]  [<c036229c>] sys_umount+0x5f4/0x60c
> [  361.346199]  [<c03622d4>] sys_oldumount+0x20/0x30
> [  361.346607]  [<c0f5d668>] syscall_call+0x7/0xb
> [  361.347027] 1 lock held by umount/3426:
Yes, this types of glitches are possible. Test try to stress fs very
hard, sometimes IO becomes too fragmented so 'buffered-aio-verifier'
looks like follows:
Level Entries           Logical          Physical Length Flags
 0/ 2   1/  2      75 - 2140016   33412           2139942
 1/ 2   1/302      75 -    2978   98945             2904
 2/ 2   1/ 62      75 -      75 2617227 - 2617227      1
 2/ 2   2/ 62      79 -      79  246147 -  246147      1
 2/ 2   3/ 62     161 -     161 2119435 - 2119435      1
 2/ 2   4/ 62     331 -     331 2077134 - 2077134      1
 2/ 2   5/ 62     372 -     372 1285910 - 1285910      1
 2/ 2   6/ 62     400 -     400 1285938 - 1285938      1
 2/ 2   7/ 62     478 -     478 1286016 - 1286016      1
 2/ 2   8/ 62     490 -     490 1286028 - 1286028      1
 2/ 2   9/ 62     548 -     548 1286086 - 1286086      1
 2/ 2  10/ 62     555 -     555 1286093 - 1286093      1
 2/ 2  11/ 62     559 -     559 1286097 - 1286097      1
 2/ 2  12/ 62     665 -     665 2105779 - 2105779      1
 2/ 2  13/ 62     667 -     667 1286401 - 1286401      1
As result blktraces are also looks sub-optimal:
253,3    1       91     2.431844430  6049  Q   W 19368784 + 8 [flush-253:3]
253,3    1       92     2.432439483  6049  Q   W 19368912 + 8 [flush-253:3]
253,3    1       93     2.433015550  6049  Q   W 19369432 + 8 [flush-253:3]
253,3    1       94     2.433562426  6049  Q   W 19370184 + 8 [flush-253:3]
253,3    1       95     2.434084419  6049  Q   W 19370416 + 8 [flush-253:3]
253,3    1       96     2.434692946  6049  Q   W 19372064 + 8 [flush-253:3]
253,3    1       97     2.434976250  6049  Q   W 19372208 + 8 [flush-253:3]
IMHO it is not bad idea to have at least one test which force fs to handle
very unfriendly workload. In fact, in terms of uncovered bugs, this test
appeared to be the most productive for me.
> [  361.347361]  #0:  (&type->s_umount_key#18){++++..}, at: [<c0338bde>]
> deactivate_super+0x54/0x7a
>  [16:40:14] [failed, exit status 1] - output mismatch (see
>  /root/xfstests/results/generic/299.out.bad)
>     --- tests/generic/299.out   2013-04-05 21:41:17.000000000 -0400
>     +++ /root/xfstests/results/generic/299.out.bad      2013-04-12
>     16:40:14.678565323 -0400
>     @@ -3,3 +3,6 @@
>      Run fio with random aio-dio pattern
>      
>      Start fallocate/truncate loop
>     +./common/rc: line 2055:  3353 Segmentation fault      "$@" >>
Yes, this is known issue. I probably use recent fio.git/HEAD
Jens does a good job on developing fio, but he tend to commit random
untested crap to his git. So stability is worse than it should be.
I have golden-good commit (aeb32dfccbd05) which works for me, and suggest
to use it.
>     $seqres.full 2>&1
>     +failed: '/root/xfstests/bin/fio /tmp/3152-299.fio'
>     +(see /root/xfstests/results/generic/299.full for details)
>      ...
>      (Run 'diff -u tests/generic/299.out
>     /root/xfstests/results/generic/299.out.bad' to see the entire diff)
> Ran: generic/299
> Failures: generic/299
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
