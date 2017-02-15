From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 2/4] e2fsprogs: add support for 3-level htree
Date: Tue, 14 Feb 2017 21:42:47 -0800
Message-ID: <20170215054247.GA6804@birch.djwong.org>
References: <1486977617-17216-1-git-send-email-artem.blagodarenko@gmail.com>
 <1486977617-17216-3-git-send-email-artem.blagodarenko@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23826 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750729AbdBOFmx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Feb 2017 00:42:53 -0500
Content-Disposition: inline
In-Reply-To: <1486977617-17216-3-git-send-email-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 13, 2017 at 12:20:15PM +0300, Artem Blagodarenko wrote:
> From: Artem Blagodarenko <artem.blagodarenko@seagate.com>
> 
> The INCOMPAT_LARGEDIR feature allows larger directories to
> be created, both with directory sizes over 2GB and and a
> maximum htree depth of 3 instead of the current limit of 2.
> These features are needed in order to exceed the currently
> limit of approximately 10M entries in a single directory.
> 
> debugfs, e2fsck, ext2fs, mke2fs and tune2fs support is
> added.
> 
> Signed-off-by: Alexey Lyashkov <alexey.lyashkov@seagate.com>
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@seagate.com>
> ---
>  e2fsck/pass1.c       |    5 +++--
>  e2fsck/pass2.c       |    5 +++--
>  lib/ext2fs/ext2_fs.h |    3 ++-
>  lib/ext2fs/ext2fs.h  |   21 ++++++++++++++++++++-
>  misc/mke2fs.c        |    3 ++-
>  misc/tune2fs.c       |    3 ++-
>  6 files changed, 32 insertions(+), 8 deletions(-)
> 
> diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
> index ce37176..fff7dcf 100644
> --- a/e2fsck/pass1.c
> +++ b/e2fsck/pass1.c
> @@ -1716,7 +1716,8 @@ void e2fsck_pass1(e2fsck_t ctx)
>  		}
>  
>  		if (inode->i_faddr || frag || fsize ||
> -		    (LINUX_S_ISDIR(inode->i_mode) && inode->i_size_high))
> +		    (!ext2fs_has_feature_large_dir(fs) &&
> +		    (LINUX_S_ISDIR(inode->i_mode) && inode->i_size_high)))
>  			mark_inode_bad(ctx, ino);
>  		if ((fs->super->s_creator_os != EXT2_OS_HURD) &&
>  		    !ext2fs_has_feature_64bit(fs->super) &&
> @@ -2469,7 +2470,7 @@ static int handle_htree(e2fsck_t ctx, struct problem_context *pctx,
>  		return 1;
>  
>  	pctx->num = root->indirect_levels;
> -	if ((root->indirect_levels > 1) &&
> +	if ((root->indirect_levels > ext2_dir_htree_level(fs)) &&
>  	    fix_problem(ctx, PR_1_HTREE_DEPTH, pctx))
>  		return 1;
>  
> diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
> index b89ebc9..139d48f 100644
> --- a/e2fsck/pass2.c
> +++ b/e2fsck/pass2.c
> @@ -1058,7 +1058,8 @@ inline_read_fail:
>  			dx_db->flags |= DX_FLAG_FIRST | DX_FLAG_LAST;
>  			if ((root->reserved_zero ||
>  			     root->info_length < 8 ||
> -			     root->indirect_levels > 1) &&
> +			     root->indirect_levels
> +				> ext2_dir_htree_level(fs)) &&
>  			    fix_problem(ctx, PR_2_HTREE_BAD_ROOT, &cd->pctx)) {
>  				clear_htree(ctx, ino);
>  				dx_dir->numblocks = 0;
> @@ -1811,7 +1812,7 @@ int e2fsck_process_bad_inode(e2fsck_t ctx, ext2_ino_t dir,
>  		} else
>  			not_fixed++;
>  	}
> -	if (inode.i_size_high &&
> +	if (inode.i_size_high && !ext2fs_has_feature_large_dir(fs) &&
>  	    LINUX_S_ISDIR(inode.i_mode)) {
>  		if (fix_problem(ctx, PR_2_DIR_SIZE_HIGH_ZERO, &pctx)) {
>  			inode.i_size_high = 0;
> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
> index 195e366..6d9a5d0 100644
> --- a/lib/ext2fs/ext2_fs.h
> +++ b/lib/ext2fs/ext2_fs.h
> @@ -921,7 +921,8 @@ EXT4_FEATURE_INCOMPAT_FUNCS(encrypt,		4, ENCRYPT)
>  
>  #define EXT2_FEATURE_COMPAT_SUPP	0
>  #define EXT2_FEATURE_INCOMPAT_SUPP    (EXT2_FEATURE_INCOMPAT_FILETYPE| \
> -				       EXT4_FEATURE_INCOMPAT_MMP)
> +				       EXT4_FEATURE_INCOMPAT_MMP|\
> +				       EXT4_FEATURE_INCOMPAT_LARGEDIR)
>  #define EXT2_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER| \
>  					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
>  					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK| \
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index 786ded8..d714b44 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -588,7 +588,8 @@ typedef struct ext2_icount *ext2_icount_t;
>  					 EXT4_FEATURE_INCOMPAT_64BIT|\
>  					 EXT4_FEATURE_INCOMPAT_INLINE_DATA|\
>  					 EXT4_FEATURE_INCOMPAT_ENCRYPT|\
> -					 EXT4_FEATURE_INCOMPAT_CSUM_SEED)
> +					 EXT4_FEATURE_INCOMPAT_CSUM_SEED|\
> +					 EXT4_FEATURE_INCOMPAT_LARGEDIR)
>  
>  #define EXT2_LIB_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|\
>  					 EXT4_FEATURE_RO_COMPAT_HUGE_FILE|\
> @@ -1924,6 +1925,24 @@ _INLINE_ blk_t ext2fs_inode_data_blocks(ext2_filsys fs,
>  	return (blk_t) ext2fs_inode_data_blocks2(fs, inode);
>  }
>  
> +/* htree levels for ext4 */
> +#define EXT4_HTREE_LEVEL_COMPAT 1
> +#define EXT4_HTREE_LEVEL	3
> +
> +_INLINE_ int ext2fs_has_feature_large_dir(ext2_filsys fs)
> +{
> +	return EXT2_HAS_INCOMPAT_FEATURE(fs->super,
> +					 EXT4_FEATURE_INCOMPAT_LARGEDIR);
> +}

Already provided, see line 955:

EXT4_FEATURE_INCOMPAT_FUNCS(largedir,		4, LARGEDIR)

defines ext2fs_has_feature_largedir().

The rest looks ok.

--D

> +
> +_INLINE_ unsigned int ext2_dir_htree_level(ext2_filsys fs)
> +{
> +	if (ext2fs_has_feature_large_dir(fs))
> +		return EXT4_HTREE_LEVEL;
> +
> +	return EXT4_HTREE_LEVEL_COMPAT;
> +}
> +
>  /*
>   * This is an efficient, overflow safe way of calculating ceil((1.0 * a) / b)
>   */
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index 9f18c83..b2bf461 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -1081,7 +1081,8 @@ static __u32 ok_features[3] = {
>  		EXT4_FEATURE_INCOMPAT_64BIT|
>  		EXT4_FEATURE_INCOMPAT_INLINE_DATA|
>  		EXT4_FEATURE_INCOMPAT_ENCRYPT |
> -		EXT4_FEATURE_INCOMPAT_CSUM_SEED,
> +		EXT4_FEATURE_INCOMPAT_CSUM_SEED |
> +		EXT4_FEATURE_INCOMPAT_LARGEDIR,
>  	/* R/O compat */
>  	EXT2_FEATURE_RO_COMPAT_LARGE_FILE|
>  		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
> diff --git a/misc/tune2fs.c b/misc/tune2fs.c
> index 6239577..f78d105 100644
> --- a/misc/tune2fs.c
> +++ b/misc/tune2fs.c
> @@ -156,7 +156,8 @@ static __u32 ok_features[3] = {
>  		EXT4_FEATURE_INCOMPAT_MMP |
>  		EXT4_FEATURE_INCOMPAT_64BIT |
>  		EXT4_FEATURE_INCOMPAT_ENCRYPT |
> -		EXT4_FEATURE_INCOMPAT_CSUM_SEED,
> +		EXT4_FEATURE_INCOMPAT_CSUM_SEED |
> +		EXT4_FEATURE_INCOMPAT_LARGEDIR,
>  	/* R/O compat */
>  	EXT2_FEATURE_RO_COMPAT_LARGE_FILE |
>  		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
> -- 
> 1.7.1
> 
