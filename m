From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 15/34] libext2fs: support BLKZEROOUT/FALLOC_FL_ZERO_RANGE
 in ext2fs_zero_blocks
Date: Mon, 29 Sep 2014 11:58:44 -0700
Message-ID: <20140929185844.GM10150@birch.djwong.org>
References: <20140913221112.13646.3873.stgit@birch.djwong.org>
 <20140913221253.13646.7723.stgit@birch.djwong.org>
 <20140922025109.GF30646@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19086 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553AbaI2S6u (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Sep 2014 14:58:50 -0400
Content-Disposition: inline
In-Reply-To: <20140922025109.GF30646@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 21, 2014 at 10:51:09PM -0400, Theodore Ts'o wrote:
> On Sat, Sep 13, 2014 at 03:12:53PM -0700, Darrick J. Wong wrote:
> > +#if defined(HAVE_FALLOCATE) && defined(FALLOC_FL_ZERO_RANGE)
> > +		int flag = FALLOC_FL_ZERO_RANGE;
> > +		struct stat statbuf;
> > +
> > +		/*
> > +		 * If we're trying to zero a range past the end of the file,
> > +		 * just use regular fallocate to get there, because zeroing
> > +		 * a range past EOF does not extend the file.
> > +		 */
> 
> If we are operating on a regular file (for example, "mkfs.ext4
> /tmp/foo.img 64M") we want to keep the file a sparse one; so if we are
> trying to zero a range past the end of the file, it should be
> sufficient simply use trucate to set i_size.  In fact, if we can use
> FALLOC_FL_PUNCH on the regular file, we should try to use that
> instead, I would think.

I thought about making file-backed zero-out a simple truncate/punch operation,
since it would get us the results we want.  However, I had a look at what the
kernel's discard and zeroout implementations do for block devices, and came up
with:

discard: unprovision, may or may not return zeroes
zeroout: provision, return zeroes

(mkp is thinking about a zeroout that guarantees the zeroes but unprovisions if
possible a la FS hole punching, but we're not there yet.)

The users of the zero_blocks call (which uses this zeroout primitive) are
generally looking to clean off blocks in anticipation of them being written in
the near future so (to me) it makes more sense that after the call completes,
the block range has storage allocated to it.

Therefore, I took this approach to anticipate the needs of the callers and to
ensure that the side effects on the storage would be consistent between block
devices and file images.

(Of course, the user-visible effect is the same between the two approaches so I
don't really have a problem changing it.)

--D

> 
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
