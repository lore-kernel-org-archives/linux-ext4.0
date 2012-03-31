From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCH v1 0/9] do not use s_dirt in ext4
Date: Sat, 31 Mar 2012 15:25:31 +0300
Message-ID: <1333196731.2221.2.camel@golum>
References: <1332254489-2300-1-git-send-email-dedekind1@gmail.com>
	 <20120322095342.GC14485@quack.suse.cz>
	 <1332410747.18717.12.camel@sauron.fi.intel.com>
	 <20120322103309.GA14484@quack.suse.cz>
	 <1332854998.31549.40.camel@sauron.fi.intel.com>
	 <20120327201401.GF5020@quack.suse.cz>
	 <1333121035.5440.49.camel@sauron.fi.intel.com>
	 <20120330153530.GH5587@quack.suse.cz>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Ted Tso <tytso@mit.edu>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:25565 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756300Ab2CaMZl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 31 Mar 2012 08:25:41 -0400
In-Reply-To: <20120330153530.GH5587@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2012-03-30 at 17:35 +0200, Jan Kara wrote:
>   Hmm, looks like we tried to checkpoint BH_Unwritten buffer. That looks
> like a bug in fallocate() support. Not really related but definitely worth
> reporting.

Yeah, vanilla 3.3 dies as well, with a bit different oops though.

