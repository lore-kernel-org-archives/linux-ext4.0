From: Jan Kara <jack@suse.cz>
Subject: Re: BUG:OOPS
Date: Wed, 7 Aug 2013 12:56:31 +0200
Message-ID: <20130807105631.GB12843@quack.suse.cz>
References: <201308011053355032592@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: majianpeng <majianpeng@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53334 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932619Ab3HGK4d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Aug 2013 06:56:33 -0400
Content-Disposition: inline
In-Reply-To: <201308011053355032592@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 01-08-13 11:10:57, majianpeng wrote:
> The current git: commit 06693f305e60202d2795a10bee7fb7da23bc2acc.
> I don't know how to reproduce this.
  Thanks for report! I'd need full disassebly of jbd2_journal_file_inod=
e()
function but guessing from decoding instructions around the place where=
 we
oopsed I think we passed NULL jinode into jbd2_journal_file_inode() -
likely this was introduced by 0713ed0cde76438d05849f1537d3aab46e099475.

Hum... jinode gets attached to ext4_inode_info in ext4_file_open(). But
here we entered that path via sys_truncate() so ext4_file_open() didn't=
 get
called. OK, so we need to attach jinode to ext4_inode_info somewhere in
truncate and punch hole paths. I'll prepare a patch for that.

								Honza
=20
> [  541.177396] BUG: unable to handle kernel NULL pointer dereference =
at           (null)
> [  541.177442] IP: [<ffffffff8122e793>] jbd2_journal_file_inode+0x53/=
0x140
> [  541.177476] PGD b7bed067 PUD 9fefd067 PMD 0=20
> [  541.177505] Oops: 0000 [#1] SMP=20
> [  541.177529] Modules linked in: fuse e1000e
> [  541.177562] CPU: 1 PID: 7145 Comm: ceph-osd Tainted: G        W   =
 3.11.0-rc3+ #29
> [  541.177595] Hardware name: To Be Filled By O.E.M. To Be Filled By =
O.E.M./To be filled by O.E.M., BIOS 080015  11/09/2011
> [  541.177638] task: ffff88009fee4600 ti: ffff88009d9de000 task.ti: f=
fff88009d9de000
> [  541.177667] RIP: 0010:[<ffffffff8122e793>]  [<ffffffff8122e793>] j=
bd2_journal_file_inode+0x53/0x140
> [  541.177705] RSP: 0018:ffff88009d9dfcc0  EFLAGS: 00010246
> [  541.177728] RAX: ffff8800b78da000 RBX: ffff880094ddfcc0 RCX: 00000=
00000004040
> [  541.177756] RDX: ffff8800bd429cc0 RSI: 0000000000000000 RDI: ffff8=
800b670cc00
> [  541.177783] RBP: ffff88009d9dfce0 R08: 0000000000000000 R09: 00000=
00000000000
> [  541.177810] R10: 0000000000000001 R11: 0000000000000000 R12: 00000=
00000000000
> [  541.177838] R13: ffff8800b670cc00 R14: ffff880072022208 R15: 00000=
00000000a4a
> [  541.177866] FS:  00007f3f97696700(0000) GS:ffff8800bd400000(0000) =
knlGS:0000000000000000
> [  541.177903] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  541.177927] CR2: 0000000000000000 CR3: 000000009fe1d000 CR4: 00000=
000000407e0
> [  541.177954] Stack:
> [  541.177965]  0000000000000a4a ffff880087916a60 ffffea0001adb080 ff=
ff880072022208
> [  541.178005]  ffff88009d9dfd40 ffffffff811e95eb 0000000000001000 00=
00000000001000
> [  541.178005]  00000000000005b6 ffff8800b670cc00 ffff880072022208 ff=
ff880087916a60
> [  541.178005] Call Trace:
> [  541.178005]  [<ffffffff811e95eb>] ext4_block_zero_page_range+0x3bb=
/0x3e0
> [  541.178005]  [<ffffffff811e972b>] ext4_block_truncate_page+0x2b/0x=
30
> [  541.178141]  [<ffffffff811ea363>] ext4_truncate+0x313/0x3a0
> [  541.178141]  [<ffffffff8112542d>] ? truncate_pagecache+0x5d/0x70
> [  541.178141]  [<ffffffff811eaebd>] ext4_setattr+0x3fd/0x740
> [  541.178141]  [<ffffffff811836ab>] notify_change+0x1db/0x390
> [  541.178141]  [<ffffffff81165550>] do_truncate+0x60/0xa0
> [  541.178141]  [<ffffffff81165706>] vfs_truncate+0x176/0x1a0
> [  541.178141]  [<ffffffff8116578c>] do_sys_truncate+0x5c/0xa0
> [  541.178141]  [<ffffffff8116594e>] SyS_truncate+0xe/0x10
> [  541.178141]  [<ffffffff816e6254>] tracesys+0xdd/0xe2
> [  541.178141] Code: db 0f 84 f3 00 00 00 41 f6 45 1c 08 0f 85 ae 00 =
00 00 49 8b 45 00 48 85 c0 0f 84 a1 00 00 00 48 8b 00 f6 00 02 0f 85 95=
 00 00 00 <49> 39 1c 24 4c 8b 2b 0f 84 90 00 00 00 49 39 5c 24 08 0f 84=
 85=20
> [  541.178141] RIP  [<ffffffff8122e793>] jbd2_journal_file_inode+0x53=
/0x140
> [  541.178141]  RSP <ffff88009d9dfcc0>
> [  541.178141] CR2: 0000000000000000
> [  541.178738] ---[ end trace 951cd63ac5df02d2 ]---
>=20
>=20
> Thanks!
> Jianpeng MaN?=D0=A0=E9=AA=92r??y????b?X?=E8=82=9A?v?^?)=E8=97=93{.n?+=
?=E4=BC=90?{?{=1Bx?{ay?=1D?????,j=07??f=EF=BC=82?h???z?=1E?w=E3=82=A2?=0C=
=E2=92=8E?j:+v???w?j?m????=07??=E8=B5=99zZ+?????=E8=8C=9Bj"??!
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
