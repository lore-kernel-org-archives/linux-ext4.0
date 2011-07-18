From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 08/12] ext4: let setup_new_group_blocks set multi-bits each time
Date: Mon, 18 Jul 2011 00:26:13 -0600
Message-ID: <3539826A-0FB0-4995-8588-1E6D45359FA3@dilger.ca>
References: <1310957555-15617-1-git-send-email-xiaoqiangnk@gmail.com> <1310957555-15617-9-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:20213 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab1GRG0Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Jul 2011 02:26:16 -0400
In-Reply-To: <1310957555-15617-9-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-07-17, at 8:52 PM, Yongqiang Yang wrote:
> This patch adds a function - ext4_set_btis() which can set multi-bits
> each time, and lets setup_new_group_blocks() use ext4_set_bits().
> 
> 
> +void ext4_set_bits(void *bm, int cur, int len)
> +{
> +	mb_set_bits(bm, cur, len);
> +}

Why not just rename mb_set_bits() to ext4_set_bits()?  That could be done
in one patch to avoid complexity.

> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
> index 4089642..c91653c 100644
> --- a/fs/ext4/resize.c
> +++ b/fs/ext4/resize.c
> @@ -227,11 +227,6 @@ static int setup_new_group_blocks(struct super_block *sb,
> 		goto exit_journal;
> 	}
> 
> -	if (ext4_bg_has_super(sb, input->group)) {
> -		ext4_debug("mark backup superblock %#04llx (+0)\n", start);
> -		ext4_set_bit(0, bh->b_data);
> -	}
> -
> 	/* Copy all of the GDT blocks into the backup in this group */
> 	for (i = 0, bit = 1, block = start + 1;
> 	     i < gdblocks; i++, block++, bit++) {
> @@ -260,7 +255,6 @@ static int setup_new_group_blocks(struct super_block *sb,
> 			brelse(gdb);
> 			goto exit_bh;
> 		}
> -		ext4_set_bit(bit, bh->b_data);
> 		brelse(gdb);
> 	}
> 
> @@ -271,8 +265,11 @@ static int setup_new_group_blocks(struct super_block *sb,
> 			       GFP_NOFS);
> 	if (err)
> 		goto exit_bh;
> -	for (i = 0, bit = gdblocks + 1; i < reserved_gdb; i++, bit++)
> -		ext4_set_bit(bit, bh->b_data);
> +
> +	if (ext4_bg_has_super(sb, input->group)) {
> +		ext4_debug("mark backup group tables %#04llx (+0)\n", start);
> +		ext4_set_bits(bh->b_data, 0, gdblocks + reserved_gdb + 1);
> +	}
> 
> 	ext4_debug("mark block bitmap %#04llx (+%llu)\n", input->block_bitmap,
> 		   input->block_bitmap - start);
> @@ -288,9 +285,8 @@ static int setup_new_group_blocks(struct super_block *sb,
> 	err = sb_issue_zeroout(sb, block, sbi->s_itb_per_group, GFP_NOFS);
> 	if (err)
> 		goto exit_bh;
> -	for (i = 0, bit = input->inode_table - start;
> -	     i < sbi->s_itb_per_group; i++, bit++)
> -		ext4_set_bit(bit, bh->b_data);
> +	ext4_set_bits(bh->b_data, input->inode_table - start,
> +		      sbi->s_itb_per_group);
> 
> 	if ((err = extend_or_restart_transaction(handle, 2, bh)))
> 		goto exit_bh;
> -- 
> 1.7.5.1
> 


Cheers, Andreas





