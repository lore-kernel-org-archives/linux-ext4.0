From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [PATCH] e2fsprogs: New bitmap and inode table allocation for
 FLEX_BG
Date: Fri, 8 Feb 2008 11:37:40 -0600
Message-ID: <20080208113740.11760ee2@gara>
References: <20080207110905.7886d170@gara>
	<20080208051116.GB3120@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:39608 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758688AbYBHRhr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Feb 2008 12:37:47 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m18Hbk7F003030
	for <linux-ext4@vger.kernel.org>; Fri, 8 Feb 2008 12:37:46 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m18HbhxX189874
	for <linux-ext4@vger.kernel.org>; Fri, 8 Feb 2008 10:37:44 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m18HbgGW011479
	for <linux-ext4@vger.kernel.org>; Fri, 8 Feb 2008 10:37:43 -0700
In-Reply-To: <20080208051116.GB3120@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 08 Feb 2008 00:11:16 -0500
Andreas Dilger <adilger@sun.com> wrote:

> On Feb 07, 2008  11:09 -0600, Jose R. Santos wrote:
> > +blk_t ext2fs_flexbg_offset(ext2_filsys fs, dgrp_t group, blk_t start_blk,
> > +			   ext2fs_block_bitmap bmap, int offset, int size)
> > +{
> 
> Can you add a comment on the intent of this function.  By the name it seems
> to be calculating some offset relative to the flex group, but that doesn't
> convey anything about searching for free blocks???

I will add a comment.  The function calculates where the search of
bitmaps/inode tables for a give block group starts by returning a block
number where all of the bitmaps/inode tables can be allocated in a
contiguous fashion.  The search for free blocks is needed determine
where within the flex group we can allocated the meta-data.

> 
> > +	/*
> > +	 * Dont do a long search if the previous block
> > +	 * search is still valid.
> > +	 */
> 
> What condition here makse the previous search still valid?

We pass the previous allocation as an argument to the function.  If the
is enough space to allocate the rest of the inode tables after the
previous allocation, then no need to do a search.  There are two
reasons why this is done.

1) If the size of the of a flexbg is big enough, searching for
inode_blocks_per_group * flexbg becomes very expensive if there happens
to be some blocks in the middle of where we started the search.  This
easy happens if the size of all the inode tables in a flex group are
larger than a single block group.  If the next block group has super
block backups or meta_bg blocks ext2fs_get_free_blocks() becomes very
expensive.  If we have to do such an expensive search, better do it
once.  This is also a problem when resizing since there is no telling
what block usage of those last groups would be.

2) This avoids having inode_tables or bitmaps being allocated out of
order.  The search for very large blocks can leave empty space at the
begining of a flex group.  The search for the last groups in the flex
group could actually be place in these smaller empty blocks which would
put things out of order.

> > +	if (start_blk && group % flexbg_size) {
> > +		if (size > flexbg_size)
> > +			elem_size = fs->inode_blocks_per_group;
> > +		else
> > +			elem_size = 1;
> > +		if (ext2fs_test_block_bitmap_range(bmap, start_blk + elem_size,
> > +						   size))
> > +			return start_blk + elem_size;
> > +	}
> > +
> > +	start_blk = ext2fs_group_first_block(fs, flexbg_size * flexbg);
> > +	last_grp = (group + (flexbg_size - (group % flexbg_size) - 1));
> 
> This is a confusing calculation...  Is it trying to find the last group
> in the flex group that "group" is part of?  I.e. round "group" to the
> end of the flex group?  Since flexbg_size is a power-of-two value, you
> could just do "last_grp = group | (flexbg_size - 1)"?

Yes, I will fix that.
 
> > +	last_blk = ext2fs_group_last_block(fs, last_grp);
> > +	if (last_grp > fs->group_desc_count)
> > +		last_grp = fs->group_desc_count;
> 
> Doesn't it make more sense to calculate "last_blk" AFTER limiting
> "last_grp" to the actual number of groups in the filesystem?

Ops...  Thanks for catching.
 
> > +	/* Find the first available block */
> > +	if (ext2fs_get_free_blocks(fs, start_blk, last_blk, 1, bmap,
> > +				   &first_free))
> > +		return first_free;
> > +
> > +	if (ext2fs_get_free_blocks(fs, first_free + offset, last_blk, size,
> > +				   bmap, &first_free))
> > +		return first_free;
> 
> I don't quite understand this either?  The first search is looking for a
> single free block between "start_blk" and "last_blk", while the second
> search is looking for "size" free blocks between "first_free + offset"
> and "last_blk".  What is the reason to do the second search after doing
> the first one, or alternately just doing the second one directly?

Because the second search starts from the first free block + an
offset.  This is used in order to have space to allocate each group of
inode/block bitmaps and inode tables contiguously.  Cant do the second
search directly without knowing where I should start the search.

> Should both of these calls actually be saving the error return value and
> returning that to a caller (returning first_free via a pointer arg like
> ext2fs_get_free_blocks() does)?

Failure to find a contiguous set of blocks for all the groups meta-data
is not fatal since we don't allocate here.  This function just helps
ext2fs_allocate_group_table() find where is should start its search. I
leet ext2fs_allocate_group_table() do the error handling if it truly
can find enough space for the allocation. 

