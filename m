From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Need clear buffer_delay after page writeout for
	delayed allocation
Date: Tue, 3 Jun 2008 15:37:34 +0530
Message-ID: <20080603100734.GB16102@skywalker>
References: <1212154769-16486-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212354602.4368.12.camel@localhost.localdomain> <20080602031433.GA17678@skywalker> <1212378632.4368.79.camel@localhost.localdomain> <20080602040934.GB17678@skywalker> <1212385116.4368.90.camel@localhost.localdomain> <20080602063519.GA26379@skywalker> <1212390247.4368.107.camel@localhost.localdomain> <20080602080527.GE26379@skywalker> <1212468198.3636.116.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:38566 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbYFCKH6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jun 2008 06:07:58 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id m53A7jIv018136
	for <linux-ext4@vger.kernel.org>; Tue, 3 Jun 2008 20:07:45 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m53AC4aU102534
	for <linux-ext4@vger.kernel.org>; Tue, 3 Jun 2008 20:12:05 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m53A7pnQ026367
	for <linux-ext4@vger.kernel.org>; Tue, 3 Jun 2008 20:07:52 +1000
Content-Disposition: inline
In-Reply-To: <1212468198.3636.116.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 02, 2008 at 09:43:18PM -0700, Mingming Cao wrote:
> > 
> > Buffer marked as delay is also mapped
> > fs/ext4/inode.c
> > 
> > 1437                 map_bh(bh_result, inode->i_sb, 0);
> > 1438                 set_buffer_new(bh_result);
> > 1439                 set_buffer_delay(bh_result);
> > 
> > 
> I find a better place to handle this, it make sense to clear this bit in
> block_write_full_page() after get_block() returns successfully. This
> handles partial error case smoothly. Updated patch below (to replace the
> original patch)
> 
> ext4: Need clear buffer_delay in block_write_full_page() after allocation
> 
> From: Mingming Cao <cmm@us.ibm.com>
> 
> Normally delayed buffer could be cleared in mpage_da_map_blocks(), after
> blocks are successfully allocated. But if allocation failed, it will
> keep buffer_delay marked and deferring to later 
> ext4_da_writepage()(via block_write_full_page()) to do block allocation.
> This patch handles clear bh delay bit in this case. Clear buffer_delay
> in block_write_full_page() after the block is allocated.
> 
> This patch also fixed a bug in block_write_full_page() error case, we need
> to check the delayed flag before flush bh to disk when trying to recover from
> error.
> 
> Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> 
> ---
>  fs/buffer.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.26-rc4/fs/buffer.c
> ===================================================================
> --- linux-2.6.26-rc4.orig/fs/buffer.c	2008-06-02 21:34:30.000000000 -0700
> +++ linux-2.6.26-rc4/fs/buffer.c	2008-06-02 21:35:17.000000000 -0700
> @@ -1697,6 +1697,7 @@ static int __block_write_full_page(struc
>  			err = get_block(inode, block, bh, 1);
>  			if (err)
>  				goto recover;
> +			clear_buffer_delay(bh);

I still think we should clear the buffer_head delay bit in the get_block
rather than the callers. That way all the callers will be returned the
buffer_head with delay bit cleared. We do that for mapped and new bit
already.


>  			if (buffer_new(bh)) {
>  				/* blockdev mappings never come here */
>  				clear_buffer_new(bh);
> @@ -1775,7 +1776,8 @@ recover:
>  	bh = head;
>  	/* Recovery: lock and submit the mapped buffers */
>  	do {
> -		if (buffer_mapped(bh) && buffer_dirty(bh)) {
> +		if (buffer_mapped(bh) && buffer_dirty(bh)
> +			&& !buffer_delay(bh)) {
>  			lock_buffer(bh);
>  			mark_buffer_async_write(bh);
>  		} else {
> 
> 


This should be a separate bug fix patch. If we fail the allocation of a
block marked delay we should not write it.

-aneesh
