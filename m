From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 17/34] libext2fs: support allocating uninit blocks in
 bmap2()
Date: Mon, 13 Oct 2014 10:35:26 -0400
Message-ID: <20141013143526.GE9738@thunk.org>
References: <20140913221112.13646.3873.stgit@birch.djwong.org>
 <20140913221306.13646.36911.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50021 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753103AbaJMOfb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Oct 2014 10:35:31 -0400
Content-Disposition: inline
In-Reply-To: <20140913221306.13646.36911.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 13, 2014 at 03:13:06PM -0700, Darrick J. Wong wrote:
> In order to support fallocate, we need to be able to have
> ext2fs_bmap2() allocate blocks and put them into uninitialized
> extents.  There's a flag to do this in the extent code, but it's not
> exposed to the bmap2 interface, so plumb that in.  Eventually
> fallocate or fuse2fs or somebody will use it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  lib/ext2fs/bmap.c   |   24 ++++++++++++++++++++++--
>  lib/ext2fs/ext2fs.h |    1 +
>  2 files changed, 23 insertions(+), 2 deletions(-)
> 
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

What I think we should do is to have two separate new BMAP_ flags;
BMAP_UNINIT, which sets the uninit bit, and BMAP_ZERO, which requests
that the block be zeroed.  I don't think it should follow that whe you
set the uninit bit via the libext2fs, the block wil automatically be
zeroed.  After all, userspace can't assume that if the uninit bit is
set, that the block will be pre-zeroed, since files fallocated by the
kernel won't meet that guarantee.

					- Ted
