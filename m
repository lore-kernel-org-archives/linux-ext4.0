From: Dave Jones <davej@codemonkey.org.uk>
Subject: ext4 unkillable lseek.
Date: Tue, 12 Jan 2016 09:53:48 -0500
Message-ID: <20160112145348.GA15634@codemonkey.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Linux Kernel <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I was investigating a case where it looked like Trinity was getting
into a deadlock.

The running task is doing an lseek(fd, <bignum>, SEEK_DATA) on a sparse
file that looks like this..

$ ll trinity-testfile4 
--wxrwx--- 1 davej davej 4947802326691 Jan 12 09:14 trinity-testfile4*
$ sudo filefrag trinity-testfile4 
trinity-testfile4: 3 extents found

The kernel trace for that process looks like..

trinity-c11     R  running task    22192 11483   2439 0x00080004
 ffff8800428a7c98 ffff8800a2ef87dc ffff8800a3bdf758 ffff8800a3bdf730
 ffff8800a2ef8008 ffff8800a2ef8340 ffff88009f8e9980 ffff8800a2ef8000
 ffff8800428a0000 ffffed0008514001 ffff8800428a0008 ffff8800935499e0
Call Trace:
 [<ffffffff8f5e8bd2>] preempt_schedule_common+0x42/0x70
 [<ffffffff8f5e8c1f>] preempt_schedule+0x1f/0x30
 [<ffffffff8e003058>] ___preempt_schedule+0x12/0x14
 [<ffffffff8e7a1e90>] ? ext4_es_find_delayed_extent_range+0x2a0/0x780
 [<ffffffff8f5f6f81>] ? _raw_read_unlock+0x31/0x50
 [<ffffffff8f5f6f94>] ? _raw_read_unlock+0x44/0x50
 [<ffffffff8e7a1e90>] ext4_es_find_delayed_extent_range+0x2a0/0x780
 [<ffffffff8e69c307>] ext4_llseek+0x567/0x870
 [<ffffffff8e69bda0>] ? ext4_find_unwritten_pgoff.isra.12+0x790/0x790
 [<ffffffff8f5edafc>] ? mutex_lock_nested+0x51c/0x8e0
 [<ffffffff8e20e5f9>] ? trace_hardirqs_on_caller+0x3f9/0x580
 [<ffffffff8e56e1a5>] ? __fdget_pos+0xd5/0x110
 [<ffffffff8e20e78d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff8f5ed5e0>] ? mutex_lock_interruptible_nested+0x9f0/0x9f0
 [<ffffffff8e00508f>] ? enter_from_user_mode+0x1f/0x50
 [<ffffffff8e005338>] ? syscall_trace_enter_phase1+0x278/0x470
 [<ffffffff8e248527>] ? debug_lockdep_rcu_enabled+0x77/0x90
 [<ffffffff8e518acd>] SyS_lseek+0x10d/0x180
 [<ffffffff8f5f7457>] entry_SYSCALL_64_fastpath+0x12/0x6b

It's currently been running for a hour.
Even though it's preempting back to userspace, it's ignoring
all the SIGKILLs that trinity has been sending it for taking too long.

Meanwhile all the other processes are backing up on the f_pos lock.

trinity-c7      D ffff880066857d50 24240 11628   2439 0x00080004
 ffff880066857d50 0000000000000007 ffff8800a3bdf758 ffff8800a3bdf730
 ffff880045286608 ffff880045286940 ffff8800a0150000 ffff880045286600
 ffff880066850000 ffffed000cd0a001 ffff880066850008 dffffc0000000000
Call Trace:
 [<ffffffff8f5e8e0f>] schedule+0x9f/0x1c0
 [<ffffffff8f5e9588>] schedule_preempt_disabled+0x18/0x30
 [<ffffffff8f5ed92d>] mutex_lock_nested+0x34d/0x8e0
 [<ffffffff8e56e1a5>] ? __fdget_pos+0xd5/0x110
 [<ffffffff8e337fe3>] ? acct_account_cputime+0x63/0x80
 [<ffffffff8e56e1a5>] ? __fdget_pos+0xd5/0x110
 [<ffffffff8f5ed5e0>] ? mutex_lock_interruptible_nested+0x9f0/0x9f0
 [<ffffffff8e248527>] ? debug_lockdep_rcu_enabled+0x77/0x90
 [<ffffffff8e56e1a5>] __fdget_pos+0xd5/0x110
 [<ffffffff8e51c029>] SyS_read+0x79/0x230
 [<ffffffff8e51bfb0>] ? do_sendfile+0x1280/0x1280
 [<ffffffff8e20e5f9>] ? trace_hardirqs_on_caller+0x3f9/0x580
 [<ffffffff8e003017>] ? trace_hardirqs_on_thunk+0x17/0x19
 [<ffffffff8f5f7457>] entry_SYSCALL_64_fastpath+0x12/0x6b

Eventually it does complete, but waiting a half hour every time
trinity picks lseek as a syscall is kinda crappy.

Shouldn't lseek be a killable operation ?

I notice this doesn't seem to happen with btrfs, suggesting it's
an ext'ism.   This has probably been there for a while, I've not
been doing fuzz runs on ext4 enabled systems for a long time.

	Dave
