From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: DIO process stuck apparently due to dioread_nolock (3.0)
Date: Fri, 12 Aug 2011 00:05:08 +0400
Message-ID: <4E4435F4.6000406@msgid.tls.msk.ru>
References: <4E4262A5.6030903@msgid.tls.msk.ru> <20110811115943.GF4755@quack.suse.cz> <4E43C956.3060507@msgid.tls.msk.ru> <20110811140101.GA18802@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from isrv.corpit.ru ([86.62.121.231]:55545 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382Ab1HKUFM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Aug 2011 16:05:12 -0400
In-Reply-To: <20110811140101.GA18802@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

11.08.2011 18:01, Jan Kara wrote:
[]
>>>> When it happens, a process doing direct AIO stalls
>>>> infinitely, with the following backtrace:
>>>>
>>>> [87550.759848] INFO: task oracle:23176 blocked for more than 120 seconds.
>>>> [87550.759892] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>>> [87550.759955] oracle          D 0000000000000000     0 23176      1 0x00000000
>>>> [87550.760006]  ffff8820457b47d0 0000000000000082 ffff880600000000 ffff881278e3f7d0
>>>> [87550.760085]  ffff8806215c1fd8 ffff8806215c1fd8 ffff8806215c1fd8 ffff8820457b47d0
>>>> [87550.760163]  ffffea0010bd7c68 ffffffff00000000 ffff882045512ef8 ffffffff810eeda2
>>>> [87550.760245] Call Trace:
>>>> [87550.760285]  [<ffffffff810eeda2>] ? __do_fault+0x422/0x520
>>>> [87550.760327]  [<ffffffff81111ded>] ? kmem_getpages+0x5d/0x170
>>>> [87550.760367]  [<ffffffff81112e58>] ? ____cache_alloc_node+0x48/0x140
>>>> [87550.760430]  [<ffffffffa0123e6d>] ? ext4_file_write+0x20d/0x260 [ext4]
>>>> [87550.760475]  [<ffffffff8106aee0>] ? abort_exclusive_wait+0xb0/0xb0
>>>> [87550.760523]  [<ffffffffa0123c60>] ? ext4_llseek+0x120/0x120 [ext4]
>>>> [87550.760566]  [<ffffffff81162173>] ? aio_rw_vect_retry+0x73/0x1d0
>>>> [87550.760607]  [<ffffffff8116302f>] ? aio_run_iocb+0x5f/0x160
>>>> [87550.760646]  [<ffffffff81164258>] ? do_io_submit+0x4f8/0x600
>>>> [87550.760689]  [<ffffffff81359b52>] ? system_call_fastpath+0x16/0x1b
>>>   Hmm, the stack trace does not quite make sense to me - the part between
>>> __do_fault and aio_rw_vect_retry is somehow broken. I can imagine we
>>> blocked in ext4_file_write() but I don't see any place there where we would
>>> allocate memory. By any chance, are there messages like "Unaligned AIO/DIO
>>> on inode ..." in the kernel log?
>>
>> Yes, there are warnings about unaligned DIO, referring to this same
>> process actually. Oracle does almost good job at aligning writes
>> (usually it does i/o by its blocks which are 4Kb by default but
>> are set to something larger - like 16Kb - for larger database).
>> Except of a few cases, and lgwr process is one of them (*) - it
>> writes logfiles using 512b blocks.  This is okay for a raw device
>> with 512bytes blocks, but ext4 expects 4k writes at min.
>>
>> (*) another case is writing to control file, which is also done in
>> 512byte chunks.
>   Ah, OK. I think the code ext4_end_io_nolock() handling the wait queue
> might be racy. waitqueue_active() check is missing a barrier I think.
> Does attached (untested) patch fix the issue for you?

With this patch applied, I can reproduce the problem easily too:

[   76.982985] EXT4-fs (dm-1): Unaligned AIO/DIO on inode 3407879 by oracle; performance will be poor.
[ 1469.734114] SysRq : Show Blocked State
[ 1469.734157]   task                        PC stack   pid father
[ 1469.734473] oracle          D 0000000000000000     0  6146      1 0x00000000
[ 1469.734525]  ffff88103f604810 0000000000000082 ffff881000000000 ffff881079791040
[ 1469.734603]  ffff880432c19fd8 ffff880432c19fd8 ffff880432c19fd8 ffff88103f604810
[ 1469.734681]  ffffea000ec13590 ffffffff00000000 ffff881438c8dad8 ffffffff810eeda2
[ 1469.734760] Call Trace:
[ 1469.734800]  [<ffffffff810eeda2>] ? __do_fault+0x422/0x520
[ 1469.734863]  [<ffffffffa0123e6d>] ? ext4_file_write+0x20d/0x260 [ext4]
[ 1469.734909]  [<ffffffff8106aee0>] ? abort_exclusive_wait+0xb0/0xb0
[ 1469.734956]  [<ffffffffa0123c60>] ? ext4_llseek+0x120/0x120 [ext4]
[ 1469.734999]  [<ffffffff81162173>] ? aio_rw_vect_retry+0x73/0x1d0
[ 1469.735039]  [<ffffffff8116302f>] ? aio_run_iocb+0x5f/0x160
[ 1469.735078]  [<ffffffff81164258>] ? do_io_submit+0x4f8/0x600
[ 1469.735122]  [<ffffffff81359b52>] ? system_call_fastpath+0x16/0x1b

which is exactly the same as with previous "w" into sysrq-trigger.

So it's something else... :(

Thank you!

/mjt
