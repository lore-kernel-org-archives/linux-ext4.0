From: Dmitriy Monakhov <dmonakhov@sw.ru>
Subject: Re: delayed allocatiou result in Oops
Date: Sat, 16 Jun 2007 12:14:26 +0400
Message-ID: <20070616081426.GB14349@localhost.sw.ru>
References: <20070614072352.GA6517@localhost.sw.ru> <4672202C.4080304@clusterfs.com> <1181949368.3808.7.camel@dyn9047017103.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Alex Tomas <alex@clusterfs.com>, linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:30068 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbXFPINy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 16 Jun 2007 04:13:54 -0400
Content-Disposition: inline
In-Reply-To: <1181949368.3808.7.camel@dyn9047017103.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 16:16 =D0=9F=D1=82=D0=BD 15 =D0=98=D1=8E=D0=BD     , Mingming Cao wr=
ote:
> I hit almost the same issue today also, but with different error #, a=
nd
> one more kernel oops, when run fsstress on x86_64.=20
>=20
> EXT4-fs: writeback error =3D -2
> EXT4-fs: writeback error =3D -2
This error never happens in writeback in my case, only ENOSPC.
Btw: i've send one more micro fix (see in this thread " PATCH] ext4:fix=
=20
invariant checking in ext4_rebalance_reservation")
>=20
> Unable to handle kernel NULL pointer dereference at 0000000000000000 =
RIP:=20
>  [<ffffffff8028bbb6>] block_read_full_page+0xb5/0x267
> PGD 1f9842067 PUD 1f9843067 PMD 0=20
> Oops: 0000 [5] SMP=20
> CPU 3=20
> Modules linked in:
> Pid: 10900, comm: fsstress Not tainted 2.6.22-rc4-autokern1 #1
> RIP: 0010:[<ffffffff8028bbb6>]  [<ffffffff8028bbb6>] block_read_full_=
page+0xb5/0x267
> RSP: 0000:ffff8101f984fa48  EFLAGS: 00010213
> RAX: 0000000000000179 RBX: 0000000000000000 RCX: 000000000000000c
> RDX: 000000000000000c RSI: ffffffff802e0f7b RDI: ffff81017ff578c8
> RBP: ffff81017ff578c8 R08: ffff8101f984fbe8 R09: ffff8101f984fbe0
> R10: 0000000000000000 R11: 0000000000000000 R12: 00000000000000e5
> R13: 0000000000000000 R14: 0000000000001000 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff8101803ec5c0(0063) knlGS:00000000f=
7dec460
> CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 00000001f9841000 CR4: 00000000000006e0
> Process fsstress (pid: 10900, threadinfo ffff8101f984e000, task ffff8=
101f9824280)
> Stack:  00001000f9ad4080 0000000100000000 0000000000000000 0000000000=
000179
>  ffff8100de7c4100 ffffffff802e0f7b 000003363e3761bf ffffffff804eac2d
>  ffff8101f984fb48 0000000000000082 ffff81017e9bc550 ffff81017e9bc588
> Call Trace:
>  [<ffffffff802e0f7b>] ext4_get_block+0x0/0x104
>  [<ffffffff804eac2d>] thread_return+0x0/0xd5
>  [<ffffffff8028fcd6>] do_mpage_readpage+0x411/0x430
>  [<ffffffff804eb481>] io_schedule+0x26/0x32
>  [<ffffffff804eb6fb>] __wait_on_bit_lock+0x5f/0x6d
>  [<ffffffff8028fe7e>] mpage_readpage+0x42/0x5b
>  [<ffffffff802e0f7b>] ext4_get_block+0x0/0x104
>  [<ffffffff802395eb>] wake_bit_function+0x0/0x23
>  [<ffffffff8024a9bd>] file_read_actor+0x89/0xf4
>  [<ffffffff8024a21e>] find_get_page+0x1e/0x4d
>  [<ffffffff8024a763>] do_generic_mapping_read+0x20e/0x3df
>  [<ffffffff8024a934>] file_read_actor+0x0/0xf4
>  [<ffffffff8024c2e7>] generic_file_aio_read+0x11d/0x154
>  [<ffffffff8026c7ca>] do_sync_read+0xc8/0x10b
>  [<ffffffff80272c4f>] permission+0xbb/0xbd
>  [<ffffffff802395bd>] autoremove_wake_function+0x0/0x2e
>  [<ffffffff8026be62>] nameidata_to_filp+0x25/0x34
>  [<ffffffff8026be9e>] do_filp_open+0x2d/0x3d
>  [<ffffffff8026f355>] vfs_getattr+0x2b/0x2f
>  [<ffffffff8026f43d>] vfs_fstat+0x33/0x3a
>  [<ffffffff8026c8b8>] vfs_read+0xab/0x12e
>  [<ffffffff8026cbbc>] sys_read+0x45/0x6e
>  [<ffffffff80219f02>] ia32_sysret+0x0/0xa
>=20
[skip]
> ------------[ cut here ]------------
> kernel BUG at fs/ext4/writeback.c:266!
Yepp. I've saw this oops too, But IMHO it may be artefact caused by
previous one.
> invalid opcode: 0000 [6] SMP=20
> CPU 3=20
> Modules linked in:
> Pid: 10851, comm: fsstress Not tainted 2.6.22-rc4-autokern1 #1
> RIP: 0010:[<ffffffff802ed5f6>]  [<ffffffff802ed5f6>] ext4_wb_submit_e=
xtent+0x1ef/0x3d9
> RSP: 0000:ffff8101e47cfab8  EFLAGS: 00010246
> RAX: 000000000001182c RBX: ffff8100c6709ca0 RCX: 000000000000000c
> RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff8101e8de5000
> RBP: ffff8100c6709a48 R08: ffff8101b1056338 R09: 0000000000000000
> R10: ffff8101b1056338 R11: ffff8100c6709a48 R12: 0000000000000040
> R13: ffff81017eaa5b98 R14: 0000000000000040 R15: 0000000000000001
> FS:  0000000000000000(0000) GS:ffff8101803ec5c0(0063) knlGS:00000000f=
7dec460
> CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
> CR2: 00000000f7dcb004 CR3: 00000001e47c1000 CR4: 00000000000006e0
> Process fsstress (pid: 10851, threadinfo ffff8101e47ce000, task ffff8=
101e47a6b30)
> Stack:  ffff8101cf22c9b8 0000000000000000 0000000000000001 0000000c00=
000001
>  ffff8100c6709a48 000000018028938e ffff8101e47cfb68 0000000000000000
>  ffff8101e47cfd28 ffff8100c6709ca0 ffff8100c6709a48 ffff8100c6709990
> Call Trace:
>  [<ffffffff802edb95>] ext4_wb_handle_extent+0x3b5/0x48c
>  [<ffffffff802ebc24>] ext4_ext_walk_space+0x18a/0x20c
>  [<ffffffff802ed7e0>] ext4_wb_handle_extent+0x0/0x48c
>  [<ffffffff802edcc7>] ext4_wb_flush+0x5b/0x153
>  [<ffffffff802ee1a0>] ext4_wb_writepages+0x34b/0x398
>  [<ffffffff8024f81b>] do_writepages+0x20/0x2d
>  [<ffffffff80286164>] __writeback_single_inode+0x1df/0x3a7
>  [<ffffffff8024a47e>] find_get_pages_tag+0x34/0x89
>  [<ffffffff80250c66>] pagevec_lookup_tag+0x1a/0x24
>  [<ffffffff80249e89>] wait_on_page_writeback_range+0xc7/0x10d
>  [<ffffffff80286702>] sync_sb_inodes+0x1cb/0x2a0
>  [<ffffffff8028687c>] sync_inodes_sb+0xa5/0xb9
>  [<ffffffff803b3e09>] __up_read+0x10/0x8a
>  [<ffffffff802868fa>] __sync_inodes+0x6a/0xb1
>  [<ffffffff80286952>] sync_inodes+0x11/0x29
>  [<ffffffff8028895c>] do_sync+0x2c/0x50
>  [<ffffffff8028898b>] sys_sync+0xb/0xf
>  [<ffffffff80219f02>] ia32_sysret+0x0/0xa
>=20
>=20
> Code: 0f 0b eb fe f0 41 0f ba 75 00 14 48 8b 4c 24 40 01 51 10 48=20
> RIP  [<ffffffff802ed5f6>] ext4_wb_submit_extent+0x1ef/0x3d9
>  RSP <ffff8101e47cfab8>
>=20
> I will try the patch below...Alex, any hint about the second oops?
>=20
> Mingming
> Alex please=20
> On Fri, 2007-06-15 at 09:14 +0400, Alex Tomas wrote:
> > looks like an error in error handling path (notice -28 (ENOSPC) bef=
ore)
> >=20
> > thanks for the report, Alex
> >=20
> > Dmitriy Monakhov wrote:
> > > )
> > >=20
> > > Simple test failed on ext4 when delayed allocation was used.
> > > #mkfs.ext3 -b4096 /dev/vzvg/test2
> > > #mount -text4dev /dev/vzvg/test2  /mnt/test -odelalloc
> > > #fsstress -d /mnt/test/ -l100  -n100000 -p20  -f dwrite=3D0
> > >=20
> > > <CONSOLE LOG>
> > > EXT4-fs: writeback error =3D -28
> > > ......
> > > EXT4-fs: writeback error =3D -28
> > > Unable to handle kernel NULL pointer dereference at 0000000000000=
000 RIP:=20
> > >  [<ffffffff802a12d2>] block_read_full_page+0xab/0x25f
> > > PGD 44c1067 PUD 44fd067 PMD 0=20
> > > Oops: 0000 [2] SMP=20
> > > CPU 0=20
> > > Modules linked in: ext4dev jbd2
> > > Pid: 4833, comm: fsstress Not tainted 2.6.22-rc4-mm2 #9
> > > RIP: 0010:[<ffffffff802a12d2>]  [<ffffffff802a12d2>] block_read_f=
ull_page+0xab/0x25f
> > > RSP: 0018:ffff810004df9a58  EFLAGS: 00010203
> > > RAX: 0000000000001000 RBX: ffff8100cf4256f8 RCX: 000000000000000c
> > >=20
> > > RDX: 0000000000000001 RSI: 000000000000000c RDI: ffff8100cf4256f8
> > > RBP: 0000000000000000 R08: ffff810004df9be8 R09: ffff810004df9c58
> > > R10: 8888888888888888 R11: 8888888888888888 R12: 0000000000000052
> > > R13: 0000000000001000 R14: 0000000000000000 R15: 00000000000000d3
> > > FS:  00002adfe3f7d6f0(0000) GS:ffffffff80730000(0000) knlGS:00000=
00000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > > CR2: 0000000000000000 CR3: 0000000004362000 CR4: 00000000000006e0
> > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > > Process fsstress (pid: 4833, threadinfo ffff810004df8000, task ff=
ff810004c867a0)
> > > Stack:  ffffffff880180f2 ffff8100054a23f0 0000000000000000 000000=
0000000000
> > >  ffff810005dcbb80 ffff81000549bf00 0000000000000000 ffff810005def=
8b0
> > >  ffffffff88029e60 ffffffff8025b2be ffff8100054da540 ffff8100cf496=
fb0
> > > Call Trace:
> > >  [<ffffffff880180f2>] :ext4dev:ext4_get_block+0x0/0x109
> > >  [<ffffffff8025b2be>] find_get_page+0x21/0x51
> > >  [<ffffffff802a5b45>] do_mpage_readpage+0x45f/0x480
> > >  [<ffffffff880180f2>] :ext4dev:ext4_get_block+0x0/0x109
> > >  [<ffffffff88003d64>] :jbd2:jbd2_journal_dirty_metadata+0x197/0x1=
be
> > >  [<ffffffff80245f3b>] bit_waitqueue+0x1c/0x99
> > >  [<ffffffff802a5bb4>] mpage_readpage+0x4e/0x67
> > >  [<ffffffff880180f2>] :ext4dev:ext4_get_block+0x0/0x109
> > >  [<ffffffff8028817e>] do_lookup+0x63/0x1ae
> > >  [<ffffffff8025b1ae>] file_read_actor+0x8d/0xf6
> > >  [<ffffffff8025b2be>] find_get_page+0x21/0x51
> > >  [<ffffffff8025b93a>] do_generic_mapping_read+0x23c/0x3da
> > >  [<ffffffff8025b121>] file_read_actor+0x0/0xf6
> > >  [<ffffffff8025d123>] generic_file_aio_read+0x119/0x156
> > >  [<ffffffff80281848>] do_sync_read+0xc9/0x10c
> > >=20
> > >  [<ffffffff802845b2>] cp_new_stat+0xe5/0xfd
> > >  [<ffffffff80246007>] autoremove_wake_function+0x0/0x2e
> > >  [<ffffffff80281fba>] vfs_read+0xaa/0x132
> > >  [<ffffffff80282356>] sys_read+0x45/0x6e
> > >  [<ffffffff8020b41e>] system_call+0x7e/0x83
> > > Code: 8b 45 00 a8 01 0f 85 e6 00 00 00 8b 45 00 a8 20 0f 85 c9 00=
=20
> > > <CONSOLE LOG>
> > >=20
> > > I've digged this a litle bit with folowig results:
> > >=20
> > > int block_read_full_page(struct page *page, get_block_t *get_bloc=
k)
> > > {
> > > ...
> > > 1914:	if (!page_has_buffers(page)) <<< page_has_buffers(page) =3D=
=3D true=20
> > > 		create_empty_buffers(page, blocksize, 0);
> > > 	head =3D page_buffers(page); <<<<  page_buffers(page) =3D=3D NUL=
L =20
> > > <<<i've add debug info here:
> > > <<< page->flags =3D=3D 100000000000821
> > > <<< PagePrivate(page) =3D=3D 1, (page)->private =3D=3D NULL
> > > <<< So we have private page without buffers, it is WRONG.
> > >=20
> > > 	iblock =3D (sector_t)page->index << (PAGE_CACHE_SHIFT - inode->i=
_blkbits);
> > > 	lblock =3D (i_size_read(inode)+blocksize-1) >> inode->i_blkbits;
> > > 	bh =3D head;
> > > 	nr =3D 0;
> > > 	i =3D 0;
> > >=20
> > > 	do {
> > > 		if (buffer_uptodate(bh)) << Null pointer deref here result in o=
ops
> > > .......
> > > }
> > >=20
> > > -
> > > To unsubscribe from this list: send the line "unsubscribe linux-e=
xt4" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.htm=
l
> >=20
> >=20
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
