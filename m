From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH V2  1/2] QUOTA cleanup: Use inode->i_blkbits to get
	block bits
Date: Mon, 15 Dec 2008 13:42:42 +0100
Message-ID: <20081215124242.GA15464@duck.suse.cz>
References: <1229114886.7646.29.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>, tytso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:36033 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750909AbYLOMmo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Dec 2008 07:42:44 -0500
Content-Disposition: inline
In-Reply-To: <1229114886.7646.29.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 12-12-08 12:48:06, Mingming Cao wrote:
> quota: Use inode->i_blkbits to get block bits
> 
> From: Mingming Cao <cmm@us.ibm.com>
> 
> Andrew has suggested to use inode->i_blkbits to get the block bits info,
> rather than use super block's blockbits. That should be faster and emit
> less code.
> 
> Signed-off-by: Mingming Cao <cmm@us.ibm.com>
  Acked-by: Jan Kara <jack@suse.cz>

									Honza

> ---
>  include/linux/quotaops.h |   22 ++++++++--------------
>  1 file changed, 8 insertions(+), 14 deletions(-)
> 
> Index: linux-2.6.28-rc2/include/linux/quotaops.h
> ===================================================================
> --- linux-2.6.28-rc2.orig/include/linux/quotaops.h	2008-12-12 12:21:49.000000000 -0800
> +++ linux-2.6.28-rc2/include/linux/quotaops.h	2008-12-12 12:32:21.000000000 -0800
> @@ -398,39 +398,33 @@ static inline void vfs_dq_free_space(str
>  
>  static inline int vfs_dq_prealloc_block_nodirty(struct inode *inode, qsize_t nr)
>  {
> -	return vfs_dq_prealloc_space_nodirty(inode,
> -			nr << inode->i_sb->s_blocksize_bits);
> +	return vfs_dq_prealloc_space_nodirty(inode, nr << inode->i_blkbits);
>  }
>  
>  static inline int vfs_dq_prealloc_block(struct inode *inode, qsize_t nr)
>  {
> -	return vfs_dq_prealloc_space(inode,
> -			nr << inode->i_sb->s_blocksize_bits);
> +	return vfs_dq_prealloc_space(inode, nr << inode->i_blkbits);
>  }
>  
>  static inline int vfs_dq_alloc_block_nodirty(struct inode *inode, qsize_t nr)
>  {
> - 	return vfs_dq_alloc_space_nodirty(inode,
> -			nr << inode->i_sb->s_blocksize_bits);
> + 	return vfs_dq_alloc_space_nodirty(inode, nr << inode->i_blkbits);
>  }
>  
>  
>  static inline int vfs_dq_alloc_block(struct inode *inode, qsize_t nr)
>  {
> -	return vfs_dq_alloc_space(inode,
> -			nr << inode->i_sb->s_blocksize_bits);
> +	return vfs_dq_alloc_space(inode, nr << inode->i_blkbits);
>  }
>  
>  static inline int vfs_dq_reserve_block(struct inode *inode, qsize_t nr)
>  {
> -	return vfs_dq_reserve_space(inode,
> -			nr << inode->i_blkbits);
> +	return vfs_dq_reserve_space(inode, nr << inode->i_blkbits);
>  }
>  
>  static inline int vfs_dq_claim_block(struct inode *inode, qsize_t nr)
>  {
> -	return vfs_dq_claim_space(inode,
> -			nr << inode->i_blkbits);
> +	return vfs_dq_claim_space(inode, nr << inode->i_blkbits);
>  }
>  
>  static inline
> @@ -441,12 +435,12 @@ void vfs_dq_release_reservation_block(st
>  
>  static inline void vfs_dq_free_block_nodirty(struct inode *inode, qsize_t nr)
>  {
> -	vfs_dq_free_space_nodirty(inode, nr << inode->i_sb->s_blocksize_bits);
> +	vfs_dq_free_space_nodirty(inode, nr << inode->i_blkbits);
>  }
>  
>  static inline void vfs_dq_free_block(struct inode *inode, qsize_t nr)
>  {
> -	vfs_dq_free_space(inode, nr << inode->i_sb->s_blocksize_bits);
> +	vfs_dq_free_space(inode, nr << inode->i_blkbits);
>  }
>  
>  /*
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
