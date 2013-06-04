From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsck: detect invalid extents at the end of an extent-block
Date: Tue, 04 Jun 2013 16:54:03 -0500
Message-ID: <51AE61FB.8080402@redhat.com>
References: <20130403190841.GA16276@fury.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: David Jeffery <djeffery@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520Ab3FDVyF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Jun 2013 17:54:05 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r54Ls5Bu009678
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 4 Jun 2013 17:54:05 -0400
In-Reply-To: <20130403190841.GA16276@fury.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/3/13 2:08 PM, David Jeffery wrote:
> e2fsck does not detect extents which are outside their location in the
> extent tree.  This can result in a bad extent at the end of an extent-block
> not being detected.
>     
> From a part of a dump_extents output:
>     
>  1/ 2  37/ 68 143960 - 146679 123826181               2720
>  2/ 2   1/  2 143960 - 146679 123785816 - 123788535   2720
>  2/ 2   2/  2 146680 - 147583 123788536 - 123789439    904 Uninit <-bad extent
>  1/ 2  38/ 68 146680 - 149391 123826182               2712
>  2/ 2   1/  2 146680 - 147583     18486 -     19389    904
>  2/ 2   2/  2 147584 - 149391 123789440 - 123791247   1808
>     
> e2fsck does not detect this bad extent which both overlaps another, valid
> extent, and is invalid by being beyond the end of the extent above it in
> the tree.
>     
> This patch modifies e2fsck to detect this invalid extent and remove it.
> 
> Signed-off-by: David Jeffery <djeffery@redhat.com>
> ---
>  e2fsck/pass1.c   |   13 +++++++++----
>  e2fsck/problem.c |    6 ++++++
>  e2fsck/problem.h |    1 +
>  3 files changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
> index a20b57b..198e9a0 100644
> --- a/e2fsck/pass1.c
> +++ b/e2fsck/pass1.c
> @@ -1848,7 +1848,7 @@ void e2fsck_clear_inode(e2fsck_t ctx, ext2_ino_t ino,
>  
>  static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
>  			     struct process_block_struct *pb,
> -			     blk64_t start_block,
> +			     blk64_t start_block, blk64_t end_block,
>  			     ext2_extent_handle_t ehandle)
>  {
>  	struct ext2fs_extent	extent;
> @@ -1891,6 +1891,9 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
>  			problem = PR_1_EXTENT_BAD_START_BLK;
>  		else if (extent.e_lblk < start_block)
>  			problem = PR_1_OUT_OF_ORDER_EXTENTS;
> +		else if (end_block &&
> +			 (extent.e_lblk + extent.e_len) > end_block)
> +			problem = PR_1_EXTENT_END_OUT_OF_BOUNDS;

thinking out loud; let's say e_lblk is 10 and len is 10.  So the
extent covers blocks 10->19, and e_lbk + e_len is 20, though
the last block in the range is 19.

But you pass in the same value (lblk + len) as "last block" so I guess
it matches up, it just requires some thought.

It might be better to do this in the caller:

lblk_end = extent.e_lblk + extent.e_len - 1;

and this in the test:

		else if (end_block &&
			 (extent.e_lblk + extent.e_len - 1) > end_block)

just so that "end_block" really is the end block?

>  		else if (is_leaf && extent.e_len == 0)
>  			problem = PR_1_EXTENT_LENGTH_ZERO;
>  		else if (is_leaf &&
> @@ -1937,10 +1940,11 @@ fix_problem_now:
>  		}
>  
>  		if (!is_leaf) {
> -			blk64_t lblk;
> +			blk64_t lblk, lblk_end;
>  
>  			blk = extent.e_pblk;
>  			lblk = extent.e_lblk;
> +			lblk_end = extent.e_lblk + extent.e_len;

maybe extent.e_lblk + extent.e_len - 1 ?

>  			pctx->errcode = ext2fs_extent_get(ehandle,
>  						  EXT2_EXTENT_DOWN, &extent);
>  			if (pctx->errcode) {
> @@ -1965,7 +1969,8 @@ fix_problem_now:
>  				if (fix_problem(ctx, problem, pctx))
>  					ext2fs_extent_fix_parents(ehandle);
>  			}
> -			scan_extent_node(ctx, pctx, pb, extent.e_lblk, ehandle);
> +			scan_extent_node(ctx, pctx, pb, extent.e_lblk,
> +					 lblk_end, ehandle);
>  			if (pctx->errcode)
>  				return;
>  			pctx->errcode = ext2fs_extent_get(ehandle,
> @@ -2084,7 +2089,7 @@ static void check_blocks_extents(e2fsck_t ctx, struct problem_context *pctx,
>  		ctx->extent_depth_count[info.max_depth]++;
>  	}
>  
> -	scan_extent_node(ctx, pctx, pb, 0, ehandle);
> +	scan_extent_node(ctx, pctx, pb, 0, 0, ehandle);

Other than the above nitpick, I think this does what it advertises, so:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Thanks,
-Eric

>  	if (pctx->errcode &&
>  	    fix_problem(ctx, PR_1_EXTENT_ITERATE_FAILURE, pctx)) {
>  		pb->num_blocks = 0;
> diff --git a/e2fsck/problem.c b/e2fsck/problem.c
> index 76bc1d5..b0a6e19 100644
> --- a/e2fsck/problem.c
> +++ b/e2fsck/problem.c
> @@ -1008,6 +1008,12 @@ static struct e2fsck_problem problem_table[] = {
>  	     "Logical start %b does not match logical start %c at next level.  "),
>  	  PROMPT_FIX, 0 },
>  
> +	/* Extent end is out of bounds for the tree */
> +	{ PR_1_EXTENT_END_OUT_OF_BOUNDS,
> +	  N_("@i %i, end of extent exceeds allowed value\n\t(logical @b %c, physical @b %b, len %N)\n"),
> +	  PROMPT_CLEAR, 0 },
> +
> +
>  	/* Pass 1b errors */
>  
>  	/* Pass 1B: Rescan for duplicate/bad blocks */
> diff --git a/e2fsck/problem.h b/e2fsck/problem.h
> index d2b6df4..fcdc1a1 100644
> --- a/e2fsck/problem.h
> +++ b/e2fsck/problem.h
> @@ -589,6 +589,7 @@ struct problem_context {
>  /* Index start doesn't match start of next extent down */
>  #define PR_1_EXTENT_INDEX_START_INVALID	0x01006D
>  
> +#define PR_1_EXTENT_END_OUT_OF_BOUNDS	0x01006E
>  /*
>   * Pass 1b errors
>   */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

