From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [Ext4 punch hole 3/5 v7] Ext4 Punch Hole Support: Punch out
 extents
Date: Mon, 09 May 2011 17:51:42 -0700
Message-ID: <1304988702.2543.7.camel@mingming-laptop>
References: <4DC5DB9E.9060707@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:56591 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab1EJAvt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 May 2011 20:51:49 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e38.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p49HIWn0030714
	for <linux-ext4@vger.kernel.org>; Mon, 9 May 2011 11:18:32 -0600
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p4A0queM135570
	for <linux-ext4@vger.kernel.org>; Mon, 9 May 2011 18:52:56 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p49IpiiY022406
	for <linux-ext4@vger.kernel.org>; Mon, 9 May 2011 12:51:44 -0600
In-Reply-To: <4DC5DB9E.9060707@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 2011-05-07 at 16:54 -0700, Allison Henderson wrote:
> v6->v7: Added optimization to while loop in ext4_ext_remove_space
> to limit the tree search to only the extents that need to be punched
> out
> 

It indeed a optimization, not having to search entire tree:-)

Not blocking issue but we could do future optimization by making sure we
only punch out one extent at a time at high level so the while loop is
entirely removed. That could be future improvement.

> 
> This patch modifies the truncate routines to support hole punching
> Below is a brief summary of the patches changes:
> 
> - Added end param to ext_ext4_rm_leaf
>         This function has been modified to accept an end parameter
>         which enables it to punch holes in leafs instead of just
>         truncating them.
> 
> - Implemented the "remove head" case in the ext_remove_blocks routine
>         This routine is used by ext_ext4_rm_leaf to remove the tail
>         of an extent during a truncate.  The new ext_ext4_rm_leaf
>         routine will now also use it to remove the head of an extent in the
>         case that the hole covers a region of blocks at the beginning
>         of an extent.
> 
> - Added "end" param to ext4_ext_remove_space routine
>         This function has been modified to accept a stop parameter, which
>         is passed through to ext4_ext_rm_leaf.
> 

Overall I am fine with the patch. You could add
reviewed-by: Mingming Cao <cmm@us.ibm.com>

