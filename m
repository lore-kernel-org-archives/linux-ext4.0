From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [EXT4 set 5][PATCH 1/1] expand inode i_extra_isize to support
 features in larger inode
Date: Tue, 10 Jul 2007 16:32:47 -0700
Message-ID: <20070710163247.5c8bfa3f.akpm@linux-foundation.org>
References: <1183275482.4010.133.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
To: cmm@us.ibm.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1183275482.4010.133.camel@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, 01 Jul 2007 03:38:01 -0400
Mingming Cao <cmm@us.ibm.com> wrote:

> This patch is on top of the nanosecond timestamp and i_version_hi
> patches. 

This sort of information isn't needed (or desired) when this patch hits the
git tree.  Please ensure that things like this are cleaned up before the
patches go to Linus.

> We need to make sure that existing filesystems can also avail the new
> fields that have been added to the inode. We use s_want_extra_isize and
> s_min_extra_isize to decide by how much we should expand the inode. If
> EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE feature is set then we expand by
> max(s_want_extra_isize, s_min_extra_isize , sizeof(ext4_inode) -
> EXT4_GOOD_OLD_INODE_SIZE) bytes. Actually it is still an open question
> about whether users should be able to set s_*_extra_isize smaller than
> the known fields or not. 
> 
> This patch also adds the functionality to expand inodes to include the
> newly added fields. We start by trying to expand by s_want_extra_isize
> bytes and if its fails we try to expand by s_min_extra_isize bytes. This
> is done by changing the i_extra_isize if enough space is available in
> the inode and no EAs are present. If EAs are present and there is enough
> space in the inode then the EAs in the inode are shifted to make space.
> If enough space is not available in the inode due to the EAs then 1 or
> more EAs are shifted to the external EA block. In the worst case when
> even the external EA block does not have enough space we inform the user
> that some EA would need to be deleted or s_min_extra_isize would have to
> be reduced.
> 
> This would be online expansion of inodes. I am also working on adding an
> "expand_inodes" option to e2fsck which will expand all the used inodes.
> 
> Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
> Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>
> Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> 
> Index: linux-2.6.22-rc4/fs/ext4/inode.c
> ===================================================================
> --- linux-2.6.22-rc4.orig/fs/ext4/inode.c	2007-06-14 17:32:27.000000000 -0700
> +++ linux-2.6.22-rc4/fs/ext4/inode.c	2007-06-14 17:32:41.000000000 -0700
> @@ -3120,6 +3120,40 @@ ext4_reserve_inode_write(handle_t *handl
>  }
>  
>  /*
> + * Expand an inode by new_extra_isize bytes.
> + * Returns 0 on success or negative error number on failure.
> + */
> +int ext4_expand_extra_isize(struct inode *inode, unsigned int new_extra_isize,
> +			struct ext4_iloc iloc, handle_t *handle)
> +{
> +	struct ext4_inode *raw_inode;
> +	struct ext4_xattr_ibody_header *header;
> +	struct ext4_xattr_entry *entry;
> +
> +	if (EXT4_I(inode)->i_extra_isize >= new_extra_isize) {
> +		return 0;
> +	}

This patch has lots of unneeded braces in it.  checkpatch appears to catch
them.


> +	raw_inode = ext4_raw_inode(&iloc);
> +
> +	header = IHDR(inode, raw_inode);
> +	entry = IFIRST(header);
> +
> +	/* No extended attributes present */
> +	if (!(EXT4_I(inode)->i_state & EXT4_STATE_XATTR) ||
> +		header->h_magic != cpu_to_le32(EXT4_XATTR_MAGIC)) {
> +		memset((void *)raw_inode + EXT4_GOOD_OLD_INODE_SIZE, 0,
> +			new_extra_isize);
> +		EXT4_I(inode)->i_extra_isize = new_extra_isize;
> +		return 0;
> +	}
> +
> +	/* try to expand with EA present */
> +	return ext4_expand_extra_isize_ea(inode, new_extra_isize,
> +						raw_inode, handle);
> +}
> +
> +/*
>   * What we do here is to mark the in-core inode as clean with respect to inode
>   * dirtiness (it may still be data-dirty).
>   * This means that the in-core inode may be reaped by prune_icache
> @@ -3143,10 +3177,33 @@ ext4_reserve_inode_write(handle_t *handl
>  int ext4_mark_inode_dirty(handle_t *handle, struct inode *inode)
>  {
>  	struct ext4_iloc iloc;
> -	int err;
> +	int err, ret;
> +	static int expand_message;
>  
>  	might_sleep();
>  	err = ext4_reserve_inode_write(handle, inode, &iloc);
> +	if (EXT4_I(inode)->i_extra_isize <
> +	    EXT4_SB(inode->i_sb)->s_want_extra_isize &&
> +	    !(EXT4_I(inode)->i_state & EXT4_STATE_NO_EXPAND)) {
> +		/* We need extra buffer credits since we may write into EA block
> +		 * with this same handle */
> +		if ((jbd2_journal_extend(handle,
> +			     EXT4_DATA_TRANS_BLOCKS(inode->i_sb))) == 0) {
> +			ret = ext4_expand_extra_isize(inode,
> +				EXT4_SB(inode->i_sb)->s_want_extra_isize,
> +				iloc, handle);
> +			if (ret) {
> +				EXT4_I(inode)->i_state |= EXT4_STATE_NO_EXPAND;
> +				if (!expand_message) {
> +					ext4_warning(inode->i_sb, __FUNCTION__,
> +					"Unable to expand inode %lu. Delete"
> +					" some EAs or run e2fsck.",
> +					inode->i_ino);
> +					expand_message = 1;
> +				}
> +			}
> +		}
> +	}

