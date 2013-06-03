From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 13/26] ext4: Improve writepage credit estimate for files
 with indirect blocks
Date: Mon, 3 Jun 2013 14:45:55 -0700
Message-ID: <20130603214555.GA6083@blackbox.djwong.org>
References: <1369993379-13017-1-git-send-email-jack@suse.cz>
 <1369993379-13017-14-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18769 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756402Ab3FCVqF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Jun 2013 17:46:05 -0400
Content-Disposition: inline
In-Reply-To: <1369993379-13017-14-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 31, 2013 at 11:42:46AM +0200, Jan Kara wrote:
> ext4_ind_trans_blocks() wrongly used 'chunk' argument to decide whether
> blocks mapped are logically continguous. That is wrong since the argument

Picking nits here, but I think you meant 'contiguous' here?  Or 'continuous'
perhaps?  Either way, 'continguous' isn't a word.  There's a bunch more of this
sprinkled over this patch.

--D

> informs whether the blocks are physically continguous. As the blocks
> mapped are always logically continguous and that's all
> ext4_ind_trans_blocks() cares about, just remove the 'chunk' argument.
> 
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/ext4.h     |  2 +-
>  fs/ext4/indirect.c | 27 +++++++++------------------
>  fs/ext4/inode.c    |  2 +-
>  3 files changed, 11 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index d260fb7..bca9889 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2111,7 +2111,7 @@ extern ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
>  				const struct iovec *iov, loff_t offset,
>  				unsigned long nr_segs);
>  extern int ext4_ind_calc_metadata_amount(struct inode *inode, sector_t lblock);
> -extern int ext4_ind_trans_blocks(struct inode *inode, int nrblocks, int chunk);
> +extern int ext4_ind_trans_blocks(struct inode *inode, int nrblocks);
>  extern void ext4_ind_truncate(handle_t *, struct inode *inode);
>  extern int ext4_free_hole_blocks(handle_t *handle, struct inode *inode,
>  				 ext4_lblk_t first, ext4_lblk_t stop);
> diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
> index b8d5d35..c8b3861 100644
> --- a/fs/ext4/indirect.c
> +++ b/fs/ext4/indirect.c
> @@ -779,27 +779,18 @@ int ext4_ind_calc_metadata_amount(struct inode *inode, sector_t lblock)
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
> index 3eb7ad6..27b8504 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4756,7 +4756,7 @@ int ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
>  static int ext4_index_trans_blocks(struct inode *inode, int nrblocks, int chunk)
>  {
>  	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
> -		return ext4_ind_trans_blocks(inode, nrblocks, chunk);
> +		return ext4_ind_trans_blocks(inode, nrblocks);
>  	return ext4_ext_index_trans_blocks(inode, nrblocks, chunk);
>  }
>  
> -- 
> 1.8.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
