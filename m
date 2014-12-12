From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 09/47] libext2fs: use a dynamically sized (or
 caller-provided) block zeroing buffer
Date: Thu, 11 Dec 2014 21:37:56 -0500
Message-ID: <20141212023756.GA10189@thunk.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
 <20141107215146.883.18254.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52150 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759799AbaLLCiB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Dec 2014 21:38:01 -0500
Content-Disposition: inline
In-Reply-To: <20141107215146.883.18254.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 07, 2014 at 01:51:46PM -0800, Darrick J. Wong wrote:
> Dynamically grow the block zeroing buffer to a maximum of 4MB, and
> allow callers to provide their own zeroed buffer.
> 
> +
> +	/* If the user gave us a buffer, write that out */
> +	if (block_buf) {
> +		retval = io_channel_write_blk64(fs->io, blk, num, block_buf);
> +		if (retval) {
> +			if (ret_count)
> +				*ret_count = num;
> +			if (ret_blk)
> +				*ret_blk = blk;
> +		}
> +
> +		return retval;
> +	}

I've looked through the whole patch series,and there's only a single
caller of the new ext2fs_zero_blocks3 function --- and the caller is
going to be giving us a pre-zero'ed buffer, it might as well call
io_channel_write_blk64() directly instead of the new
ext2fs_zero_block3().  This is what we do in 1.42.x, and it makes a
lot more sense than changing the code to call ext2fs_zero_blocks3(),
and requiring it to depend on the caller having zero'ed the block
buffer, and then adding absolutely no value other than calling
i_channel_zeroout(), having it return UNIMPLEMENTED because it makes
no sense to use BLKZEROOUT, and then falling back to
io_channel_write_blk64().  

So what I think makes sense is to drop the new ext2fs_zero_blocks3()
function, and to revert the change in ext2fs_alloc_block2() so that it
calls io_channel_write_blk64() instead of ext2fs_zero_block2().

I'll take care of making this change in the patch.

						- Ted

