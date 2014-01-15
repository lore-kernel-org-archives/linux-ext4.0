From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 50/74] libext2fs: support allocating uninit blocks in
 bmap2()
Date: Wed, 15 Jan 2014 13:11:22 -0800
Message-ID: <20140115211122.GJ9229@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211012353.30655.82545.stgit@birch.djwong.org>
 <20140111225755.GB10995@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33213 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbaAOVL2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Jan 2014 16:11:28 -0500
Content-Disposition: inline
In-Reply-To: <20140111225755.GB10995@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 11, 2014 at 05:57:55PM -0500, Theodore Ts'o wrote:
> On Tue, Dec 10, 2013 at 05:23:53PM -0800, Darrick J. Wong wrote:
> > @@ -336,6 +370,12 @@ errcode_t ext2fs_bmap2(ext2_filsys fs, ext2_ino_t ino, struct ext2_inode *inode,
> >  		goto done;
> >  	}
> >  
> > +	if ((bmap_flags & BMAP_SET) && (bmap_flags & BMAP_UNINIT)) {
> > +		retval = zero_block(fs, *phys_blk);
> > +		if (retval)
> > +			goto done;
> > +	}
> > +
> 
> We should use a new flag (say, BMAP_ZERO) if we want ext2fs_bmap2() to
> zero out the data block.  Otherwise, a number of tools which are
> currently using ext2fs_bmap, or debugfs "write" command to copy files
> into a file system will end up doing double writes into the file
> system --- once to zero the block, and a second time to write data
> into said block.

Ok, I'll create a BMAP_ZERO to do this.

> The libext2fs library is designed to be used for low-level tools, so
> we shouldn't presume that we should force blocks to be zero'ed unless
> the application really wants it.
> 
> The other thing to note about this patch is that if you want to
> implement fallocate, ext2fs_bmap2() is really the wrong tool to use.
> I've been working on a program for work which pre-creates a bunch of

I think that ext2fs_fallocate would be a good addition to the library.  Is your
program far enough along to share?  fuse2fs would benefit greatly.

That said, I've also found a couple of bugs in the extent code by implementing
fallocate in such a stupid way. :)  It turns out that if (a) we need to split
an extent into three pieces (say we write to a block in the middle of an
unwritten extent and don't want to convert the whole extent) and (b) either of
the extent_insert calls requires us to split the extent block and (c) we ENOSPC
while trying to allocate a new extent block, we don't put the extent tree back
the way it was before the split, and all the blocks after that point are lost.

I will send patches to avoid this corruption by checking for enough space soon.
I think your local git tree has patches in it that aren't on kernel.org yet, so
I'll hold off until I see them show up.

Fortunately there are only 5 new patches since last month. :)

> llarge files allocated contiguously on the disk as part of the mke2fs
> process, and it turns out that if you try to allocate several
> gigabytes worth of files using ext2fs_bmap2(), you end up burning a
> huge amount of CPU time (as in around 30 seconds of CPU times while
> fallocating a 10GB worth of blocks; so if you try to allocate a
> terabyte or three worth of blocks, it would take a truly long time,
> while you turn your CPU into a space heater :-).
> 
> The top profile user was update_path() in fs/ext4/extents.c, which is
> caused by the very large number of extent operations that are needed
> for each extent operation.  The second largest profile user is
> ext2fs_crc16(), caused by the large number of calls to
> ext2fs_block_alloc_stats2(), which causes the the block group
> descriptors to get incremented one at a time.
> 
> What we need to do if we want create an optimized fallocate() is to
> allocate blocks until we either exceed the max number of blocks in an
> extent, or we get a non-contiguous allocation, and then insert the
> extent into extent tree one extent at a time.  Similarly, we need to
> update the block group descriptors a batched chunks, instead of after
> each individual block allocation.
> 
> Similarly, as far as calling zero_block(), you really don't want to
> issue each 4k write separately.

Alternately, we could simply not allow BMAP_UNINIT for non-extent files.
That's the only reason why there's any zeroing going on at all.

--D
> 
> Cheers,
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
