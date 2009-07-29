From: Mingming <cmm@us.ibm.com>
Subject: Re: [PATCH RFC] Insure direct IO writes do not use the page cache
Date: Wed, 29 Jul 2009 10:47:03 -0700
Message-ID: <1248889623.4035.63.camel@mingming-laptop>
References: <6601abe90907281728h22be79fenc68a16b578e28a91@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:49527 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbZG2RrG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Jul 2009 13:47:06 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e38.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n6THhdsI021415
	for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2009 11:43:39 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n6THl6mG204606
	for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2009 11:47:06 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n6THl56H019339
	for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2009 11:47:05 -0600
In-Reply-To: <6601abe90907281728h22be79fenc68a16b578e28a91@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2009-07-28 at 17:28 -0700, Curt Wohlgemuth wrote:
> This insures that direct IO writes to fallocate'd file space do not use the
> page cache.
> 
> 
>       Signed-off-by: Curt Wohlgemuth <curtw@google.com>
> 
> ---
> 
> I implemented Aneesh's ideas for this solution, but have some questions.
> 
> I've verified that the page cache isn't  used, regardless of whether
> FALLOC_FL_KEEP_SIZE is used in the fallocate() call or not.
> 
> The changes:
>    - New inode state flag to indicate that a DIO write is ongoing
> 
>    - ext4_ext_convert_to_initialized() will mark any new extent it creates
>      as uninitialized, if this new EXT4_STATE_DIO_WRITE flag is set.
> 
>    - ext4_direct_IO() will set this flag for any write.
> 
>      It now calls blockdev_direct_IO_own_locking() to do the I/O.
> 
>      After return from blockdev_direct_IO_own_locking() it clears the flag
>      and calls a new routine to mark all extents containing the returned
>      blocks as initialized.
> 
> I'm a bit uncertain about the use of DIO_OWN_LOCKING; I looked at the XFS
> code to see if it acquired any other locks while using this flag, but didn't
> see any.  Suggestions/corrections welcome.
> 

I was coding up something different approach, but you beat me first:)

I looked at your patch briefly, I am not sure about using
DIO_OWN_LOCKING directly. For writes, that requires filesystem to handle
the race between the buffered IO and direct IO, assuming i_mutex is not
hold for write. But in ext4 case, since we use the generic routine, we
already hold the inode's i_mutex for write. Not sure if that would cause
any locking problem though...

XFS seems hold the i_mutex if it founds there are dirty pages in cache,
but in the case of no dirty pages, it will drop the lock completely.
during the DIO IO the lock is not hold at all.

