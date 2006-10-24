From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC] Ext3 online defrag
Date: Tue, 24 Oct 2006 17:00:20 -0600
Message-ID: <20061024230020.GZ3509@schatzie.adilger.int>
References: <20061023122710.GA12034@atrey.karlin.mff.cuni.cz> <20061023141641.GA29649@thunk.org> <m3vembnlwz.fsf@bzzz.home.net> <20061024041433.GB12506@havoc.gtf.org> <20061024135928.GB11034@melbourne.sgi.com> <20061024194416.GB16087@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Chinner <dgc@sgi.com>, Jeff Garzik <jeff@garzik.org>,
	Alex Tomas <alex@clusterfs.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:54473 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S1422791AbWJXXAX
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Oct 2006 19:00:23 -0400
To: Theodore Tso <tytso@mit.edu>
Content-Disposition: inline
In-Reply-To: <20061024194416.GB16087@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 24, 2006  15:44 -0400, Theodore Tso wrote:
> First of all, we would need a way of allowing userpsace to specify
> which blocks should be used in the preallocation.

Presumably it could do this in the same way it will be specifying
which blocks to relocate in the defragger - by passing an extent.
You would be required to pass the file offset for which to preallocate,
and optionally an extent for the on-disk allocation itself (if none is
supplied the kernel will allocate the best extent it can).

> Secondly, we would need a way of marking blocks as "preallocated but
> not pre-zeroed"; otherwise we would have to zero out all of the blocks
> in order to assure security (don't want userspace programs seeing the
> previous contents of the data blocks), only to do the copy and the
> extents vector swap.

This could be mitigated by having the preallocation be done (in the
defragment case) against a temporary inode in the orphan list (as
the initial patch did) so if there is a crash it will be released.
The temporary inode will not be linked into the namespace so it cannot
be read - only used to hold preallocation.  If this was a write-only
file handle then we should be OK?

For defragger purposes this would need:

- "allocate new temporary inode" (VFS + fs, returns write-only fh if
   fs can't properly handle uninitalized extents, or doesn't request
   full-extent zeroing)

   for each extent to defragment {
	- "preallocate extents on temp inode" (fs specific internals)
	- "copy data from orig to temp at offset X" (VFS, splice or
	   e.g. sys_copyfile(src, dst, offset, count) which Linus agreed
	   to at KS '05 for network filesystems)
	- "migrate copied extent to original inode" (fs specific internals)
   }

- "free temporary inode" (just close of temp fh, frees unmigrated extents).

I don't think this is much more work than implementing all of this
functionality as part of a monolithic online defrag function, assuming
we don't require full-file copies in order to do defrag.

> (For example, you'd never be able to do this with the FAT filesystem,
> or the ext2 or ext3 filesystems; it would work for ext4 only *after*
> we implement the above mentioned new features and the associated
> filesystem format changes.)

Well, ext4 already has stub support for "allocated but uninitialized"
extents.  But regardless, I think if we structure the operations as
above we don't need to do very much crazy stuff.  It just boils down
to exposing some fs internals (create open-unlink inode, block allocation
with sanity check if on-disk extents are given) via new userspace methods,
and one new bit of code (extent migration with sanity check).

Virtually all of the VFS bits are generally useful and it doesn't require
any funky ability on the part of the filesystem in order to work.  We
don't need this to be super performant, so it can do as much locking &
page flushing as it needs to get things correct.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
