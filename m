From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 1/1] dir shrink (was Re: ext3/ext4 directories don't	shrink
 after deleting lots of files)
Date: Fri, 28 Aug 2009 17:11:15 -0600
Message-ID: <20090828231115.GV4197@webber.adilger.int>
References: <1242338523.6933.664.camel@timo-desktop>
 <200908221620.50103.schlick@lavabit.com>
 <20090823031039.GF5931@webber.adilger.int>
 <200908290018.18084.schlick@lavabit.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Andreas Schlick <schlick@lavabit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:48587 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbZH1XLI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Aug 2009 19:11:08 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n7SNB9R6007401
	for <linux-ext4@vger.kernel.org>; Fri, 28 Aug 2009 16:11:10 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KP400G00078PK00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Fri,
 28 Aug 2009 16:11:09 -0700 (PDT)
In-reply-to: <200908290018.18084.schlick@lavabit.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 29, 2009  00:18 +0200, Andreas Schlick wrote:
> > Adding the extra "dc" to each of the functions probably isn't necessary,
> > as this makes the API messier.  Probably a better approach would be to
> > just do this within ext4_delete_entry(), analogous to how ext4_add_entry()
> > might add a new block at any time.
> 
> As I understand it, Ted's idea was to avoid problems with the transactions
> by doing it after the main work of unlink()/rmdir()/rename(). I don't know 
> what the better approach is and don't mind changing it.

This seems reasonable, though in that case it seems it would be much
more efficient to just put the directory inode onto an in-memory list
of directories that have recently emptied a block, and then have a
separate helper thread (or kernel task or whatever) that checks this
list periodically and does freeing of all blocks at the end of the
file that are empty.

That would allow aggregation of the scanning/freeing operations, and
in the case of a directory that has many files deleted from it, it may
save the repeated truncate operations, and it will simply be deleted
entirely (removing itself from the list, of course).

> But can you please 
> give me a pointer, how to remove the final block in this case? Shall I copy 
> the relevant code from ext4_truncate()? At the moment I (mis- ?)use 
> ext4_truncate().
> 
> Attached is the latest WIP patch. It seems to work for me, but after some 
> tests fsck warns about some nodes not being referenced and having an invalid 
> depth of 2, although the htree as shown by debugfs' htree command looks 
> consistent to me. Does fsck assume a special order of the htree nodes 
> perhaps?

Yes, the leaf blocks need to be referenced in hash order in the index.
The actual on-disk order of the directory leaf blocks is not important.

