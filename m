From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 16/25] resize2fs: convert fs to and from 64bit mode
Date: Wed, 27 Nov 2013 10:21:59 +0800
Message-ID: <20131127022159.GA1016@gmail.com>
References: <20131018044854.7339.48457.stgit@birch.djwong.org>
 <20131018045042.7339.21953.stgit@birch.djwong.org>
 <20131126064445.GA20867@gmail.com>
 <20131126183920.GA3068@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:64206 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156Ab3K0CTI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Nov 2013 21:19:08 -0500
Received: by mail-pd0-f170.google.com with SMTP id g10so8947315pdj.15
        for <linux-ext4@vger.kernel.org>; Tue, 26 Nov 2013 18:19:07 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20131126183920.GA3068@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 26, 2013 at 10:39:20AM -0800, Darrick J. Wong wrote:
> On Tue, Nov 26, 2013 at 02:44:45PM +0800, Zheng Liu wrote:
> > On Thu, Oct 17, 2013 at 09:50:42PM -0700, Darrick J. Wong wrote:
> > > resize2fs does its magic by loading a filesystem, duplicating the
> > > in-memory image of that fs, moving relevant blocks out of the way of
> > > whatever new metadata get created, and finally writing everything back
> > > out to disk.  Enabling 64bit mode enlarges the group descriptors,
> > > which makes resize2fs a reasonable vehicle for taking care of the rest
> > > of the bookkeeping requirements, so add to resize2fs the ability to
> > > convert a filesystem to 64bit mode and back.
> > 
> > Sorry, I don't get your point why we need to add these arguments to
> > enable/disable 64bit mode.  If I understand correctly, we don't disable
> > 64bit mode for a file system which is larger than 2^32 blocks.  So that
> > means that we just disable it for a file system which 64bit shouldn't be
> > enabled.  Is it worth doing this?
> 
> Are you questioning the entire conversion, or just the 64->32 direction?
> 
> 32->64 has two benefits: You can resize (somewhat) past 16T (256T I think?);
> and you get full 32-bit bitmap checksums.
> 
> I agree that 64->32 isn't terribly useful, but dislike one-way conversions.

Thanks for your explanation.  Now it makes sense to me.  Enabling 64bit
mode makes us break the limitation of 16T.  Absolutely it is useful for
us.

Thanks,
                                                - Zheng