> >  errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
> >  				      ext2fs_block_bitmap bmap)
> >  {
> >  	if (!bmap)
> >  		bmap = fs->block_map;
> > +
> > +	if (EXT2_HAS_INCOMPAT_FEATURE (fs->super,
> > +				       EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
> 
> No space between ..._FEATURE and "(".

Will fix.
 
> > +		flexbg_size = 1 << fs->super->s_log_groups_per_flex;
> > +		rem_grps = flexbg_size - (group % flexbg_size);
> > +		last_grp = group + rem_grps - 1;
> 
> Could this be written as:
> 
> 		last_grp = group | (flexbg_size - 1);
> 		rem_grps = last_grp - group;

Will fix.

> I'm also trying to see if you have an off-by-one error in your version?
> Consider the case of group = 5, flexbg_size = 4.  That gives us with my calc:
> 
> 		last_grp = 5 | (4 - 1) = 7;
> 		rem_grps = 7 - 5 = 2;
> 
> This makes sense, since group 5 is in the second flexbg [4,7], and there
> are 2 groups remaining after group 5 in that flexbg.

I think you're right.  Thanks for catching.
 
> > @@ -56,6 +120,15 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs,
> >  	} else
> >  		start_blk = group_blk;
> >  
> > +	if (flexbg_size) {
> > +		int prev_block = 0;
> > +		if (group && fs->group_desc[group-1].bg_block_bitmap)
> > +			prev_block = fs->group_desc[group-1].bg_block_bitmap;
> > +		start_blk = ext2fs_flexbg_offset(fs, group, prev_block, bmap,
> > +						 0, rem_grps);
> > +		last_blk = ext2fs_group_last_block(fs, last_grp);
> > +	}
> 
> This is presumably trying to allocate the block bitmap for "group" to be
> after the block bitmap for "group - 1" (allocated in an earlier call).
> 
> > +		if (group && fs->group_desc[group-1].bg_inode_bitmap)
> > +			prev_block = fs->group_desc[group-1].bg_inode_bitmap;
> > +		start_blk = ext2fs_flexbg_offset(fs, group, prev_block, bmap,
> > +						 flexbg_size, rem_grps);
> > +		last_blk = ext2fs_group_last_block(fs, last_grp);
> >  	}
> 
> This is allocating the inode bitmap in the same manner.  Would it make more
> sense to change the mke2fs code to allocate all of the block bitmaps first
> (well, after the sb+gdt backups), then all of the inode bitmaps, and finally
> all of the inode tables?

This is how I originally created the patch but since it was handle
outside ext2_allocate_table, it would mean that it could not be used
for resize2fs.  I can be done from inside ext2_allocate_table() but it
seems wrong to allocate all of the groups in a flexbg when we expect
that this function only does it for one single group.

> >  #define EXT2_BG_INODE_UNINIT	0x0001 /* Inode table/bitmap not initialized */
> >  #define EXT2_BG_BLOCK_UNINIT	0x0002 /* Block bitmap not initialized */
> > +#define EXT2_BG_FLEX_METADATA	0x0004 /* FLEX_BG block group contains meta-data */
> 
> Hrm, I thought I had reserved that value in the uninit_groups patch?
> +#define EXT3_BG_INODE_ZEROED   0x0004  /* On-disk itable initialized to zero */

I may have been, I just based the patch on the next branch as Ted had
ask for new e2fsprog patches.  The uninit group patch was not part of
the next branch when I pulled.

> The kernel and e2fsck can use that to determine if the inode table was
> zeroed out at mke2fs time (i.e. formatted with LAZY_BG or not).  Then
> the kernel can zero out the entire inode table and set INODE_ZEROED lazily
> some time after mount, instead of mke2fs doing it at mke2fs time sucking
> up all of the node's RAM and making it very slow.
> 
> This is still needed at some point to avoid the problem of e2fsck trying
> to salvage ancient inodes if the group descriptor is corrupted for some
> reason and the inode high watermark is lost.
> 
> Not implemented yet... but intended to be done by a helper thread started
> at mount time to do GDT/bitmap/itable checksum validation, create the
> mballoc buddy buffers, prefetch metadata, etc.
> 
> > @@ -96,7 +96,7 @@ static void usage(void)
> >  {
> >  	fprintf(stderr, _("Usage: %s [-c|-t|-l filename] [-b block-size] "
> >  	"[-f fragment-size]\n\t[-i bytes-per-inode] [-I inode-size] "
> > -	"[-j] [-J journal-options]\n"
> > +	"[-j] [-J journal-options] [-G meta group size]\n"
> >  	"\t[-N number-of-inodes] [-m reserved-blocks-percentage] "
> >  	"[-o creator-os]\n\t[-g blocks-per-group] [-L volume-label] "
> >  	"[-M last-mounted-directory]\n\t[-O feature[,...]] "
> 
> This also needs an update to the mke2fs.8.in man page.

Yes it does.
 
> > +	if(flex_bg_size) {
> > +		fs_param.s_log_groups_per_flex = int_log2(flex_bg_size);
> > +	}
> 
> Whitespace, braces:

Will fix.

> 
> 	if (flex_bg_size)
> 		fs_param.s_log_groups_per_flex = int_log2(flex_bg_size);
> 
> 
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
> 

Thanks for the feedback.

-JRS
