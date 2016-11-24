From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] ext4: allow ext4_ext_truncate() to return an error
Date: Thu, 24 Nov 2016 13:42:48 +0100
Message-ID: <20161124124248.GG24138@quack2.suse.cz>
References: <20161113223312.10531-1-tytso@mit.edu>
 <20161113223312.10531-2-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33119 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941049AbcKXMm7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 24 Nov 2016 07:42:59 -0500
Content-Disposition: inline
In-Reply-To: <20161113223312.10531-2-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 13-11-16 17:33:12, Ted Tso wrote:
> Return errors to the caller instead of declaring the file system
> corrupted.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/ext4.h    |  2 +-
>  fs/ext4/extents.c | 15 +++++++--------
>  fs/ext4/inode.c   |  4 +++-
>  3 files changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index be2282dcde7d..54211c7876f8 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3128,7 +3128,7 @@ extern int ext4_ext_writepage_trans_blocks(struct inode *, int);
>  extern int ext4_ext_index_trans_blocks(struct inode *inode, int extents);
>  extern int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
>  			       struct ext4_map_blocks *map, int flags);
> -extern void ext4_ext_truncate(handle_t *, struct inode *);
> +extern int ext4_ext_truncate(handle_t *, struct inode *);
>  extern int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start,
>  				 ext4_lblk_t end);
>  extern void ext4_ext_init(struct super_block *);
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index c930a0110fb4..d3b119499c53 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4631,7 +4631,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
>  	return err ? err : allocated;
>  }
>  
> -void ext4_ext_truncate(handle_t *handle, struct inode *inode)
> +int ext4_ext_truncate(handle_t *handle, struct inode *inode)
>  {
>  	struct super_block *sb = inode->i_sb;
>  	ext4_lblk_t last_block;
> @@ -4645,7 +4645,9 @@ void ext4_ext_truncate(handle_t *handle, struct inode *inode)
>  
>  	/* we have to know where to truncate from in crash case */
>  	EXT4_I(inode)->i_disksize = inode->i_size;
> -	ext4_mark_inode_dirty(handle, inode);
> +	err = ext4_mark_inode_dirty(handle, inode);
> +	if (err)
> +		return err;
>  
>  	last_block = (inode->i_size + sb->s_blocksize - 1)
>  			>> EXT4_BLOCK_SIZE_BITS(sb);
> @@ -4657,12 +4659,9 @@ void ext4_ext_truncate(handle_t *handle, struct inode *inode)
>  		congestion_wait(BLK_RW_ASYNC, HZ/50);
>  		goto retry;
>  	}
> -	if (err) {
> -		ext4_std_error(inode->i_sb, err);
> -		return;
> -	}
> -	err = ext4_ext_remove_space(inode, last_block, EXT_MAX_BLOCKS - 1);
> -	ext4_std_error(inode->i_sb, err);
> +	if (err)
> +		return err;
> +	return ext4_ext_remove_space(inode, last_block, EXT_MAX_BLOCKS - 1);
>  }
>  
>  static int ext4_alloc_file_blocks(struct file *file, ext4_lblk_t offset,
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 40ea090d2e0e..7f32899c9701 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4167,11 +4167,13 @@ int ext4_truncate(struct inode *inode)
>  	ext4_discard_preallocations(inode);
>  
>  	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
> -		ext4_ext_truncate(handle, inode);
> +		err = ext4_ext_truncate(handle, inode);
>  	else
>  		ext4_ind_truncate(handle, inode);
>  
>  	up_write(&ei->i_data_sem);
> +	if (err)
> +		goto out_stop;
>  
>  	if (IS_SYNC(inode))
>  		ext4_handle_sync(handle);
> -- 
> 2.11.0.rc0.7.gbe5a750
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
