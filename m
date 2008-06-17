From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] resize2fs: Fix support for the uninit_bg feature
Date: Tue, 17 Jun 2008 12:30:38 -0400
Message-ID: <20080617163038.GE12448@mit.edu>
References: <1213682792-4878-1-git-send-email-tytso@mit.edu> <1213682792-4878-2-git-send-email-tytso@mit.edu> <20080617151647.GD3726@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:48271 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752128AbYFQQap (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Jun 2008 12:30:45 -0400
Content-Disposition: inline
In-Reply-To: <20080617151647.GD3726@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 17, 2008 at 09:16:47AM -0600, Andreas Dilger wrote:
> On Jun 17, 2008  02:06 -0400, Theodore Ts'o wrote:
> > @@ -1579,13 +1589,35 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs)
> >  	/*
> >  	 * First calculate the block statistics
> >  	 */
> > +	uninit = fs->group_desc[group].bg_flags & EXT2_BG_BLOCK_UNINIT;
> > +	ext2fs_super_and_bgd_loc(fs, group, &super_blk, &old_desc_blk,
> > +				 &new_desc_blk, 0);
> > +	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
> > +		old_desc_blocks = fs->super->s_first_meta_bg;
> > +	else
> > +		old_desc_blocks = fs->desc_blocks +
> > +			fs->super->s_reserved_gdt_blocks;
> 
> I'm a bit confused by this.  It doesn't seem that you use old_desc_blocks
> in the META_BG case?  I'm trying to figure out what "old_desc_blocks"
> means in the META_BG case.

In the META_BG case, s_first_meta_bg is the number of the "meta
blockgroup" where the META_BG layout starts getting used.  The idea
here is that you can have a traditional filesystem layout, and then
instead of using ext2_prepare, you simply grow the block groups until
the traditional block group descriptor space is filled out, and then
after that, you switch over to the meta_bg layout.  

To convert conversion between the block group number and a
meta_block_group number, the formula is:

       block_grp_num = meta_bg_num * (block_size / descriptor_size)

Because of this, very conveniently fs->super->s_first_meta also is the
size of the block group descriptors for block groups below the meta_bg
boundary.  

Hence, old_desc_blocks is the number of blocks used by block group
descriptors for block groups that have the traditional block group
descriptor layout.

> Also, the number of places where we have to figure out whick blocks
> are in use for a particular group is growing quite large, and with the
> interactions between various features (META_BG, SPARSE_SUPER, FLEX_BG,
> RESIZE_INODE, etc) getting this right in all of these places is hard.
> Places that need this, off the top of my head, include mk2fs, e2fsck,
> resize2fs, kernel (online resize, uninit_bg), debugfs.

> It would be very handy to have a single function that can figure out
> the block layout for any group based on all of the features, and then
> return the block numbers of the bitmaps, itable, sb, gdt (if present).
> This would be like a more complex version of ext2fs_super_and_bgd_loc(),
> but it also returns the number of gdt blocks (normal and reserved),
> bitmaps, inode table, and itable blocks.

Yeah, ext2fs_super_and_bgd_loc() is about 95% of this logic.  The one
additional bit that isn't included there is the meta_bg magic, i.e.:

	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
		old_desc_blocks = fs->super->s_first_meta_bg;
	else
		old_desc_blocks = fs->desc_blocks +
			fs->super->s_reserved_gdt_blocks;

So this would be an example of something I would push into the 64-bit
version of ext2fs_super_and_bgd_loc() in the future.

Everything else depends on exactly how you want to use the
information.  The primary pattern is "is this block part of the block
group metadata?", which is this conditional:

	     ((blk == super_blk) ||
	       ((old_desc_blk && old_desc_blocks &&
		 (blk >= old_desc_blk) &&
		 (blk < old_desc_blk + old_desc_blocks))) ||
	       ((new_desc_blk && (blk == new_desc_blk))) ||
	       (blk == fs->group_desc[group].bg_block_bitmap) ||
	       (blk == fs->group_desc[group].bg_inode_bitmap) ||
	       ((blk >= fs->group_desc[group].bg_inode_table &&
		 (blk < fs->group_desc[group].bg_inode_table
		  + fs->inode_blocks_per_group))))

So this is something I could make available via a function.  The other
usage pattern which various functions implement is determining the
number of reserved metadata blocks (from superblock, block group
descriptors, inode tables, and bitmap blocks) in use in that
blockgroup.

> A group descriptor would almost be the right struct, but it doesn't
> (yet?) include the GDT block count, itable block count, or a flag if
> there is a superblock.  Adding these fields into the on-disk group_desc
> struct wouldn't be a bad idea, then all the need to recalculate the
> group layout in 10 places would disappear.

It's not worth managing the disk format change, nor the space on disk
for all this information, IMHO.

Probably what we should do is have a new 64-bit version of
ext2fs_super_and_bgd_loc() fill in a data structure which contains all
of the calculated information, instead of in a series of pointers
passed into the function, and then create a new function which given a
block number and the said data structure, returns a boolean true/false
value if the block is part of the metadata.

> A second function would take the above block numbers (possibly in the
> form of a modified group descriptor) and return a populated block bitmap.

Yes, possibly; this will only be used by e2fsck and resize2fs, but
it's probably worth factoring out the code.

						- Ted
