From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 6/6] ext4: Dynamically allocate the jbd2_inode in
 ext4_inode_info as necessary
Date: Wed, 5 Jan 2011 15:21:03 -0500
Message-ID: <20110105202103.GM2959@thunk.org>
References: <1294189270-16733-1-git-send-email-tytso@mit.edu>
 <1294189270-16733-7-git-send-email-tytso@mit.edu>
 <A562E0CA-9CA6-4654-8FCB-9849F6EB09E7@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:54542 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683Ab1AEUVH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Jan 2011 15:21:07 -0500
Content-Disposition: inline
In-Reply-To: <A562E0CA-9CA6-4654-8FCB-9849F6EB09E7@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 05, 2011 at 12:26:33PM -0700, Andreas Dilger wrote:
> 
> How does this change impact the majority of users that are running
> with a journal?  It is clearly a win for a small percentage of users
> with no-journal mode, but it may be a net increase in memory usage
> for the majority of the users (with journal).  There will now be two
> allocations for every inode, and the extra packing these allocations
> into slabs will increase memory usage for an inode, and would
> definitely result in more allocation/freeing overhead.
> 
> The main question is how many files are ever opened for write?

Even if we do two allocations for every inode (not just inodes opened
for write), it's a win simply because moving the jinode out the
ext4_inode_info structure shrinks it sufficiently that we can now pack
18 inodes in a 16k slab on x86_64.  It turns out that the slab
allocator is pretty inefficient at large data structures, and smaller
data structures (such as the jbd2_inode structure) it handles much
more efficiently, in terms of wasted memory.

> It
> isn't just the number of currently-open files for write, because the
> jinfo isn't released until the inode is cleared from memory.  While
> I suspect that most inodes in cache are never opened for write, it
> would be worthwhile to compare the ext4_inode_cache object count
> against the jbd2_inode object count, and see how the total memory
> compares to a before-patch system running different workloads (with
> journal).

Sure.  It should be possible to release jinfo when the file is
completely closed, in ext4_release_file.  That would reduce the memory
footprint significantly.  I hadn't bothered with it too badly because
the jbd2_inode structure is only 48 bytes, and you can fit 85 of them
on a 4k page with only 16 bytes getting wasted.  But it's fair that we
release jinode once the inode is no longer used by any file descriptors.


I'll make the the other changes you suggested; thanks!!

							- Ted
