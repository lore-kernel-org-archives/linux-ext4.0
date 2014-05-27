From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 2/2] libext2fs: support allocating uninit blocks in
 bmap2()
Date: Tue, 27 May 2014 18:28:22 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1405271827290.2055@localhost.localdomain>
References: <20140501231222.31890.82860.stgit@birch.djwong.org> <20140501231407.31890.3876.stgit@birch.djwong.org> <alpine.LFD.2.00.1405061736390.2255@localhost.localdomain> <20140506195938.GD25745@birch.djwong.org> <alpine.LFD.2.00.1405071045090.2128@localhost.localdomain>
 <20140507213704.GA8923@birch.djwong.org> <20140508001447.GD8923@birch.djwong.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1418217955-1401208106=:2055"
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbaE0Q22 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 May 2014 12:28:28 -0400
In-Reply-To: <20140508001447.GD8923@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1418217955-1401208106=:2055
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Wed, 7 May 2014, Darrick J. Wong wrote:

> Date: Wed, 7 May 2014 17:14:47 -0700
> From: Darrick J. Wong <darrick.wong@oracle.com>
> To: Luká¨ Czerner <lczerner@redhat.com>
> Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
> Subject: [PATCH 2/2] libext2fs: support allocating uninit blocks in bmap2()
> 
> Here's the second part, which for the most part is the old patch, but wired up
> to use the bits in the other patch.

Looks good

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

but I wonder how effective will this be with zero range when we're
doing this on block at the time.

Thanks!
-Lukas

> 
> --D
> ---
> In order to support fallocate, we need to be able to have
> ext2fs_bmap2() allocate blocks and put them into uninitialized
> extents.  There's a flag to do this in the extent code, but it's not
> exposed to the bmap2 interface, so plumb that in.  Eventually fuse2fs
> or somebody will use it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  lib/ext2fs/bmap.c   |   24 ++++++++++++++++++++++--
>  lib/ext2fs/ext2fs.h |    1 +
>  2 files changed, 23 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/ext2fs/bmap.c b/lib/ext2fs/bmap.c
> index c1d0e6f..a4dc8ef 100644
> --- a/lib/ext2fs/bmap.c
> +++ b/lib/ext2fs/bmap.c
> @@ -72,6 +72,11 @@ static _BMAP_INLINE_ errcode_t block_ind_bmap(ext2_filsys fs, int flags,
>  					    block_buf + fs->blocksize, &b);
>  		if (retval)
>  			return retval;
> +		if (flags & BMAP_UNINIT) {
> +			retval = ext2fs_zero_blocks2(fs, b, 1, NULL, NULL);
> +			if (retval)
> +				return retval;
> +		}
>  
>  #ifdef WORDS_BIGENDIAN
>  		((blk_t *) block_buf)[nr] = ext2fs_swab32(b);
> @@ -214,10 +219,13 @@ static errcode_t extent_bmap(ext2_filsys fs, ext2_ino_t ino,
>  	errcode_t		retval = 0;
>  	blk64_t			blk64 = 0;
>  	int			alloc = 0;
> +	int			set_flags;
> +
> +	set_flags = bmap_flags & BMAP_UNINIT ? EXT2_EXTENT_SET_BMAP_UNINIT : 0;
>  
>  	if (bmap_flags & BMAP_SET) {
>  		retval = ext2fs_extent_set_bmap(handle, block,
> -						*phys_blk, 0);
> +						*phys_blk, set_flags);
>  		return retval;
>  	}
>  	retval = ext2fs_extent_goto(handle, block);
> @@ -254,7 +262,7 @@ got_block:
>  		alloc++;
>  	set_extent:
>  		retval = ext2fs_extent_set_bmap(handle, block,
> -						blk64, 0);
> +						blk64, set_flags);
>  		if (retval) {
>  			ext2fs_block_alloc_stats2(fs, blk64, -1);
>  			return retval;
> @@ -345,6 +353,12 @@ errcode_t ext2fs_bmap2(ext2_filsys fs, ext2_ino_t ino, struct ext2_inode *inode,
>  		goto done;
>  	}
>  
> +	if ((bmap_flags & BMAP_SET) && (bmap_flags & BMAP_UNINIT)) {
> +		retval = ext2fs_zero_blocks2(fs, *phys_blk, 1, NULL, NULL);
> +		if (retval)
> +			goto done;
> +	}
> +
>  	if (block < EXT2_NDIR_BLOCKS) {
>  		if (bmap_flags & BMAP_SET) {
>  			b = *phys_blk;
> @@ -360,6 +374,12 @@ errcode_t ext2fs_bmap2(ext2_filsys fs, ext2_ino_t ino, struct ext2_inode *inode,
>  			retval = ext2fs_alloc_block(fs, b, block_buf, &b);
>  			if (retval)
>  				goto done;
> +			if (bmap_flags & BMAP_UNINIT) {
> +				retval = ext2fs_zero_blocks2(fs, b, 1, NULL,
> +							     NULL);
> +				if (retval)
> +					goto done;
> +			}
>  			inode_bmap(inode, block) = b;
>  			blocks_alloc++;
>  			*phys_blk = b;
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index 599c972..819a14a 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -527,6 +527,7 @@ typedef struct ext2_icount *ext2_icount_t;
>   */
>  #define BMAP_ALLOC	0x0001
>  #define BMAP_SET	0x0002
> +#define BMAP_UNINIT	0x0004
>  
>  /*
>   * Returned flags from ext2fs_bmap
> 
--8323328-1418217955-1401208106=:2055--
