From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 45971] New: BUG: unable to handle kernel paging request
Date: Tue, 14 Aug 2012 12:49:51 +0000 (UTC)
Message-ID: <bug-45971-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:60633 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754686Ab2HNMt4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Aug 2012 08:49:56 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7943A201B2
	for <linux-ext4@vger.kernel.org>; Tue, 14 Aug 2012 12:49:54 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id D9BF820230
	for <linux-ext4@vger.kernel.org>; Tue, 14 Aug 2012 12:49:51 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=45971

           Summary: BUG: unable to handle kernel paging request
           Product: File System
           Version: 2.5
    Kernel Version: latest git (3.6.0-rc1+)
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: tracek@redhat.com
        Regression: No


Created an attachment (id=77711)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=77711)
kernel config

Hi,

I have Fedora 17 in qemu with latest kernel from git and sometimes during IO I
got:

[  163.976057] BUG: unable to handle kernel paging request at 000000000001118b
[  163.976950] IP: [<ffffffff8138b128>] generic_make_request_checks+0xe8/0x380
[  163.977010] PGD 33c3b067 PUD 33cc3067 PMD 0 
[  163.977010] Oops: 0002 [#1] SMP 
[  163.977010] CPU 0 
[  163.977010] Pid: 246, comm: flush-8:0 Not tainted 3.6.0-rc1+ #11 Bochs Bochs
[  163.977010] RIP: 0010:[<ffffffff8138b128>]  [<ffffffff8138b128>]
generic_make_request_checks+0xe8/0x380
[  163.977010] RSP: 0000:ffff88005c2fd7c0  EFLAGS: 00010246
[  163.977010] RAX: ffff88005c6d80ff RBX: ffff880033e7bb40 RCX:
ffff88005c703400
[  163.977010] RDX: ffff88005d424900 RSI: ffff880033e7bb40 RDI:
0000000000800002
[  163.977010] RBP: ffff88005c2fd840 R08: 0000000000011200 R09:
0000000000014828
[  163.977010] R10: ffffffff8189f080 R11: 000000000000000a R12:
0000000000000008
[  163.977010] R13: 000000000000ffff R14: ffff88005c6d8000 R15:
0000000000000001
[  163.977010] FS:  0000000000000000(0000) GS:ffff88005fc00000(0000)
knlGS:0000000000000000
[  163.977010] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  163.977010] CR2: 000000000001118b CR3: 000000004ceeb000 CR4:
00000000000006f0
[  163.977010] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[  163.977010] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[  163.977010] Process flush-8:0 (pid: 246, threadinfo ffff88005c2fc000, task
ffff880059010000)
[  163.977010] Stack:
[  163.977010]  ffff88005c6d8000 ffff88005c6d8000 0080000200011210
0000000000001c60
[  163.977010]  ffff88005c2fd840 ffff880059010000 ffff88005c2fd800
ffffffff81104475
[  163.977010]  ffff88005c2fd880 00000000e6e9ab18 ffff88005c6dc000
ffff880033e7bb40
[  163.977010] Call Trace:
[  163.977010]  [<ffffffff81104475>] ? mempool_alloc_slab+0x15/0x20
[  163.977010]  [<ffffffff8138e248>] generic_make_request+0x18/0x100
[  163.977010]  [<ffffffff8138e3b5>] submit_bio+0x85/0x110
[  163.977010]  [<ffffffff8118013a>] ? bio_alloc_bioset+0x5a/0xf0
[  163.977010]  [<ffffffff8117cd9b>] submit_bh+0xeb/0x120
[  163.977010]  [<ffffffff8117d9f0>] __block_write_full_page+0x210/0x3a0
[  163.977010]  [<ffffffff8117bbc0>] ? end_buffer_async_read+0x130/0x130
[  163.977010]  [<ffffffff81182490>] ? blkdev_get_blocks+0xd0/0xd0
[  163.977010]  [<ffffffff81182490>] ? blkdev_get_blocks+0xd0/0xd0
[  163.977010]  [<ffffffff8117dc4a>] block_write_full_page_endio+0xca/0x100
[  163.977010]  [<ffffffff8117dc95>] block_write_full_page+0x15/0x20
[  163.977010]  [<ffffffff81181fe8>] blkdev_writepage+0x18/0x20
[  163.977010]  [<ffffffff81109fe7>] __writepage+0x17/0x40
[  163.977010]  [<ffffffff8110bdac>] write_cache_pages+0x20c/0x480
[  163.977010]  [<ffffffff81109fd0>] ? global_dirtyable_memory+0x40/0x40
[  163.977010]  [<ffffffff8110c06a>] generic_writepages+0x4a/0x70
[  163.977010]  [<ffffffff8110c0b0>] do_writepages+0x20/0x40
[  163.977010]  [<ffffffff8117251f>] __writeback_single_inode+0x3f/0x170
[  163.977010]  [<ffffffff811740c5>] writeback_sb_inodes+0x1a5/0x3e0
[  163.977010]  [<ffffffff8117439e>] __writeback_inodes_wb+0x9e/0xd0
[  163.977010]  [<ffffffff8117464b>] wb_writeback+0x27b/0x330
[  163.977010]  [<ffffffff81175bb0>] wb_do_writeback+0x190/0x1d0
[  163.977010]  [<ffffffff81175c7b>] bdi_writeback_thread+0x8b/0x290
[  163.977010]  [<ffffffff81175bf0>] ? wb_do_writeback+0x1d0/0x1d0
[  163.977010]  [<ffffffff8106c913>] kthread+0x93/0xa0
[  163.977010]  [<ffffffff8159fd84>] kernel_thread_helper+0x4/0x10
[  163.977010]  [<ffffffff8106c880>] ? insert_kthread_work+0x50/0x50
[  163.977010]  [<ffffffff8159fd80>] ? gs_change+0x13/0x13
[  163.977010] Code: 10 48 2b 01 8b 3f 48 89 45 98 48 8b 82 90 00 00 00 89 7d
94 48 8b 80 60 02 00 00 48 89 45 88 00 00 00 00 00 45 85 e4 74 30 48 8b <43> 10
48 8b 40 08 48 8b 40 48 48 c1 f8 09 48 85 c0 74 1b 44 89 
[  163.977010] RIP  [<ffffffff8138b128>] generic_make_request_checks+0xe8/0x380
[  163.977010]  RSP <ffff88005c2fd7c0>
[  163.977010] CR2: 000000000001118b
[  164.018791] ---[ end trace eaf7077baceb7656 ]---
[  167.712050] BUG: unable to handle kernel paging request at 000000000001118b
[  167.712962] IP: [<ffffffff8138b128>] generic_make_request_checks+0xe8/0x380
[  167.713009] PGD 33f8c067 PUD 33fe2067 PMD 0 
[  167.713009] Oops: 0002 [#2] SMP 
[  167.713009] CPU 0 
[  167.713009] Pid: 47, comm: jbd2/sda2-8 Tainted: G      D      3.6.0-rc1+ #11
Bochs Bochs
[  167.713009] RIP: 0010:[<ffffffff8138b128>]  [<ffffffff8138b128>]
generic_make_request_checks+0xe8/0x380
[  167.713009] RSP: 0000:ffff88005c721890  EFLAGS: 00010246
[  167.713009] RAX: ffff88005c6d80ff RBX: ffff880033e7b600 RCX:
ffff88005c703400
[  167.713009] RDX: ffff88005d424900 RSI: ffff880033e7b600 RDI:
0000000000800002
[  167.713009] RBP: ffff88005c721910 R08: 0000000000011200 R09:
0000000000014828
[  167.713009] R10: ffffffff8189f080 R11: 000000000000000a R12:
0000000000000008
[  167.713009] R13: 000000000000ffff R14: ffff88005c6d8000 R15:
0000000000000001
[  167.713009] FS:  0000000000000000(0000) GS:ffff88005fc00000(0000)
knlGS:0000000000000000
[  167.713009] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  167.713009] CR2: 000000000001118b CR3: 000000005c7c7000 CR4:
00000000000006f0
[  167.713009] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[  167.713009] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[  167.713009] Process jbd2/sda2-8 (pid: 47, threadinfo ffff88005c720000, task
ffff88005c6516b0)
[  167.713009] Stack:
[  167.713009]  ffff88005c721910 ffff88005c6d8000 0080000200011210
00000000000cd018
[  167.713009]  ffff88005c721910 ffff88005c6516b0 ffff88005c7218d0
ffffffff81104475
[  167.713009]  ffff88005c721950 0000000048a4b73d ffff88005c721910
ffff880033e7b600
[  167.713009] Call Trace:
[  167.713009]  [<ffffffff81104475>] ? mempool_alloc_slab+0x15/0x20
[  167.713009]  [<ffffffff8138e248>] generic_make_request+0x18/0x100
[  167.713009]  [<ffffffff8138e3b5>] submit_bio+0x85/0x110
[  167.713009]  [<ffffffff8118013a>] ? bio_alloc_bioset+0x5a/0xf0
[  167.713009]  [<ffffffff8117cd9b>] submit_bh+0xeb/0x120
[  167.713009]  [<ffffffff8117d9f0>] __block_write_full_page+0x210/0x3a0
[  167.713009]  [<ffffffff8117bbc0>] ? end_buffer_async_read+0x130/0x130
[  167.713009]  [<ffffffff811e6000>] ? ext4_get_block_write+0x20/0x20
[  167.713009]  [<ffffffff811e6000>] ? ext4_get_block_write+0x20/0x20
[  167.713009]  [<ffffffff8117dc4a>] block_write_full_page_endio+0xca/0x100
[  167.713009]  [<ffffffff8117bbc0>] ? end_buffer_async_read+0x130/0x130
[  167.713009]  [<ffffffff8117dc95>] block_write_full_page+0x15/0x20
[  167.713009]  [<ffffffff811e5d9b>] ext4_writepage+0x1bb/0x280
[  167.713009]  [<ffffffff81109fe7>] __writepage+0x17/0x40
[  167.713009]  [<ffffffff8110bdac>] write_cache_pages+0x20c/0x480
[  167.713009]  [<ffffffff81090d6f>] ? ktime_get_ts+0x9f/0xd0
[  167.713009]  [<ffffffff81109fd0>] ? global_dirtyable_memory+0x40/0x40
[  167.713009]  [<ffffffff8117b770>] ? do_thaw_one+0x90/0x90
[  167.713009]  [<ffffffff8159d36b>] ? io_schedule+0xab/0xd0
[  167.713009]  [<ffffffff8117b770>] ? do_thaw_one+0x90/0x90
[  167.713009]  [<ffffffff8110c06a>] generic_writepages+0x4a/0x70
[  167.713009]  [<ffffffff81226085>]
jbd2_journal_commit_transaction+0x3d5/0x17f0
[  167.713009]  [<ffffffff81081bd0>] ? account_entity_dequeue+0x80/0xa0
[  167.713009]  [<ffffffff8122abe6>] kjournald2+0xb6/0x240
[  167.713009]  [<ffffffff8106d580>] ? abort_exclusive_wait+0xb0/0xb0
[  167.713009]  [<ffffffff8122ab30>] ? commit_timeout+0x10/0x10
[  167.713009]  [<ffffffff8106c913>] kthread+0x93/0xa0
[  167.713009]  [<ffffffff8159fd84>] kernel_thread_helper+0x4/0x10
[  167.713009]  [<ffffffff8106c880>] ? insert_kthread_work+0x50/0x50
[  167.713009]  [<ffffffff8159fd80>] ? gs_change+0x13/0x13
[  167.713009] Code: 10 48 2b 01 8b 3f 48 89 45 98 48 8b 82 90 00 00 00 89 7d
94 48 8b 80 60 02 00 00 48 89 45 88 00 00 00 00 00 45 85 e4 74 30 48 8b <43> 10
48 8b 40 08 48 8b 40 48 48 c1 f8 09 48 85 c0 74 1b 44 89 
[  167.713009] RIP  [<ffffffff8138b128>] generic_make_request_checks+0xe8/0x380
[  167.713009]  RSP <ffff88005c721890>
[  167.713009] CR2: 000000000001118b
[  167.755297] ---[ end trace eaf7077baceb7657 ]---

However I cannot reproduce it with distribution's kernel (3.5.0-2.fc17).

Regards, Tom

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