Maybe that message should come out once per mount rather than once per boot
(or once per modprobe)?

What are the consequences of a jbd2_journal_extend() failure in here?

> +static inline size_t ext4_xattr_free_space(struct ext4_xattr_entry *last,
> +				    size_t *min_offs, void *base, int *total)
> +{
> +	for (; !IS_LAST_ENTRY(last); last = EXT4_XATTR_NEXT(last)) {
> +		*total += EXT4_XATTR_LEN(last->e_name_len);
> +		if (!last->e_value_block && last->e_value_size) {
> +			size_t offs = le16_to_cpu(last->e_value_offs);
> +			if (offs < *min_offs)
> +				*min_offs = offs;
> +		}
> +	}
> +	return (*min_offs - ((void *)last - base) - sizeof(__u32));
> +}

This is far too large to be inlined.

This function needs a comment explaining what it does.  Most functions do..

>  struct ext4_xattr_info {
>  	int name_index;
>  	const char *name;
> @@ -606,6 +613,7 @@ ext4_xattr_set_entry(struct ext4_xattr_i
>  			memmove(s->here, (void *)s->here + size,
>  				(void *)last - (void *)s->here + sizeof(__u32));
>  			memset(last, 0, size);
> +
>  		}
>  	}

Unneeded newline.

> @@ -1014,6 +1022,8 @@ ext4_xattr_set_handle(handle_t *handle, 
>  	if (!error) {
>  		ext4_xattr_update_super_block(handle, inode->i_sb);
>  		inode->i_ctime = ext4_current_time(inode);
> +		if (!value)
> +			EXT4_I(inode)->i_state &= ~EXT4_STATE_NO_EXPAND;

What is the locking for i_state?

>  		error = ext4_mark_iloc_dirty(handle, inode, &is.iloc);
>  		/*
>  		 * The bh is consumed by ext4_mark_iloc_dirty, even with
> @@ -1066,6 +1076,239 @@ retry:
>  	return error;
>  }
>  
> +static void ext4_xattr_shift_entries(struct ext4_xattr_entry *entry,
> +				     int value_offs_shift, void *to,
> +				     void *from, size_t n, int blocksize)
> +{
> +	struct ext4_xattr_entry *last = entry;
> +	int new_offs;
> +
> +	/* Adjust the value offsets of the entries */
> +	for (; !IS_LAST_ENTRY(last); last = EXT4_XATTR_NEXT(last)) {
> +		if (!last->e_value_block && last->e_value_size) {
> +			new_offs = le16_to_cpu(last->e_value_offs) +
> +							value_offs_shift;
> +			BUG_ON(new_offs + le32_to_cpu(last->e_value_size)
> +				 > blocksize);
> +			last->e_value_offs = cpu_to_le16(new_offs);
> +		}
> +	}
> +	/* Shift the entries by n bytes */
> +	memmove(to, from, n);
> +}

This function could do with an overall comment.

Under what circumstances will that new BUG_ON trigger?  Can it be triggered
via incorrect disk contents?  If so, it should not be there.

> +/*
> + * Expand an inode by new_extra_isize bytes when EA presents.

"when an EA is present"?

> + * Returns 0 on success or negative error number on failure.
> + *
> + */
> +int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
> +			    struct ext4_inode *raw_inode, handle_t *handle)
> +{
> +	struct ext4_xattr_ibody_header *header;
> +	struct ext4_xattr_entry *entry, *last, *first;
> +	struct buffer_head *bh = NULL;
> +	struct ext4_xattr_ibody_find *is = NULL;
> +	struct ext4_xattr_block_find *bs = NULL;
> +	char *buffer = NULL, *b_entry_name = NULL;
> +	size_t min_offs, free;
> +	int total_ino, total_blk;
> +	void *base, *start, *end;
> +	int extra_isize = 0, error = 0, tried_min_extra_isize = 0;
> +	int s_min_extra_isize = EXT4_SB(inode->i_sb)->s_es->s_min_extra_isize;
> +
> +	down_write(&EXT4_I(inode)->xattr_sem);
> +retry:
> +	if (EXT4_I(inode)->i_extra_isize >= new_extra_isize) {
> +		up_write(&EXT4_I(inode)->xattr_sem);
> +		return 0;
> +	}

So..  xattr_sem is a lock which protects i_extra_isize?  That seems a bit
strange to me - I'd have expected i_mutex.

> +	header = IHDR(inode, raw_inode);
> +	entry = IFIRST(header);
> +
> +	/*
> +	 * Check if enough free space is available in the inode to shift the
> +	 * entries ahead by new_extra_isize.
> +	 */
> +
> +	base = start = entry;
> +	end = (void *)raw_inode + EXT4_SB(inode->i_sb)->s_inode_size;
> +	min_offs = end - base;
> +	last = entry;
> +	total_ino = sizeof(struct ext4_xattr_ibody_header);
> +
> +	free = ext4_xattr_free_space(last, &min_offs, base, &total_ino);
> +	if (free >= new_extra_isize) {
> +		entry = IFIRST(header);
> +		ext4_xattr_shift_entries(entry,	EXT4_I(inode)->i_extra_isize
> +				- new_extra_isize, (void *)raw_inode +
> +				EXT4_GOOD_OLD_INODE_SIZE + new_extra_isize,
> +				(void *)header, total_ino,
> +				inode->i_sb->s_blocksize);
> +		EXT4_I(inode)->i_extra_isize = new_extra_isize;
> +		error = 0;
> +		goto cleanup;
> +	}
> +
> +	/*
> +	 * Enough free space isn't available in the inode, check if
> +	 * EA block can hold new_extra_isize bytes.
> +	 */
> +	if (EXT4_I(inode)->i_file_acl) {
> +		bh = sb_bread(inode->i_sb, EXT4_I(inode)->i_file_acl);
> +		error = -EIO;
> +		if (!bh)
> +			goto cleanup;
> +		if (ext4_xattr_check_block(bh)) {
> +			ext4_error(inode->i_sb, __FUNCTION__,
> +				"inode %lu: bad block %llu", inode->i_ino,
> +				EXT4_I(inode)->i_file_acl);
> +			error = -EIO;
> +			goto cleanup;
> +		}
> +		base = BHDR(bh);
> +		first = BFIRST(bh);
> +		end = bh->b_data + bh->b_size;
> +		min_offs = end - base;
> +		free = ext4_xattr_free_space(first, &min_offs, base,
> +					     &total_blk);
> +		if (free < new_extra_isize) {
> +			if (!tried_min_extra_isize && s_min_extra_isize) {
> +				tried_min_extra_isize++;
> +				new_extra_isize = s_min_extra_isize;

Aren't we missing a brelse(bh) here?

> +				goto retry;
> +			}
> +			error = -1;
> +			goto cleanup;
> +		}
> +	} else {
> +		free = inode->i_sb->s_blocksize;
> +	}
> +
> +	while (new_extra_isize > 0) {
> +		size_t offs, size, entry_size;
> +		struct ext4_xattr_entry *small_entry = NULL;
> +		struct ext4_xattr_info i = {
> +			.value = NULL,
> +			.value_len = 0,

These two initialisations actually aren't needed, but they serve as
commentary if that is what was intended.

> +		};
> +		unsigned int total_size, shift_bytes, temp = ~0U;

It would be better to do

		unsigned int total_size;	/* description */
		unsigned int shift_bytes;	/* description */
		unsigned int temp = ~0U;	/* description */

because a) it is more readable, b) it makes subsequent patches cleaner and
c) it leaves room for descriptions.  c) is particularly important for
variables which are called "tmp" and "temp".

