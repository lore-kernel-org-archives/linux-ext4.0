From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: speed up group trim with the right free block
 count.
Date: Fri, 21 Jan 2011 11:49:21 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1101211148180.3275@dhcp-lab-213.englab.brq.redhat.com>
References: <1295577131-3778-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431Ab1AUKt2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Jan 2011 05:49:28 -0500
In-Reply-To: <1295577131-3778-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 21 Jan 2011, Tao Ma wrote:

> From: Tao Ma <boyu.mt@taobao.com>
> 
> When we trim some free blocks in a group of ext4, we should
> calculate the free blocks properly and check whether there are
> enough freed blocks left for us to trim. Current solution will
> only calculate free spaces if they are large for a trim which
> isn't appropriate.
> 
> Let us see a small example:
> a group has 1.5M free which are 300k, 300k, 300k, 300k, 300k.
> And minblocks is 1M. With current solution, we have to iterate
> the whole group since these 300k will never be subtracted from
> 1.5M. But actually we should exit after we find the first 2
> free spaces since the left 3 chunks only sum up to 900K if we
> subtract the first 600K although they can't be trimed.
> 
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> ---
>  fs/ext4/mballoc.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 851f49b..970e471 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4737,7 +4737,7 @@ ext4_grpblk_t ext4_trim_all_free(struct super_block *sb, struct ext4_buddy *e4b,
>  		ext4_grpblk_t start, ext4_grpblk_t max, ext4_grpblk_t minblocks)
>  {
>  	void *bitmap;
> -	ext4_grpblk_t next, count = 0;
> +	ext4_grpblk_t next, count = 0, free_count = 0;
>  	ext4_group_t group;
>  	int ret = 0;
>  
> @@ -4762,6 +4762,7 @@ ext4_grpblk_t ext4_trim_all_free(struct super_block *sb, struct ext4_buddy *e4b,
>  				break;
>  			count += next - start;
>  		}
> +		free_count += next - start;
>  		start = next + 1;
>  
>  		if (fatal_signal_pending(current)) {
> @@ -4775,7 +4776,7 @@ ext4_grpblk_t ext4_trim_all_free(struct super_block *sb, struct ext4_buddy *e4b,
>  			ext4_lock_group(sb, group);
>  		}
>  
> -		if ((e4b->bd_info->bb_free - count) < minblocks)
> +		if ((e4b->bd_info->bb_free - free_count) < minblocks)
>  			break;
>  	}
>  	ext4_unlock_group(sb, group);
> 

Looks good, thanks.

-Lukas
