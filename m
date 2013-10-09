From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 62751] New: INFO: rcu_sched detected stalls on CPUs/tasks: { 3}
 (detected by 2, t=15107 jiffies, g=270766, c=270765, q=0)
Date: Wed, 09 Oct 2013 13:55:53 +0000
Message-ID: <bug-62751-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:52111 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891Ab3JINz7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Oct 2013 09:55:59 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A77F5201EF
	for <linux-ext4@vger.kernel.org>; Wed,  9 Oct 2013 13:55:57 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 40C10201F2
	for <linux-ext4@vger.kernel.org>; Wed,  9 Oct 2013 13:55:54 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=62751

            Bug ID: 62751
           Summary: INFO: rcu_sched detected stalls on CPUs/tasks: { 3}
                    (detected by 2, t=15107 jiffies, g=270766, c=270765,
                    q=0)
           Product: File System
           Version: 2.5
    Kernel Version: 3.11.3-031103-generic
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: loris.luise@gmail.com
        Regression: No

Oct  9 09:51:19 h3oserver2 kernel: [87982.718328] NMI backtrace for cpu 3
Oct  9 09:51:19 h3oserver2 kernel: [87982.718351] CPU: 3 PID: 71 Comm: kswapd0
Not tainted 3.11.3-031103-generic #201310011421
Oct  9 09:51:19 h3oserver2 kernel: [87982.718355] Hardware name: VMware, Inc.
VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 01/15/2013
Oct  9 09:51:19 h3oserver2 kernel: [87982.718361] task: ffff8801b5d3c650 ti:
ffff8801b2026000 task.ti: ffff8801b2026000
Oct  9 09:51:19 h3oserver2 kernel: [87982.718363] RIP:
0010:[<ffffffff8128cfa3>]  [<ffffffff8128cfa3>] __ext4_es_shrink+0xb3/0x200
Oct  9 09:51:19 h3oserver2 kernel: [87982.869348] RSP: 0018:ffff8801b2027b78 
EFLAGS: 00010293
Oct  9 09:51:19 h3oserver2 kernel: [87982.869352] RAX: ffff8801b4a89f30 RBX:
ffff880002b29c00 RCX: ffff8801b2027ba8
Oct  9 09:51:19 h3oserver2 kernel: [87982.869353] RDX: ffff880002b29f30 RSI:
ffff880002b2af30 RDI: 000000010129c39a
Oct  9 09:51:19 h3oserver2 kernel: [87982.869357] RBP: ffff8801b2027be8 R08:
ffff880002b2af30 R09: ffffea0006933480
Oct  9 09:51:19 h3oserver2 kernel: [87982.869359] R10: ffffffff8128cdfd R11:
0000000000000002 R12: 000000000000003a
Oct  9 09:51:19 h3oserver2 kernel: [87982.869360] R13: 0000000000000000 R14:
ffff8801b0060800 R15: ffff8801b0060c10
Oct  9 09:51:19 h3oserver2 kernel: [87982.869385] FS:  0000000000000000(0000)
GS:ffff8801bfcc0000(0000) knlGS:0000000000000000
Oct  9 09:51:19 h3oserver2 kernel: [87982.869387] CS:  0010 DS: 0000 ES: 0000
CR0: 000000008005003b
Oct  9 09:51:19 h3oserver2 kernel: [87982.869388] CR2: 0000000002236028 CR3:
0000000001c0d000 CR4: 00000000000006e0
Oct  9 09:51:19 h3oserver2 kernel: [87982.869403] Stack:
Oct  9 09:51:19 h3oserver2 kernel: [87982.869406]  ffff8801b1c1bb80
ffff88006019d330 ffff88006027e730 ffff8801b2027ba8
Oct  9 09:51:19 h3oserver2 kernel: [87982.869409]  ffff8801b0060c80
00000046012f3080 ffff8801b4b2db30 ffff880002b28730
Oct  9 09:51:19 h3oserver2 kernel: [87982.869412]  ffff8801b2027fd8
ffff8801b0060be0 ffff8801b2027d18 0000000000010fa0
Oct  9 09:51:19 h3oserver2 kernel: [87982.910096] Call Trace:
Oct  9 09:51:19 h3oserver2 kernel: [87982.910141]  [<ffffffff8128d1b8>]
ext4_es_shrink+0xc8/0x140
Oct  9 09:51:19 h3oserver2 kernel: [87982.910158]  [<ffffffff8115b6b4>]
shrink_slab+0x154/0x300
Oct  9 09:51:19 h3oserver2 kernel: [87982.910179]  [<ffffffff8172ea0e>] ?
_raw_spin_lock+0xe/0x20
Oct  9 09:51:19 h3oserver2 kernel: [87982.910191]  [<ffffffff811ad776>] ?
vmpressure+0x76/0xa0
Oct  9 09:51:19 h3oserver2 kernel: [87982.910194]  [<ffffffff8115de8b>]
kswapd_shrink_zone+0xfb/0x1a0
Oct  9 09:51:19 h3oserver2 kernel: [87982.910197]  [<ffffffff8115ec5c>]
balance_pgdat+0x32c/0x470
Oct  9 09:51:19 h3oserver2 kernel: [87982.910200]  [<ffffffff81166d60>] ?
vm_events_fold_cpu+0x50/0x50
Oct  9 09:51:19 h3oserver2 kernel: [87982.910203]  [<ffffffff8115eec3>]
kswapd+0x123/0x240
Oct  9 09:51:19 h3oserver2 kernel: [87982.910205]  [<ffffffff8115eda0>] ?
balance_pgdat+0x470/0x470
Oct  9 09:51:19 h3oserver2 kernel: [87982.910521]  [<ffffffff81089040>]
kthread+0xc0/0xd0
Oct  9 09:51:19 h3oserver2 kernel: [87982.910526]  [<ffffffff81088f80>] ?
flush_kthread_worker+0xb0/0xb0
Oct  9 09:51:19 h3oserver2 kernel: [87982.910532]  [<ffffffff81737dac>]
ret_from_fork+0x7c/0xb0
Oct  9 09:51:19 h3oserver2 kernel: [87982.910535]  [<ffffffff81088f80>] ?
flush_kthread_worker+0xb0/0xb0
Oct  9 09:51:19 h3oserver2 kernel: [87982.910536] Code: 8c da 00 00 00 0f 84 d4
00 00 00 0f 1f 44 00 00 48 8b 7a 18 49 39 be 20 04 00 00 48 8d 9a d0 fc ff ff
73 44 48 8b 42 08 48 8b 32 <48> 89 46 08 48 89 30 48 8b 45 c8 48 89 55 c8 48 89
0a 48 89 42

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
