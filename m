From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] ext3: Update ctime in ext3_splice_branch() only
 when needed
Date: Wed, 8 Feb 2012 10:33:07 +0100
Message-ID: <20120208093307.GB24625@quack.suse.cz>
References: <4F322585.3010407@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 <linux-ext4@vger.kernel.org>, jan Kara <jack@suse.cz>,
	Andreas Dilger <adilger@dilger.ca>
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38960 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634Ab2BHJdJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Feb 2012 04:33:09 -0500
Content-Disposition: inline
In-Reply-To: <4F322585.3010407@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 08-02-12 16:34:29, Kazuya Mio wrote:
> Currently ext3 updates ctime in ext3_splice_branch() which is called whenever
> we allocate one block. But it is wasteful because ext3 doesn't support
> nanosecond timestamp. This leads to a performance loss.
> 
> Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
  Thanks. The patch looks good. I've added it to my tree.

								Honza

> ---
>  fs/ext3/inode.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> index 2d0afec..3c7fd63 100644
> --- a/fs/ext3/inode.c
> +++ b/fs/ext3/inode.c
> @@ -756,6 +756,7 @@ static int ext3_splice_branch(handle_t *handle, struct inode *inode,
>  	struct ext3_block_alloc_info *block_i;
>  	ext3_fsblk_t current_block;
>  	struct ext3_inode_info *ei = EXT3_I(inode);
> +	struct timespec now;
>  
>  	block_i = ei->i_block_alloc_info;
>  	/*
> @@ -795,9 +796,11 @@ static int ext3_splice_branch(handle_t *handle, struct inode *inode,
>  	}
>  
>  	/* We are done with atomic stuff, now do the rest of housekeeping */
> -
> -	inode->i_ctime = CURRENT_TIME_SEC;
> -	ext3_mark_inode_dirty(handle, inode);
> +	now = CURRENT_TIME_SEC;
> +	if (!timespec_equal(&inode->i_ctime, &now) || !where->bh) {
> +		inode->i_ctime = now;
> +		ext3_mark_inode_dirty(handle, inode);
> +	}
>  	/* ext3_mark_inode_dirty already updated i_sync_tid */
>  	atomic_set(&ei->i_datasync_tid, handle->h_transaction->t_tid);
>  
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
