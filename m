From: Dmitriy Monakhov <dmonakhov@sw.ru>
Subject: delayed allocatiou result in Oops
Date: Thu, 14 Jun 2007 11:23:52 +0400
Message-ID: <20070614072352.GA6517@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:26506 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbXFNHXR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Jun 2007 03:23:17 -0400
Received: from sw.ru ([192.168.3.106])
	by relay.sw.ru (8.13.4/8.13.4) with SMTP id l5E7NDKl000373
	for <linux-ext4@vger.kernel.org>; Thu, 14 Jun 2007 11:23:14 +0400 (MSD)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Simple test failed on ext4 when delayed allocation was used.
#mkfs.ext3 -b4096 /dev/vzvg/test2
#mount -text4dev /dev/vzvg/test2  /mnt/test -odelalloc
#fsstress -d /mnt/test/ -l100  -n100000 -p20  -f dwrite=0

<CONSOLE LOG>
EXT4-fs: writeback error = -28
......
EXT4-fs: writeback error = -28
Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP: 
 [<ffffffff802a12d2>] block_read_full_page+0xab/0x25f
PGD 44c1067 PUD 44fd067 PMD 0 
Oops: 0000 [2] SMP 
CPU 0 
Modules linked in: ext4dev jbd2
Pid: 4833, comm: fsstress Not tainted 2.6.22-rc4-mm2 #9
RIP: 0010:[<ffffffff802a12d2>]  [<ffffffff802a12d2>] block_read_full_page+0xab/0x25f
RSP: 0018:ffff810004df9a58  EFLAGS: 00010203
RAX: 0000000000001000 RBX: ffff8100cf4256f8 RCX: 000000000000000c

RDX: 0000000000000001 RSI: 000000000000000c RDI: ffff8100cf4256f8
RBP: 0000000000000000 R08: ffff810004df9be8 R09: ffff810004df9c58
R10: 8888888888888888 R11: 8888888888888888 R12: 0000000000000052
R13: 0000000000001000 R14: 0000000000000000 R15: 00000000000000d3
FS:  00002adfe3f7d6f0(0000) GS:ffffffff80730000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000004362000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process fsstress (pid: 4833, threadinfo ffff810004df8000, task ffff810004c867a0)
Stack:  ffffffff880180f2 ffff8100054a23f0 0000000000000000 0000000000000000
 ffff810005dcbb80 ffff81000549bf00 0000000000000000 ffff810005def8b0
 ffffffff88029e60 ffffffff8025b2be ffff8100054da540 ffff8100cf496fb0
Call Trace:
 [<ffffffff880180f2>] :ext4dev:ext4_get_block+0x0/0x109
 [<ffffffff8025b2be>] find_get_page+0x21/0x51
 [<ffffffff802a5b45>] do_mpage_readpage+0x45f/0x480
 [<ffffffff880180f2>] :ext4dev:ext4_get_block+0x0/0x109
 [<ffffffff88003d64>] :jbd2:jbd2_journal_dirty_metadata+0x197/0x1be
 [<ffffffff80245f3b>] bit_waitqueue+0x1c/0x99
 [<ffffffff802a5bb4>] mpage_readpage+0x4e/0x67
 [<ffffffff880180f2>] :ext4dev:ext4_get_block+0x0/0x109
 [<ffffffff8028817e>] do_lookup+0x63/0x1ae
 [<ffffffff8025b1ae>] file_read_actor+0x8d/0xf6
 [<ffffffff8025b2be>] find_get_page+0x21/0x51
 [<ffffffff8025b93a>] do_generic_mapping_read+0x23c/0x3da
 [<ffffffff8025b121>] file_read_actor+0x0/0xf6
 [<ffffffff8025d123>] generic_file_aio_read+0x119/0x156
 [<ffffffff80281848>] do_sync_read+0xc9/0x10c

 [<ffffffff802845b2>] cp_new_stat+0xe5/0xfd
 [<ffffffff80246007>] autoremove_wake_function+0x0/0x2e
 [<ffffffff80281fba>] vfs_read+0xaa/0x132
 [<ffffffff80282356>] sys_read+0x45/0x6e
 [<ffffffff8020b41e>] system_call+0x7e/0x83
Code: 8b 45 00 a8 01 0f 85 e6 00 00 00 8b 45 00 a8 20 0f 85 c9 00 
<CONSOLE LOG>

I've digged this a litle bit with folowig results:

int block_read_full_page(struct page *page, get_block_t *get_block)
{
...
1914:	if (!page_has_buffers(page)) <<< page_has_buffers(page) == true 
		create_empty_buffers(page, blocksize, 0);
	head = page_buffers(page); <<<<  page_buffers(page) == NULL  
<<<i've add debug info here:
<<< page->flags == 100000000000821
<<< PagePrivate(page) == 1, (page)->private == NULL
<<< So we have private page without buffers, it is WRONG.

	iblock = (sector_t)page->index << (PAGE_CACHE_SHIFT - inode->i_blkbits);
	lblock = (i_size_read(inode)+blocksize-1) >> inode->i_blkbits;
	bh = head;
	nr = 0;
	i = 0;

	do {
		if (buffer_uptodate(bh)) << Null pointer deref here result in oops
.......
}
