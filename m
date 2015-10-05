From: Theodore Ts'o <tytso@mit.edu>
Subject: [REGRESSION] 998ef75ddb and aio-dio-invalidate-failure w/
 data=journal
Date: Mon, 5 Oct 2015 11:22:36 -0400
Message-ID: <20151005152236.GA8140@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Dave Hansen <dave.hansen@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I've been tracking down a test failure in xfstests generic/208 in the
data_journal configuration, which I've been testing using:

	gce-xfstests -c data_journal -C 20 generic/208

I've bisected it down to commit 998ef75ddb: "fs: do not prefault
sys_write() user buffer pages".  I've confirmed that 4.3-rc2 fails as
detailed below, but with 998ef75ddb reverted, the problem goes away.

The generic/208 test tries to run the test program
aio-dio-invalidate-failure[1] 20 times.

On a successful pass, the test runs without incident.  On a failure,
the syslog gets flooded with messages which look like this:

Oct  5 08:46:40 xfstests-201510050844 kernel: JBD2: Spotted dirty metadata buffer (dev = dm-0, blocknr = 33797). There's a risk of filesystem corruption in case of system crash.

... and eventually, almost always before successful 5 test runs, and
often before even a single successful test run, we end up triggering
a BUG_ON[2].

Before commit 998ef75ddb, if we need to prefault in the page, we do so
before we attempt the copy.  After this commit, we attempt the copy
and if it fails because pagefaults have been turned off, we call
write_end(), the unlock the page, prefault in the pages, and then
retry the commit.

What I think is going on is that when we do attempt the copy, we end
up marking the page dirty before we notice that we need to page fault
in the page, which ends up triggering the warning that jbd2
buffer_head that is supposed to be journaled has been marked dirty
without calling ext4_handle_dirty_metadata() --- which is handled by
ext4_journalled_write_end(), but which is now happening out of order
given this commit.

Is it possible that we can change iov_iter_copy_from_user_atomic(), to
check for the error case before it marks the page dirty?  Or can we
create a light-weight function which checks to see if the page needs
to be faulted in which is lighter weight than
iov_iter_fault_in_readable?

Thanks,

						- Ted


[1] https://git.kernel.org/cgit/fs/xfs/xfstests-dev.git/tree/src/aio-dio-regress/aio-dio-invalidate-failure.c

[2] ------------[ cut here ]------------
kernel BUG at /usr/projects/linux/ext4/fs/jbd2/commit.c:1030!
invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC 
CPU: 1 PID: 9842 Comm: jbd2/dm-0-8 Not tainted 4.2.0-ext4-09906-g998ef75 #92
Hardware name: Google Google, BIOS Google 01/01/2011
task: ffff8802132a73c0 ti: ffff8800ade8c000 task.ti: ffff8800ade8c000
RIP: 0010:[<ffffffff81269145>]  [<ffffffff81269145>] jbd2_journal_commit_transaction+0xfbc/0x1592
RSP: 0018:ffff8800ade8fcc0  EFLAGS: 00010202
RAX: 0000000000a20003 RBX: ffff8800b8a5a888 RCX: ffff8800b8a5a088
RDX: 0000000000000001 RSI: ffff8800ade8fc78 RDI: ffff880200f63c30
RBP: ffff8800ade8fe30 R08: 0000013f3a2c21fa R09: 0000000000000002
R10: ffff8800ade8fbf0 R11: 0000000000000774 R12: ffff8800b66b21a0
R13: ffff8800b8a5a088 R14: ffff880200f63800 R15: ffff8800b8b9d800
FS:  0000000000000000(0000) GS:ffff88021df00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f9005ff2050 CR3: 000000020fea6000 CR4: 00000000001406e0
Stack:
ffff8800b4462488 000001375a588074 ffff8800b8b9d8ac ffff8802132a73c0
0000001000000024 ffff8800ada9b000 ffff8802132a73c0 ffff8800b8b9d850
00000000ffffffff ffff880000000784 0000000000000000 ffff8802102ab288
Call Trace:
[<ffffffff8126d26f>] ? kjournald2+0xb6/0x1e5
[<ffffffff8126d26f>] ? kjournald2+0xb6/0x1e5
[<ffffffff810f7ba6>] ? __wake_up_common+0x71/0x71
[<ffffffff8126d1b9>] ? commit_timeout+0xa/0xa
[<ffffffff810e1f8c>] ? kthread+0xc6/0xce
[<ffffffff810e1ec6>] ? __kthread_parkme+0x5a/0x5a
[<ffffffff8168ac5f>] ? ret_from_fork+0x3f/0x70
[<ffffffff810e1ec6>] ? __kthread_parkme+0x5a/0x5a
Code: 8b 03 a9 00 00 40 00 74 1b 4c 89 fe 4c 89 e7 45 31 ed e8 19 13 00 00 41 f6 06 02 74 1d f0 80 63 02 bf eb 16 48 8b 03 a8 02 74 02 <0f> 0b 45 31 ed 49 83 7c 24 30 00 41 0f 94 c5 4c 89 e7 e8 d5 eb 
RIP  [<ffffffff81269145>] jbd2_journal_commit_transaction+0xfbc/0x1592
RSP <ffff8800ade8fcc0>
---[ end trace 2c7d9ab15164cf1c ]---
