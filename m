From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/4] ext4: avoid calling ext4_mark_inode_dirty() under
 unneeded semaphores
Date: Fri, 20 Jan 2017 14:37:37 +0100
Message-ID: <20170120133737.GA10446@quack2.suse.cz>
References: <20170112034938.5934-1-tytso@mit.edu>
 <20170112034938.5934-5-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux@sciencehorizons.net
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45998 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752485AbdATNhp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 20 Jan 2017 08:37:45 -0500
Content-Disposition: inline
In-Reply-To: <20170112034938.5934-5-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 11-01-17 22:49:37, Ted Tso wrote:
> There is no need to call ext4_mark_inode_dirty while holding xattr_sem
> or i_data_sem, so where it's easy to avoid it, move it out from the
> critical region.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inline.c | 9 +++------
>  fs/ext4/inode.c  | 2 +-
>  2 files changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index 99a5312ced52..31f98dd04e51 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -1042,7 +1042,6 @@ static int ext4_add_dirent_to_inline(handle_t *handle,
>  	dir->i_mtime = dir->i_ctime = current_time(dir);
>  	ext4_update_dx_flag(dir);
>  	dir->i_version++;
> -	ext4_mark_inode_dirty(handle, dir);
>  	return 1;
>  }
>  
> @@ -1311,8 +1310,8 @@ int ext4_try_add_inline_entry(handle_t *handle, struct ext4_filename *fname,
>  	ret = ext4_convert_inline_data_nolock(handle, dir, &iloc);
>  
>  out:
> -	ext4_mark_inode_dirty(handle, dir);
>  	ext4_write_unlock_xattr(dir, &no_expand);
> +	ext4_mark_inode_dirty(handle, dir);
>  	brelse(iloc.bh);
>  	return ret;
>  }
> @@ -1708,13 +1707,11 @@ int ext4_delete_inline_entry(handle_t *handle,
>  	if (err)
>  		goto out;
>  
> -	err = ext4_mark_inode_dirty(handle, dir);
> -	if (unlikely(err))
> -		goto out;
> -
>  	ext4_show_inline_dir(dir, iloc.bh, inline_start, inline_size);
>  out:
>  	ext4_write_unlock_xattr(dir, &no_expand);
> +	if (likely(err == 0))
> +		err = ext4_mark_inode_dirty(handle, dir);
>  	brelse(iloc.bh);
>  	if (err != -ENOENT)
>  		ext4_std_error(dir->i_sb, err);
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 88d57af1b516..86dde0667ccc 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2464,8 +2464,8 @@ static int mpage_map_and_submit_extent(handle_t *handle,
>  			disksize = i_size;
>  		if (disksize > EXT4_I(inode)->i_disksize)
>  			EXT4_I(inode)->i_disksize = disksize;
> -		err2 = ext4_mark_inode_dirty(handle, inode);
>  		up_write(&EXT4_I(inode)->i_data_sem);
> +		err2 = ext4_mark_inode_dirty(handle, inode);
>  		if (err2)
>  			ext4_error(inode->i_sb,
>  				   "Failed to mark inode %lu dirty",
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
