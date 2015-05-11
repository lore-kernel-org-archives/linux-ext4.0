From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 98091] New: kernel/sched/core.c:7291 __might_sleep+0x87/0x90()
Date: Mon, 11 May 2015 18:15:49 +0000
Message-ID: <bug-98091-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:33025 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753546AbbEKSPw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 May 2015 14:15:52 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 2CAAD2064B
	for <linux-ext4@vger.kernel.org>; Mon, 11 May 2015 18:15:51 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id AF5EC20601
	for <linux-ext4@vger.kernel.org>; Mon, 11 May 2015 18:15:49 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=98091

            Bug ID: 98091
           Summary: kernel/sched/core.c:7291 __might_sleep+0x87/0x90()
           Product: File System
           Version: 2.5
    Kernel Version: 4.1.0-0.rc3.git0.1.fc23.x86_64+debug
          Hardware: x86-64
                OS: Linux
              Tree: Fedora
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: pomidorabelisima@gmail.com
        Regression: No

[   38.413109] ------------[ cut here ]------------
[   38.413119] WARNING: CPU: 1 PID: 6 at kernel/sched/core.c:7291
__might_sleep+0x87/0x90()
[   38.413124] do not call blocking ops when !TASK_RUNNING; state=2 set at
[<ffffffff81898dd5>] wait_for_completion_io+0xe5/0x140
...
[   38.413200] CPU: 1 PID: 6 Comm: kworker/u16:0 Tainted: G         C     
4.1.0-0.rc3.git0.1.fc23.x86_64+debug #1
...
[   38.413217] Call Trace:
[   38.413221]  [<ffffffff81895355>] dump_stack+0x4c/0x65
[   38.413224]  [<ffffffff810b043a>] warn_slowpath_common+0x8a/0xc0
[   38.413227]  [<ffffffff810b04c5>] warn_slowpath_fmt+0x55/0x70
[   38.413229]  [<ffffffff81898dd5>] ? wait_for_completion_io+0xe5/0x140
[   38.413230]  [<ffffffff81898dd5>] ? wait_for_completion_io+0xe5/0x140
[   38.413232]  [<ffffffff810e0b67>] __might_sleep+0x87/0x90
[   38.413235]  [<ffffffff813fdeaf>] generic_make_request_checks+0x3f/0x600
[   38.413238]  [<ffffffff8189e726>] ? _raw_spin_unlock_irqrestore+0x36/0x70
[   38.413241]  [<ffffffff811102fd>] ? trace_hardirqs_on_caller+0x13d/0x1e0
[   38.413243]  [<ffffffff813fe497>] generic_make_request+0x27/0x130
[   38.413250]  [<ffffffffa0000438>] raid1_unplug+0x108/0x160 [raid1]
[   38.413253]  [<ffffffff8140437a>] blk_flush_plug_list+0x9a/0x260
[   38.413256]  [<ffffffff81897710>] io_schedule_timeout+0x120/0x130
[   38.413258]  [<ffffffff81898df7>] wait_for_completion_io+0x107/0x140
[   38.413260]  [<ffffffff810e9c90>] ? wake_up_state+0x20/0x20
[   38.413263]  [<ffffffff8140c087>] __blkdev_issue_zeroout+0x227/0x270
[   38.413265]  [<ffffffff81898d3a>] ? wait_for_completion_io+0x4a/0x140
[   38.413268]  [<ffffffff8140c17a>] blkdev_issue_zeroout+0xaa/0x100
[   38.413271]  [<ffffffff813512f2>] ext4_ext_zeroout.isra.34+0x52/0x60
[   38.413274]  [<ffffffff813572a0>]
ext4_ext_handle_unwritten_extents+0x680/0x10d0
[   38.413276]  [<ffffffff81358247>] ext4_ext_map_blocks+0x527/0x13c0
[   38.413279]  [<ffffffff81324779>] ? ext4_map_blocks+0x179/0x510
[   38.413281]  [<ffffffff81324779>] ? ext4_map_blocks+0x179/0x510
[   38.413283]  [<ffffffff8132479d>] ext4_map_blocks+0x19d/0x510
[   38.413285]  [<ffffffff8132828d>] ext4_writepages+0x7fd/0x13e0
[   38.413289]  [<ffffffff81201c91>] do_writepages+0x21/0x40
[   38.413292]  [<ffffffff812b72c0>] __writeback_single_inode+0x70/0xb00
[   38.413294]  [<ffffffff812b8360>] writeback_sb_inodes+0x2c0/0x680
[   38.413296]  [<ffffffff812b87c2>] __writeback_inodes_wb+0xa2/0xd0
[   38.413298]  [<ffffffff812b8c03>] wb_writeback+0x413/0x790
[   38.413300]  [<ffffffff812a2224>] ? get_nr_inodes+0x54/0x80
[   38.413302]  [<ffffffff812b95b1>] bdi_writeback_workfn+0x3b1/0x8c0
[   38.413305]  [<ffffffff810d1572>] process_one_work+0x232/0x860
[   38.413307]  [<ffffffff810d14db>] ? process_one_work+0x19b/0x860
[   38.413309]  [<ffffffff810d1c7a>] ? worker_thread+0xda/0x470
[   38.413312]  [<ffffffff810d1bf3>] worker_thread+0x53/0x470
[   38.413314]  [<ffffffff810d1ba0>] ? process_one_work+0x860/0x860
[   38.413316]  [<ffffffff810d86c4>] kthread+0x104/0x120
[   38.413319]  [<ffffffff810ee045>] ? local_clock+0x25/0x30
[   38.413321]  [<ffffffff810d85c0>] ? kthread_create_on_node+0x250/0x250
[   38.413323]  [<ffffffff8189f5a2>] ret_from_fork+0x42/0x70
[   38.413325]  [<ffffffff810d85c0>] ? kthread_create_on_node+0x250/0x250
[   38.413327] ---[ end trace ca9ea5620ac2e2e0 ]---

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
