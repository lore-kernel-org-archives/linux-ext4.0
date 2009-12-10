From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: quota macros cleanup [V2]
Date: Thu, 10 Dec 2009 17:03:12 +0100
Message-ID: <20091210160312.GF26516@atrey.karlin.mff.cuni.cz>
References: <1260317131-13562-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59693 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760905AbZLJQDG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Dec 2009 11:03:06 -0500
Content-Disposition: inline
In-Reply-To: <1260317131-13562-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Currently all quota block reservation macros contains hardcoded "2"
> aka MAXQUOTAS value. This is no good because in some places it is not
> obvious to understand what does this digit represent. Let's introduce
> new macro with self descriptive name.
  OK, merged this cleanup together with the next patch.

								Honza

> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext3/inode.c          |    8 ++++----
>  fs/ext3/namei.c          |    8 ++++----
>  include/linux/ext3_jbd.h |    7 +++++--
>  3 files changed, 13 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> index 354ed3b..d8951fb 100644
> --- a/fs/ext3/inode.c
> +++ b/fs/ext3/inode.c
> @@ -970,7 +970,7 @@ static int ext3_get_block(struct inode *inode, sector_t iblock,
>  		if (max_blocks > DIO_MAX_BLOCKS)
>  			max_blocks = DIO_MAX_BLOCKS;
>  		handle = ext3_journal_start(inode, DIO_CREDITS +
> -				2 * EXT3_QUOTA_TRANS_BLOCKS(inode->i_sb));
> +				EXT3_MAXQUOTAS_TRANS_BLOCKS(inode->i_sb));
>  		if (IS_ERR(handle)) {
>  			ret = PTR_ERR(handle);
>  			goto out;
> @@ -3136,8 +3136,8 @@ int ext3_setattr(struct dentry *dentry, struct iattr *attr)
>  
>  		/* (user+group)*(old+new) structure, inode write (sb,
>  		 * inode block, ? - but truncate inode update has it) */
> -		handle = ext3_journal_start(inode, 2*(EXT3_QUOTA_INIT_BLOCKS(inode->i_sb)+
> -					EXT3_QUOTA_DEL_BLOCKS(inode->i_sb))+3);
> +		handle = ext3_journal_start(inode, EXT3_MAXQUOTAS_INIT_BLOCKS(inode->i_sb)+
> +					EXT3_QUOTA_DEL_BLOCKS(inode->i_sb)+3);
>  		if (IS_ERR(handle)) {
>  			error = PTR_ERR(handle);
>  			goto err_out;
> @@ -3229,7 +3229,7 @@ static int ext3_writepage_trans_blocks(struct inode *inode)
>  #ifdef CONFIG_QUOTA
>  	/* We know that structure was already allocated during vfs_dq_init so
>  	 * we will be updating only the data blocks + inodes */
> -	ret += 2*EXT3_QUOTA_TRANS_BLOCKS(inode->i_sb);
> +	ret += EXT3_MAXQUOTAS_TRANS_BLOCKS(inode->i_sb);
>  #endif
>  
>  	return ret;
> diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
> index aad6400..81f7348 100644
> --- a/fs/ext3/namei.c
> +++ b/fs/ext3/namei.c
> @@ -1699,7 +1699,7 @@ static int ext3_create (struct inode * dir, struct dentry * dentry, int mode,
>  retry:
>  	handle = ext3_journal_start(dir, EXT3_DATA_TRANS_BLOCKS(dir->i_sb) +
>  					EXT3_INDEX_EXTRA_TRANS_BLOCKS + 3 +
> -					2*EXT3_QUOTA_INIT_BLOCKS(dir->i_sb));
> +					EXT3_MAXQUOTAS_INIT_BLOCKS(dir->i_sb));
>  	if (IS_ERR(handle))
>  		return PTR_ERR(handle);
>  
> @@ -1733,7 +1733,7 @@ static int ext3_mknod (struct inode * dir, struct dentry *dentry,
>  retry:
>  	handle = ext3_journal_start(dir, EXT3_DATA_TRANS_BLOCKS(dir->i_sb) +
>  					EXT3_INDEX_EXTRA_TRANS_BLOCKS + 3 +
> -					2*EXT3_QUOTA_INIT_BLOCKS(dir->i_sb));
> +					EXT3_MAXQUOTAS_INIT_BLOCKS(dir->i_sb));
>  	if (IS_ERR(handle))
>  		return PTR_ERR(handle);
>  
> @@ -1769,7 +1769,7 @@ static int ext3_mkdir(struct inode * dir, struct dentry * dentry, int mode)
>  retry:
>  	handle = ext3_journal_start(dir, EXT3_DATA_TRANS_BLOCKS(dir->i_sb) +
>  					EXT3_INDEX_EXTRA_TRANS_BLOCKS + 3 +
> -					2*EXT3_QUOTA_INIT_BLOCKS(dir->i_sb));
> +					EXT3_MAXQUOTAS_INIT_BLOCKS(dir->i_sb));
>  	if (IS_ERR(handle))
>  		return PTR_ERR(handle);
>  
> @@ -2175,7 +2175,7 @@ static int ext3_symlink (struct inode * dir,
>  retry:
>  	handle = ext3_journal_start(dir, EXT3_DATA_TRANS_BLOCKS(dir->i_sb) +
>  					EXT3_INDEX_EXTRA_TRANS_BLOCKS + 5 +
> -					2*EXT3_QUOTA_INIT_BLOCKS(dir->i_sb));
> +					EXT3_MAXQUOTAS_INIT_BLOCKS(dir->i_sb));
>  	if (IS_ERR(handle))
>  		return PTR_ERR(handle);
>  
> diff --git a/include/linux/ext3_jbd.h b/include/linux/ext3_jbd.h
> index cf82d51..d7b5ddc 100644
> --- a/include/linux/ext3_jbd.h
> +++ b/include/linux/ext3_jbd.h
> @@ -44,13 +44,13 @@
>  
>  #define EXT3_DATA_TRANS_BLOCKS(sb)	(EXT3_SINGLEDATA_TRANS_BLOCKS + \
>  					 EXT3_XATTR_TRANS_BLOCKS - 2 + \
> -					 2*EXT3_QUOTA_TRANS_BLOCKS(sb))
> +					 EXT3_MAXQUOTAS_TRANS_BLOCKS(sb))
>  
>  /* Delete operations potentially hit one directory's namespace plus an
>   * entire inode, plus arbitrary amounts of bitmap/indirection data.  Be
>   * generous.  We can grow the delete transaction later if necessary. */
>  
> -#define EXT3_DELETE_TRANS_BLOCKS(sb)	(2 * EXT3_DATA_TRANS_BLOCKS(sb) + 64)
> +#define EXT3_DELETE_TRANS_BLOCKS(sb)   (EXT3_MAXQUOTAS_TRANS_BLOCKS(sb) + 64)
>  
>  /* Define an arbitrary limit for the amount of data we will anticipate
>   * writing to any given transaction.  For unbounded transactions such as
> @@ -86,6 +86,9 @@
>  #define EXT3_QUOTA_INIT_BLOCKS(sb) 0
>  #define EXT3_QUOTA_DEL_BLOCKS(sb) 0
>  #endif
> +#define EXT3_MAXQUOTAS_TRANS_BLOCKS(sb) (MAXQUOTAS*EXT3_QUOTA_TRANS_BLOCKS(sb))
> +#define EXT3_MAXQUOTAS_INIT_BLOCKS(sb) (MAXQUOTAS*EXT3_QUOTA_INIT_BLOCKS(sb))
> +#define EXT3_MAXQUOTAS_DEL_BLOCKS(sb) (MAXQUOTAS*EXT3_QUOTA_DEL_BLOCKS(sb))
>  
>  int
>  ext3_mark_iloc_dirty(handle_t *handle,
> -- 
> 1.6.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
