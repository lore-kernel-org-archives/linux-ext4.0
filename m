From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 12/16] ext4: Calculate and verify checksums of
	directory leaf blocks
Date: Mon, 5 Sep 2011 11:30:36 -0700
Message-ID: <20110905183036.GP12086@tux1.beaverton.ibm.com>
References: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com> <20110901003153.31048.982.stgit@elm3c44.beaverton.ibm.com> <4D5D8FB2-0D8A-4D30-B6D8-51158395C1C9@dilger.ca> <20110902185744.GH12086@tux1.beaverton.ibm.com> <7ACD3B0D-354C-4A93-A840-7D363E2D0B28@dilger.ca>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:56872 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027Ab1IESak (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Sep 2011 14:30:40 -0400
Content-Disposition: inline
In-Reply-To: <7ACD3B0D-354C-4A93-A840-7D363E2D0B28@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 02, 2011 at 02:52:32PM -0600, Andreas Dilger wrote:
> On 2011-09-02, at 12:57 PM, Darrick J. Wong wrote:
> > On Thu, Sep 01, 2011 at 01:36:50AM -0600, Andreas Dilger wrote:
> >> On 2011-08-31, at 6:31 PM, Darrick J. Wong wrote:
> >>>  /*
> >>> + * This is a bogus directory entry at the end of each leaf block that
> >>> + * records checksums.
> >>> + */
> >>> +struct ext4_dir_entry_tail {
> >>> +	__le32	reserved_zero1;		/* Pretend to be unused */
> >>> +	__le16	rec_len;		/* 12 */
> >>> +	__le16	reserved_zero2;		/* Zero name length */
> >>> +	__le32	checksum;		/* crc32c(uuid+inum+dirblock) */
> >>> +};
> >> 
> >> Since this field is stored inline with existing directory entries, it
> >> may make sense to also add a magic value to this entry (preferably one
> >> with non-ASCII values) so that it can be distinguished from an empty
> >> dirent that happens to be at the end of the block.
> > 
> > I could set the file type to 0xDE since currently there's only 8 file types
> > defined.
> 
> This seems possible, since the dirent is empty the value stored in
> file_type is largely irrelevant.
> 
> It also definitely makes sense to declare this as an "ext4_dir_entry_2"
> style structure, since this is the only dirent that is used in the ext4
> code.  I'd be happy if you also deleted the ext4_dir_entry structure
> definition from ext4.h, since it is unused and only serves to potentially
> cause confusion if used accidentally.

Perhaps, but as a separate patchset.

> You could do the whole sanity check for this tail dirent by treating
> it as a 64-bit magic number:
> 
> struct ext4_dirent_tail {
> 	union {
> 		struct {
> 			__le32	inode_zero;	/* Pretend to be unused */
> 			__le16	rec_len;	/* 12 */
> 			__u8	name_zero;	/* Zero name length */
> 			__u8	file_type;	/* 0xde */
> 		};
> 		__le64		det_magic;
> 	};
> 	__le32	det_checksum;
> };
> 
> #define EXT4_DIRENT_TAIL_MAGIC 0xde000c000000
> 
> That said, looking at this magic number doesn't give me a world of
> confidence that it will not be accidentally duplicated, though at
> the same time consecutive NUL bytes do not happen in filenames, so
> maybe it is OK.

det_checksum sits where the filename usually goes, so that won't be the case.
On the other hand, there are very few zero-length directory entries, so we're
probably ok.

--D
> 
> >>> /* checksumming functions */
> >>> +static struct ext4_dir_entry_tail *get_dirent_tail(struct inode *inode,
> >>> +						   struct ext4_dir_entry *de)
> >>> +{
> >>> +	struct ext4_dir_entry *d, *top;
> >>> +	struct ext4_dir_entry_tail *t;
> >>> +
> >>> +	d = de;
> >>> +	top = (struct ext4_dir_entry *)(((void *)de) +
> >>> +		(EXT4_BLOCK_SIZE(inode->i_sb) -
> >>> +		sizeof(struct ext4_dir_entry_tail)));
> >>> +	while (d < top && d->rec_len)
> >>> +		d = (struct ext4_dir_entry *)(((void *)d) +
> >>> +		    le16_to_cpu(d->rec_len));
> >> 
> >> Calling get_dirent_tail() is fairly expensive, because it has to walk
> >> the whole directory block each time.  When filling a block it would
> >> be O(n^2) for the number of entries in the block.
> >> 
> >> It would be more efficient to just cast the end of the directory block
> >> to the ext4_dir_entry_tail and check its validity, which is especially
> >> easy if there is a magic value in it.
> >> 
> >>> +	if (d != top)
> >>> +		return NULL;
> >>> +
> >>> +	t = (struct ext4_dir_entry_tail *)d;
> >>> +	if (t->reserved_zero1 ||
> >>> +	    le16_to_cpu(t->rec_len) != sizeof(struct ext4_dir_entry_tail) ||
> >>> +	    t->reserved_zero2)
> >> 
> >> I'd prefer these reserved_zero[12] fields be explicitly compared to zero
> >> instead of treated as boolean values.
> > 
> > Ok.
> > 
> >>> +		return NULL;
> >>> +
> >>> +	return t;
> >>> +}
> >>> +
> >>> +static __le32 ext4_dirent_csum(struct inode *inode,
> >>> +			       struct ext4_dir_entry *dirent)
> >>> +{
> >>> +	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
> >>> +	struct ext4_dir_entry_tail *t;
> >>> +	__le32 inum = cpu_to_le32(inode->i_ino);
> >>> +	int size;
> >>> +	__u32 crc = 0;
> >>> +
> >>> +	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> >>> +					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
> >>> +		return 0;
> >>> +
> >>> +	t = get_dirent_tail(inode, dirent);
> >> 
> >>> +	if (!t)
> >>> +		return 0;
> >>> +
> >>> +	size = (void *)t - (void *)dirent;
> >>> +	crc = crc32c_le(~0, sbi->s_es->s_uuid, sizeof(sbi->s_es->s_uuid));
> >>> +	crc = crc32c_le(crc, (__u8 *)&inum, sizeof(inum));
> >> 
> >> Based on the number of times that the s_uuid+inum checksum is used in this
> >> code, and since it is constant for the life of the inode, it probably
> >> makes sense to precompute it and store it in ext4_inode_info.
> > 
> > Agreed.
> > 
> >> Also, now that I think about it, these checksums that contain the inum
> >> should also contain i_generation, so that there is no confusion with
> >> accessing old blocks on disk.
> > 
> > i_generation only gets updated when inodes are created or SETVERSION ioctl is
> > called, correct?  I guess it wouldn't be too difficult to rewrite all file
> > metadata, though it could get a little expensive.
> 
> I don't think SETVERSION is used in any regular cases (at least I'm not
> aware of any applications/tools that use it).  Note that, despite the
> name, this sets the i_generation field and not the NFSv4 i_version field,
> so it should be constant for the life of the inode.  In the short term you
> could just disable SETVERSION on an inode if checksums are enabled, and
> see if anyone complains about it at all.
> 
> Cheers, Andreas
> 
> >>> +	crc = crc32c_le(crc, (__u8 *)dirent, size);
> >>> +	return cpu_to_le32(crc);
> >>> +}
> >>> +
> >>> +int ext4_dirent_csum_verify(struct inode *inode, struct ext4_dir_entry *dirent)
> >>> +{
> >>> +	struct ext4_dir_entry_tail *t;
> >>> +
> >>> +	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> >>> +					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
> >>> +		return 1;
> >>> +
> >>> +	t = get_dirent_tail(inode, dirent);
> >>> +	if (!t) {
> >>> +		EXT4_ERROR_INODE(inode, "metadata_csum set but no space in dir "
> >>> +				 "leaf for checksum.  Please run e2fsck -D.");
> >>> +		return 0;
> >>> +	}
> >> 
> >> I don't think this should necessarily be considered an error.  That
> >> there is no space in the directory block is not a sign of corruption.
> > 
> > I was trying to steer users towards running fsck, which will notice the
> > lack of space and rebuild the dir.  With a somewhat large mallet. :)
> 
> Yes, but this would cause a service interruption because the filesystem
> will be mounted read-only and/or panic the kernel, which is not justified
> for a situation which is legitimately possible and does not indicate data
> corruption of the filesystem.
> 
> >>> +
> >>> +	if (t->checksum != ext4_dirent_csum(inode, dirent))
> >>> +		return 0;
> >>> +
> >>> +	return 1;
> >>> +}
> >>> +
> >>> +static void ext4_dirent_csum_set(struct inode *inode,
> >>> +				 struct ext4_dir_entry *dirent)
> >>> +{
> >>> +	struct ext4_dir_entry_tail *t;
> >>> +
> >>> +	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> >>> +					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
> >>> +		return;
> >>> +
> >>> +	t = get_dirent_tail(inode, dirent);
> >>> +	if (!t) {
> >>> +		EXT4_ERROR_INODE(inode, "metadata_csum set but no space in dir "
> >>> +				 "leaf for checksum.  Please run e2fsck -D.");
> >>> +		return;
> >>> +	}
> >>> +
> >>> +	t->checksum = ext4_dirent_csum(inode, dirent);
> >>> +}
> >>> +
> >>> +static inline int ext4_handle_dirty_dirent_node(handle_t *handle,
> >>> +						struct inode *inode,
> >>> +						struct buffer_head *bh)
> >>> +{
> >>> +	ext4_dirent_csum_set(inode, (struct ext4_dir_entry *)bh->b_data);
> >>> +	return ext4_handle_dirty_metadata(handle, inode, bh);
> >>> +}
> >>> +
> >>> static struct dx_countlimit *get_dx_countlimit(struct inode *inode,
> >>> 					       struct ext4_dir_entry *dirent,
> >>> 					       int *offset)
> >>> @@ -748,6 +846,11 @@ static int htree_dirblock_to_tree(struct file *dir_file,
> >>> 	if (!(bh = ext4_bread (NULL, dir, block, 0, &err)))
> >>> 		return err;
> >>> 
> >>> +	if (!buffer_verified(bh) &&
> >>> +	    !ext4_dirent_csum_verify(dir, (struct ext4_dir_entry *)bh->b_data))
> >>> +		return -EIO;
> >>> +	set_buffer_verified(bh);
> >>> +
> >>> 	de = (struct ext4_dir_entry_2 *) bh->b_data;
> >> 
> >> You might as well set de before calling ext4_dirent_csum_verify() to avoid
> >> having another unsightly cast.
> > 
> > Ok.
> > 
> >>> 	top = (struct ext4_dir_entry_2 *) ((char *) de +
> >>> 					   dir->i_sb->s_blocksize -
> >>> @@ -1106,6 +1209,15 @@ restart:
> >>> 			brelse(bh);
> >>> 			goto next;
> >>> 		}
> >>> +		if (!buffer_verified(bh) &&
> >>> +		    !ext4_dirent_csum_verify(dir,
> >>> +				(struct ext4_dir_entry *)bh->b_data)) {
> >>> +			EXT4_ERROR_INODE(dir, "checksumming directory "
> >>> +					 "block %lu", (unsigned long)block);
> >>> +			brelse(bh);
> >>> +			goto next;
> >>> +		}
> >>> +		set_buffer_verified(bh);
> >>> 		i = search_dirblock(bh, dir, d_name,
> >>> 			    block << EXT4_BLOCK_SIZE_BITS(sb), res_dir);
> >>> 		if (i == 1) {
> >>> @@ -1157,6 +1269,16 @@ static struct buffer_head * ext4_dx_find_entry(struct inode *dir, const struct q
> >>> 		if (!(bh = ext4_bread(NULL, dir, block, 0, err)))
> >>> 			goto errout;
> >>> 
> >>> +		if (!buffer_verified(bh) &&
> >>> +		    !ext4_dirent_csum_verify(dir,
> >>> +				(struct ext4_dir_entry *)bh->b_data)) {
> >>> +			EXT4_ERROR_INODE(dir, "checksumming directory "
> >>> +					 "block %lu", (unsigned long)block);
> >>> +			brelse(bh);
> >>> +			*err = -EIO;
> >>> +			goto errout;
> >>> +		}
> >>> +		set_buffer_verified(bh);
> >>> 		retval = search_dirblock(bh, dir, d_name,
> >>> 					 block << EXT4_BLOCK_SIZE_BITS(sb),
> >>> 					 res_dir);
> >>> @@ -1329,8 +1451,14 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
> >>> 	char *data1 = (*bh)->b_data, *data2;
> >>> 	unsigned split, move, size;
> >>> 	struct ext4_dir_entry_2 *de = NULL, *de2;
> >>> +	struct ext4_dir_entry_tail *t;
> >>> +	int	csum_size = 0;
> >>> 	int	err = 0, i;
> >>> 
> >>> +	if (EXT4_HAS_RO_COMPAT_FEATURE(dir->i_sb,
> >>> +				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
> >>> +		csum_size = sizeof(struct ext4_dir_entry_tail);
> >>> +
> >>> 	bh2 = ext4_append (handle, dir, &newblock, &err);
> >>> 	if (!(bh2)) {
> >>> 		brelse(*bh);
> >>> @@ -1377,10 +1505,24 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
> >>> 	/* Fancy dance to stay within two buffers */
> >>> 	de2 = dx_move_dirents(data1, data2, map + split, count - split, blocksize);
> >>> 	de = dx_pack_dirents(data1, blocksize);
> >>> -	de->rec_len = ext4_rec_len_to_disk(data1 + blocksize - (char *) de,
> >>> +	de->rec_len = ext4_rec_len_to_disk(data1 + (blocksize - csum_size) -
> >>> +					   (char *) de,
> >>> 					   blocksize);
> >> 
> >> (style) This should be "(char *)de, blocksize);"
> >> 
> >>> -	de2->rec_len = ext4_rec_len_to_disk(data2 + blocksize - (char *) de2,
> >>> +	de2->rec_len = ext4_rec_len_to_disk(data2 + (blocksize - csum_size) -
> >>> +					    (char *) de2,
> >>> 					    blocksize);
> >> 
> >> (style) likewise
> >> 
> >>> +	if (csum_size) {
> >>> +		t = (struct ext4_dir_entry_tail *)(data2 +
> >>> +						   (blocksize - csum_size));
> >>> +		memset(t, 0, csum_size);
> >>> +		t->rec_len = ext4_rec_len_to_disk(csum_size, blocksize);
> >>> +
> >>> +		t = (struct ext4_dir_entry_tail *)(data1 +
> >>> +						   (blocksize - csum_size));
> >>> +		memset(t, 0, csum_size);
> >>> +		t->rec_len = ext4_rec_len_to_disk(csum_size, blocksize);
> >>> +	}
> >>> +
> >>> 	dxtrace(dx_show_leaf (hinfo, (struct ext4_dir_entry_2 *) data1, blocksize, 1));
> >>> 	dxtrace(dx_show_leaf (hinfo, (struct ext4_dir_entry_2 *) data2, blocksize, 1));
> >>> 
> >>> @@ -1391,7 +1533,7 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
> >>> 		de = de2;
> >>> 	}
> >>> 	dx_insert_block(frame, hash2 + continued, newblock);
> >>> -	err = ext4_handle_dirty_metadata(handle, dir, bh2);
> >>> +	err = ext4_handle_dirty_dirent_node(handle, dir, bh2);
> >>> 	if (err)
> >>> 		goto journal_error;
> >>> 	err = ext4_handle_dirty_dx_node(handle, dir, frame->bh);
> >>> @@ -1431,11 +1573,16 @@ static int add_dirent_to_buf(handle_t *handle, struct dentry *dentry,
> >>> 	unsigned short	reclen;
> >>> 	int		nlen, rlen, err;
> >>> 	char		*top;
> >>> +	int		csum_size = 0;
> >>> +
> >>> +	if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> >>> +				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
> >>> +		csum_size = sizeof(struct ext4_dir_entry_tail);
> >>> 
> >>> 	reclen = EXT4_DIR_REC_LEN(namelen);
> >>> 	if (!de) {
> >>> 		de = (struct ext4_dir_entry_2 *)bh->b_data;
> >>> -		top = bh->b_data + blocksize - reclen;
> >>> +		top = bh->b_data + (blocksize - csum_size) - reclen;
> >>> 		while ((char *) de <= top) {
> >>> 			if (ext4_check_dir_entry(dir, NULL, de, bh, offset))
> >>> 				return -EIO;
> >>> @@ -1491,7 +1638,7 @@ static int add_dirent_to_buf(handle_t *handle, struct dentry *dentry,
> >>> 	dir->i_version++;
> >>> 	ext4_mark_inode_dirty(handle, dir);
> >>> 	BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
> >>> -	err = ext4_handle_dirty_metadata(handle, dir, bh);
> >>> +	err = ext4_handle_dirty_dirent_node(handle, dir, bh);
> >>> 	if (err)
> >>> 		ext4_std_error(dir->i_sb, err);
> >>> 	return 0;
> >>> @@ -1512,6 +1659,7 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
> >>> 	struct dx_frame	frames[2], *frame;
> >>> 	struct dx_entry *entries;
> >>> 	struct ext4_dir_entry_2	*de, *de2;
> >>> +	struct ext4_dir_entry_tail *t;
> >>> 	char		*data1, *top;
> >>> 	unsigned	len;
> >>> 	int		retval;
> >>> @@ -1519,6 +1667,11 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
> >>> 	struct dx_hash_info hinfo;
> >>> 	ext4_lblk_t  block;
> >>> 	struct fake_dirent *fde;
> >>> +	int		csum_size = 0;
> >>> +
> >>> +	if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> >>> +				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
> >>> +		csum_size = sizeof(struct ext4_dir_entry_tail);
> >>> 
> >>> 	blocksize =  dir->i_sb->s_blocksize;
> >>> 	dxtrace(printk(KERN_DEBUG "Creating index: inode %lu\n", dir->i_ino));
> >>> @@ -1539,7 +1692,7 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
> >>> 		brelse(bh);
> >>> 		return -EIO;
> >>> 	}
> >>> -	len = ((char *) root) + blocksize - (char *) de;
> >>> +	len = ((char *) root) + (blocksize - csum_size) - (char *) de;
> >> 
> >> (style) "(char *)root)" and "(char *)de".
> >> 
> >>> 	/* Allocate new block for the 0th block's dirents */
> >>> 	bh2 = ext4_append(handle, dir, &block, &retval);
> >>> @@ -1555,8 +1708,17 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
> >>> 	top = data1 + len;
> >>> 	while ((char *)(de2 = ext4_next_entry(de, blocksize)) < top)
> >>> 		de = de2;
> >>> -	de->rec_len = ext4_rec_len_to_disk(data1 + blocksize - (char *) de,
> >>> +	de->rec_len = ext4_rec_len_to_disk(data1 + (blocksize - csum_size) -
> >>> +					   (char *) de,
> >>> 					   blocksize);
> >> 
> >> Likewise.
> > 
> > Ok, I'll fix the style complaints.  Should checkpatch find these things?
> > 
> > --D
> > 
> >>> +
> >>> +	if (csum_size) {
> >>> +		t = (struct ext4_dir_entry_tail *)(data1 +
> >>> +						   (blocksize - csum_size));
> >>> +		memset(t, 0, csum_size);
> >>> +		t->rec_len = ext4_rec_len_to_disk(csum_size, blocksize);
> >>> +	}
> >>> +
> >>> 	/* Initialize the root; the dot dirents already exist */
> >>> 	de = (struct ext4_dir_entry_2 *) (&root->dotdot);
> >>> 	de->rec_len = ext4_rec_len_to_disk(blocksize - EXT4_DIR_REC_LEN(2),
> >>> @@ -1582,7 +1744,7 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
> >>> 	bh = bh2;
> >>> 
> >>> 	ext4_handle_dirty_dx_node(handle, dir, frame->bh);
> >>> -	ext4_handle_dirty_metadata(handle, dir, bh);
> >>> +	ext4_handle_dirty_dirent_node(handle, dir, bh);
> >>> 
> >>> 	de = do_split(handle,dir, &bh, frame, &hinfo, &retval);
> >>> 	if (!de) {
> >>> @@ -1618,11 +1780,17 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
> >>> 	struct inode *dir = dentry->d_parent->d_inode;
> >>> 	struct buffer_head *bh;
> >>> 	struct ext4_dir_entry_2 *de;
> >>> +	struct ext4_dir_entry_tail *t;
> >>> 	struct super_block *sb;
> >>> 	int	retval;
> >>> 	int	dx_fallback=0;
> >>> 	unsigned blocksize;
> >>> 	ext4_lblk_t block, blocks;
> >>> +	int	csum_size = 0;
> >>> +
> >>> +	if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> >>> +				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
> >>> +		csum_size = sizeof(struct ext4_dir_entry_tail);
> >>> 
> >>> 	sb = dir->i_sb;
> >>> 	blocksize = sb->s_blocksize;
> >>> @@ -1641,6 +1809,11 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
> >>> 		bh = ext4_bread(handle, dir, block, 0, &retval);
> >>> 		if(!bh)
> >>> 			return retval;
> >>> +		if (!buffer_verified(bh) &&
> >>> +		    !ext4_dirent_csum_verify(dir,
> >>> +				(struct ext4_dir_entry *)bh->b_data))
> >>> +			return -EIO;
> >>> +		set_buffer_verified(bh);
> >>> 		retval = add_dirent_to_buf(handle, dentry, inode, NULL, bh);
> >>> 		if (retval != -ENOSPC) {
> >>> 			brelse(bh);
> >>> @@ -1657,7 +1830,15 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
> >>> 		return retval;
> >>> 	de = (struct ext4_dir_entry_2 *) bh->b_data;
> >>> 	de->inode = 0;
> >>> -	de->rec_len = ext4_rec_len_to_disk(blocksize, blocksize);
> >>> +	de->rec_len = ext4_rec_len_to_disk(blocksize - csum_size, blocksize);
> >>> +
> >>> +	if (csum_size) {
> >>> +		t = (struct ext4_dir_entry_tail *)(((void *)bh->b_data) +
> >>> +						   (blocksize - csum_size));
> >>> +		memset(t, 0, csum_size);
> >>> +		t->rec_len = ext4_rec_len_to_disk(csum_size, blocksize);
> >>> +	}
> >>> +
> >>> 	retval = add_dirent_to_buf(handle, dentry, inode, de, bh);
> >>> 	brelse(bh);
> >>> 	if (retval == 0)
> >>> @@ -1689,6 +1870,11 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
> >>> 	if (!(bh = ext4_bread(handle,dir, dx_get_block(frame->at), 0, &err)))
> >>> 		goto cleanup;
> >>> 
> >>> +	if (!buffer_verified(bh) &&
> >>> +	    !ext4_dirent_csum_verify(dir, (struct ext4_dir_entry *)bh->b_data))
> >>> +		goto journal_error;
> >>> +	set_buffer_verified(bh);
> >>> +
> >>> 	BUFFER_TRACE(bh, "get_write_access");
> >>> 	err = ext4_journal_get_write_access(handle, bh);
> >>> 	if (err)
> >>> @@ -1814,12 +2000,17 @@ static int ext4_delete_entry(handle_t *handle,
> >>> {
> >>> 	struct ext4_dir_entry_2 *de, *pde;
> >>> 	unsigned int blocksize = dir->i_sb->s_blocksize;
> >>> +	int csum_size = 0;
> >>> 	int i, err;
> >>> 
> >>> +	if (EXT4_HAS_RO_COMPAT_FEATURE(dir->i_sb,
> >>> +				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
> >>> +		csum_size = sizeof(struct ext4_dir_entry_tail);
> >>> +
> >>> 	i = 0;
> >>> 	pde = NULL;
> >>> 	de = (struct ext4_dir_entry_2 *) bh->b_data;
> >>> -	while (i < bh->b_size) {
> >>> +	while (i < bh->b_size - csum_size) {
> >>> 		if (ext4_check_dir_entry(dir, NULL, de, bh, i))
> >>> 			return -EIO;
> >>> 		if (de == de_del)  {
> >>> @@ -1840,7 +2031,7 @@ static int ext4_delete_entry(handle_t *handle,
> >>> 				de->inode = 0;
> >>> 			dir->i_version++;
> >>> 			BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
> >>> -			err = ext4_handle_dirty_metadata(handle, dir, bh);
> >>> +			err = ext4_handle_dirty_dirent_node(handle, dir, bh);
> >>> 			if (unlikely(err)) {
> >>> 				ext4_std_error(dir->i_sb, err);
> >>> 				return err;
> >>> @@ -1983,9 +2174,15 @@ static int ext4_mkdir(struct inode *dir, struct dentry *dentry, int mode)
> >>> 	struct inode *inode;
> >>> 	struct buffer_head *dir_block = NULL;
> >>> 	struct ext4_dir_entry_2 *de;
> >>> +	struct ext4_dir_entry_tail *t;
> >>> 	unsigned int blocksize = dir->i_sb->s_blocksize;
> >>> +	int csum_size = 0;
> >>> 	int err, retries = 0;
> >>> 
> >>> +	if (EXT4_HAS_RO_COMPAT_FEATURE(dir->i_sb,
> >>> +				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
> >>> +		csum_size = sizeof(struct ext4_dir_entry_tail);
> >>> +
> >>> 	if (EXT4_DIR_LINK_MAX(dir))
> >>> 		return -EMLINK;
> >>> 
> >>> @@ -2026,16 +2223,26 @@ retry:
> >>> 	ext4_set_de_type(dir->i_sb, de, S_IFDIR);
> >>> 	de = ext4_next_entry(de, blocksize);
> >>> 	de->inode = cpu_to_le32(dir->i_ino);
> >>> -	de->rec_len = ext4_rec_len_to_disk(blocksize - EXT4_DIR_REC_LEN(1),
> >>> +	de->rec_len = ext4_rec_len_to_disk(blocksize -
> >>> +					   (csum_size + EXT4_DIR_REC_LEN(1)),
> >>> 					   blocksize);
> >>> 	de->name_len = 2;
> >>> 	strcpy(de->name, "..");
> >>> 	ext4_set_de_type(dir->i_sb, de, S_IFDIR);
> >>> 	inode->i_nlink = 2;
> >>> +
> >>> +	if (csum_size) {
> >>> +		t = (struct ext4_dir_entry_tail *)(((void *)dir_block->b_data) +
> >>> +						   (blocksize - csum_size));
> >>> +		memset(t, 0, csum_size);
> >>> +		t->rec_len = ext4_rec_len_to_disk(csum_size, blocksize);
> >>> +	}
> >>> +
> >>> 	BUFFER_TRACE(dir_block, "call ext4_handle_dirty_metadata");
> >>> -	err = ext4_handle_dirty_metadata(handle, inode, dir_block);
> >>> +	err = ext4_handle_dirty_dirent_node(handle, inode, dir_block);
> >>> 	if (err)
> >>> 		goto out_clear_inode;
> >>> +	set_buffer_verified(dir_block);
> >>> 	err = ext4_mark_inode_dirty(handle, inode);
> >>> 	if (!err)
> >>> 		err = ext4_add_entry(handle, dentry, inode);
> >>> @@ -2085,6 +2292,14 @@ static int empty_dir(struct inode *inode)
> >>> 				     inode->i_ino);
> >>> 		return 1;
> >>> 	}
> >>> +	if (!buffer_verified(bh) &&
> >>> +	    !ext4_dirent_csum_verify(inode,
> >>> +			(struct ext4_dir_entry *)bh->b_data)) {
> >>> +		EXT4_ERROR_INODE(inode, "checksum error reading directory "
> >>> +				 "lblock 0");
> >>> +		return -EIO;
> >>> +	}
> >>> +	set_buffer_verified(bh);
> >>> 	de = (struct ext4_dir_entry_2 *) bh->b_data;
> >>> 	de1 = ext4_next_entry(de, sb->s_blocksize);
> >>> 	if (le32_to_cpu(de->inode) != inode->i_ino ||
> >>> @@ -2116,6 +2331,14 @@ static int empty_dir(struct inode *inode)
> >>> 				offset += sb->s_blocksize;
> >>> 				continue;
> >>> 			}
> >>> +			if (!buffer_verified(bh) &&
> >>> +			    !ext4_dirent_csum_verify(inode,
> >>> +					(struct ext4_dir_entry *)bh->b_data)) {
> >>> +				EXT4_ERROR_INODE(inode, "checksum error "
> >>> +						 "reading directory lblock 0");
> >>> +				return -EIO;
> >>> +			}
> >>> +			set_buffer_verified(bh);
> >>> 			de = (struct ext4_dir_entry_2 *) bh->b_data;
> >>> 		}
> >>> 		if (ext4_check_dir_entry(inode, NULL, de, bh, offset)) {
> >>> @@ -2616,6 +2839,11 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
> >>> 		dir_bh = ext4_bread(handle, old_inode, 0, 0, &retval);
> >>> 		if (!dir_bh)
> >>> 			goto end_rename;
> >>> +		if (!buffer_verified(dir_bh) &&
> >>> +		    !ext4_dirent_csum_verify(old_inode,
> >>> +				(struct ext4_dir_entry *)dir_bh->b_data))
> >>> +			goto end_rename;
> >>> +		set_buffer_verified(dir_bh);
> >>> 		if (le32_to_cpu(PARENT_INO(dir_bh->b_data,
> >>> 				old_dir->i_sb->s_blocksize)) != old_dir->i_ino)
> >>> 			goto end_rename;
> >>> @@ -2646,7 +2874,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
> >>> 					ext4_current_time(new_dir);
> >>> 		ext4_mark_inode_dirty(handle, new_dir);
> >>> 		BUFFER_TRACE(new_bh, "call ext4_handle_dirty_metadata");
> >>> -		retval = ext4_handle_dirty_metadata(handle, new_dir, new_bh);
> >>> +		retval = ext4_handle_dirty_dirent_node(handle, new_dir, new_bh);
> >>> 		if (unlikely(retval)) {
> >>> 			ext4_std_error(new_dir->i_sb, retval);
> >>> 			goto end_rename;
> >>> @@ -2700,7 +2928,8 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
> >>> 		PARENT_INO(dir_bh->b_data, new_dir->i_sb->s_blocksize) =
> >>> 						cpu_to_le32(new_dir->i_ino);
> >>> 		BUFFER_TRACE(dir_bh, "call ext4_handle_dirty_metadata");
> >>> -		retval = ext4_handle_dirty_metadata(handle, old_inode, dir_bh);
> >>> +		retval = ext4_handle_dirty_dirent_node(handle, old_inode,
> >>> +						       dir_bh);
> >>> 		if (retval) {
> >>> 			ext4_std_error(old_dir->i_sb, retval);
> >>> 			goto end_rename;
> >>> 
> >> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
