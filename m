From: Eric Paris <eparis@redhat.com>
Subject: general protection fault:  from release_blocks_on_commit
Date: Tue, 21 Oct 2008 14:03:01 -0400
Message-ID: <1224612181.19719.20.camel@paris-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: sandeen@redhat.com, tytso@mit.edu
To: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42704 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbYJUSDF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Oct 2008 14:03:05 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I can consistently get the below backtrace any time I try to shutdown my
machine.  This machine has ext4 as it's root FS.  This is 100%
reproducible.  I backed out commit
3e624fc72fba09b6f999a9fbb87b64efccd38036 and it fixed the problem.

This is a regression.

[ 2152.923123] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
[ 2152.923933] last sysfs file: /sys/devices/virtual/net/sit0/type
[ 2152.923933] Dumping ftrace buffer:
[ 2152.923933]    (ftrace buffer empty)
[ 2152.923933] CPU 0 
[ 2152.923933] Modules linked in: sit tunnel4 nfs lockd nfs_acl bridge stp bnep sco l2cap bluetooth sunrpc ip6t_REJECT nf_conntrack_ipv6 ipv6 dm_multipath ppdev floppy pcspkr e1000 i2c_piix4 i2c_core shpchp parport_pc parport ac scsi_wait_scan mptspi mptscsih mptbase scsi_transport_spi ext4 jbd2 crc16 [last unloaded: ip6_tables]
[ 2152.923933] Pid: 629, comm: kjournald2 Not tainted 2.6.27 #125
[ 2152.923933] RIP: 0010:[<ffffffffa0055510>]  [<ffffffffa0055510>] release_blocks_on_commit+0x28/0x15a [ext4]
[ 2152.923933] RSP: 0018:ffff8800159a1d10  EFLAGS: 00010282
[ 2152.923933] RAX: ffffffffa00554e8 RBX: ffff88001546b1d8 RCX: ffffffff819cf478
[ 2152.923933] RDX: 6b6b6b6b6b6b6b6b RSI: ffff88000f4e36d0 RDI: ffff88001546b1b0
[ 2152.923933] RBP: ffff8800159a1d90 R08: 0000000000000000 R09: ffff88000f4e38d0
[ 2152.923933] R10: 000000000000005a R11: ffffffff81097077 R12: ffff88001546b6b8
[ 2152.923933] R13: ffff88001546a120 R14: ffff88001546b1b0 R15: ffff88000f4e36d0
[ 2152.923933] FS:  0000000000000000(0000) GS:ffffffff81866980(0000) knlGS:0000000000000000
[ 2152.923933] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[ 2152.923933] CR2: 00007fc237226170 CR3: 0000000010964000 CR4: 00000000000006e0
[ 2152.923933] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2152.923933] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2152.923933] Process kjournald2 (pid: 629, threadinfo ffff8800159a0000, task ffff8800158f8000)
[ 2152.923933] Stack:
[ 2152.923933]  ffff8800159a1d30 ffff88000f4e36d0 ffff8800158f8000 ffff88001546b590
[ 2152.923933]  ffff8800159a1d70 0000000000000246 000000000006e957 0000000000000246
[ 2152.923933]  ffff8800159a1d70 ffffffff8119d972 ffff88001546b578 ffff88001546b1d8
[ 2152.923933] Call Trace:
[ 2152.923933]  [<ffffffff8119d972>] ? _raw_spin_unlock+0x8e/0x93
[ 2152.923933]  [<ffffffffa0016932>] jbd2_journal_commit_transaction+0x1274/0x1312 [jbd2]
[ 2152.923933]  [<ffffffff8106be97>] ? trace_hardirqs_on+0xd/0xf
[ 2152.923933]  [<ffffffff81053486>] ? try_to_del_timer_sync+0x50/0x5e
[ 2152.923933]  [<ffffffffa001ae07>] kjournald2+0x14f/0x3b5 [jbd2]
[ 2152.923933]  [<ffffffff8105e05d>] ? autoremove_wake_function+0x0/0x3d
[ 2152.923933]  [<ffffffffa001acb8>] ? kjournald2+0x0/0x3b5 [jbd2]
[ 2152.923933]  [<ffffffffa001acb8>] ? kjournald2+0x0/0x3b5 [jbd2]
[ 2152.923933]  [<ffffffff8105dece>] kthread+0x4e/0x7c
[ 2152.923933]  [<ffffffff81012859>] child_rip+0xa/0x11
[ 2152.923933]  [<ffffffff81011a63>] ? restore_args+0x0/0x30
[ 2152.923933]  [<ffffffff810445b6>] ? finish_task_switch+0x0/0xda
[ 2152.923933]  [<ffffffff8105de80>] ? kthread+0x0/0x7c
[ 2152.923933]  [<ffffffff8101284f>] ? child_rip+0x0/0x11
[ 2152.923933] Code: 5f c9 c3 55 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 58 0f 1f 44 00 00 48 89 75 88 48 8b 96 00 01 00 00 4c 8b af a0 05 00 00 <4c> 8b 32 e9 08 01 00 00 4c 8d 62 e8 4c 8d 7d 90 4c 89 ef 49 8b 
[ 2152.923933] RIP  [<ffffffffa0055510>] release_blocks_on_commit+0x28/0x15a [ext4]
[ 2152.923933]  RSP <ffff8800159a1d10>
[ 2153.162115] ---[ end trace 18e42daa426b7e09 ]---

