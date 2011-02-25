From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Proposed design for big allocation blocks for ext4
Date: Fri, 25 Feb 2011 01:21:58 -0700
Message-ID: <1F9A85BD-4B5E-488C-B903-0AE17AACF2B7@dilger.ca>
References: <E1PsnrK-0005r5-JH@tytso-glaptop>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:58270 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085Ab1BYIV7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Feb 2011 03:21:59 -0500
In-Reply-To: <E1PsnrK-0005r5-JH@tytso-glaptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-02-24, at 7:56 PM, Theodore Ts'o wrote:
> = Problem statement = 
> 
> If the vast majority of the files are large, and the system is running
> under tight memory pressure, such that the block allocation bitmaps
> and buddy bitmaps are frequently getting evicted from the system, if
> the filesystem's free space is moderately fragmented, file allocations
> and unlinks may require reading multiple block bitmaps into memory,
> and this can be a surprisingly large amount of overhead, since the
> reading the various block bitmaps is a synchronous operation that
> tends to involve a large number of seeks.
> 
> One way of solving this problem is to use a large block size than 4k
> --- say, perhaps 256k or 1 megabyte.  By reducing the number of blocks
> needed to allocate the same file, and at the same time increasing the
> amount of storage that can be covered by a block allocation bitmap, we
> can address this problem, at the cost of increased internal
> fragmentation.  However Linux has a fundamental assumption that the
> page size is >= the file system block size.
> 
> So the goal is to design a system that allows us to get the benefits
> of larger block sizes without the complexities caused by large block
> sizes.

Hmm, interesting.  This could be useful for Lustre installations, since the majority of installations are using large files, and a 1MB allocation blocksize would align very nicely with the 1MB Lustre RPC size...

I guess one minor drawback of this implementation is that it isn't quite identical to the case where there actually IS a larger blocksize (whether due to larger PAGE_SIZE, or kernel support in software for blocksize > PAGE_SIZE.

I suppose the changes that would be needed to emulate real large blocks to map multiple pages to the same block number (with different offsets within the block) would just cause the VM and block layer to explode.  page->index would still be in units of PAGE_SIZE, but bh->b_blocknr would be the same for two consecutive pages without major block layer surgery.

> = Constraints =
> 
> We want to keep the changes to the ext4 code base small and easily
> testable.  Ideally, no changes to the core kernel should be required.
> What follows from this is a requirement that the fundamental block
> size (as far as the VM is concerned) must remain at 4k.
> 
> = Design =
> 
> The solution to this problem is to use an increased allocation size as
> far as the block allocaiton bitmaps are concerned.  However, the size
> of allocation bitmaps, and the granularity of blocks as far as the the
> extent tree blocks are concerned, are still based on the original
> maximum 4k block size.
> 
> We assume the fields previously used for defining the fragment size in
> the ext4 superblock: s_log_frag_size and redefine it to be
> s_log_alloc_size.  This defines a size, the allocation blocksize.  The
> allocation blocksize is only enabled if a new INCOMPAT feature is
> defined, EXT4_FEATURE_INCOMPAT_BIGALLOC, and it must be greater than
> or equal to the block size.

Fortunately, "s_log_alloc_size" currently contains the blocksize so this should be completely compatible with current filesystems, in that we can change the allocation code to always use s_log_alloc_size regardless of whether INCOMPAT_BIGALLOC is set or not.

> The allocation blocksize controls the allocation granularity of a bit
> in the block bitmap.  However, the maximum size of a block bitmap
> remains a single block size.  Hence, for a file system with a 4k block
> size and a 1 megabyte allocation blocksize, there can be a maximum of
> 32,768 (4k * 8) allocation blocks, and so a single block group can now
> cover a maximum of 32GiB.

Hmm, so does this change impact the 32-bit block number limit?  It seems like it wouldn't, since the underlying blocks are still addressed using 4kB blocksize.  The only difference is that each bit in the block bitmap covers, say, 256 * 4kB blocks and that is the minimum granularity of allocations.

