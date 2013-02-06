From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/3] Ext2: remove the overhead check about sb in the
 function ext2_new_blocks
Date: Wed, 6 Feb 2013 13:46:12 +0100
Message-ID: <20130206124612.GC6330@quack.suse.cz>
References: <1360131268-1615-1-git-send-email-wangshilong1991@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, linux-ext4@vger.kernel.org,
	Wang Shilong <wangsl-fnst@cn.fujitsu.com>
To: Wang shilong <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38042 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754209Ab3BFMyh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Feb 2013 07:54:37 -0500
Content-Disposition: inline
In-Reply-To: <1360131268-1615-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 06-02-13 14:14:26, Wang shilong wrote:
> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> 
> It can be guranteed that inode->i_sb should not be null in vfs.
> So here the check about it is overhead.
  This patch looks good. I've added it to my tree.

								Honza
> 
> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> ---
>  fs/ext2/balloc.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
> index 1c36139..22993a0 100644
> --- a/fs/ext2/balloc.c
> +++ b/fs/ext2/balloc.c
> @@ -1239,10 +1239,6 @@ ext2_fsblk_t ext2_new_blocks(struct inode *inode, ext2_fsblk_t goal,
>  
>  	*errp = -ENOSPC;
>  	sb = inode->i_sb;
> -	if (!sb) {
> -		printk("ext2_new_blocks: nonexistent device");
> -		return 0;
> -	}
>  
>  	/*
>  	 * Check quota for allocation of this block.
> -- 
> 1.7.11.7
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
