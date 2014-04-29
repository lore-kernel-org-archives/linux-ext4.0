From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 1/2] libext2fs: fix alloc_allocate_group_table() if the
 flexbg_offset wraps
Date: Tue, 29 Apr 2014 13:02:07 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1404291259500.2183@localhost.localdomain>
References: <1398694179-18027-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932384AbaD2LCM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Apr 2014 07:02:12 -0400
In-Reply-To: <1398694179-18027-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 28 Apr 2014, Theodore Ts'o wrote:

> Date: Mon, 28 Apr 2014 10:09:38 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Ext4 Developers List <linux-ext4@vger.kernel.org>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Subject: [PATCH 1/2] libext2fs: fix alloc_allocate_group_table() if the
>     flexbg_offset wraps
> 
> If the previous block group's inode table ends at the very end of file
> system, wrap around to the beginning of the flex_bg.
> 
> This fixes a bug was tickled by:
> 
> mke2fs.conf:
> 	frontload = {
> 		features = extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,^resize_inode,sparse_super2
> 		hash_alg = half_md4
> 		num_backup_sb = 0
> 		packed_meta_blocks = 1
> 		inode_ratio = 4194304
> 		flex_bg_size = 262144
> 	}
> 
> mke2fs -T frontload /tmp/foo.img 2T
> resize2fs -M /tmp/foo.img
> resize2fs -M /tmp/foo.img
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  lib/ext2fs/alloc_tables.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/ext2fs/alloc_tables.c b/lib/ext2fs/alloc_tables.c
> index fec9003..bc99943 100644
> --- a/lib/ext2fs/alloc_tables.c
> +++ b/lib/ext2fs/alloc_tables.c
> @@ -54,8 +54,8 @@ static blk64_t flexbg_offset(ext2_filsys fs, dgrp_t group, blk64_t start_blk,
>  	 * Don't do a long search if the previous block
>  	 * search is still valid.
>  	 */
> -	if (start_blk && ext2fs_test_block_bitmap_range2(bmap, start_blk,
> -							 elem_size))
> +	if (start_blk && start_blk < ext2fs_blocks_count(fs->super) &&
> +	    ext2fs_test_block_bitmap_range2(bmap, start_blk, elem_size))
>  		return start_blk;

Not sure about this, but I just wonder whether this would work with
bigalloc file system as well since it is true that we're testing
blocks in this condition but in ext2fs_test_block_bitmap_range2()
we're searching for a free cluster.

-Lukas

>  
>  	start_blk = ext2fs_group_first_block2(fs, flexbg_size * flexbg);
> 
