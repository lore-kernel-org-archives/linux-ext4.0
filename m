From: Theodore Tso <tytso@mit.edu>
Subject: Re: Ext4 without a journal: some benchmark results
Date: Wed, 7 Jan 2009 21:17:08 -0500
Message-ID: <20090108021707.GA18744@mit.edu>
References: <6601abe90901071129v3de159d4jcf3b250aac40d0eb@mail.gmail.com> <20090107204739.GC4698@mit.edu> <6601abe90901071319k41bd2ac4h1c2dc27ec174a3d0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:57837 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757427AbZAHCRK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Jan 2009 21:17:10 -0500
Content-Disposition: inline
In-Reply-To: <6601abe90901071319k41bd2ac4h1c2dc27ec174a3d0@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 07, 2009 at 01:19:07PM -0800, Curt Wohlgemuth wrote:
> >
> > Curt, thanks for doing these test runs.  One interesting thing to note
> > is that even though ext3 was running with barriers disabled, and ext4
> > was running with barriers enabled, ext4 still showed consistently
> > better resuls.  (Or was this on an LVM/dm setup where barriers were
> > getting disabled?)
> 
> Nope.  Barriers were enabled for both ext4 versions below.

Well, barriers won't metter in the nojournal case, but it's nice to
know that for these workloads, ext4-stock (w/journalling) is faster
even that ext3 w/o barriers.  That's probably not be true with a
metadata-heavy workload with fsync's, such as fsmark, though.

> > The other thing to note is that in Compilebench's read_tree, ext2 and
> > ext3 are scoring better than ext4.  This is probably related to ext4's
> > changes in its block/inode allocation hueristics, which is something
> > that we probably should look at as part of tuning exercises.  The
> > brtfs.boxacle.net benchmarks showed something similar, which I also
> > would attribute to changes in ext4's allocation policies.
> 
> Can you enlighten me as to what aspect of block allocation might be
> involved in the slowdown here?  Which block group these allocations
> are made from?  Or something more low-level than that?

Ext4's block allocation algorithsm are quite different from ext3, but
that's not what I'm worried about.  Ext4's mballoc algorithms are much
more aggressive to find contiguous blocks, and that's a good thing.
There may be some issues about how it decides to do its localilty
group preallocation vs streaming preallocation, but these are all
tactical issues that in the end probably don't make that big of a
difference.  There may also be some issues about which block group
mballoc chooses if its home block group is full, but I suspect those
are second-order issues.

The bigger problem is the strategic level issues of how inodes are
allocated, in particular when new directories are allocated.  It is
much more aggressive about keeping subdirectories in the same block
group.  It also completely disables the Orlov allocator algorithsm to
spread out top-level directories and directories (such as /home) that
would have the top-level directory flag set.  Indeed, the new ext4
allocation algorithm doesn't differentiate between directories and
inodes in its allocation algorithms at all.

My concern with the current algorithms is that for very short
benchmarks, it keeps everything very closely packed together at the
beginning of the filesystem, which is probably good for those
benchmarks.  But for more complex benchmarks and longer-lived
filesystems where aging is a concern, the lack of spreading may cause
a much bigger set of problems, especially in the long-term.

There some other changes I want to make that involve avoid putting
inodes in block group that area multiple of the flex block group size,
since all of the inode table blocks and block/inode allocation bitmaps
are stored in those block groups, and reserving the blocks in that
block group for directory blocks in that block group, but that
requires testing to make sure it makes sense.

	 					- Ted
