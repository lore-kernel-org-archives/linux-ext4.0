From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 26/25] libext2fs: call get_alloc_block hook when
 allocating blocks
Date: Fri, 12 Sep 2014 18:17:53 -0400
Message-ID: <20140912221753.GB27092@thunk.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
 <20140911194153.GR10351@birch.djwong.org>
 <20140911220552.GB17990@thunk.org>
 <20140911223447.GZ10351@birch.djwong.org>
 <20140912173551.GA27092@thunk.org>
 <20140912175750.GA10150@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54430 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbaILWR5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 12 Sep 2014 18:17:57 -0400
Content-Disposition: inline
In-Reply-To: <20140912175750.GA10150@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 12, 2014 at 10:57:50AM -0700, Darrick J. Wong wrote:
> 
> > errcode_t ext2fs_alloc_blocks(ext2_filsys fs, blk64_t goal,
> > 	  	              unsigned int *num_blocks,
> > 			      char *block_buf, int flags, blk64_t *ret)
> > 
> > ... which can be used to efficiently allocate up to *num_blocks blocks
> > at a time, much like the mballoc interface.  I suspect that would be
> > useful for a number of different cases, including ext2fs_fallocate and
> > mk_hugefiles.c.
> 
> Sounds familiar:  http://marc.info/?l=linux-ext4&m=139898612510491&w=2

Yes, but I'm thinking of something which is a superset of
ext2fs_alloc_block2().  That is, that it should call the
get_alloc_block hook (and also adding a possible get_alloc_blocks
hook), and that a flag would control whether the data blocks would be
zero'ed or not.  (Indeed, I was thinking originally of calling it
ext2fs_alloc_block3.)

> > What I'm currently wondering about is whether it's worth the interface
> > complexity to have something like a "struct ext2fs_allocation_request"
> > structure, so we can potentially add more hints that a future
> > implementation might use, or whether that's not worth it.
> > 
> > What do folks think?
> 
> I'm not sure changing a struct vs. changing whatever parameters we feed into
> that function is all that much different.  I guess you could get around
> structure size changes by forcing callers to use a library allocator function.
> But OTOH large allocations are probably rare.

We can also insulate against structure sizes by using padding fields,
but the ultimate question is how complicated we want to make this
interface.  We know it will be used by mk_hugeblock and the fallocate
interface.  In theory it could be use by your fuse driver to do
allocations more efficiently.  There is the question of whether it's
worth it, although it has crossed my mind that this might be an
interesting place to start experimenting with an eventual replacement
of the buddy-bitmap implementation in mballoc with something that use
in-memory rbtrees, for example....

					- Ted
