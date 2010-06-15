From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Do not update quota for reserved blocks on error
	paths v3
Date: Tue, 15 Jun 2010 17:51:21 +0200
Message-ID: <20100615155121.GE18513@atrey.karlin.mff.cuni.cz>
References: <1274959030-8001-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:56544 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751201Ab0FOPvW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jun 2010 11:51:22 -0400
Content-Disposition: inline
In-Reply-To: <1274959030-8001-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi Dmitry,

> If we have failed some where inside ext4_get_blocks() internals we may
> have allocated some new blocks, which was not yet claimed to quota.
> We have to free such blocks, but without touching quota. Quota will
> be updated later on exit from ext4_get_blocks().
> The bug hapens on heavily loaded node.
> 
> Changes from v2:
>  - After Eric's quota-patches metadata charged immediately to quota
>    inside new_meta_blocks(), so we have to free quota credits regardless
>    to BLOCKS_RESERVED flag.
> Changes from v1:
>  - Dectement i_allocated_meta_blocks for metadata blocks.
>  - Add some sanity checks.
  I had a look at the patch and I miss two things:
Why do we need EXT4_FREE_BLOCKS_RESERVED flag? Cannot we just directly
use i_delalloc_reserved?
  Also adding EXT4_FREE_BLOCKS_METADATA to some calls will also result
in avoiding to reallocate these blocks for the same transaction. Why
do you do this?

  Besides that a few style / language nitpicks:
Please use empty line to separate variable declaration and code. It's
a good custom followed in most places of the kernel.

> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 377309c..e3cc230 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3528,12 +3532,16 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
>  	}
>  	err = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
>  	if (err) {
> -		/* free data blocks we just allocated */
> -		/* not a good idea to call discard here directly,
> -		 * but otherwise we'd need to call it every free() */
> +		int fb_flags = 0;
> +		/* free data blocks we just allocated
> +		 * Not a good idea to call discard here directly,
> +		 * but otherwise we'd need to call it every free().
> +		 * On delalloc blocks are not yet accounted to quota */
  I have some troubles understanding the above comment so if you actually
know what 'discard' and 'free()' mean in this context, please update it.
Otherwise, just leave it...
  Also suggested format for multiline comments is:
/*
 *  Some text
 *  more text
 */

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 502b07d..c3b4443 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
...
>  }
> -
  This removal of empty line is unintended?

>  }
> -
  And this one as well?
>  /*
>   * The ext4_ind_map_blocks() function handles non-extents inodes
>   * (i.e., using the traditional indirect/double-indirect i_blocks
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 12b3bc0..c87243b 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4682,11 +4684,46 @@ do_more:
>  	}
>  	sb->s_dirt = 1;
>  error_return:
> -	if (freed)
> -		dquot_free_block(inode, freed);
> +	/*  Update quotas */
          ^ Superfluous space

> +	if (freed) {
> +		if (!(res_fl & EXT4_FREE_BLOCKS_RESERVED)) {
> +			dquot_free_block(inode, freed);
> +			goto out;
> +		}
> +		/* Blocks reserved case */
                ^ Do we really need this comment? It seems obvious...

> +		if (res_fl & EXT4_FREE_BLOCKS_METADATA) {
> +			/*
> +			 * Meta data blocks was charged to quota and to
                                            ^^^ were
> +			 * inode's mblock alloc counter in
                                   ^^^^^^^^^^^^ mballoc?
> +			 * ext4_new_meta_blocks(). */
                                                   ^^ put on a separate line
> +			spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
> +			if (EXT4_I(inode)->i_allocated_meta_blocks <
> +				freed)
  Line wrap doesn't seem to be needed above...

> +				goto rsv_error;
> +			EXT4_I(inode)->i_allocated_meta_blocks -= freed;
> +			spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> +			dquot_free_block(inode, freed);
> +		} else {
> +			/* Data blocks allocated was reserved, but not yet
                                                 ^^^ were
> +			 * claimed to quota. Caller is responsibleo for
                                                                ^^^ remove 'o'
> +			 * quota reservation update. */
> +		}
> +	}
> +out:
>  	brelse(bitmap_bh);
>  	ext4_std_error(sb, err);
>  	if (ac)
>  		kmem_cache_free(ext4_ac_cachep, ac);
>  	return;
> +
> +rsv_error:
> +	ext4_msg(sb, KERN_ERR," inode %ld, reservation counters goes"
                                                                ^^^^ are?
> +		" inconsistent rsv_data=%u, rsv_mdata=%u, alloc_mblk=%u"
> +		" freed=%lu", inode->i_ino,
> +		EXT4_I(inode)->i_reserved_data_blocks,
> +		EXT4_I(inode)->i_reserved_meta_blocks,
> +		EXT4_I(inode)->i_allocated_meta_blocks, freed);
> +	EXT4_I(inode)->i_allocated_meta_blocks = 0;
> +	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> +	goto out;
>  }
> -- 
> 1.6.6.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
