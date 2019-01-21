Return-Path: <SRS0=MuWy=P5=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B8C0C2F3D5
	for <linux-ext4@archiver.kernel.org>; Mon, 21 Jan 2019 14:21:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35AB120879
	for <linux-ext4@archiver.kernel.org>; Mon, 21 Jan 2019 14:21:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729861AbfAUOVq (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 21 Jan 2019 09:21:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:46312 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729830AbfAUOVo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 21 Jan 2019 09:21:44 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9D91DAF0B;
        Mon, 21 Jan 2019 14:21:42 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 7A2831E1584; Mon, 21 Jan 2019 15:21:41 +0100 (CET)
Date:   Mon, 21 Jan 2019 15:21:41 +0100
From:   Jan Kara <jack@suse.cz>
To:     Phillip Potter <phil@philpotter.co.uk>
Cc:     jack@suse.cz, amir73il@gmail.com, viro@zeniv.linux.org.uk,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC][PATCH v5 04/09] ext2: use common file type conversion
Message-ID: <20190121142141.GA16403@quack2.suse.cz>
References: <20190121005431.GA32343@pathfinder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190121005431.GA32343@pathfinder>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon 21-01-19 00:54:31, Phillip Potter wrote:
> Deduplicate the ext2 file type conversion implementation and remove
> EXT2_FT_* definitions - file systems that use the same file types as
> defined by POSIX do not need to define their own versions and can
> use the common helper functions decared in fs_types.h and implemented
> in fs_types.c
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Phillip Potter <phil@philpotter.co.uk>

This patch and the generic one look good to me. I'll wait couple more
days whether someone won't object to the general idea and then push these
two patches to my tree.

								Honza

> ---
>  fs/ext2/dir.c  | 35 ++++++-----------------------------
>  fs/ext2/ext2.h | 16 ----------------
>  2 files changed, 6 insertions(+), 45 deletions(-)
> 
> diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
> index 3b8114def693..13318e255ebf 100644
> --- a/fs/ext2/dir.c
> +++ b/fs/ext2/dir.c
> @@ -252,33 +252,10 @@ ext2_validate_entry(char *base, unsigned offset, unsigned mask)
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
>  	if (EXT2_HAS_INCOMPAT_FEATURE(inode->i_sb, EXT2_FEATURE_INCOMPAT_FILETYPE))
> -		de->file_type = ext2_type_by_mode[(mode & S_IFMT)>>S_SHIFT];
> +		de->file_type = fs_umode_to_ftype(inode->i_mode);
>  	else
>  		de->file_type = 0;
>  }
> @@ -293,14 +270,14 @@ ext2_readdir(struct file *file, struct dir_context *ctx)
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
> @@ -335,8 +312,8 @@ ext2_readdir(struct file *file, struct dir_context *ctx)
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
> diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
> index e770cd100a6a..93fcfe7bbb3b 100644
> --- a/fs/ext2/ext2.h
> +++ b/fs/ext2/ext2.h
> @@ -603,22 +603,6 @@ struct ext2_dir_entry_2 {
>  	char	name[];			/* File name, up to EXT2_NAME_LEN */
>  };
>  
> -/*
> - * Ext2 directory file types.  Only the low 3 bits are used.  The
> - * other bits are reserved for now.
> - */
> -enum {
> -	EXT2_FT_UNKNOWN		= 0,
> -	EXT2_FT_REG_FILE	= 1,
> -	EXT2_FT_DIR		= 2,
> -	EXT2_FT_CHRDEV		= 3,
> -	EXT2_FT_BLKDEV		= 4,
> -	EXT2_FT_FIFO		= 5,
> -	EXT2_FT_SOCK		= 6,
> -	EXT2_FT_SYMLINK		= 7,
> -	EXT2_FT_MAX
> -};
> -
>  /*
>   * EXT2_DIR_PAD defines the directory entries boundaries
>   *
> -- 
> 2.20.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
