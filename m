From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Proposed design for big allocation blocks for ext4
Date: Fri, 25 Feb 2011 07:57:04 -0500
Message-ID: <CE75B187-E5BB-444E-9256-4DBF96B6DCDA@mit.edu>
References: <E1PsnrK-0005r5-JH@tytso-glaptop> <1F9A85BD-4B5E-488C-B903-0AE17AACF2B7@dilger.ca>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:60010 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755192Ab1BYM5J convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Feb 2011 07:57:09 -0500
In-Reply-To: <1F9A85BD-4B5E-488C-B903-0AE17AACF2B7@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Feb 25, 2011, at 3:21 AM, Andreas Dilger wrote:

> I guess one would need to be careful with the inode ratio, since the number of inodes per group is still only 32k or less.  This implies that the allocation blocksize should not be larger than the inode ratio (i.e. the average file size) otherwise there will not be enough inodes to allocate 1 allocation block per inode.

Yes.  You would only want to do this on large data disks, where the average file size is large.   For example, in the target application I have in mind, the average file size might be 8 or 16 megabytes, and then I might use a 1M  allocation block size.

> 
>> To minimize changes to ext4, we will constrain an allocation block such
>> that it must contain only fixed file system metadata (i.e., block
>> bitmaps, inode bitmaps, and inode table) or data blocks belonging to a
>> single inode.  Furthermore, if allocation block is to be used for data
>> blocks for an inode, it must be used contiguously starting at a file
>> offset which is a multiple of the allocation blocksize.  The first
>> block of the allocation block must be mapped in the extent tree (or
>> indirect block), so that the ext4_map_blocks() can easily find (and
>> continue using) partially used allocation block.
> 
> For files with holes, does this mean that e.g. a sparse file with 4 data ranges of 256kB each, in a filesystem with 1MB allocation blocks would use 4*1MB of space in the filesystem, or could the sparse ranges be allocated from within a single 1MB allocation block?  The easier and more straight forward implementation would imply 4*1MB blocks are consumed (i.e. identical to the case where there are really 1MB blocks), even though it would waste more space.

It is identical to the case where there are really 1MB blocks.   That's why I said, "allocation bocks must be used contiguously starting at a file offset which is a multiple of the allocation block size".  This allows ext4_map_blocks to find a previously used allocation block by simply looking up what block was used at the beginning of the allocation block range.

> 
> I'm particularly interested in what happens with directories?  Some data structures like ext2_dirent_2.rec_len can only handle a blocksize of 256kB, even with the hack to use the low 2 bits of rec_len to store the MSB of the actual length.
> 
> Would directories be affected at all, since the underlying blocksize is still 4kB?

Directories don't change at all.

> 
>> = E2fsprogs changes required =
>> 
>> # Changes to dumpe2fs, debugfs, etc., to understand the new
>> superblock field.
>> 
>> # Changes to mke2fs to understand how to allocate the inode, block,
>> and inode table metadata blocks.
> 
> Presumably, it would always make sense to consume an entire allocation block with metadata...  Inodes in the itable would fill up the whole allocation block, or the rest of the space would be wasted.
> 
> Would there be a requirement that the flex_bg factor is >= the allocation blocksize, so that e.g. block bitmaps fill an entire allocation block, or will it be possible to mix & match metadata within an allocation block?

There will be so such *requirement*, although certain fs parameter tunings will make more sense than others.

One of the high order drivers of this design is that as we get bigger and bigger disks (i.e., the progression from 1T, 2T, 3T, 4T, etc. disks), we are effectively losing seek capacity because the the bigger disks mean we have fewer spindles at a given capacity level, even as the seek time stays more or less constant.   So if we waste 2-5% more space on metadata blocks because all of the metadata blocks in a flex_bg don't fit inside an allocation block, I'm not going to shed massive amounts of tears. 

> In essence, this is mostly just an optimization of the mballoc code to be able to allocate large chunks more quickly (i.e. equivalent to being able to get/set tens or hundreds of bits at a time).  I don't think it is actually fundamentally different than just changing the mballoc code to actually get/set these tens/hundreds of bits at one time, or doing some kind of "bitmap compression" whereby it loads the block bitmap into memory and only saves the top levels of the buddy bitmap to reduce the memory used by some power-of-two factor.  That could all be done in software without changing the on-disk format.

I actually initially got started on an approach where we did a "bitmap compression" scheme, so I've been down this path already.   The approach I was trying was to use an rbtree of free extents, but that doesn't make much difference to the fundamental problem which I saw, and that is that you still have to update the block allocation bitmaps in memory.    And if you are running in a memory constrained environment (either because you're a cheap... err, financially constrained NAS vendor, or because you're running in tight memory containers because you are trying to pack hundreds of jobs onto a single machine), the block bitmaps are getting constantly ejected from memory.

