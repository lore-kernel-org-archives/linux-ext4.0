From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Design alternatives for fragments/file tail support in ext4
Date: Wed, 11 Oct 2006 09:55:57 -0400
Message-ID: <E1GXeYv-0006rP-RV@candygram.thunk.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:25731 "EHLO thunker.thunk.org")
	by vger.kernel.org with ESMTP id S1161060AbWJKN4B (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Oct 2006 09:56:01 -0400
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Some of the new on-disk format changes are chewing up some of the inode
fields that had been previously reserved for fragments, which has
started me thinking about whether this would box us in if we ever wanted
to implement extents --- for example, if we start seeing 64k blocksize
filesystems and still want to make it be useful for a general purpose
filesystem without wasting a huge amount of space to internal
fragmentation.

There have been a couple of different approaches that have been
suggested over the years, and I think it's worth thinking about some of
them again as we start the ext4 process, and see if we can do something
better.

But before we do this, it is useful to think about why we would want
larger blocks in the first place. 

1.  Make the indirect/double indrect block mapping scheme more
    efficient.   When the block size is increased, the need to go to
    double and triple indirect blocks is reduced in two ways; first, the
    number of block pointers in an indirect block is increased; second
    the amount of data addressed by a block pointer is increased.
    Hence, an indirect block for filesystem with a 16k block size can
    address 256 times as much data as an indirect block for a filesystem
    using 1k blocks.   

2.  Increase the ability to be able to read from the disk in contiguous
    reads and writes.   Modern disks use internal cluster sizes of 32k
    and up at this point.  Hence, allocating blocks in 32k chunks at a
    time is extremely helpful.

3.  Make the block allocation bitmap more efficient.  By using a larger
    blocksize, the number of block groups required decreases, and the
    amount of overhead to maintain the block allocation bitmaps per
    kilobyte of data is decreased.

Extents, when implemented, making the first reason for wanting to
implement fragments go away, assuming that we keep block sizes
relatively small (i.e., 4k or smaller).  They also mostly help reduce
the motivation for the second reason, although there are problably
changes we should make to our allocation algorithms that would improve
this.  (More later on this point).   However, the 3rd point might still
be a motivation for implementing fragments, if they are relatively cheap
to implement.

So given that, let's look at the various solutions in more detail:

	* Storing the tail as an extended attribute
	* Tail merging
	* BSD FFS/UFS fragments
	* Block allocation clusters

Storing the tail as an extended attribute
=========================================

Stephen and I have discussed this in the past, and the idea is a simple
one; simply store the tail as an extended attribute.  There are other
filesystems that have done this, most notably NTFS (post-Windows 2000).
However, this approach is a little unsatisfying to me, since it buys us
nothing if there are no other extended attributes contained by the
filesystem, and if we are using large inodes to accelerate extended
attributes, there won't be much space for any but the smallest tails
(i.e., if we are using 4k blocks, and 512 byte inodes, the largest tail
that we could store using this method is around 350 bytes or so.)

Using this technique would only require a flag in the inode indicating
it has a fragment, so the filesystem knows to look for the extended
attribute.  In theory this could also be done by checking the i_size
field, and assuming that last block in the file can never normally be a
hole, but this can be quite fragile.

Tail merging
============

Daniel Phillps had prototype code which implemented a form of tail
packing, which he called tail merging.  Details of his approach can be
found here:

http://www.mail-archive.com/linux-fsdevel@vger.rutgers.edu/msg01372.html

The quick summary of his approach, however, is that he uses all six
bytes in the inodes relating to fragments (i_faddr, l_i_frag, l_i_fsize)
to maintain a doubly linked list (using 16-bit signed offsets of the
inod number) of all of the inodes utiling the same tail block, and 16
bit offset into the shared-tail block.  The i_size field used to
determine which block is the last block, as well as the size of the
fragment stored in the shared-tail block.  

In order to determine which portions of the shared-tail block are in use
and which are free, the filesystem code must walk through the entire
linked list to map out which portions of the block are in use.  The
kernel caches this information, as well as the location of some number
of incompletely filled tailed blocks and one of the inodes to locate the
"merge" ring.  

Daniel had prototype code implemented against ext2 in mid 2000, but this
approach never got integrated because it had a number of shortcomings:

	* It was very complicated to map out the free portions of the
          tail block.  This complexity was an issue both for
          understanding and merging the code, as well as trying to make
          it play nice with ext3's journaling.
	* There was no good way to find partially merged tail blocks
          after the filesystem is freshly mounted.

Still, if one accepts the fact that the empty space in shared-tailed
blocks will likely not be reused after the filesystem is unmounted,
without either (a) opportunistically finding shared blocks when an inode
containing one of the shared tails is referenced, or (b) some kind of
brute force searching scheme, the solution is workable.

BSD FFS/UFS Fragments
=====================

This scheme is (as far as I know) not necessarily well understood by the
ext3/4 development community.  It is fairly elegant, although it has
some shortcomings which I will discuss below.

In the BSD Fast filesystem, where we would use a block number, the
FFS/UFS uses a "filesystem address" instead.  The filesystem address is
effectively a fragment number, referenced in fragment size chunks.  This
means that if you are using a 512 byte fragment size, and 32-bit
filesystem addresses (as is the case with UFS1; UFS2 uses 64-bit
filesystem addresses), the maximum filesystem volume size is 2**32 *
512, or 2TB.  (In fact the maximum advertised volume size for UFS1 is
1TB, so I assume they had some signed vs unsigned issues like we did
with ext3.)  

The allocation bitmap for the UFS is also stored in terms of fragments.
However, allocations are done a block at a time, and in a block-aligned
fashion.  In addition, indirect blocks are also a full block.  So for
example, on a filesystem with 4k blocks and 512 byte fragments, most
bytes in the allocation map would be either 0xFF or 0x00, corresponding
to a fully used or unused block.  In their i_blocks[] array, all blocks
except for the last block (which could be a fragment) would be stored
using filesystem addresses based on 512 byte sector number that would
always be a multiple of 8, since they must be stored on a block-aligned
boundary.  The last block, if a fragment, might not be a multiple of 8,
and the i_blocks field (which is always measured in 512 byte units)
could be used to indicate how much of the last block was in use by that
inode.

This solution could be easily implemented by us; although if we were to
do so, we would have to change the definition of i_blocks to always be
based on the fragment size, instead of basing it on the block size, as
currently proposed by EXT4_FEATURE_RO_COMPAT_HUGE_FILE.   Since current
ext3/4 filesystems have the fragment size == the block size, this would
not be difficult.   This scheme also means that none of the i_faddr,
l_iu_frag, or l_i_fsize fields are necessary.

Downsides of this scheme?  To the extent that we use a smaller fragment
size, we limit the maximum size of files and filesystem volumes.  In
addition, it is quite wasteful of space in the allocation bitmap, since
a bit is used for each fragment-sized chunk of space on disk, even
though most blocks are allocated a full block at a time.

Block allocation clusters
=========================

Is not strictly speaking a fragmentation solution, but if we assume that
extents takes care of the indirect block efficiency concern, and if we
assume that we're not too worried about the efficiency of the block
allocation bitmap, then perhaps a solution which only affects our
allocation algorithm would be sufficient combined with the extents
solution.  This solution also has the benefit that it (without extents)
it is backwards compatible with existing ext3 filesystem, as it only
changes the allocation algorithm.

The basic idea is that we store in the superblock the size of a block
allocation cluster, and that we change the allocation algorithm and the
preallocation code to always try to allocate blocks so that whenever
possible, an inode will use contiguous clusters of blocks, which are
aligned in multiples of the cluster size.   

So for example, suppose we are using a 4k filesystem with a 64k cluster
size, so there are 16 blocks in an allocation cluster.  The allocation
algorithm will try very hard so that logical block numbers
0,16,32,48,64, etc. of each inode gets a block number which is a
multiple of 16, so that logical blocks 0-15 will usually be contiguous,
and logical blocks 16-31 are usually contiguous, etc.  Block
reservations (aka preallocation) can help to enforce this, but even
without using the reservation tree, by simply changing the allocation
algorithm to preferentially use clusters of 16 blocks which are free,
and clusters which are partially in use if there are no clusters that
are completely free, we can substantially improve the block layout to
improve extents efficiency as well as data transfer efficiency.

Does this have a downside?  Yes; unless we have special case code when
doing delayed allocation so that the "tail" --- where in this case the
tail is whatever portion of the file doesn't fit in a full cluster ---
is packed with other partially used clusters, this scheme can in the end
have even worse fragmentation issues once the filesystem starts getting
full.  However, since we need delayed allocation for extents anyway, we
can simply encode this requirement into the delayed allocation scheme.

Conclusion
==========

If we are to implement extents for ext4, given that we are already
implementing extents, I believe the best approach is either the BSD
Fragements scheme, or the block allocation clusters scheme.   The
advantage of the BSD Fragments scheme is that it allows the block
bitmaps to be more efficient for very large files; but at the cost of
requiring us to go to 64-bit filesystem addresses much more quickly, and
more complexity in handling the final file tail/fragment.

The block cluster scheme has the advantage that it is much simpler to
implement (just changes to the block allocation code), but it does
require that delayed allocation be also implemented, and it means that
the block allocation bitmaps have to get touched more frequently, since
the block size remains at the current 4k size.  It also had the
advantage that it doesn't require that complexities and VM changes
necessary to support filesystem block sizes which are greater than the
page size.  

Since currently both the x86 and x86_64 use 4k page sizes, and the ia64
system seems stuck as a niche market, using larger block sizes such as
16k or 64k is highly problematic for the dominant architecture(s) in the
market.  Hence, until the VM has the capability of supporting 64k block
sizes on systems with 4k page sizes, it is very unlikely many people
would use the large blocksize changes and enhancements to the
filesystem.  So the block cluster scheme is much more likely to be
immediately useful to the ext4 user community.

Finally, note that implementation of block clusters does not foreclose
implementation of the BSD fragments scheme.  However, it would probably
only be of interest to a company who is highly invested in the Intanium
architecture, at least in the short term.


Comments?

						- Ted

