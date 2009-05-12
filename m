From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH -V4 1/2] Fix sub-block zeroing for buffered writes into
	unwritten extents
Date: Mon, 11 May 2009 22:42:18 -0400
Message-ID: <20090512024218.GH21518@mit.edu>
References: <1240980441-8105-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44139 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756994AbZELCma (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 May 2009 22:42:30 -0400
Content-Disposition: inline
In-Reply-To: <1240980441-8105-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 29, 2009 at 10:17:20AM +0530, Aneesh Kumar K.V wrote:
> We need to mark the  buffer_head mapping prealloc space
> as new during write_begin. Otherwise we don't zero out the
> page cache content properly for a partial write. This will
> cause file corruption with preallocation.
> 
> Also use block number -1 as the fake block number so that
> unmap_underlying_metadata doesn't drop wrong buffer_head

The buffer_head code is starting to scare me more and more. 

I'm looking at this code again and I can't figure out why it's safe
(or why we would need to) put in an invalid number into
bh_result->b_blocknr:

> @@ -2323,6 +2323,16 @@ static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
>  		set_buffer_delay(bh_result);
>  	} else if (ret > 0) {
>  		bh_result->b_size = (ret << inode->i_blkbits);
> +		/*
> +		 * With sub-block writes into unwritten extents
> +		 * we also need to mark the buffer as new so that
> +		 * the unwritten parts of the buffer gets correctly zeroed.
> +		 */
> +		if (buffer_unwritten(bh_result)) {
> +			bh_result->b_bdev = inode->i_sb->s_bdev;
> +			set_buffer_new(bh_result);
> +			bh_result->b_blocknr = -1;

Why do we need to avoid calling unmap_underlying_metadata()?

And after the buffer is zero'ed out, it leaves b_blocknr in a
buffer_head attached to the page at an invalid block number.  Doesn't
that get us in trouble later on?

I see that this line is removed later on in the for-2.6.31 patch "Mark
the unwritten buffer_head as mapped during write_begin".  But is it
safe for 2.6.30?

						- Ted
