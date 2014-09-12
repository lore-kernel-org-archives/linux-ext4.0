From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 26/25] libext2fs: call get_alloc_block hook when
 allocating blocks
Date: Fri, 12 Sep 2014 13:35:51 -0400
Message-ID: <20140912173551.GA27092@thunk.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
 <20140911194153.GR10351@birch.djwong.org>
 <20140911220552.GB17990@thunk.org>
 <20140911223447.GZ10351@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53848 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbaILRfy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 12 Sep 2014 13:35:54 -0400
Content-Disposition: inline
In-Reply-To: <20140911223447.GZ10351@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 11, 2014 at 03:34:47PM -0700, Darrick J. Wong wrote:
> > Hmm... I wonder if we can get away with changing ext2fs_new_block2(fs,
> > goal, bmap, ret_blk) so that if bmap is NULL, we change its behavior
> > so that (a) it tries to use the get_alloc_block() hook if it is present, and
> > (b) it will try to load the block bitmap if it is not already loaded,
> > instead of returning an error.
> 
> Quite probably.  I tried to avoid API behavioral change, at least for the
> inital patch, though I was thinking that a general cleanup was probably in
> order.

It turns out that making a behavioral change could very well break
some callers --- including e2fsck (see e2fsck_get_alloc_block for an
example of wahy).  What I'm currently thinking about is an API sort of
like this:

errcode_t ext2fs_alloc_blocks(ext2_filsys fs, blk64_t goal,
	  	              unsigned int *num_blocks,
			      char *block_buf, int flags, blk64_t *ret)

... which can be used to efficiently allocate up to *num_blocks blocks
at a time, much like the mballoc interface.  I suspect that would be
useful for a number of different cases, including ext2fs_fallocate and
mk_hugefiles.c.

What I'm currently wondering about is whether it's worth the interface
complexity to have something like a "struct ext2fs_allocation_request"
structure, so we can potentially add more hints that a future
implementation might use, or whether that's not worth it.

What do folks think?

					- Ted
