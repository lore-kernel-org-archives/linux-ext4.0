From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: DIO process stuck apparently due to dioread_nolock (3.0)
Date: Thu, 11 Aug 2011 16:21:42 +0400
Message-ID: <4E43C956.3060507@msgid.tls.msk.ru>
References: <4E4262A5.6030903@msgid.tls.msk.ru> <20110811115943.GF4755@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from isrv.corpit.ru ([86.62.121.231]:53778 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755487Ab1HKMVo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Aug 2011 08:21:44 -0400
In-Reply-To: <20110811115943.GF4755@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

11.08.2011 15:59, Jan Kara wrote:
>   Hello,
> 
> On Wed 10-08-11 14:51:17, Michael Tokarev wrote:
>> For a few days I'm evaluating various options to use
>> storage.  I'm interested in concurrent direct I/O
>> (oracle rdbms workload).
>>
>> I noticed that somehow, ext4fs in mixed read-write
>> test greatly prefers writes over reads - writes goes
>> at full speed while reads are almost non-existent.
>>
>> Sandeen on IRC pointed me at dioread_nolock mount
>> option, which I tried with great results, if not
>> one "but".
>>
>> There's a deadlock somewhere, which I can't trigger
>> "on demand" - I can't hit the right condition.  It
>> happened twice in a row already, each time after the
>> same scenario (more about that later).
>>
>> When it happens, a process doing direct AIO stalls
>> infinitely, with the following backtrace:
>>
>> [87550.759848] INFO: task oracle:23176 blocked for more than 120 seconds.
>> [87550.759892] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> [87550.759955] oracle          D 0000000000000000     0 23176      1 0x00000000
>> [87550.760006]  ffff8820457b47d0 0000000000000082 ffff880600000000 ffff881278e3f7d0
>> [87550.760085]  ffff8806215c1fd8 ffff8806215c1fd8 ffff8806215c1fd8 ffff8820457b47d0
>> [87550.760163]  ffffea0010bd7c68 ffffffff00000000 ffff882045512ef8 ffffffff810eeda2
>> [87550.760245] Call Trace:
>> [87550.760285]  [<ffffffff810eeda2>] ? __do_fault+0x422/0x520
>> [87550.760327]  [<ffffffff81111ded>] ? kmem_getpages+0x5d/0x170
>> [87550.760367]  [<ffffffff81112e58>] ? ____cache_alloc_node+0x48/0x140
>> [87550.760430]  [<ffffffffa0123e6d>] ? ext4_file_write+0x20d/0x260 [ext4]
>> [87550.760475]  [<ffffffff8106aee0>] ? abort_exclusive_wait+0xb0/0xb0
>> [87550.760523]  [<ffffffffa0123c60>] ? ext4_llseek+0x120/0x120 [ext4]
>> [87550.760566]  [<ffffffff81162173>] ? aio_rw_vect_retry+0x73/0x1d0
>> [87550.760607]  [<ffffffff8116302f>] ? aio_run_iocb+0x5f/0x160
>> [87550.760646]  [<ffffffff81164258>] ? do_io_submit+0x4f8/0x600
>> [87550.760689]  [<ffffffff81359b52>] ? system_call_fastpath+0x16/0x1b
>   Hmm, the stack trace does not quite make sense to me - the part between
> __do_fault and aio_rw_vect_retry is somehow broken. I can imagine we
> blocked in ext4_file_write() but I don't see any place there where we would
> allocate memory. By any chance, are there messages like "Unaligned AIO/DIO
> on inode ..." in the kernel log?

Yes, there are warnings about unaligned DIO, referring to this same
process actually. Oracle does almost good job at aligning writes
(usually it does i/o by its blocks which are 4Kb by default but
are set to something larger - like 16Kb - for larger database).
Except of a few cases, and lgwr process is one of them (*) - it
writes logfiles using 512b blocks.  This is okay for a raw device
with 512bytes blocks, but ext4 expects 4k writes at min.

(*) another case is writing to control file, which is also done in
512byte chunks.

>> At this point, the process in question can't be killed or
>> stopped.  Yes it's oracle DB, and I can kill all other processes
>> of this instance (this one is lgwr, aka log writer), but the stuck
>> process will continue to be stuck, so it is not an inter-process
>> deadlock.
>>
>> echo "w" > /proc/sysrq-trigger shows only that process, with the
>> same stack trace.

Just for the record, this is from echoing "w" into sysrq-trigger:

[ 4691.585450] SysRq : Show Blocked State
[ 4691.585493]   task                        PC stack   pid father
[ 4691.585752] oracle          D 0000000000000000     0 23357      1 0x00000004
[ 4691.585804]  ffff88127719e080 0000000000000082 ffff881200000000 ffff881279791040
[ 4691.585883]  ffff8803caf03fd8 ffff8803caf03fd8 ffff8803caf03fd8 ffff88127719e080
[ 4691.585961]  ffffea0046db2510 ffffffff00000000 ffff8820431b24a8 ffffffff810eeda2
[ 4691.586039] Call Trace:
[ 4691.586079]  [<ffffffff810eeda2>] ? __do_fault+0x422/0x520
[ 4691.586140]  [<ffffffffa0123e6d>] ? ext4_file_write+0x20d/0x260 [ext4]
[ 4691.586185]  [<ffffffff8106aee0>] ? abort_exclusive_wait+0xb0/0xb0
[ 4691.586232]  [<ffffffffa0123c60>] ? ext4_llseek+0x120/0x120 [ext4]
[ 4691.586275]  [<ffffffff81162173>] ? aio_rw_vect_retry+0x73/0x1d0
[ 4691.586315]  [<ffffffff8116302f>] ? aio_run_iocb+0x5f/0x160
[ 4691.586354]  [<ffffffff81164258>] ? do_io_submit+0x4f8/0x600
[ 4691.586398]  [<ffffffff81359b52>] ? system_call_fastpath+0x16/0x1b

It is almost but not the same as above.

Thank you,

/mjt

>> This is 3.0.1 kernel from kernel.org (amd64 arch).  The system is
>> a relatively large box (IBM System x3850 X5).  So far, I've seen
>> this issue twice, and each time in the following scenario:
>>
>> I copy an oracle database from another machine to filesystem
>> mounted with dioread_nolock, and right after the copy completes,
>> I start the database.  And immediately when Oracle opens its
>> DB ("Database opened") I see stuck lgwr process like above.
>>
>> So I suspect it happens when there are some unwritten files
>> in buffer/page cache and some process tries to do direct
>> writes.
>>
>> I haven't seen this happening without dioread_nolock, but since
>> I don't have an easy reproducer I can't say this mount option
>> is a requiriment.  So far, I was able to trigger it only after
>> large db copy, with small database I created in order to try
>> to reproduce it the issue does not happen.
>>
>> And sure thing, when it happens, the only way to clean up is
>> to forcible reboot the machine (echo b > sysrq-trigger).
>>
>> I'll continue experiments in a hope to find an easier reproducer,
>> but the problem is that I've little time left before the machine
>> in question will go into production.  So if anyone have hints
>> for this issue, please share.. ;)
> 
> 							Honza

