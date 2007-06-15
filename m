From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: delayed allocatiou result in Oops
Date: Fri, 15 Jun 2007 16:16:07 -0700
Message-ID: <1181949368.3808.7.camel@dyn9047017103.beaverton.ibm.com>
References: <20070614072352.GA6517@localhost.sw.ru>
	 <4672202C.4080304@clusterfs.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Dmitriy Monakhov <dmonakhov@sw.ru>, Alex Tomas <alex@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:47724 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757124AbXFOXQZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Jun 2007 19:16:25 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5FNGPVU012066
	for <linux-ext4@vger.kernel.org>; Fri, 15 Jun 2007 19:16:25 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5FNGOsl215254
	for <linux-ext4@vger.kernel.org>; Fri, 15 Jun 2007 17:16:24 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5FNGNg4015530
	for <linux-ext4@vger.kernel.org>; Fri, 15 Jun 2007 17:16:24 -0600
In-Reply-To: <4672202C.4080304@clusterfs.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I hit almost the same issue today also, but with different error #, and
one more kernel oops, when run fsstress on x86_64. 

EXT4-fs: writeback error = -2
EXT4-fs: writeback error = -2

Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP: 
 [<ffffffff8028bbb6>] block_read_full_page+0xb5/0x267
PGD 1f9842067 PUD 1f9843067 PMD 0 
Oops: 0000 [5] SMP 
CPU 3 
Modules linked in:
Pid: 10900, comm: fsstress Not tainted 2.6.22-rc4-autokern1 #1
RIP: 0010:[<ffffffff8028bbb6>]  [<ffffffff8028bbb6>] block_read_full_page+0xb5/0x267
RSP: 0000:ffff8101f984fa48  EFLAGS: 00010213
RAX: 0000000000000179 RBX: 0000000000000000 RCX: 000000000000000c
RDX: 000000000000000c RSI: ffffffff802e0f7b RDI: ffff81017ff578c8
RBP: ffff81017ff578c8 R08: ffff8101f984fbe8 R09: ffff8101f984fbe0
R10: 0000000000000000 R11: 0000000000000000 R12: 00000000000000e5
R13: 0000000000000000 R14: 0000000000001000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8101803ec5c0(0063) knlGS:00000000f7dec460
CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
CR2: 0000000000000000 CR3: 00000001f9841000 CR4: 00000000000006e0
Process fsstress (pid: 10900, threadinfo ffff8101f984e000, task ffff8101f9824280)
Stack:  00001000f9ad4080 0000000100000000 0000000000000000 0000000000000179
 ffff8100de7c4100 ffffffff802e0f7b 000003363e3761bf ffffffff804eac2d
 ffff8101f984fb48 0000000000000082 ffff81017e9bc550 ffff81017e9bc588
Call Trace:
 [<ffffffff802e0f7b>] ext4_get_block+0x0/0x104
 [<ffffffff804eac2d>] thread_return+0x0/0xd5
 [<ffffffff8028fcd6>] do_mpage_readpage+0x411/0x430
 [<ffffffff804eb481>] io_schedule+0x26/0x32
 [<ffffffff804eb6fb>] __wait_on_bit_lock+0x5f/0x6d
 [<ffffffff8028fe7e>] mpage_readpage+0x42/0x5b
 [<ffffffff802e0f7b>] ext4_get_block+0x0/0x104
 [<ffffffff802395eb>] wake_bit_function+0x0/0x23
 [<ffffffff8024a9bd>] file_read_actor+0x89/0xf4
 [<ffffffff8024a21e>] find_get_page+0x1e/0x4d
 [<ffffffff8024a763>] do_generic_mapping_read+0x20e/0x3df
 [<ffffffff8024a934>] file_read_actor+0x0/0xf4
 [<ffffffff8024c2e7>] generic_file_aio_read+0x11d/0x154
 [<ffffffff8026c7ca>] do_sync_read+0xc8/0x10b
 [<ffffffff80272c4f>] permission+0xbb/0xbd
 [<ffffffff802395bd>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8026be62>] nameidata_to_filp+0x25/0x34
 [<ffffffff8026be9e>] do_filp_open+0x2d/0x3d
 [<ffffffff8026f355>] vfs_getattr+0x2b/0x2f
 [<ffffffff8026f43d>] vfs_fstat+0x33/0x3a
 [<ffffffff8026c8b8>] vfs_read+0xab/0x12e
 [<ffffffff8026cbbc>] sys_read+0x45/0x6e
 [<ffffffff80219f02>] ia32_sysret+0x0/0xa


Code: 8b 03 a8 01 0f 85 e1 00 00 00 8b 03 a8 20 0f 85 cc 00 00 00 
RIP  [<ffffffff8028bbb6>] block_read_full_page+0xb5/0x267
 RSP <ffff8101f984fa48>
