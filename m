From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] e2fsck: blk64_t to blk_t truncation
Date: Mon, 2 Dec 2013 13:48:56 -0800
Message-ID: <20131202214856.GB9535@birch.djwong.org>
References: <529CF0D2.2010707@ddn.com>
 <529CF1E8.3010003@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Dilger, Andreas" <andreas.dilger@intel.com>
To: Kit Westneat <kwestneat@ddn.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48675 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab3LBVtH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Dec 2013 16:49:07 -0500
Content-Disposition: inline
In-Reply-To: <529CF1E8.3010003@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 02, 2013 at 03:47:36PM -0500, Kit Westneat wrote:
> Hello,
> 
> We recently ran into an issue where e2fsck was claiming to clear
> deleted/unused inodes, but was not actually doing it. We tracked it
> down to a bad blk64_t to blk_t conversion in pass2 where
> ext2fs_write_dir_block is being called instead of
> ext2fs_write_dir_block3. There is another similar call in
> allocate_dir_block. These appear to be fixed in master as part of
> the move to adding checksums to the end of directory leaf nodes, but
> it's still an issue on maint.
> 
> I ran gcc with -Wconversion and found a number of other places that
> have blk64_t to blk_t truncations, but I'm not sure how many of them
> are actually problems. For example in block_iterate_ind, block_nr is
> blk_t but it seems to be a specific choice, since there is also the
> blk64 variable. Another instance is with the EA refcounting, which
> is all 32-bit. In expand_dir_proc in pass3.c, it uses the 32-bit
> ext2fs_write_dir_block. Against 1.42.7, gcc reports 103 blk64_t to
> blk_t conversions, so this is just a small sample.
> 
> I'm sure most of these are not problems, but I thought I'd raise the
> issue since we did run into problems with deleted/unused inodes.
> 
> Signed-off-by: Kit Westneat <kwestneat@ddn.com>

Looks fine to me, so you can add
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

I wonder how many more of these kinds of errors I inadvertently fixed
and neglected to patch maint... :/

--D
> 
> 
> diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
> index 78740c0..e8d0b47 100644
> --- a/e2fsck/pass2.c
> +++ b/e2fsck/pass2.c
> @@ -1216,7 +1216,7 @@ out_htree:
>  		}
>  	}
>  	if (dir_modified) {
> -		cd->pctx.errcode = ext2fs_write_dir_block(fs, block_nr, buf);
> +		cd->pctx.errcode = ext2fs_write_dir_block3(fs, block_nr, buf, 0);
>  		if (cd->pctx.errcode) {
>  			if (!fix_problem(ctx, PR_2_WRITE_DIRBLOCK,
>  					 &cd->pctx))
> @@ -1595,7 +1595,7 @@ static int allocate_dir_block(e2fsck_t ctx,
>  		return 1;
>  	}
> 
> -	pctx->errcode = ext2fs_write_dir_block(fs, blk, block);
> +	pctx->errcode = ext2fs_write_dir_block3(fs, blk, block, 0);
>  	ext2fs_free_mem(&block);
>  	if (pctx->errcode) {
>  		pctx->str = "ext2fs_write_dir_block";
> 
> ---
> Kit Westneat
> L3 Lustre Support, DDN
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
