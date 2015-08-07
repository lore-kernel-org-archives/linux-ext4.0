From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 10/19] tune2fs: Implement setting and disabling of 64-bit
 feature
Date: Fri, 7 Aug 2015 08:42:23 -0700
Message-ID: <20150807154223.GE10037@birch.djwong.org>
References: <1438944689-24562-1-git-send-email-jack@suse.com>
 <1438944689-24562-11-git-send-email-jack@suse.com>
 <20150807153247.GA24988@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>
To: Jan Kara <jack@suse.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36412 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932113AbbHGPm3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Aug 2015 11:42:29 -0400
Content-Disposition: inline
In-Reply-To: <20150807153247.GA24988@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 07, 2015 at 08:32:47AM -0700, Darrick J. Wong wrote:
> On Fri, Aug 07, 2015 at 12:51:20PM +0200, Jan Kara wrote:
> > Currently resize2fs is used to toggle 64-bit feature. However tune2fs
> > should logically handle that as toggling any other feature. Since we
> > have now factored out block moving code from resize2fs it is relatively
> > easy to implement toggling of the feature within tune2fs.
> > 
> > For now we leave the same functionality also in resize2fs for testing.
> > Later we can make resize2fs call tune2fs for backward compatibility.
> 
> There hasn't been a release of e2fsprogs with 64bit conversion support in
> resize2fs, so you can fix the conversion tests to use tune2fs and remove the
> -b/-B switches from resize2fs entirely.

Oh, I didn't notice that you /do/ remove the resize2fs part later on in the
patch set.  Sorry for the noise about that.

I think there are still tests that need to be fixed up.

--D

