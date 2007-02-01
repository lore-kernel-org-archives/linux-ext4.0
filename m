From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Fw: [BUG -mm] ext3_orphan_add() accessing corrupted list on a corrupted ext3fs
Date: Thu, 1 Feb 2007 03:25:34 -0700
Message-ID: <20070201102534.GF5404@schatzie.adilger.int>
References: <20070201010836.31a63ef2.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Fengguang Wu <fengguang.wu@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:34636 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422771AbXBAKZg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Feb 2007 05:25:36 -0500
Content-Disposition: inline
In-Reply-To: <20070201010836.31a63ef2.akpm@osdl.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I don't have a comment on the actual bug here, but this is another case
where it would be nice to have multi-mount protection built into ext3...
When I last proposed this it was refused on the grounds that an external
HA manager should be doing this job but I don't think that is realistic.

Fengguang Wu <fengguang.wu@gmail.com> wrote:
> I accidentally ran two qemu instances on the same ext3 fs, after that bad
> things happened. After exiting the two qemus and running a new one, I got the
> following oops:
> 
> root ~# ll /etc/mtab
> /bin/ls: /etc/mtab: Input/output error
> root ~# rm /etc/mtab
> [  147.213090] EXT3-fs warning (device hda): ext3_unlink: Deleting nonexistent file (1775838), 0
> root ~# halt
> [  152.651209] list_add corruption. next->prev should be prev (ffff810007be1a38), but was ffff81000717e3d8. (next=ffff81000717e3d8).
> [  152.652507] ------------[ cut here ]------------
> [  152.652900] kernel BUG at lib/list_debug.c:27!
> [  152.653283] invalid opcode: 0000 [1] SMP
> [  152.653649] last sysfs file: /block/md2/uevent
> [  152.654020] CPU 0
> [  152.654228] Modules linked in:
> [  152.654549] Pid: 1107, comm: zsh Not tainted 2.6.20-rc6-mm3 #1
> [  152.655397] RIP: 0010:[<ffffffff8116f558>]  [<ffffffff8116f558>] __list_add+0x48/0xb0
> [  152.656139] RSP: 0018:ffff8100062bdd78  EFLAGS: 00000296
> [  152.656572] RAX: 0000000000000088 RBX: ffff81000717e3d8 RCX: 0000000000000000
> [  152.657140] RDX: ffffffff8101a433 RSI: 0000000000000001 RDI: ffffffff8141fb40
> [  152.657708] RBP: ffff8100062bdd98 R08: 0000000000000002 R09: ffffffff8101a270
> [  152.658275] R10: ffff8100062bdb58 R11: 0000000000000006 R12: ffff810007be1a38
> [  152.658842] R13: ffff81000717e3d8 R14: ffff810005a52170 R15: ffff81000717e3d8
> [  152.659415] FS:  00002ba30c98ae90(0000) GS:ffffffff81488000(0000) knlGS:0000000000000000
> [  152.660068] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  152.660531] CR2: 00002ba30d670000 CR3: 00000000062ee000 CR4: 00000000000006e0
> [  152.661103] Process zsh (pid: 1107, threadinfo ffff8100062bc000, task ffff810007895080)
> [  152.661731] Stack:  ffff8100061245b0 0000000000000000 ffff810007bcac20 ffff81000717e470
> [  152.662483]  ffff8100062bdda8 ffffffff8116f5cc ffff8100062bde18 ffffffff81129463
> [  152.663147]  ffff81000717e470 ffff81000717e300 ffff8100061245b0 0000000000000f80
> [  152.663779] Call Trace:
> [  152.664035]  [<ffffffff8116f5cc>] list_add+0xc/0x10
> [  152.664439]  [<ffffffff81129463>] ext3_orphan_add+0x163/0x1a0
> [  152.664943]  [<ffffffff8112a5c0>] ext3_unlink+0x150/0x1c0
> [  152.665385]  [<ffffffff81056942>] vfs_unlink+0xb2/0x110
> [  152.665813]  [<ffffffff81045e58>] do_unlinkat+0x108/0x1f0
> [  152.666255]  [<ffffffff81073341>] trace_hardirqs_on_thunk+0x35/0x37
> [  152.666761]  [<ffffffff810b2749>] trace_hardirqs_on+0x1a9/0x1d0
> [  152.667239]  [<ffffffff81073341>] trace_hardirqs_on_thunk+0x35/0x37
> [  152.667758]  [<ffffffff810ee891>] sys_unlink+0x11/0x20
> [  152.668180]  [<ffffffff8106c11e>] system_call+0x7e/0x83
> [  152.668602]
> [  152.668749]
> [  152.668754] Code: 0f 0b 66 66 90 66 66 90 eb fe 31 f6 49 3b 1c 24 48 c7 c7 60
> [  152.669850] RIP  [<ffffffff8116f558>] __list_add+0x48/0xb0
> [  152.670322]  RSP <ffff8100062bdd78>
> [  152.670842] BUG: at kernel/exit.c:860 do_exit()
> [  152.671209]
> [  152.671214] Call Trace:
> [  152.671543]  [<ffffffff8109a835>] profile_task_exit+0x15/0x20
> [  152.671992]  [<ffffffff81017f7b>] do_exit+0x6b/0xac0
> [  152.672384]  [<ffffffff81073d6c>] _spin_unlock_irqrestore+0x4c/0x60
> [  152.672871]  [<ffffffff8107b7b1>] die+0x61/0x70
> [  152.673230]  [<ffffffff81074b00>] do_trap+0xf0/0x110
> [  152.673624]  [<ffffffff8107be63>] do_invalid_op+0xb3/0xc0
> [  152.674048]  [<ffffffff8116f558>] __list_add+0x48/0xb0
> [  152.675955]  [<ffffffff8107439d>] error_exit+0x0/0x96
> [  152.676385]  [<ffffffff8101a270>] release_console_sem+0x50/0x230
> [  152.676876]  [<ffffffff8101a433>] release_console_sem+0x213/0x230
> [  152.677370]  [<ffffffff8116f558>] __list_add+0x48/0xb0
> [  152.677777]  [<ffffffff8116f558>] __list_add+0x48/0xb0
> [  152.678200]  [<ffffffff8116f5cc>] list_add+0xc/0x10
> [  152.678598]  [<ffffffff81129463>] ext3_orphan_add+0x163/0x1a0
> [  152.679105]  [<ffffffff8112a5c0>] ext3_unlink+0x150/0x1c0
> [  152.679570]  [<ffffffff81056942>] vfs_unlink+0xb2/0x110
> [  152.679991]  [<ffffffff81045e58>] do_unlinkat+0x108/0x1f0
> [  152.680436]  [<ffffffff81073341>] trace_hardirqs_on_thunk+0x35/0x37
> [  152.680945]  [<ffffffff810b2749>] trace_hardirqs_on+0x1a9/0x1d0
> [  152.681411]  [<ffffffff81073341>] trace_hardirqs_on_thunk+0x35/0x37
> [  152.681909]  [<ffffffff810ee891>] sys_unlink+0x11/0x20
> [  152.682341]  [<ffffffff8106c11e>] system_call+0x7e/0x83
> [  152.682761]
> 
> Regards,
> Wu
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
