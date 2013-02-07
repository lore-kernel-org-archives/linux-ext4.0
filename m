From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v1 2/3] Ext2: mark inode dirty after the function
 dquot_free_block_nodirty is called
Date: Thu, 7 Feb 2013 16:45:21 +0100
Message-ID: <20130207154521.GC25392@quack.suse.cz>
References: <1360249074-2642-1-git-send-email-wangshilong1991@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: Wang shilong <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36230 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757809Ab3BGPpd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Feb 2013 10:45:33 -0500
Content-Disposition: inline
In-Reply-To: <1360249074-2642-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 07-02-13 22:57:53, Wang shilong wrote:
> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> 
> We should mark inode dirty after the function dquot_free_block_nodirty
> is called.Besides,add a check whether it is necessary to call
> dquot_free_block_nodirty functon.
  Thanks. I've added the patch to my tree.

								Honza
> 
> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> ---
>  fs/ext2/balloc.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
> index 22993a0..9d372bf 100644
> --- a/fs/ext2/balloc.c
> +++ b/fs/ext2/balloc.c
> @@ -568,8 +568,11 @@ do_more:
>  	}
>  error_return:
>  	brelse(bitmap_bh);
> -	release_blocks(sb, freed);
> -	dquot_free_block_nodirty(inode, freed);
> +	if (freed) {
> +		release_blocks(sb, freed);
> +		dquot_free_block_nodirty(inode, freed);
> +		mark_inode_dirty(inode);
> +	}
>  }
>  
>  /**
> @@ -1412,9 +1415,11 @@ allocated:
>  
>  	*errp = 0;
>  	brelse(bitmap_bh);
> -	dquot_free_block_nodirty(inode, *count-num);
> -	mark_inode_dirty(inode);
> -	*count = num;
> +	if (num < *count) {
> +		dquot_free_block_nodirty(inode, *count-num);
> +		mark_inode_dirty(inode);
> +		*count = num;
> +	}
>  	return ret_block;
>  
>  io_error:
> -- 
> 1.7.11.7
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
