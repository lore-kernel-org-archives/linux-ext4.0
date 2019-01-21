Return-Path: <SRS0=MuWy=P5=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D4E8C2F3D5
	for <linux-ext4@archiver.kernel.org>; Mon, 21 Jan 2019 14:20:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28BDE20861
	for <linux-ext4@archiver.kernel.org>; Mon, 21 Jan 2019 14:20:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729941AbfAUOUx (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 21 Jan 2019 09:20:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:46084 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729714AbfAUOUu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 21 Jan 2019 09:20:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 78B6DAF1F;
        Mon, 21 Jan 2019 14:20:48 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 2D7C41E1584; Mon, 21 Jan 2019 15:20:48 +0100 (CET)
Date:   Mon, 21 Jan 2019 15:20:48 +0100
From:   Jan Kara <jack@suse.cz>
To:     Phillip Potter <phil@philpotter.co.uk>
Cc:     tytso@mit.edu, amir73il@gmail.com, viro@zeniv.linux.org.uk,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [RFC][PATCH v5 07/09] ext4: use common file type conversion
Message-ID: <20190121142048.GB21694@quack2.suse.cz>
References: <20190121005435.GA32365@pathfinder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190121005435.GA32365@pathfinder>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon 21-01-19 00:54:35, Phillip Potter wrote:
> Deduplicate the ext4 file type conversion implementation and define
> EXT4_FT_* to match shared FT_* - file systems that use the same file
> types as defined by POSIX do not need to define their own versions
> and can use the common helper functions decared in fs_types.h and
> implemented in fs_types.c
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Phillip Potter <phil@philpotter.co.uk>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/ext4.h | 37 ++++++++++++-------------------------
>  1 file changed, 12 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 185a05d3257e..f43d002a30fd 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1925,16 +1925,16 @@ struct ext4_dir_entry_tail {
>   * Ext4 directory file types.  Only the low 3 bits are used.  The
>   * other bits are reserved for now.
>   */
> -#define EXT4_FT_UNKNOWN		0
> -#define EXT4_FT_REG_FILE	1
> -#define EXT4_FT_DIR		2
> -#define EXT4_FT_CHRDEV		3
> -#define EXT4_FT_BLKDEV		4
> -#define EXT4_FT_FIFO		5
> -#define EXT4_FT_SOCK		6
> -#define EXT4_FT_SYMLINK		7
> +#define EXT4_FT_UNKNOWN		FT_UNKNOWN
> +#define EXT4_FT_REG_FILE	FT_REG_FILE
> +#define EXT4_FT_DIR		FT_DIR
> +#define EXT4_FT_CHRDEV		FT_CHRDEV
> +#define EXT4_FT_BLKDEV		FT_BLKDEV
> +#define EXT4_FT_FIFO		FT_FIFO
> +#define EXT4_FT_SOCK		FT_SOCK
> +#define EXT4_FT_SYMLINK		FT_SYMLINK
>  
> -#define EXT4_FT_MAX		8
> +#define EXT4_FT_MAX		FT_MAX
>  
>  #define EXT4_FT_DIR_CSUM	0xDE
>  
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
> @@ -3065,22 +3062,12 @@ extern void initialize_dirent_tail(struct ext4_dir_entry_tail *t,
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
>  	if (ext4_has_feature_filetype(sb))
> -		de->file_type = ext4_type_by_mode[(mode & S_IFMT)>>S_SHIFT];
> +		de->file_type = fs_umode_to_ftype(mode);
>  }
>  
>  /* readpages.c */
> -- 
> 2.20.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
