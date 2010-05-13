From: tytso@mit.edu
Subject: Re: [PATCH] e2fsck: make block counting variable in pass1 64 bits
Date: Thu, 13 May 2010 13:35:04 -0400
Message-ID: <20100513173504.GA13321@thunk.org>
References: <4BB22A0B.2000303@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Justin Maggard <jmaggard10@gmail.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:33971 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756825Ab0EMRfG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 May 2010 13:35:06 -0400
Content-Disposition: inline
In-Reply-To: <4BB22A0B.2000303@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Applied to the maint branch

				- Ted

On Tue, Mar 30, 2010 at 11:42:51AM -0500, Eric Sandeen wrote:
> Justin reported that creating a 4T file with posix_fallocate led
> to fsck errors:
> 
> e2fsck 1.41.10 (10-Feb-2009)
> Pass 1: Checking inodes, blocks, and sizes
> Inode 12, i_blocks is 8589935432, should be 840.  Fix? yes
> 
> This looks like a 32-bit overflow.
> 
> commmit 8a8f36540bbf5d4397cf476e216e9a720b5c1d8e added handling of
> the high i_blocks number, but we accumulate blocks in the num_blocks
> field, and that's still just 32 bits.
> 
> Note: we don't need to expand max_blocks for now, that's only used
> in the non-extents case, and those files have smaller max sizes.
> 
> I haven't been able to replicate the problem, oddly, but Justin
> reports that this patch fixed his situation.
> 
> Reported-by: Justin Maggard <jmaggard10@gmail.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> (resend, a thunderbird upgrade changed things so vger was eating my patches)
> 
> 
> diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
> index 09ff1d0..8c8fe8c 100644
> --- a/e2fsck/pass1.c
> +++ b/e2fsck/pass1.c
> @@ -80,7 +80,7 @@ struct process_block_struct {
>  	ext2_ino_t	ino;
>  	unsigned	is_dir:1, is_reg:1, clear:1, suppress:1,
>  				fragmented:1, compressed:1, bbcheck:1;
> -	blk_t		num_blocks;
> +	blk64_t		num_blocks;
>  	blk_t		max_blocks;
>  	e2_blkcnt_t	last_block;
>  	int		num_illegal_blocks;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
