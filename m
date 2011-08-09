From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/1 v4] ext4: fix xfstests 75, 112, 127 punch hole
 failure
Date: Tue, 9 Aug 2011 12:45:24 -0400
Message-ID: <20110809164524.GA3422@thunk.org>
References: <1312698112-7836-1-git-send-email-achender@linux.vnet.ibm.com>
 <20110808024213.GC11497@thunk.org>
 <4E404D06.6010002@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41010 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673Ab1HIQp1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Aug 2011 12:45:27 -0400
Content-Disposition: inline
In-Reply-To: <4E404D06.6010002@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 08, 2011 at 01:54:30PM -0700, Allison Henderson wrote:
> > Correct me if I'm wrong, but the primary problem that we need to worry
> > about here is that the block that has just been punched out could be
> > reused by some other inode --- but if we still have a dirty buffer
> > head mapped to the now-punched-out-and-released-block, writeback could
> > end up corrupting some other buffer.  So in some sense, what we are
> > effectively doing is a bforget, right?
> 
> Hmm, well actually when I spotted this bug, I was thinking more
> along the lines of: because the buffer is still mapped, we end up
> reading stale data out of it.  They are not supposed to be dirty
> because we flush out all the pages before punching holes.  We did
> this with the idea of avoiding race conditions, and also it
> simplified the code because the delayed extents are gone.  But now
> that you point it out, Im seeing that we only flush the aligned
> pages in the hole, so maybe we need to flush the extra two non
> aligned pages at the beginning and end.

We never use the buffer to read data "out of" the buffer.  We used to
use the buffer_head as the interface to the buffer layer when reading
or writing an entire page, but the buffer heads were never part of the
buffer cache, so there was never any chance that you could read "stale
data" from a mapped buffer head.  These days, we use the buffer head
as an inefficient data structure to store the mapping from the logical
block # to a physical block #.   But that's really it.

But the more I look at this code, the more I think it's not quite
right, and I think that's why you're still having a failure with test
127.   First of all, the comment here is wrong:

	/*
	 * Now we need to zero out the non-block-aligned data.
	 * If the file space being truncated is smaller than
	 * than a block, just zero out the middle
	 */

If blocksize != pagesize, this comment is _wrong_ in the case where
punched region is within a single page, but larger than a block:

	if (first_block > last_block)
		ext4_block_zero_page_range(handle, mapping, offset, length);

ext4_block_zero_page() will zero out the entire range that has been
punched out if it is within a single page.  And that is in fact a good
and proper thing to do, even if it is larger than a block.  For
example, assume a page size of 4096, and a block size of 1024, and the
punched-out-region begins at offset 1000 and extends for 1030 byets.
It's larger than a block, but because it's within a single page, we
zero out the entire range.

	else {
		/* zero out the head of the hole before the first block */
		block_len  = first_block_offset - offset;
		if (block_len > 0)
			ext4_block_zero_page_range(handle, mapping,
						   offset, block_len);

		/* zero out the tail of the hole after the last block */
		block_len = offset + length - last_block_offset;
		if (block_len > 0) {
			ext4_block_zero_page_range(handle, mapping,
					last_block_offset, block_len);
		}
	}

OK, now make the same assumption, but the punch range is 2000 for a
length of 6000 bytes.  And assume the file is 8192 bytes.  Right now
we will only zero out the range 2000-2048, and 7168--8000, since these
are the "tails" before the "first block" and after the "last block".

But if both 4k files are mapped in the page cache, in fact we need to
zero out the ranges 2000-4095 and 4096--8000!  Why?  Because we don't
read things out of the buffer cache, we read things out of the page
cache.  Or to make this more obvious, suppose this file is mmap'ed
into some process address space.  If you don't zero out the entire
range of bytes, then when the process reads from the mmap'ed region,
it will see non-zero pages.  It matters not a whit that the buffers
heads are unmapped in ext4_unmap_partial_page_buffers().

The reason why it's important to remove the mapped buffers is because
if we ever call write_page(), or read_page(), we use the mapped
buffers as a cache so we don't have to call ext4_map_blocks().  Hence,
if we remove some blocks from the logical->physical block mapping via
the punch() system call, we need to update the buffer_heads that may
be attached to the page since we have to keep the cache in sync.

Does that make sense?

> > Furthermore, the question I have is why don't have precisely the same
> > problem with truncate?  If we have a 16k page size, and we open a 15k
> > file for writing, and then we overwrite the first 15k, and then
> > truncate the file down to 4k.  At the moment we'll zero out the last
> > 11k of the file, and leave the buffer heads dirty and mapped; then
> > suppose those blocks get reassigned and used before writeback happens.
> > We're not calling ext4_unmap_partial_page_buffers() now; why isn't
> > this a problem today?  Are we just getting lucky?  Why is this more of
> > a problem with punch, such that xfstests 75, 112, 127, etc. are
> > failing?
> > 
> > Am I missing something here?
> 
> That is a really good point, I'd be surprised if we've just been
> lucky all this time.  I am thinking maybe it is because of the fact
> that i_size is already trimmed down to the new size? I do not think
> we read beyond i_size.

It's not the read(2) that I'm worried about; it's what happens if we
call writepage() on that last block.  If we have a left-over
buffer_head which is no longer mapped, and that block has been
repurposed, when we call writepage() we'll end up smashing potentially
someone else's block.  If that block hasn't gotten reused at the time
of the writepage(), we'll just do some pointless I/O, but it won't
cause any harm.  I suspect we're just getting lucky....

Regards,

						- Ted
