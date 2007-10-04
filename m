From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: update uninitialized-block-groups.patch and mballoc-core.patch
Date: Wed, 03 Oct 2007 17:44:48 -0700
Message-ID: <1191458688.3810.7.camel@localhost.localdomain>
References: <47036832.7030107@linux.vnet.ibm.com>
	 <20071003183718.GM5578@schatzie.adilger.int>
	 <4703E5B1.7090903@linux.vnet.ibm.com> <4703E7B0.7060900@linux.vnet.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>,
	Avantika Mathur <mathur@linux.vnet.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:53363 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbXJDApH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Oct 2007 20:45:07 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l940j6uh031858
	for <linux-ext4@vger.kernel.org>; Wed, 3 Oct 2007 20:45:06 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l940j6fk546638
	for <linux-ext4@vger.kernel.org>; Wed, 3 Oct 2007 20:45:06 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l940j0AZ011565
	for <linux-ext4@vger.kernel.org>; Wed, 3 Oct 2007 20:45:01 -0400
In-Reply-To: <4703E7B0.7060900@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Updated ext4 patch queue with your updated uninit blk group and mballoc
patch.

Mingming

On Thu, 2007-10-04 at 00:34 +0530, Aneesh Kumar K.V wrote:
> 
> Aneesh Kumar K.V wrote:
> > 
> > 
> > Andreas Dilger wrote:
> >> On Oct 03, 2007  15:30 +0530, Aneesh Kumar K.V wrote:
> >>> +    if (block_group == sbi->s_gdb_count - 1) {
> >>> +        /*
> >>> +         * Even though mke2fs always initialize first and last group
> >>> +         * if some other tool enabled the EXT4_BG_BLOCK_UNINIT we need
> >>> +         * to make sure we calculate the right free blocks
> >>> +         */
> >>> +        free_blocks = ext4_blocks_count(sbi->s_es) -
> >>> +                le32_to_cpu(sbi->s_es->s_first_data_block) -
> >>> +                (EXT4_BLOCKS_PER_GROUP(sb) * sbi->s_groups_count) -
> >>> +                bit_max;
> >>
> >> Did you verify that subtracting s_first_data_block is indeed the right
> >> thing to do.  I _think_ yes, but I didn't look at it very closely when
> >> I wrote it late last night.
> >>
> > 
> > yes s_first_data_block is always decremented to find total number of 
> > blocks occupied by the reset of the group. But now looking at it again i 
> > guess i need to have
> 
> 
> 
> 
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index 8613914..34b1e11 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -50,7 +50,7 @@ unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
>  {
>  	unsigned long start;
>  	int bit, bit_max;
> -	unsigned free_blocks;
> +	unsigned free_blocks, group_blocks;
>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
> 
>  	if (bh) {
> @@ -96,14 +96,15 @@ unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
>  		 * if some other tool enabled the EXT4_BG_BLOCK_UNINIT we need
>  		 * to make sure we calculate the right free blocks
>  		 */
> -		free_blocks = ext4_blocks_count(sbi->s_es) -
> -				le32_to_cpu(sbi->s_es->s_first_data_block) -
> -				(EXT4_BLOCKS_PER_GROUP(sb) * sbi->s_groups_count) -
> -				bit_max;
> +		group_blocks = ext4_blocks_count(sbi->s_es) -
> +			le32_to_cpu(sbi->s_es->s_first_data_block) -
> +			(EXT4_BLOCKS_PER_GROUP(sb) * (sbi->s_groups_count -1));
>  	} else {
> -		free_blocks = EXT4_BLOCKS_PER_GROUP(sb) - bit_max;
> +		group_blocks = EXT4_BLOCKS_PER_GROUP(sb);
>  	}
> 
> +	free_blocks = group_blocks - bit_max;
> +
>  	if (bh) {
>  		for (bit = 0; bit < bit_max; bit++)
>  			ext4_set_bit(bit, bh->b_data);
> @@ -123,8 +124,7 @@ unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
>  		 * blocksize * 8 ( which is the size of bitmap ), set rest of the
>  		 * block bitmap to 1
>  		 */
> -		mark_bitmap_end(EXT4_BLOCKS_PER_GROUP(sb),
> -					sb->s_blocksize * 8, bh->b_data);
> +		mark_bitmap_end(group_blocks, sb->s_blocksize * 8, bh->b_data);
>  	}
> 
>  	return free_blocks - sbi->s_itb_per_group - 2;
