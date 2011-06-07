From: Torsten Hilbrich <torsten.hilbrich@secunet.com>
Subject: Re: 2.6.37, 2.6.38, 2.6.39 vfs/ext3/ext4 crash when unplugging USB
 storage
Date: Tue, 07 Jun 2011 12:36:29 +0200
Message-ID: <4DEDFF2D.2030805@secunet.com>
References: <20110525132356.GA6296@janus> <4DDF46A4.3070601@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Frank van Maarseveen <frankvm@frankvm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:38500 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881Ab1FGKgf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Jun 2011 06:36:35 -0400
In-Reply-To: <4DDF46A4.3070601@secunet.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Am 27.05.2011 08:37, schrieb Torsten Hilbrich:

> Pid: 520, comm: bdi-default Not tainted 2.6.39 #40 LENOVO 20077KG/20077KG
> RIP: 0010:[<ffffffff811221f6>]  [<ffffffff811221f6>] redirty_tail+0x56/0xb0
> RSP: 0018:ffff88007cd49c08  EFLAGS: 00010292
> RAX: ffff88007d17b408 RBX: ffffffff8201d840 RCX: 6b6b6b6b6b6b6b6b
> RDX: ffff88007c3a1070 RSI: ffff88007c3a11c8 RDI: ffffffff81d33f32
> RBP: ffff88007cd49c10 R08: ffffffff8201d8b8 R09: ffff88007cd49c40
> R10: 0000000000000000 R11: ffffffff8201d8b8 R12: ffff88007bcee218
> R13: ffff88007cd49cc0 R14: ffff88007d17b408 R15: ffffffff8201d8c8
> FS:  0000000000000000(0000) GS:ffff88007fd00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00007f713597ebeb CR3: 0000000002003000 CR4: 00000000000006a0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process bdi-default (pid: 520, threadinfo ffff88007cd48000, task ffff88007cc65180)
> Stack:
>  ffffffff8201d840 ffff88007cd49c70 ffffffff811228fb ffff88007fc11b40
>  0000000000011b01 ffff88007fc11b40 ffffffff8201d8d8 ffff88007d17b470
>  ffffffff8201d840 ffff88007bde3d38 0000000000000400 0000000000000000
> Call Trace:
>  [<ffffffff811228fb>] writeback_sb_inodes+0x8b/0x1b0
>  [<ffffffff811235ff>] wb_writeback+0x18f/0x460
>  [<ffffffff81123971>] wb_do_writeback+0xa1/0x280
>  [<ffffffff81051b80>] ? del_timer+0xe0/0xe0
>  [<ffffffff810d70a7>] bdi_forker_thread+0xc7/0x510
>  [<ffffffff810d6fe0>] ? bdi_debug_stats_show+0x170/0x170
>  [<ffffffff810d6fe0>] ? bdi_debug_stats_show+0x170/0x170
>  [<ffffffff81063a86>] kthread+0x96/0xa0
>  [<ffffffff819c79f4>] kernel_thread_helper+0x4/0x10
>  [<ffffffff810639f0>] ? kthread_worker_fn+0x190/0x190
>  [<ffffffff819c79f0>] ? gs_change+0xb/0xb
> Code: 40 01 00 00 48 8b 52 68 8b 0d 27 01 ee 00 89 ce c1 fe 08 40 38 ce 74 66 48 8b 8a 58 01 00 00 48 8d b2 58 01 00 00 48 39 ce 74 15
>  8b 59 e8 48 39 58 50 79 0b 48 8b 0d b9 56 ff 00 48 89 48 50
> RIP  [<ffffffff811221f6>] redirty_tail+0x56/0xb0
>  RSP <ffff88007cd49c08>
> ---[ end trace 04e2da502b7fc110 ]---

Problem is no longer reproducible with the following commits applied:

commit d86e0e83b32bc84600adb0b6ea1fce389b266682
Author: Jens Axboe <jaxboe@fusionio.com>
Date:   Fri May 27 07:44:43 2011 +0200

    block: export blk_{get,put}_queue()

commit e73e079bf128d68284efedeba1fbbc18d78610f9
Author: James Bottomley <James.Bottomley@HansenPartnership.com>
Date:   Wed May 25 15:52:14 2011 -0500

    [SCSI] Fix oops caused by queue refcounting failure


	Torsten
