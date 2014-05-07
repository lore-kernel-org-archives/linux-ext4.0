From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 16/37] libext2fs: support allocating uninit blocks in
 bmap2()
Date: Wed, 7 May 2014 12:02:30 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1405071045090.2128@localhost.localdomain>
References: <20140501231222.31890.82860.stgit@birch.djwong.org> <20140501231407.31890.3876.stgit@birch.djwong.org> <alpine.LFD.2.00.1405061736390.2255@localhost.localdomain> <20140506195938.GD25745@birch.djwong.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-8413990-1399456952=:2128"
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932344AbaEGKCf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 May 2014 06:02:35 -0400
In-Reply-To: <20140506195938.GD25745@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-8413990-1399456952=:2128
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Tue, 6 May 2014, Darrick J. Wong wrote:

> Date: Tue, 6 May 2014 12:59:38 -0700
> From: Darrick J. Wong <darrick.wong@oracle.com>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
> Subject: Re: [PATCH 16/37] libext2fs: support allocating uninit blocks in
>     bmap2()
> 
> On Tue, May 06, 2014 at 05:45:01PM +0200, Lukáš Czerner wrote:
> > On Thu, 1 May 2014, Darrick J. Wong wrote:
> > 
> > > Date: Thu, 01 May 2014 16:14:07 -0700
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > To: tytso@mit.edu, darrick.wong@oracle.com
> > > Cc: linux-ext4@vger.kernel.org
> > > Subject: [PATCH 16/37] libext2fs: support allocating uninit blocks in bmap2()
> > > 
> > > In order to support fallocate, we need to be able to have
> > > ext2fs_bmap2() allocate blocks and put them into uninitialized
> > > extents.  There's a flag to do this in the extent code, but it's not
> > > exposed to the bmap2 interface, so plumb that in.  Eventually fuse2fs
> > > or somebody will use it.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  lib/ext2fs/bmap.c      |   24 ++++++++++++++++++++++--
> > >  lib/ext2fs/ext2fs.h    |    1 +
> > >  lib/ext2fs/mkjournal.c |   17 +++++++++++++++++
> > >  3 files changed, 40 insertions(+), 2 deletions(-)
> > > 
> > > 
> > > diff --git a/lib/ext2fs/bmap.c b/lib/ext2fs/bmap.c
> > > index c1d0e6f..a4dc8ef 100644
> > > --- a/lib/ext2fs/bmap.c
> > > +++ b/lib/ext2fs/bmap.c
> > > @@ -72,6 +72,11 @@ static _BMAP_INLINE_ errcode_t block_ind_bmap(ext2_filsys fs, int flags,
> > >  					    block_buf + fs->blocksize, &b);
> > >  		if (retval)
> > >  			return retval;
> > > +		if (flags & BMAP_UNINIT) {
> > > +			retval = ext2fs_zero_blocks2(fs, b, 1, NULL, NULL);
> > > +			if (retval)
> > > +				return retval;
> > > +		}
> > >  
> > >  #ifdef WORDS_BIGENDIAN
> > >  		((blk_t *) block_buf)[nr] = ext2fs_swab32(b);
> > > @@ -214,10 +219,13 @@ static errcode_t extent_bmap(ext2_filsys fs, ext2_ino_t ino,
> > >  	errcode_t		retval = 0;
> > >  	blk64_t			blk64 = 0;
> > >  	int			alloc = 0;
> > > +	int			set_flags;
> > > +
> > > +	set_flags = bmap_flags & BMAP_UNINIT ? EXT2_EXTENT_SET_BMAP_UNINIT : 0;
> > >  
> > >  	if (bmap_flags & BMAP_SET) {
> > >  		retval = ext2fs_extent_set_bmap(handle, block,
> > > -						*phys_blk, 0);
> > > +						*phys_blk, set_flags);
> > >  		return retval;
> > >  	}
> > >  	retval = ext2fs_extent_goto(handle, block);
> > > @@ -254,7 +262,7 @@ got_block:
> > >  		alloc++;
> > >  	set_extent:
> > >  		retval = ext2fs_extent_set_bmap(handle, block,
> > > -						blk64, 0);
> > > +						blk64, set_flags);
> > >  		if (retval) {
> > >  			ext2fs_block_alloc_stats2(fs, blk64, -1);
> > >  			return retval;
> > > @@ -345,6 +353,12 @@ errcode_t ext2fs_bmap2(ext2_filsys fs, ext2_ino_t ino, struct ext2_inode *inode,
> > >  		goto done;
> > >  	}
> > >  
> > > +	if ((bmap_flags & BMAP_SET) && (bmap_flags & BMAP_UNINIT)) {
> > > +		retval = ext2fs_zero_blocks2(fs, *phys_blk, 1, NULL, NULL);
> > > +		if (retval)
> > > +			goto done;
> > > +	}
> > > +
> > >  	if (block < EXT2_NDIR_BLOCKS) {
> > >  		if (bmap_flags & BMAP_SET) {
> > >  			b = *phys_blk;
> > > @@ -360,6 +374,12 @@ errcode_t ext2fs_bmap2(ext2_filsys fs, ext2_ino_t ino, struct ext2_inode *inode,
> > >  			retval = ext2fs_alloc_block(fs, b, block_buf, &b);
> > >  			if (retval)
> > >  				goto done;
> > > +			if (bmap_flags & BMAP_UNINIT) {
> > > +				retval = ext2fs_zero_blocks2(fs, b, 1, NULL,
> > > +							     NULL);
> > > +				if (retval)
> > > +					goto done;
> > > +			}
> > >  			inode_bmap(inode, block) = b;
> > >  			blocks_alloc++;
> > >  			*phys_blk = b;
> > > diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> > > index 599c972..819a14a 100644
> > > --- a/lib/ext2fs/ext2fs.h
> > > +++ b/lib/ext2fs/ext2fs.h
> > > @@ -527,6 +527,7 @@ typedef struct ext2_icount *ext2_icount_t;
> > >   */
> > >  #define BMAP_ALLOC	0x0001
> > >  #define BMAP_SET	0x0002
> > > +#define BMAP_UNINIT	0x0004
> > >  
> > >  /*
> > >   * Returned flags from ext2fs_bmap
> > > diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
> > > index 884d9c0..ecc3912 100644
> > > --- a/lib/ext2fs/mkjournal.c
> > > +++ b/lib/ext2fs/mkjournal.c
> > > @@ -174,6 +174,23 @@ errcode_t ext2fs_zero_blocks2(ext2_filsys fs, blk64_t blk, int num,
> > >  			return ENOMEM;
> > >  		memset(buf, 0, fs->blocksize * STRIDE_LENGTH);
> > >  	}
> > > +
> > > +	/* Try discard, if it zeroes data... */
> > > +	if (io_channel_discard_zeroes_data(fs->io)) {
> > > +		memset(buf + fs->blocksize, 0, fs->blocksize);
> > > +		retval = io_channel_discard(fs->io, blk, num);
> > > +		if (retval)
> > > +			goto skip_discard;
> > > +		retval = io_channel_read_blk64(fs->io, blk, 1, buf);
> > > +		if (retval)
> > > +			goto skip_discard;
> > > +		if (memcmp(buf, buf + fs->blocksize, fs->blocksize) == 0)
> > > +			return 0;
> > > +		/* Hah!  Discard doesn't zero! */
> > > +		fs->io->flags &= ~CHANNEL_FLAGS_DISCARD_ZEROES;
> > > +	}
> > > +skip_discard:
> > 
> > You did not mention that in the description, but this is actually a
> > problem. The reason is that discard might not be reliable on some
> > devices. This has been discussed several times and I am not the only
> > one who've seen that even if the device itself says that it will
> > return zeroes from discarded regions sometimes it might return data.
> 
> I agree that the storage not living up to the interface it advertises is a
> problem, hence the verification step that will unset the io channel flag if it
> finds that the device is lying.
> 
> On the other hand, I wonder if this ought to be abstracted away in an
> io_channel_zero() call that takes care of figuring out if it can do a zeroing
> discard or if it has to write a block of zeroes.
> 
> Or, are you worried that a discard and immediate re-read will appear to work,
> but that a later re-read will return non-zero data?

Yes I am, because we know that it sometimes behaves unpredictably
and this is one of the things that might just happen. Even though I
have not seen this exact case I've seen the opposite where right
after discard I've read non zero values but later it actually
returned zeroes.

So I would much rather not rely on discard here because you might
expose stale data on indirect files and there is no way to turn this
optimization off.

> 
> > I would rather avoid this kind of optimization. However if the
> > underlying "device" is a loop device then it will be reliable if
> > it's supported. Also if then underlying "device" is a image then we
> > can just simply use punch hole.
> 
> But static whitelisting is also problematic -- what if the storage device is an
> AHCI (or virtio-scsi) disk in QEMU that's ultimately backed by a file that we
> can punch_hole?  How do we distinguish that from an SSD hooked up to SATA
> hardware?

We do not. We can only do that if we know we're sitting on a file.
It is really unfortunate, but I think that there is a limitation in
how we can use discard.

However we could use write same which should help on devices which
supports it and on the fs images because QEMU will convert that to
zero range (at least on xfs since ext4 implementation is quite new).
However I have no idea what is the interface to do that.

-Lukas

> 
> In the qemu emulated AHCI case we ought to be able to zeroing discard, if
> advertised.  I thought it was a reasonable compromise to trust that it works
> and verify the results afterward.
> 
> --D
> > 
> > Thanks!
> > -Lukas
> > 
> > > +
> > >  	/* OK, do the write loop */
> > >  	j=0;
> > >  	while (j < num) {
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--8323328-8413990-1399456952=:2128--
