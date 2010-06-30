From: Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH] ext2:delete misused ext2_free_blocks
Date: Thu, 1 Jul 2010 00:57:54 +0200
Message-ID: <20100630225754.GT19184@bicker>
References: <1277893287-25916-1-git-send-email-wppan@redflag-linux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, hch@lst.de, viro@zeniv.linux.org.uk, npiggin@suse.de,
	jblunck@suse.de, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: Peter Pan <wppan@redflag-linux.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38518 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab0F3W7q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Jun 2010 18:59:46 -0400
Content-Disposition: inline
In-Reply-To: <1277893287-25916-1-git-send-email-wppan@redflag-linux.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 30, 2010 at 06:21:27PM +0800, Peter Pan wrote:
> if ext2_new_blocks returns error, no blocks need to be freed.
> 

Hi Peter,

Your patch isn't right.  The original code is OK as is.

Are you seeing a kernel panic?  Perhaps we can help you fix it.

regards,
dan carpenter

> Signed-off-by: Peter Pan <wppan@redflag-linux.com>
> ---
>  fs/ext2/inode.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index 3675088..f858847 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -385,6 +385,8 @@ static int ext2_alloc_blocks(struct inode *inode,
>  	ext2_fsblk_t current_block = 0;
>  	int ret = 0;
>  
> +	*err = -ENOSPC;
> +
>  	/*
>  	 * Here we try to allocate the requested multiple blocks at once,
>  	 * on a best-effort basis.
> @@ -421,8 +423,6 @@ static int ext2_alloc_blocks(struct inode *inode,
>  	*err = 0;
>  	return ret;
>  failed_out:
> -	for (i = 0; i <index; i++)
> -		ext2_free_blocks(inode, new_blocks[i], 1);
>  	return ret;
>  }
>  
> -- 
> 1.6.6
