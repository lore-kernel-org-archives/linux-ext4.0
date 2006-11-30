From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC][PATCH 0/4] BIG_BG: support of large block groups
Date: Thu, 30 Nov 2006 14:41:02 -0500
Message-ID: <20061130194102.GA10999@thunk.org>
References: <1164386860.17961.67.camel@ckrm> <20061129172318.GD5771@thunk.org> <456EF615.1090205@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:5048 "EHLO thunker.thunk.org")
	by vger.kernel.org with ESMTP id S1031278AbWK3TlF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Nov 2006 14:41:05 -0500
To: Valerie Clement <valerie.clement@bull.net>
Content-Disposition: inline
In-Reply-To: <456EF615.1090205@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Nov 30, 2006 at 04:17:41PM +0100, Valerie Clement wrote:
> In fact, there is another limitation related to the block group size:
> all the group descriptors are stored in the first group of the filesystem.
> Currently, with a 4-KB block size, the maximum size of a group is
> 2**15 blocks = 2**27 bytes.
> With a group descriptor size of 32 bytes, we can store a maximum of
> 2**32 / 32 = 2**22 group descriptors in the first group.
> So the maximum number of groups is limited to 2**22 which limits the 
> size of the filesystem to
> 2**22(groups) * 2**15(blocks) * 2**12(blocksize) = 2**49 bytes = 512TB

Hmm, yes.  Good point.  Thanks for pointing that out.  In fact, with
the 64-bit patches, the block group descriptor size becomes 64 bytes
long, which means we can only have 2*21 groups, which means 2**48
bytes, or 256TB.

There is one other problem with big block groups which I had forgotten
to mention in my last note.  As we grow the size of the big block
group, it means that we increase the number of contiguous blocks
required for block and inode allocation bitmaps.  If we use the
smallest possible block group size to support a given filesystem, then
for a 1 Petabyte filesystem (using a 128k blocks/group), we will need
4 contiguous blocks for the block and inode allocation bitmaps, and
for an Exabyte (2**60) filesystem we would need 4096 contiguous bitmap
blocks.  The problem with requiring this many contiguous blocks is
that it makes the filesystem less robust in the face of bad blocks
appearing in the middle of a block group, or in the face of filesystem
corruptions where it becomes necessary to relocate the bitmap blocks.
(For example, if the block allocation bitmap gets damaged and data
blocks get allocated into bitmap blocks.)  Finding even 4 contiguous
blocks can be quite difficult, especially if you are constrained to
find them within the current block group.

Even if we relax this constraint for ext4 (and I believe we should),
it is not always guaranteed that it is possible to find a large number
of contiguous free blocks.  And if we can't then e2fsck will not be
able to repair the filesystem, leaving the user dead in the water.

What are potential solutions to this issue?

* We could add two per-block group flags indicating whether the block
bitmap and inode bitmap are stored contiguously, or whether the block
number points to an indirect or doubly-indirect block (depending on
what is necessary to store the bitmap information).

* We could use the bitmap block address as the root of a b-tree
containing the allocation information --- at the cost of adding some
XFS-like complexity. 

* We ignore the problem, and accept that there are some kinds of
filesystem corruptions which e2fsck will not be able to fix --- or at
least not without adding complexity which would allow it to relocate
data blocks in order to make a contiguous range of blocks to be used
for the allocation bitmaps.  

The last alternative sounds horrible, but if we assume that some other
layer (i.e., the hard drive's bad block replacement pool) provides us
the illusion of a flawless storage media, and CRC to protect metadata
will prevent us from relying on an corrupted bitmap block, maybe it is
acceptable that e2fsck may not be able to fix certain types of
filesystem corruption.  In that case, though, for laptop drives
without any of these protections, I'd want to keep the block group
size under 32k so we can avoid dealing with these issues for as long
as possible.  Even if we assume laptop drives will double in size
every 12 months, we still have a good 10+ years before we're in danger
of seeing a 512TB laptop drives.  :-)


Yet another solution that we could consider besides supporting larger
block groups would be to increase the block size.  The downside of
this solution is that we would have to fix the VM helper functions
(i.e., the file_map functions, et. al) to allow supporting filesystems
where the blocksize > page size, and of course it will increase
fragmentation cost for small files.  But for certain partitions which
are dedicated for video files, using a larger block size could also
improve data I/O efficiency, as well as decreasing the overhead
necessary caused by needing to update the block allocation bitmaps as
a file is extended.

As always, filesystem design is full of tradeoffs....

							- Ted
