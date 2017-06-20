From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mke2fs: fix hugefile creation so the hugefile(s) are
 contiguous
Date: Tue, 20 Jun 2017 05:31:36 -0400
Message-ID: <20170620093136.ciiothqlcnoihl53@thunk.org>
References: <20170619224927.3176-1-tytso@mit.edu>
 <20170619232945.GB76149@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48892 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751007AbdFTJbm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 20 Jun 2017 05:31:42 -0400
Content-Disposition: inline
In-Reply-To: <20170619232945.GB76149@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 19, 2017 at 04:29:45PM -0700, Eric Biggers wrote:
> Can you also update the mke2fs.conf man page to document under what
> circumstances it can be assumed that the preallocated "hugefiles" will be
> physically contiguous?  Currently I don't see any mention of it.

Good point, I'll do that.


> > diff --git a/misc/mk_hugefiles.c b/misc/mk_hugefiles.c
> > -	retval = ext2fs_fallocate(fs, falloc_flags, *ino, &inode, goal, 0, num);
> > +	retval = ext2fs_extent_open2(fs, *ino, &inode, &handle);
> >  	if (retval)
> >  		return retval;
> > -	retval = ext2fs_inode_size_set(fs, &inode, num * fs->blocksize);
> > +
> > +	lblk = 0;
> > +	left = num ? num : 1;
> 
> Add a comment explaining why ext2fs_fallocate() isn't sufficient?

Done.

> Alternatively, would it be possible to fix ext2fs_fallocate() instead?

We could possibly add this feature to ext2fs_fallocate(); it would
mean changing extent_fallocate() so that it used one goal block
variable for data blocks, and different goal block variable for extent
tree blocks and to default the goal block variable for the
metadata blocks to be "near the inode".

My preference though is to change the behavior back to the original
1.42 behaviour, since this is regression broke production code.  Once
we have this fixed we can always try again to refactor the code after
adding a new feature flag to ext2fs_fallocate().

> This only verifies that the extent tree blocks are in the expected locations.
> How about also verifying that the file is actually physically contigious?  If
> storing the full output file is too large it could be done algorithmically, e.g.
> verifying that the following doesn't produce any output:

Yeah, I've already modified the test to store the full output of the
dump_extents of the hugefile in compressed form and then to use zcmp
and zdiff to compare the actual output to the expected out.  That
seems to be the simplest way to do things, and doesn't require that we
validate the algorihmic code.

						- Ted
