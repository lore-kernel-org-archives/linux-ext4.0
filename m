From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: [BUG] Linux 2.6.25-rc2 - Kernel Ooops while running dbench
Date: Sat, 16 Feb 2008 11:14:46 +0530
Message-ID: <47B6784E.2090401@linux.vnet.ibm.com>
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>,
	Balbir Singh <balbir@linux.vnet.ibm.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:46763 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbYBPFo6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Feb 2008 00:44:58 -0500
In-Reply-To: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

The 2.6.25-rc2 kernel oopses while running dbench on ext3 filesystem
mounted with mount -o data=writeback,nobh option on the x86_64 box

BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
IP: [<ffffffff80274972>] kmem_cache_alloc+0x3a/0x6c
PGD 1f6860067 PUD 1f5d64067 PMD 0 
Oops: 0000 [1] SMP 
CPU 3 
Modules linked in:
Pid: 4271, comm: dbench Not tainted 2.6.25-rc2-autotest #1
RIP: 0010:[<ffffffff80274972>]  [<ffffffff80274972>] kmem_cache_alloc+0x3a/0x6c
RSP: 0000:ffff8101fb041dc8  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff810180033c00 RCX: ffffffff8027b269
RDX: 0000000000000000 RSI: 00000000000080d0 RDI: ffffffff80632d70
RBP: 00000000000080d0 R08: 0000000000000001 R09: 0000000000000000
R10: ffff8101feb36e50 R11: 0000000000000190 R12: 0000000000000001
R13: 0000000000000000 R14: ffff8101f8f38000 R15: 00000000ffffff9c
FS:  0000000000000000(0000) GS:ffff8101fff0f000(0063) knlGS:00000000f7e41460
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000001f5620000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process dbench (pid: 4271, threadinfo ffff8101fb040000, task ffff8101fb180000)
Stack:  0000000000000001 ffff8101fb041ea8 0000000000000001 ffffffff8027b269
 ffff8101fb041ea8 ffffffff80281fe8 0000000000000001 0000000000000000
 ffff8101fb041ea8 00000000ffffff9c 000000000000000b 0000000000000001
Call Trace:
 [<ffffffff8027b269>] get_empty_filp+0x55/0xf9
 [<ffffffff80281fe8>] __path_lookup_intent_open+0x22/0x8f
 [<ffffffff80282853>] open_namei+0x86/0x5a7
 [<ffffffff8027d019>] vfs_stat_fd+0x3c/0x4a
 [<ffffffff80279ab1>] do_filp_open+0x1c/0x3d
 [<ffffffff80279c2c>] get_unused_fd_flags+0x79/0x111
 [<ffffffff80279dce>] do_sys_open+0x46/0xca
 [<ffffffff80221c82>] ia32_sysret+0x0/0xa


Code: 24 00 00 00 48 98 48 8b 9c c7 d8 02 00 00 48 8b 13 f6 c2 01 74 12 83 ca ff 49 89 d8 89 ee e8 1f fb ff ff 48 89 c2 eb 13 8b 43 14 <48> 8b 34 c2 48 89 d0 48 0f b1 33 48 39 d0 75 d3 c1 ed 0f 31 c0 
RIP  [<ffffffff80274972>] kmem_cache_alloc+0x3a/0x6c
 RSP <ffff8101fb041dc8>
CR2: 0000000000000000
BUG: unable to handle kernel paging request at 00000000f51f3e1c
IP: [<ffffffff80417d02>] tg3_poll+0x10c/0x82e
PGD 1f6860067 PUD 1f37a5067 PMD 0 
Oops: 0000 [2] SMP 
CPU 3 
Modules linked in:
Pid: 4271, comm: dbench Tainted: G      D  2.6.25-rc2-autotest #1
RIP: 0010:[<ffffffff80417d02>]  [<ffffffff80417d02>] tg3_poll+0x10c/0x82e
RSP: 0000:ffff8100e3b6fe60  EFLAGS: 00010206
RAX: 00000000f51f3e18 RBX: ffff8101ff1d4f50 RCX: 00000000000032e1
RDX: 00000000000032e1 RSI: 0000000000000246 RDI: ffffffff806aaad8
RBP: ffff8101ff67e6c0 R08: ffff8100e3b6fedc R09: ffff8100e3b6fee0
R10: 0000000000000282 R11: 0000000000000282 R12: 000000000000014f
R13: ffff8101f51f3d80 R14: 0000000000000000 R15: 000000000000014f
FS:  0000000000000000(0000) GS:ffff8101fff0f000(0063) knlGS:00000000f7e41460
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 00000000f51f3e1c CR3: 00000001f5620000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process dbench (pid: 4271, threadinfo ffff8101fb040000, task ffff8101fb180000)
Stack:  ffff8101fb041d18 ffff8101feb83040 ffff8100e3b6ff20 ffffffff80228bd0
 ffff8100e3b6feec 00000000fff0ff80 ffff8101ff0c4000 0000000000000246
 ffff8101ff0c4000 0000004000000000 ffff8101ff67e758 ffff8101ff67e758
Call Trace:
 <IRQ>  [<ffffffff80228bd0>] run_rebalance_domains+0x162/0x432
 [<ffffffff80477b5e>] net_rx_action+0x75/0x14a
 [<ffffffff80233ef0>] __do_softirq+0x50/0xbb
 [<ffffffff8020c33c>] call_softirq+0x1c/0x28
 [<ffffffff8020e4b7>] do_softirq+0x2f/0x84
 [<ffffffff8021b8a8>] smp_apic_timer_interrupt+0x8b/0x9e
 [<ffffffff8020bde6>] apic_timer_interrupt+0x66/0x70
 <EOI>  [<ffffffff8021e3c0>] flat_send_IPI_mask+0x0/0x4c
 [<ffffffff8020cca6>] oops_end+0x38/0x6a
 [<ffffffff802200dd>] do_page_fault+0x716/0x7bf
 [<ffffffff804ebab9>] error_exit+0x0/0x51
 [<ffffffff8027b269>] get_empty_filp+0x55/0xf9
 [<ffffffff80274972>] kmem_cache_alloc+0x3a/0x6c
 [<ffffffff8027b269>] get_empty_filp+0x55/0xf9
 [<ffffffff80281fe8>] __path_lookup_intent_open+0x22/0x8f
 [<ffffffff80282853>] open_namei+0x86/0x5a7
 [<ffffffff8027d019>] vfs_stat_fd+0x3c/0x4a
 [<ffffffff80279ab1>] do_filp_open+0x1c/0x3d
 [<ffffffff80279c2c>] get_unused_fd_flags+0x79/0x111
 [<ffffffff80279dce>] do_sys_open+0x46/0xca
 [<ffffffff80221c82>] ia32_sysret+0x0/0xa


Code: 8b 05 a3 2e 29 00 41 ff c4 45 31 f6 41 81 e4 ff 01 00 00 ff 50 28 48 c7 03 00 00 00 00 41 8b 85 a0 00 00 00 49 03 85 a8 00 00 00 <0f> b7 40 04 39 44 24 2c 0f 8d 95 00 00 00 44 89 e0 48 6b d8 18 
RIP  [<ffffffff80417d02>] tg3_poll+0x10c/0x82e
 RSP <ffff8100e3b6fe60>
CR2: 00000000f51f3e1c

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
