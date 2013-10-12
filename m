From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v1 19/22] e2fsck: check inline_data in pass3
Date: Fri, 11 Oct 2013 17:54:10 -0700
Message-ID: <20131012005410.GY6860@birch.djwong.org>
References: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
 <1375436989-18948-20-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24727 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab3JLAyT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Oct 2013 20:54:19 -0400
Content-Disposition: inline
In-Reply-To: <1375436989-18948-20-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 02, 2013 at 05:49:46PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> In e2fsck_expand_directory() we don't handle a dir with inline data
> because when this function is called the directory inode shouldn't
> contains inline data.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
>  e2fsck/pass3.c  |   12 ++++++++++++
>  e2fsck/rehash.c |    3 ++-
>  2 files changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
> index a379e9b..5052345 100644
> --- a/e2fsck/pass3.c
> +++ b/e2fsck/pass3.c
> @@ -787,6 +787,18 @@ errcode_t e2fsck_expand_directory(e2fsck_t ctx, ext2_ino_t dir,
>  	es.ctx = ctx;
>  	es.dir = dir;
>  
> +	/*
> +	 * 'lost+found' dir shouldn't contains inline data.  So we
> +	 * need to clear this flag.
> +	 */
> +	if (ext2fs_inode_has_inline_data(fs, dir)) {
> +		retval = ext2fs_read_inode(fs, dir, &inode);
> +		if (retval)
> +			return retval;
> +		inode.i_flags &= ~EXT4_INLINE_DATA_FL;
> +		e2fsck_write_inode(ctx, dir, &inode, "clear inline_data flag");
> +	}
> +
>  	retval = ext2fs_block_iterate3(fs, dir, BLOCK_FLAG_APPEND,
>  				       0, expand_dir_proc, &es);

Are you saying that lost+found can have inline_data set yet i_blocks is
actually a block map/extent head?  Or are we supposed to zero i_blocks?

If we clear EXT4_INLINE_DATA_FL and then try to iterate blocks, are we setting
ourselves up to read (formerly inline) dirents as a block map and iterate it?

Shouldn't we care if the inode write fails?

--D

>  
> diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
> index 5592e3f..82aeddd 100644
> --- a/e2fsck/rehash.c
> +++ b/e2fsck/rehash.c
> @@ -937,7 +937,8 @@ void e2fsck_rehash_directories(e2fsck_t ctx)
>  #if 0
>  		fix_problem(ctx, PR_3A_OPTIMIZE_DIR, &pctx);
>  #endif
> -		pctx.errcode = e2fsck_rehash_dir(ctx, ino);
> +		if (!ext2fs_inode_has_inline_data(ctx->fs, ino))
> +			pctx.errcode = e2fsck_rehash_dir(ctx, ino);
>  		if (pctx.errcode) {
>  			end_problem_latch(ctx, PR_LATCH_OPTIMIZE_DIR);
>  			fix_problem(ctx, PR_3A_OPTIMIZE_DIR_ERR, &pctx);
> -- 
> 1.7.9.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
