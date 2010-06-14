From: tytso@mit.edu
Subject: Re: [PATCH] [15/23] EXT4: Fix initialized but not read variables
Date: Mon, 14 Jun 2010 13:20:22 -0400
Message-ID: <20100614172022.GA6666@thunk.org>
References: <20100610110.764742110@firstfloor.org>
 <20100610111051.36EFEB1A2B@basil.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:56239 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756309Ab0FNRUc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Jun 2010 13:20:32 -0400
Content-Disposition: inline
In-Reply-To: <20100610111051.36EFEB1A2B@basil.firstfloor.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 10, 2010 at 01:10:51PM +0200, Andi Kleen wrote:
> 
> No real bugs found, just various dead code removed I believe.
> Some review would be good.
> 
> Found by gcc 4.6's new warnings
> 
> Cc: tytso@mit.edu
> Cc: linux-ext4@vger.kernel.org
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

I've reviewed this and pulled a fixed version into the ext4 patch
queue.  You deleted the initializers for size and start in mballoc.c,
which introduced a bug (ironically you commented about start not
getting inititialized in a FIXME, when the patch deleted said
initialization right above the introduced FIXME comment):

> @@ -2922,8 +2916,9 @@ ext4_mb_normalize_request(struct ext4_al
>  		start_off = (loff_t)ac->ac_o_ex.fe_logical << bsbits;
>  		size	  = ac->ac_o_ex.fe_len << bsbits;
>  	}
> -	orig_size = size = size >> bsbits;
> -	orig_start = start = start_off >> bsbits;
> +
> +	/* FIXME: start_off is not used for anything. bug? */
> +	/* FIXME: start may be uninitialized? */
>  
>  	/* don't cover already allocated blocks in selected range */
>  	if (ar->pleft && start <= ar->lleft) {

Also you only fixed one of two uses of the variable 'fidx' which you
removed here:

> @@ -1144,10 +1143,10 @@ static int ext4_ext_grow_indepth(handle_
>  	ext4_idx_store_pblock(curp->p_idx, newblock);
>  
>  	neh = ext_inode_hdr(inode);
> -	fidx = EXT_FIRST_INDEX(neh);
>  	ext_debug("new root: num %d(%d), lblock %d, ptr %llu\n",
>  		  le16_to_cpu(neh->eh_entries), le16_to_cpu(neh->eh_max),
> -		  le32_to_cpu(fidx->ei_block), idx_pblock(fidx));
> +		  le32_to_cpu(EXT_FIRST_INDEX(neh)->ei_block),
> +		  idx_pblock(fidx));
>  
>  	neh->eh_depth = cpu_to_le16(path->p_depth + 1);
>  	err = ext4_ext_dirty(handle, inode, curp);

Other than that the patch was fine.  I've fixed these up and I'll
carry the patch in the ext4 tree.

Thanks,

					- Ted
