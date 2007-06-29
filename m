From: Mike Waychison <mikew@google.com>
Subject: Re: fallocate support for bitmap-based files
Date: Fri, 29 Jun 2007 16:52:23 -0400
Message-ID: <46857107.2000106@google.com>
References: <20070629130120.ec0d1c75.akpm@linux-foundation.org> <1183149414.12702.10.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger@clusterfs.com>,
	Sreenivasa Busam <sreenivasac@google.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:50534 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707AbXF2Uwi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Jun 2007 16:52:38 -0400
In-Reply-To: <1183149414.12702.10.camel@kleikamp.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Dave Kleikamp wrote:
> On Fri, 2007-06-29 at 13:01 -0700, Andrew Morton wrote:
> 
>>Guys, Mike and Sreenivasa at google are looking into implementing
>>fallocate() on ext2.  Of course, any such implementation could and should
>>also be portable to ext3 and ext4 bitmapped files.
>>
>>I believe that Sreenivasa will mainly be doing the implementation work.
>>
>>
>>The basic plan is as follows:
>>
>>- Create (with tune2fs and mke2fs) a hidden file using one of the
>>  reserved inode numbers.  That file will be sized to have one bit for each
>>  block in the partition.  Let's call this the "unwritten block file".
>>
>>  The unwritten block file will be initialised with all-zeroes
>>
>>- at fallocate()-time, allocate the blocks to the user's file (in some
>>  yet-to-be-determined fashion) and, for each one which is uninitialised,
>>  set its bit in the unwritten block file.  The set bit means "this block
>>  is uninitialised and needs to be zeroed out on read".
>>
>>- truncate() would need to clear out set-bits in the unwritten blocks file.
> 
> 
> By truncating the blocks file at the correct byte offset, only needing
> to zero some bits of the last byte of the file.

We were thinking the unwritten blocks file would be indexed by physical 
block number of the block device.  There wouldn't be a logical to 
physical relationship for the blocks, so we wouldn't be able to get away 
with truncating the blocks file itself.

> 
> 
>>- When the fs comes to read a block from disk, it will need to consult
>>  the unwritten blocks file to see if that block should be zeroed by the
>>  CPU.
>>
>>- When the unwritten-block is written to, its bit in the unwritten blocks
>>  file gets zeroed.
>>
>>- An obvious efficiency concern: if a user file has no unwritten blocks
>>  in it, we don't need to consult the unwritten blocks file.
>>
>>  Need to work out how to do this.  An obvious solution would be to have
>>  a number-of-unwritten-blocks counter in the inode.  But do we have space
>>  for that?
> 
> 
> Would it be too expensive to test the blocks-file page each time a bit
> is cleared to see if it is all-zero, and then free the page, making it a
> hole?  This test would stop if if finds any non-zero word, so it may not
> be too bad.  (This could further be done on a block basis if the block
> size is less than a page.)

When clearing the bits, we'd likely see a large stream of writes to the 
unwritten blocks, which could result in a O(n^2) pass of rescanning the 
page over and over.  Maybe a per-unwritten-block-file block 
per-block-header with a count that could be cheaply tested?  Ie: the 
unwritten block file is composed of blocks that each have a small header 
that contains count -- when the count hits zero, we could punch a hole 
in the file.

> 
> 
>>  (I expect google and others would prefer that the on-disk format be
>>  compatible with legacy ext2!)
>>
>>- One concern is the following scenario:
>>
>>  - Mount fs with "new" kernel, fallocate() some blocks to a file.
>>
>>  - Now, mount the fs under "old" kernel (which doesn't understand the
>>    unwritten blocks file).
>>
>>    - This kernel will be able to read uninitialised data from that
>>      fallocated-to file, which is a security concern.
>>
>>  - Now, the "old" kernel writes some data to a fallocated block.  But
>>    this kernel doesn't know that it needs to clear that block's flag in
>>    the unwritten blocks file!
>>
>>  - Now mount that fs under the "new" kernel and try to read that file.
>>     The flag for the block is set, so this kernel will still zero out the
>>    data on a read, thus corrupting the user's data
>>
>>  So how to fix this?  Perhaps with a per-inode flag indicating "this
>>  inode has unwritten blocks".  But to fix this problem, we'd require that
>>  the "old" kernel clear out that flag.
>>
>>  Can anyone propose a solution to this?
>>
>>  Ah, I can!  Use the compatibility flags in such a way as to prevent the
>>  "old" kernel from mounting this filesystem at all.  To mount this fs
>>  under an "old" kernel the user will need to run some tool which will
>>
>>  - read the unwritten blocks file
>>
>>  - for each set-bit in the unwritten blocks file, zero out the
>>    corresponding block
>>
>>  - zero out the unwritten blocks file
>>
>>  - rewrite the superblock to indicate that this fs may now be mounted
>>    by an "old" kernel.
>>
>>  Sound sane?
> 
> 
> Yeah.  I think it would have to be done under a compatibility flag.  Is
> going back to an older kernel really that important?  I think it's more
> important to make sure it can't be mounted by an older kernel if bad
> things can happen, and they can.
> 

Ya, I too was originally thinking of a compat flag to keep the old 
kernel from mounting the filesystem.  We'd arrange our bootup scripts to 
check for compatibility and call out to tune2fs (or some other tool) to 
down convert (by simply writing out zero blocks for each bit set and 
clearing the bitmap).

Mike Waychison
