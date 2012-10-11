From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: Avoid underflow of in ext3_trim_fs()
Date: Thu, 11 Oct 2012 13:04:49 +0200
Message-ID: <20121011110449.GC16624@quack.suse.cz>
References: <1349951318-25190-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51703 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757537Ab2JKLEv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Oct 2012 07:04:51 -0400
Content-Disposition: inline
In-Reply-To: <1349951318-25190-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 11-10-12 12:28:38, Lukas Czerner wrote:
> Currently if len argument in ext3_trim_fs() is smaller than one block,
> the 'end' variable underflow. Avoid that by returning EINVAL if len is
> smaller than file system block.
> 
> Also remove useless unlikely().
  Thanks. I've added the patch to my tree.

								Honza

> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  fs/ext3/balloc.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
> index 7320a66..22548f5 100644
> --- a/fs/ext3/balloc.c
> +++ b/fs/ext3/balloc.c
> @@ -2101,8 +2101,9 @@ int ext3_trim_fs(struct super_block *sb, struct fstrim_range *range)
>  	end = start + (range->len >> sb->s_blocksize_bits) - 1;
>  	minlen = range->minlen >> sb->s_blocksize_bits;
>  
> -	if (unlikely(minlen > EXT3_BLOCKS_PER_GROUP(sb)) ||
> -	    unlikely(start >= max_blks))
> +	if (minlen > EXT3_BLOCKS_PER_GROUP(sb) ||
> +	    start >= max_blks ||
> +	    range->len < sb->s_blocksize)
>  		return -EINVAL;
>  	if (end >= max_blks)
>  		end = max_blks - 1;
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
