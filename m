From: Kay Diederichs <Kay.Diederichs@uni-konstanz.de>
Subject: Re: ext4 performance regression 2.6.27-stable versus 2.6.32 and later
Date: Mon, 02 Aug 2010 17:28:01 +0200
Message-ID: <4C56E401.6050400@uni-konstanz.de>
References: <4C508A54.7070002@uni-konstanz.de> <20100730022055.GL4506@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Ted Ts'o <tytso@mit.edu>,
	Kay Diederichs <Kay.Diederichs@uni-konstanz.de>,
	linux <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Karsten Schaefer <
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from pyrimidin.rz.uni-konstanz.de ([134.34.240.46]:8712 "EHLO
	pyrimidin.rz.uni-konstanz.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751490Ab0HBP2E (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Aug 2010 11:28:04 -0400
In-Reply-To: <20100730022055.GL4506@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted Ts'o schrieb:
> On Wed, Jul 28, 2010 at 09:51:48PM +0200, Kay Diederichs wrote:
>> When looking at the I/O statistics while the benchmark is running, we
>> see very choppy patterns for 2.6.32, but quite smooth stats for
>> 2.6.27-stable.
> 
> Could you try to do two things for me?  Using (preferably from a
> recent e2fsprogs, such as 1.41.11 or 12) run filefrag -v on the files
> created from your 2.6.27 run and your 2.6.32 run?
> 
> Secondly can capture blktrace results from 2.6.27 and 2.6.32?  That
> would be very helpful to understand what might be going on.
> 
> Either would be helpful; both would be greatly appreciated.
> 
> Thanks,
> 
> 						- Ted

Ted,

we pared down the benchmark to the last step (called "run xds_par in nfs
directory (reads 600M, and writes 50M)") because this captures most of
the problem. Here we report kernel messages with stacktrace, and the
blktrace output that you requested.

Kernel messages: with 2.6.32.16 we observe

[ 6961.838032] INFO: task jbd2/md5-8:2010 blocked for more than 120 seconds.
[ 6961.838111] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 6961.838191] jbd2/md5-8    D 00000634     0  2010      2 0x00000000
[ 6961.838200]  f5171e78 00000046 231a9999 00000634 ddf91f2c f652cc4c
00000001 f5171e1c
[ 6961.838307]  c0a6f140 c0a6f140 c0a6f140 c0a6a6ac f6354c20 f6354ecc
c2008140 00000000
[ 6961.838412]  00637f84 00000003 f652cc58 00000000 00000292 00000048
c20036ac f6354ecc
[ 6961.838518] Call Trace:
[ 6961.838556]  [<c056c39e>] jbd2_journal_commit_transaction+0x1d9/0x1187
[ 6961.838627]  [<c040220a>] ? __switch_to+0xd5/0x147
[ 6961.838681]  [<c07a390a>] ? schedule+0x837/0x885
[ 6961.838734]  [<c0455e5f>] ? autoremove_wake_function+0x0/0x38
[ 6961.838799]  [<c0448c84>] ? try_to_del_timer_sync+0x58/0x60
[ 6961.838859]  [<c0572426>] kjournald2+0xa2/0x1be
[ 6961.838909]  [<c0455e5f>] ? autoremove_wake_function+0x0/0x38
[ 6961.838971]  [<c0572384>] ? kjournald2+0x0/0x1be
[ 6961.839035]  [<c0455c11>] kthread+0x66/0x6b
[ 6961.839089]  [<c0455bab>] ? kthread+0x0/0x6b
[ 6961.839139]  [<c0404167>] kernel_thread_helper+0x7/0x10
[ 6961.839215] INFO: task sync:11600 blocked for more than 120 seconds.
[ 6961.839286] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 6961.839367] sync          D 00000632     0 11600  11595 0x00000000
[ 6961.839375]  ddf91ea4 00000086 dca59d8b 00000632 76f570ee 00000048
00001dec 773fd796
[ 6961.839486]  c0a6f140 c0a6f140 c0a6f140 c200819c f4ce0000 f4ce02ac
c2008140 00000000
[ 6961.839600]  ddf91ea8 dca5c36b 00000632 dca5bb77 c2008180 773fd796
00000282 f4ce02ac
[ 6961.839727] Call Trace:
[ 6961.839762]  [<c04f4de6>] bdi_sched_wait+0xd/0x11
[ 6961.841438]  [<c07a3ede>] __wait_on_bit+0x3b/0x62
[ 6961.843109]  [<c04f4dd9>] ? bdi_sched_wait+0x0/0x11
[ 6961.844782]  [<c07a3fb5>] out_of_line_wait_on_bit+0xb0/0xb8
[ 6961.846479]  [<c04f4dd9>] ? bdi_sched_wait+0x0/0x11
[ 6961.848181]  [<c0455e97>] ? wake_bit_function+0x0/0x48
[ 6961.849906]  [<c04f4c75>] wait_on_bit+0x25/0x31
[ 6961.851601]  [<c04f4e5d>] sync_inodes_sb+0x73/0x121
[ 6961.853287]  [<c04f8acc>] __sync_filesystem+0x48/0x69
[ 6961.854983]  [<c04f8b72>] sync_filesystems+0x85/0xc7
[ 6961.856670]  [<c04f8c04>] sys_sync+0x20/0x32
[ 6961.858363]  [<c040351b>] sysenter_do_call+0x12/0x28

Blktrace: blktrace was run for 2.6.27.48, 2.6.32.16 and a patched
2.6.32.16 (called 2.6.32.16p below and in the .tar file), where the
patch just reverts "ext4: Avoid group preallocation for closed files".
This revert removes a substantial part of the regression.

For 2.6.32.16p and 2.6.27.48 there are two runs: run1 is directly after
booting, then the directory is unexported, unmounted, mounted, exported,
and then run2 is done. For 2.6.32.16 there is just run1; all subsequent
runs yield approximately the same results, i.e. they are as slow as run1.

Some numbers (time, and number of lines with flush|nfsd|sync in the
blkparse output):
            2.6.27.48        2.6.32.16      2.6.32.16p
           run1   run2      run1   run2     run1  run2
wallclock  113s    61s      280s  ~280s     137s   61s
flush     25362   9285     71861           32656 12066
nfsd       7595   8580      8685            8359  8444
sync       2860   3925       303             212   169

The total time seems to be dominated by the number of flushes.
It should be noted that all these runs used barrier=0 ; barrier=1 does
not have a significant effect, though.

So we find:
a) in 2.6.32.16, there is a problem which manifests itself in kernel
messages associated with the jbd2/md5-8 and sync tasks, and vastly
increased number of flush operations
b) reverting patch "ext4: Avoid group preallocation for closed files"
cures part of the problem
c) even after reverting that patch, the first run takes much longer than
the subsequent runs, despite "sync", "echo 3 >
/proc/sys/vm/drop_caches", and umounting/re-mounting the filesystem.

The blktrace files are at
http://strucbio.biologie.uni-konstanz.de/~dikay/blktraces.tar.bz2 .

Should we test any other patches?

thanks,

Kay
