From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 1/4] ext4: use ext4_group_first_block_no()
Date: Tue, 19 Feb 2008 00:18:22 -0800
Message-ID: <1203409102.3612.30.camel@localhost.localdomain>
References: <20080217060839.GH3390@APFDCB5C>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Stephen Tweedie <sct@redhat.com>, adilger@clusterfs.com,
	Theodore Tso <tytso@MIT.EDU>
To: Akinobu Mita <akinobu.mita@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:51405 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbYBSIS3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Feb 2008 03:18:29 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1J8IRu7005435
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2008 03:18:27 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1J8IROb255328
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2008 03:18:27 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1J8IQU8028135
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2008 03:18:27 -0500
In-Reply-To: <20080217060839.GH3390@APFDCB5C>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 2008-02-17 at 15:08 +0900, Akinobu Mita wrote:
> Use ext4_group_first_block_no() and assign the return values to
> ext2_fsblk_t variables.
> 
Acked for ext2/3/4 patches(except a little typo in above change log:
ext4_fsblk_t). ext4 patch is queued in ext4 patch queue
http://repo.or.cz/w/ext4-patch-queue.git

Mingming

> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Stephen Tweedie <sct@redhat.com>
> Cc: adilger@clusterfs.com
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Mingming Cao <cmm@us.ibm.com>
> Cc: Theodore Tso <tytso@MIT.EDU>
> ---
>  fs/ext4/balloc.c |    6 +++---
>  fs/ext4/xattr.c  |    6 ++----
>  2 files changed, 5 insertions(+), 7 deletions(-)
> 
> Index: 2.6-rc/fs/ext4/xattr.c
> ===================================================================
> --- 2.6-rc.orig/fs/ext4/xattr.c
> +++ 2.6-rc/fs/ext4/xattr.c
> @@ -808,10 +808,8 @@ inserted:
>  			get_bh(new_bh);
>  		} else {
>  			/* We need to allocate a new block */
> -			ext4_fsblk_t goal = le32_to_cpu(
> -					EXT4_SB(sb)->s_es->s_first_data_block) +
> -				(ext4_fsblk_t)EXT4_I(inode)->i_block_group *
> -				EXT4_BLOCKS_PER_GROUP(sb);
> +			ext4_fsblk_t goal = ext4_group_first_block_no(sb,
> +						EXT4_I(inode)->i_block_group);
>  			ext4_fsblk_t block = ext4_new_block(handle, inode,
>  							goal, &error);
>  			if (error)
> Index: 2.6-rc/fs/ext4/balloc.c
> ===================================================================
> --- 2.6-rc.orig/fs/ext4/balloc.c
> +++ 2.6-rc/fs/ext4/balloc.c
> @@ -48,7 +48,6 @@ void ext4_get_group_no_and_offset(struct
>  unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
>  		 ext4_group_t block_group, struct ext4_group_desc *gdp)
>  {
> -	unsigned long start;
>  	int bit, bit_max;
>  	unsigned free_blocks, group_blocks;
>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
> @@ -106,11 +105,12 @@ unsigned ext4_init_block_bitmap(struct s
>  	free_blocks = group_blocks - bit_max;
> 
>  	if (bh) {
> +		ext4_fsblk_t start;
> +
>  		for (bit = 0; bit < bit_max; bit++)
>  			ext4_set_bit(bit, bh->b_data);
> 
> -		start = block_group * EXT4_BLOCKS_PER_GROUP(sb) +
> -			le32_to_cpu(sbi->s_es->s_first_data_block);
> +		start = ext4_group_first_block_no(sb, block_group);
> 
>  		/* Set bits for block and inode bitmaps, and inode table */
>  		ext4_set_bit(ext4_block_bitmap(sb, gdp) - start, bh->b_data);
