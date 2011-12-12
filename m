From: Paul Mackerras <paulus@samba.org>
Subject: Re: Crash in __brelse with recent kernels copying sparse file
Date: Mon, 12 Dec 2011 17:04:52 +1100
Message-ID: <20111212060452.GA23428@drongo>
References: <20111211232951.GA5380@bloggs.ozlabs.ibm.com>
 <20111212024359.GB12433@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:47469 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486Ab1LLGFA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Dec 2011 01:05:00 -0500
Content-Disposition: inline
In-Reply-To: <20111212024359.GB12433@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 11, 2011 at 09:43:59PM -0500, Ted Ts'o wrote:
> Hmm, can you try this patch, and see if it triggers?
> 
> I've removed all of the static declarations so that the stack trace
> will hopefully be more accurate.  (I don't know if you have a reliable
> way to map hex addresses to line numbers on PowerPC, but it's
> critically important to do that given the huge number of static
> functions that generally get inlined, making the stack trace hard to
> decipher if you can't get the line numbers.)

Yes, it triggers:

EXT4-fs (sda8): ext4_ext_find_extent: inode 264547, depth 257 > path->p_depth 1
------------[ cut here ]------------
kernel BUG at /home/paulus/kernel/kvm-merge/fs/ext4/extents.c:645!
cpu 0x1: Vector: 700 (Program Check) at [c000001bc8772dd0]
    pc: c0000000002df3d4: .ext4_ext_find_extent+0x3d4/0x3e0
    lr: c0000000002df3d0: .ext4_ext_find_extent+0x3d0/0x3e0
    sp: c000001bc8773050
   msr: 9000000000029032
  current = 0xc000001bcc4b3b10
  paca    = 0xc00000000ffe0380
    pid   = 4211, comm = flush-8:0
kernel BUG at /home/paulus/kernel/kvm-merge/fs/ext4/extents.c:645!
enter ? for help
[c000001bc8773130] c0000000002e0324 .ext4_ext_create_new_leaf+0x144/0x230
[c000001bc87731e0] c0000000002e16ec .ext4_ext_insert_extent+0x15c/0x5a0
[c000001bc87732b0] c0000000002e5b78 .ext4_ext_map_blocks+0x5b8/0xea0
[c000001bc8773420] c0000000002b2974 .ext4_map_blocks+0x224/0x310
[c000001bc87734d0] c0000000002b7f2c .mpage_da_map_and_submit+0xbc/0x490
[c000001bc87735a0] c0000000002b8688 .write_cache_pages_da+0x2c8/0x430
[c000001bc8773720] c0000000002b8b28 .ext4_da_writepages+0x338/0x670
[c000001bc87738d0] c000000000157280 .do_writepages+0x40/0x90
[c000001bc8773940] c0000000001ea830 .writeback_single_inode+0xe0/0x530
[c000001bc8773a00] c0000000001eb680 .writeback_sb_inodes+0x210/0x300
[c000001bc8773b20] c0000000001ebc84 .__writeback_inodes_wb+0xd4/0x140
[c000001bc8773be0] c0000000001ebfec .wb_writeback+0x2fc/0x3e0
[c000001bc8773ce0] c0000000001ed55c .wb_do_writeback+0xdc/0x300
[c000001bc8773df0] c0000000001ed848 .bdi_writeback_thread+0xc8/0x340
[c000001bc8773ed0] c0000000000c5494 .kthread+0xb4/0xc0
[c000001bc8773f90] c000000000021f48 .kernel_thread+0x54/0x70

I'll try to dig out some line numbers for you.

Paul.
