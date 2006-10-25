From: David Chinner <dgc@sgi.com>
Subject: Re: [RFC] Ext3 online defrag
Date: Wed, 25 Oct 2006 12:09:27 +1000
Message-ID: <20061025020927.GS8394166@melbourne.sgi.com>
References: <20061023122710.GA12034@atrey.karlin.mff.cuni.cz> <20061023141641.GA29649@thunk.org> <m3vembnlwz.fsf@bzzz.home.net> <20061024041433.GB12506@havoc.gtf.org> <20061024135928.GB11034@melbourne.sgi.com> <20061024194416.GB16087@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Chinner <dgc@sgi.com>, Jeff Garzik <jeff@garzik.org>,
	Alex Tomas <alex@clusterfs.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:43175 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1422867AbWJYCJ7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Oct 2006 22:09:59 -0400
To: Theodore Tso <tytso@mit.edu>
Content-Disposition: inline
In-Reply-To: <20061024194416.GB16087@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Oct 24, 2006 at 03:44:16PM -0400, Theodore Tso wrote:
> On Tue, Oct 24, 2006 at 11:59:28PM +1000, David Chinner wrote:
> > That's the wrong way to look at it. if you want the userspace
> > process to specify a location, then you should preallocate it first
> > before doing anything else. There is no need to clutter a simple
> > data mover interface with all sorts of unnecessary error handling.
> 
> This is doable, but it adds a huge amount of complexity before we
> could implement on-line defragmentation.
> 
> First of all, we would need a way of allowing userpsace to specify
> which blocks should be used in the preallocation.

Not initially. Create a file, and call posix_fallocate() on it.
Later, the filesystem can provide something that the defrag tool can
use for fine-grained control of where the preallocated blocks are on
disk.

> Secondly, we would need a way of marking blocks as "preallocated but
> not pre-zeroed"; otherwise we would have to zero out all of the blocks
> in order to assure security (don't want userspace programs seeing the
> previous contents of the data blocks), only to do the copy and the
> extents vector swap.

The unlinked inode method avoids this problem because no user space
process can see the inode to open it. Also, posix_fallocate() zeroes
the disk blocks so even this protects against data exposure.

So, now all that remains for an initial implementation is the swap
extents transaction and the data mover syscall.

For a smart, fast implementation, I agree that you need unwritten
extents (which XFS already has), then a fast filesystem
implementation of posix_fallocate() that utilises unwritten extents
(which XFS already has), and finally another interface that allows
you to allocate unwritten extents in an arbitrary location within
the filesystem (which no filesystem currently has).

> That's a huge amount of work, and while the above two features can be
> useful for other things, it's not clear it's worth it to require this
> as the only way to implement on-line defragging.  You're right that
> it's a way of making things be more generic, but it means that each
> filesystem needs to have a huge amount of additional complexity and
> potential filesystem format changes before they could take advantage
> of this general framework.  

I disagree - it's not a huge amount of work to get some thing
working and to solidify the generic interfaces and only format
change is a new transaction. Any filesystem that supports the swap
extent/blocks method would then work better than XFs's current
online defrag tool which currently does not use preallocation,
nor does it use splice.....

> (For example, you'd never be able to do this with the FAT filesystem,
> or the ext2 or ext3 filesystems; it would work for ext4 only *after*
> we implement the above mentioned new features and the associated
> filesystem format changes.)

Sure, but they can use the slow, unoptimised posix_fallocate() method
for allocating disk space....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
