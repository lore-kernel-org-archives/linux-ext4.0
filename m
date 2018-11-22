Return-Path: <SRS0=c0SX=OB=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34952 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2394957AbeKVWT1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 22 Nov 2018 17:19:27 -0500
Date: Thu, 22 Nov 2018 12:40:23 +0100
From: Jan Kara <jack@suse.cz>
To: Phillip Potter <phil@philpotter.co.uk>
Cc: jack@suse.com, amir73il@gmail.com, viro@zeniv.linux.org.uk,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC][PATCH v4 04/09] ext2: use common file type conversion
Message-ID: <20181122114023.GE9840@quack2.suse.cz>
References: <20181121190653.GA7710@pathfinder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181121190653.GA7710@pathfinder>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 21-11-18 19:06:53, Phillip Potter wrote:
> Deduplicate the ext2 file type conversion implementation - file systems
> that use the same file types as defined by POSIX do not need to define
> their own versions and can use the common helper functions decared in
> fs_types.h and implemented in fs_types.c
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Phillip Potter <phil@philpotter.co.uk>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext2/dir.c | 49 ++++++++++++++++++++-----------------------------
>  1 file changed, 20 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
> index 3b8114def693..bd30fe266373 100644
> --- a/fs/ext2/dir.c
> +++ b/fs/ext2/dir.c
> @@ -252,33 +252,24 @@ ext2_validate_entry(char *base, unsigned offset, unsigned mask)
>  	return (char *)p - base;
>  }
>  
> -static unsigned char ext2_filetype_table[EXT2_FT_MAX] = {
> -	[EXT2_FT_UNKNOWN]	= DT_UNKNOWN,
> -	[EXT2_FT_REG_FILE]	= DT_REG,
> -	[EXT2_FT_DIR]		= DT_DIR,
> -	[EXT2_FT_CHRDEV]	= DT_CHR,
> -	[EXT2_FT_BLKDEV]	= DT_BLK,
> -	[EXT2_FT_FIFO]		= DT_FIFO,
> -	[EXT2_FT_SOCK]		= DT_SOCK,
> -	[EXT2_FT_SYMLINK]	= DT_LNK,
> -};
> -
> -#define S_SHIFT 12
> -static unsigned char ext2_type_by_mode[S_IFMT >> S_SHIFT] = {
> -	[S_IFREG >> S_SHIFT]	= EXT2_FT_REG_FILE,
> -	[S_IFDIR >> S_SHIFT]	= EXT2_FT_DIR,
> -	[S_IFCHR >> S_SHIFT]	= EXT2_FT_CHRDEV,
> -	[S_IFBLK >> S_SHIFT]	= EXT2_FT_BLKDEV,
> -	[S_IFIFO >> S_SHIFT]	= EXT2_FT_FIFO,
> -	[S_IFSOCK >> S_SHIFT]	= EXT2_FT_SOCK,
> -	[S_IFLNK >> S_SHIFT]	= EXT2_FT_SYMLINK,
> -};
> -
>  static inline void ext2_set_de_type(ext2_dirent *de, struct inode *inode)
>  {
> -	umode_t mode = inode->i_mode;
> +	/*
> +	 * compile-time asserts that generic FT_x types still match
> +	 * EXT2_FT_x types
> +	 */
> +	BUILD_BUG_ON(EXT2_FT_UNKNOWN != FT_UNKNOWN);
> +	BUILD_BUG_ON(EXT2_FT_REG_FILE != FT_REG_FILE);
> +	BUILD_BUG_ON(EXT2_FT_DIR != FT_DIR);
> +	BUILD_BUG_ON(EXT2_FT_CHRDEV != FT_CHRDEV);
> +	BUILD_BUG_ON(EXT2_FT_BLKDEV != FT_BLKDEV);
> +	BUILD_BUG_ON(EXT2_FT_FIFO != FT_FIFO);
> +	BUILD_BUG_ON(EXT2_FT_SOCK != FT_SOCK);
> +	BUILD_BUG_ON(EXT2_FT_SYMLINK != FT_SYMLINK);
> +	BUILD_BUG_ON(EXT2_FT_MAX != FT_MAX);
> +
>  	if (EXT2_HAS_INCOMPAT_FEATURE(inode->i_sb, EXT2_FEATURE_INCOMPAT_FILETYPE))
> -		de->file_type = ext2_type_by_mode[(mode & S_IFMT)>>S_SHIFT];
> +		de->file_type = fs_umode_to_ftype(inode->i_mode);
>  	else
>  		de->file_type = 0;
>  }
> @@ -293,14 +284,14 @@ ext2_readdir(struct file *file, struct dir_context *ctx)
>  	unsigned long n = pos >> PAGE_SHIFT;
>  	unsigned long npages = dir_pages(inode);
>  	unsigned chunk_mask = ~(ext2_chunk_size(inode)-1);
> -	unsigned char *types = NULL;
>  	bool need_revalidate = !inode_eq_iversion(inode, file->f_version);
> +	bool has_filetype;
>  
>  	if (pos > inode->i_size - EXT2_DIR_REC_LEN(1))
>  		return 0;
>  
> -	if (EXT2_HAS_INCOMPAT_FEATURE(sb, EXT2_FEATURE_INCOMPAT_FILETYPE))
> -		types = ext2_filetype_table;
> +	has_filetype =
> +		EXT2_HAS_INCOMPAT_FEATURE(sb, EXT2_FEATURE_INCOMPAT_FILETYPE);
>  
>  	for ( ; n < npages; n++, offset = 0) {
>  		char *kaddr, *limit;
> @@ -335,8 +326,8 @@ ext2_readdir(struct file *file, struct dir_context *ctx)
>  			if (de->inode) {
>  				unsigned char d_type = DT_UNKNOWN;
>  
> -				if (types && de->file_type < EXT2_FT_MAX)
> -					d_type = types[de->file_type];
> +				if (has_filetype)
> +					d_type = fs_ftype_to_dtype(de->file_type);
>  
>  				if (!dir_emit(ctx, de->name, de->name_len,
>  						le32_to_cpu(de->inode),
> -- 
> 2.19.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