Please don't call variables "tmp" or "temp".

> +
> +		is = (struct ext4_xattr_ibody_find *) kmalloc(sizeof(struct
> +					 ext4_xattr_ibody_find), GFP_KERNEL);
> +		bs = (struct ext4_xattr_block_find *) kmalloc(sizeof(struct
> +					 ext4_xattr_block_find), GFP_KERNEL);

Two unneeded (and undesirable) casts of void*

> +		memset((void *)is, 0, sizeof(struct ext4_xattr_ibody_find));
> +		memset((void *)bs, 0, sizeof(struct ext4_xattr_block_find));

Two more unneeded casts.

This code should use kzalloc().

> +		is->s.not_found = bs->s.not_found = -ENODATA;

Multiple assignement.

> +		is->iloc.bh = NULL;
> +		bs->bh = NULL;
> +
> +		last = IFIRST(header);
> +		/* Find the entry best suited to be pushed into EA block */
> +		entry = NULL;
> +		for (; !IS_LAST_ENTRY(last); last = EXT4_XATTR_NEXT(last)) {
> +			total_size =
> +			EXT4_XATTR_SIZE(le32_to_cpu(last->e_value_size)) +
> +					EXT4_XATTR_LEN(last->e_name_len);
> +			if (total_size <= free && total_size < temp) {
> +				if (total_size < new_extra_isize) {
> +					small_entry = last;
> +				} else {
> +					entry = last;
> +					temp = total_size;
> +				}
> +			}
> +		}
> +
> +		if (entry == NULL) {
> +			if (small_entry) {
> +				entry = small_entry;
> +			} else {
> +				if (!tried_min_extra_isize &&
> +				    s_min_extra_isize) {
> +					tried_min_extra_isize++;
> +					new_extra_isize = s_min_extra_isize;
> +					goto retry;
> +				}
> +				error = -1;
> +				goto cleanup;
> +			}
> +		}
> +		offs = le16_to_cpu(entry->e_value_offs);
> +		size = le32_to_cpu(entry->e_value_size);
> +		entry_size = EXT4_XATTR_LEN(entry->e_name_len);
> +		i.name_index = entry->e_name_index,
> +		buffer = kmalloc(EXT4_XATTR_SIZE(size), GFP_KERNEL);
> +		b_entry_name = kmalloc(entry->e_name_len + 1, GFP_KERNEL);

