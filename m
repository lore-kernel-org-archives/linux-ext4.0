From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: ext4 xfstest regression due to ext4_es_lookup_extent
Date: Sun, 24 Feb 2013 22:58:37 +0800
Message-ID: <20130224145837.GA3722@gmail.com>
References: <87obfcs1x6.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f42.google.com ([209.85.210.42]:51190 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab3BXOno (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 Feb 2013 09:43:44 -0500
Received: by mail-da0-f42.google.com with SMTP id z17so1086658dal.1
        for <linux-ext4@vger.kernel.org>; Sun, 24 Feb 2013 06:43:43 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <87obfcs1x6.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Dmirty,

On Fri, Feb 22, 2013 at 09:17:57PM +0400, Dmitry Monakhov wrote:
[snip]
> From 65c5fc212b1c684c76899c6e5e1f24d88550c6fc Mon Sep 17 00:00:00 2001
> From: Dmitry Monakhov <dmonakhov@openvz.org>
> Date: Fri, 22 Feb 2013 20:55:52 +0400
> Subject: [PATCH] ext4 add sanity ext4_es_lookup_extent
> 
> This patch does very simple thing: it recheck result returned from
> ext4_es_lookup_extent() by comparing it old-good lookup via
> ext4_{ind,ext}_map_blocks() under i_data_sem
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

I try to apply the following patch in my tree, but I realize that it
seems that we couldn't add this sanity check in ext4_map_blocks and
ext4_da_map_blocks now.  The reason is that when we try to initialize an
unwritten extent this extent could be zeroed out.  But we could know it
in *_map_blocks, and status tree couldn't be updated.  So we will hit a
BUG_ON(1) after added this sanity check.

I agree with you that we need to add self-testing infrastructre after
applied status tree patch series.  But it seems that we need to mix
updating status tree code with extent tree code.  IMHO it is too
complicated.  Any thought?

Thanks,
                                                - Zheng

> ---
>  fs/ext4/inode.c |   42 ++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 42 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 95a0c62..706db1f 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -482,6 +482,41 @@ static pgoff_t ext4_num_dirty_pages(struct inode *inode, pgoff_t idx,
>  	return num;
>  }
>  
> +#define ES_AGGRESSIVE_TEST 1
> +#ifdef ES_AGGRESSIVE_TEST
> +void ext4_map_blocks_es_recheck(handle_t *handle, struct inode *inode,
> +				struct ext4_map_blocks *es_map, int es_ret,
> +				struct ext4_map_blocks *map, int flags)
> +{
> +	int ret;
> +
> +	map->m_flags = 0;
> +	if (!(flags & EXT4_GET_BLOCKS_NO_LOCK))
> +		down_read((&EXT4_I(inode)->i_data_sem));
> +	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
> +		ret = ext4_ext_map_blocks(handle, inode, map, flags &
> +					     EXT4_GET_BLOCKS_KEEP_SIZE);
> +	} else {
> +		ret = ext4_ind_map_blocks(handle, inode, map, flags &
> +					     EXT4_GET_BLOCKS_KEEP_SIZE);
> +	}
> +	if (es_map->m_lblk != map->m_lblk ||
> +	    es_map->m_flags != map->m_flags ||
> +	    es_map->m_len != map->m_len ||
> +	    es_map->m_pblk != map->m_pblk ||
> +	    es_ret != ret) {
> +		printk("Assertation failed for inode:%lu "
> +		       "es_cached_ex [%d/%d/%llu/%x]:%d != "
> +		       "found_ex [%d/%d/%llu/%x]:%d\n", inode->i_ino,
> +		       es_map->m_lblk, es_map->m_len, es_map->m_pblk,
> +		       es_map->m_flags, es_ret,
> +		       map->m_lblk, map->m_len, map->m_pblk, map->m_flags, ret);
> +		BUG();
> +	}
> +	if (!(flags & EXT4_GET_BLOCKS_NO_LOCK))
> +		up_read((&EXT4_I(inode)->i_data_sem));
> +}
> +#endif
>  /*
>   * The ext4_map_blocks() function tries to look up the requested blocks,
>   * and returns if the blocks are already mapped.
> @@ -509,7 +544,11 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>  {
>  	struct extent_status es;
>  	int retval;
> +#ifdef ES_AGGRESSIVE_TEST
> +	struct ext4_map_blocks orig_map;
>  
> +	memcpy(&orig_map, map, sizeof(*map));
> +#endif
>  	map->m_flags = 0;
>  	ext_debug("ext4_map_blocks(): inode %lu, flag %d, max_blocks %u,"
>  		  "logical block %lu\n", inode->i_ino, flags, map->m_len,
> @@ -531,6 +570,9 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>  		} else {
>  			BUG_ON(1);
>  		}
> +#ifdef ES_AGGRESSIVE_TEST
> +		ext4_map_blocks_es_recheck(handle,inode, map, retval, &orig_map, flags);
> +#endif
>  		goto found;
>  	}
>  
> -- 
> 1.7.1
> 