I guess one would need to be careful with the inode ratio, since the number of inodes per group is still only 32k or less.  This implies that the allocation blocksize should not be larger than the inode ratio (i.e. the average file size) otherwise there will not be enough inodes to allocate 1 allocation block per inode.

> To minimize changes to ext4, we will constrain an allocation block such
> that it must contain only fixed file system metadata (i.e., block
> bitmaps, inode bitmaps, and inode table) or data blocks belonging to a
> single inode.  Furthermore, if allocation block is to be used for data
> blocks for an inode, it must be used contiguously starting at a file
> offset which is a multiple of the allocation blocksize.  The first
> block of the allocation block must be mapped in the extent tree (or
> indirect block), so that the ext4_map_blocks() can easily find (and
> continue using) partially used allocation block.

For files with holes, does this mean that e.g. a sparse file with 4 data ranges of 256kB each, in a filesystem with 1MB allocation blocks would use 4*1MB of space in the filesystem, or could the sparse ranges be allocated from within a single 1MB allocation block?  The easier and more straight forward implementation would imply 4*1MB blocks are consumed (i.e. identical to the case where there are really 1MB blocks), even though it would waste more space.

> Because we are not changing the definition of a block, the only
> changes that need to be made are at the intersection of allocating to
> an inode (or to file system metadata).  This is good, because it means
> the bulk of ext4 does not need to be changed
> 
> 
> = Kernel Changes required =
> 
> 1) Globally throughout ext4: uses of EXT4_BLOCKS_PER_GROUP() need to
> be audited to see if they should be EXT4_BLOCKS_PER_GROUP() or
> EXT4_ALLOC_BLOCKS_PER_GROUP().
> 
> 2) ext4_map_blocks() and its downstream functions need to be changed so
> that they understand the new allocation rules, and in particular
> understand that before allocating a new block, they need to see if a
> partially allocated block has already been allocated, and can be used
> to fulfill the current allocation.
> 
> 3) mballoc.c will need little or no changes, other than the
> EXT4_BLOCKS_PER_GROUP()/EXT4_ALLOC_BLOCKS_PER_GROUP() audit discussed
> in (1).

I'm particularly interested in what happens with directories?  Some data structures like ext2_dirent_2.rec_len can only handle a blocksize of 256kB, even with the hack to use the low 2 bits of rec_len to store the MSB of the actual length.

Would directories be affected at all, since the underlying blocksize is still 4kB?

> = E2fsprogs changes required =
> 
> # Changes to dumpe2fs, debugfs, etc., to understand the new
> superblock field.
> 
> # Changes to mke2fs to understand how to allocate the inode, block,
> and inode table metadata blocks.

Presumably, it would always make sense to consume an entire allocation block with metadata...  Inodes in the itable would fill up the whole allocation block, or the rest of the space would be wasted.

Would there be a requirement that the flex_bg factor is >= the allocation blocksize, so that e.g. block bitmaps fill an entire allocation block, or will it be possible to mix & match metadata within an allocation block?

> # Changes to e2fsck pass1 and pass 1b/c/d to understand that a single
> allocation block can be shared across multiple file system metadata
> blocks or a file's data blocks.  (But the fact that allocation block
> can be used contiguously vis-a-vis an inode's logical block space will
> make these changes relatively straightforwarwd.)
> 
> = Upsides =
> 
> Block allocation and deallocation for large files should be much
> faster, since a block bitmap will cover much more space, and it is
> much less likely that a single file system operation will need to
> touch multiple block bitmaps.
> 
> Using a larger allocation blocksize will also reduce external
> fragmentation.  By reducing the free space fragmentation, when files
> are written (and later read) seeking between data blocks will be
> greatly reduced.

In essence, this is mostly just an optimization of the mballoc code to be able to allocate large chunks more quickly (i.e. equivalent to being able to get/set tens or hundreds of bits at a time).  I don't think it is actually fundamentally different than just changing the mballoc code to actually get/set these tens/hundreds of bits at one time, or doing some kind of "bitmap compression" whereby it loads the block bitmap into memory and only saves the top levels of the buddy bitmap to reduce the memory used by some power-of-two factor.  That could all be done in software without changing the on-disk format.

