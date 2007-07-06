From: Mike Waychison <mikew@google.com>
Subject: Re: fallocate support for bitmap-based files
Date: Fri, 06 Jul 2007 14:33:05 -0700
Message-ID: <468EB511.7040203@google.com>
References: <20070629130120.ec0d1c75.akpm@linux-foundation.org>	 <1183212800.9505.12.camel@localhost.localdomain> <1183398293.31959.3.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger@clusterfs.com>,
	Sreenivasa Busam <sreenivasac@google.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Badari Pulavarty <pbadari@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:39555 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760967AbXGFVdg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Jul 2007 17:33:36 -0400
In-Reply-To: <1183398293.31959.3.camel@dyn9047017100.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Badari Pulavarty wrote:
> On Sat, 2007-06-30 at 10:13 -0400, Mingming Cao wrote:
>> On Fri, 2007-06-29 at 13:01 -0700, Andrew Morton wrote:
>>> Guys, Mike and Sreenivasa at google are looking into implementing
>>> fallocate() on ext2.  Of course, any such implementation could and should
>>> also be portable to ext3 and ext4 bitmapped files.
>>>
>>> I believe that Sreenivasa will mainly be doing the implementation work.
>>>
>>>
>>> The basic plan is as follows:
>>>
>>> - Create (with tune2fs and mke2fs) a hidden file using one of the
>>>   reserved inode numbers.  That file will be sized to have one bit for each
>>>   block in the partition.  Let's call this the "unwritten block file".
>>>
>>>   The unwritten block file will be initialised with all-zeroes
>>>
>>> - at fallocate()-time, allocate the blocks to the user's file (in some
>>>   yet-to-be-determined fashion) and, for each one which is uninitialised,
>>>   set its bit in the unwritten block file.  The set bit means "this block
>>>   is uninitialised and needs to be zeroed out on read".
>>>
>>> - truncate() would need to clear out set-bits in the unwritten blocks file.
>>>
>>> - When the fs comes to read a block from disk, it will need to consult
>>>   the unwritten blocks file to see if that block should be zeroed by the
>>>   CPU.
>>>
>>> - When the unwritten-block is written to, its bit in the unwritten blocks
>>>   file gets zeroed.
>>>
>>> - An obvious efficiency concern: if a user file has no unwritten blocks
>>>   in it, we don't need to consult the unwritten blocks file.
>>>
>>>   Need to work out how to do this.  An obvious solution would be to have
>>>   a number-of-unwritten-blocks counter in the inode.  But do we have space
>>>   for that?
>>>
>>>   (I expect google and others would prefer that the on-disk format be
>>>   compatible with legacy ext2!)
>>>
>>> - One concern is the following scenario:
>>>
>>>   - Mount fs with "new" kernel, fallocate() some blocks to a file.
>>>
>>>   - Now, mount the fs under "old" kernel (which doesn't understand the
>>>     unwritten blocks file).
>>>
>>>     - This kernel will be able to read uninitialised data from that
>>>       fallocated-to file, which is a security concern.
>>>
>>>   - Now, the "old" kernel writes some data to a fallocated block.  But
>>>     this kernel doesn't know that it needs to clear that block's flag in
>>>     the unwritten blocks file!
>>>
>>>   - Now mount that fs under the "new" kernel and try to read that file.
>>>      The flag for the block is set, so this kernel will still zero out the
>>>     data on a read, thus corrupting the user's data
>>>
>>>   So how to fix this?  Perhaps with a per-inode flag indicating "this
>>>   inode has unwritten blocks".  But to fix this problem, we'd require that
>>>   the "old" kernel clear out that flag.
>>>
>>>   Can anyone propose a solution to this?
>>>
>>>   Ah, I can!  Use the compatibility flags in such a way as to prevent the
>>>   "old" kernel from mounting this filesystem at all.  To mount this fs
>>>   under an "old" kernel the user will need to run some tool which will
>>>
>>>   - read the unwritten blocks file
>>>
>>>   - for each set-bit in the unwritten blocks file, zero out the
>>>     corresponding block
>>>
>>>   - zero out the unwritten blocks file
>>>
>>>   - rewrite the superblock to indicate that this fs may now be mounted
>>>     by an "old" kernel.
>>>
>>>   Sound sane?
>>>
>>> - I'm assuming that there are more reserved inodes available, and that
>>>   the changes to tune2fs and mke2fs will be basically a copy-n-paste job
>>>   from the `tune2fs -j' code.  Correct?
>>>
>>> - I haven't thought about what fsck changes would be needed.
>>>
>>>   Presumably quite a few.  For example, fsck should check that set-bits
>>>   in the unwriten blobks file do not correspond to freed blocks.  If they
>>>   do, that should be fixed up.
>>>
>>>   And fsck can check each inodes number-of-unwritten-blocks counters
>>>   against the unwritten blocks file (if we implement the per-inode
>>>   number-of-unwritten-blocks counter)
>>>
>>>   What else should fsck do?
>>>
>>> - I haven't thought about the implications of porting this into ext3/4. 
>>>   Probably the commit to the unwritten blocks file will need to be atomic
>>>   with the commit to the user's file's metadata, so the unwritten-blocks
>>>   file will effectively need to be in journalled-data mode.
>>>
>>>   Or, more likely, we access the unwritten blocks file via the blockdev
>>>   pagecache (ie: use bmap, like the journal file) and then we're just
>>>   talking direct to the disk's blocks and it becomes just more fs metadata.
>>>
>>> - I guess resize2fs will need to be taught about the unwritten blocks
>>>   file: to shrink and grow it appropriately.
>>>
>>>
>>> That's all I can think of for now - I probably missed something. 
>>>
>>> Suggestions and thought are sought, please.
>>>
>>>
>> Another approach we have been thinking  is using a backing
>> inode(per-inode-with-preallocation) to store the preallocated blocks.
>> When user asked for preallocation on the base inode, ext2/3 create a
>> temporary backing inode, and it's (pre)allocate the
>> corresponding blocks in the backing inode. 
>>
>> When writes to the base inode, and realize we need to block allocation
>> on, before doing the fs real block allocation, it will check if the file
>> has a backing inode stores some preallocated blocks for the same logical
>> blocks.  If so, it will transfer the preallocated blocks from backing
>> inode to the base inode.
>>
>> We need to link the two inodes in some way, maybe store the backing
>> inode number via EA in the base inode, and flag the base inode that it
>> has a backing inode to get preallocated blocks.
>>
>> Since it doesn't change the block mapping on the original file until
>> writeout, so it doesn't require a incompat feature to protect the
>> preallocated contents to be read in "old" kernel. There some work need
>> to be done in e2fsck to understand the backing inode.
>>
> 
> Small detail - we need to mark size of the backing inode to zero --
> so that if we ever boot on older kernel, we will not be able to read
> the contents of that inode. (Ofcourse, this also means that fsck
> would remove that inode if we run fscheck).
> 

One downside of moving this data over to a backing inode is that we lose 
the benefit of making large pre allocations following by a series of 
random writes that result in in-ordered data on disk.  I presume we'd be 
scanning the backing inode for free data blocks?

Unless of course if we make the backing inode be an effective 'negative' 
of the holes in the actual inode.  Each hole introduced in the actual 
inode would have it's backing inode have actual storage at the same 
logical block offsets.

Another problem I can think of with this approach is that we'd have 
difficult reclaiming the metadata indirect blocks from the backing inode 
efficiently.  So if a user went and pre-allocated say 1GB of disk space 
for a file, we'd end up with the ~%0.1 metadata overhead doubled until 
we see the i_blocks for the backing inode hit zero (meaning all 
pre-allocated blocks were dirtied and backing inode can be freed).  May 
not be an issue in the real world..

Mike Waychison