Check kmalloc() failure, add recovery code.  The fault-injection framework
might be useful when testing that recovery code.

> +		/* Save the entry name and the entry value */
> +		memcpy((void *)buffer, (void *)IFIRST(header) + offs,
> +		       EXT4_XATTR_SIZE(size));
> +		memcpy((void *)b_entry_name, (void *)entry->e_name,
> +		       entry->e_name_len);

Lots of unneeded casts there.

> +		b_entry_name[entry->e_name_len] = '\0';
> +		i.name = b_entry_name;
> +
> +		error = ext4_get_inode_loc(inode, &is->iloc);
> +		if (error)
> +			goto cleanup;
> +
> +		error = ext4_xattr_ibody_find(inode, &i, is);
> +		if (error)
> +			goto cleanup;
> +
> +		/* Remove the chosen entry from the inode */
> +		error = ext4_xattr_ibody_set(handle, inode, &i, is);
> +
> +		entry = IFIRST(header);
> +		if (entry_size + EXT4_XATTR_SIZE(size) >= new_extra_isize)
> +			shift_bytes = new_extra_isize;
> +		else
> +			shift_bytes = entry_size + size;
> +		/* Adjust the offsets and shift the remaining entries ahead */
> +		ext4_xattr_shift_entries(entry, EXT4_I(inode)->i_extra_isize -
> +			shift_bytes, (void *)raw_inode +
> +			EXT4_GOOD_OLD_INODE_SIZE + extra_isize + shift_bytes,
> +			(void *)header, total_ino - entry_size,
> +			inode->i_sb->s_blocksize);
> +
> +		extra_isize += shift_bytes;
> +		new_extra_isize -= shift_bytes;
> +		EXT4_I(inode)->i_extra_isize = extra_isize;
> +
> +		i.name = b_entry_name;
> +		i.value = buffer;
> +		i.value_len = cpu_to_le32(size);
> +		error = ext4_xattr_block_find(inode, &i, bs);
> +		if (error)
> +			goto cleanup;
> +
> +		/* Add entry which was removed from the inode into the block */
> +		error = ext4_xattr_block_set(handle, inode, &i, bs);
> +		if (error)
> +			goto cleanup;
> +	}
> +
> +cleanup:
> +	if (b_entry_name)
> +		kfree(b_entry_name);
> +	if (buffer)
> +		kfree(buffer);
> +	if (is) {
> +		brelse(is->iloc.bh);
> +		kfree(is);
> +	}
> +	if (bs)
> +		kfree(bs);

