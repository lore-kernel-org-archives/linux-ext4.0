From: Benjamin LaHaise <bcrl@kvack.org>
Subject: ext4: first write to large ext3 filesystem takes 96 seconds
Date: Mon, 7 Jul 2014 17:13:49 -0400
Message-ID: <20140707211349.GA12478@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kanga.kvack.org ([205.233.56.17]:47246 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbaGGVNu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Jul 2014 17:13:50 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi folks,

I've just ran into a bug with the ext4 codebase in 3.4.91 that doesn't seem 
to exist in ext3, and was wondering if anyone has encountered this before.  
I have a 7.4TB ext3 filesystem that has been filled with 1.8TB of data.  
When this filesystem is freshly mounted, the first write to the filesystem 
takes a whopping 96 seconds to complete, during which time the system is 
reading about 1000 blocks per second.  Subsequent writes are much quicker.  
The problem seems to be that ext4 is loading all of the bitmaps on the 
filesystem before the first write proceeds.  The backtrace looks roughly as 
follows:

[ 4480.921288]  [<ffffffff81437472>] ? dm_request_fn+0x112/0x1c0
[ 4480.921292]  [<ffffffff81244bf5>] ? __blk_run_queue+0x15/0x20
[ 4480.921294]  [<ffffffff81246670>] ? queue_unplugged+0x20/0x50
[ 4480.921297]  [<ffffffff8154ed05>] schedule+0x45/0x60
[ 4480.921299]  [<ffffffff8154ef7c>] io_schedule+0x6c/0xb0
[ 4480.921301]  [<ffffffff810fb7a9>] sleep_on_buffer+0x9/0x10
[ 4480.921303]  [<ffffffff8154d435>] __wait_on_bit+0x55/0x80
[ 4480.921306]  [<ffffffff810fb7a0>] ? unmap_underlying_metadata+0x40/0x40
[ 4480.921308]  [<ffffffff810fb7a0>] ? unmap_underlying_metadata+0x40/0x40
[ 4480.921310]  [<ffffffff8154d4d8>] out_of_line_wait_on_bit+0x78/0x90
[ 4480.921312]  [<ffffffff8104d5b0>] ? autoremove_wake_function+0x40/0x40
[ 4480.921315]  [<ffffffff810fb756>] __wait_on_buffer+0x26/0x30
[ 4480.921318]  [<ffffffff81146258>] ext4_wait_block_bitmap+0x138/0x190
[ 4480.921321]  [<ffffffff8116c816>] ext4_mb_init_cache+0x1e6/0x5f0
[ 4480.921324]  [<ffffffff8109654a>] ? add_to_page_cache_locked+0x9a/0xd0
[ 4480.921327]  [<ffffffff810965b1>] ? add_to_page_cache_lru+0x31/0x50
[ 4480.921330]  [<ffffffff8116cd1f>] ext4_mb_init_group+0xff/0x1e0
[ 4480.921332]  [<ffffffff8116ce9f>] ext4_mb_good_group+0x9f/0x130
[ 4480.921334]  [<ffffffff8116e41f>] ext4_mb_regular_allocator+0x1bf/0x3d0
[ 4480.921337]  [<ffffffff8116c0ac>] ? ext4_mb_normalize_request+0x26c/0x4d0
[ 4480.921339]  [<ffffffff811716ce>] ext4_mb_new_blocks+0x2ee/0x490
[ 4480.921342]  [<ffffffff81174c11>] ? ext4_get_branch+0x101/0x130
[ 4480.921345]  [<ffffffff8117639c>] ext4_ind_map_blocks+0x9bc/0xc10
[ 4480.921347]  [<ffffffff810fae11>] ? __getblk+0x21/0x2b0
[ 4480.921350]  [<ffffffff8114c9a3>] ext4_map_blocks+0x293/0x390
[ 4480.921353]  [<ffffffff8117a462>] ? do_get_write_access+0x1d2/0x450
[ 4480.921355]  [<ffffffff810cb0b4>] ? kmem_cache_alloc+0xa4/0xc0
[ 4480.921358]  [<ffffffff8114d9e9>] _ext4_get_block+0xa9/0x140
[ 4480.921360]  [<ffffffff8114dab1>] ext4_get_block+0x11/0x20
[ 4480.921362]  [<ffffffff810fbda5>] __block_write_begin+0x2b5/0x470
[ 4480.921365]  [<ffffffff8114daa0>] ? noalloc_get_block_write+0x20/0x20
[ 4480.921368]  [<ffffffff81096679>] ? grab_cache_page_write_begin+0xa9/0x100
[ 4480.921370]  [<ffffffff8114c1e2>] ext4_write_begin+0x132/0x2f0
[ 4480.921373]  [<ffffffff81095869>] generic_file_buffered_write+0x119/0x260
[ 4480.921376]  [<ffffffff81096eef>] __generic_file_aio_write+0x27f/0x430
[ 4480.921379]  [<ffffffff810cfbba>] ? do_huge_pmd_anonymous_page+0x1ea/0x2d0
[ 4480.921382]  [<ffffffff81097101>] generic_file_aio_write+0x61/0xc0
[ 4480.921384]  [<ffffffff81147c18>] ext4_file_write+0x68/0x2a0
[ 4480.921387]  [<ffffffff8154e723>] ? __schedule+0x2c3/0x800
[ 4480.921389]  [<ffffffff810d2a41>] do_sync_write+0xe1/0x120
[ 4480.921392]  [<ffffffff8154eefa>] ? _cond_resched+0x2a/0x40
[ 4480.921395]  [<ffffffff810d31c9>] vfs_write+0xc9/0x170
[ 4480.921397]  [<ffffffff810d3910>] sys_write+0x50/0x90
[ 4480.921400]  [<ffffffff8155155f>] sysenter_dispatch+0x7/0x1a

Any thoughts?  Have there been any changes to this area of the ext4 code?

		-ben
-- 
"Thought is the essence of where you are now."
