From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 4/6] Use sb_issue_zeroout in setup_new_group_blocks
Date: Wed, 29 Sep 2010 16:12:16 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1009291608061.25427@dhcp-lab-213.englab.brq.redhat.com>
References: <1284641251-24531-1-git-send-email-lczerner@redhat.com> <1284641251-24531-5-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, rwheeler@redhat.com,
	sandeen@redhat.com, adilger@dilger.ca, snitzer@gmail.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159Ab0I2OMX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Sep 2010 10:12:23 -0400
In-Reply-To: <1284641251-24531-5-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 16 Sep 2010, Lukas Czerner wrote:

> Use sb_issue_zeroout to zero out inode table and descriptor table
> blocks instead of old approach which involves journaling.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  fs/ext4/resize.c |   46 +++++++++++++---------------------------------
>  1 files changed, 13 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
> index ca5c8aa..afba286 100644
> --- a/fs/ext4/resize.c
> +++ b/fs/ext4/resize.c
> @@ -226,23 +226,13 @@ static int setup_new_group_blocks(struct super_block *sb,
>  	}
>  
>  	/* Zero out all of the reserved backup group descriptor table blocks */
> -	for (i = 0, bit = gdblocks + 1, block = start + bit;
> -	     i < reserved_gdb; i++, block++, bit++) {
> -		struct buffer_head *gdb;
> -
> -		ext4_debug("clear reserved block %#04llx (+%d)\n", block, bit);
> -
> -		if ((err = extend_or_restart_transaction(handle, 1, bh)))
> -			goto exit_bh;
> +	ext4_debug("clear inode table blocks %#04llx -> %#04llx\n",
> +			block, sbi->s_itb_per_group);
> +	err = sb_issue_zeroout(sb, gdblocks + start + 1, reserved_gdb,
> +			       GFP_NOFS, BLKDEV_IFL_WAIT);
> +	if (err)
> +		goto exit_journal;

When I look at this now, it seems it is bad, because when
sb_issue_discard() returns error for some reason we end up with not
released buffer_head. Since I am still not able to reproduce Ted's
errors I can't say whether it will help or not, but is doubt it will.

>  
> -		if (IS_ERR(gdb = bclean(handle, sb, block))) {
> -			err = PTR_ERR(gdb);
> -			goto exit_bh;
> -		}
> -		ext4_handle_dirty_metadata(handle, NULL, gdb);
> -		ext4_set_bit(bit, bh->b_data);
> -		brelse(gdb);
> -	}
>  	ext4_debug("mark block bitmap %#04llx (+%llu)\n", input->block_bitmap,
>  		   input->block_bitmap - start);
>  	ext4_set_bit(input->block_bitmap - start, bh->b_data);
> @@ -251,23 +241,13 @@ static int setup_new_group_blocks(struct super_block *sb,
>  	ext4_set_bit(input->inode_bitmap - start, bh->b_data);
>  
>  	/* Zero out all of the inode table blocks */
> -	for (i = 0, block = input->inode_table, bit = block - start;
> -	     i < sbi->s_itb_per_group; i++, bit++, block++) {
> -		struct buffer_head *it;
> -
> -		ext4_debug("clear inode block %#04llx (+%d)\n", block, bit);
> -
> -		if ((err = extend_or_restart_transaction(handle, 1, bh)))
> -			goto exit_bh;
> -
> -		if (IS_ERR(it = bclean(handle, sb, block))) {
> -			err = PTR_ERR(it);
> -			goto exit_bh;
> -		}
> -		ext4_handle_dirty_metadata(handle, NULL, it);
> -		brelse(it);
> -		ext4_set_bit(bit, bh->b_data);
> -	}
> +	block = input->inode_table;
> +	ext4_debug("clear inode table blocks %#04llx -> %#04llx\n",
> +			block, sbi->s_itb_per_group);
> +	err = sb_issue_zeroout(sb, block, sbi->s_itb_per_group,
> +			       GFP_NOFS, BLKDEV_IFL_WAIT);
> +	if (err)
> +		goto exit_journal;

here as well.

>  
>  	if ((err = extend_or_restart_transaction(handle, 2, bh)))
>  		goto exit_bh;
> 

I'll resend the patch shortly.

Thanks!
-Lukas
