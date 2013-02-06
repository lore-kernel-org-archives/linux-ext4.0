From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/3] Ext2: mark inode dirty after the function
 dquot_free_block_nodirty is called
Date: Wed, 6 Feb 2013 13:44:20 +0100
Message-ID: <20130206124420.GB6330@quack.suse.cz>
References: <1360131268-1615-1-git-send-email-wangshilong1991@gmail.com>
 <1360131268-1615-2-git-send-email-wangshilong1991@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, linux-ext4@vger.kernel.org,
	Wang Shilong <wangsl-fnst@cn.fujitsu.com>
To: Wang shilong <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37655 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107Ab3BFMod (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Feb 2013 07:44:33 -0500
Content-Disposition: inline
In-Reply-To: <1360131268-1615-2-git-send-email-wangshilong1991@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Wed 06-02-13 14:14:27, Wang shilong wrote:
> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> 
> We should mark inode dirty after the function dquot_free_block_nodirty
> is called.Besides,add a check whether it is necessary to call
> dquot_free_block_nodirty functon.
  Thanks for the patch. Just one comment below.

> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> ---
>  fs/ext2/balloc.c | 15 ++++++++++-----
>  fs/ext2/xattr.c  |  1 +
>  2 files changed, 11 insertions(+), 5 deletions(-)
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
> diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
> index b6754db..4c4cda9 100644
> --- a/fs/ext2/xattr.c
> +++ b/fs/ext2/xattr.c
> @@ -795,6 +795,7 @@ ext2_xattr_delete_inode(struct inode *inode)
>  		if (IS_SYNC(inode))
>  			sync_dirty_buffer(bh);
>  		dquot_free_block_nodirty(inode, 1);
> +		mark_inode_dirty(inode);
>  	}
>  	EXT2_I(inode)->i_file_acl = 0;
  This isn't necessary as the function is meant to be called only when
inode is going to be deleted and thus there's no point in marking it dirty.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