> 
> > Otherwise one nit below.
> > 
> >                                                 - Zheng
> > 
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  resize/main.c         |   40 ++++++-
> > >  resize/resize2fs.8.in |   18 +++
> > >  resize/resize2fs.c    |  282 ++++++++++++++++++++++++++++++++++++++++++++++++-
> > >  resize/resize2fs.h    |    3 +
> > >  4 files changed, 336 insertions(+), 7 deletions(-)
> > > 
> > > 
> > > diff --git a/resize/main.c b/resize/main.c
> > > index 1394ae1..ad0c946 100644
> > > --- a/resize/main.c
> > > +++ b/resize/main.c
> > > @@ -41,7 +41,7 @@ char *program_name, *device_name, *io_options;
> > >  static void usage (char *prog)
> > >  {
> > >  	fprintf (stderr, _("Usage: %s [-d debug_flags] [-f] [-F] [-M] [-P] "
> > > -			   "[-p] device [new_size]\n\n"), prog);
> > > +			   "[-p] device [-b|-s|new_size]\n\n"), prog);
> > >  
> > >  	exit (1);
> > >  }
> > > @@ -199,7 +199,7 @@ int main (int argc, char ** argv)
> > >  	if (argc && *argv)
> > >  		program_name = *argv;
> > >  
> > > -	while ((c = getopt (argc, argv, "d:fFhMPpS:")) != EOF) {
> > > +	while ((c = getopt(argc, argv, "d:fFhMPpS:bs")) != EOF) {
> > >  		switch (c) {
> > >  		case 'h':
> > >  			usage(program_name);
> > > @@ -225,6 +225,12 @@ int main (int argc, char ** argv)
> > >  		case 'S':
> > >  			use_stride = atoi(optarg);
> > >  			break;
> > > +		case 'b':
> > > +			flags |= RESIZE_ENABLE_64BIT;
> > > +			break;
> > > +		case 's':
> > > +			flags |= RESIZE_DISABLE_64BIT;
> > > +			break;
> > >  		default:
> > >  			usage(program_name);
> > >  		}
> > > @@ -383,6 +389,10 @@ int main (int argc, char ** argv)
> > >  		if (sys_page_size > fs->blocksize)
> > >  			new_size &= ~((sys_page_size / fs->blocksize)-1);
> > >  	}
> > > +	/* If changing 64bit, don't change the filesystem size. */
> > > +	if (flags & (RESIZE_DISABLE_64BIT | RESIZE_ENABLE_64BIT)) {
> > > +		new_size = ext2fs_blocks_count(fs->super);
> > > +	}
> > >  	if (!EXT2_HAS_INCOMPAT_FEATURE(fs->super,
> > >  				       EXT4_FEATURE_INCOMPAT_64BIT)) {
> > >  		/* Take 16T down to 2^32-1 blocks */
> > > @@ -434,7 +444,31 @@ int main (int argc, char ** argv)
> > >  			fs->blocksize / 1024, new_size);
> > >  		exit(1);
> > >  	}
> > > -	if (new_size == ext2fs_blocks_count(fs->super)) {
> > > +	if (flags & RESIZE_DISABLE_64BIT && flags & RESIZE_ENABLE_64BIT) {
> >             ^^^^^
> > Coding style problem:
> >         if ((flags & RESIZE_ENABLE_64BIT) && (flags & RESIZE_ENABLE_64BIT))
> 
> Yes, thank you for catching this.
> 
> --D
> 
> > 
> > > +		fprintf(stderr, _("Cannot set and unset 64bit feature.\n"));
> > > +		exit(1);
> > > +	} else if (flags & (RESIZE_DISABLE_64BIT | RESIZE_ENABLE_64BIT)) {
> > > +		new_size = ext2fs_blocks_count(fs->super);
> > > +		if (new_size >= (1ULL << 32)) {
> > > +			fprintf(stderr, _("Cannot change the 64bit feature "
> > > +				"on a filesystem that is larger than "
> > > +				"2^32 blocks.\n"));
> > > +			exit(1);
> > > +		}
> > > +		if (mount_flags & EXT2_MF_MOUNTED) {
> > > +			fprintf(stderr, _("Cannot change the 64bit feature "
> > > +				"while the filesystem is mounted.\n"));
> > > +			exit(1);
> > > +		}
> > > +		if (flags & RESIZE_ENABLE_64BIT &&
> >                     ^^^^
> >                     ditto
> > 
> > > +		    !EXT2_HAS_INCOMPAT_FEATURE(fs->super,
> > > +				EXT3_FEATURE_INCOMPAT_EXTENTS)) {
> > > +			fprintf(stderr, _("Please enable the extents feature "
> > > +				"with tune2fs before enabling the 64bit "
> > > +				"feature.\n"));
> > > +			exit(1);
> > > +		}
> > > +	} else if (new_size == ext2fs_blocks_count(fs->super)) {
> > >  		fprintf(stderr, _("The filesystem is already %llu blocks "
> > >  			"long.  Nothing to do!\n\n"), new_size);
> > >  		exit(0);
> > > diff --git a/resize/resize2fs.8.in b/resize/resize2fs.8.in
> > > index a1f3099..1c75816 100644
> > > --- a/resize/resize2fs.8.in
> > > +++ b/resize/resize2fs.8.in
> > > @@ -8,7 +8,7 @@ resize2fs \- ext2/ext3/ext4 file system resizer
> > >  .SH SYNOPSIS
> > >  .B resize2fs
> > >  [
> > > -.B \-fFpPM
> > > +.B \-fFpPMbs
> > >  ]
> > >  [
> > >  .B \-d
> > > @@ -85,8 +85,21 @@ to shrink the size of filesystem.  Then you may use
> > >  to shrink the size of the partition.  When shrinking the size of
> > >  the partition, make sure you do not make it smaller than the new size
> > >  of the ext2 filesystem!
> > > +.PP
> > > +The
> > > +.B \-b
> > > +and
> > > +.B \-s
> > > +options enable and disable the 64bit feature, respectively.  The resize2fs
> > > +program will, of course, take care of resizing the block group descriptors
> > > +and moving other data blocks out of the way, as needed.  It is not possible
> > > +to resize the filesystem concurrent with changing the 64bit status.
> > >  .SH OPTIONS
> > >  .TP
> > > +.B \-b
> > > +Turns on the 64bit feature, resizes the group descriptors as necessary, and
> > > +moves other metadata out of the way.
> > > +.TP
> > >  .B \-d \fIdebug-flags
> > >  Turns on various resize2fs debugging features, if they have been compiled
> > >  into the binary.
> > > @@ -126,6 +139,9 @@ of what the program is doing.
> > >  .B \-P
> > >  Print the minimum size of the filesystem and exit.
> > >  .TP
> > > +.B \-s
> > > +Turns off the 64bit feature and frees blocks that are no longer in use.
> > > +.TP
> > >  .B \-S \fIRAID-stride
> > >  The
> > >  .B resize2fs
> > > diff --git a/resize/resize2fs.c b/resize/resize2fs.c
> > > index 0feff0f..05ba6e1 100644
> > > --- a/resize/resize2fs.c
> > > +++ b/resize/resize2fs.c
> > > @@ -53,6 +53,9 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs);
> > >  static errcode_t fix_sb_journal_backup(ext2_filsys fs);
> > >  static errcode_t mark_table_blocks(ext2_filsys fs,
> > >  				   ext2fs_block_bitmap bmap);
> > > +static errcode_t resize_group_descriptors(ext2_resize_t rfs, blk64_t new_size);
> > > +static errcode_t move_bg_metadata(ext2_resize_t rfs);
> > > +static errcode_t zero_high_bits_in_inodes(ext2_resize_t rfs);
> > >  
> > >  /*
> > >   * Some helper CPP macros
> > > @@ -119,13 +122,30 @@ errcode_t resize_fs(ext2_filsys fs, blk64_t *new_size, int flags,
> > >  	if (retval)
> > >  		goto errout;
> > >  
> > > +	init_resource_track(&rtrack, "resize_group_descriptors", fs->io);
> > > +	retval = resize_group_descriptors(rfs, *new_size);
> > > +	if (retval)
> > > +		goto errout;
> > > +	print_resource_track(rfs, &rtrack, fs->io);
> > > +
> > > +	init_resource_track(&rtrack, "move_bg_metadata", fs->io);
> > > +	retval = move_bg_metadata(rfs);
> > > +	if (retval)
> > > +		goto errout;
> > > +	print_resource_track(rfs, &rtrack, fs->io);
> > > +
> > > +	init_resource_track(&rtrack, "zero_high_bits_in_metadata", fs->io);
> > > +	retval = zero_high_bits_in_inodes(rfs);
> > > +	if (retval)
> > > +		goto errout;
> > > +	print_resource_track(rfs, &rtrack, fs->io);
> > > +
> > >  	init_resource_track(&rtrack, "adjust_superblock", fs->io);
> > >  	retval = adjust_superblock(rfs, *new_size);
> > >  	if (retval)
> > >  		goto errout;
> > >  	print_resource_track(rfs, &rtrack, fs->io);
> > >  
> > > -
> > >  	init_resource_track(&rtrack, "fix_uninit_block_bitmaps 2", fs->io);
> > >  	fix_uninit_block_bitmaps(rfs->new_fs);
> > >  	print_resource_track(rfs, &rtrack, fs->io);
> > > @@ -221,6 +241,259 @@ errout:
> > >  	return retval;
> > >  }
> > >  
> > > +/* Toggle 64bit mode */
> > > +static errcode_t resize_group_descriptors(ext2_resize_t rfs, blk64_t new_size)
> > > +{
> > > +	void *o, *n, *new_group_desc;
> > > +	dgrp_t i;
> > > +	int copy_size;
> > > +	errcode_t retval;
> > > +
> > > +	if (!(rfs->flags & (RESIZE_DISABLE_64BIT | RESIZE_ENABLE_64BIT)))
> > > +		return 0;
> > > +
> > > +	if (new_size != ext2fs_blocks_count(rfs->new_fs->super) ||
> > > +	    ext2fs_blocks_count(rfs->new_fs->super) >= (1ULL << 32) ||
> > > +	    (rfs->flags & RESIZE_DISABLE_64BIT &&
> > > +	     rfs->flags & RESIZE_ENABLE_64BIT))
> > > +		return EXT2_ET_INVALID_ARGUMENT;
> > > +
> > > +	if (rfs->flags & RESIZE_DISABLE_64BIT) {
> > > +		rfs->new_fs->super->s_feature_incompat &=
> > > +				~EXT4_FEATURE_INCOMPAT_64BIT;
> > > +		rfs->new_fs->super->s_desc_size = EXT2_MIN_DESC_SIZE;
> > > +	} else if (rfs->flags & RESIZE_ENABLE_64BIT) {
> > > +		rfs->new_fs->super->s_feature_incompat |=
> > > +				EXT4_FEATURE_INCOMPAT_64BIT;
> > > +		rfs->new_fs->super->s_desc_size = EXT2_MIN_DESC_SIZE_64BIT;
> > > +	}
> > > +
> > > +	if (EXT2_DESC_SIZE(rfs->old_fs->super) ==
> > > +	    EXT2_DESC_SIZE(rfs->new_fs->super))
> > > +		return 0;
> > > +
> > > +	o = rfs->new_fs->group_desc;
> > > +	rfs->new_fs->desc_blocks = ext2fs_div_ceil(
> > > +			rfs->old_fs->group_desc_count,
> > > +			EXT2_DESC_PER_BLOCK(rfs->new_fs->super));
> > > +	retval = ext2fs_get_arrayzero(rfs->new_fs->desc_blocks,
> > > +				      rfs->old_fs->blocksize, &new_group_desc);
> > > +	if (retval)
> > > +		return retval;
> > > +
> > > +	n = new_group_desc;
> > > +
> > > +	if (EXT2_DESC_SIZE(rfs->old_fs->super) <=
> > > +	    EXT2_DESC_SIZE(rfs->new_fs->super))
> > > +		copy_size = EXT2_DESC_SIZE(rfs->old_fs->super);
> > > +	else
> > > +		copy_size = EXT2_DESC_SIZE(rfs->new_fs->super);
> > > +	for (i = 0; i < rfs->old_fs->group_desc_count; i++) {
> > > +		memcpy(n, o, copy_size);
> > > +		n += EXT2_DESC_SIZE(rfs->new_fs->super);
> > > +		o += EXT2_DESC_SIZE(rfs->old_fs->super);
> > > +	}
> > > +
> > > +	ext2fs_free_mem(&rfs->new_fs->group_desc);
> > > +	rfs->new_fs->group_desc = new_group_desc;
> > > +
> > > +	for (i = 0; i < rfs->old_fs->group_desc_count; i++)
> > > +		ext2fs_group_desc_csum_set(rfs->new_fs, i);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +/* Move bitmaps/inode tables out of the way. */
> > > +static errcode_t move_bg_metadata(ext2_resize_t rfs)
> > > +{
> > > +	dgrp_t i;
> > > +	blk64_t b, c, d;
> > > +	ext2fs_block_bitmap old_map, new_map;
> > > +	int old, new;
> > > +	errcode_t retval;
> > > +	int zero = 0, one = 1;
> > > +
> > > +	if (!(rfs->flags & (RESIZE_DISABLE_64BIT | RESIZE_ENABLE_64BIT)))
> > > +		return 0;
> > > +
> > > +	retval = ext2fs_allocate_block_bitmap(rfs->old_fs, "oldfs", &old_map);
> > > +	if (retval)
> > > +		return retval;
> > > +
> > > +	retval = ext2fs_allocate_block_bitmap(rfs->new_fs, "newfs", &new_map);
> > > +	if (retval)
> > > +		goto out;
> > > +
> > > +	/* Construct bitmaps of super/descriptor blocks in old and new fs */
> > > +	for (i = 0; i < rfs->old_fs->group_desc_count; i++) {
> > > +		retval = ext2fs_super_and_bgd_loc2(rfs->old_fs, i, &b, &c, &d,
> > > +						   NULL);
> > > +		if (retval)
> > > +			goto out;
> > > +		ext2fs_mark_block_bitmap2(old_map, b);
> > > +		ext2fs_mark_block_bitmap2(old_map, c);
> > > +		ext2fs_mark_block_bitmap2(old_map, d);
> > > +
> > > +		retval = ext2fs_super_and_bgd_loc2(rfs->new_fs, i, &b, &c, &d,
> > > +						   NULL);
> > > +		if (retval)
> > > +			goto out;
> > > +		ext2fs_mark_block_bitmap2(new_map, b);
> > > +		ext2fs_mark_block_bitmap2(new_map, c);
> > > +		ext2fs_mark_block_bitmap2(new_map, d);
> > > +	}
> > > +
> > > +	/* Find changes in block allocations for bg metadata */
> > > +	for (b = 0;
> > > +	     b < ext2fs_blocks_count(rfs->new_fs->super);
> > > +	     b += EXT2FS_CLUSTER_RATIO(rfs->new_fs)) {
> > > +		old = ext2fs_test_block_bitmap2(old_map, b);
> > > +		new = ext2fs_test_block_bitmap2(new_map, b);
> > > +
> > > +		if (old && !new)
> > > +			ext2fs_unmark_block_bitmap2(rfs->new_fs->block_map, b);
> > > +		else if (!old && new)
> > > +			; /* empty ext2fs_mark_block_bitmap2(new_map, b); */
> > > +		else
> > > +			ext2fs_unmark_block_bitmap2(new_map, b);
> > > +	}
> > > +	/* new_map now shows blocks that have been newly allocated. */
> > > +
> > > +	/* Move any conflicting bitmaps and inode tables */
> > > +	for (i = 0; i < rfs->old_fs->group_desc_count; i++) {
> > > +		b = ext2fs_block_bitmap_loc(rfs->new_fs, i);
> > > +		if (ext2fs_test_block_bitmap2(new_map, b))
> > > +			ext2fs_block_bitmap_loc_set(rfs->new_fs, i, 0);
> > > +
> > > +		b = ext2fs_inode_bitmap_loc(rfs->new_fs, i);
> > > +		if (ext2fs_test_block_bitmap2(new_map, b))
> > > +			ext2fs_inode_bitmap_loc_set(rfs->new_fs, i, 0);
> > > +
> > > +		c = ext2fs_inode_table_loc(rfs->new_fs, i);
> > > +		for (b = 0; b < rfs->new_fs->inode_blocks_per_group; b++) {
> > > +			if (ext2fs_test_block_bitmap2(new_map, b + c)) {
> > > +				ext2fs_inode_table_loc_set(rfs->new_fs, i, 0);
> > > +				break;
> > > +			}
> > > +		}
> > > +	}
> > > +
> > > +out:
> > > +	if (old_map)
> > > +		ext2fs_free_block_bitmap(old_map);
> > > +	if (new_map)
> > > +		ext2fs_free_block_bitmap(new_map);
> > > +	return retval;
> > > +}
> > > +
> > > +/* Zero out the high bits of extent fields */
> > > +static errcode_t zero_high_bits_in_extents(ext2_filsys fs, ext2_ino_t ino,
> > > +				 struct ext2_inode *inode)
> > > +{
> > > +	ext2_extent_handle_t	handle;
> > > +	struct ext2fs_extent	extent;
> > > +	int			op = EXT2_EXTENT_ROOT;
> > > +	errcode_t		errcode;
> > > +
> > > +	if (!(inode->i_flags & EXT4_EXTENTS_FL))
> > > +		return 0;
> > > +
> > > +	errcode = ext2fs_extent_open(fs, ino, &handle);
> > > +	if (errcode)
> > > +		return errcode;
> > > +
> > > +	while (1) {
> > > +		errcode = ext2fs_extent_get(handle, op, &extent);
> > > +		if (errcode)
> > > +			break;
> > > +
> > > +		op = EXT2_EXTENT_NEXT_SIB;
> > > +
> > > +		if (extent.e_pblk > (1ULL << 32)) {
> > > +			extent.e_pblk &= (1ULL << 32) - 1;
> > > +			errcode = ext2fs_extent_replace(handle, 0, &extent);
> > > +			if (errcode)
> > > +				break;
> > > +		}
> > > +	}
> > > +
> > > +	/* Ok if we run off the end */
> > > +	if (errcode == EXT2_ET_EXTENT_NO_NEXT)
> > > +		errcode = 0;
> > > +	return errcode;
> > > +}
> > > +
> > > +/* Zero out the high bits of inodes. */
> > > +static errcode_t zero_high_bits_in_inodes(ext2_resize_t rfs)
> > > +{
> > > +	ext2_filsys	fs = rfs->new_fs;
> > > +	int length = EXT2_INODE_SIZE(fs->super);
> > > +	struct ext2_inode *inode = NULL;
> > > +	ext2_inode_scan	scan = NULL;
> > > +	errcode_t	retval;
> > > +	ext2_ino_t	ino;
> > > +	blk64_t		file_acl_block;
> > > +	int		inode_dirty;
> > > +
> > > +	if (!(rfs->flags & (RESIZE_DISABLE_64BIT | RESIZE_ENABLE_64BIT)))
> > > +		return 0;
> > > +
> > > +	if (fs->super->s_creator_os != EXT2_OS_LINUX)
> > > +		return 0;
> > > +
> > > +	retval = ext2fs_open_inode_scan(fs, 0, &scan);
> > > +	if (retval)
> > > +		return retval;
> > > +
> > > +	retval = ext2fs_get_mem(length, &inode);
> > > +	if (retval)
> > > +		goto out;
> > > +
> > > +	do {
> > > +		retval = ext2fs_get_next_inode_full(scan, &ino, inode, length);
> > > +		if (retval)
> > > +			goto out;
> > > +		if (!ino)
> > > +			break;
> > > +		if (!ext2fs_test_inode_bitmap2(fs->inode_map, ino))
> > > +			continue;
> > > +
> > > +		/*
> > > +		 * Here's how we deal with high block number fields:
> > > +		 *
> > > +		 *  - i_size_high has been been written out with i_size_lo
> > > +		 *    since the ext2 days, so no conversion is needed.
> > > +		 *
> > > +		 *  - i_blocks_hi is guarded by both the huge_file feature and
> > > +		 *    inode flags and has always been written out with
> > > +		 *    i_blocks_lo if the feature is set.  The field is only
> > > +		 *    ever read if both feature and inode flag are set, so
> > > +		 *    we don't need to zero it now.
> > > +		 *
> > > +		 *  - i_file_acl_high can be uninitialized, so zero it if
> > > +		 *    it isn't already.
> > > +		 */
> > > +		if (inode->osd2.linux2.l_i_file_acl_high) {
> > > +			inode->osd2.linux2.l_i_file_acl_high = 0;
> > > +			retval = ext2fs_write_inode_full(fs, ino, inode,
> > > +							 length);
> > > +			if (retval)
> > > +				goto out;
> > > +		}
> > > +
> > > +		retval = zero_high_bits_in_extents(fs, ino, inode);
> > > +		if (retval)
> > > +			goto out;
> > > +	} while (ino);
> > > +
> > > +out:
> > > +	if (inode)
> > > +		ext2fs_free_mem(&inode);
> > > +	if (scan)
> > > +		ext2fs_close_inode_scan(scan);
> > > +	return retval;
> > > +}
> > > +
> > >  /*
> > >   * Clean up the bitmaps for unitialized bitmaps
> > >   */
> > > @@ -424,7 +697,8 @@ retry:
> > >  	/*
> > >  	 * Reallocate the group descriptors as necessary.
> > >  	 */
> > > -	if (old_fs->desc_blocks != fs->desc_blocks) {
> > > +	if (EXT2_DESC_SIZE(old_fs->super) == EXT2_DESC_SIZE(fs->super) &&
> > > +	    old_fs->desc_blocks != fs->desc_blocks) {
> > >  		retval = ext2fs_resize_mem(old_fs->desc_blocks *
> > >  					   fs->blocksize,
> > >  					   fs->desc_blocks * fs->blocksize,
> > > @@ -949,7 +1223,9 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
> > >  		new_blocks = fs->desc_blocks + fs->super->s_reserved_gdt_blocks;
> > >  	}
> > >  
> > > -	if (old_blocks == new_blocks) {
> > > +	if (EXT2_DESC_SIZE(rfs->old_fs->super) ==
> > > +	    EXT2_DESC_SIZE(rfs->new_fs->super) &&
> > > +	    old_blocks == new_blocks) {
> > >  		retval = 0;
> > >  		goto errout;
> > >  	}
> > > diff --git a/resize/resize2fs.h b/resize/resize2fs.h
> > > index 52319b5..5a1c5dc 100644
> > > --- a/resize/resize2fs.h
> > > +++ b/resize/resize2fs.h
> > > @@ -82,6 +82,9 @@ typedef struct ext2_sim_progress *ext2_sim_progmeter;
> > >  #define RESIZE_PERCENT_COMPLETE		0x0100
> > >  #define RESIZE_VERBOSE			0x0200
> > >  
> > > +#define RESIZE_ENABLE_64BIT		0x0400
> > > +#define RESIZE_DISABLE_64BIT		0x0800
> > > +
> > >  /*
> > >   * This structure is used for keeping track of how much resources have
> > >   * been used for a particular resize2fs pass.
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
