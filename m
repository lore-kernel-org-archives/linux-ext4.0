From: Eric Whitney <enwlinux@gmail.com>
Subject: xfstest generic/068 dev branch failures
Date: Sun, 23 Jun 2013 22:06:27 -0400
Message-ID: <20130624020627.GA29365@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ve0-f170.google.com ([209.85.128.170]:52736 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab3FXCGd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 23 Jun 2013 22:06:33 -0400
Received: by mail-ve0-f170.google.com with SMTP id 14so8233023vea.1
        for <linux-ext4@vger.kernel.org>; Sun, 23 Jun 2013 19:06:32 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In last week's ext4 concall I mentioned that I'd seen five consecutive failures
of xfstest generic/068 on an ext4 file system mounted with data=journal while
doing dev branch testing on a Pandaboard.  Similar failures of generic/068 on
filesystems mounted with data=journal have been visible for some time with
mainline kernels on both x86-64 and ARM in about 10% of the tests run.  (That
was still the case for my x86-64 runs on this dev kernel.)

Because we'd like a dependable reproducer to help find a fix for these failures,
I ran a larger number of trials on the Pandaboard using the same dev kernel
to see if we really had one.  Unfortunately, the failure rate for this larger
sample set was 40% rather than 100%.  The failure rate did still appear to be
elevated as compared to 3.10 on ARM.

More recent runs of generic/068 on a dev kernel from Friday failed at
about a 30% rate in the same test scenario on the Pandaboard and at the
same statement in the jbd2 code.

As requested, the last commit for the initial dev kernel:
74039f20b5 - ext4: remove ext4_ioend_wait()

The last commit for Friday's dev kernel:
a1edc9ea52 - jbd2: fix theoretical race in jbd2__journal_restart

Configuration for SUT:
Pandaboard ES, 2 ARM cores, 1 GB memory, 1 SATA III disk attached via USB 2.0
on which three 5 GB test file systems were located.  e2fsprogs master branch,
1.43 WIP.

Stack trace excerpt from original dev kernel on Pandaboard:

 kernel BUG at fs/jbd2/transaction.c:2156!
 Internal error: Oops - BUG: 0 [#1] SMP ARM
 Modules linked in:
 CPU: 1 PID: 30272 Comm: fstest Not tainted 3.10.0-rc2-13849-g74039f2 #1
 task: ed184140 ti: ec4c4000 task.ti: ec4c4000
 PC is at jbd2_journal_invalidatepage+0x3cc/0x3f4
 LR is at jbd2_journal_invalidatepage+0x208/0x3f4
 pc : [<c01f926c>]    lr : [<c01f90a8>]    psr: 00000113
 sp : ec4c5b88  ip : 00000000  fp : ec4c5bd4
 r10: ecb58f88  r9 : 00200000  r8 : 00001000
 r7 : ecb58f88  r6 : 00000000  r5 : ecb58f88  r4 : 00001000
 r3 : 00000002  r2 : 0071c025  r1 : ecb58f88  r0 : 00000000
 Flags: nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
 Control: 10c5387d  Table: a77c804a  DAC: 00000015
 Process fstest (pid: 30272, stack limit = 0xec4c4240)
 
 [<c01f926c>] (jbd2_journal_invalidatepage+0x3cc/0x3f4)
 [<c01aab88>] (__ext4_journalled_invalidatepage+0x70/0xac)
 [<c01abdb0>] (ext4_journalled_invalidatepage+0x18/0x34)
 [<c00e355c>] (truncate_inode_page+0xbc/0xc4)
 [<c00e36a4>] (truncate_inode_pages_range+0x140/0x47c)
 [<c00e3abc>] (truncate_inode_pages+0x28/0x30)
 [<c00e3b34>] (truncate_pagecache+0x70/0x90)
 [<c01b04ac>] (ext4_setattr+0x40c/0x688)
 [<c012df14>] (notify_change+0x1e8/0x334)
 [<c0112368>] (do_truncate+0x84/0xa8)
 [<c0121c7c>] (do_last.isra.28+0x634/0xba8)
 [<c01222ac>] (path_openat+0xbc/0x498)
 [<c01229a4>] (do_filp_open+0x3c/0x90)
 [<c0113358>] (do_sys_open+0xf4/0x180)
 [<c0113410>] (SyS_open+0x2c/0x30)


And another problem - when I ran generic/068 on an ext4 file system mounted with
data=journal using an x86-64 VM using Friday's dev kernel, the kernel BUGed
about 10% of the time as usual at fs/jbd2/transaction.c: 2133. However, it
also failed about 40% of the time in a way it didn't on the Pandaboard.
Retesting on x86-64 running 3.10-rc6, I was able to get the same failure but
at a lower rate of between 10 and 20%.  (This may not bode well for trying to
reproduce the transaction.c BUG() on a physical x86-64 as we discussed in
the call.)

Here's an excerpt from that stack trace:

kernel BUG at fs/buffer.c:2956!
invalid opcode: 0000 [#1] SMP
Modules linked in: kvm_intel kvm microcode snd_hda_intel psmouse serio_raw snd_hda_codec snd_hwdep snd_pcm snd_timer snd soundcore snd_page_alloc virtio_balloon i2c_piix4 mac_hid lp parport f\

CPU: 0 PID: 3644 Comm: fstest Not tainted 3.10.0-rc6-ext4testing #1
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
task: ffff88003bbb9fb0 ti: ffff88003d23c000 task.ti: ffff88003d23c000
RIP: 0010:[<ffffffff811b8bca>]  [<ffffffff811b8bca>] _submit_bh+0x17a/0x200
RSP: 0000:ffff88003d23d878  EFLAGS: 00010246
RAX: 000000000011c005 RBX: ffff88003b4f4f70 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff88003b4f4f70 RDI: 0000000000000411
RBP: ffff88003d23d898 R08: 0000000000000004 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000411
R13: ffff88003d23d964 R14: ffff8800256b1800 R15: ffff88003b4f4f70
FS:  00007fcb7c652700(0000) GS:ffff88003fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fcb7c5e6000 CR3: 0000000036847000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Stack:
 ffff88003b4f4f70 0000000000000411 ffff88003d23d964 ffff8800256b1800
 ffff88003d23d8a8 ffffffff811b8c60 ffff88003d23d8c8 ffffffff811ba015
 0000000000000001 ffff8800256b1b48 ffff88003d23d928 ffffffff8127932d
Call Trace:
 [<ffffffff811b8c60>] submit_bh+0x10/0x20
 [<ffffffff811ba015>] write_dirty_buffer+0x55/0x80
 [<ffffffff8127932d>] __flush_batch+0x4d/0xa0
 [<ffffffff81279b7f>] jbd2_log_do_checkpoint+0x27f/0x480
 [<ffffffff81279e27>] __jbd2_log_wait_for_space+0xa7/0x1d0
 [<ffffffff81273f70>] start_this_handle+0x2d0/0x550
 [<ffffffff81178f2a>] ? kmem_cache_alloc+0x13a/0x140
 [<ffffffff81274457>] jbd2__journal_start+0xf7/0x1d0
 [<ffffffff8122cbf0>] ? ext4_dirty_inode+0x30/0x70
 [<ffffffff81252bf2>] __ext4_journal_start_sb+0x82/0x150
 [<ffffffff8122cbf0>] ext4_dirty_inode+0x30/0x70
 [<ffffffff811b0942>] __mark_inode_dirty+0xe2/0x2b0
 [<ffffffff811a10e1>] update_time+0x81/0xc0
 [<ffffffff811a5662>] ? mnt_clone_write+0x12/0x30
 [<ffffffff811a11b8>] file_update_time+0x98/0xf0
 [<ffffffff8112a8aa>] ? find_get_page+0x9a/0xf0
 [<ffffffff8122ce10>] ext4_page_mkwrite+0x60/0x450
 [<ffffffff8114e84e>] __do_fault+0xde/0x470
 [<ffffffff8115149f>] handle_pte_fault+0x8f/0x890
 [<ffffffff811524a0>] handle_mm_fault+0x210/0x300
 [<ffffffff816cfecf>] __do_page_fault+0x18f/0x510
 [<ffffffff81070a63>] ? up_write+0x23/0x40
 [<ffffffff811452e4>] ? vm_mmap_pgoff+0xb4/0xe0
 [<ffffffff816cc5c9>] ? retint_swapgs+0xe/0x13
 [<ffffffff813493ad>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff816d025e>] do_page_fault+0xe/0x10
 [<ffffffff816cc7e2>] page_fault+0x22/0x30

Thanks,
Eric