The only significant difference in the end is that it saves on reading/writing the block bitmaps, though if they are stored compressed in memory and contiguous on disk with flex_bg that may not even be a significant difference.

I think the fundamental flaws of the current mballoc code will still be present, in that it does linear scanning of the groups in order to find free space.  I think we'd be better off to improve mballoc to have a more holistic approach to allocation.  For example, having a top-level buddy-bitmap or tree that shows where the most free space is in a filesystem would be a big win in reducing search times for free blocks.

> Directory blocks will be contiguous, which will speed up situations
> where a directory is very, very large.

This is no different than having a tuneable to always preallocate the directory blocks.  IMHO, the main factor affecting directory performance today is not the IO of reading the directory blocks, but rather the random access order of the inodes vs. readdir order (very few apps do pure readdir() operations).

> = Downsides =
> 
> Internal fragmentation will be expensive for small files.  So this is
> only useful for file systems where most files are large, or where the
> file system performance is more important than the losses caused by
> internal fragmentation.  

One interesting counter proposal would be to leave the on-disk format the same, use flex_bg == allocation size to reduce the seek overhead, and only store in memory the top levels of the block bitmaps - for _most_ groups but not necessarily all groups.  For example, with an allocation blocksize of 1MB, the block/buddy bitmap would store in memory 1 bit per 256 blocks on disk, so most flex_bgs (= 256 groups) could conveniently store the whole block bitmap in 4kB of RAM and read/write those bitmaps in a single seek/IO.

Allocations from these groups would be at a 1MB granularity, so there is no difference in fragmentation from your proposal.  Files allocated in this way would have the EXT4_EOFBLOCKS_FL set, and all of the blocks up to the 1MB boundary would actually be allocated by the file.  It would require set/clear of 256 bits == 32 bytes at a time on disk, so the shadow copy of modified block bitmaps in the journal would be generated on-the-fly from the compressed in-memory bitmap.  Optionally, only the modified disk block bitmaps would need to be written to the journal, to avoid unnecessary IO expansion though this may not be a net win on a RAID system that needs to do stripe-aligned IO anyway.

Essentially, the groups would be split up into "1MB allocation slabs" and "4kB allocation slabs", and/or possibly sizes in-between.  It would be possible to store the "slab size" in the group descriptor for each group, and possibly migrate between different slab sizes using online defragmentation to move unaligned files.  If only compliant ext4 code writes to such a filesystem, then there is no chance of unaligned/fragmented allocations in the slabs.  It would even be possible to have migrate an existing filesystem to using this scheme (possibly using e4defrag to empty out some groups), if there was enough free space.

A major upside of this is that some groups could store the full-resolution bitmap in memory and still do 4kB-granular allocations, which would be great for small files, directories, and index blocks.  We might want to segregate the file data blocks into separate slabs/groups from the index/directory blocks, to speed up e2fsck by keeping the metadata dense and separate from the data.  This would also be ideal for having hybrid SSD/HDD layouts, with metadata and/or small files on RAID-1 SSD slabs, and large file data on RAID-6 HDD slabs.

This is the same as the VM implementation of hugepages, which segregates chunks of memory for large or small, and persistent vs. ephemeral memory allocations.  AFAIK, that has shown to work pretty well over time.

This would need to be at worst a ROCOMPAT feature, since all that is needed is to store the "slab size" for new allocations in the group descriptor (possibly only a few bits in the bg_flags field in log-log format (0=1*blocksize, 1=16*blocksize, 2=256 * blocksize, 3=(1 << s_log_groups_per_flex) * blocksize).

A simple forward compatible extension for "maint" kernels to be able to r/w mount a filesystem with this ROCOMPAT feature would be to clear the slab size in a group descriptor when allocating new blocks there, since freeing blocks will not affect the slab size.  No other visible difference would exist in the on-disk layout.

> Directories will also be allocated in chucks of the allocation block
> size.  If this is especially large (such as 1 MiB), and there are a
> large number of directories, this could be quite expensive.
> Applications which use multi-level directory schemes to keep
> directories small to optimize for ext2's very slow large directory
> performance could be especially vulnerable.

Cheers, Andreas





