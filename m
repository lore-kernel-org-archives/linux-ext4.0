From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/5 v6] ext4: Add new ext4_discard_partial_page_buffers
 routines
Date: Sat, 27 Aug 2011 00:06:09 -0400
Message-ID: <20110827040609.GA5374@thunk.org>
References: <1314212842-16741-1-git-send-email-achender@linux.vnet.ibm.com>
 <1314212842-16741-2-git-send-email-achender@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33186 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695Ab1H0EGQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 27 Aug 2011 00:06:16 -0400
Content-Disposition: inline
In-Reply-To: <1314212842-16741-2-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 24, 2011 at 12:07:18PM -0700, Allison Henderson wrote:
> +	while (pos < offset + length) {
> +		err = 0;
> +
> +		/* The length of space left to zero and unmap */
> +		range_to_discard = offset + length - pos;
> +
> +		/* The length of space until the end of the block */
> +		end_of_block = blocksize - (pos & (blocksize-1));
> +
> +		/*
> +		 * Do not unmap or zero past end of block
> +		 * for this buffer head
> +		 */
> +		if (range_to_discard > end_of_block)
> +			range_to_discard = end_of_block;
> +
> +
> +		/*
> +		 * Skip this buffer head if we are only zeroing unampped
> +		 * regions of the page
> +		 */
> +		if (flags & EXT4_DSCRD_PARTIAL_PG_ZERO_UNMAPED &&
> +			buffer_mapped(bh))
> +				goto next;
> +


You should move this bit of code here:

		/* If the range is block aligned, unmap */
		if (range_to_discard == blocksize) {
			clear_buffer_dirty(bh);
			bh->b_bdev = NULL;
			clear_buffer_mapped(bh);
			clear_buffer_req(bh);
			clear_buffer_new(bh);
			clear_buffer_delay(bh);
			clear_buffer_unwritten(bh);
			clear_buffer_uptodate(bh);

and add these two lines:
+			zero_user(page, pos, blocksize);
+			goto next;

		}

Why?  Because if the range is block aligned, all you have to do is
unmap the buffer and call zero_user() just in case the page was
mmap'ed into some process's address space.  You don't want to mark the
block dirty --- in fact, if the buffer was already unmapped, you'll
trigger a WARN_ON in fs/buffer.c in mark_buffer_dirty() --- which is
how I noticed the problem and decided to look more closely at this bit
of code.   

You also don't want to engage the journaling machinery and journal the
data block in data=journalling mode, or to put the inode on the
data=ordered writeback list just because of this write.  That's just
wasted work.

If you do this, then you also don't need the conditional below:

> +		/*
> +		 * If this block is not completely contained in the range
> +		 * to be discarded, then it is not going to be released. Because
> +		 * we need to keep this block, we need to make sure this part
> +		 * of the page is uptodate before we modify it by writeing
> +		 * partial zeros on it.
> +		 */
> +		if (range_to_discard != blocksize) {

... which will also reduce a level of indentation, in the code, which
is good.

						- Ted
