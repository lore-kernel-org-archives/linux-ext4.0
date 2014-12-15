From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 29/47] resize2fs: don't mark unallocated bg metadata
 blocks when fixing bg flags
Date: Sun, 14 Dec 2014 23:09:00 -0800
Message-ID: <20141215070900.GD5368@birch.djwong.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
 <20141107215354.883.35283.stgit@birch.djwong.org>
 <20141215021748.GE17575@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42550 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaLOHJF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Dec 2014 02:09:05 -0500
Content-Disposition: inline
In-Reply-To: <20141215021748.GE17575@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 14, 2014 at 09:17:48PM -0500, Theodore Ts'o wrote:
> On Fri, Nov 07, 2014 at 01:53:54PM -0800, Darrick J. Wong wrote:
> > When fixing up block group bitmaps on the new fs, don't try to mark
> > unallocated group metadata blocks; these will be allocated (and
> > marked) later.
> 
> The commit description doesn't match the diff.  It looks like what you
> are doing is adding a check in case ext2fs_{block,inode}_bitmap_loc is
> zero (which is not bad, but when can that happen; and if it's
> something that _can_ happen, should we be triggering an assert
> failure), and using ext2fs_mark_block_bitmap_range2() instead of a for
> loop.
> 
> Is there a back story to this patch?

Looking through my notes, I think the reason I wrote this patch was that if
we're running resize2fs to enlarge inodes on a nearly full filesystem, we can
end up setting those bg fields to zero to force a later reallocation because
the only free space big enough to hold the larger inode table is somewhere else
in the FS. In the meantime, trying to mark block zero results in a lot of
unnecessary stderr spew about the invalid block number.  This issue doesn't
affect resize2fs functionality, it just looks scary.

Yeah, probably we should use mark...range().

--D

> 
> Thanks,
> 
> 						- Ted
> 
> > diff --git a/resize/resize2fs.c b/resize/resize2fs.c
> > index 94c0643..a760593 100644
> > --- a/resize/resize2fs.c
> > +++ b/resize/resize2fs.c
> > @@ -242,7 +242,6 @@ static void fix_uninit_block_bitmaps(ext2_filsys fs)
> >  {
> >  	blk64_t		blk, lblk;
> >  	dgrp_t		g;
> > -	int		i;
> >  
> >  	if (!ext2fs_has_group_desc_csum(fs))
> >  		return;
> > @@ -257,14 +256,16 @@ static void fix_uninit_block_bitmaps(ext2_filsys fs)
> >  						  lblk - blk + 1);
> >  
> >  		ext2fs_reserve_super_and_bgd(fs, g, fs->block_map);
> > -		ext2fs_mark_block_bitmap2(fs->block_map,
> > -					  ext2fs_block_bitmap_loc(fs, g));
> > -		ext2fs_mark_block_bitmap2(fs->block_map,
> > -					  ext2fs_inode_bitmap_loc(fs, g));
> > -		for (i = 0, blk = ext2fs_inode_table_loc(fs, g);
> > -		     i < (unsigned int) fs->inode_blocks_per_group;
> > -		     i++, blk++)
> > +		blk = ext2fs_block_bitmap_loc(fs, g);
> > +		if (blk)
> > +			ext2fs_mark_block_bitmap2(fs->block_map, blk);
> > +		blk = ext2fs_inode_bitmap_loc(fs, g);
> > +		if (blk)
> >  			ext2fs_mark_block_bitmap2(fs->block_map, blk);
> > +		blk = ext2fs_inode_table_loc(fs, g);
> > +		if (blk)
> > +			ext2fs_mark_block_bitmap_range2(fs->block_map, blk,
> > +						fs->inode_blocks_per_group);
> >  	}
> >  }
> >  
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
