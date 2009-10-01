From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [Kernel BUG] ext4 for v2.6.32 round II
Date: Thu, 1 Oct 2009 03:41:28 +0200
Message-ID: <20091001014128.GA2092@phenom2.trippelsdorf.de>
References: <E1Msrgx-0001br-MP@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-042.synserver.de ([212.40.180.42]:1062 "HELO
	smtp-out-042.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755344AbZJABlb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Sep 2009 21:41:31 -0400
Content-Disposition: inline
In-Reply-To: <E1Msrgx-0001br-MP@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 30, 2009 at 01:25:31AM -0400, Theodore Ts'o wrote:
> 
> Please pull from:
> 
>         git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus
> 
> to grab the following changes for v2.6.32.
> 
> 
> Curt Wohlgemuth (2):
>       ext4: Make sure ext4_dirty_inode() updates the inode in no journal mode
>       ext4: Handle nested ext4_journal_start/stop calls without a journal
> 
> Frank Mayhar (1):
>       ext4: Avoid updating the inode table bh twice in no journal mode
> 
> Jan Kara (1):
>       ext4: Update documentation about quota mount options
> 
> Josh Stone (1):
>       ext4: Add a stub for mpage_da_data in the trace header
> 
> Mingming Cao (4):
>       ext4: release reserved quota when block reservation for delalloc retry
>       ext4: Split uninitialized extents for direct I/O
>       ext4: Use end_io callback to avoid direct I/O fallback to buffered I/O
>       ext4: async direct IO for holes and fallocate support
> 
> Theodore Ts'o (8):
>       ext4: Use ext4_msg() for ext4_da_writepage() errors
>       ext4: Fix hueristic which avoids group preallocation for closed files
>       ext4: Adjust ext4_da_writepages() to write out larger contiguous chunks
>       ext4: EXT4_IOC_MOVE_EXT: Check for different original and donor inodes first
>       ext4, jbd2: Drop unneeded printks at mount and unmount time
>       ext4: Use tracepoints for mb_history trace file
>       jbd2: Use tracepoints for history file
>       ext4: Fix time encoding with extra epoch bits

Running latest git I get the following kernel BUG message:

------------[ cut here ]------------
Kernel BUG at ffffffff810efa89 [verbose debug info unavailable]
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq
CPU 3
Pid: 1930, comm: flush-8:16 Not tainted 2.6.32-rc2-00134-g84d88d5 #4 System Product Name
RIP: 0010:[<ffffffff810efa89>]  [<ffffffff810efa89>] ext4_num_dirty_pages+0x113/0x213
RSP: 0018:ffff88011e7d7a80  EFLAGS: 00010246
RAX: 4000000000020039 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffffea00030497e8 RSI: 0000000000000002 RDI: ffffea000300ad60
RBP: ffff88011e7d7b80 R08: ffffea000300ad68 R09: 0000000000000003
R10: 000000000000000e R11: 0000000000000000 R12: 0000000000000000
R13: ffff88011e7d7ac0 R14: ffff8800df4acee0 R15: ffff88011e7d7b48
FS:  00007eff036f26f0(0000) GS:ffff880028380000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00007f24c4fa0000 CR3: 000000011e68d000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process flush-8:16 (pid: 1930, threadinfo ffff88011e7d6000, task ffff88011ca2abe0)
Stack:
 ffffffff810f174e ffff88011e5808e0 ffffea00030497e8 0000000000008000
<0> ffff88011e7d7ad0 0000000e00000286 ffff88011e7d7ad0 0000000000000000
<0> 000000000000000e 0000000000000000 ffffea00030497e8 ffffea00030497b0
Call Trace:
 [<ffffffff810f174e>] ? __mpage_da_writepage+0x0/0x14e
 [<ffffffff810f134f>] ext4_da_writepages+0x135/0x48f
 [<ffffffff8104c642>] ? find_busiest_group+0x3ea/0x950
 [<ffffffff81084178>] do_writepages+0x1c/0x25
 [<ffffffff810c07fe>] writeback_single_inode+0xea/0x2e3
 [<ffffffff810c14d8>] writeback_inodes_wb+0x443/0x520
 [<ffffffff810c16d8>] wb_writeback+0x123/0x1a1
 [<ffffffff810c1933>] wb_do_writeback+0x137/0x14d
 [<ffffffff810c1974>] bdi_writeback_task+0x2b/0x84
 [<ffffffff8108e0f3>] ? bdi_start_fn+0x0/0xcd
 [<ffffffff8108e15f>] bdi_start_fn+0x6c/0xcd
 [<ffffffff8108e0f3>] ? bdi_start_fn+0x0/0xcd
 [<ffffffff810657d7>] kthread+0x7a/0x82
 [<ffffffff810292da>] child_rip+0xa/0x20
 [<ffffffff8106575d>] ? kthread+0x0/0x82
 [<ffffffff810292d0>] ? child_rip+0x0/0x20
Code: 72 18 75 15 48 8b 02 a8 10 74 0e f6 c4 20 75 09 48 8b 4a 20 48 39 d9 74 0d 48 89 d7 e8 3b ea f8 ff 48 89 d9 eb 5b f6 c4 08 75 04 <0f> 0b eb fe 48 8b 72 10 48 89 f0 48 8b 38 f7 c7 00 02 00 00 75
RIP  [<ffffffff810efa89>] ext4_num_dirty_pages+0x113/0x213
 RSP <ffff88011e7d7a80>
---[ end trace 8a998a2f9968ef87 ]---

or

------------[ cut here ]------------
Kernel BUG at ffffffff810efa89 [verbose debug info unavailable]
invalid opcode: 0000 [#1] SMP 
last sysfs file: /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/device:16/ATK0110:00/hwmon/hwmon0/temp2_input
CPU 1 
Pid: 1916, comm: flush-8:16 Not tainted 2.6.32-rc2-00134-g84d88d5 #4 System Product Name
RIP: 0010:[<ffffffff810efa89>]  [<ffffffff810efa89>] ext4_num_dirty_pages+0x113/0x213
RSP: 0018:ffff88011cf61a80  EFLAGS: 00010246
RAX: 4000000000020039 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffffea000301bc30 RSI: 0000000000000002 RDI: ffffea000301c058
RBP: ffff88011cf61b80 R08: ffffea000301c060 R09: 0000000000000003
R10: 000000000000000e R11: 0000000000000000 R12: 0000000000000000
R13: ffff88011cf61ac0 R14: ffff8800df4339f0 R15: ffff88011cf61b48
FS:  00007f04ceb40910(0000) GS:ffff880028280000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00007f04ce33f000 CR3: 000000011bb91000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process flush-8:16 (pid: 1916, threadinfo ffff88011cf60000, task ffff88011e6f2be0)
Stack:
 0000000100000001 00000000007745d5 ffffea000301bc30 0000000000008000
<0> ffff88011cf61ad0 0000000e03efe400 ffff88011cf61ad0 0000000000000000
<0> 000000000000000e 0000000000000000 ffffea000301bc30 ffffea000301bca0
Call Trace:
 [<ffffffff810f134f>] ext4_da_writepages+0x135/0x48f
 [<ffffffff81084178>] do_writepages+0x1c/0x25
 [<ffffffff810c07fe>] writeback_single_inode+0xea/0x2e3
 [<ffffffff810c14d8>] writeback_inodes_wb+0x443/0x520
 [<ffffffff810c16d8>] wb_writeback+0x123/0x1a1
 [<ffffffff810c1933>] wb_do_writeback+0x137/0x14d
 [<ffffffff810c1974>] bdi_writeback_task+0x2b/0x84
 [<ffffffff8108e0f3>] ? bdi_start_fn+0x0/0xcd
 [<ffffffff8108e15f>] bdi_start_fn+0x6c/0xcd
 [<ffffffff8108e0f3>] ? bdi_start_fn+0x0/0xcd
 [<ffffffff810657d7>] kthread+0x7a/0x82
 [<ffffffff810292da>] child_rip+0xa/0x20
 [<ffffffff8106575d>] ? kthread+0x0/0x82
 [<ffffffff810292d0>] ? child_rip+0x0/0x20
Code: 72 18 75 15 48 8b 02 a8 10 74 0e f6 c4 20 75 09 48 8b 4a 20 48 39 d9 74 0d 48 89 d7 e8 3b ea f8 ff 48 89 d9 eb 5b f6 c4 08 75 04 <0f> 0b eb fe 48 8b 72 10 48 89 f0 48 8b 38 f7 c7 00 02 00 00 75 
RIP  [<ffffffff810efa89>] ext4_num_dirty_pages+0x113/0x213
 RSP <ffff88011cf61a80>
---[ end trace 534f3a080f2b5f80 ]---

I haven't bisected yet, but maybe it is obvious to someone what went wrong.
-- 
Markus
