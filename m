From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] ext3: ext3_bread usage audit [V2]
Date: Thu, 4 Oct 2012 14:42:12 +0200
Message-ID: <20121004124212.GG4641@quack.suse.cz>
References: <1349121055-8168-3-git-send-email-cmaiolino@redhat.com>
 <1349233163-16178-1-git-send-email-cmaiolino@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Carlos Maiolino <cmaiolino@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34513 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756381Ab2JDMmP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Oct 2012 08:42:15 -0400
Content-Disposition: inline
In-Reply-To: <1349233163-16178-1-git-send-email-cmaiolino@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 02-10-12 23:59:23, Carlos Maiolino wrote:
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
> 
> V2: It adds a wrapper function ext3_dir_bread() to check for directory holes
> when reading blocks for a directory inode, and callers of ext3_bread() to read
> directory blocks were replaced by this wrapper.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
  Oh, I see you already sent V2. Thanks. I've put the patch to my tree.

								Honza

> ---
>  fs/ext3/namei.c | 36 +++++++++++++++++++-----------------
>  fs/ext3/namei.h | 19 +++++++++++++++++++
>  2 files changed, 38 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
> index 7f6c938..0eecf4d 100644
> --- a/fs/ext3/namei.c
> +++ b/fs/ext3/namei.c
> @@ -46,8 +46,7 @@ static struct buffer_head *ext3_append(handle_t *handle,
>  
>  	*block = inode->i_size >> inode->i_sb->s_blocksize_bits;
>  
> -	bh = ext3_bread(handle, inode, *block, 1, err);
> -	if (bh) {
> +	if ((bh = ext3_dir_bread(handle, inode, *block, 1, err))) {
>  		inode->i_size += inode->i_sb->s_blocksize;
>  		EXT3_I(inode)->i_disksize = inode->i_size;
>  		*err = ext3_journal_get_write_access(handle, bh);
> @@ -339,8 +338,10 @@ dx_probe(struct qstr *entry, struct inode *dir,
>  	u32 hash;
>  
>  	frame->bh = NULL;
> -	if (!(bh = ext3_bread (NULL,dir, 0, 0, err)))
> +	if (!(bh = ext3_dir_bread(NULL, dir, 0, 0, err))) {
> +		*err = ERR_BAD_DX_DIR;
>  		goto fail;
> +	}
>  	root = (struct dx_root *) bh->b_data;
>  	if (root->info.hash_version != DX_HASH_TEA &&
>  	    root->info.hash_version != DX_HASH_HALF_MD4 &&
> @@ -436,8 +437,10 @@ dx_probe(struct qstr *entry, struct inode *dir,
>  		frame->entries = entries;
>  		frame->at = at;
>  		if (!indirect--) return frame;
> -		if (!(bh = ext3_bread (NULL,dir, dx_get_block(at), 0, err)))
> +		if (!(bh = ext3_dir_bread(NULL, dir, dx_get_block(at), 0, err))) {
> +			*err = ERR_BAD_DX_DIR;
>  			goto fail2;
> +		}
>  		at = entries = ((struct dx_node *) bh->b_data)->entries;
>  		if (dx_get_limit(entries) != dx_node_limit (dir)) {
>  			ext3_warning(dir->i_sb, __func__,
> @@ -535,8 +538,8 @@ static int ext3_htree_next_block(struct inode *dir, __u32 hash,
>  	 * block so no check is necessary
>  	 */
>  	while (num_frames--) {
> -		if (!(bh = ext3_bread(NULL, dir, dx_get_block(p->at),
> -				      0, &err)))
> +		if (!(bh = ext3_dir_bread(NULL, dir, dx_get_block(p->at),
> +					  0, &err)))
>  			return err; /* Failure */
>  		p++;
>  		brelse (p->bh);
> @@ -562,7 +565,8 @@ static int htree_dirblock_to_tree(struct file *dir_file,
>  	int err = 0, count = 0;
>  
>  	dxtrace(printk("In htree dirblock_to_tree: block %d\n", block));
> -	if (!(bh = ext3_bread (NULL, dir, block, 0, &err)))
> +
> +	if (!(bh = ext3_dir_bread(NULL, dir, block, 0, &err)))
>  		return err;
>  
>  	de = (struct ext3_dir_entry_2 *) bh->b_data;
> @@ -976,7 +980,7 @@ static struct buffer_head * ext3_dx_find_entry(struct inode *dir,
>  		return NULL;
>  	do {
>  		block = dx_get_block(frame->at);
> -		if (!(bh = ext3_bread (NULL,dir, block, 0, err)))
> +		if (!(bh = ext3_dir_bread (NULL, dir, block, 0, err)))
>  			goto errout;
>  
>  		retval = search_dirblock(bh, dir, entry,
> @@ -1458,9 +1462,9 @@ static int ext3_add_entry (handle_t *handle, struct dentry *dentry,
>  	}
>  	blocks = dir->i_size >> sb->s_blocksize_bits;
>  	for (block = 0; block < blocks; block++) {
> -		bh = ext3_bread(handle, dir, block, 0, &retval);
> -		if(!bh)
> +		if (!(bh = ext3_dir_bread(handle, dir, block, 0, &retval)))
>  			return retval;
> +
>  		retval = add_dirent_to_buf(handle, dentry, inode, NULL, bh);
>  		if (retval != -ENOSPC)
>  			return retval;
> @@ -1500,7 +1504,7 @@ static int ext3_dx_add_entry(handle_t *handle, struct dentry *dentry,
>  	entries = frame->entries;
>  	at = frame->at;
>  
> -	if (!(bh = ext3_bread(handle,dir, dx_get_block(frame->at), 0, &err)))
> +	if (!(bh = ext3_dir_bread(handle, dir, dx_get_block(frame->at), 0, &err)))
>  		goto cleanup;
>  
>  	BUFFER_TRACE(bh, "get_write_access");
> @@ -1790,8 +1794,7 @@ retry:
>  	inode->i_op = &ext3_dir_inode_operations;
>  	inode->i_fop = &ext3_dir_operations;
>  	inode->i_size = EXT3_I(inode)->i_disksize = inode->i_sb->s_blocksize;
> -	dir_block = ext3_bread (handle, inode, 0, 1, &err);
> -	if (!dir_block)
> +	if (!(dir_block = ext3_dir_bread(handle, inode, 0, 1, &err)))
>  		goto out_clear_inode;
>  
>  	BUFFER_TRACE(dir_block, "get_write_access");
> @@ -1859,7 +1862,7 @@ static int empty_dir (struct inode * inode)
>  
>  	sb = inode->i_sb;
>  	if (inode->i_size < EXT3_DIR_REC_LEN(1) + EXT3_DIR_REC_LEN(2) ||
> -	    !(bh = ext3_bread (NULL, inode, 0, 0, &err))) {
> +	    !(bh = ext3_dir_bread(NULL, inode, 0, 0, &err))) {
>  		if (err)
>  			ext3_error(inode->i_sb, __func__,
>  				   "error %d reading directory #%lu offset 0",
> @@ -1890,9 +1893,8 @@ static int empty_dir (struct inode * inode)
>  			(void *) de >= (void *) (bh->b_data+sb->s_blocksize)) {
>  			err = 0;
>  			brelse (bh);
> -			bh = ext3_bread (NULL, inode,
> -				offset >> EXT3_BLOCK_SIZE_BITS(sb), 0, &err);
> -			if (!bh) {
> +			if (!(bh = ext3_dir_bread (NULL, inode,
> +				offset >> EXT3_BLOCK_SIZE_BITS(sb), 0, &err))) {
>  				if (err)
>  					ext3_error(sb, __func__,
>  						   "error %d reading directory"
> diff --git a/fs/ext3/namei.h b/fs/ext3/namei.h
> index f2ce2b0..46304d8 100644
> --- a/fs/ext3/namei.h
> +++ b/fs/ext3/namei.h
> @@ -6,3 +6,22 @@
>  */
>  
>  extern struct dentry *ext3_get_parent(struct dentry *child);
> +
> +static inline struct buffer_head *ext3_dir_bread(handle_t *handle,
> +						 struct inode *inode,
> +						 int block, int create,
> +						 int *err)
> +{
> +	struct buffer_head *bh;
> +
> +	bh = ext3_bread(handle, inode, block, create, err);
> +
> +	if (!bh && !(*err)) {
> +		*err = -EIO;
> +		ext3_error(inode->i_sb, __func__,
> +			   "Directory hole detected on inode %lu\n",
> +			   inode->i_ino);
> +		return NULL;
> +	}
> +	return bh;
> +}
> -- 
> 1.7.11.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
