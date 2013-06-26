From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [BUG] xfstest269 causes deadlock on linux-3.9.0 (ext4)
Date: Wed, 26 Jun 2013 17:38:35 +0900
Message-ID: <51CAA88B.2050802@rs.jp.nec.com>
References: <51908CF4.2000703@rs.jp.nec.com> <20130514213755.GA10769@quack.suse.cz> <5192F998.6080706@rs.jp.nec.com> <51A2BB97.7030802@rs.jp.nec.com> <8738t8on26.fsf@openvz.org> <20130527083301.GA17423@quack.suse.cz> <51A46C79.4000105@rs.jp.nec.com> <20130624110402.GD20471@quack.suse.cz> <51C96BBD.8060701@rs.jp.nec.com> <20130625112738.GF20471@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([210.143.35.52]:44846 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab3FZIjI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Jun 2013 04:39:08 -0400
In-Reply-To: <20130625112738.GF20471@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



(2013/06/25 20:27), Jan Kara wrote:
> On Tue 25-06-13 19:06:53, Akira Fujita wrote:
>>
>>
>> (2013/06/24 20:04), Jan Kara wrote:
>>> On Tue 28-05-13 17:36:09, Akira Fujita wrote:
>>>> Hello,
>>>>
>>>> (2013/05/27 17:33), Jan Kara wrote:
>>>>> On Mon 27-05-13 12:16:01, Dmitry Monakhov wrote:
>>>>>> On Mon, 27 May 2013 10:49:11 +0900, Akira Fujita <a-fujita@rs.jp.nec.com> wrote:
>>>>>>> Hi Jan,
>>>>>>>
>>>>>>> (2013/05/15 11:57), Akira Fujita wrote:
>>>>>>>> Hi,
>>>>>>>>
>>>>>>>> (2013/05/15 6:37), Jan Kara wrote:
>>>>>>>>>        Hello,
>>>>>>>>>
>>>>>>>>> On Mon 13-05-13 15:49:24, Akira Fujita wrote:
>>>>>>>>>> I ran into the deaclock with xfs_test 269 on linux-3.9.0.
>>>>>>>>>> It seems happen between jbd2_log_wait_commit, sleep_on_buffer
>>>>>>>>>> and writeback_indoes (Please see ps log below).
>>>>>>>>>> Once it occurs we can't touch FS anymore.
>>>>>>>>>> In my case 300 - 1000 trials to occur. Is this known issue?
>>>>>>>>>>
>>>>>>>>>> The following kernels seems to have same problem:
>>>>>>>>>> - linux-3.5-rc5
>>>>>>>>>> - linux-3.8.5
>>>>>>>>>> - linux-3.9-rc7
>>>>>>>>>> And now I'm trying it on linux-3.10-rc1.
>>>>>>>>>>
>>>>>>>>>> # ./check generic/269
>>>>>>>>>> FSTYP         -- ext4
>>>>>>>>>> PLATFORM      -- Linux/x86_64 mcds1 3.9.0
>>>>>>>>>> MKFS_OPTIONS  -- /dev/sda12
>>>>>>>>>> MOUNT_OPTIONS -- -o acl,user_xattr /dev/sda12 /mnt/mp2
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> # ps -eo pid,tid,class,rtprio,ni,pri,psr,pcpu,stat,wchan:16,comm
>>>>>>>>>>        PID   TID CLS RTPRIO  NI PRI PSR %CPU STAT WCHAN            COMMAND
>>>>>>>>>>          1     1 TS       -   0  19   0  0.0 Ss   poll_schedule_ti init
>>>>>>>>>>          2     2 TS       -   0  19   0  0.0 S    kthreadd         kthreadd
>>>>>>>>>>          3     3 TS       -   0  19   0  0.0 S    smpboot_thread_f ksoftirqd/0
>>>>>>>>>> ...
>>>>>>>>>>       2391  2391 TS       -   0  19   2  0.1 D    jbd2_log_wait_co flush-8:0
>>>>>>>>>> ...
>>>>>>>>>> 22647 22647 TS       -   0  19   3  0.0 S    worker_thread    kworker/3:1
>>>>>>>>>> 22655 22655 TS       -   0  19   0  0.0 S    hrtimer_nanoslee sleep
>>>>>>>>>> 22657 22657 TS       -   0  19   2  0.0 R+   -                ps
>>>>>>>>>> 25330 25330 TS       -   0  19   0  0.0 S    worker_thread    kworker/0:0
>>>>>>>>>> 28963 28963 TS       -   0  19   1  0.0 S+   wait             loop_xfstests.s
>>>>>>>>>> 28964 28964 TS       -   0  19   1  0.0 S+   wait             check
>>>>>>>>>> 29180 29180 TS       -   0  19   3  0.0 S    kjournald2       jbd2/sda11-8
>>>>>>>>>> 29181 29181 TS       - -20  39   3  0.0 S<   rescuer_thread   ext4-dio-unwrit
>>>>>>>>>> 29199 29199 TS       -   0  19   3  0.0 S+   wait             269
>>>>>>>>>> 29391 29391 TS       -   0  19   0  0.6 D    sleep_on_buffer  jbd2/sda12-8
>>>>>>>>>> 29392 29392 TS       - -20  39   3  0.0 S<   rescuer_thread   ext4-dio-unwrit
>>>>>>>>>> 29394 29394 TS       -   0  19   0  0.0 S    wait             fsstress
>>>>>>>>>> 29505 29505 TS       -   0  19   3  0.0 D    writeback_inodes fsstress
>>>>>>>>>>
>>>>>>>>>> # df -T /dev/sda11 /dev/sda12
>>>>>>>>>> Filesystem    Type   1K-blocks      Used Available Use% Mounted on
>>>>>>>>>> /dev/sda11    ext4     9857264     22308   9327564   1% /mnt/mp1
>>>>>>>>>> /dev/sda12    ext4      499656    499656         0 100% /mnt/mp2
>>>>>>>>>        Thanks for report. No I don't think this problem has been reported
>>>>>>>>> before. Seeing that sda12 is out of space and fsstress hangs in
>>>>>>>>> writeback_inodes(), I suspect we have some deadlock in ENOSPC recovery path
>>>>>>>>> when we want to flush data to disk to reduce delalloc uncertainty. Can you
>>>>>>>>> run 'echo w >/proc/sysrq-trigger' when the deadlock happens and post your
>>>>>>>>> dmesg here? Thanks!
>>>>>>>>>
>>>>>>>>
>>>>>>>> Thanks for reply.
>>>>>>>> I'll take that information when the deadlock happens again.
>>>>>>>
>>>>>>> Finally, I got the following messages on linux-3.9.0.
>>>>>>> Could you take a look?
>>>>>> Is it a real deadlock?
>>>>>> umount wait for flush-8:0
>>>>>> flush wait for jbd2
>>>>>> jbd2 wait for bh.
>>>>>> All buffer-heads will be written at sooner or later.
>>>>>> It probably will require significant amount of time, because fs is too
>>>>>> fragmented(that is what this test all about), but it is not a deadlock.
>>>>>      Yeah, that is my analysis as well. I was only thinking whether we
>>>>> couldn't forget some buffer locked on some error recovery path (we are
>>>>> getting ENOSPC) but it's not obvious where it would be. Akira-san, could
>>>>> you also send us disassembly of your jbd2_journal_commit_transaction()
>>>>> function so that we can check where exactly offset 0xee0 is in the
>>>>> function?
>>>>>
>>>>> 								Honza
>>>>
>>>> I attached disasemble code of jbd2_journal_commit_tnrasaction,
>>>> please check it.
>>>     Thanks. I've looked into the disassembly now and we are waiting for the
>>> write of commit record to finish. We have submitted the buffer just before
>>> so it can hardly be some issue like forgotten locked buffer. Really
>>> strange. It looks like some problem in block layer, device driver, or HW
>>> itself... I'm thinking how to debug this further - it would be good if we
>>> had blktrace data just before the moment when the hang happens but given
>>> how hard this is to reproduce the traces would be extremly large...
>>>
>>> One idea - can you try whether the problem reproduces with 'nobarrier'
>>> mount option? It could be some problem with flush / fua handling.
>>>
>>
>> OK, I'll try to reproduce this issue with 'nobarrier'
>> (and take blktrace log if I can).
>    You can restart the blktrace every 5 minutes or so, so that trace files
> don't get too big. If we have a trace for a minute before the machine crashes
> it should be enough for debugging.

Thanks for advice, I'll try it.
In my environment, 1 time xfstests269 running generates
about 150MB log by blktrace, so taking log seems okay.

Thanks,
Akira Fujita

