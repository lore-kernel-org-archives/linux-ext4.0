From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] ext3: use little-endian bitops directly
Date: Mon, 30 May 2011 16:57:33 +0200
Message-ID: <20110530145733.GE4075@quack.suse.cz>
References: <1306763236-13751-1-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58537 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687Ab1E3O5l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 May 2011 10:57:41 -0400
Content-Disposition: inline
In-Reply-To: <1306763236-13751-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 30-05-11 22:47:15, Akinobu Mita wrote:
> s/ext3_set_bit/__test_and_set_bit_le/
> s/ext3_clear_bit/__test_and_clear_bit_le/
> s/ext3_test_bit/test_bit_le/
> s/ext3_find_first_zero_bit/find_first_zero_bit_le/
> s/ext3_find_next_zero_bit/find_next_zero_bit_le/
> 
> This change reveals that there are some __test_and_{set,clear}_bit_le()
> calls which ignore the return value. These can be replaced with
> __{set,clear}_bit_le().
  OK, after some though this is probably an improvement in readability.
Added to my tree.

								Honza
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: linux-ext4@vger.kernel.org
> ---
>  fs/ext3/balloc.c        |   20 ++++++++++----------
>  fs/ext3/ialloc.c        |    8 ++++----
>  fs/ext3/inode.c         |    2 +-
>  fs/ext3/resize.c        |   14 +++++++-------
>  include/linux/ext3_fs.h |    5 -----
>  5 files changed, 22 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
> index fe52297..8365b3d 100644
> --- a/fs/ext3/balloc.c
> +++ b/fs/ext3/balloc.c
> @@ -112,21 +112,21 @@ static int ext3_valid_block_bitmap(struct super_block *sb,
>  	/* check whether block bitmap block number is set */
>  	bitmap_blk = le32_to_cpu(desc->bg_block_bitmap);
>  	offset = bitmap_blk - group_first_block;
> -	if (!ext3_test_bit(offset, bh->b_data))
> +	if (!test_bit_le(offset, bh->b_data))
>  		/* bad block bitmap */
>  		goto err_out;
>  
>  	/* check whether the inode bitmap block number is set */
>  	bitmap_blk = le32_to_cpu(desc->bg_inode_bitmap);
>  	offset = bitmap_blk - group_first_block;
> -	if (!ext3_test_bit(offset, bh->b_data))
> +	if (!test_bit_le(offset, bh->b_data))
>  		/* bad block bitmap */
>  		goto err_out;
>  
>  	/* check whether the inode table block number is set */
>  	bitmap_blk = le32_to_cpu(desc->bg_inode_table);
>  	offset = bitmap_blk - group_first_block;
> -	next_zero_bit = ext3_find_next_zero_bit(bh->b_data,
> +	next_zero_bit = find_next_zero_bit_le(bh->b_data,
>  				offset + EXT3_SB(sb)->s_itb_per_group,
>  				offset);
>  	if (next_zero_bit >= offset + EXT3_SB(sb)->s_itb_per_group)
> @@ -722,14 +722,14 @@ static int ext3_test_allocatable(ext3_grpblk_t nr, struct buffer_head *bh)
>  	int ret;
>  	struct journal_head *jh = bh2jh(bh);
>  
> -	if (ext3_test_bit(nr, bh->b_data))
> +	if (test_bit_le(nr, bh->b_data))
>  		return 0;
>  
>  	jbd_lock_bh_state(bh);
>  	if (!jh->b_committed_data)
>  		ret = 1;
>  	else
> -		ret = !ext3_test_bit(nr, jh->b_committed_data);
> +		ret = !test_bit_le(nr, jh->b_committed_data);
>  	jbd_unlock_bh_state(bh);
>  	return ret;
>  }
> @@ -752,14 +752,14 @@ bitmap_search_next_usable_block(ext3_grpblk_t start, struct buffer_head *bh,
>  	struct journal_head *jh = bh2jh(bh);
>  
>  	while (start < maxblocks) {
> -		next = ext3_find_next_zero_bit(bh->b_data, maxblocks, start);
> +		next = find_next_zero_bit_le(bh->b_data, maxblocks, start);
>  		if (next >= maxblocks)
>  			return -1;
>  		if (ext3_test_allocatable(next, bh))
>  			return next;
>  		jbd_lock_bh_state(bh);
>  		if (jh->b_committed_data)
> -			start = ext3_find_next_zero_bit(jh->b_committed_data,
> +			start = find_next_zero_bit_le(jh->b_committed_data,
>  							maxblocks, next);
>  		jbd_unlock_bh_state(bh);
>  	}
> @@ -798,7 +798,7 @@ find_next_usable_block(ext3_grpblk_t start, struct buffer_head *bh,
>  		ext3_grpblk_t end_goal = (start + 63) & ~63;
>  		if (end_goal > maxblocks)
>  			end_goal = maxblocks;
> -		here = ext3_find_next_zero_bit(bh->b_data, end_goal, start);
> +		here = find_next_zero_bit_le(bh->b_data, end_goal, start);
>  		if (here < end_goal && ext3_test_allocatable(here, bh))
>  			return here;
>  		ext3_debug("Bit not found near goal\n");
> @@ -845,7 +845,7 @@ claim_block(spinlock_t *lock, ext3_grpblk_t block, struct buffer_head *bh)
>  	if (ext3_set_bit_atomic(lock, block, bh->b_data))
>  		return 0;
>  	jbd_lock_bh_state(bh);
> -	if (jh->b_committed_data && ext3_test_bit(block,jh->b_committed_data)) {
> +	if (jh->b_committed_data && test_bit_le(block, jh->b_committed_data)) {
>  		ext3_clear_bit_atomic(lock, block, bh->b_data);
>  		ret = 0;
>  	} else {
> @@ -1697,7 +1697,7 @@ allocated:
>  		int i;
>  
>  		for (i = 0; i < num; i++) {
> -			if (ext3_test_bit(grp_alloc_blk+i,
> +			if (test_bit_le(grp_alloc_blk + i,
>  					bh2jh(bitmap_bh)->b_committed_data)) {
>  				printk("%s: block was unexpectedly set in "
>  					"b_committed_data\n", __func__);
> diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
> index bfc2dc4..8796fbc 100644
> --- a/fs/ext3/ialloc.c
> +++ b/fs/ext3/ialloc.c
> @@ -460,7 +460,7 @@ struct inode *ext3_new_inode(handle_t *handle, struct inode * dir,
>  		ino = 0;
>  
>  repeat_in_this_group:
> -		ino = ext3_find_next_zero_bit((unsigned long *)
> +		ino = find_next_zero_bit_le(
>  				bitmap_bh->b_data, EXT3_INODES_PER_GROUP(sb), ino);
>  		if (ino < EXT3_INODES_PER_GROUP(sb)) {
>  
> @@ -654,7 +654,7 @@ struct inode *ext3_orphan_get(struct super_block *sb, unsigned long ino)
>  	 * is a valid orphan (no e2fsck run on fs).  Orphans also include
>  	 * inodes that were being truncated, so we can't check i_nlink==0.
>  	 */
> -	if (!ext3_test_bit(bit, bitmap_bh->b_data))
> +	if (!test_bit_le(bit, bitmap_bh->b_data))
>  		goto bad_orphan;
>  
>  	inode = ext3_iget(sb, ino);
> @@ -680,9 +680,9 @@ iget_failed:
>  bad_orphan:
>  	ext3_warning(sb, __func__,
>  		     "bad orphan inode %lu!  e2fsck was run?", ino);
> -	printk(KERN_NOTICE "ext3_test_bit(bit=%d, block=%llu) = %d\n",
> +	printk(KERN_NOTICE "test_bit_le(bit=%d, block=%llu) = %d\n",
>  	       bit, (unsigned long long)bitmap_bh->b_blocknr,
> -	       ext3_test_bit(bit, bitmap_bh->b_data));
> +	       test_bit_le(bit, bitmap_bh->b_data));
>  	printk(KERN_NOTICE "inode=%p\n", inode);
>  	if (inode) {
>  		printk(KERN_NOTICE "is_bad_inode(inode)=%d\n",
> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> index 3451d23..57432a6 100644
> --- a/fs/ext3/inode.c
> +++ b/fs/ext3/inode.c
> @@ -2727,7 +2727,7 @@ static int __ext3_get_inode_loc(struct inode *inode,
>  			for (i = start; i < start + inodes_per_buffer; i++) {
>  				if (i == inode_offset)
>  					continue;
> -				if (ext3_test_bit(i, bitmap_bh->b_data))
> +				if (test_bit_le(i, bitmap_bh->b_data))
>  					break;
>  			}
>  			brelse(bitmap_bh);
> diff --git a/fs/ext3/resize.c b/fs/ext3/resize.c
> index 7916e4c..213a794 100644
> --- a/fs/ext3/resize.c
> +++ b/fs/ext3/resize.c
> @@ -148,7 +148,7 @@ static void mark_bitmap_end(int start_bit, int end_bit, char *bitmap)
>  
>  	ext3_debug("mark end bits +%d through +%d used\n", start_bit, end_bit);
>  	for (i = start_bit; i < ((start_bit + 7) & ~7UL); i++)
> -		ext3_set_bit(i, bitmap);
> +		__test_and_set_bit_le(i, bitmap);
>  	if (i < end_bit)
>  		memset(bitmap + (i >> 3), 0xff, (end_bit - i) >> 3);
>  }
> @@ -222,7 +222,7 @@ static int setup_new_group_blocks(struct super_block *sb,
>  
>  	if (ext3_bg_has_super(sb, input->group)) {
>  		ext3_debug("mark backup superblock %#04lx (+0)\n", start);
> -		ext3_set_bit(0, bh->b_data);
> +		__test_and_set_bit_le(0, bh->b_data);
>  	}
>  
>  	/* Copy all of the GDT blocks into the backup in this group */
> @@ -254,7 +254,7 @@ static int setup_new_group_blocks(struct super_block *sb,
>  			brelse(gdb);
>  			goto exit_bh;
>  		}
> -		ext3_set_bit(bit, bh->b_data);
> +		__test_and_set_bit_le(bit, bh->b_data);
>  		brelse(gdb);
>  	}
>  
> @@ -278,15 +278,15 @@ static int setup_new_group_blocks(struct super_block *sb,
>  			brelse(gdb);
>  			goto exit_bh;
>  		}
> -		ext3_set_bit(bit, bh->b_data);
> +		__test_and_set_bit_le(bit, bh->b_data);
>  		brelse(gdb);
>  	}
>  	ext3_debug("mark block bitmap %#04x (+%ld)\n", input->block_bitmap,
>  		   input->block_bitmap - start);
> -	ext3_set_bit(input->block_bitmap - start, bh->b_data);
> +	__test_and_set_bit_le(input->block_bitmap - start, bh->b_data);
>  	ext3_debug("mark inode bitmap %#04x (+%ld)\n", input->inode_bitmap,
>  		   input->inode_bitmap - start);
> -	ext3_set_bit(input->inode_bitmap - start, bh->b_data);
> +	__test_and_set_bit_le(input->inode_bitmap - start, bh->b_data);
>  
>  	/* Zero out all of the inode table blocks */
>  	for (i = 0, block = input->inode_table, bit = block - start;
> @@ -309,7 +309,7 @@ static int setup_new_group_blocks(struct super_block *sb,
>  			goto exit_bh;
>  		}
>  		brelse(it);
> -		ext3_set_bit(bit, bh->b_data);
> +		__test_and_set_bit_le(bit, bh->b_data);
>  	}
>  
>  	err = extend_or_restart_transaction(handle, 2, bh);
> diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
> index 5e06acf..6caadd0 100644
> --- a/include/linux/ext3_fs.h
> +++ b/include/linux/ext3_fs.h
> @@ -418,13 +418,8 @@ struct ext3_inode {
>  #define EXT2_MOUNT_DATA_FLAGS		EXT3_MOUNT_DATA_FLAGS
>  #endif
>  
> -#define ext3_set_bit			__test_and_set_bit_le
>  #define ext3_set_bit_atomic		ext2_set_bit_atomic
> -#define ext3_clear_bit			__test_and_clear_bit_le
>  #define ext3_clear_bit_atomic		ext2_clear_bit_atomic
> -#define ext3_test_bit			test_bit_le
> -#define ext3_find_first_zero_bit	find_first_zero_bit_le
> -#define ext3_find_next_zero_bit		find_next_zero_bit_le
>  
>  /*
>   * Maximal mount counts between two filesystem checks
> -- 
> 1.7.4.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
