From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/3] ext4: add i_data_sem sanity check
Date: Mon, 21 Jul 2014 21:35:10 +0200
Message-ID: <20140721193510.GA19942@quack.suse.cz>
References: <1405955089-12777-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57233 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933534AbaGUTfO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Jul 2014 15:35:14 -0400
Content-Disposition: inline
In-Reply-To: <1405955089-12777-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 21-07-14 19:04:47, Dmitry Monakhov wrote:
> Each caller of ext4_ext_dirty must hold i_data_sem,
> The only exception is migration code, let's make it convenient.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
  Looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/extents.c |    2 ++
>  fs/ext4/migrate.c |    7 +++++++
>  2 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index b30172d..ee93f82 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -161,6 +161,8 @@ int __ext4_ext_dirty(const char *where, unsigned int line, handle_t *handle,
>  		     struct inode *inode, struct ext4_ext_path *path)
>  {
>  	int err;
> +
> +	WARN_ON(!rwsem_is_locked(&EXT4_I(inode)->i_data_sem));
>  	if (path->p_bh) {
>  		ext4_extent_block_csum_set(inode, ext_block_hdr(path->p_bh));
>  		/* path points to block */
> diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
> index ec09243..d3567f2 100644
> --- a/fs/ext4/migrate.c
> +++ b/fs/ext4/migrate.c
> @@ -39,6 +39,8 @@ static int finish_range(handle_t *handle, struct inode *inode,
>  	newext.ee_block = cpu_to_le32(lb->first_block);
>  	newext.ee_len   = cpu_to_le16(lb->last_block - lb->first_block + 1);
>  	ext4_ext_store_pblock(&newext, lb->first_pblock);
> +	/* Locking only for convinience since we are operating on temp inode */
> +	down_write(&EXT4_I(inode)->i_data_sem);
>  	path = ext4_ext_find_extent(inode, lb->first_block, NULL, 0);
>  
>  	if (IS_ERR(path)) {
> @@ -61,7 +63,9 @@ static int finish_range(handle_t *handle, struct inode *inode,
>  	 */
>  	if (needed && ext4_handle_has_enough_credits(handle,
>  						EXT4_RESERVE_TRANS_BLOCKS)) {
> +		up_write((&EXT4_I(inode)->i_data_sem));
>  		retval = ext4_journal_restart(handle, needed);
> +		down_write((&EXT4_I(inode)->i_data_sem));
>  		if (retval)
>  			goto err_out;
>  	} else if (needed) {
> @@ -70,13 +74,16 @@ static int finish_range(handle_t *handle, struct inode *inode,
>  			/*
>  			 * IF not able to extend the journal restart the journal
>  			 */
> +			up_write((&EXT4_I(inode)->i_data_sem));
>  			retval = ext4_journal_restart(handle, needed);
> +			down_write((&EXT4_I(inode)->i_data_sem));
>  			if (retval)
>  				goto err_out;
>  		}
>  	}
>  	retval = ext4_ext_insert_extent(handle, inode, path, &newext, 0);
>  err_out:
> +	up_write((&EXT4_I(inode)->i_data_sem));
>  	if (path) {
>  		ext4_ext_drop_refs(path);
>  		kfree(path);
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
