From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: ext4 patch queue updated(2.6.23-rc5)
Date: Thu, 13 Sep 2007 14:01:41 -0700
Message-ID: <1189717301.3751.11.camel@localhost.localdomain>
References: <1189643439.4935.30.camel@localhost.localdomain>
	 <46E95011.7040309@bull.net>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4 <linux-ext4@vger.kernel.org>, tytso@mit.edu
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:50766 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966AbXIMVBp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Sep 2007 17:01:45 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l8DL3B0j012784
	for <linux-ext4@vger.kernel.org>; Thu, 13 Sep 2007 17:03:11 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8DL1jYu525174
	for <linux-ext4@vger.kernel.org>; Thu, 13 Sep 2007 17:01:45 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8DL1iiW029148
	for <linux-ext4@vger.kernel.org>; Thu, 13 Sep 2007 17:01:45 -0400
In-Reply-To: <46E95011.7040309@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2007-09-13 at 16:58 +0200, Valerie Clement wrote:
> Mingming Cao wrote:
> > Rebased the patches to 2.6.23-rc5,  I reordered the series file to =
move
> > cleanups/fixes to the beginning of the series file. Added a patch t=
o
> > cleanup slab useage in jbd/jbd2, and fixed some checkpatch.pl warni=
ngs.
> > Added large block patch and Jose's FLEX_BG patch.
>=20
> With those new patches, I've got a segmentation fault when unmounting=
=20
> the ext4 filesystem:
>=20
Thanks for reporting this.  Some structure is not allocated from slab
anymore but freed by kfree, so it complains. An updated patch to follow=
=2E

> ------------[ cut here ]------------
> kernel BUG at /home/src/linux-2.6.23-rc5/mm/slab.c:592!
> invalid opcode: 0000 [1] SMP
> CPU 3
> Modules linked in: qla2xxx
> Pid: 4163, comm: umount Not tainted 2.6.23-rc5 #1
> RIP: 0010:[<ffffffff80276fe8>]  [<ffffffff80276fe8>] kfree+0x5f/0x1a0
> RSP: 0018:ffff810022143d88  EFLAGS: 00010046
> RAX: 0000000000000000 RBX: ffff81002889e154 RCX: 000000000000003f
> RDX: ffff81007ec4f290 RSI: ffffffff80245947 RDI: 000000000002889e
> RBP: ffff81002889e000 R08: 0000000000000001 R09: ffff81007c556400
> R10: ffff810022143d48 R11: ffffffff802fd50d R12: ffff81007c556400
> R13: ffff81002889e000 R14: 0000000000000286 R15: 0000000000513150
> FS:  00002b2fc8bafe20(0000) GS:ffff81007e0b5d40(0000) knlGS:000000000=
0000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00000000005b2b50 CR3: 000000007621e000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process umount (pid: 4163, threadinfo ffff810022142000, task=20
> ffff81007e0d8180)
> Stack:  ffff81007c556400 ffff81002889e024 ffff81002889e154 ffff810028=
89e000
>   ffff81007c556400 ffff81002889e024 00000000005130c0 ffffffff8031ac12
>   0000000000656473 ffff81007e0d8180 ffffffff80245a06 ffff810022143de0
> Call Trace:
>   [<ffffffff8031ac12>] jbd2_journal_destroy+0x257/0x262
>   [<ffffffff80245a06>] autoremove_wake_function+0x0/0x2e
>   [<ffffffff802ac42c>] mb_cache_shrink+0x1e/0x95
>   [<ffffffff802fda67>] ext4_put_super+0x39/0x1d8
>   [<ffffffff8027cf07>] generic_shutdown_super+0x60/0xf1
>   [<ffffffff8027cfa5>] kill_block_super+0xd/0x1e
>   [<ffffffff8027d04d>] deactivate_super+0x47/0x5f
>   [<ffffffff8028f37f>] sys_umount+0x1f7/0x22a
>   [<ffffffff8027e3c9>] sys_newstat+0x19/0x31
>   [<ffffffff8020b3ae>] system_call+0x7e/0x83
>=20
> Code: 0f 0b eb fe 65 8b 04 25 24 00 00 00 83 3d c1 9e 55 00 00 4c
> RIP  [<ffffffff80276fe8>] kfree+0x5f/0x1a0
>   RSP <ffff810022143d88>
> WARNING: at /home/src/linux-2.6.23-rc5/kernel/exit.c:901 do_exit()
>=20
> Call Trace:
>   [<ffffffff80236ff3>] do_exit+0x4f/0x7ac
>   [<ffffffff8020cb6d>] kernel_math_error+0x0/0x71
>   [<ffffffff8020cf94>] do_invalid_op+0x85/0x8f
>   [<ffffffff80276fe8>] kfree+0x5f/0x1a0
>   [<ffffffff80245947>] bit_waitqueue+0x1c/0x8c
>   [<ffffffff802459f5>] wake_up_bit+0x11/0x22
>   [<ffffffff80295178>] __writeback_single_inode+0x395/0x3a7
>   [<ffffffff805daa5d>] error_exit+0x0/0x84
>   [<ffffffff802fd50d>] ext4_destroy_inode+0x0/0x77
>   [<ffffffff80245947>] bit_waitqueue+0x1c/0x8c
>   [<ffffffff80276fe8>] kfree+0x5f/0x1a0
>   [<ffffffff80276fb7>] kfree+0x2e/0x1a0
>   [<ffffffff8031ac12>] jbd2_journal_destroy+0x257/0x262
>   [<ffffffff80245a06>] autoremove_wake_function+0x0/0x2e
>   [<ffffffff802ac42c>] mb_cache_shrink+0x1e/0x95
>   [<ffffffff802fda67>] ext4_put_super+0x39/0x1d8
>   [<ffffffff8027cf07>] generic_shutdown_super+0x60/0xf1
>   [<ffffffff8027cfa5>] kill_block_super+0xd/0x1e
>   [<ffffffff8027d04d>] deactivate_super+0x47/0x5f
>   [<ffffffff8028f37f>] sys_umount+0x1f7/0x22a
>   [<ffffffff8027e3c9>] sys_newstat+0x19/0x31
>   [<ffffffff8020b3ae>] system_call+0x7e/0x83
>=20
>=20
> Replacing  kfree(journal)  by jbd2_free(journal, sizeof(*journal)) in=
=20
> fs/jbd2/journal.c fixes the problem.
>=20
> Who could check this?
>=20
>=20
> Another thing: JBD-blocks-reservation-fix-for-large-blk.patch is in t=
he=20
> series file but not present in the ext4 patch queue.
>=20

Thanks for catching this. will add it to rc6 version patch queue.
>    Val=C3=A9rie
