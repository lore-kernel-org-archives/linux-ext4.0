From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/5 v6] ext4: Add new ext4_discard_partial_page_buffers
 routines
Date: Sat, 27 Aug 2011 19:22:37 -0700
Message-ID: <4E59A66D.7080800@linux.vnet.ibm.com>
References: <1314212842-16741-1-git-send-email-achender@linux.vnet.ibm.com> <1314212842-16741-2-git-send-email-achender@linux.vnet.ibm.com> <20110827040609.GA5374@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:43289 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996Ab1H1CWk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 27 Aug 2011 22:22:40 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p7S1qY4Q030744
	for <linux-ext4@vger.kernel.org>; Sat, 27 Aug 2011 21:52:34 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p7S2MdEq480116
	for <linux-ext4@vger.kernel.org>; Sat, 27 Aug 2011 22:22:39 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p7S2Md5Y032085
	for <linux-ext4@vger.kernel.org>; Sat, 27 Aug 2011 22:22:39 -0400
In-Reply-To: <20110827040609.GA5374@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/26/2011 09:06 PM, Ted Ts'o wrote:
> On Wed, Aug 24, 2011 at 12:07:18PM -0700, Allison Henderson wrote:
>> +	while (pos<  offset + length) {
>> +		err = 0;
>> +
>> +		/* The length of space left to zero and unmap */
>> +		range_to_discard = offset + length - pos;
>> +
>> +		/* The length of space until the end of the block */
>> +		end_of_block = blocksize - (pos&  (blocksize-1));
>> +
>> +		/*
>> +		 * Do not unmap or zero past end of block
>> +		 * for this buffer head
>> +		 */
>> +		if (range_to_discard>  end_of_block)
>> +			range_to_discard = end_of_block;
>> +
>> +
>> +		/*
>> +		 * Skip this buffer head if we are only zeroing unampped
>> +		 * regions of the page
>> +		 */
>> +		if (flags&  EXT4_DSCRD_PARTIAL_PG_ZERO_UNMAPED&&
>> +			buffer_mapped(bh))
>> +				goto next;
>> +
>
>
> You should move this bit of code here:
>
> 		/* If the range is block aligned, unmap */
> 		if (range_to_discard == blocksize) {
> 			clear_buffer_dirty(bh);
> 			bh->b_bdev = NULL;
> 			clear_buffer_mapped(bh);
> 			clear_buffer_req(bh);
> 			clear_buffer_new(bh);
> 			clear_buffer_delay(bh);
> 			clear_buffer_unwritten(bh);
> 			clear_buffer_uptodate(bh);
>
> and add these two lines:
> +			zero_user(page, pos, blocksize);
> +			goto next;
>
> 		}
>
> Why?  Because if the range is block aligned, all you have to do is
> unmap the buffer and call zero_user() just in case the page was
> mmap'ed into some process's address space.  You don't want to mark the
> block dirty --- in fact, if the buffer was already unmapped, you'll
> trigger a WARN_ON in fs/buffer.c in mark_buffer_dirty() --- which is
> how I noticed the problem and decided to look more closely at this bit
> of code.
>
> You also don't want to engage the journaling machinery and journal the
> data block in data=journalling mode, or to put the inode on the
> data=ordered writeback list just because of this write.  That's just
> wasted work.
>
> If you do this, then you also don't need the conditional below:
>
>> +		/*
>> +		 * If this block is not completely contained in the range
>> +		 * to be discarded, then it is not going to be released. Because
>> +		 * we need to keep this block, we need to make sure this part
>> +		 * of the page is uptodate before we modify it by writeing
>> +		 * partial zeros on it.
>> +		 */
>> +		if (range_to_discard != blocksize) {
>
> ... which will also reduce a level of indentation, in the code, which
> is good.
>
> 						- Ted


Alrighty, I have updated my current copy of the set.  I am still working 
trying to narrow down where the OOM bug is coming from.  I noticed that 
I started getting OOM bugs when I updated my kernel sand box to the 
latest code.  But I didnt get them while running the punch hole tests, 
or even while the set was applied  (it was actually a script I wrote for 
secure delete that dumps an image and analyzes it.  I probably just need 
to make the image smaller, but it didnt used to do that).

But since you mention OOM problems, my first thought was to reproduce 
the problem with xfstest 224, and then see if the problem goes away on 
the down level kernel (3.0.0-next-20110725), since Im not immediately 
seeing anything in this set that would use up so much memory. 
Unfortunately, I havent gotten the 224 OOM bug to happen for me yet, but 
I will keep you posted if I find anything.   Thx again for helping me 
out with this set!  :)

Allison Henderson