> Signed-off-by: Allison Henderson <achender@us.ibm.com>
> ---
> :100644 100644 e04faeb... 6dea243... M	fs/ext4/extents.c
>  fs/ext4/extents.c |  189 ++++++++++++++++++++++++++++++++++++++++++++++------
>  1 files changed, 167 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index e04faeb..6dea243 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -46,6 +46,13 @@
> 
>  #include <trace/events/ext4.h>
> 
> +static int ext4_split_extent(handle_t *handle,
> +				struct inode *inode,
> +				struct ext4_ext_path *path,
> +				struct ext4_map_blocks *map,
> +				int split_flag,
> +				int flags);
> +
>  static int ext4_ext_truncate_extend_restart(handle_t *handle,
>  					    struct inode *inode,
>  					    int needed)
> @@ -2198,8 +2205,16 @@ static int ext4_remove_blocks(handle_t *handle, struct inode *inode,
>  		ext4_free_blocks(handle, inode, NULL, start, num, flags);
>  	} else if (from == le32_to_cpu(ex->ee_block)
>  		   && to <= le32_to_cpu(ex->ee_block) + ee_len - 1) {
> -		printk(KERN_INFO "strange request: removal %u-%u from %u:%u\n",
> -			from, to, le32_to_cpu(ex->ee_block), ee_len);
> +		/* head removal */
> +		ext4_lblk_t num;
> +		ext4_fsblk_t start;
> +
> +		num = to - from;
> +		start = ext4_ext_pblock(ex);
> +
> +		ext_debug("free first %u blocks starting %llu\n", num, start);
> +		ext4_free_blocks(handle, inode, 0, start, num, flags);
> +
>  	} else {
>  		printk(KERN_INFO "strange request: removal(2) "
>  				"%u-%u from %u:%u\n",
> @@ -2208,9 +2223,22 @@ static int ext4_remove_blocks(handle_t *handle, struct inode *inode,
>  	return 0;
>  }
> 
> +
> +/*
> + * ext4_ext_rm_leaf() Removes the extents associated with the
> + * blocks appearing between "start" and "end", and splits the extents
> + * if "start" and "end" appear in the same extent
> + *
> + * @handle: The journal handle
> + * @inode:  The files inode
> + * @path:   The path to the leaf
> + * @start:  The first block to remove
> + * @end:   The last block to remove
> + */
>  static int
>  ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
> -		struct ext4_ext_path *path, ext4_lblk_t start)
> +		struct ext4_ext_path *path, ext4_lblk_t start,
> +		ext4_lblk_t end)
>  {
>  	int err = 0, correct_index = 0;
>  	int depth = ext_depth(inode), credits;
> @@ -2221,6 +2249,7 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
>  	unsigned short ex_ee_len;
>  	unsigned uninitialized = 0;
>  	struct ext4_extent *ex;
> +	struct ext4_map_blocks map;
> 
>  	/* the header must be checked already in ext4_ext_remove_space() */
>  	ext_debug("truncate since %u in leaf\n", start);
> @@ -2250,31 +2279,95 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
>  		path[depth].p_ext = ex;
> 
>  		a = ex_ee_block > start ? ex_ee_block : start;
> -		b = ex_ee_block + ex_ee_len - 1 < EXT_MAX_BLOCK ?
> -			ex_ee_block + ex_ee_len - 1 : EXT_MAX_BLOCK;
> +		b = ex_ee_block+ex_ee_len - 1 < end ?
> +			ex_ee_block+ex_ee_len - 1 : end;
> 
>  		ext_debug("  border %u:%u\n", a, b);
> 
> -		if (a != ex_ee_block && b != ex_ee_block + ex_ee_len - 1) {
> -			block = 0;
> -			num = 0;
> -			BUG();
> +		/* If this extent is beyond the end of the hole, skip it */
> +		if (end <= ex_ee_block) {
> +			ex--;
> +			ex_ee_block = le32_to_cpu(ex->ee_block);
> +			ex_ee_len = ext4_ext_get_actual_len(ex);
> +			continue;
> +		} else if (a != ex_ee_block &&
> +			b != ex_ee_block + ex_ee_len - 1) {
> +			/*
> +			 * If this is a truncate, then this condition should
> +			 * never happen because at least one of the end points
> +			 * needs to be on the edge of the extent.
> +			 */
> +			if (end == EXT_MAX_BLOCK) {
> +				ext_debug("  bad truncate %u:%u\n",
> +						start, end);
> +				block = 0;
> +				num = 0;
> +				err = -EIO;
> +				goto out;
> +			}
> +			/*
> +			 * else this is a hole punch, so the extent needs to
> +			 * be split since neither edge of the hole is on the
> +			 * extent edge
> +			 */
> +			else{
> +				map.m_pblk = ext4_ext_pblock(ex);
> +				map.m_lblk = ex_ee_block;
> +				map.m_len = b - ex_ee_block;
> +
> +				err = ext4_split_extent(handle,
> +					inode, path, &map, 0,
> +					EXT4_GET_BLOCKS_PUNCH_OUT_EXT |
> +					EXT4_GET_BLOCKS_PRE_IO);
> +
> +				if (err < 0)
> +					goto out;
> +
> +				ex_ee_len = ext4_ext_get_actual_len(ex);
> +
> +				b = ex_ee_block+ex_ee_len - 1 < end ?
> +					ex_ee_block+ex_ee_len - 1 : end;
> +
> +				/* Then remove tail of this extent */
> +				block = ex_ee_block;
> +				num = a - block;
> +			}
>  		} else if (a != ex_ee_block) {
>  			/* remove tail of the extent */
>  			block = ex_ee_block;
>  			num = a - block;
>  		} else if (b != ex_ee_block + ex_ee_len - 1) {
>  			/* remove head of the extent */
> -			block = a;
> -			num = b - a;
> -			/* there is no "make a hole" API yet */
> -			BUG();
> +			block = b;
> +			num =  ex_ee_block + ex_ee_len - b;
> +
> +			/*
> +			 * If this is a truncate, this condition
> +			 * should never happen
> +			 */
> +			if (end == EXT_MAX_BLOCK) {
> +				ext_debug("  bad truncate %u:%u\n",
> +					start, end);
> +				err = -EIO;
> +				goto out;
> +			}
>  		} else {
>  			/* remove whole extent: excellent! */
>  			block = ex_ee_block;
>  			num = 0;
> -			BUG_ON(a != ex_ee_block);
> -			BUG_ON(b != ex_ee_block + ex_ee_len - 1);
> +			if (a != ex_ee_block) {
> +				ext_debug("  bad truncate %u:%u\n",
> +					start, end);
> +				err = -EIO;
> +				goto out;
> +			}
> +
> +			if (b != ex_ee_block + ex_ee_len - 1) {
> +				ext_debug("  bad truncate %u:%u\n",
> +					start, end);
> +				err = -EIO;
> +				goto out;
> +			}
>  		}
> 
>  		/*
> @@ -2305,7 +2398,13 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
>  		if (num == 0) {
>  			/* this extent is removed; mark slot entirely unused */
>  			ext4_ext_store_pblock(ex, 0);
> -			le16_add_cpu(&eh->eh_entries, -1);
> +		} else if (block != ex_ee_block) {
> +			/*
> +			 * If this was a head removal, then we need to update
> +			 * the physical block since it is now at a different
> +			 * location
> +			 */
> +			ext4_ext_store_pblock(ex, ext4_ext_pblock(ex) + (b-a));
>  		}
> 
>  		ex->ee_block = cpu_to_le32(block);
> @@ -2321,6 +2420,27 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
>  		if (err)
>  			goto out;
> 
> +		/*
> +		 * If the extent was completely released,
> +		 * we need to remove it from the leaf
> +		 */
> +		if (num == 0) {
> +			if (end != EXT_MAX_BLOCK) {
> +				/*
> +				 * For hole punching, we need to scoot all the
> +				 * extents up when an extent is removed so that
> +				 * we dont have blank extents in the middle
> +				 */
> +				memmove(ex, ex+1, (EXT_LAST_EXTENT(eh) - ex) *
> +					sizeof(struct ext4_extent));
> +
> +				/* Now get rid of the one at the end */
> +				memset(EXT_LAST_EXTENT(eh), 0,
> +					sizeof(struct ext4_extent));
> +			}
> +			le16_add_cpu(&eh->eh_entries, -1);
> +		}
> +
>  		ext_debug("new extent: %u:%u:%llu\n", block, num,
>  				ext4_ext_pblock(ex));
>  		ex--;
> @@ -2361,13 +2481,16 @@ ext4_ext_more_to_rm(struct ext4_ext_path *path)
>  	return 1;
>  }
> 
> -static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start)
> +static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start,
> +				ext4_lblk_t end)
>  {
>  	struct super_block *sb = inode->i_sb;
>  	int depth = ext_depth(inode);
>  	struct ext4_ext_path *path;
> +	struct ext4_extent_header *eh;
> +	struct ext4_extent *ex;
>  	handle_t *handle;
> -	int i, err;
> +	int i, err, last_extent;
> 
>  	ext_debug("truncate since %u\n", start);
> 
> @@ -2400,12 +2523,32 @@ again:
>  	while (i >= 0 && err == 0) {
>  		if (i == depth) {
>  			/* this is leaf block */
> -			err = ext4_ext_rm_leaf(handle, inode, path, start);
> +
> +			eh = path[depth].p_hdr;
> +			if (!eh)
> +				eh = ext_block_hdr(path[depth].p_bh);
> +			if (unlikely(eh == NULL)) {
> +				EXT4_ERROR_INODE(inode,
> +					"path[%d].p_hdr == NULL", depth);
> +				err = -EIO;
> +				break;
> +			}
> +
> +			ex = EXT_FIRST_EXTENT(eh);
> +			last_extent = ex != NULL ?
> +				le32_to_cpu(ex->ee_block) >= start : 0;
> +
> +			err = ext4_ext_rm_leaf(handle, inode, path,
> +					start, end);
>  			/* root level has p_bh == NULL, brelse() eats this */
>  			brelse(path[i].p_bh);
>  			path[i].p_bh = NULL;
>  			i--;
> -			continue;
> +
> +			if (last_extent)
> +				break;
> +			else
> +				continue;
>  		}
> 
>  		/* this is index block */
> @@ -2429,7 +2572,9 @@ again:
>  		ext_debug("level %d - index, first 0x%p, cur 0x%p\n",
>  				i, EXT_FIRST_INDEX(path[i].p_hdr),
>  				path[i].p_idx);
> -		if (ext4_ext_more_to_rm(path + i)) {
> +		if (ext4_ext_more_to_rm(path + i) &&
> +			(path[i].p_idx->ei_block < end)) {
> +
>  			struct buffer_head *bh;
>  			/* go to the next level */
>  			ext_debug("move to level %d (block %llu)\n",
> @@ -3445,7 +3590,7 @@ void ext4_ext_truncate(struct inode *inode)
> 
>  	last_block = (inode->i_size + sb->s_blocksize - 1)
>  			>> EXT4_BLOCK_SIZE_BITS(sb);
> -	err = ext4_ext_remove_space(inode, last_block);
> +	err = ext4_ext_remove_space(inode, last_block, EXT_MAX_BLOCK);
> 
>  	/* In a multi-transaction truncate, we only make the final
>  	 * transaction synchronous.