Mingming
> 
> diff -Naur orig/fs/ext4/ext4.h new/fs/ext4/ext4.h
> --- orig/fs/ext4/ext4.h	2009-07-28 17:02:25.000000000 -0700
> +++ new/fs/ext4/ext4.h	2009-07-28 17:02:19.000000000 -0700
> @@ -272,6 +272,7 @@
>  #define EXT4_STATE_XATTR		0x00000004 /* has in-inode xattrs */
>  #define EXT4_STATE_NO_EXPAND		0x00000008 /* No space for expansion */
>  #define EXT4_STATE_DA_ALLOC_CLOSE	0x00000010 /* Alloc DA blks on close */
> +#define EXT4_STATE_DIO_WRITE		0x00000020 /* This is a DIO write */
> 
>  /* Used to pass group descriptor data when online resize is done */
>  struct ext4_new_group_input {
> diff -Naur orig/fs/ext4/ext4_extents.h new/fs/ext4/ext4_extents.h
> --- orig/fs/ext4/ext4_extents.h	2009-07-28 17:02:40.000000000 -0700
> +++ new/fs/ext4/ext4_extents.h	2009-07-28 17:02:34.000000000 -0700
> @@ -242,5 +242,7 @@
>  						ext4_lblk_t *, ext4_fsblk_t *);
>  extern void ext4_ext_drop_refs(struct ext4_ext_path *);
>  extern int ext4_ext_check_inode(struct inode *inode);
> +extern int ext4_ext_mark_extents_init(struct inode *inode, loff_t offset,
> +							int nr_bytes);
>  #endif /* _EXT4_EXTENTS */
> 
> diff -Naur orig/fs/ext4/extents.c new/fs/ext4/extents.c
> --- orig/fs/ext4/extents.c	2009-07-28 17:02:54.000000000 -0700
> +++ new/fs/ext4/extents.c	2009-07-28 17:02:49.000000000 -0700
> @@ -2563,6 +2563,13 @@
>  			ex3->ee_block = cpu_to_le32(iblock);
>  			ext4_ext_store_pblock(ex3, newblock);
>  			ex3->ee_len = cpu_to_le16(allocated);
> +
> +			/* For direct I/O, we mark this as uninitialized, and
> +			 * set it as initialized when we finish the direct
> +			 * IO. */
> +			if (EXT4_I(inode)->i_state & EXT4_STATE_DIO_WRITE)
> +				ext4_ext_mark_uninitialized(ex3);
> +
>  			err = ext4_ext_insert_extent(handle, inode, path, ex3);
>  			if (err == -ENOSPC) {
>  				err =  ext4_ext_zeroout(inode, &orig_ex);
> @@ -2698,6 +2705,13 @@
>  	ex2->ee_block = cpu_to_le32(iblock);
>  	ext4_ext_store_pblock(ex2, newblock);
>  	ex2->ee_len = cpu_to_le16(allocated);
> +
> +	/* For direct I/O, we mark this as uninitialized, and
> +	 * set it as initialized when we finish the direct
> +	 * IO. */
> +	if (EXT4_I(inode)->i_state & EXT4_STATE_DIO_WRITE)
> +		ext4_ext_mark_uninitialized(ex2);
> +
>  	if (ex2 != ex)
>  		goto insert;
>  	/*
> @@ -2763,6 +2777,109 @@
>  	return err;
>  }
> 
> +
> +static int handle_uninit_extent(struct ext4_ext_path *path,
> +				struct inode *inode,
> +				struct ext4_extent *ex)
> +{
> +	handle_t *handle;
> +	int credits;
> +	int started;
> +	int depth = ext_depth(inode);
> +	int ret = 0;
> +
> +	if (ext4_ext_is_uninitialized(ex)) {
> +		handle = ext4_journal_current_handle();
> +		started = 0;
> +
> +		if (!handle) {
> +			credits =
> +			     ext4_chunk_trans_blocks(inode, 1);
> +			handle = ext4_journal_start(inode,
> +						    credits);
> +			if (IS_ERR(handle)) {
> +				ret = PTR_ERR(handle);
> +				goto out;
> +			}
> +			started = 1;
> +		}
> +		/* Mark as initialized */
> +		ex->ee_len = cpu_to_le16(ext4_ext_get_actual_len(ex));
> +
> +		ret = ext4_ext_dirty(handle, inode, path + depth);
> +
> +		if (started)
> +			ext4_journal_stop(handle);
> +	}
> +out:
> +	return ret;
> +}
> +
> +/* Called after direct I/O writes, to make sure that all extents are marked
> + * as initialized. */
> +int ext4_ext_mark_extents_init(struct inode *inode,
> +				loff_t offset,
> +				int nr_bytes)
> +{
> +	struct ext4_ext_path *path = NULL;
> +	struct ext4_extent *ex;
> +	int depth;
> +	int nr_blocks = nr_bytes >> inode->i_blkbits;
> +	ext4_lblk_t first_block = offset >> inode->i_blkbits;
> +	ext4_lblk_t block;
> +	int ret;
> +
> +	/* Handle the extent for the first block */
> +	path  = ext4_ext_find_extent(inode, first_block, NULL);
> +	if (IS_ERR(path)) {
> +		ret = PTR_ERR(path);
> +		path = NULL;
> +		goto out;
> +	}
> +	depth = ext_depth(inode);
> +	ex    = path[depth].p_ext;
> +
> +	ret = handle_uninit_extent(path, inode, ex);
> +	if (ret != 0) {
> +		goto out;
> +	}
> +
> +	/* Check the rest of the blocks; if they're in different
> +	 * extents, handle those as well. */
> +	for (block = first_block + 1;
> +	     block < first_block + nr_blocks;
> +	     block++) {
> +
> +		/* Only look for new extents now */
> +		if (block >= ex->ee_block &&
> +				block < (ex->ee_block + ex->ee_len))
> +			continue;
> +
> +		ext4_ext_drop_refs(path);
> +		path  = ext4_ext_find_extent(inode, first_block, path);
> +		if (IS_ERR(path)) {
> +			ret = PTR_ERR(path);
> +			path = NULL;
> +			goto out;
> +		}
> +		depth = ext_depth(inode);
> +		ex    = path[depth].p_ext;
> +
> +		ret = handle_uninit_extent(path, inode, ex);
> +		if (ret != 0) {
> +			goto out;
> +		}
> +	}
> +out:
> +	if (path) {
> +		ext4_ext_drop_refs(path);
> +		kfree(path);
> +	}
> +
> +	return ret;
> +}
> +
> +
>  /*
>   * Block allocation/map/preallocation routine for extents based files
>   *
> diff -Naur orig/fs/ext4/inode.c new/fs/ext4/inode.c
> --- orig/fs/ext4/inode.c	2009-07-28 17:02:04.000000000 -0700
> +++ new/fs/ext4/inode.c	2009-07-28 17:23:59.000000000 -0700
> @@ -3318,11 +3318,33 @@
>  			ei->i_disksize = inode->i_size;
>  			ext4_journal_stop(handle);
>  		}
> -	}
> +		/* This prevents initializing extents too early */
> +		if (ei->i_flags & EXT4_EXTENTS_FL)
> +			ei->i_state |= EXT4_STATE_DIO_WRITE;
> +	}
> +
> +	ret = blockdev_direct_IO_own_locking(rw, iocb, inode,
> +						inode->i_sb->s_bdev, iov,
> +						offset, nr_segs,
> +						ext4_get_block, NULL);
> +
> +	/* We now need to look at all extents for the blocks that were
> +	 * written out, and mark them as initialized.  Note that they've
> +	 * already been converted, simply not yet marked as init. */
> +	if (rw == WRITE && ei->i_flags & EXT4_EXTENTS_FL) {
> +		BUG_ON((ei->i_state & EXT4_STATE_DIO_WRITE) == 0);
> +		ei->i_state |= ~EXT4_STATE_DIO_WRITE;
> +
> +		if (ret > 0) {
> +			int ret2;
> 
> -	ret = blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
> -				 offset, nr_segs,
> -				 ext4_get_block, NULL);
> +			ret2 = ext4_ext_mark_extents_init(inode, offset, ret);
> +			if (ret2 != 0) {
> +				ret = ret2;
> +				goto out;
> +			}
> +		}
> +	}
> 
>  	if (orphan) {
>  		int err;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