CR2: 0000000000000000
EXT4-fs: writeback error = -2
EXT4-fs: writeback error = -2
EXT4-fs: writeback error = -2
EXT4-fs: writeback error = -2
EXT4-fs: writeback error = -2
EXT4-fs: writeback error = -2
EXT4-fs: writeback error = -2
EXT4-fs: writeback error = -2
EXT4-fs: writeback error = -2
EXT4-fs: writeback error = -2
EXT4-fs: writeback error = -2
EXT4-fs: writeback error = -2
EXT4-fs: writeback error = -2
EXT4-fs: writeback error = -2
EXT4-fs: writeback error = -2
EXT4-fs: writeback error = -2
EXT4-fs: writeback error = -2
EXT4-fs: writeback error = -2
EXT4-fs: writeback error = -2
EXT4-fs: writeback error = -2
EXT4-fs: writeback error = -2
------------[ cut here ]------------
kernel BUG at fs/ext4/writeback.c:266!
invalid opcode: 0000 [6] SMP 
CPU 3 
Modules linked in:
Pid: 10851, comm: fsstress Not tainted 2.6.22-rc4-autokern1 #1
RIP: 0010:[<ffffffff802ed5f6>]  [<ffffffff802ed5f6>] ext4_wb_submit_extent+0x1ef/0x3d9
RSP: 0000:ffff8101e47cfab8  EFLAGS: 00010246
RAX: 000000000001182c RBX: ffff8100c6709ca0 RCX: 000000000000000c
RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff8101e8de5000
RBP: ffff8100c6709a48 R08: ffff8101b1056338 R09: 0000000000000000
R10: ffff8101b1056338 R11: ffff8100c6709a48 R12: 0000000000000040
R13: ffff81017eaa5b98 R14: 0000000000000040 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff8101803ec5c0(0063) knlGS:00000000f7dec460
CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
CR2: 00000000f7dcb004 CR3: 00000001e47c1000 CR4: 00000000000006e0
Process fsstress (pid: 10851, threadinfo ffff8101e47ce000, task ffff8101e47a6b30)
Stack:  ffff8101cf22c9b8 0000000000000000 0000000000000001 0000000c00000001
 ffff8100c6709a48 000000018028938e ffff8101e47cfb68 0000000000000000
 ffff8101e47cfd28 ffff8100c6709ca0 ffff8100c6709a48 ffff8100c6709990
Call Trace:
 [<ffffffff802edb95>] ext4_wb_handle_extent+0x3b5/0x48c
 [<ffffffff802ebc24>] ext4_ext_walk_space+0x18a/0x20c
 [<ffffffff802ed7e0>] ext4_wb_handle_extent+0x0/0x48c
 [<ffffffff802edcc7>] ext4_wb_flush+0x5b/0x153
 [<ffffffff802ee1a0>] ext4_wb_writepages+0x34b/0x398
 [<ffffffff8024f81b>] do_writepages+0x20/0x2d
 [<ffffffff80286164>] __writeback_single_inode+0x1df/0x3a7
 [<ffffffff8024a47e>] find_get_pages_tag+0x34/0x89
 [<ffffffff80250c66>] pagevec_lookup_tag+0x1a/0x24
 [<ffffffff80249e89>] wait_on_page_writeback_range+0xc7/0x10d
 [<ffffffff80286702>] sync_sb_inodes+0x1cb/0x2a0
 [<ffffffff8028687c>] sync_inodes_sb+0xa5/0xb9
 [<ffffffff803b3e09>] __up_read+0x10/0x8a
 [<ffffffff802868fa>] __sync_inodes+0x6a/0xb1
 [<ffffffff80286952>] sync_inodes+0x11/0x29
 [<ffffffff8028895c>] do_sync+0x2c/0x50
 [<ffffffff8028898b>] sys_sync+0xb/0xf
 [<ffffffff80219f02>] ia32_sysret+0x0/0xa


Code: 0f 0b eb fe f0 41 0f ba 75 00 14 48 8b 4c 24 40 01 51 10 48 
RIP  [<ffffffff802ed5f6>] ext4_wb_submit_extent+0x1ef/0x3d9
 RSP <ffff8101e47cfab8>

I will try the patch below...Alex, any hint about the second oops?

