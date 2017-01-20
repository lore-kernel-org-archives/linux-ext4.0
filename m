From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/4] ext4: propagate error values from
 ext4_inline_data_truncate()
Date: Fri, 20 Jan 2017 14:39:38 +0100
Message-ID: <20170120133938.GB10446@quack2.suse.cz>
References: <20170112034938.5934-1-tytso@mit.edu>
 <20170112034938.5934-6-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux@sciencehorizons.net
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49075 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752447AbdATNxw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 20 Jan 2017 08:53:52 -0500
Content-Disposition: inline
In-Reply-To: <20170112034938.5934-6-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 11-01-17 22:49:38, Ted Tso wrote:
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> ---
>  fs/ext4/ext4.h   |  2 +-
>  fs/ext4/inline.c | 40 +++++++++++++++++++++++-----------------
>  fs/ext4/inode.c  |  4 +++-
>  3 files changed, 27 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 6bcb9622fdf9..1cd077e02517 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3023,7 +3023,7 @@ extern int ext4_inline_data_fiemap(struct inode *inode,
>  extern int ext4_try_to_evict_inline_data(handle_t *handle,
>  					 struct inode *inode,
>  					 int needed);
> -extern void ext4_inline_data_truncate(struct inode *inode, int *has_inline);
> +extern int ext4_inline_data_truncate(struct inode *inode, int *has_inline);
>  
>  extern int ext4_convert_inline_data(struct inode *inode);
>  
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index 31f98dd04e51..accd665c5dc0 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -1896,10 +1896,10 @@ int ext4_try_to_evict_inline_data(handle_t *handle,
>  	return error;
>  }
>  
> -void ext4_inline_data_truncate(struct inode *inode, int *has_inline)
> +int ext4_inline_data_truncate(struct inode *inode, int *has_inline)
>  {
>  	handle_t *handle;
> -	int inline_size, value_len, needed_blocks, no_expand;
> +	int inline_size, value_len, needed_blocks, no_expand, err = 0;
>  	size_t i_size;
>  	void *value = NULL;
>  	struct ext4_xattr_ibody_find is = {
> @@ -1914,19 +1914,19 @@ void ext4_inline_data_truncate(struct inode *inode, int *has_inline)
>  	needed_blocks = ext4_writepage_trans_blocks(inode);
>  	handle = ext4_journal_start(inode, EXT4_HT_INODE, needed_blocks);
>  	if (IS_ERR(handle))
> -		return;
> +		return PTR_ERR(handle);
>  
>  	ext4_write_lock_xattr(inode, &no_expand);
>  	if (!ext4_has_inline_data(inode)) {
>  		*has_inline = 0;
>  		ext4_journal_stop(handle);
> -		return;
> +		return 0;
>  	}
>  
> -	if (ext4_orphan_add(handle, inode))
> +	if ((err = ext4_orphan_add(handle, inode)) != 0)
>  		goto out;
>  
> -	if (ext4_get_inode_loc(inode, &is.iloc))
> +	if ((err = ext4_get_inode_loc(inode, &is.iloc)) != 0)
>  		goto out;
>  
>  	down_write(&EXT4_I(inode)->i_data_sem);
> @@ -1937,24 +1937,29 @@ void ext4_inline_data_truncate(struct inode *inode, int *has_inline)
>  	if (i_size < inline_size) {
>  		/* Clear the content in the xattr space. */
>  		if (inline_size > EXT4_MIN_INLINE_DATA_SIZE) {
> -			if (ext4_xattr_ibody_find(inode, &i, &is))
> +			if ((err = ext4_xattr_ibody_find(inode, &i, &is)) != 0)
>  				goto out_error;
>  
>  			BUG_ON(is.s.not_found);
>  
>  			value_len = le32_to_cpu(is.s.here->e_value_size);
>  			value = kmalloc(value_len, GFP_NOFS);
> -			if (!value)
> +			if (!value) {
> +				err = -ENOMEM;
>  				goto out_error;
> +			}
>  
> -			if (ext4_xattr_ibody_get(inode, i.name_index, i.name,
> -						value, value_len))
> +			err = ext4_xattr_ibody_get(inode, i.name_index,
> +						   i.name, value, value_len);
> +			if (err)
>  				goto out_error;
>  
>  			i.value = value;
>  			i.value_len = i_size > EXT4_MIN_INLINE_DATA_SIZE ?
>  					i_size - EXT4_MIN_INLINE_DATA_SIZE : 0;
> -			if (ext4_xattr_ibody_inline_set(handle, inode, &i, &is))
> +			err = ext4_xattr_ibody_inline_set(handle, inode,
> +							  &i, &is);
> +			if (err)
>  				goto out_error;
>  		}
>  
> @@ -1979,13 +1984,14 @@ void ext4_inline_data_truncate(struct inode *inode, int *has_inline)
>  	if (inode->i_nlink)
>  		ext4_orphan_del(handle, inode);
>  
> -	inode->i_mtime = inode->i_ctime = current_time(inode);
> -	ext4_mark_inode_dirty(handle, inode);
> -	if (IS_SYNC(inode))
> -		ext4_handle_sync(handle);
> -
> +	if (err == 0) {
> +		inode->i_mtime = inode->i_ctime = current_time(inode);
> +		err = ext4_mark_inode_dirty(handle, inode);
> +		if (IS_SYNC(inode))
> +			ext4_handle_sync(handle);
> +	}
>  	ext4_journal_stop(handle);
> -	return;
> +	return err;
>  }
>  
>  int ext4_convert_inline_data(struct inode *inode)
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 86dde0667ccc..1e2c881f102d 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4222,7 +4222,9 @@ int ext4_truncate(struct inode *inode)
>  	if (ext4_has_inline_data(inode)) {
>  		int has_inline = 1;
>  
> -		ext4_inline_data_truncate(inode, &has_inline);
> +		err = ext4_inline_data_truncate(inode, &has_inline);
> +		if (err)
> +			return err;
>  		if (has_inline)
>  			return 0;
>  	}
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
