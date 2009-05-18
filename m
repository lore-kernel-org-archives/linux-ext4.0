From: Theodore Tso <tytso@mit.edu>
Subject: Re: e2fsprogs bmap problem
Date: Sun, 17 May 2009 21:52:45 -0400
Message-ID: <20090518015245.GC32019@mit.edu>
References: <382524.16755.qm@web43505.mail.sp1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: number9652@yahoo.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:41720 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704AbZERBwy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 17 May 2009 21:52:54 -0400
Content-Disposition: inline
In-Reply-To: <382524.16755.qm@web43505.mail.sp1.yahoo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 15, 2009 at 01:49:38PM -0700, number9652@yahoo.com wrote:
> 
> I am running into a problem with the output of the function
> ext2fs_bmap in the ext2fs library version 1.41.5: when I send it an
> inode structure pointer as the third argument and the number of a
> deleted inode as the second argument, it seems to end up trying to
> read the deleted inode from disk (and results in the returned value
> block number being 0), when I expected it to just get the values
> from the inode structure I send to it.  This only happens if the
> inode contains an extent structure within it; when it has the
> indirect block structure it behaves as I expected.
> 
> I couldn't find the documentation for this function, so is this the
> right behavior for this function?  If so, is there a better way to
> retrieve the block numbers pointed to by an inode structure provided
> by the ext2fs library?

Well, I can confirm you're not crazy, this is what happens today.
Whether or not this is the proper behaviour is a different question.
The ability to pass in an inode structure to ext2fs_bmap() was always
intended to be as an optimization; in many cases, the caller had a
copy of the inode anyway, so passing it in saved ext2fs_bmap() from
needing to read it into memory.  However, the intention was that what
was given to ext2fs_bmap() was the same as what as on disk.  So the
question of what happened when inode structure passed to ext2fs_bmap()
is different from the what is actually on disk is not one that I had
really considered.

In the case of extents support, we implemented the extent support
functions in lib/ext2fs/extent.c first, and then retrofitted
ext2fs_bmap() to call the extents function.  Since the extent support
functions didn't have the facility for passing in an inode structure,
they always end up reading the inode; this means that for inodes which
use extent encoding, even if you pass in an inode structure to
ext2fs_bmap(), the version on disk is the one that ends up getting
used anyway.

I suppose we could add a new version of the extent structure which
used a caller-supplied inode structure.  This would be mostly safe as
long as you were only doing read-only operations on the buffer head,
and only assuming that all of the extents fit in the inode structure.

One of the reasons why it's not at all defined what happens if the
inode passed into ext2fs_bmap() is different from what is on disk is
that if there are any indirect blocks, or extent tree blocks that are
needed to complete the operation, those *will* need to be read from
disk.  And if in the case of a deleted inode, who knows if those will
be accurate.  Worse if there is any attempt to call ext2_bmap with the
BMAP_SET or BMAP_ALLOC flag, it is passed in inode structure will be
written to disk, and that could cause all sorts of potential
filesystem corruption, especially if the inode had since been
reallocated.

The short version is it would be possible for us to patch the extents
support code to use a passed-in inode, and then change ext2fs_bmap()
to pass the inode structure to the extents functions, but the main
reason why I would do it would be for the optimization, and not to
support (at least officially) the use of an inode structure different
from what is on disk, since that is highly likely to simply not work
correctly.

Out of curiosity, where are you getting the data for the inode
structure if it is not on disk?  Is this some kind of ext3grep-like
approach where you are grabbing an old version of the inode from the
journal, or some such?

					- Ted
