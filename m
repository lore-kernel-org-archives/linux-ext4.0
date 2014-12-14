From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 13/47] libext2fs: add a way to check the theoretical
 maximum extent tree depth
Date: Sat, 13 Dec 2014 19:11:11 -0800
Message-ID: <20141214031111.GB27255@birch.djwong.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
 <20141107215212.883.11364.stgit@birch.djwong.org>
 <20141214022357.GC29787@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35746 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbaLNDLR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 13 Dec 2014 22:11:17 -0500
Content-Disposition: inline
In-Reply-To: <20141214022357.GC29787@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Dec 13, 2014 at 09:23:57PM -0500, Theodore Ts'o wrote:
> On Fri, Nov 07, 2014 at 01:52:12PM -0800, Darrick J. Wong wrote:
> > Add an API so that client programs can discover a reasonable maximum
> > extent tree depth.  This will eventually be used by e2fsck as one of
> > the criteria to decide if an extent-based file should have its extent
> > tree rebuilt.
> > 
> > +size_t ext2fs_max_extent_depth(ext2_extent_handle_t handle)
> > +{
> > +	size_t iblock_sz = sizeof(((struct ext2_inode *)NULL)->i_block);
> > +	size_t iblock_extents = (iblock_sz - sizeof(struct ext3_extent_header)) /
> > +				sizeof(struct ext3_extent);
> > +	size_t extents_per_block = (handle->fs->blocksize -
> > +				    sizeof(struct ext3_extent_header)) /
> > +				   sizeof(struct ext3_extent);
> > +
> > +	return 1 + ((ul_log2(EXT_MAX_EXTENT_LBLK) - ul_log2(iblock_extents)) /
> > +		    ul_log2(extents_per_block));
> > +}
> > +
> 
> This patch is only used by patch #33, and it gets called for every
> single inode which is extent-mapped.
> 
> But if you look at the above code, there is nothing which is inode or
> handle specific.  The value is only dependent on fs->blocksize.  But
> to calculate this value the function calls ul_log2 three times, which
> is implemented using a looping construct.  So we will be recalculating
> what is effectively a constant value every single inode in an ext4
> file system, which seems very unfortunate.

How about I save the last fs->blocksize and the last result, and return the
cached last result if fs->blocksize == lastblocksize?

--D

> 
> BTW, there are some ways we could accelerate the log2 function, and
> I've considered implementing an ext2fs_log2_u32() and
> ext2fs_log2_u64() using something like this:
> 
> int log2i(unsigned int x)
> {
> 	if (!x)
> 		return 0;
> 
> 	return sizeof(unsigned int) * 8 - __builtin_clz(x) - 1;
> }
> 
> or
> 
> int log2u64(unsigned long long x)
> {
> 	if (!x)
> 		return 0;
> 
> 	return sizeof(unsigned long long) * 8 - __builtin_clzll(x) - 1;
> }
> 
> or
> 
> int generic_log2(unsigned int x)
> {
> 	int r = 0;
> 
> 	if (x >= ((unsigned int)(1) << 16)) {
> 		r += 16;
> 		x >>= 16;
> 	}
> 	if (x >= ((unsigned int)(1) << 8)) {
> 		r += 8;
> 		x >>= 8;
> 	}
> 	if (x >= ((unsigned int)(1) << 4)) {
> 		r += 4;
> 		x >>= 4;
> 	}
> 	if (x >= ((unsigned int)(1) << 2)) {
> 		r += 2;
> 		x >>= 2;
> 	}
> 	if (x >= ((unsigned int)(1) << 1)) {
> 		r += 1;
> 		x >>= 1;
> 	}
> 	return r;
> }
> 
> But it's not at all clear it's worth doing this because I haven't seen
> any place in e2fsprogs where we really should be calculating an
> integer log2 in a tight loop where performance should make a
> difference.  If we are, we're probably doing something wrong....
> 
> 	     	   	      	       	     	       - Ted
