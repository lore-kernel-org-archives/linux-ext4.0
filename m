From: Christoph Hellwig <hch@infradead.org>
Subject: odd ext3/4 quota protection fault when running xfstests for xfs
Date: Tue, 31 May 2016 07:11:24 -0700
Message-ID: <20160531141124.GA12550@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60705 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbcEaOLZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 May 2016 10:11:25 -0400
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red Hat Linux))
	id 1b7kOC-0004pp-8R
	for linux-ext4@vger.kernel.org; Tue, 31 May 2016 14:11:24 +0000
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

My test VMs use ext3 as root fs, which now happens to be driven
by the ext4 modules.  I've seen the following panic when running
xfstests for xfs the second time now with 4.6 + a few XFS patches:

[ 2022.738145] Modules linked in:
[ 2022.738462] CPU: 1 PID: 971 Comm: sed Tainted: G        W
4.6.0+ #773
[ 2022.739150] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
[ 2022.740142] task: ffff880079f3cb00 ti: ffff880079b30000 task.ti: ffff880079b30000
[ 2022.740874] RIP: 0010:[<ffffffff8125bb28>]  [<ffffffff8125bb28>] dqput+0x188/0x1f0
[ 2022.741630] RSP: 0018:ffff880079b33c98  EFLAGS: 00010206
[ 2022.742160] RAX: 5a5a5a5a5a5a5a5a RBX: ffff88007c5186d0 RCX: 000000005a5a5a5a
[ 2022.742859] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffffffff826056c0
[ 2022.743560] RBP: ffff880079b33ca8 R08: 0000000000000001 R09: 0000000000000000
[ 2022.744256] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88007c518700
[ 2022.744955] R13: ffff880077297278 R14: ffff88007cdc8000 R15: ffff880077172088
[ 2022.745659] FS:  00007f4db928c800(0000) GS:ffff88007fc80000(0000) knlGS:0000000000000000
[ 2022.746450] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2022.747014] CR2: 00007f4db9297000 CR3: 000000004f077000 CR4: 00000000000006e0
[ 2022.747712] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2022.748390] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 2022.748971] Stack:
[ 2022.749179]  ffff8800772977d0 00000000000017b5 ffff880079b33cd8 ffffffff8125bbf9
[ 2022.749959]  ffff88007c5186d0 0000000000000000 0000000000000000 ffff880077297278
[ 2022.750728]  ffff880079b33cf0 ffffffff8125bc5c ffff880034151d70 ffff880079b33d88
[ 2022.751497] Call Trace:
[ 2022.751695]  [<ffffffff8125bbf9>] __dquot_drop+0x69/0x90
[ 2022.752121]  [<ffffffff8125bc5c>] dquot_drop+0x3c/0x40
[ 2022.752628]  [<ffffffff812aaf22>] ext4_free_inode+0xf2/0x680
[ 2022.753185]  [<ffffffff812b5bfd>] ? ext4_evict_inode+0x30d/0x4c0
[ 2022.753776]  [<ffffffff812b2a21>] ? ext4_mark_inode_dirty+0x71/0x220
[ 2022.754399]  [<ffffffff812b5c6b>] ext4_evict_inode+0x37b/0x4c0
[ 2022.754975]  [<ffffffff812149a0>] evict+0xc0/0x190
[ 2022.755447]  [<ffffffff812153f7>] iput+0x167/0x200
[ 2022.755896]  [<ffffffff812106ec>] __dentry_kill+0x17c/0x1e0
[ 2022.756472]  [<ffffffff812109e3>] dput+0x293/0x390
[ 2022.756980]  [<ffffffff81210770>] ? dput+0x20/0x390
[ 2022.757460]  [<ffffffff81209c70>] SyS_renameat2+0x380/0x4f0
[ 2022.758020]  [<ffffffff81209e09>] SyS_rename+0x19/0x20
[ 2022.758526]  [<ffffffff81e7057c>] entry_SYSCALL_64_fastpath+0x1f/0xbd
[ 2022.759157] Code: 01 00 00 00 72 6b 48 c7 c7 c0 56 60 82 e8 b1 42 c1 00 e9 ba fe ff ff f0 ff 8b c0 00 00 00 48 8b 83 10 01 00 00 8b 8b 1c 01 00 00 <8b> 80 50 01 00 00 0f a3 c8 73 0f ba 40 00 00 00 d3 e2 85 c2 0f 
[ 2022.761759] RIP  [<ffffffff8125bb28>] dqput+0x188/0x1f0
[ 2022.762288]  RSP <ffff880079b33c98>
[ 2022.762958] ---[ end trace 5ea916f398430658 ]---

(gdb) l *(dqput+0x188)
0xffffffff8122e938 is in dqput (../include/linux/quotaops.h:122).
117	 * Functions for checking status of quota
118	 */
119	
120	static inline bool sb_has_quota_usage_enabled(struct super_block *sb, int type)
121	{
122		return sb_dqopt(sb)->flags &
123 dquot_state_flag(DQUOT_USAGE_ENABLED, type);
124	}
125	
126	static inline bool sb_has_quota_limits_enabled(struct super_block *sb, int type)

