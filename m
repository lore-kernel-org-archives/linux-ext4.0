From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Proposed design for big allocation blocks for ext4
Date: Thu, 24 Feb 2011 21:56:46 -0500
Message-ID: <E1PsnrK-0005r5-JH@tytso-glaptop>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50092 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754446Ab1BYC4s (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Feb 2011 21:56:48 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


I've had problems creating new pages on the ext4 wiki, so I haven't been
able to post it there.  I'm waiting for the kernel.org admins to fix it,
but until they do, I'll just send it to the ext4 list for comments.

        	       	   	     	  - Ted


= Problem statement = 

If the vast majority of the files are large, and the system is running
under tight memory pressure, such that the block allocation bitmaps
and buddy bitmaps are frequently getting evicted from the system, if
the filesystem's free space is moderately fragmented, file allocations
and unlinks may require reading multiple block bitmaps into memory,
and this can be a surprisingly large amount of overhead, since the
reading the various block bitmaps is a synchronous operation that
tends to involve a large number of seeks.

One way of solving this problem is to use a large block size than 4k
--- say, perhaps 256k or 1 megabyte.  By reducing the number of blocks
needed to allocate the same file, and at the same time increasing the
amount of storage that can be covered by a block allocation bitmap, we
can address this problem, at the cost of increased internal
fragmentation.  However Linux has a fundamental assumption that the
page size is >= the file system block size.

So the goal is to design a system that allows us to get the benefits
of larger block sizes without the complexities caused by large block
sizes.

= Constraints =

We want to keep the changes to the ext4 code base small and easily
testable.  Ideally, no changes to the core kernel should be required.
What follows from this is a requirement that the fundamental block
size (as far as the VM is concerned) must remain at 4k.

= Design =

The solution to this problem is to use an increased allocation size as
far as the block allocaiton bitmaps are concerned.  However, the size
of allocation bitmaps, and the granularity of blocks as far as the the
extent tree blocks are concerned, are still based on the original
maximum 4k block size.

We assume the fields previously used for defining the fragment size in
the ext4 superblock: s_log_frag_size and redefine it to be
s_log_alloc_size.  This defines a size, the allocation blocksize.  The
allocation blocksize is only enabled if a new INCOMPAT feature is
defined, EXT4_FEATURE_INCOMPAT_BIGALLOC, and it must be greater than
or equal to the block size.

The allocation blocksize controls the allocation granularity of a bit
in the block bitmap.  However, the maximum size of a block bitmap
remains a single block size.  Hence, for a file system with a 4k block
size and a 1 megabyte allocation blocksize, there can be a maximum of
32,768 (4k * 8) allocation blocks, and so a single block group can now
cover a maximum of 32GiB.

To minimize changes to ext4, we will constrain an allocation block such
that it must contain only fixed file system metadata (i.e., block
bitmaps, inode bitmaps, and inode table) or data blocks belonging to a
single inode.  Furthermore, if allocation block is to be used for data
blocks for an inode, it must be used contiguously starting at a file
offset which is a multiple of the allocation blocksize.  The first
block of the allocation block must be mapped in the extent tree (or
indirect block), so that the ext4_map_blocks() can easily find (and
continue using) partially used allocation block.

Because we are not changing the definition of a block, the only
changes that need to be made are at the intersection of allocating to
an inode (or to file system metadata).  This is good, because it means
the bulk of ext4 does not need to be changed


= Kernel Changes required =

1) Globally throughout ext4: uses of EXT4_BLOCKS_PER_GROUP() need to
be audited to see if they should be EXT4_BLOCKS_PER_GROUP() or
EXT4_ALLOC_BLOCKS_PER_GROUP().

2) ext4_map_blocks() and its downstream functions need to be changed so
that they understand the new allocation rules, and in particular
understand that before allocating a new block, they need to see if a
partially allocated block has already been allocated, and can be used
to fulfill the current allocation.

3) mballoc.c will need little or no changes, other than the
EXT4_BLOCKS_PER_GROUP()/EXT4_ALLOC_BLOCKS_PER_GROUP() audit discussed
in (1).

= E2fsprogs changes required =

# Changes to dumpe2fs, debugfs, etc., to understand the new
superblock field.

# Changes to mke2fs to understand how to allocate the inode, block,
and inode table metadata blocks.

# Changes to e2fsck pass1 and pass 1b/c/d to understand that a single
allocation block can be shared across multiple file system metadata
blocks or a file's data blocks.  (But the fact that allocation block
can be used contiguously vis-a-vis an inode's logical block space will
make these changes relatively straightforwarwd.)

= Upsides =

Block allocation and deallocation for large files should be much
faster, since a block bitmap will cover much more space, and it is
much less likely that a single file system operation will need to
touch multiple block bitmaps.

Using a larger allocation blocksize will also reduce external
fragmentation.  By reducing the free space fragmentation, when files
are written (and later read) seeking between data blocks will be
greatly reduced.

Directory blocks will be contiguous, which will speed up situations
where a directory is very, very large.

= Downsides =

Internal fragmentation will be expensive for small files.  So this is
only useful for file systems where most files are large, or where the
file system performance is more important than the losses caused by
internal fragmentation.  

Directories will also be allocated in chucks of the allocation block
size.  If this is especially large (such as 1 MiB), and there are a
large number of directories, this could be quite expensive.
Applications which use multi-level directory schemes to keep
directories small to optimize for ext2's very slow large directory
performance could be especially vulnerable.