> [PATCH] ext4: Add a function to shrink directories by removing last empty 
> block.
> 
> Signed-off-by: Andreas Schlick <schlick@lavabit.com>
> ---
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 22098e1..fa01019 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -74,6 +74,12 @@ static struct buffer_head *ext4_append(handle_t *handle,
>  #define assert(test) J_ASSERT(test)
>  #endif
>  
> +struct ext4_dir_cleanup {
> +	ext4_lblk_t block;
> +	struct buffer_head *bh;
> +	struct ext4_dir_entry_2 *de;
> +};
> +
>  #ifdef DX_DEBUG
>  #define dxtrace(command) command
>  #else
> @@ -176,9 +182,10 @@ static int ext4_htree_next_block(struct inode *dir, __u32 hash,
>  static struct buffer_head * ext4_dx_find_entry(struct inode *dir,
>  		const struct qstr *d_name,
>  		struct ext4_dir_entry_2 **res_dir,
> -		int *err);
> +		int *err, ext4_lblk_t *blk);
>  static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
>  			     struct inode *inode);
> +static void ext4_shrink_directory(struct inode *dir, struct ext4_dir_cleanup *dc);
>  
>  unsigned int ext4_rec_len_from_disk(__le16 dlen, unsigned blocksize)
>  {
> @@ -880,7 +887,8 @@ static inline int search_dirblock(struct buffer_head *bh,
>   */
>  static struct buffer_head * ext4_find_entry (struct inode *dir,
>  					const struct qstr *d_name,
> -					struct ext4_dir_entry_2 ** res_dir)
> +					struct ext4_dir_entry_2 ** res_dir,
> +					ext4_lblk_t *blk)
>  {
>  	struct super_block *sb;
>  	struct buffer_head *bh_use[NAMEI_RA_SIZE];
> @@ -901,7 +909,7 @@ static struct buffer_head * ext4_find_entry (struct inode *dir,
>  	if (namelen > EXT4_NAME_LEN)
>  		return NULL;
>  	if (is_dx(dir)) {
> -		bh = ext4_dx_find_entry(dir, d_name, res_dir, &err);
> +		bh = ext4_dx_find_entry(dir, d_name, res_dir, &err, blk);
>  		/*
>  		 * On success, or if the error was file not found,
>  		 * return.  Otherwise, fall back to doing a search the
> @@ -958,6 +966,8 @@ restart:
>  			    block << EXT4_BLOCK_SIZE_BITS(sb), res_dir);
>  		if (i == 1) {
>  			EXT4_I(dir)->i_dir_start_lookup = block;
> +			if (blk)
> +				*blk = block;
>  			ret = bh;
>  			goto cleanup_and_exit;
>  		} else {
> @@ -989,7 +999,7 @@ cleanup_and_exit:
>  }
>  
>  static struct buffer_head * ext4_dx_find_entry(struct inode *dir, const struct qstr *d_name,
> -		       struct ext4_dir_entry_2 **res_dir, int *err)
> +		       struct ext4_dir_entry_2 **res_dir, int *err, ext4_lblk_t *blk)
>  {
>  	struct super_block * sb;
>  	struct dx_hash_info	hinfo;
> @@ -1034,6 +1044,8 @@ static struct buffer_head * ext4_dx_find_entry(struct inode *dir, const struct q
>  			if (ext4_match(namelen, name, de)) {
>  				*res_dir = de;
>  				dx_release(frames);
> +				if (blk)
> +					*blk = block;
>  				return bh;
>  			}
>  		}
> @@ -1066,7 +1078,7 @@ static struct dentry *ext4_lookup(struct inode *dir, struct dentry *dentry, stru
>  	if (dentry->d_name.len > EXT4_NAME_LEN)
>  		return ERR_PTR(-ENAMETOOLONG);
>  
> -	bh = ext4_find_entry(dir, &dentry->d_name, &de);
> +	bh = ext4_find_entry(dir, &dentry->d_name, &de, NULL);
>  	inode = NULL;
>  	if (bh) {
>  		__u32 ino = le32_to_cpu(de->inode);
> @@ -1103,7 +1115,7 @@ struct dentry *ext4_get_parent(struct dentry *child)
>  	struct ext4_dir_entry_2 * de;
>  	struct buffer_head *bh;
>  
> -	bh = ext4_find_entry(child->d_inode, &dotdot, &de);
> +	bh = ext4_find_entry(child->d_inode, &dotdot, &de, NULL);
>  	inode = NULL;
>  	if (!bh)
>  		return ERR_PTR(-ENOENT);
> @@ -1285,6 +1297,303 @@ errout:
>  	return NULL;
>  }
>  
> +/* ext4_dx_lookup() looks up the references to block and block2 in a
> + * directory's htree. Set block2 == block, if you are only interested
> + * in one block (in that case bframe2 won't be changed).
> + *
> + * Returns 0 on success. In any other case all buffer_heads are already
> + * released and the state of *bframe / *bframe2 is undefined.
> + */
> +static int ext4_dx_lookup(handle_t *handle, struct inode *dir,
> +		ext4_lblk_t block,
> +		struct dx_frame *bframe,
> +		ext4_lblk_t block2,
> +		struct dx_frame *bframe2)
> +{
> +
> +	struct dx_frame frames[2], *frame=frames;
> +	struct dx_root *root;
> +	int err, count;
> +	short indirect, found;
> +
> +	if (!(frame->bh = ext4_bread(handle, dir, 0, 0, &err))) {
> +		ext4_warning(dir->i_sb, __func__, "early fail");
> +		return 1;
> +	}
> +
> +	root = (struct dx_root *) frame->bh->b_data;
> +	frame->at = frame->entries =
> +		(struct dx_entry *) (((char *)&root->info) + root->info.info_length);
> +
> +	if ((indirect = root->info.indirect_levels) > 1) {
> +		ext4_warning(dir->i_sb, __func__,
> +			     "Unimplemented inode hash depth: %#06x",
> +			     root->info.indirect_levels);
> +		brelse(frame->bh);
> +		return ERR_BAD_DX_DIR;
> +	}
> +
> +	if (dx_get_limit(frame->entries) !=
> +			dx_root_limit(dir, root->info.info_length)) {
> +		ext4_warning(dir->i_sb, __func__,
> +			     "dx entry: limit != root limit");
> +		brelse(frame->bh);
> +		return ERR_BAD_DX_DIR;
> +	}
> +
> +	if (indirect) {
> +		frame = &frames[1];
> +		frame->bh = ext4_bread(handle, dir,
> +				dx_get_block(frames[0].at), 0, &err);
> +		if (!frame->bh)	{
> +			ext4_warning(dir->i_sb, __func__,
> +			     "indirect read failed");
> +			brelse(frames[0].bh);
> +			return 1;
> +		}
> +		frame->entries = ((struct dx_node *) frame->bh->b_data)->entries;
> +		frame->at = frame->entries;
> +	}
> +
> +	found = (block == block2)?1:0;
> +
> +	while (1) {
> +		count = dx_get_count(frame->entries);
> +		if (!count || count > dx_get_limit(frame->entries)) {
> +			ext4_warning(dir->i_sb, __func__,
> +				     "dx entry: no count or count > limit");
> +			brelse(frame->bh);
> +			if (indirect) {
> +				brelse(frames->bh);
> +			}
> +			goto fail;
> +		}
> +
> +		while (frame->at < frame->entries + count && found != 2) {
> +			if (dx_get_block(frame->at) == block) {
> +				bframe->bh = frame->bh;
> +				bframe->entries = frame->entries;
> +				bframe->at = frame->at;
> +				++found;
> +			} else if (dx_get_block(frame->at) == block2) {
> +				bframe2->bh = frame->bh;
> +				bframe2->entries = frame->entries;
> +				bframe2->at = frame->at;
> +				++found;
> +			}
> +			frame->at += 1;
> +		}
> +
> +		if (frame->bh != bframe2->bh && frame->bh != bframe->bh)
> +			brelse(frame->bh);
> +
> +		if ((bframe2->bh && bframe->bh) || (bframe->bh && (block == block2))) {
> +			/* Release root if it is not needed. */
> +			if (frames->bh != bframe->bh && frames->bh != bframe2->bh) {
> +				brelse(frames->bh);
> +			}
> +
> +			return 0;
> +		}
> +
> +		if (!indirect) {
> +			ext4_warning(dir->i_sb, __func__, "Unaccounted block");
> +			goto fail;
> +		}
> +
> +		if (frames[0].at + 1 >= frames[0].entries + dx_get_count(frames[0].entries)) {
> +			indirect = 0;
> +			frame = frames;
> +			frame->at = frame->entries;
> +		} else {
> +			frames->at += 1;
> +			frame->bh = ext4_bread(handle, dir, dx_get_block(frames->at), 0, &err);
> +			if (!frame->bh) {
> +				ext4_warning(dir->i_sb, __func__,
> +					"read failed: block %u err %i",
> +					dx_get_block(frames->at), err);
> +				goto fail;
> +			}
> +			frame->entries = ((struct dx_node *) frame->bh->b_data)->entries;
> +			frame->at = frame->entries;
> +
> +			if (dx_get_limit(frame->entries) != dx_node_limit(dir)) {
> +				ext4_warning(dir->i_sb, __func__,
> +					     "dx entry: limit != node limit");
> +				brelse(frame->bh);
> +				goto fail;
> +			}
> +		}
> +	}
> +
> +	fail:
> +	if (frames->bh != bframe->bh && frames->bh != bframe2->bh)
> +		brelse(frames[0].bh);
> +	brelse(bframe->bh);
> +	brelse(bframe2->bh);
> +	bframe2->bh = bframe->bh = NULL;
> +	return 1;
> +}
> +
> +/* int ext4_dx_chg_ref() - Change a lblock reference to block.
> + * @handle: transaction handle
> + * @dir: directory we working on
> + * @block: logical block number of the block filled with unused ext4_dir_entry_2
> + * @lblock: logical block number of dir's last block
> + *
> + * This is a helper function for ext4_shrink_dir(). It searches the htree
> + * for entries that reference @block/@lblock and changes the reference
> + * to @lblock such that it points to @block afterwards and removes the
> + * reference to @lblock completely. In case of @block == @lblock it just
> + * removes the reference to @lblock from the htree.
> + *
> + * Returns 0 on success.
> + */
> +static int ext4_dx_chg_ref(handle_t *handle,
> +		struct inode *dir,
> +		ext4_lblk_t block,
> +		ext4_lblk_t lblock)
> +{
> +	struct dx_frame b_frame, lb_frame;
> +	struct dx_countlimit cltmp;
> +	unsigned count;
> +
> +	memset(&b_frame, 0, sizeof(b_frame));
> +	memset(&lb_frame, 0, sizeof(lb_frame));
> +
> +	if (lblock < 2 || block == 0)
> +		return 1;
> +
> +	if (ext4_dx_lookup(handle, dir, block, &b_frame, lblock, &lb_frame))
> +		return 1;
> +
> +	if (dx_get_count(b_frame.entries) <= 1) {
> +		/* A count value of 0 is not allowed and we don't
> +		 * merge an index node into root (yet?). */
> +		goto fail;
> +	}
> +
> +	if (ext4_journal_get_write_access(handle, b_frame.bh))
> +		goto fail;
> +
> +	if (lb_frame.bh) {
> +		if (lb_frame.bh!=b_frame.bh &&
> +				ext4_journal_get_write_access(handle, lb_frame.bh))
> +			goto fail;
> +
> +		dx_set_block(lb_frame.at, block);
> +
> +		if (lb_frame.bh != b_frame.bh) {
> +			if (ext4_handle_dirty_metadata(handle, dir, lb_frame.bh)) {
> +				dx_set_block(lb_frame.at, lblock);
> +				goto fail;
> +			}
> +
> +			brelse(lb_frame.bh);
> +		}
> +		lb_frame.bh = NULL;
> +	}
> +
> +	count = dx_get_count(b_frame.entries);
> +
> +	/* save original dx_countlimit in case memmove() overwrites it */
> +	cltmp = *((struct dx_countlimit *)b_frame.entries);
> +
> +	memmove(b_frame.at, b_frame.at + 1,
> +		(char *)(b_frame.entries+count) - (char *)(b_frame.at + 1));
> +
> +	/* restore dx_countlimit */
> +	*((struct dx_countlimit *)b_frame.entries) = cltmp;
> +
> +	dx_set_count(b_frame.entries, dx_get_count(b_frame.entries) - 1);
> +
> +	ext4_handle_dirty_metadata(handle, dir, b_frame.bh);
> +	brelse(b_frame.bh);
> +	return 0;
> +
> +fail:
> +	if (lb_frame.bh != b_frame.bh)
> +		brelse(lb_frame.bh);
> +
> +	brelse(b_frame.bh);
> +	return 1;
> +}
> +
> +/*
> + * int ext4_shrink_directory() - This function tries to shrink the directory.
> + *
> + * Precondition: All dir_entries before dc->de (dc->de included) are unused.
> + */
> +static void ext4_shrink_directory(struct inode *dir, struct ext4_dir_cleanup *dc)
> +{
> +	handle_t *handle;
> +	char * dlimit;
> +	struct buffer_head *bh2=NULL;
> +	ext4_lblk_t lblock;
> +
> +	lblock = dir->i_size >> EXT4_BLOCK_SIZE_BITS(dir->i_sb);
> +
> +	if (lblock <= 1 || !dc->bh || !dc->de)
> +		return;
> +
> +	--lblock;
> +
> +	/* Rearranging blocks will break readdir() on non-htree directories. */
> +	/* Is there a better way to check if a readdir() is going on? */
> +	if (dc->block != lblock && !is_dx(dir))
> +		return;
> +
> +	/* Check if the rest of the block is also empty */
> +	dc->de = ext4_next_entry(dc->de, EXT4_BLOCK_SIZE(dir->i_sb));
> +	dlimit = dc->bh->b_data + EXT4_BLOCK_SIZE(dir->i_sb);
> +	while ((char *) dc->de < dlimit) {
> +		if (dc->de->inode)
> +			return;
> +		dc->de = ext4_next_entry(dc->de, EXT4_BLOCK_SIZE(dir->i_sb));
> +	}
> +
> +	handle = ext4_journal_start(dir, 5);
> +	if (!handle)
> +		return;
> +
> +	/* As ext4_dx_chg_ref() changes the htree and we cannot undo it,
> +	 * we may not fail afterwards. Therefore we get the last block
> +	 * now, but copy it later.
> +	 */
> +	if (dc->block != lblock) {
> +		int err;
> +
> +		if (ext4_journal_get_write_access(handle, dc->bh))
> +			goto fail;
> +
> +		if (!(bh2 = ext4_bread(NULL, dir, lblock, 0, &err)))
> +			goto fail;
> +	}
> +
> +
> +	if (is_dx(dir) && ext4_dx_chg_ref(handle, dir, dc->block, lblock))
> +		goto fail;
> +
> +	if (dc->block != lblock) {
> +		memcpy(dc->bh->b_data, bh2->b_data, EXT4_BLOCK_SIZE(dir->i_sb));
> +		ext4_handle_dirty_metadata(handle, dir, dc->bh);
> +		brelse(bh2);
> +	}
> +
> +	dir->i_size -= EXT4_BLOCK_SIZE(dir->i_sb);
> +	ext4_mark_inode_dirty(handle, dir);
> +	ext4_orphan_add(handle, dir); /* ext4_truncate should remove dir again */
> +	ext4_journal_stop(handle);
> +
> +	ext4_truncate(dir);
> +	return;
> +
> +fail:
> +	brelse(bh2);
> +	ext4_handle_release_buffer(handle, dc->bh);
> +	ext4_journal_stop(handle);
> +}
> +
>  /*
>   * Add a new entry into a directory (leaf) block.  If de is non-NULL,
>   * it points to a directory entry which is guaranteed to be large
> @@ -1676,13 +1985,15 @@ cleanup:
>  static int ext4_delete_entry(handle_t *handle,
>  			     struct inode *dir,
>  			     struct ext4_dir_entry_2 *de_del,
> -			     struct buffer_head *bh)
> +			     struct buffer_head *bh,
> +			     struct ext4_dir_cleanup *dc)
>  {
>  	struct ext4_dir_entry_2 *de, *pde;
>  	unsigned int blocksize = dir->i_sb->s_blocksize;
> -	int i;
> +	int i, empty;
>  
>  	i = 0;
> +	empty = 1;
>  	pde = NULL;
>  	de = (struct ext4_dir_entry_2 *) bh->b_data;
>  	while (i < bh->b_size) {
> @@ -1700,11 +2011,21 @@ static int ext4_delete_entry(handle_t *handle,
>  					blocksize);
>  			else
>  				de->inode = 0;
> +
> +			if (empty && dc) {
> +				dc->bh = bh;
> +				dc->de = pde?pde:de;
> +			}
> +
>  			dir->i_version++;
>  			BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
>  			ext4_handle_dirty_metadata(handle, dir, bh);
>  			return 0;
>  		}
> +
> +		if (de->inode)
> +			empty = 0;
> +
>  		i += ext4_rec_len_from_disk(de->rec_len, blocksize);
>  		pde = de;
>  		de = ext4_next_entry(de, blocksize);
> @@ -2135,6 +2456,9 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
>  	struct buffer_head *bh;
>  	struct ext4_dir_entry_2 *de;
>  	handle_t *handle;
> +	struct ext4_dir_cleanup dc;
> +
> +	memset(&dc, 0, sizeof(dc));
>  
>  	/* Initialize quotas before so that eventual writes go in
>  	 * separate transaction */
> @@ -2144,7 +2468,7 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
>  		return PTR_ERR(handle);
>  
>  	retval = -ENOENT;
> -	bh = ext4_find_entry(dir, &dentry->d_name, &de);
> +	bh = ext4_find_entry(dir, &dentry->d_name, &de, &dc.block);
>  	if (!bh)
>  		goto end_rmdir;
>  
> @@ -2161,7 +2485,7 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
>  	if (!empty_dir(inode))
>  		goto end_rmdir;
>  
> -	retval = ext4_delete_entry(handle, dir, de, bh);
> +	retval = ext4_delete_entry(handle, dir, de, bh, &dc);
>  	if (retval)
>  		goto end_rmdir;
>  	if (!EXT4_DIR_LINK_EMPTY(inode))
> @@ -2183,6 +2507,7 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
>  
>  end_rmdir:
>  	ext4_journal_stop(handle);
> +	ext4_shrink_directory(dir, &dc);
>  	brelse(bh);
>  	return retval;
>  }
> @@ -2194,6 +2519,9 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
>  	struct buffer_head *bh;
>  	struct ext4_dir_entry_2 *de;
>  	handle_t *handle;
> +	struct ext4_dir_cleanup dc;
> +
> +	memset(&dc, 0, sizeof(dc));
>  
>  	/* Initialize quotas before so that eventual writes go
>  	 * in separate transaction */
> @@ -2206,7 +2534,7 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
>  		ext4_handle_sync(handle);
>  
>  	retval = -ENOENT;
> -	bh = ext4_find_entry(dir, &dentry->d_name, &de);
> +	bh = ext4_find_entry(dir, &dentry->d_name, &de, &dc.block);
>  	if (!bh)
>  		goto end_unlink;
>  
> @@ -2222,7 +2550,7 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
>  			     inode->i_ino, inode->i_nlink);
>  		inode->i_nlink = 1;
>  	}
> -	retval = ext4_delete_entry(handle, dir, de, bh);
> +	retval = ext4_delete_entry(handle, dir, de, bh, &dc);
>  	if (retval)
>  		goto end_unlink;
>  	dir->i_ctime = dir->i_mtime = ext4_current_time(dir);
> @@ -2237,6 +2565,7 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
>  
>  end_unlink:
>  	ext4_journal_stop(handle);
> +	ext4_shrink_directory(dir, &dc);
>  	brelse(bh);
>  	return retval;
>  }
> @@ -2358,6 +2687,9 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
>  	struct buffer_head *old_bh, *new_bh, *dir_bh;
>  	struct ext4_dir_entry_2 *old_de, *new_de;
>  	int retval, force_da_alloc = 0;
> +	struct ext4_dir_cleanup dc;
> +
> +	memset(&dc, 0, sizeof(dc));
>  
>  	old_bh = new_bh = dir_bh = NULL;
>  
> @@ -2374,7 +2706,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
>  	if (IS_DIRSYNC(old_dir) || IS_DIRSYNC(new_dir))
>  		ext4_handle_sync(handle);
>  
> -	old_bh = ext4_find_entry(old_dir, &old_dentry->d_name, &old_de);
> +	old_bh = ext4_find_entry(old_dir, &old_dentry->d_name, &old_de, &dc.block);
>  	/*
>  	 *  Check for inode number is _not_ due to possible IO errors.
>  	 *  We might rmdir the source, keep it as pwd of some process
> @@ -2387,7 +2719,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
>  		goto end_rename;
>  
>  	new_inode = new_dentry->d_inode;
> -	new_bh = ext4_find_entry(new_dir, &new_dentry->d_name, &new_de);
> +	new_bh = ext4_find_entry(new_dir, &new_dentry->d_name, &new_de, NULL);
>  	if (new_bh) {
>  		if (!new_inode) {
>  			brelse(new_bh);
> @@ -2447,7 +2779,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
>  	    old_de->name_len != old_dentry->d_name.len ||
>  	    strncmp(old_de->name, old_dentry->d_name.name, old_de->name_len) ||
>  	    (retval = ext4_delete_entry(handle, old_dir,
> -					old_de, old_bh)) == -ENOENT) {
> +					old_de, old_bh, &dc)) == -ENOENT) {
>  		/* old_de could have moved from under us during htree split, so
>  		 * make sure that we are deleting the right entry.  We might
>  		 * also be pointing to a stale entry in the unused part of
> @@ -2455,10 +2787,10 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
>  		struct buffer_head *old_bh2;
>  		struct ext4_dir_entry_2 *old_de2;
>  
> -		old_bh2 = ext4_find_entry(old_dir, &old_dentry->d_name, &old_de2);
> +		old_bh2 = ext4_find_entry(old_dir, &old_dentry->d_name, &old_de2, &dc.block);
>  		if (old_bh2) {
>  			retval = ext4_delete_entry(handle, old_dir,
> -						   old_de2, old_bh2);
> +						   old_de2, old_bh2, NULL);
>  			brelse(old_bh2);
>  		}
>  	}
> @@ -2504,9 +2836,10 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
>  
>  end_rename:
>  	brelse(dir_bh);
> -	brelse(old_bh);
>  	brelse(new_bh);
>  	ext4_journal_stop(handle);
> +	ext4_shrink_directory(old_dir, &dc);
> +	brelse(old_bh);
>  	if (retval == 0 && force_da_alloc)
>  		ext4_alloc_da_blocks(old_inode);
>  	return retval;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