kfree(NULL) is legal.  (Can we teach checkpatch about this?)

> +	brelse(bh);
> +	up_write(&EXT4_I(inode)->xattr_sem);
> +	return error;
> +}
> +

We're doing GFP_KERNEL memory allocations while holding xattr_sem.  This
can cause the VM to reenter the filesystem, perhaps taking i_mutex and/or
i_truncate_sem and/or journal_start() (I forget whether this still
happens).  Have we checked whether this can occur and if so, whether we are
OK from a lock ranking POV?  Bear in mind that journalled-data mode is more
complex in this regard.

> +
>  /*
>   * ext4_xattr_delete_inode()
>   *
> Index: linux-2.6.22-rc4/fs/ext4/xattr.h
> ===================================================================
> --- linux-2.6.22-rc4.orig/fs/ext4/xattr.h	2007-06-14 17:30:37.000000000 -0700
> +++ linux-2.6.22-rc4/fs/ext4/xattr.h	2007-06-14 17:32:41.000000000 -0700
> @@ -56,6 +56,13 @@ struct ext4_xattr_entry {
>  #define EXT4_XATTR_SIZE(size) \
>  	(((size) + EXT4_XATTR_ROUND) & ~EXT4_XATTR_ROUND)
>  
> +#define IHDR(inode, raw_inode) \
> +	((struct ext4_xattr_ibody_header *) \
> +		((void *)raw_inode + \
> +		EXT4_GOOD_OLD_INODE_SIZE + \
> +		EXT4_I(inode)->i_extra_isize))
> +#define IFIRST(hdr) ((struct ext4_xattr_entry *)((hdr)+1))

Neither of these _have_ to be implemented as macros and hence they should
not be.


