From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 16/29] ext4: Improve writepage credit estimate for files
 with indirect blocks
Date: Tue, 7 May 2013 13:39:27 +0800
Message-ID: <20130507053927.GA17637@gmail.com>
References: <1365456754-29373-1-git-send-email-jack@suse.cz>
 <1365456754-29373-17-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:39748 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab3EGFVr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 May 2013 01:21:47 -0400
Received: by mail-pb0-f42.google.com with SMTP id up7so136192pbc.29
        for <linux-ext4@vger.kernel.org>; Mon, 06 May 2013 22:21:46 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1365456754-29373-17-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 08, 2013 at 11:32:21PM +0200, Jan Kara wrote:
> ext4_ind_trans_blocks() wrongly used 'chunk' argument to decide whether
> blocks mapped are logically continguous. That is wrong since the argument
> informs whether the blocks are physically continguous. As the blocks
> mapped are always logically continguous and that's all
> ext4_ind_trans_blocks() cares about, just remove the 'chunk' argument.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
Regards,
                                                - Zheng

> ---
>  fs/ext4/ext4.h     |    2 +-
>  fs/ext4/indirect.c |   27 +++++++++------------------
>  fs/ext4/inode.c    |    2 +-
>  3 files changed, 11 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 3575fdb..d3a54f2 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2093,7 +2093,7 @@ extern ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
>  				const struct iovec *iov, loff_t offset,
>  				unsigned long nr_segs);
>  extern int ext4_ind_calc_metadata_amount(struct inode *inode, sector_t lblock);
> -extern int ext4_ind_trans_blocks(struct inode *inode, int nrblocks, int chunk);
> +extern int ext4_ind_trans_blocks(struct inode *inode, int nrblocks);
>  extern void ext4_ind_truncate(struct inode *inode);
>  extern int ext4_ind_punch_hole(struct file *file, loff_t offset, loff_t length);
>  
> diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
> index b505a14..197b202 100644
> --- a/fs/ext4/indirect.c
> +++ b/fs/ext4/indirect.c
> @@ -913,27 +913,18 @@ int ext4_ind_calc_metadata_amount(struct inode *inode, sector_t lblock)
>  	return (blk_bits / EXT4_ADDR_PER_BLOCK_BITS(inode->i_sb)) + 1;
>  }
>  
> -int ext4_ind_trans_blocks(struct inode *inode, int nrblocks, int chunk)
> +/*
> + * Calculate number of indirect blocks touched by mapping @nrblocks logically
> + * continguous blocks
> + */
> +int ext4_ind_trans_blocks(struct inode *inode, int nrblocks)
>  {
> -	int indirects;
> -
> -	/* if nrblocks are contiguous */
> -	if (chunk) {
> -		/*
> -		 * With N contiguous data blocks, we need at most
> -		 * N/EXT4_ADDR_PER_BLOCK(inode->i_sb) + 1 indirect blocks,
> -		 * 2 dindirect blocks, and 1 tindirect block
> -		 */
> -		return DIV_ROUND_UP(nrblocks,
> -				    EXT4_ADDR_PER_BLOCK(inode->i_sb)) + 4;
> -	}
>  	/*
> -	 * if nrblocks are not contiguous, worse case, each block touch
> -	 * a indirect block, and each indirect block touch a double indirect
> -	 * block, plus a triple indirect block
> +	 * With N contiguous data blocks, we need at most
> +	 * N/EXT4_ADDR_PER_BLOCK(inode->i_sb) + 1 indirect blocks,
> +	 * 2 dindirect blocks, and 1 tindirect block
>  	 */
> -	indirects = nrblocks * 2 + 1;
> -	return indirects;
> +	return DIV_ROUND_UP(nrblocks, EXT4_ADDR_PER_BLOCK(inode->i_sb)) + 4;
>  }
>  
>  /*
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index f4dc4a1..aa26f4c 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4399,7 +4399,7 @@ int ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
>  static int ext4_index_trans_blocks(struct inode *inode, int nrblocks, int chunk)
>  {
>  	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
> -		return ext4_ind_trans_blocks(inode, nrblocks, chunk);
> +		return ext4_ind_trans_blocks(inode, nrblocks);
>  	return ext4_ext_index_trans_blocks(inode, nrblocks, chunk);
>  }
>  
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
