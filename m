From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: EXT4: kernel BUG at fs/ext4/mballoc.c:1721!
Date: Thu, 3 Sep 2009 16:50:03 +0530
Message-ID: <20090903112003.GA13105@skywalker.linux.vnet.ibm.com>
References: <4A9F7B48.9010903@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>
To: Sachin Sant <sachinp@in.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:44389 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbZICLUN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Sep 2009 07:20:13 -0400
Received: from d23relay05.au.ibm.com (d23relay05.au.ibm.com [202.81.31.247])
	by e23smtp04.au.ibm.com (8.14.3/8.13.1) with ESMTP id n83BHReM005183
	for <linux-ext4@vger.kernel.org>; Thu, 3 Sep 2009 21:17:27 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay05.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n83BIUj11585310
	for <linux-ext4@vger.kernel.org>; Thu, 3 Sep 2009 21:18:30 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n83BKDnU016279
	for <linux-ext4@vger.kernel.org>; Thu, 3 Sep 2009 21:20:14 +1000
Content-Disposition: inline
In-Reply-To: <4A9F7B48.9010903@in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 03, 2009 at 01:46:08PM +0530, Sachin Sant wrote:
> While executing FS resize test against ext4 on a 4-way
> POWER6 box with 2.6.31-rc8 kernel ran into following bug.
>
> ------------[ cut here ]------------
> cpu 0x2: Vector: 700 (Program Check) at [c0000000f963ece0]
>    pc: c000000000264d80: .ext4_mb_good_group+0x54/0x15c
>    lr: c00000000026c9b0: .ext4_mb_regular_allocator+0x278/0x44c
>    sp: c0000000f963ef60
>   msr: 8000000000029032
>  current = 0xc000000047b635a0
>  paca    = 0xc000000000b62a00
>    pid   = 32202, comm = dd
> kernel BUG at fs/ext4/mballoc.c:1721!
> enter ? for help
> [link register   ] c00000000026c9b0 .ext4_mb_regular_allocator+0x278/0x44c
> [c0000000f963ef60] c00000000026c99c .ext4_mb_regular_allocator+0x264/0x44c
> (unreliable)
> [c0000000f963f090] c00000000026cde0 .ext4_mb_new_blocks+0x25c/0x5b0
> [c0000000f963f170] c000000000263260 .ext4_ext_get_blocks+0xd18/0xf2c
> [c0000000f963f2f0] c0000000002404a8 .ext4_get_blocks+0x1b8/0x438
> [c0000000f963f3c0] c000000000241d8c .ext4_get_block+0xe8/0x15c
> [c0000000f963f480] c00000000018e1c0 .__block_prepare_write+0x210/0x4b0
> [c0000000f963f5c0] c00000000018e698 .block_write_begin+0xa8/0x13c
> [c0000000f963f680] c000000000243be4 .ext4_write_begin+0x198/0x324
> [c0000000f963f790] c000000000112e50 .generic_file_buffered_write+0x140/0x37c
> [c0000000f963f8d0] c00000000011364c
> .__generic_file_aio_write_nolock+0x37c/0x3e0
> [c0000000f963f9d0] c0000000001140e0 .generic_file_aio_write+0x88/0x120
> [c0000000f963fa90] c000000000239250 .ext4_file_write+0xe4/0x1a4
> [c0000000f963fb40] c00000000015e1f4 .do_sync_write+0xcc/0x130
> [c0000000f963fce0] c00000000015ef44 .vfs_write+0xd0/0x1dc
> [c0000000f963fd80] c00000000015f158 .SyS_write+0x58/0xa0
> [c0000000f963fe30] c000000000008534 syscall_exit+0x0/0x40
> --- Exception: c01 (System Call) at 00000fff8fd1a8f8
> SP (fffc6270e00) is in userspace
>
> During the first 3 runs i did not see this issue, so might
> not be able to recreate this again. I have captured the dmesg
> log and have attached it.
>
> ext4 fs was created and mounted using :
>
> mkfs.ext4 -b 1024 /dev/sda4 3943948
> mount  -t ext4 -o errors=panic,data=journal /dev/sda4 /mnt/tmp/
>
> The corresponding c code is :
>
> 1718         struct ext4_group_info *grp = ext4_get_group_info(ac->ac_sb,
> group);
> 1719 1720         BUG_ON(cr < 0 || cr >= 4);
> 1721         BUG_ON(EXT4_MB_GRP_NEED_INIT(grp));
> 1722    ^^^^^^^^^^^^^^^^^^^^
> 1723         free = grp->bb_free;
>
> Thanks
> -Sachin

Can you try this patch ?

commit 43149bc800a6ae88b7d984558403e8d8cb045138
Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date:   Thu Sep 3 16:47:27 2009 +0530

    ext4: check for good group with alloc_sem held
    
    We need to make sure we check for good group with alloc_sem
    held to make sure we prevent a parallel addition of new blocks
    to the group via resize.
    
    Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index cd25846..4623555 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2029,13 +2029,6 @@ repeat:
 					goto out;
 			}
 
-			/*
-			 * If the particular group doesn't satisfy our
-			 * criteria we continue with the next group
-			 */
-			if (!ext4_mb_good_group(ac, group, cr))
-				continue;