[10697.469725] ------------[ cut here ]------------
[10697.470440] kernel BUG at fs/buffer.c:2871!
[10697.470440] invalid opcode: 0000 [#1] SMP 
[10697.470440] CPU 9 
[10697.470440] Modules linked in: [last unloaded: scsi_wait_scan]
[10697.470440] 
[10697.470440] Pid: 27877, comm: fsstress Not tainted 3.3.0+ #43 Bochs Bochs
[10697.470440] RIP: 0010:[<ffffffff811a9add>]  [<ffffffff811a9add>] submit_bh+0x10d/0x120
[10697.470440] RSP: 0018:ffff8803dfbef758  EFLAGS: 00010202
[10697.470440] RAX: 000000000004d025 RBX: ffff8803ffaa66e8 RCX: 0000000000000000
[10697.470440] RDX: ffff8803dfbeffd8 RSI: ffff8803ffaa66e8 RDI: 0000000000000211
[10697.470440] RBP: ffff8803dfbef778 R08: ffff880409013600 R09: 0000000000000001
[10697.470440] R10: 0000000000000000 R11: ffff88040656f240 R12: 0000000000000211
[10697.470440] R13: ffff8803dfbef834 R14: ffff8804065d6800 R15: ffff8803dfbeffd8
[10697.470440] FS:  00007fd0012a0700(0000) GS:ffff88041fd20000(0000) knlGS:0000000000000000
[10697.470440] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[10697.470440] CR2: 00007fcffc22dbc8 CR3: 0000000406d3d000 CR4: 00000000000006e0
[10697.470440] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[10697.470440] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[10697.470440] Process fsstress (pid: 27877, threadinfo ffff8803dfbee000, task ffff880404a60000)
[10697.470440] Stack:
[10697.470440]  ffff8804065d6b18 ffff8803ffaa66e8 0000000000000211 ffff8803dfbef834
[10697.470440]  ffff8803dfbef798 ffffffff811ab59d 000000000000003c ffff8804065d6af8
[10697.470440]  ffff8803dfbef7f8 ffffffff8123be2d 0000000091827364 ffff8803dfbef7b0
[10697.470440] Call Trace:
[10697.470440]  [<ffffffff811ab59d>] write_dirty_buffer+0x4d/0x80
[10697.470440]  [<ffffffff8123be2d>] __flush_batch+0x4d/0xa0
[10697.470440]  [<ffffffff8123c8aa>] jbd2_log_do_checkpoint+0x38a/0x4f0
[10697.470440]  [<ffffffff812c800d>] ? __write_lock_failed+0xd/0x20
[10697.470440]  [<ffffffff8123ca99>] __jbd2_log_wait_for_space+0x89/0x190
[10697.470440]  [<ffffffff812c8029>] ? __read_lock_failed+0x9/0x20
[10697.470440]  [<ffffffff81237aa8>] start_this_handle+0x3a8/0x4e0
[10697.470440]  [<ffffffff810799e0>] ? remove_wait_queue+0x50/0x50
[10697.470440]  [<ffffffff81237ca3>] jbd2__journal_start+0xc3/0x100
[10697.470440]  [<ffffffff81237cf3>] jbd2_journal_start+0x13/0x20
[10697.470440]  [<ffffffff8121740f>] ext4_journal_start_sb+0x7f/0x1d0
[10697.470440]  [<ffffffff811f9322>] ? ext4_write_begin+0x112/0x310
[10697.470440]  [<ffffffff811f6465>] ? ext4_meta_trans_blocks+0xa5/0xb0
[10697.470440]  [<ffffffff811f9322>] ext4_write_begin+0x112/0x310
[10697.470440]  [<ffffffff811f96d4>] ext4_da_write_begin+0x1b4/0x210
[10697.470440]  [<ffffffff812383e7>] ? jbd2_journal_stop+0x1b7/0x2b0
[10697.470440]  [<ffffffff8111af42>] generic_file_buffered_write+0x112/0x290
[10697.470440]  [<ffffffff8111c7b9>] __generic_file_aio_write+0x229/0x440
[10697.470440]  [<ffffffff8111ca42>] generic_file_aio_write+0x72/0xe0
[10697.470440]  [<ffffffff811f319f>] ext4_file_write+0xbf/0x260
[10697.470440]  [<ffffffff81165d5f>] ? kmem_cache_free+0x2f/0x130
[10697.470440]  [<ffffffff81186af3>] ? putname+0x33/0x50
[10697.470440]  [<ffffffff8117ada2>] do_sync_write+0xd2/0x110
[10697.470440]  [<ffffffff812633bc>] ? security_file_permission+0x2c/0xb0
[10697.470440]  [<ffffffff8117b321>] ? rw_verify_area+0x61/0xf0
[10697.470440]  [<ffffffff8117b683>] vfs_write+0xb3/0x180
[10697.470440]  [<ffffffff8117b9aa>] sys_write+0x4a/0x90
[10697.470440]  [<ffffffff815e6d69>] system_call_fastpath+0x16/0x1b
[10697.470440] Code: ee 44 89 e7 e8 45 1f 0f 00 49 8b 5d 18 4c 89 ef e8 19 4e 00 00 48 83 c4 08 c1 e3 18 c1 fb 1f 83 e3 a1 89 d8 5b 41 5c 41 5d 5d c3 <0f> 0b 0f 0b 0f 0b 0f 0b 0f 0b 66 0f 1f 84 00 00 00 00 00 55 48 
[10697.470440] RIP  [<ffffffff811a9add>] submit_bh+0x10d/0x120
[10697.470440]  RSP <ffff8803dfbef758>
[10697.497128] ---[ end trace 21134344c4537c68 ]---
[10697.497589] ------------[ cut here ]------------
[10697.498081] WARNING: at kernel/exit.c:897 do_exit+0x55/0x870()
[10697.498575] Hardware name: Bochs
[10697.499044] Modules linked in: [last unloaded: scsi_wait_scan]
[10697.499725] Pid: 27877, comm: fsstress Tainted: G      D      3.3.0+ #43
[10697.500280] Call Trace:
[10697.500682]  [<ffffffff810572bf>] warn_slowpath_common+0x7f/0xc0
[10697.501223]  [<ffffffff8105731a>] warn_slowpath_null+0x1a/0x20
[10697.501721]  [<ffffffff8105b1c5>] do_exit+0x55/0x870
[10697.502231]  [<ffffffff81058f6c>] ? kmsg_dump+0x5c/0xf0
[10697.502714]  [<ffffffff815dfeac>] oops_end+0xac/0xf0
[10697.503243]  [<ffffffff81017928>] die+0x58/0x90
[10697.503701]  [<ffffffff815df7a4>] do_trap+0xc4/0x170
[10697.504208]  [<ffffffff81014fa5>] do_invalid_op+0x95/0xb0
[10697.504696]  [<ffffffff811a9add>] ? submit_bh+0x10d/0x120
[10697.505598]  [<ffffffff81299dc4>] ? drive_stat_acct+0x114/0x190
[10697.506136]  [<ffffffff8129ec46>] ? blk_queue_bio+0x106/0x400
[10697.506633]  [<ffffffff815e7f9b>] invalid_op+0x1b/0x20
[10697.507163]  [<ffffffff811a9add>] ? submit_bh+0x10d/0x120
[10697.507648]  [<ffffffff811a9ac7>] ? submit_bh+0xf7/0x120
[10697.508164]  [<ffffffff811ab59d>] write_dirty_buffer+0x4d/0x80
[10697.508663]  [<ffffffff8123be2d>] __flush_batch+0x4d/0xa0
[10697.509187]  [<ffffffff8123c8aa>] jbd2_log_do_checkpoint+0x38a/0x4f0
[10697.509700]  [<ffffffff812c800d>] ? __write_lock_failed+0xd/0x20
[10697.510238]  [<ffffffff8123ca99>] __jbd2_log_wait_for_space+0x89/0x190
[10697.510754]  [<ffffffff812c8029>] ? __read_lock_failed+0x9/0x20
[10697.511180]  [<ffffffff81237aa8>] start_this_handle+0x3a8/0x4e0
[10697.511522]  [<ffffffff810799e0>] ? remove_wait_queue+0x50/0x50
[10697.511863]  [<ffffffff81237ca3>] jbd2__journal_start+0xc3/0x100
[10697.512230]  [<ffffffff81237cf3>] jbd2_journal_start+0x13/0x20
[10697.512569]  [<ffffffff8121740f>] ext4_journal_start_sb+0x7f/0x1d0
[10697.512915]  [<ffffffff811f9322>] ? ext4_write_begin+0x112/0x310
[10697.513283]  [<ffffffff811f6465>] ? ext4_meta_trans_blocks+0xa5/0xb0
[10697.513631]  [<ffffffff811f9322>] ext4_write_begin+0x112/0x310
[10697.513970]  [<ffffffff811f96d4>] ext4_da_write_begin+0x1b4/0x210
[10697.514340]  [<ffffffff812383e7>] ? jbd2_journal_stop+0x1b7/0x2b0
[10697.514683]  [<ffffffff8111af42>] generic_file_buffered_write+0x112/0x290
[10697.515077]  [<ffffffff8111c7b9>] __generic_file_aio_write+0x229/0x440
[10697.515428]  [<ffffffff8111ca42>] generic_file_aio_write+0x72/0xe0
[10697.515771]  [<ffffffff811f319f>] ext4_file_write+0xbf/0x260
[10697.516127]  [<ffffffff81165d5f>] ? kmem_cache_free+0x2f/0x130
[10697.516467]  [<ffffffff81186af3>] ? putname+0x33/0x50
[10697.516790]  [<ffffffff8117ada2>] do_sync_write+0xd2/0x110
[10697.517146]  [<ffffffff812633bc>] ? security_file_permission+0x2c/0xb0
[10697.517498]  [<ffffffff8117b321>] ? rw_verify_area+0x61/0xf0
[10697.517834]  [<ffffffff8117b683>] vfs_write+0xb3/0x180
[10697.518184]  [<ffffffff8117b9aa>] sys_write+0x4a/0x90
[10697.518508]  [<ffffffff815e6d69>] system_call_fastpath+0x16/0x1b
[10697.518934] ---[ end trace 21134344c4537c69 ]---

-- 
Best Regards,
Artem Bityutskiy

