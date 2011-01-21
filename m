From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] ext3: speed up group trim with the right free block
 count.
Date: Fri, 21 Jan 2011 11:44:13 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1101211136410.3275@dhcp-lab-213.englab.brq.redhat.com>
References: <1295575166-3674-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844Ab1AUKoT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Jan 2011 05:44:19 -0500
In-Reply-To: <1295575166-3674-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 21 Jan 2011, Tao Ma wrote:

> From: Tao Ma <boyu.mt@taobao.com>
> 
> When we trim some free blocks in a group of ext3, we should
> calculate the free blocks properly and check whether there are
> enough freed blocks left for us to trim. Current solution will
> only calculate free spaces if they are large for a trim which
> is wrong.
> 
> Let us see a small example:
> a group has 1.5M free which are 300k, 300k, 300k, 300k, 300k.
> And minblocks is 1M. With current solution, we have to iterate
> the whole group since these 300k will never be subtracted from
> 1.5M. But actually we should exit after we find the first 2
> free spaces since the left 3 chunks only sum up to 900K if we
> subtract the first 600K although they can't be trimed.
> 
> Cc: Jan Kara <jack@suse.cz>
> Cc: Lukas Czerner <lczerner@redhat.com>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> ---
>  fs/ext3/balloc.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
> index 045995c..971e1bd 100644
> --- a/fs/ext3/balloc.c
> +++ b/fs/ext3/balloc.c
> @@ -1922,7 +1922,7 @@ ext3_grpblk_t ext3_trim_all_free(struct super_block *sb, unsigned int group,
>  				ext3_grpblk_t minblocks)
>  {
>  	handle_t *handle;
> -	ext3_grpblk_t next, free_blocks, bit, freed, count = 0;
> +	ext3_grpblk_t next, free_blocks, bit, freed, count = 0, free_count = 0;
>  	ext3_fsblk_t discard_block;
>  	struct ext3_sb_info *sbi;
>  	struct buffer_head *gdp_bh, *bitmap_bh = NULL;
> @@ -1991,6 +1991,7 @@ ext3_grpblk_t ext3_trim_all_free(struct super_block *sb, unsigned int group,
>  		spin_unlock(sb_bgl_lock(sbi, group));
>  		percpu_counter_sub(&sbi->s_freeblocks_counter, next - start);
>  
> +		free_count += next - start;
>  		/* Do not issue a TRIM on extents smaller than minblocks */
>  		if ((next - start) < minblocks)
>  			goto free_extent;
> @@ -2040,7 +2041,7 @@ free_extent:
>  		cond_resched();
>  
>  		/* No more suitable extents */
> -		if ((free_blocks - count) < minblocks)
> +		if ((free_blocks - free_count) < minblocks)
>  			break;
>  	}
>  
> 

Nice catch, do you plan to do the same for ext4 ? Btw, I do not think
there is a need for new variable (free_count), you can as well do :

free_blocks -= next - start;
...
if (free_blocks < minblocks)
	break;


Thanks!
-Lukas
