From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/1 v4] ext4: fix xfstests 75, 112, 127 punch hole
 failure
Date: Sun, 7 Aug 2011 22:42:13 -0400
Message-ID: <20110808024213.GC11497@thunk.org>
References: <1312698112-7836-1-git-send-email-achender@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38157 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694Ab1HHCmQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 7 Aug 2011 22:42:16 -0400
Content-Disposition: inline
In-Reply-To: <1312698112-7836-1-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks, much better.  I still have some questions though.

>  /*
> + * ext4_unmap_partial_page_buffers()
> + * Unmaps a page range of length 'length' starting from offset
> + * 'from'.  The range to be unmaped must be contained with in
> + * one page.  If the specified range exceeds the end of the page
> + * it will be shortened to end of the page that cooresponds to
> + * 'from'.  Only block aligned buffers will be unmapped and unblock
> + * aligned buffers are skipped
> + */
> +static int ext4_unmap_partial_page_buffers(handle_t *handle,
> +		struct address_space *mapping, loff_t from, loff_t length)

Is "unmap" really the right name of this function?  Isn't the real to
invalidate a buffer head that corresponds to a punched-out block?

Correct me if I'm wrong, but the primary problem that we need to worry
about here is that the block that has just been punched out could be
reused by some other inode --- but if we still have a dirty buffer
head mapped to the now-punched-out-and-released-block, writeback could
end up corrupting some other buffer.  So in some sense, what we are
effectively doing is a bforget, right?

In fact, if we are doing data journalling, don't we need to call
ext4_forget()?  Otherwise, the block gets reassigned, but if the block
has been data journaled, without the revoke record written by
ext4_forget(), won't we have a potential problem where the journal
replay could end up corrupting another inode's data?

Furthermore, the question I have is why don't have precisely the same
problem with truncate?  If we have a 16k page size, and we open a 15k
file for writing, and then we overwrite the first 15k, and then
truncate the file down to 4k.  At the moment we'll zero out the last
11k of the file, and leave the buffer heads dirty and mapped; then
suppose those blocks get reassigned and used before writeback happens.
We're not calling ext4_unmap_partial_page_buffers() now; why isn't
this a problem today?  Are we just getting lucky?  Why is this more of
a problem with punch, such that xfstests 75, 112, 127, etc. are
failing?

Am I missing something here?

> +	/*
> +	 * Now we need to unmap the non-page-aligned buffers.
> +	 * If the block size is smaller than the page size
> +	 * and the file space being truncated is not
> +	 * page aligned, then unmap the buffers
> +	 */
> +	if (inode->i_sb->s_blocksize < PAGE_CACHE_SIZE &&
> +	   !((offset % PAGE_CACHE_SIZE == 0) &&
> +	   (length % PAGE_CACHE_SIZE == 0))) {

How does this solve the situation I had outlined before?  Suppose are
have a 4k page size, and a 4k block size, and we issue a punch
operation with offset=4092, and length=4105.  In the previous section
of code, the offsets 4092--4095 and 8193--8197 will be zero'ed out.
But offset will not be a multiple of the page size, and length will
not be a multiple of page size, but what has been left to be dealt
with *is* an exactl multiple of a page size, and thus could be
optimized out.

I didn't see any changes in your patch that adjust offset and length
after calling ext4_block_zero_page_range(); so I think we still have
an optimization opportunity we're missing here.

Regards,

						- Ted
