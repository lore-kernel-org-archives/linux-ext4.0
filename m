From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v1 17/22] e2fsck: check inline_data in pass1
Date: Fri, 11 Oct 2013 17:47:09 -0700
Message-ID: <20131012004709.GX6860@birch.djwong.org>
References: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
 <1375436989-18948-18-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23734 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305Ab3JLArT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Oct 2013 20:47:19 -0400
Content-Disposition: inline
In-Reply-To: <1375436989-18948-18-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 02, 2013 at 05:49:44PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
>  e2fsck/pass1.c          |   70 ++++++++++++++++++++++++++++++++++++++++++++---
>  lib/ext2fs/dblist_dir.c |   10 +++++--
>  2 files changed, 74 insertions(+), 6 deletions(-)
> 
> diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
> index e6ea460..4301bb9 100644
> --- a/e2fsck/pass1.c
> +++ b/e2fsck/pass1.c
> @@ -202,6 +202,16 @@ int e2fsck_pass1_check_symlink(ext2_filsys fs, ext2_ino_t ino,
>  		return i;
>  	}
>  
> +	if (inode->i_flags & EXT4_INLINE_DATA_FL) {
> +		unsigned int inline_size;
> +
> +		inline_size = ext2fs_inline_data_get_size(fs, ino);
> +		if (inline_size == inode->i_size)
> +			return 1;
> +		else
> +			return 0;
> +	}
> +
>  	blocks = ext2fs_inode_data_blocks2(fs, inode);
>  	if (blocks) {
>  		if ((inode->i_size >= fs->blocksize) ||
> @@ -303,6 +313,15 @@ static void check_ea_in_inode(e2fsck_t ctx, struct problem_context *pctx)
>  			goto fix;
>  		}
>  
> +		/*
> +		 * Don't do the following checks for inline_data because
> +		 * other checks ensure the content of inline data right.
> +		 */
> +		if (strncmp(EXT2_EXT_ATTR_NAME(entry),
> +		    EXT4_EXT_ATTR_SYSTEM_DATA,
> +		    strlen(EXT4_EXT_ATTR_SYSTEM_DATA)) == 0)

Please align arguments 2 and 3 with argument 1 of strcmp.

--D
> +			goto next;
> +
>  		/* attribute len eats this space */
>  		remain -= EXT2_EXT_ATTR_SIZE(entry->e_name_len);
>  
> @@ -330,6 +349,7 @@ static void check_ea_in_inode(e2fsck_t ctx, struct problem_context *pctx)
>  			goto fix;
>  		}
>  
> +next:
>  		remain -= entry->e_value_size;
>  
>  		entry = EXT2_EXT_ATTR_NEXT(entry);
> @@ -407,6 +427,7 @@ static void check_is_really_dir(e2fsck_t ctx, struct problem_context *pctx,
>  	blk64_t			blk;
>  	unsigned int		i, rec_len, not_device = 0;
>  	int			extent_fs;
> +	int			inlinedata_fs;
>  
>  	/*
>  	 * If the mode looks OK, we believe it.  If the first block in
> @@ -434,11 +455,19 @@ static void check_is_really_dir(e2fsck_t ctx, struct problem_context *pctx,
>  	 * For extent mapped files, we don't do any sanity checking:
>  	 * just try to get the phys block of logical block 0 and run
>  	 * with it.
> +	 *
> +	 * For inline_data files, we just skip it because, in e2fsck
> +	 * pass1, we cannot get parent inode of a inode.  So we have
> +	 * no way to determine the inode is a directory or not.
>  	 */
>  
>  	extent_fs = (ctx->fs->super->s_feature_incompat &
>  		     EXT3_FEATURE_INCOMPAT_EXTENTS);
> -	if (extent_fs && (inode->i_flags & EXT4_EXTENTS_FL)) {
> +	inlinedata_fs = (ctx->fs->super->s_feature_incompat &
> +			EXT4_FEATURE_INCOMPAT_INLINE_DATA);
> +	if (inlinedata_fs && (inode->i_flags & EXT4_INLINE_DATA_FL))
> +		return;
> +	else if (extent_fs && (inode->i_flags & EXT4_EXTENTS_FL)) {
>  		/* extent mapped */
>  		if  (ext2fs_bmap2(ctx->fs, pctx->ino, inode, 0, 0, 0, 0,
>  				 &blk))
> @@ -1205,7 +1234,8 @@ void e2fsck_pass1(e2fsck_t ctx)
>  			ctx->fs_sockets_count++;
>  		} else
>  			mark_inode_bad(ctx, ino);
> -		if (!(inode->i_flags & EXT4_EXTENTS_FL)) {
> +		if (!(inode->i_flags & EXT4_EXTENTS_FL) &&
> +		    !(inode->i_flags & EXT4_INLINE_DATA_FL)) {
>  			if (inode->i_block[EXT2_IND_BLOCK])
>  				ctx->fs_ind_count++;
>  			if (inode->i_block[EXT2_DIND_BLOCK])
> @@ -1214,6 +1244,7 @@ void e2fsck_pass1(e2fsck_t ctx)
>  				ctx->fs_tind_count++;
>  		}
>  		if (!(inode->i_flags & EXT4_EXTENTS_FL) &&
> +		    !(inode->i_flags & EXT4_INLINE_DATA_FL) &&
>  		    (inode->i_block[EXT2_IND_BLOCK] ||
>  		     inode->i_block[EXT2_DIND_BLOCK] ||
>  		     inode->i_block[EXT2_TIND_BLOCK] ||
> @@ -2129,6 +2160,28 @@ static void check_blocks_extents(e2fsck_t ctx, struct problem_context *pctx,
>  }
>  
>  /*
> + * In fact we needn't check blocks for a inode that has inline data because
> + * this inode doesn't have any blocks.  In this function, all we need to do
> + * is add this inode into dblist when it is a directory.
> + */
> +static void check_blocks_inline_data(e2fsck_t ctx,
> +				     struct problem_context *pctx,
> +				     struct process_block_struct *pb)
> +{
> +	if (!pb->is_dir)
> +		return;
> +
> +	pctx->errcode = ext2fs_add_dir_block2(ctx->fs->dblist,
> +					      pb->ino, 0, 0);
> +	if (pctx->errcode) {
> +		pctx->blk = 0;
> +		pctx->num = 0;
> +		fix_problem(ctx, PR_1_ADD_DBLOCK, pctx);
> +		ctx->flags |= E2F_FLAG_ABORT;
> +	}
> +}
> +
> +/*
>   * This subroutine is called on each inode to account for all of the
>   * blocks used by that inode.
>   */
> @@ -2142,6 +2195,7 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
>  	int		bad_size = 0;
>  	int		dirty_inode = 0;
>  	int		extent_fs;
> +	int		inlinedata_fs;
>  	__u64		size;
>  
>  	pb.ino = ino;
> @@ -2165,6 +2219,8 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
>  
>  	extent_fs = (ctx->fs->super->s_feature_incompat &
>                       EXT3_FEATURE_INCOMPAT_EXTENTS);
> +	inlinedata_fs = (ctx->fs->super->s_feature_incompat &
> +			 EXT4_FEATURE_INCOMPAT_INLINE_DATA);
>  
>  	if (inode->i_flags & EXT2_COMPRBLK_FL) {
>  		if (fs->super->s_feature_incompat &
> @@ -2188,6 +2244,9 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
>  	if (ext2fs_inode_has_valid_blocks2(fs, inode)) {
>  		if (extent_fs && (inode->i_flags & EXT4_EXTENTS_FL))
>  			check_blocks_extents(ctx, pctx, &pb);
> +		else if (inlinedata_fs &&
> +			 (inode->i_flags & EXT4_INLINE_DATA_FL))
> +			check_blocks_inline_data(ctx, pctx, &pb);
>  		else {
>  			pctx->errcode = ext2fs_block_iterate3(fs, ino,
>  						pb.is_dir ? BLOCK_FLAG_HOLE : 0,
> @@ -2230,7 +2289,8 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
>  		}
>  	}
>  
> -	if (!pb.num_blocks && pb.is_dir) {
> +	if (!pb.num_blocks && pb.is_dir &&
> +	    !(inode->i_flags & EXT4_INLINE_DATA_FL)) {
>  		if (fix_problem(ctx, PR_1_ZERO_LENGTH_DIR, pctx)) {
>  			e2fsck_clear_inode(ctx, ino, inode, 0, "check_blocks");
>  			ctx->fs_directory_count--;
> @@ -2256,7 +2316,9 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
>  #endif
>  	if (pb.is_dir) {
>  		int nblock = inode->i_size >> EXT2_BLOCK_SIZE_BITS(fs->super);
> -		if (inode->i_size & (fs->blocksize - 1))
> +		if (inode->i_flags & EXT4_INLINE_DATA_FL)
> +			;
> +		else if (inode->i_size & (fs->blocksize - 1))
>  			bad_size = 5;
>  		else if (nblock > (pb.last_block + 1))
>  			bad_size = 1;
> diff --git a/lib/ext2fs/dblist_dir.c b/lib/ext2fs/dblist_dir.c
> index d4d5111..6282ab4 100644
> --- a/lib/ext2fs/dblist_dir.c
> +++ b/lib/ext2fs/dblist_dir.c
> @@ -72,8 +72,14 @@ static int db_dir_proc(ext2_filsys fs, struct ext2_db_entry2 *db_info,
>  	ctx->dir = db_info->ino;
>  	ctx->errcode = 0;
>  
> -	ret = ext2fs_process_dir_block(fs, &db_info->blk,
> -				       db_info->blockcnt, 0, 0, priv_data);
> +	if (ext2fs_inode_has_inline_data(fs, ctx->dir))
> +		ret = ext2fs_inline_data_iterate(fs, ctx->dir, 0, 0,
> +						 ext2fs_process_dir_inline_data,
> +						 priv_data);
> +	else
> +		ret = ext2fs_process_dir_block(fs, &db_info->blk,
> +					       db_info->blockcnt,
> +					       0, 0, priv_data);
>  	if ((ret & BLOCK_ABORT) && !ctx->errcode)
>  		return DBLIST_ABORT;
>  	return 0;
> -- 
> 1.7.9.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
