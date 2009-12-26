From: tytso@mit.edu
Subject: Re: [RFC PATCH 1/4] ext4: DIO get_block code cleanup
Date: Sat, 26 Dec 2009 02:03:04 -0500
Message-ID: <20091226070303.GH32757@thunk.org>
References: <5df78e1d0912151737v3be07575k638edf744e59ee2f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michael Rubin <mrubin@google.com>
To: Jiaying Zhang <jiayingz@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:41496 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908AbZLZHDK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Dec 2009 02:03:10 -0500
Content-Disposition: inline
In-Reply-To: <5df78e1d0912151737v3be07575k638edf744e59ee2f@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 15, 2009 at 05:37:53PM -0800, Jiaying Zhang wrote:
> ext4: dio get_block code cleanup in prepare for it to be used by buffer write
> 
> Renaming the dio block allocation flags, variables and functions
> introduced in Mingming's "Direct IO for holes and fallocate"
> patches so that they can be used by ext4 buffer write as well.
> 
> Signed-off-by: Jiaying Zhang <jiayingz@google.com>

Hi Jiaying,

Merry Christmas!

Sorry, between trying to prepare patches for the 2.6.33 merge window,
and closing out my current position at the Linux Foundation, and the
resulting job transition, this has fallen through the cracks.  I've
started looking at your patch now.   A couple of comments so far.

1) The patches were white-space damaged, so applying them is a bit
difficult.  I gave up entirely on patch #4, which hopefully is a
mechnical only patch, but it's also one which is apparently only a
cleanup.  

Patch #1 had a combination of mechanical changes (i.e., naming of
variables and constants) as well as some non-mechnical changes.
Especially in the case of patch #4, when large chunks of code are
being moved around, the patch which mechnical changes is very likely
to break if other patches are applied (or reverted) compared to
whatever version the patch was based off of.  If the mechnical changes
are separated out (and clearly described in the commits), then I can
easily regenerate the mechnical changes, and not worry about
accidentally dropping changes.

2) In the first patch, in ext4_sync_file() in fs/ext4/fsync.c, the
call to flush_aio_dio_completed_IO() is renamed to
flush_completed_IO().  But then in the second patch, a second call to
flush_completed_IO() is added at the end of ext4_sync_file().  That
doesn't look right to me.

I need to look at the code more closely, which I will do later.  In
the mean time, I've added the first three patches which you sent to
the unstable portion of the ext4 patch queue.  When run against the
xfsqa regression test suite, it quickly shows a failure:

BUG: unable to handle kernel NULL pointer dereference at 00000004
IP: [<c0262b58>] __journal_remove_journal_head+0xf/0xcf
*pdpt = 0000000019b91001 *pde = 0000000000000000 
Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
last sysfs file: 
Modules linked in:

Pid: 6536, comm: jbd2/sdb-8 Not tainted 2.6.32-06814-g26716e4 #225 /
EIP: 0060:[<c0262b58>] EFLAGS: 00010246 CPU: 0
EIP is at __journal_remove_journal_head+0xf/0xcf
EAX: de570e40 EBX: 00000000 ECX: 00000000 EDX: de570e40
ESI: de570e40 EDI: 00000002 EBP: d8a94e5c ESP: d8a94e54
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process jbd2/sdb-8 (pid: 6536, ti=d8a94000 task=df3bbf90 task.ti=d8a94000)
Stack:
 de570e40 de570e40 d8a94e68 c0262c87 d4b7c140 d8a94e8c c025fe4b 00000001
<0> d8a94e9c d4b7c140 d8f630c0 00000000 cf6ba540 d8a94e9c d8a94eac c025fed9
<0> dbc50d80 dbc50d80 00000000 dc754800 00000000 dc754800 d8a94f5c c025e20a
Call Trace:
 [<c0262c87>] ? jbd2_journal_remove_journal_head+0x1e/0x2d
 [<c025fe4b>] ? journal_clean_one_cp_list+0x68/0xbd
 [<c025fed9>] ? __jbd2_journal_clean_checkpoint_list+0x39/0x7b
 [<c025e20a>] ? jbd2_journal_commit_transaction+0x2c5/0x1173
 [<c017bb17>] ? trace_hardirqs_off+0xb/0xd
 [<c01631ec>] ? try_to_del_timer_sync+0x5e/0x66
 [<c062eae5>] ? _spin_unlock_irqrestore+0x41/0x4d
 [<c017d019>] ? trace_hardirqs_on+0xb/0xd
 [<c01631ec>] ? try_to_del_timer_sync+0x5e/0x66
 [<c01635bb>] ? del_timer_sync+0x78/0x88
 [<c0263b66>] ? kjournald2+0x116/0x309
 [<c016d9b0>] ? autoremove_wake_function+0x0/0x34
 [<c0263a50>] ? kjournald2+0x0/0x309
 [<c016d785>] ? kthread+0x64/0x69
 [<c016d721>] ? kthread+0x0/0x69
 [<c012567b>] ? kernel_thread_helper+0x7/0x10
Code: f6 ff eb 15 89 d8 e8 97 91 f7 ff eb 0c e8 71 ff ff ff 89 da e8 8c 3e f8 ff 5b 5d c3 55 89 e5 56 53 0f 1f 44 00 00 8b 58 24 89 c6 <83> 7b 04 00 79 04 0f 0b eb fe f0 ff 40 34 83 7b 04 00 0f 85 a1 
EIP: [<c0262b58>] __journal_remove_journal_head+0xf/0xcf SS:ESP 0068:d8a94e54
CR2: 0000000000000004

Removing your three patches makes the failure go away.  I'll analyze
this some more later this weekend.

Best regards,

							- Ted
