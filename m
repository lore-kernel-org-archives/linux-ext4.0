Return-Path: <SRS0=c0SX=OB=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35300 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731675AbeKVWVh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 22 Nov 2018 17:21:37 -0500
Date: Thu, 22 Nov 2018 12:42:33 +0100
From: Jan Kara <jack@suse.cz>
To: Phillip Potter <phil@philpotter.co.uk>
Cc: tytso@mit.edu, amir73il@gmail.com, viro@zeniv.linux.org.uk,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [RFC][PATCH v4 05/09] ext4: use common file type conversion
Message-ID: <20181122114233.GH9840@quack2.suse.cz>
References: <20181121190655.GA7717@pathfinder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181121190655.GA7717@pathfinder>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 21-11-18 19:06:55, Phillip Potter wrote:
> Deduplicate the ext4 file type conversion implementation - file systems
> that use the same file types as defined by POSIX do not need to define
> their own versions and can use the common helper functions decared in
> fs_types.h and implemented in fs_types.c
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
> ---
>  fs/ext4/ext4.h | 33 +++++++++++++++++----------------
>  1 file changed, 17 insertions(+), 16 deletions(-)

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 3f89d0ab08fc..c45d701ba4f4 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2357,16 +2357,13 @@ static inline void ext4_update_dx_flag(struct inode *inode)
>  	if (!ext4_has_feature_dir_index(inode->i_sb))
>  		ext4_clear_inode_flag(inode, EXT4_INODE_INDEX);
>  }
> -static const unsigned char ext4_filetype_table[] = {
> -	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK, DT_FIFO, DT_SOCK, DT_LNK
> -};
>  
>  static inline  unsigned char get_dtype(struct super_block *sb, int filetype)
>  {
> -	if (!ext4_has_feature_filetype(sb) || filetype >= EXT4_FT_MAX)
> +	if (!ext4_has_feature_filetype(sb))
>  		return DT_UNKNOWN;
>  
> -	return ext4_filetype_table[filetype];
> +	return fs_ftype_to_dtype(filetype);
>  }
>  extern int ext4_check_all_de(struct inode *dir, struct buffer_head *bh,
>  			     void *buf, int buf_size);
> @@ -3052,22 +3049,26 @@ extern void initialize_dirent_tail(struct ext4_dir_entry_tail *t,
>  extern int ext4_handle_dirty_dirent_node(handle_t *handle,
>  					 struct inode *inode,
>  					 struct buffer_head *bh);
> -#define S_SHIFT 12
> -static const unsigned char ext4_type_by_mode[(S_IFMT >> S_SHIFT) + 1] = {
> -	[S_IFREG >> S_SHIFT]	= EXT4_FT_REG_FILE,
> -	[S_IFDIR >> S_SHIFT]	= EXT4_FT_DIR,
> -	[S_IFCHR >> S_SHIFT]	= EXT4_FT_CHRDEV,
> -	[S_IFBLK >> S_SHIFT]	= EXT4_FT_BLKDEV,
> -	[S_IFIFO >> S_SHIFT]	= EXT4_FT_FIFO,
> -	[S_IFSOCK >> S_SHIFT]	= EXT4_FT_SOCK,
> -	[S_IFLNK >> S_SHIFT]	= EXT4_FT_SYMLINK,
> -};
>  
>  static inline void ext4_set_de_type(struct super_block *sb,
>  				struct ext4_dir_entry_2 *de,
>  				umode_t mode) {
> +	/*
> +	 * compile-time asserts that generic FT_x types still match
> +	 * EXT4_FT_x types
> +	 */
> +	BUILD_BUG_ON(EXT4_FT_UNKNOWN != FT_UNKNOWN);
> +	BUILD_BUG_ON(EXT4_FT_REG_FILE != FT_REG_FILE);
> +	BUILD_BUG_ON(EXT4_FT_DIR != FT_DIR);
> +	BUILD_BUG_ON(EXT4_FT_CHRDEV != FT_CHRDEV);
> +	BUILD_BUG_ON(EXT4_FT_BLKDEV != FT_BLKDEV);
> +	BUILD_BUG_ON(EXT4_FT_FIFO != FT_FIFO);
> +	BUILD_BUG_ON(EXT4_FT_SOCK != FT_SOCK);
> +	BUILD_BUG_ON(EXT4_FT_SYMLINK != FT_SYMLINK);
> +	BUILD_BUG_ON(EXT4_FT_MAX != FT_MAX);
> +
>  	if (ext4_has_feature_filetype(sb))
> -		de->file_type = ext4_type_by_mode[(mode & S_IFMT)>>S_SHIFT];
> +		de->file_type = fs_umode_to_ftype(mode);
>  }
>  
>  /* readpages.c */
> -- 
> 2.19.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
