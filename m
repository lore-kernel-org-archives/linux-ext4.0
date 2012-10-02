From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] ext3: ext3_bread usage audit
Date: Tue, 2 Oct 2012 15:55:13 +0200
Message-ID: <20121002135513.GE22777@quack.suse.cz>
References: <1349121055-8168-1-git-send-email-cmaiolino@redhat.com>
 <1349121055-8168-3-git-send-email-cmaiolino@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Carlos Maiolino <cmaiolino@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59101 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654Ab2JBNzP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Oct 2012 09:55:15 -0400
Content-Disposition: inline
In-Reply-To: <1349121055-8168-3-git-send-email-cmaiolino@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 01-10-12 16:50:55, Carlos Maiolino wrote:
> This is the ext3 version of the same patch applied to Ext4, where such goal is
> to audit the usage of ext3_bread() due a possible misinterpretion of its return
> value.
> 
> Focused on directory blocks, a NULL value returned from ext3_bread() means a
> hole, which cannot exist into a directory inode. It can pass undetected after a
> fix in an uninitialized error variable.
> 
> The (now) initialized variable into ext3_getblk() may lead to a zero'ed return
> value of ext3_bread() to its callers, which can make the caller do not detect
> the hole in the directory inode.
> 
> This checks for directory holes when buffer_head and error value are both
> zero'ed returning -EIO to their callers
> 
> Some ext3_bread() callers do not needed any changes either because they already
> had its own hole detector paths or because these are deprecaded (like
> dx_show_entries)
  Umm, can you wrap the check for hole + error message in a helper function
like ext3_dir_bread() please? That would save us quite some dupplication..
Thanks!

								Honza

> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/ext3/namei.c | 75 ++++++++++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 66 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
> index 7f6c938..8e56c2cc 100644
> --- a/fs/ext3/namei.c
> +++ b/fs/ext3/namei.c
> @@ -56,6 +56,11 @@ static struct buffer_head *ext3_append(handle_t *handle,
>  			bh = NULL;
>  		}
>  	}
> +	if (!bh && !(*err)) {
> +		*err = -EIO;
> +		ext3_error(inode->i_sb, __func__,
> +			   "Directory hole detected on inode %lu\n", inode->i_ino);
> +	}
>  	return bh;
>  }
>  
> @@ -339,8 +344,11 @@ dx_probe(struct qstr *entry, struct inode *dir,
>  	u32 hash;
>  
>  	frame->bh = NULL;
> -	if (!(bh = ext3_bread (NULL,dir, 0, 0, err)))
> +	if (!(bh = ext3_bread (NULL,dir, 0, 0, err))) {
> +		if (!(*err))
> +			*err = ERR_BAD_DX_DIR;
>  		goto fail;
> +	}
>  	root = (struct dx_root *) bh->b_data;
>  	if (root->info.hash_version != DX_HASH_TEA &&
>  	    root->info.hash_version != DX_HASH_HALF_MD4 &&
> @@ -436,8 +444,11 @@ dx_probe(struct qstr *entry, struct inode *dir,
>  		frame->entries = entries;
>  		frame->at = at;
>  		if (!indirect--) return frame;
> -		if (!(bh = ext3_bread (NULL,dir, dx_get_block(at), 0, err)))
> +		if (!(bh = ext3_bread (NULL,dir, dx_get_block(at), 0, err))) {
> +			if (!(*err))
> +				*err = ERR_BAD_DX_DIR;
>  			goto fail2;
> +		}
>  		at = entries = ((struct dx_node *) bh->b_data)->entries;
>  		if (dx_get_limit(entries) != dx_node_limit (dir)) {
>  			ext3_warning(dir->i_sb, __func__,
> @@ -536,8 +547,15 @@ static int ext3_htree_next_block(struct inode *dir, __u32 hash,
>  	 */
>  	while (num_frames--) {
>  		if (!(bh = ext3_bread(NULL, dir, dx_get_block(p->at),
> -				      0, &err)))
> +				      0, &err))) {
> +			if (!err) {
> +				ext3_error(dir->i_sb, __func__,
> +					   "Directory hole detected on inode %lu\n",
> +					   dir->i_ino);
> +				return -EIO;
> +			}
>  			return err; /* Failure */
> +		}
>  		p++;
>  		brelse (p->bh);
>  		p->bh = bh;
> @@ -562,8 +580,15 @@ static int htree_dirblock_to_tree(struct file *dir_file,
>  	int err = 0, count = 0;
>  
>  	dxtrace(printk("In htree dirblock_to_tree: block %d\n", block));
> -	if (!(bh = ext3_bread (NULL, dir, block, 0, &err)))
> +	if (!(bh = ext3_bread (NULL, dir, block, 0, &err))) {
> +		if (!err) {
> +			ext3_error(dir->i_sb, __func__,
> +				   "Directory hole detected on inode %lu\n",
> +				   dir->i_ino);
> +			return -EIO;
> +		}
>  		return err;
> +	}
>  
>  	de = (struct ext3_dir_entry_2 *) bh->b_data;
>  	top = (struct ext3_dir_entry_2 *) ((char *) de +
> @@ -976,8 +1001,15 @@ static struct buffer_head * ext3_dx_find_entry(struct inode *dir,
>  		return NULL;
>  	do {
>  		block = dx_get_block(frame->at);
> -		if (!(bh = ext3_bread (NULL,dir, block, 0, err)))
> +		if (!(bh = ext3_bread (NULL,dir, block, 0, err))) {
> +			if (!(*err)) {
> +				*err = -EIO;
> +				ext3_error(dir->i_sb, __func__,
> +					   "Directory hole detected on inode %lu\n",
> +					   dir->i_ino);
> +			}
>  			goto errout;
> +		}
>  
>  		retval = search_dirblock(bh, dir, entry,
>  					 block << EXT3_BLOCK_SIZE_BITS(sb),
> @@ -1458,9 +1490,15 @@ static int ext3_add_entry (handle_t *handle, struct dentry *dentry,
>  	}
>  	blocks = dir->i_size >> sb->s_blocksize_bits;
>  	for (block = 0; block < blocks; block++) {
> -		bh = ext3_bread(handle, dir, block, 0, &retval);
> -		if(!bh)
> +		if (!(bh = ext3_bread(handle, dir, block, 0, &retval))) {
> +			if (!retval) {
> +				retval = -EIO;
> +				ext3_error(dir->i_sb, __func__,
> +					   "Directory hole detected on inode %lu\n",
> +					   dir->i_ino);
> +			}
>  			return retval;
> +		}
>  		retval = add_dirent_to_buf(handle, dentry, inode, NULL, bh);
>  		if (retval != -ENOSPC)
>  			return retval;
> @@ -1500,8 +1538,15 @@ static int ext3_dx_add_entry(handle_t *handle, struct dentry *dentry,
>  	entries = frame->entries;
>  	at = frame->at;
>  
> -	if (!(bh = ext3_bread(handle,dir, dx_get_block(frame->at), 0, &err)))
> +	if (!(bh = ext3_bread(handle,dir, dx_get_block(frame->at), 0, &err))) {
> +		if (!err) {
> +			err = -EIO;
> +			ext3_error(dir->i_sb, __func__,
> +				   "Directory hole detected on inode %lu\n",
> +				   dir->i_ino);
> +		}
>  		goto cleanup;
> +	}
>  
>  	BUFFER_TRACE(bh, "get_write_access");
>  	err = ext3_journal_get_write_access(handle, bh);
> @@ -1791,8 +1836,15 @@ retry:
>  	inode->i_fop = &ext3_dir_operations;
>  	inode->i_size = EXT3_I(inode)->i_disksize = inode->i_sb->s_blocksize;
>  	dir_block = ext3_bread (handle, inode, 0, 1, &err);
> -	if (!dir_block)
> +	if (!dir_block) {
> +		if (!err) {
> +			err = -EIO;
> +			ext3_error(inode->i_sb, __func__,
> +				   "Directory hole detected on inode %lu\n",
> +				   inode->i_ino);
> +			}
>  		goto out_clear_inode;
> +	}
>  
>  	BUFFER_TRACE(dir_block, "get_write_access");
>  	err = ext3_journal_get_write_access(handle, dir_block);
> @@ -1898,6 +1950,11 @@ static int empty_dir (struct inode * inode)
>  						   "error %d reading directory"
>  						   " #%lu offset %lu",
>  						   err, inode->i_ino, offset);
> +				else
> +					ext3_warning(inode->i_sb, __func__,
> +						     "bad directory (dir #%lu) - no data block",
> +						     inode->i_ino);
> +
>  				offset += sb->s_blocksize;
>  				continue;
>  			}
> -- 
> 1.7.11.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
