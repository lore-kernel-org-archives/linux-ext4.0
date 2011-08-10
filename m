From: Michael Tokarev <mjt@tls.msk.ru>
Subject: DIO process stuck apparently due to dioread_nolock (3.0)
Date: Wed, 10 Aug 2011 14:51:17 +0400
Message-ID: <4E4262A5.6030903@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from isrv.corpit.ru ([86.62.121.231]:51564 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752684Ab1HJKvT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Aug 2011 06:51:19 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello.

For a few days I'm evaluating various options to use
storage.  I'm interested in concurrent direct I/O
(oracle rdbms workload).

I noticed that somehow, ext4fs in mixed read-write
test greatly prefers writes over reads - writes goes
at full speed while reads are almost non-existent.

Sandeen on IRC pointed me at dioread_nolock mount
option, which I tried with great results, if not
one "but".

There's a deadlock somewhere, which I can't trigger
"on demand" - I can't hit the right condition.  It
happened twice in a row already, each time after the
same scenario (more about that later).

When it happens, a process doing direct AIO stalls
infinitely, with the following backtrace:

[87550.759848] INFO: task oracle:23176 blocked for more than 120 seconds.
[87550.759892] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[87550.759955] oracle          D 0000000000000000     0 23176      1 0x00000000
[87550.760006]  ffff8820457b47d0 0000000000000082 ffff880600000000 ffff881278e3f7d0
[87550.760085]  ffff8806215c1fd8 ffff8806215c1fd8 ffff8806215c1fd8 ffff8820457b47d0
[87550.760163]  ffffea0010bd7c68 ffffffff00000000 ffff882045512ef8 ffffffff810eeda2
[87550.760245] Call Trace:
[87550.760285]  [<ffffffff810eeda2>] ? __do_fault+0x422/0x520
[87550.760327]  [<ffffffff81111ded>] ? kmem_getpages+0x5d/0x170
[87550.760367]  [<ffffffff81112e58>] ? ____cache_alloc_node+0x48/0x140
[87550.760430]  [<ffffffffa0123e6d>] ? ext4_file_write+0x20d/0x260 [ext4]
[87550.760475]  [<ffffffff8106aee0>] ? abort_exclusive_wait+0xb0/0xb0
[87550.760523]  [<ffffffffa0123c60>] ? ext4_llseek+0x120/0x120 [ext4]
[87550.760566]  [<ffffffff81162173>] ? aio_rw_vect_retry+0x73/0x1d0
[87550.760607]  [<ffffffff8116302f>] ? aio_run_iocb+0x5f/0x160
[87550.760646]  [<ffffffff81164258>] ? do_io_submit+0x4f8/0x600
[87550.760689]  [<ffffffff81359b52>] ? system_call_fastpath+0x16/0x1b

At this point, the process in question can't be killed or
stopped.  Yes it's oracle DB, and I can kill all other processes
of this instance (this one is lgwr, aka log writer), but the stuck
process will continue to be stuck, so it is not an inter-process
deadlock.

echo "w" > /proc/sysrq-trigger shows only that process, with the
same stack trace.

This is 3.0.1 kernel from kernel.org (amd64 arch).  The system is
a relatively large box (IBM System x3850 X5).  So far, I've seen
this issue twice, and each time in the following scenario:

I copy an oracle database from another machine to filesystem
mounted with dioread_nolock, and right after the copy completes,
I start the database.  And immediately when Oracle opens its
DB ("Database opened") I see stuck lgwr process like above.

So I suspect it happens when there are some unwritten files
in buffer/page cache and some process tries to do direct
writes.

I haven't seen this happening without dioread_nolock, but since
I don't have an easy reproducer I can't say this mount option
is a requiriment.  So far, I was able to trigger it only after
large db copy, with small database I created in order to try
to reproduce it the issue does not happen.

And sure thing, when it happens, the only way to clean up is
to forcible reboot the machine (echo b > sysrq-trigger).

I'll continue experiments in a hope to find an easier reproducer,
but the problem is that I've little time left before the machine
in question will go into production.  So if anyone have hints
for this issue, please share.. ;)

Thank you!

/mjt
