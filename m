From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 29/47] resize2fs: don't mark unallocated bg metadata
 blocks when fixing bg flags
Date: Fri, 19 Dec 2014 11:15:54 -0800
Message-ID: <20141219191554.GF5368@birch.djwong.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
 <20141107215354.883.35283.stgit@birch.djwong.org>
 <20141215021748.GE17575@thunk.org>
 <20141215070900.GD5368@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50085 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbaLSTQC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Dec 2014 14:16:02 -0500
Content-Disposition: inline
In-Reply-To: <20141215070900.GD5368@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 14, 2014 at 11:09:00PM -0800, Darrick J. Wong wrote:
> On Sun, Dec 14, 2014 at 09:17:48PM -0500, Theodore Ts'o wrote:
> > On Fri, Nov 07, 2014 at 01:53:54PM -0800, Darrick J. Wong wrote:
> > > When fixing up block group bitmaps on the new fs, don't try to mark
> > > unallocated group metadata blocks; these will be allocated (and
> > > marked) later.
> > 
> > The commit description doesn't match the diff.  It looks like what you
> > are doing is adding a check in case ext2fs_{block,inode}_bitmap_loc is
> > zero (which is not bad, but when can that happen; and if it's
> > something that _can_ happen, should we be triggering an assert
> > failure), and using ext2fs_mark_block_bitmap_range2() instead of a for
> > loop.

Aha, I have recaptured when this happens:

0) I have a debug patch that complains if anyone other than mke2fs tries
to allocate, deallocate, mark, or unmark block 0.

1) If we tell resize2fs to convert a FS to 64bit mode, it's possible that
move_bg_metadata() has to move the bitmaps or the inode table out of the way
because the group descriptors overflow the end of the regular and the reserved
gdt blocks.  This can happen if you format a small FS, fill it with files,
expand it to use most of the reserved GDT blocks, then try to upgrade it to
64bit.

2) To force a reallocation of the bitmaps/inode table, move_bg_metadata() sets
the fields to zero in new_fs.

3) fix_uninit_block_bitmaps() is called on new_fs, and fails when we try to
mark block 0 in the block bitmap.  Due to (0), a complaint happens.

4) Later, blocks_to_move() will also notice group descriptors pointing to block
zero and fix this via ext2fs_allocate_group_table().  Then it moves the blocks,
and we're done.

I conclude that this patch isn't really needed.  It's a little funny to be
marking block zero (which should already be marked) but doing so doesn't
negatively affect the FS in this particular case.

--D

> > 
> > Is there a back story to this patch?
> 
> Looking through my notes, I think the reason I wrote this patch was that if
> we're running resize2fs to enlarge inodes on a nearly full filesystem, we can
> end up setting those bg fields to zero to force a later reallocation because
> the only free space big enough to hold the larger inode table is somewhere else
> in the FS. In the meantime, trying to mark block zero results in a lot of
> unnecessary stderr spew about the invalid block number.  This issue doesn't
> affect resize2fs functionality, it just looks scary.
> 
> Yeah, probably we should use mark...range().
> 
> --D
> 
> > 
> > Thanks,
> > 
> > 						- Ted
> > 
> > > diff --git a/resize/resize2fs.c b/resize/resize2fs.c
> > > index 94c0643..a760593 100644
> > > --- a/resize/resize2fs.c
> > > +++ b/resize/resize2fs.c
> > > @@ -242,7 +242,6 @@ static void fix_uninit_block_bitmaps(ext2_filsys fs)
> > >  {
> > >  	blk64_t		blk, lblk;
> > >  	dgrp_t		g;
> > > -	int		i;
> > >  
> > >  	if (!ext2fs_has_group_desc_csum(fs))
> > >  		return;
> > > @@ -257,14 +256,16 @@ static void fix_uninit_block_bitmaps(ext2_filsys fs)
> > >  						  lblk - blk + 1);
> > >  
> > >  		ext2fs_reserve_super_and_bgd(fs, g, fs->block_map);
> > > -		ext2fs_mark_block_bitmap2(fs->block_map,
> > > -					  ext2fs_block_bitmap_loc(fs, g));
> > > -		ext2fs_mark_block_bitmap2(fs->block_map,
> > > -					  ext2fs_inode_bitmap_loc(fs, g));
> > > -		for (i = 0, blk = ext2fs_inode_table_loc(fs, g);
> > > -		     i < (unsigned int) fs->inode_blocks_per_group;
> > > -		     i++, blk++)
> > > +		blk = ext2fs_block_bitmap_loc(fs, g);
> > > +		if (blk)
> > > +			ext2fs_mark_block_bitmap2(fs->block_map, blk);
> > > +		blk = ext2fs_inode_bitmap_loc(fs, g);
> > > +		if (blk)
> > >  			ext2fs_mark_block_bitmap2(fs->block_map, blk);
> > > +		blk = ext2fs_inode_table_loc(fs, g);
> > > +		if (blk)
> > > +			ext2fs_mark_block_bitmap_range2(fs->block_map, blk,
> > > +						fs->inode_blocks_per_group);
> > >  	}
> > >  }
> > >  
> > > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