Mingming
Alex please 
On Fri, 2007-06-15 at 09:14 +0400, Alex Tomas wrote:
> looks like an error in error handling path (notice -28 (ENOSPC) before)
> 
> thanks for the report, Alex
> 
> Dmitriy Monakhov wrote:
> > )
> > 
> > Simple test failed on ext4 when delayed allocation was used.
> > #mkfs.ext3 -b4096 /dev/vzvg/test2
> > #mount -text4dev /dev/vzvg/test2  /mnt/test -odelalloc
> > #fsstress -d /mnt/test/ -l100  -n100000 -p20  -f dwrite=0
> > 
> > <CONSOLE LOG>
> > EXT4-fs: writeback error = -28
> > ......
> > EXT4-fs: writeback error = -28
> > Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP: 
> >  [<ffffffff802a12d2>] block_read_full_page+0xab/0x25f
> > PGD 44c1067 PUD 44fd067 PMD 0 
> > Oops: 0000 [2] SMP 
> > CPU 0 
> > Modules linked in: ext4dev jbd2
> > Pid: 4833, comm: fsstress Not tainted 2.6.22-rc4-mm2 #9
> > RIP: 0010:[<ffffffff802a12d2>]  [<ffffffff802a12d2>] block_read_full_page+0xab/0x25f
> > RSP: 0018:ffff810004df9a58  EFLAGS: 00010203
> > RAX: 0000000000001000 RBX: ffff8100cf4256f8 RCX: 000000000000000c
> > 
> > RDX: 0000000000000001 RSI: 000000000000000c RDI: ffff8100cf4256f8
> > RBP: 0000000000000000 R08: ffff810004df9be8 R09: ffff810004df9c58
> > R10: 8888888888888888 R11: 8888888888888888 R12: 0000000000000052
> > R13: 0000000000001000 R14: 0000000000000000 R15: 00000000000000d3
> > FS:  00002adfe3f7d6f0(0000) GS:ffffffff80730000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > CR2: 0000000000000000 CR3: 0000000004362000 CR4: 00000000000006e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > Process fsstress (pid: 4833, threadinfo ffff810004df8000, task ffff810004c867a0)
> > Stack:  ffffffff880180f2 ffff8100054a23f0 0000000000000000 0000000000000000
> >  ffff810005dcbb80 ffff81000549bf00 0000000000000000 ffff810005def8b0
> >  ffffffff88029e60 ffffffff8025b2be ffff8100054da540 ffff8100cf496fb0
> > Call Trace:
> >  [<ffffffff880180f2>] :ext4dev:ext4_get_block+0x0/0x109
> >  [<ffffffff8025b2be>] find_get_page+0x21/0x51
> >  [<ffffffff802a5b45>] do_mpage_readpage+0x45f/0x480
> >  [<ffffffff880180f2>] :ext4dev:ext4_get_block+0x0/0x109
> >  [<ffffffff88003d64>] :jbd2:jbd2_journal_dirty_metadata+0x197/0x1be
> >  [<ffffffff80245f3b>] bit_waitqueue+0x1c/0x99
> >  [<ffffffff802a5bb4>] mpage_readpage+0x4e/0x67
> >  [<ffffffff880180f2>] :ext4dev:ext4_get_block+0x0/0x109
> >  [<ffffffff8028817e>] do_lookup+0x63/0x1ae
> >  [<ffffffff8025b1ae>] file_read_actor+0x8d/0xf6
> >  [<ffffffff8025b2be>] find_get_page+0x21/0x51
> >  [<ffffffff8025b93a>] do_generic_mapping_read+0x23c/0x3da
> >  [<ffffffff8025b121>] file_read_actor+0x0/0xf6
> >  [<ffffffff8025d123>] generic_file_aio_read+0x119/0x156
> >  [<ffffffff80281848>] do_sync_read+0xc9/0x10c
> > 
> >  [<ffffffff802845b2>] cp_new_stat+0xe5/0xfd
> >  [<ffffffff80246007>] autoremove_wake_function+0x0/0x2e
> >  [<ffffffff80281fba>] vfs_read+0xaa/0x132
> >  [<ffffffff80282356>] sys_read+0x45/0x6e
> >  [<ffffffff8020b41e>] system_call+0x7e/0x83
> > Code: 8b 45 00 a8 01 0f 85 e6 00 00 00 8b 45 00 a8 20 0f 85 c9 00 
> > <CONSOLE LOG>
> > 
> > I've digged this a litle bit with folowig results:
> > 
> > int block_read_full_page(struct page *page, get_block_t *get_block)
> > {
> > ...
> > 1914:	if (!page_has_buffers(page)) <<< page_has_buffers(page) == true 
> > 		create_empty_buffers(page, blocksize, 0);
> > 	head = page_buffers(page); <<<<  page_buffers(page) == NULL  
> > <<<i've add debug info here:
> > <<< page->flags == 100000000000821
> > <<< PagePrivate(page) == 1, (page)->private == NULL
> > <<< So we have private page without buffers, it is WRONG.
> > 
> > 	iblock = (sector_t)page->index << (PAGE_CACHE_SHIFT - inode->i_blkbits);
> > 	lblock = (i_size_read(inode)+blocksize-1) >> inode->i_blkbits;
> > 	bh = head;
> > 	nr = 0;
> > 	i = 0;
> > 
> > 	do {
> > 		if (buffer_uptodate(bh)) << Null pointer deref here result in oops
> > .......
> > }
> > 
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
