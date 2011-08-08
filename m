From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1 v4] ext4: fix xfstests 75, 112, 127 punch hole failure
Date: Mon, 08 Aug 2011 13:54:30 -0700
Message-ID: <4E404D06.6010002@linux.vnet.ibm.com>
References: <1312698112-7836-1-git-send-email-achender@linux.vnet.ibm.com> <20110808024213.GC11497@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:49658 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753704Ab1HHUyf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Aug 2011 16:54:35 -0400
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e4.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p78KVics012862
	for <linux-ext4@vger.kernel.org>; Mon, 8 Aug 2011 16:31:44 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p78KsXUd3203182
	for <linux-ext4@vger.kernel.org>; Mon, 8 Aug 2011 16:54:33 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p78KsWu9021630
	for <linux-ext4@vger.kernel.org>; Mon, 8 Aug 2011 16:54:33 -0400
In-Reply-To: <20110808024213.GC11497@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/07/2011 07:42 PM, Ted Ts'o wrote:
> Thanks, much better.  I still have some questions though.
> 
>>   /*
>> + * ext4_unmap_partial_page_buffers()
>> + * Unmaps a page range of length 'length' starting from offset
>> + * 'from'.  The range to be unmaped must be contained with in
>> + * one page.  If the specified range exceeds the end of the page
>> + * it will be shortened to end of the page that cooresponds to
>> + * 'from'.  Only block aligned buffers will be unmapped and unblock
>> + * aligned buffers are skipped
>> + */
>> +static int ext4_unmap_partial_page_buffers(handle_t *handle,
>> +		struct address_space *mapping, loff_t from, loff_t length)
> 
> Is "unmap" really the right name of this function?  Isn't the real to
> invalidate a buffer head that corresponds to a punched-out block?
> 
> Correct me if I'm wrong, but the primary problem that we need to worry
> about here is that the block that has just been punched out could be
> reused by some other inode --- but if we still have a dirty buffer
> head mapped to the now-punched-out-and-released-block, writeback could
> end up corrupting some other buffer.  So in some sense, what we are
> effectively doing is a bforget, right?

Hmm, well actually when I spotted this bug, I was thinking more along the lines of: because the buffer is still mapped, we end up reading stale data out of it.  They are not supposed to be dirty because we flush out all the pages before punching holes.  We did this with the idea of avoiding race conditions, and also it simplified the code because the delayed extents are gone.  But now that you point it out, Im seeing that we only flush the aligned pages in the hole, so maybe we need to flush the extra two non aligned pages at the beginning and end.

> 
> In fact, if we are doing data journalling, don't we need to call
> ext4_forget()?  Otherwise, the block gets reassigned, but if the block
> has been data journaled, without the revoke record written by
> ext4_forget(), won't we have a potential problem where the journal
> replay could end up corrupting another inode's data?

Well, I did some investigating on ext4_forget, and it looks like it gets called in ext4_free_blocks when ext4_remove_blocks is called, (which sets the forget flag).  So it looks like we do end up calling it, but not until we get down to where we are actually punching out the blocks.

> 
> Furthermore, the question I have is why don't have precisely the same
> problem with truncate?  If we have a 16k page size, and we open a 15k
> file for writing, and then we overwrite the first 15k, and then
> truncate the file down to 4k.  At the moment we'll zero out the last
> 11k of the file, and leave the buffer heads dirty and mapped; then
> suppose those blocks get reassigned and used before writeback happens.
> We're not calling ext4_unmap_partial_page_buffers() now; why isn't
> this a problem today?  Are we just getting lucky?  Why is this more of
> a problem with punch, such that xfstests 75, 112, 127, etc. are
> failing?
> 
> Am I missing something here?

That is a really good point, I'd be surprised if we've just been lucky all this time.  I am thinking maybe it is because of the fact that i_size is already trimmed down to the new size? I do not think we read beyond i_size.  

Initially I was modeling punch hole from truncate, so they are similar.  The truncate code is actually calling ext4_block_truncate_page, which only zeros out the end of the block, and does not bother with the remaining buffer heads appearing after i_size.  Then it goes to ext4_ext_remove_space, which is pretty much calling remove_blocks like punch hole does, except that it removes everything from the end of the file to the last block that contains i_size.  So I think the fact that i_size changes would would make sense.

> 
>> +	/*
>> +	 * Now we need to unmap the non-page-aligned buffers.
>> +	 * If the block size is smaller than the page size
>> +	 * and the file space being truncated is not
>> +	 * page aligned, then unmap the buffers
>> +	 */
>> +	if (inode->i_sb->s_blocksize<  PAGE_CACHE_SIZE&&
>> +	   !((offset % PAGE_CACHE_SIZE == 0)&&
>> +	   (length % PAGE_CACHE_SIZE == 0))) {
> 
> How does this solve the situation I had outlined before?  Suppose are
> have a 4k page size, and a 4k block size, and we issue a punch
> operation with offset=4092, and length=4105.  In the previous section
> of code, the offsets 4092--4095 and 8193--8197 will be zero'ed out.
> But offset will not be a multiple of the page size, and length will
> not be a multiple of page size, but what has been left to be dealt
> with *is* an exactl multiple of a page size, and thus could be
> optimized out.
> 
> I didn't see any changes in your patch that adjust offset and length
> after calling ext4_block_zero_page_range(); so I think we still have
> an optimization opportunity we're missing here.
> 

I see, sorry I must have miss understood the first time.  Maybe what we need instead is to just check to see if page_len is larger than a block instead of just larger than zero.  Something like this:

/* unmap page buffers before the first aligned page */
page_len = first_page_offset - offset;
	if (page_len > blocksize) 
		ext4_unmap_partial_page_buffers(handle,
			mapping, offset, page_len);

/* unmap the page buffers after the last aligned page */
page_len = offset + length - last_page_offset;
	if (page_len > blocksize) { 
		ext4_unmap_partial_page_buffers(handle,
			mapping, last_page_offset, page_len);
  
In both cases, the range will start or end on a page boundary, so if the range we're unmapping is greater than a block, then there is at least one buffer head that needs unmapping.  Does that catch all the corner cases?

Thx!
Allison Henderson


> Regards,
> 
> 						- Ted

