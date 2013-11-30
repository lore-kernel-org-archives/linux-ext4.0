From: Christoph Hellwig <hch@infradead.org>
Subject: ext2 oops during xfstests
Date: Sat, 30 Nov 2013 06:40:06 -0800
Message-ID: <20131130144006.GA9570@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56216 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab3K3OkG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 30 Nov 2013 09:40:06 -0500
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red Hat Linux))
	id 1VmliI-0003Uz-1e
	for linux-ext4@vger.kernel.org; Sat, 30 Nov 2013 14:40:06 +0000
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

generic/219 1s ...
[  977.926884] ------------[ cut here ]------------
[  977.927794] kernel BUG at /work/hch/linux/fs/ext2/inode.c:635!
[  977.928930] invalid opcode: 0000 [#1] SMP 
[  977.929751] Modules linked in:
[  977.929931] CPU: 3 PID: 11331 Comm: chown Not tainted 3.13.0-rc1+ #53
[  977.929931] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[  977.929931] task: ffff880067600090 ti: ffff880072c14000 task.ti: ffff880072c14000
[  977.929931] RIP: 0010:[<ffffffff81254ce0>]  [<ffffffff81254ce0>] ext2_get_blocks+0xa40/0xb00
[  977.929931] RSP: 0018:ffff880072c15798  EFLAGS: 00010246
[  977.929931] RAX: 0000000000000000 RBX: ffff880072c15970 RCX: ffff880072c15970
[  977.929931] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88002d4adc08
[  977.929931] RBP: ffff880072c15908 R08: 0000000000000001 R09: ffff8800783ff400
[  977.929931] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88002d4adc08
[  977.929931] R13: 0000000000000800 R14: 0000000000000000 R15: 0000000000000400
[  977.929931] FS:  00007facfe395700(0000) GS:ffff88007fd80000(0000) knlGS:0000000000000000
[  977.929931] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  977.929931] CR2: 00007facfdec55b0 CR3: 000000006c71c000 CR4: 00000000000006e0
[  977.929931] Stack:
[  977.929931]  ffff880072c157f8 ffffffff810d5a1a ffff880072c15808 ffffffff810d5a1a
[  977.929931]  ffff880072c15848 0000000000000009 ffff880067600090 ffff8800676007b8
[  977.929931]  0000000000000009 ffff8800676007e0 000000000000000a ffff880072c15928
[  977.929931] Call Trace:
[  977.929931]  [<ffffffff810d5a1a>] ? __bfs+0x10a/0x230
[  977.929931]  [<ffffffff810d5a1a>] ? __bfs+0x10a/0x230
[  977.929931]  [<ffffffff810daf7a>] ? mark_held_locks+0x8a/0x120
[  977.929931]  [<ffffffff811bc58f>] ? __find_get_block+0xaf/0x250
[  977.929931]  [<ffffffff810db11d>] ? trace_hardirqs_on_caller+0x10d/0x1d0
[  977.929931]  [<ffffffff81254dc7>] ext2_get_block+0x27/0x50
[  977.929931]  [<ffffffff812574ab>] ext2_quota_write+0x14b/0x240
[  977.929931]  [<ffffffff81184bfd>] ? __kmalloc+0x13d/0x190
[  977.929931]  [<ffffffff810db11d>] ? trace_hardirqs_on_caller+0x10d/0x1d0
[  977.929931]  [<ffffffff810db1ed>] ? trace_hardirqs_on+0xd/0x10
[  977.929931]  [<ffffffff811edbb9>] write_blk+0x39/0x80
[  977.929931]  [<ffffffff811ede73>] get_free_dqblk+0x53/0xc0
[  977.929931]  [<ffffffff811ee798>] do_insert_tree+0x238/0x480
[  977.929931]  [<ffffffff811eff25>] ? from_kqid+0x25/0x50
[  977.929931]  [<ffffffff811ee7d8>] do_insert_tree+0x278/0x480
[  977.929931]  [<ffffffff811ee7d8>] do_insert_tree+0x278/0x480
[  977.929931]  [<ffffffff811ee7d8>] do_insert_tree+0x278/0x480
[  977.929931]  [<ffffffff811eea48>] qtree_write_dquot+0x68/0x160
[  977.929931]  [<ffffffff811ed356>] v2_write_dquot+0x26/0x30
[  977.929931]  [<ffffffff811e8f9e>] dquot_acquire+0xbe/0x150
[  977.929931]  [<ffffffff811e99bd>] dqget+0x23d/0x420
[  977.929931]  [<ffffffff811ecd2d>] dquot_transfer+0x5d/0xd0
[  977.929931]  [<ffffffff81255b1f>] ext2_setattr+0x7f/0x2b0
[  977.929931]  [<ffffffff811a5515>] notify_change+0x1a5/0x410
[  977.929931]  [<ffffffff811871d1>] chown_common.isra.17+0xe1/0x170
[  977.929931]  [<ffffffff81187f7e>] SyS_fchownat+0xae/0x120
[  977.929931]  [<ffffffff81c6be39>] system_call_fastpath+0x16/0x1b
