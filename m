From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 02/25] libext2fs: fix ext2fs_open2() truncation of the
 superblock parameter
Date: Fri, 18 Oct 2013 11:32:04 -0700
Message-ID: <20131018183204.GB19188@birch.djwong.org>
References: <20131018044854.7339.48457.stgit@birch.djwong.org>
 <20131018044907.7339.17710.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25517 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756000Ab3JRScJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Oct 2013 14:32:09 -0400
Content-Disposition: inline
In-Reply-To: <20131018044907.7339.17710.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 17, 2013 at 09:49:07PM -0700, Darrick J. Wong wrote:
> Since it's possible for very large filesystems to store backup
> superblocks at very large (> 2^32) block numbers, we need to be able
> to handle the case of a caller directing us to read one of these
> high-numbered backups.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  debugfs/debugfs.c   |    4 ++--
>  e2fsck/journal.c    |    6 +++---
>  e2fsck/unix.c       |    8 ++++----
>  lib/ext2fs/ext2fs.h |    4 ++++
>  lib/ext2fs/openfs.c |   21 +++++++++++++++------
>  misc/dumpe2fs.c     |    4 ++--
>  6 files changed, 30 insertions(+), 17 deletions(-)
> 
> 
> diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
> index 8c32eff..4f6108d 100644
> --- a/debugfs/debugfs.c
> +++ b/debugfs/debugfs.c
> @@ -94,8 +94,8 @@ static void open_filesystem(char *device, int open_flags, blk64_t superblock,
>  	if (catastrophic)
>  		open_flags |= EXT2_FLAG_SKIP_MMP;
>  
> -	retval = ext2fs_open(device, open_flags, superblock, blocksize,
> -			     unix_io_manager, &current_fs);
> +	retval = ext2fs_open3(device, NULL, open_flags, superblock, blocksize,
> +			      unix_io_manager, &current_fs);
>  	if (retval) {
>  		com_err(device, retval, "while opening filesystem");
>  		current_fs = NULL;
> diff --git a/e2fsck/journal.c b/e2fsck/journal.c
> index 2509303..af35a38 100644
> --- a/e2fsck/journal.c
> +++ b/e2fsck/journal.c
> @@ -967,9 +967,9 @@ int e2fsck_run_ext3_journal(e2fsck_t ctx)
>  
>  	ext2fs_mmp_stop(ctx->fs);
>  	ext2fs_free(ctx->fs);
> -	retval = ext2fs_open(ctx->filesystem_name, EXT2_FLAG_RW,
> -			     ctx->superblock, blocksize, io_ptr,
> -			     &ctx->fs);
> +	retval = ext2fs_open3(ctx->filesystem_name, NULL, EXT2_FLAG_RW,
> +			      ctx->superblock, blocksize, io_ptr,
> +			      &ctx->fs);
>  	if (retval) {
>  		com_err(ctx->program_name, retval,
>  			_("while trying to re-open %s"),
> diff --git a/e2fsck/unix.c b/e2fsck/unix.c
> index 0546653..fb41ca0 100644
> --- a/e2fsck/unix.c
> +++ b/e2fsck/unix.c
> @@ -1040,7 +1040,7 @@ static errcode_t try_open_fs(e2fsck_t ctx, int flags, io_manager io_ptr,
>  
>  	*ret_fs = NULL;
>  	if (ctx->superblock && ctx->blocksize) {
> -		retval = ext2fs_open2(ctx->filesystem_name, ctx->io_options,
> +		retval = ext2fs_open3(ctx->filesystem_name, ctx->io_options,
>  				      flags, ctx->superblock, ctx->blocksize,
>  				      io_ptr, ret_fs);
>  	} else if (ctx->superblock) {
> @@ -1051,7 +1051,7 @@ static errcode_t try_open_fs(e2fsck_t ctx, int flags, io_manager io_ptr,
>  				ext2fs_free(*ret_fs);
>  				*ret_fs = NULL;
>  			}
> -			retval = ext2fs_open2(ctx->filesystem_name,
> +			retval = ext2fs_open3(ctx->filesystem_name,
>  					      ctx->io_options, flags,
>  					      ctx->superblock, blocksize,
>  					      io_ptr, ret_fs);
> @@ -1059,7 +1059,7 @@ static errcode_t try_open_fs(e2fsck_t ctx, int flags, io_manager io_ptr,
>  				break;
>  		}
>  	} else
> -		retval = ext2fs_open2(ctx->filesystem_name, ctx->io_options,
> +		retval = ext2fs_open3(ctx->filesystem_name, ctx->io_options,
>  				      flags, 0, 0, io_ptr, ret_fs);
>  
>  	if (retval == 0)
> @@ -1375,7 +1375,7 @@ failure:
>  	 * don't need to update the mount count and last checked
>  	 * fields in the backup superblock (the kernel doesn't update
>  	 * the backup superblocks anyway).  With newer versions of the
> -	 * library this flag is set by ext2fs_open2(), but we set this
> +	 * library this flag is set by ext2fs_open3(), but we set this
>  	 * here just to be sure.  (No, we don't support e2fsck running
>  	 * with some other libext2fs than the one that it was shipped
>  	 * with, but just in case....)
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index 67876ad..1ef4d67 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -1443,6 +1443,10 @@ extern errcode_t ext2fs_open2(const char *name, const char *io_options,
>  			      int flags, int superblock,
>  			      unsigned int block_size, io_manager manager,
>  			      ext2_filsys *ret_fs);
> +extern errcode_t ext2fs_open3(const char *name, const char *io_options,
> +			      int flags, blk64_t superblock,
> +			      unsigned int block_size, io_manager manager,
> +			      ext2_filsys *ret_fs);
>  extern blk64_t ext2fs_descriptor_block_loc2(ext2_filsys fs,
>  					blk64_t group_block, dgrp_t i);
>  extern blk_t ext2fs_descriptor_block_loc(ext2_filsys fs, blk_t group_block,
> diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
> index 2ad9114..b046d6c 100644
> --- a/lib/ext2fs/openfs.c
> +++ b/lib/ext2fs/openfs.c
> @@ -76,6 +76,15 @@ errcode_t ext2fs_open(const char *name, int flags, int superblock,
>  			    manager, ret_fs);
>  }
>  
> +errcode_t ext2fs_open2(const char *name, const char *io_options,
> +		       int flags, int superblock,
> +		       unsigned int block_size, io_manager manager,
> +		       ext2_filsys *ret_fs)
> +{
> +	return ext2fs_open3(name, io_options, flags, superblock, block_size,
> +			    manager, ret_fs);
> +}
> +
>  /*
>   *  Note: if superblock is non-zero, block-size must also be non-zero.
>   * 	Superblock and block_size can be zero to use the default size.
> @@ -90,8 +99,8 @@ errcode_t ext2fs_open(const char *name, int flags, int superblock,
>   *	EXT2_FLAG_64BITS - Allow 64-bit bitfields (needed for large
>   *				filesystems)
>   */
> -errcode_t ext2fs_open2(const char *name, const char *io_options,
> -		       int flags, int superblock,
> +errcode_t ext2fs_open3(const char *name, const char *io_options,
> +		       int flags, blk64_t superblock,
>  		       unsigned int block_size, io_manager manager,
>  		       ext2_filsys *ret_fs)
>  {
> @@ -189,8 +198,8 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
>  		if (retval)
>  			goto cleanup;
>  	}
> -	retval = io_channel_read_blk(fs->io, superblock, -SUPERBLOCK_SIZE,
> -				     fs->super);
> +	retval = io_channel_read_blk64(fs->io, superblock, -SUPERBLOCK_SIZE,
> +				       fs->super);
>  	if (retval)
>  		goto cleanup;
>  	if (fs->orig_super)
> @@ -380,8 +389,8 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
>  	else
>  		first_meta_bg = fs->desc_blocks;
>  	if (first_meta_bg) {
> -		retval = io_channel_read_blk(fs->io, group_block+1,
> -					     first_meta_bg, dest);
> +		retval = io_channel_read_blk64(fs->io, group_block+1,
> +					       first_meta_bg, dest);

The only change to this patch is the use of *read_blk64 in these two hunks.

--D

>  		if (retval)
>  			goto cleanup;
>  #ifdef WORDS_BIGENDIAN
> diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
> index ae70f70..b139977 100644
> --- a/misc/dumpe2fs.c
> +++ b/misc/dumpe2fs.c
> @@ -611,7 +611,7 @@ int main (int argc, char ** argv)
>  		for (use_blocksize = EXT2_MIN_BLOCK_SIZE;
>  		     use_blocksize <= EXT2_MAX_BLOCK_SIZE;
>  		     use_blocksize *= 2) {
> -			retval = ext2fs_open (device_name, flags,
> +			retval = ext2fs_open3(device_name, NULL, flags,
>  					      use_superblock,
>  					      use_blocksize, unix_io_manager,
>  					      &fs);
> @@ -619,7 +619,7 @@ int main (int argc, char ** argv)
>  				break;
>  		}
>  	} else
> -		retval = ext2fs_open (device_name, flags, use_superblock,
> +		retval = ext2fs_open3(device_name, NULL, flags, use_superblock,
>  				      use_blocksize, unix_io_manager, &fs);
>  	if (retval) {
>  		com_err (program_name, retval, _("while trying to open %s"),
> 
