From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: Re: [PATCH 3/5] [64-BIT] blk_t->blk64_t change in ext2fs_extent_get()/cast in extent_node_split()
Date: Wed, 15 Apr 2009 15:55:06 -0400
Message-ID: <20090415195506.GE1668@shell>
References: <11649.1239227216@alphaville.usa.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Nick Dokos <nicholas.dokos@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753082AbZDOTzf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Apr 2009 15:55:35 -0400
Content-Disposition: inline
In-Reply-To: <11649.1239227216@alphaville.usa.hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 08, 2009 at 05:46:56PM -0400, Nick Dokos wrote:
> e2image (after enabling 64-bitness) was reporting a corrupt extent header
> in a 16TiB file created on a 32TiB filesystem. Checking the on-disk extents
> did not uncover any problem. Debugging e2image showed truncation in the
> ext2fs_extent_get() routine. Code examination showed an inconsistency
> on line 428:
> 
>                 blk = ext2fs_le32_to_cpu(ix->ei_leaf) +
>                         ((__u64) ext2fs_le16_to_cpu(ix->ei_leaf_hi) << 32);
> 
> blk is treated as a 64 bit quantity but it is declared blk_t. This
> changes it to blk64_t. With this change, e2image has been running to
> completion.
> 
> The second change is not based on debugging, just code examination:
> ext2fs_alloc_block2() has been modified in the 64-bit patch series (in
> the patch called add_64-bit_alloc_interface) so that its second
> argument (the goal block) is a blk64_t. However, extent_node_split()
> calls it with its second argument explicitly cast to blk_t. That looks
> wrong.
> 
> There are some more blk_t's used in this file (extent.c), but they are
> in #ifdef DEBUG code, so I have not examined them any closer and I
> have not changed them (yet?).
> 
> Signed-off-by: Nick Dokos <nicholas.dokos@hp.com>

Signed-off-by: Valerie Aurora (Henson) <vaurora@redhat.com>

> ---
>  lib/ext2fs/extent.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
> index a6edd0c..1778955 100644
> --- a/lib/ext2fs/extent.c
> +++ b/lib/ext2fs/extent.c
> @@ -273,7 +273,7 @@ errcode_t ext2fs_extent_get(ext2_extent_handle_t handle,
>  	struct ext3_extent_idx		*ix = 0;
>  	struct ext3_extent		*ex;
>  	errcode_t			retval;
> -	blk_t				blk;
> +	blk64_t				blk;
>  	blk64_t				end_blk;
>  	int				orig_op, op;
>  
> @@ -904,7 +904,7 @@ static errcode_t extent_node_split(ext2_extent_handle_t handle)
>  		goal_blk = (group * handle->fs->super->s_blocks_per_group) +
>  			handle->fs->super->s_first_data_block;
>  	}
> -	retval = ext2fs_alloc_block2(handle->fs, (blk_t) goal_blk, block_buf,
> +	retval = ext2fs_alloc_block2(handle->fs, goal_blk, block_buf,
>  				    &new_node_pblk);
>  	if (retval)
>  		goto done;
> -- 
> 1.6.0.6
> 
