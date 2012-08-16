From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 45941] BUG: soft lockup - CPU#1 stuck for 21s! [kworker/1:1:64]
 BUG: soft lockup - CPU#4 stuck for 22s! [flush-252:0:384]
Date: Thu, 16 Aug 2012 13:56:25 +0000 (UTC)
Message-ID: <20120816135625.3F65711FC6D@bugzilla.kernel.org>
References: <bug-45941-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:46379 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932587Ab2HPN43 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Aug 2012 09:56:29 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A0D66201BD
	for <linux-ext4@vger.kernel.org>; Thu, 16 Aug 2012 13:56:27 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id A0DC4201BB
	for <linux-ext4@vger.kernel.org>; Thu, 16 Aug 2012 13:56:25 +0000 (UTC)
In-Reply-To: <bug-45941-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=45941





--- Comment #2 from Loris Luise <loris.luise@gmail.com>  2012-08-16 13:56:24 ---
can Another oop dump be useful? Thanks

Aug 16 07:55:28 h3oserver2 kernel: [147758.832781] BUG: soft lockup - CPU#2
stuck for 23s! [netstat:18634]
Aug 16 07:55:28 h3oserver2 kernel: [147759.046380] Modules linked in: btrfs
zlib_deflate libcrc32c ufs qnx4 hfsplus hfs minix ntfs msdos jfs xfs reiserfs
xt_multiport pcnet32 ext2 xt_hl ip6t_rt nf_conntrack_ipv6 nf_defrag_ipv6
dm_crypt ipt_REJECT xt_LOG xt_limit xt_tcpudp xt_addrtype xt_state
ip6table_filter ip6_tables ppdev nf_conntrack_netbios_ns nf_conntrack_broadcast
vmw_balloon nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ftp
coretemp nf_conntrack microcode psmouse iptable_filter ip_tables x_tables
serio_raw parport_pc lp i2c_piix4 mac_hid shpchp parport vmxnet3 floppy
vmw_pvscsi
Aug 16 07:55:28 h3oserver2 kernel: [147759.630769] CPU 2
Aug 16 07:55:28 h3oserver2 kernel: [147759.630772] Modules linked in: btrfs
zlib_deflate libcrc32c ufs qnx4 hfsplus hfs minix ntfs msdos jfs xfs reiserfs
xt_multiport pcnet32 ext2 xt_hl ip6t_rt nf_conntrack_ipv6 nf_defrag_ipv6
dm_crypt ipt_REJECT xt_LOG xt_limit xt_tcpudp xt_addrtype xt_state
ip6table_filter ip6_tables ppdev nf_conntrack_netbios_ns nf_conntrack_broadcast
vmw_balloon nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ftp
coretemp nf_conntrack microcode psmouse iptable_filter ip_tables x_tables
serio_raw parport_pc lp i2c_piix4 mac_hid shpchp parport vmxnet3 floppy
vmw_pvscsi
Aug 16 07:55:28 h3oserver2 kernel: [147759.652655]
Aug 16 07:55:28 h3oserver2 kernel: [147759.678170] Pid: 18634, comm: netstat
Not tainted 3.5.1-030501-generic #201208091310 VMware, Inc. VMware Virtual
Platform/440BX Desktop Reference Platform
Aug 16 07:55:28 h3oserver2 kernel: [147759.688391] RIP:
0010:[<ffffffff815d0b5e>]  [<ffffffff815d0b5e>] established_get_next+0xfe/0x190
Aug 16 07:55:28 h3oserver2 kernel: [147759.928918] RSP: 0018:ffff880161f8fde8 
EFLAGS: 00010286
Aug 16 07:55:28 h3oserver2 kernel: [147759.928923] RAX: 0000000000060500 RBX:
ffff880018139400 RCX: 000000000007ffff
Aug 16 07:55:28 h3oserver2 kernel: [147759.928925] RDX: ffffc90010e82000 RSI:
ffffc90011487000 RDI: ffffffff815d0b28
Aug 16 07:55:28 h3oserver2 kernel: [147759.928926] RBP: ffff880161f8fdf8 R08:
0000000000000014 R09: 000000000000ffff
Aug 16 07:55:28 h3oserver2 kernel: [147759.928928] R10: 0000000000000000 R11:
000000000000000f R12: ffff0014ff0a0000
Aug 16 07:55:28 h3oserver2 kernel: [147759.928930] R13: ffff8801ffffffff R14:
ffff8801630898b5 R15: 000000000000074b
Aug 16 07:55:28 h3oserver2 kernel: [147759.928984] FS:  00007f5d094bf700(0000)
GS:ffff88017fc40000(0000) knlGS:0000000000000000
Aug 16 07:55:28 h3oserver2 kernel: [147759.928987] CS:  0010 DS: 0000 ES: 0000
CR0: 0000000080050033
Aug 16 07:55:28 h3oserver2 kernel: [147759.928988] CR2: 0000000000415f95 CR3:
000000011ccfb000 CR4: 00000000000006e0
Aug 16 07:55:28 h3oserver2 kernel: [147759.974228] DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Aug 16 07:55:28 h3oserver2 kernel: [147759.974266] DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Aug 16 07:55:28 h3oserver2 kernel: [147760.003496] Process netstat (pid: 18634,
threadinfo ffff880161f8e000, task ffff880173125c00)
Aug 16 07:55:28 h3oserver2 kernel: [147760.003505] Stack:
Aug 16 07:55:28 h3oserver2 kernel: [147760.003507]  ffff880018139400
ffff8801745c7440 ffff880161f8fe28 ffffffff815d0cef
Aug 16 07:55:28 h3oserver2 kernel: [147760.003514]  ffff880161f8fe28
ffff8801622b0d00 ffff880018139400 ffff8801684c0000
Aug 16 07:55:28 h3oserver2 kernel: [147760.003518]  ffff880161f8fea8
ffffffff811a8d08 ffff88013ffa4530 0002000000000001
Aug 16 07:55:28 h3oserver2 kernel: [147760.003522] Call Trace:
Aug 16 07:55:28 h3oserver2 kernel: [147760.003535]  [<ffffffff815d0cef>]
tcp_seq_next+0x3f/0xa0
Aug 16 07:55:28 h3oserver2 kernel: [147760.087408]  [<ffffffff811a8d08>]
seq_read+0x238/0x400
Aug 16 07:55:28 h3oserver2 kernel: [147760.087434]  [<ffffffff811a8ad0>] ?
seq_put_decimal_ll+0x60/0x60
Aug 16 07:55:28 h3oserver2 kernel: [147760.158567]  [<ffffffff811e7402>]
proc_reg_read+0x82/0xc0
Aug 16 07:55:28 h3oserver2 kernel: [147760.178084]  [<ffffffff811873c0>]
vfs_read+0xb0/0x180
Aug 16 07:55:28 h3oserver2 kernel: [147760.178108]  [<ffffffff811874da>]
sys_read+0x4a/0x90
Aug 16 07:55:28 h3oserver2 kernel: [147760.291955]  [<ffffffff8169fe69>]
system_call_fastpath+0x16/0x1b
Aug 16 07:55:28 h3oserver2 kernel: [147760.291966] Code: 0d 58 bb 95 00 48 8b
15 41 bb 95 00 c7 43 1c 00 00 00 00 83 c0 01 39 c8 89 43 18 0f 87 8e 00 00 00
48 63 f0 48 c1 e6 04 48 01 d6 <f6> 06 01 75 73 23 05 2b bb 95 00 48 8d 3c 85 00
00 00 00 48 03

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
