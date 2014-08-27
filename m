From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 3/6] ext4: cache extent hole in extent status tree for
 ext4_da_map_blocks()
Date: Wed, 27 Aug 2014 15:55:16 +0200
Message-ID: <20140827135516.GB22211@quack.suse.cz>
References: <1407382553-24256-1-git-send-email-wenqing.lz@taobao.com>
 <1407382553-24256-4-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36271 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934703AbaH0NzU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Aug 2014 09:55:20 -0400
Content-Disposition: inline
In-Reply-To: <1407382553-24256-4-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 07-08-14 11:35:50, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> Currently extent status tree doesn't cache extent hole when a write
> looks up in extent tree to make sure whether a block has been allocated
> or not.  In this case, we don't put extent hole in extent cache because
> later this extent might be removed and a new delayed extent might be
> added back.  But it will cause a defect when we do a lot of writes.
> If we don't put extent hole in extent cache, the following writes also
> need to access extent tree to look at whether or not a block has been
> allocated.  It brings a cache miss.  This commit fixes this defect.
> Meanwhile, if an inode has no any extent, this extent hole also will
> be cached.
> 
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
  So I agree with this change, it certainly doesn't make things worse. But
when looking into ext4_ext_put_gap_in_cache() I have one question: That
function uses ext4_find_delalloc_range() to check that the intended range
doesn't have any delalloc blocks in it. However it doesn't make any effort
to put a smaller hole in cache - for example if we have blocks allocated
like:

5-6 = delalloc
7-10 = allocated

and ext4_ext_put_gap_in_cache() is called for block 0, the function won't
put anything into cache although it could put range 0-4 in the cache as a
hole. Why is that?

								Honza

> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 76c2df3..6463d34 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2284,16 +2284,15 @@ ext4_ext_put_gap_in_cache(struct inode *inode, struct ext4_ext_path *path,
>  				ext4_lblk_t block)
>  {
>  	int depth = ext_depth(inode);
> -	unsigned long len = 0;
> -	ext4_lblk_t lblock = 0;
> +	unsigned long len;
> +	ext4_lblk_t lblock;
>  	struct ext4_extent *ex;
>  
>  	ex = path[depth].p_ext;
>  	if (ex == NULL) {
> -		/*
> -		 * there is no extent yet, so gap is [0;-] and we
> -		 * don't cache it
> -		 */
> +		/* there is no extent yet, so gap is [0;-] */
> +		lblock = 0;
> +		len = EXT_MAX_BLOCKS;
>  		ext_debug("cache gap(whole file):");
>  	} else if (block < le32_to_cpu(ex->ee_block)) {
>  		lblock = block;
> @@ -2302,9 +2301,6 @@ ext4_ext_put_gap_in_cache(struct inode *inode, struct ext4_ext_path *path,
>  				block,
>  				le32_to_cpu(ex->ee_block),
>  				 ext4_ext_get_actual_len(ex));
> -		if (!ext4_find_delalloc_range(inode, lblock, lblock + len - 1))
> -			ext4_es_insert_extent(inode, lblock, len, ~0,
> -					      EXTENT_STATUS_HOLE);
>  	} else if (block >= le32_to_cpu(ex->ee_block)
>  			+ ext4_ext_get_actual_len(ex)) {
>  		ext4_lblk_t next;
> @@ -2318,14 +2314,14 @@ ext4_ext_put_gap_in_cache(struct inode *inode, struct ext4_ext_path *path,
>  				block);
>  		BUG_ON(next == lblock);
>  		len = next - lblock;
> -		if (!ext4_find_delalloc_range(inode, lblock, lblock + len - 1))
> -			ext4_es_insert_extent(inode, lblock, len, ~0,
> -					      EXTENT_STATUS_HOLE);
>  	} else {
>  		BUG();
>  	}
>  
>  	ext_debug(" -> %u:%lu\n", lblock, len);
> +	if (!ext4_find_delalloc_range(inode, lblock, lblock + len - 1))
> +		ext4_es_insert_extent(inode, lblock, len, ~0,
> +				      EXTENT_STATUS_HOLE);
>  }
>  
>  /*
> @@ -4362,8 +4358,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
>  		 * put just found gap into cache to speed up
>  		 * subsequent requests
>  		 */
> -		if ((flags & EXT4_GET_BLOCKS_NO_PUT_HOLE) == 0)
> -			ext4_ext_put_gap_in_cache(inode, path, map->m_lblk);
> +		ext4_ext_put_gap_in_cache(inode, path, map->m_lblk);
>  		goto out2;
>  	}
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