> 
> --D
> 
> > 
> > Signed-off-by: Jan Kara <jack@suse.com>
> > ---
> >  misc/tune2fs.c | 367 +++++++++++++++++++++++++++++++++++++++++++++++++++++----
> >  1 file changed, 345 insertions(+), 22 deletions(-)
> > 
> > diff --git a/misc/tune2fs.c b/misc/tune2fs.c
> > index d2e8b20f64e2..d6bfad3374d1 100644
> > --- a/misc/tune2fs.c
> > +++ b/misc/tune2fs.c
> > @@ -447,10 +447,327 @@ static void request_fsck_afterwards(ext2_filsys fs)
> >  		printf("%s", _("(and reboot afterwards!)\n"));
> >  }
> >  
> > -static void convert_64bit(ext2_filsys fs, int direction)
> > +static errcode_t fix_resize_inode(ext2_filsys fs)
> >  {
> > -	if (!direction)
> > -		return;
> > +	errcode_t retval;
> > +
> > +	if (!(fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_RESIZE_INODE))
> > +		return 0;
> > +
> > +	retval = ext2fs_wipe_resize_inode(fs);
> > +	if (retval)
> > +		return retval;
> > +
> > +	return ext2fs_create_resize_inode(fs);
> > +}
> > +
> > +/*
> > + * Make blocks that are needed for new group metadata unused and write there
> > + * new group descriptors
> > + */
> > +static errcode_t move_bg_metadata(ext2_filsys fs, ext2_filsys new_fs)
> > +{
> > +	dgrp_t i;
> > +	blk64_t b, c, d, old_desc_blocks, new_desc_blocks, j;
> > +	ext2fs_block_bitmap old_map = NULL, new_map = NULL;
> > +	int old, new;
> > +	errcode_t retval;
> > +	int cluster_ratio;
> > +	int need_new_block = 0;
> > +
> > +	retval = ext2fs_allocate_block_bitmap(fs, "old map", &old_map);
> > +	if (retval)
> > +		goto out;
> > +
> > +	retval = ext2fs_allocate_block_bitmap(fs, "new map", &new_map);
> > +	if (retval)
> > +		goto out;
> > +
> > +	if (EXT2_HAS_INCOMPAT_FEATURE(fs->super,
> > +				      EXT2_FEATURE_INCOMPAT_META_BG)) {
> > +		old_desc_blocks = fs->super->s_first_meta_bg;
> > +		new_desc_blocks = new_fs->super->s_first_meta_bg;
> > +	} else {
> > +		old_desc_blocks = fs->desc_blocks +
> > +				  fs->super->s_reserved_gdt_blocks;
> > +		new_desc_blocks = new_fs->desc_blocks +
> > +				  new_fs->super->s_reserved_gdt_blocks;
> > +	}
> > +
> > +	/* Construct bitmaps of super/descriptor blocks in old and new fs */
> > +	for (i = 0; i < fs->group_desc_count; i++) {
> > +		retval = ext2fs_super_and_bgd_loc2(fs, i, &b, &c, &d, NULL);
> > +		if (retval)
> > +			goto out;
> > +		if (b)
> > +			ext2fs_mark_block_bitmap2(old_map, b);
> > +		for (j = 0; c != 0 && j < old_desc_blocks; j++)
> > +			ext2fs_mark_block_bitmap2(old_map, c + j);
> > +		if (d)
> > +			ext2fs_mark_block_bitmap2(old_map, d);
> > +
> > +		retval = ext2fs_super_and_bgd_loc2(new_fs, i, &b, &c, &d, NULL);
> > +		if (retval)
> > +			goto out;
> > +		if (b)
> > +			ext2fs_mark_block_bitmap2(new_map, b);
> > +		for (j = 0; c != 0 && j < new_desc_blocks; j++)
> > +			ext2fs_mark_block_bitmap2(new_map, c + j);
> > +		if (d)
> > +			ext2fs_mark_block_bitmap2(new_map, d);
> > +	}
> > +
> > +	cluster_ratio = EXT2FS_CLUSTER_RATIO(new_fs);
> > +
> > +	/* Find changes in block allocations for bg metadata */
> > +	for (b = EXT2FS_B2C(fs, fs->super->s_first_data_block);
> > +	     b < ext2fs_blocks_count(new_fs->super);
> > +	     b += cluster_ratio) {
> > +		old = ext2fs_test_block_bitmap2(old_map, b);
> > +		new = ext2fs_test_block_bitmap2(new_map, b);
> > +
> > +		if (old && !new) {
> > +			/* mark old_map, unmark new_map */
> > +			if (cluster_ratio == 1)
> > +				ext2fs_block_alloc_stats2(new_fs, b, -1);
> > +		} else if (!old && new)
> > +			need_new_block = 1; /* unmark old_map, mark new_map */
> > +		else {
> > +			ext2fs_unmark_block_bitmap2(old_map, b);
> > +			ext2fs_unmark_block_bitmap2(new_map, b);
> > +		}
> > +	}
> > +
> > +	/*
> > +	 * new_map now shows blocks that have been newly allocated.
> > +	 * old_map now shows blocks that have been newly freed.
> > +	 */
> > +
> > +	if (need_new_block) {
> > +		/*
> > +		 * Now relocate metadata & data conflicting with new descriptor
> > +		 * blocks
> > +		 */
> > +		retval = ext2fs_move_blocks(new_fs, new_map, old_map);
> > +		if (retval)
> > +			goto out;
> > +
> > +		/* Now mark blocks for new group descriptors as used */
> > +		for (b = 0; b < ext2fs_blocks_count(new_fs->super);
> > +		     b += cluster_ratio) {
> > +			if (ext2fs_test_block_bitmap2(new_map, b) &&
> > +			    !ext2fs_test_block_bitmap2(new_fs->block_map, b))
> > +				ext2fs_block_alloc_stats2(new_fs, b, +1);
> > +		}
> > +	}
> > +
> > +	if (cluster_ratio > 1) {
> > +		/* Free unused clusters */
> > +		for (b = 0; b < ext2fs_blocks_count(new_fs->super);
> > +		     b += cluster_ratio)
> > +			if (ext2fs_test_block_bitmap2(old_map, b))
> > +				ext2fs_block_alloc_stats2(new_fs, b, -1);
> > +	}
> > +
> > +	/* Now update resize inode */
> > +	retval = fix_resize_inode(new_fs);
> > +out:
> > +	if (old_map)
> > +		ext2fs_free_block_bitmap(old_map);
> > +	if (new_map)
> > +		ext2fs_free_block_bitmap(new_map);
> > +	return retval;
> > +}
> > +
> > +
> > +/* Toggle 64bit mode */
> > +static errcode_t resize_group_descriptors(ext2_filsys *fs_p, int direction)
> > +{
> > +	void *o, *n, *new_group_desc;
> > +	dgrp_t i;
> > +	int copy_size;
> > +	errcode_t retval;
> > +	ext2_filsys new_fs = NULL;
> > +	ext2_filsys fs = *fs_p;
> > +
> > +	retval = ext2fs_dup_handle(fs, &new_fs);
> > +	if (retval)
> > +		return retval;
> > +
> > +	if (direction < 0) {
> > +		new_fs->super->s_feature_incompat &=
> > +					~EXT4_FEATURE_INCOMPAT_64BIT;
> > +		new_fs->super->s_desc_size = EXT2_MIN_DESC_SIZE;
> > +	} else {
> > +		new_fs->super->s_feature_incompat |=
> > +					EXT4_FEATURE_INCOMPAT_64BIT;
> > +		new_fs->super->s_desc_size = EXT2_MIN_DESC_SIZE_64BIT;
> > +	}
> > +
> > +	o = new_fs->group_desc;
> > +	new_fs->desc_blocks = ext2fs_div_ceil(fs->group_desc_count,
> > +			EXT2_DESC_PER_BLOCK(new_fs->super));
> > +	retval = ext2fs_get_arrayzero(new_fs->desc_blocks,
> > +				      fs->blocksize, &new_group_desc);
> > +	if (retval)
> > +		goto out;
> > +
> > +	n = new_group_desc;
> > +
> > +	if (EXT2_DESC_SIZE(fs->super) <= EXT2_DESC_SIZE(new_fs->super))
> > +		copy_size = EXT2_DESC_SIZE(fs->super);
> > +	else
> > +		copy_size = EXT2_DESC_SIZE(new_fs->super);
> > +	for (i = 0; i < fs->group_desc_count; i++) {
> > +		memcpy(n, o, copy_size);
> > +		n += EXT2_DESC_SIZE(new_fs->super);
> > +		o += EXT2_DESC_SIZE(fs->super);
> > +	}
> > +
> > +	ext2fs_free_mem(&new_fs->group_desc);
> > +	new_fs->group_desc = new_group_desc;
> > +
> > +	for (i = 0; i < fs->group_desc_count; i++)
> > +		ext2fs_group_desc_csum_set(new_fs, i);
> > +
> > +	/*
> > +	 * Update number of reserved blocks so that we need to alloc / free as
> > +	 * few blocks as possible
> > +	 */
> > +	if ((fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_RESIZE_INODE) &&
> > +	    (fs->desc_blocks != new_fs->desc_blocks)) {
> > +		int new;
> > +
> > +		new = ((int) new_fs->super->s_reserved_gdt_blocks) +
> > +			(fs->desc_blocks - new_fs->desc_blocks);
> > +		if (new < 0)
> > +			new = 0;
> > +		if (new > (int) fs->blocksize / 4)
> > +			new = fs->blocksize / 4;
> > +		new_fs->super->s_reserved_gdt_blocks = new;
> > +	}
> > +
> > +	retval = move_bg_metadata(fs, new_fs);
> > +
> > +	/* Return the modified filesystem */
> > +	new_fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
> > +	ext2fs_mark_super_dirty(new_fs);
> > +	ext2fs_free(fs);
> > +	*fs_p = new_fs;
> > +	new_fs = NULL;
> > +out:
> > +	if (new_fs)
> > +		ext2fs_free(new_fs);
> > +	return retval;
> > +}
> > +
> > +/* Zero out the high bits of extent fields */
> > +static errcode_t zero_high_bits_in_extents(ext2_filsys fs, ext2_ino_t ino,
> > +					   struct ext2_inode *inode)
> > +{
> > +	ext2_extent_handle_t	handle;
> > +	struct ext2fs_extent	extent;
> > +	int			op = EXT2_EXTENT_ROOT;
> > +	errcode_t		errcode;
> > +
> > +	if (!(inode->i_flags & EXT4_EXTENTS_FL))
> > +		return 0;
> > +
> > +	errcode = ext2fs_extent_open(fs, ino, &handle);
> > +	if (errcode)
> > +		return errcode;
> > +
> > +	while (1) {
> > +		errcode = ext2fs_extent_get(handle, op, &extent);
> > +		if (errcode)
> > +			break;
> > +
> > +		op = EXT2_EXTENT_NEXT_SIB;
> > +
> > +		if (extent.e_pblk > (1ULL << 32)) {
> > +			extent.e_pblk &= (1ULL << 32) - 1;
> > +			errcode = ext2fs_extent_replace(handle, 0, &extent);
> > +			if (errcode)
> > +				break;
> > +		}
> > +	}
> > +
> > +	/* Ok if we run off the end */
> > +	if (errcode == EXT2_ET_EXTENT_NO_NEXT)
> > +		errcode = 0;
> > +	ext2fs_extent_free(handle);
> > +	return errcode;
> > +}
> > +
> > +/* Zero out the high bits of inodes. */
> > +static errcode_t zero_high_bits_in_inodes(ext2_filsys fs)
> > +{
> > +	int length = EXT2_INODE_SIZE(fs->super);
> > +	struct ext2_inode *inode = NULL;
> > +	ext2_inode_scan	scan = NULL;
> > +	errcode_t	retval;
> > +	ext2_ino_t	ino;
> > +
> > +	if (fs->super->s_creator_os != EXT2_OS_LINUX)
> > +		return 0;
> > +
> > +	retval = ext2fs_open_inode_scan(fs, 0, &scan);
> > +	if (retval)
> > +		return retval;
> > +
> > +	retval = ext2fs_get_mem(length, &inode);
> > +	if (retval)
> > +		goto out;
> > +
> > +	do {
> > +		retval = ext2fs_get_next_inode_full(scan, &ino, inode, length);
> > +		if (retval)
> > +			goto out;
> > +		if (!ino)
> > +			break;
> > +		if (!ext2fs_test_inode_bitmap2(fs->inode_map, ino))
> > +			continue;
> > +
> > +		/*
> > +		 * Here's how we deal with high block number fields:
> > +		 *
> > +		 *  - i_size_high has been been written out with i_size_lo
> > +		 *    since the ext2 days, so no conversion is needed.
> > +		 *
> > +		 *  - i_blocks_hi is guarded by both the huge_file feature and
> > +		 *    inode flags and has always been written out with
> > +		 *    i_blocks_lo if the feature is set.  The field is only
> > +		 *    ever read if both feature and inode flag are set, so
> > +		 *    we don't need to zero it now.
> > +		 *
> > +		 *  - i_file_acl_high can be uninitialized, so zero it if
> > +		 *    it isn't already.
> > +		 */
> > +		if (inode->osd2.linux2.l_i_file_acl_high) {
> > +			inode->osd2.linux2.l_i_file_acl_high = 0;
> > +			retval = ext2fs_write_inode_full(fs, ino, inode,
> > +							 length);
> > +			if (retval)
> > +				goto out;
> > +		}
> > +
> > +		retval = zero_high_bits_in_extents(fs, ino, inode);
> > +		if (retval)
> > +			goto out;
> > +	} while (ino);
> > +
> > +out:
> > +	if (inode)
> > +		ext2fs_free_mem(&inode);
> > +	if (scan)
> > +		ext2fs_close_inode_scan(scan);
> > +	return retval;
> > +}
> > +
> > +static errcode_t convert_64bit(ext2_filsys *fs_p, int direction)
> > +{
> > +	ext2_filsys fs = *fs_p;
> > +	errcode_t retval;
> >  
> >  	/*
> >  	 * Is resize2fs going to demand a fsck run? Might as well tell the
> > @@ -459,21 +776,25 @@ static void convert_64bit(ext2_filsys fs, int direction)
> >  	if (!fsck_requested &&
> >  	    ((fs->super->s_state & EXT2_ERROR_FS) ||
> >  	     !(fs->super->s_state & EXT2_VALID_FS) ||
> > -	     fs->super->s_lastcheck < fs->super->s_mtime))
> > +	     fs->super->s_lastcheck < fs->super->s_mtime)) {
> >  		request_fsck_afterwards(fs);
> > -	if (fsck_requested)
> > -		fprintf(stderr, _("After running e2fsck, please run `resize2fs %s %s"),
> > -			direction > 0 ? "-b" : "-s", fs->device_name);
> > -	else
> > -		fprintf(stderr, _("Please run `resize2fs %s %s"),
> > -			direction > 0 ? "-b" : "-s", fs->device_name);
> > +		return 0;
> > +	}
> >  
> > -	if (undo_file)
> > -		fprintf(stderr, _(" -z \"%s\""), undo_file);
> > -	if (direction > 0)
> > -		fprintf(stderr, _("' to enable 64-bit mode.\n"));
> > -	else
> > -		fprintf(stderr, _("' to disable 64-bit mode.\n"));
> > +	/*
> > +	 * Read bitmaps now since we are definitely going to need them and they
> > +	 * get properly duplicated when creating new fs handle in
> > +	 * resize_group_descriptors()
> > +	 */
> > +	retval = ext2fs_read_bitmaps(fs);
> > +	if (retval)
> > +		return retval;
> > +
> > +	retval = resize_group_descriptors(fs_p, direction);
> > +	if (retval)
> > +		return retval;
> > +
> > +	return zero_high_bits_in_inodes(*fs_p);
> >  }
> >  
> >  /* Rewrite extents */
> > @@ -1253,9 +1574,9 @@ mmp_error:
> >  	}
> >  
> >  	/*
> > -	 * We don't actually toggle 64bit; resize2fs does that.  But this
> > -	 * must come after the metadata_csum feature_on so that it won't
> > -	 * complain about the lack of 64bit.
> > +	 * Handle 64-bit conversion. We return the feature to the original
> > +	 * value for now until the conversion really takes place. Otherwise
> > +	 * some helper macros get confused.
> >  	 */
> >  	if (FEATURE_ON(E2P_FEATURE_INCOMPAT,
> >  		       EXT4_FEATURE_INCOMPAT_64BIT)) {
> > @@ -1264,8 +1585,8 @@ mmp_error:
> >  					  "while mounted!\n"));
> >  			exit(1);
> >  		}
> > -		sb->s_feature_incompat &= ~EXT4_FEATURE_INCOMPAT_64BIT;
> >  		feature_64bit = 1;
> > +		sb->s_feature_incompat &= ~EXT4_FEATURE_INCOMPAT_64BIT;
> >  	}
> >  	if (FEATURE_OFF(E2P_FEATURE_INCOMPAT,
> >  			EXT4_FEATURE_INCOMPAT_64BIT)) {
> > @@ -1274,8 +1595,8 @@ mmp_error:
> >  					  "while mounted!\n"));
> >  			exit(1);
> >  		}
> > -		sb->s_feature_incompat |= EXT4_FEATURE_INCOMPAT_64BIT;
> >  		feature_64bit = -1;
> > +		sb->s_feature_incompat |= EXT4_FEATURE_INCOMPAT_64BIT;
> >  	}
> >  
> >  	if (FEATURE_ON(E2P_FEATURE_RO_INCOMPAT,
> > @@ -3080,6 +3401,9 @@ retry_open:
> >  		}
> >  	}
> >  
> > +	if (feature_64bit)
> > +		convert_64bit(&fs, feature_64bit);
> > +
> >  	if (rewrite_checksums)
> >  		rewrite_metadata_checksums(fs);
> >  
> > @@ -3113,6 +3437,5 @@ closefs:
> >  		exit(1);
> >  	}
> >  
> > -	convert_64bit(fs, feature_64bit);
> >  	return (ext2fs_close_free(&fs) ? 1 : 0);
> >  }
> > -- 
> > 2.1.4
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