Furthermore, if you have 16 2T disks, the block bitmaps alone will consume a gigabyte of memory, so it's really not feasible to pin that much memory just to avoid the disk seeks to read/write the block bitmaps.   And of course the buddy bitmaps would consume another gigabyte, but even if you were to discard the buddy bitmaps after each allocation and recalculate them from the pinned block bitmaps, pinning a gigabyte of memory isn't really acceptable.

On the other hand, if you change the meaning of each bit in the block bitmap to mean 1M instead of 4k, the gigabyte of memory turns into 4MB (for the same 16 x 2T disks), which is much more reasonable.  It's more likely to stay cached in memory, and it's much more tractable to consider pinning that in memory.   And the buddy bitmaps also become much more efficient, since they would also only consume 4MB if fully populated in memory.

> I think the fundamental flaws of the current mballoc code will still be present, in that it does linear scanning of the groups in order to find free space.  I think we'd be better off to improve mballoc to have a more holistic approach to allocation.  For example, having a top-level buddy-bitmap or tree that shows where the most free space is in a filesystem would be a big win in reducing search times for free blocks.

We are already storing the largest free contiguous power of two free extent in each block group, which really helps with the linear scanning of groups, since it means we don't have to read in a block bitmap just to find that while it has a large amount of free space, it's not contiguous enough for our needs. 

Of course, one the file system's free space gets fragmented enough that _no_ block group has 1M of contiguous free space, trying to allocate space for an 8M file will involve a huge number of seeks as we read in each block bitmap, trying to get 256k of free space here, and another 256k of free space there, etc.

> One interesting counter proposal would be to leave the on-disk format the same, use flex_bg == allocation size to reduce the seek overhead, and only store in memory the top levels of the block bitmaps - for _most_ groups but not necessarily all groups.  For example, with an allocation blocksize of 1MB, the block/buddy bitmap would store in memory 1 bit per 256 blocks on disk, so most flex_bgs (= 256 groups) could conveniently store the whole block bitmap in 4kB of RAM and read/write those bitmaps in a single seek/IO.
> 
> Allocations from these groups would be at a 1MB granularity, so there is no difference in fragmentation from your proposal.  Files allocated in this way would have the EXT4_EOFBLOCKS_FL set, and all of the blocks up to the 1MB boundary would actually be allocated by the file.  It would require set/clear of 256 bits == 32 bytes at a time on disk, so the shadow copy of modified block bitmaps in the journal would be generated on-the-fly from the compressed in-memory bitmap.  Optionally, only the modified disk block bitmaps would need to be written to the journal, to avoid unnecessary IO expansion though this may not be a net win on a RAID system that needs to do stripe-aligned IO anyway.

No difference in file fragmentation, but without heavy modification to mballoc.c, the buddy bitmaps will still chew a huge amount of space.    And forgive me, but having tried to modify mballoc.c, it needs a lot of cleanup before it's easy to modify.   One of the reasons why I like my proposal is I don't have to touch mballoc.c much; there are lots of side effects in different functions, and the on-disk block bitmaps are assumed to be present and modified deep inside various call chains --- I don't think it would be that easy to make the sort of changes you are proposing.

So the main advantages of your proposal is that it gets you read-only compatibility instead of incompat, and the ability to more flexibly store small files/directories.

The disadvantages is that it doesn't address the memory inefficiency issue, and you still have to seek to update the block bitmaps; one of the extensions I have in mind for our no-journal mode is to simply pin the block bitmaps  in memory and only update the at umount time.   This is *not* trivial to do in mballoc.c today by just keeping the "high level" mballoc pages in memory, because mballoc assumes that you always have access to the on-disk bitmap, and there are times when the mballoc buddy bitmaps and the on-disk buddy bitmaps are allowed to be out of sync to provide locking guarantees.   It's not so simple to just wave a magic wand and say, "we will only update the buddy bitmaps!", because of this implicit assumption in parts of mballoc.c that the on-disk buddy bitmap is available to
  it.

The other big disadvantage is that the coding complexity of what you propose is much more significant, and at this point, I have a very strong bias towards KISS.

Still, if you want to clean up and make the mballoc layer more functional, it's not going to collide with the allocation blocksize work.   The two solutions aren't really mutually exclusive, but I suspect I'll be able to get there a much more quickly, and with a much lower memory overhead.

Thoughts, comments?

-- Ted
 