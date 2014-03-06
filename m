From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: fix bug in ext4_mb_normalize_request()
Date: Thu, 6 Mar 2014 10:44:07 -0500
Message-ID: <20140306154407.GA28226@thunk.org>
References: <1393855228-13592-1-git-send-email-mlombard@redhat.com>
 <1393855228-13592-3-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: adilger.kernel@dilger.ca, Maurizio Lombardi <mlombard@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37988 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753162AbaCFPoL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Mar 2014 10:44:11 -0500
Content-Disposition: inline
In-Reply-To: <1393855228-13592-3-git-send-email-mlombard@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 03, 2014 at 03:00:28PM +0100, Maurizio Lombardi wrote:
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 08ddfda..546575a 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -3059,6 +3059,21 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
>  		size	  = ac->ac_o_ex.fe_len << bsbits;
>  	}
>  	size = size >> bsbits;
> +
> +	/* In any case, the size cannot be greater than the number
> +	 * of maximum free blocks per group.
> +	 */
> +	if (size > EXT4_BLOCKS_PER_GROUP(ac->ac_sb)) {
> +		int sz_log2;
> +
> +		size = EXT4_BLOCKS_PER_GROUP(ac->ac_sb);
> +
> +		/* Recalculate the start offset */
> +		sz_log2 = __fls(size << bsbits);
> +		start_off = ((loff_t) ac->ac_o_ex.fe_logical >>
> +					(sz_log2 - bsbits)) << sz_log2;
> +	}
> +
>  	start = start_off >> bsbits;
>  
>  	/* don't cover already allocated blocks in selected range */

This definitely fixes the bug.  However, there will be some cases
where if the blocks per group is sufficiently small, where for smaller
files, start_off would have been 0 instead of that complicated
expression.

Looking at ext4_mb_normalize_request(), exactly what this code is
trying to do is actually a bit opaque to me, and every time I look at
it I get a headache.

Andreas, can you take a look at this?  I think you may know this code
better --- and it's somewhere I've been waiting to do some cleanup, or
at least some improved code comments.

Thanks!!

					- Ted
