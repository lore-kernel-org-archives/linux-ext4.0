From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 3/6] ext4: add self-testing infrastructure to do a sanity check
Date: Thu, 28 Feb 2013 23:04:39 +0400
Message-ID: <8738wgxnso.fsf@openvz.org>
References: <1362076004-10087-1-git-send-email-wenqing.lz@taobao.com> <1362076004-10087-4-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <wenqing.lz@taobao.com>, Theodore Ts'o <tytso@mit.edu>
To: Zheng Liu <gnehzuil.liu@gmail.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:59294 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157Ab3B1TEp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Feb 2013 14:04:45 -0500
Received: by mail-la0-f43.google.com with SMTP id ek20so2116693lab.2
        for <linux-ext4@vger.kernel.org>; Thu, 28 Feb 2013 11:04:42 -0800 (PST)
In-Reply-To: <1362076004-10087-4-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri,  1 Mar 2013 02:26:41 +0800, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> From: Dmitry Monakhov <dmonakhov@openvz.org>
> 
> This commit adds a self-testing infrastructure like extent tree does to
> do a sanity check for extent status tree.  After status tree is as a
> extent cache, we'd better to make sure that it caches right result.
> 
> After applied this commit, we will get a lot of messages when we run
> xfstests as below.
> 
> ...
> kernel: ES len assertation failed for inode: 230 retval 1 != map->m_len
> 3 in ext4_map_blocks (allocation)
> ...
> kernel: ES cache assertation failed for inode: 230 es_cached ex
> [974/2/4781/20] != found ex [974/1/4781/1000]
> ...
> kernel: ES insert assertation failed for inode: 635 ex_status
> [0/45/21388/w] != es_status [44/1/21432/u]
> ...
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/extents_status.c | 64 ++++++++++++++++++++++++++++++++
>  fs/ext4/extents_status.h |  6 +++
>  fs/ext4/inode.c          | 95 ++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 165 insertions(+)
> 
> diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
> index a769485..02df536 100644
> --- a/fs/ext4/extents_status.c
> +++ b/fs/ext4/extents_status.c
> @@ -401,6 +401,66 @@ ext4_es_try_to_merge_right(struct inode *inode, struct extent_status *es)
>  	return es;
>  }
>  
> +#ifdef ES_AGGRESSIVE_TEST
> +static void ext4_es_insert_extent_check(struct inode *inode,
> +					struct extent_status *es)
Agree, this is very good place for sanity check.
> +{
> +	struct ext4_ext_path *path = NULL;
> +	struct ext4_extent *ex;
> +	ext4_lblk_t ee_block;
> +	ext4_fsblk_t ee_start;
> +	unsigned short ee_len;
> +	int depth, ex_status, es_status;
> +
> +	/*
> +	 * Delayed and hole haven't been allocated in disk.  We
> +	 * don't need to check it.
> +	 */
Why?  We still can perform ext4_ext_find_extent and check that:
      /* If extent is delayed  only if ex == NULL */
      if (!ex  == ext4_es_is_written(es))
           WARN_ON();
          
      if (ext4_es_is_unwritten(es) != ext4_ext_is_uninitialized(ex))
           WARN_ON();

> +	if (!ext4_es_is_written(es) && !ext4_es_is_unwritten(es))
> +		return;
> +
> +	/*
> +	 * We don't need to worry about the race condition because
> +	 * caller takes i_data_sem locking.
         Yes, and it is good place to assertion that we hold it.
> +	 */
> +	path = ext4_ext_find_extent(inode, es->es_lblk, NULL);
> +	if (IS_ERR(path))
> +		return;
> +
> +	depth = ext_depth(inode);
> +
> +	/* We should always find an extent at given logical block */
> +	ex = path[depth].p_ext;
> +	if ((ex != NULL )  ^ ext4_es_is_written(es) {
> +		printk("ES insert assertation failed to inode: %lu "
> +		       "can not find the extent at block %d\n",
> +		       inode->i_ino, es->es_lblk);
> +		goto out;
> +	}
> +
> +> +
> +	ee_block = le32_to_cpu(ex->ee_block);
> +	ee_start = ext4_ext_pblock(ex);
> +	ee_len = ext4_ext_get_actual_len(ex);
> +
> +	ex_status = ext4_ext_is_uninitialized(ex) ? 1 : 0;
> +	es_status = ext4_es_is_unwritten(es) ? 1 : 0;
> +	if (ex_status ^ es_status) {
Why status only?  we can also check pblock, and lblk.
> +		printk("ES insert assertation failed for inode: %lu "
> +		       "ex_status [%d/%d/%llu/%c] != "
> +		       "es_status [%d/%d/%llu/%c]\n", inode->i_ino,
> +		       ee_block, ee_len, ee_start, ex_status ? 'u' : 'w',
> +		       es->es_lblk, es->es_len, ext4_es_pblock(es),
> +		       es_status ? 'u' : 'w');
> +	}
> +out:
> +	if (path) {
> +		ext4_ext_drop_refs(path);
> +		kfree(path);
> +	}
> +
> +}
> +#endif
> +
>  static int __es_insert_extent(struct inode *inode, struct extent_status *newes)
>  {
>  	struct ext4_es_tree *tree = &EXT4_I(inode)->i_es_tree;
> @@ -483,6 +543,10 @@ int ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
>  	ext4_es_store_status(&newes, status);
>  	trace_ext4_es_insert_extent(inode, &newes);
>  
> +#ifdef ES_AGGRESSIVE_TEST
> +	ext4_es_insert_extent_check(inode, &newes);
> +#endif
> +
>  	write_lock(&EXT4_I(inode)->i_es_lock);
>  	err = __es_remove_extent(inode, lblk, end);
>  	if (err != 0)
> diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
> index f190dfe..56140ad 100644
> --- a/fs/ext4/extents_status.h
> +++ b/fs/ext4/extents_status.h
> @@ -21,6 +21,12 @@
>  #endif
>  
>  /*
> + * With ES_AGGRESSIVE_TEST defined, the result of es caching will be
> + * checked with old map_block's result.
> + */
> +#define ES_AGGRESSIVE_TEST__
> +
> +/*
>   * These flags live in the high bits of extent_status.es_pblk
>   */
>  #define EXTENT_STATUS_WRITTEN	(1ULL << 63)
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 95a0c62..8d22170 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -482,6 +482,57 @@ static pgoff_t ext4_num_dirty_pages(struct inode *inode, pgoff_t idx,
>  	return num;
>  }
>  
> +#ifdef ES_AGGRESSIVE_TEST
> +static void ext4_map_blocks_es_recheck(handle_t *handle,
> +				       struct inode *inode,
> +				       struct ext4_map_blocks *es_map,
> +				       struct ext4_map_blocks *map,
> +				       int flags)
> +{
> +	int retval;
> +
> +	map->m_flags = 0;
> +	/*
> +	 * There is a race window that the result is not the same.
> +	 * e.g. xfstests #223 when dioread_nolock enables.  The reason
> +	 * is that we lookup a block mapping in extent status tree with
> +	 * out taking i_data_sem.  So at the time the unwritten extent
> +	 * could be converted.
> +	 */
> +	if (!(flags & EXT4_GET_BLOCKS_NO_LOCK))
> +		down_read((&EXT4_I(inode)->i_data_sem));
> +	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
> +		retval = ext4_ext_map_blocks(handle, inode, map, flags &
> +					     EXT4_GET_BLOCKS_KEEP_SIZE);
> +	} else {
> +		retval = ext4_ind_map_blocks(handle, inode, map, flags &
> +					     EXT4_GET_BLOCKS_KEEP_SIZE);
> +	}
> +	if (!(flags & EXT4_GET_BLOCKS_NO_LOCK))
> +		up_read((&EXT4_I(inode)->i_data_sem));
> +	/*
> +	 * Clear EXT4_MAP_FROM_CLUSTER flag because it shouldn't be marked
> +	 * in es_map->m_flags.
> +	 */
> +	map->m_flags &= ~EXT4_MAP_FROM_CLUSTER;
> +
> +	/*
> +	 * We don't check m_len because extent will be collpased in status
> +	 * tree.  So the m_len might not equal.
> +	 */
> +	if (es_map->m_lblk != map->m_lblk ||
> +	    es_map->m_flags != map->m_flags ||
> +	    es_map->m_pblk != map->m_pblk) {
> +		printk("ES cache assertation failed for inode: %lu "
> +		       "es_cached ex [%d/%d/%llu/%x] != "
> +		       "found ex [%d/%d/%llu/%x]\n", inode->i_ino,
> +		       es_map->m_lblk, es_map->m_len,
> +		       es_map->m_pblk, es_map->m_flags,
> +		       map->m_lblk, map->m_len, map->m_pblk, map->m_flags);
> +	}
> +}
> +#endif /* ES_AGGRESSIVE_TEST */
> +
>  /*
>   * The ext4_map_blocks() function tries to look up the requested blocks,
>   * and returns if the blocks are already mapped.
> @@ -509,6 +560,11 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>  {
>  	struct extent_status es;
>  	int retval;
> +#ifdef ES_AGGRESSIVE_TEST
> +	struct ext4_map_blocks orig_map;
> +
> +	memcpy(&orig_map, map, sizeof(*map));
> +#endif
>  
>  	map->m_flags = 0;
>  	ext_debug("ext4_map_blocks(): inode %lu, flag %d, max_blocks %u,"
> @@ -531,6 +587,10 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>  		} else {
>  			BUG_ON(1);
>  		}
> +#ifdef ES_AGGRESSIVE_TEST
> +		ext4_map_blocks_es_recheck(handle, inode, map,
> +					   &orig_map, flags);
> +#endif
>  		goto found;
>  	}
>  
> @@ -551,6 +611,15 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>  		int ret;
>  		unsigned long long status;
>  
> +#ifdef ES_AGGRESSIVE_TEST
> +		if (retval != map->m_len) {
> +			printk("ES len assertation failed for inode: %lu "
> +			       "retval %d != map->m_len %d "
> +			       "in %s (lookup)\n", inode->i_ino, retval,
> +			       map->m_len, __func__);
> +		}
> +#endif
> +
>  		status = map->m_flags & EXT4_MAP_UNWRITTEN ?
>  				EXTENT_STATUS_UNWRITTEN : EXTENT_STATUS_WRITTEN;
>  		if (!(flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE) &&
> @@ -643,6 +712,15 @@ found:
>  		int ret;
>  		unsigned long long status;
>  
> +#ifdef ES_AGGRESSIVE_TEST
> +		if (retval != map->m_len) {
> +			printk("ES len assertation failed for inode: %lu "
> +			       "retval %d != map->m_len %d "
> +			       "in %s (allocation)\n", inode->i_ino, retval,
> +			       map->m_len, __func__);
> +		}
> +#endif
> +
>  		status = map->m_flags & EXT4_MAP_UNWRITTEN ?
>  				EXTENT_STATUS_UNWRITTEN : EXTENT_STATUS_WRITTEN;
>  		if (!(flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE) &&
> @@ -1768,6 +1846,11 @@ static int ext4_da_map_blocks(struct inode *inode, sector_t iblock,
>  	struct extent_status es;
>  	int retval;
>  	sector_t invalid_block = ~((sector_t) 0xffff);
> +#ifdef ES_AGGRESSIVE_TEST
> +	struct ext4_map_blocks orig_map;
> +
> +	memcpy(&orig_map, map, sizeof(&map));
> +#endif
>  
>  	if (invalid_block < ext4_blocks_count(EXT4_SB(inode->i_sb)->s_es))
>  		invalid_block = ~0;
> @@ -1809,6 +1892,9 @@ static int ext4_da_map_blocks(struct inode *inode, sector_t iblock,
>  		else
>  			BUG_ON(1);
>  
> +#ifdef ES_AGRESSIVE_TEST
> +		ext4_map_blocks_es_recheck(NULL, inode, map, &orig_map, flags);
> +#endif
>  		return retval;
>  	}
>  
> @@ -1873,6 +1959,15 @@ add_delayed:
>  		int ret;
>  		unsigned long long status;
>  
> +#ifdef ES_AGGRESSIVE_TEST
> +		if (retval != map->m_len) {
> +			printk("ES len assertation failed for inode: %lu "
> +			       "retval %d != map->m_len %d "
> +			       "in %s (lookup)\n", inode->i_ino, retval,
> +			       map->m_len, __func__);
> +		}
> +#endif
> +
>  		status = map->m_flags & EXT4_MAP_UNWRITTEN ?
>  				EXTENT_STATUS_UNWRITTEN : EXTENT_STATUS_WRITTEN;
>  		ret = ext4_es_insert_extent(inode, map->m_lblk, map->m_len,
> -- 
> 1.7.12.rc2.18.g61b472e
> 
