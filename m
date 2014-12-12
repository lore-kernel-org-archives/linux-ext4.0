From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 09/47] libext2fs: use a dynamically sized (or
 caller-provided) block zeroing buffer
Date: Thu, 11 Dec 2014 21:02:49 -0800
Message-ID: <20141212050249.GA27096@birch.djwong.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
 <20141107215146.883.18254.stgit@birch.djwong.org>
 <20141212023756.GA10189@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35677 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbaLLFCx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Dec 2014 00:02:53 -0500
Content-Disposition: inline
In-Reply-To: <20141212023756.GA10189@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 11, 2014 at 09:37:56PM -0500, Theodore Ts'o wrote:
> On Fri, Nov 07, 2014 at 01:51:46PM -0800, Darrick J. Wong wrote:
> > Dynamically grow the block zeroing buffer to a maximum of 4MB, and
> > allow callers to provide their own zeroed buffer.
> > 
> > +
> > +	/* If the user gave us a buffer, write that out */
> > +	if (block_buf) {
> > +		retval = io_channel_write_blk64(fs->io, blk, num, block_buf);
> > +		if (retval) {
> > +			if (ret_count)
> > +				*ret_count = num;
> > +			if (ret_blk)
> > +				*ret_blk = blk;
> > +		}
> > +
> > +		return retval;
> > +	}
> 
> I've looked through the whole patch series,and there's only a single
> caller of the new ext2fs_zero_blocks3 function --- and the caller is
> going to be giving us a pre-zero'ed buffer, it might as well call
> io_channel_write_blk64() directly instead of the new
> ext2fs_zero_block3().  This is what we do in 1.42.x, and it makes a
> lot more sense than changing the code to call ext2fs_zero_blocks3(),
> and requiring it to depend on the caller having zero'ed the block
> buffer, and then adding absolutely no value other than calling
> i_channel_zeroout(), having it return UNIMPLEMENTED because it makes
> no sense to use BLKZEROOUT, and then falling back to
> io_channel_write_blk64().  
> 
> So what I think makes sense is to drop the new ext2fs_zero_blocks3()
> function, and to revert the change in ext2fs_alloc_block2() so that it
> calls io_channel_write_blk64() instead of ext2fs_zero_block2().
> 
> I'll take care of making this change in the patch.

Ok, thank you!

(Esp. since the power may or may not stay up out here in the West.)

--D

> 
> 						- Ted
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
