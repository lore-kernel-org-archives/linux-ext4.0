From: Mingming <cmm@us.ibm.com>
Subject: Re: [PATCH] ext3: quota macros cleanup
Date: Tue, 08 Dec 2009 15:32:29 -0800
Message-ID: <1260315149.4206.1520.camel@mingming-laptop>
References: <1260254781-18041-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:54934 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936998AbZLHXce (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Dec 2009 18:32:34 -0500
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e34.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id nB8NRFj4018287
	for <linux-ext4@vger.kernel.org>; Tue, 8 Dec 2009 16:27:15 -0700
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id nB8NWV38151144
	for <linux-ext4@vger.kernel.org>; Tue, 8 Dec 2009 16:32:33 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id nB8NWUbT000390
	for <linux-ext4@vger.kernel.org>; Tue, 8 Dec 2009 16:32:31 -0700
In-Reply-To: <1260254781-18041-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2009-12-08 at 09:46 +0300, Dmitry Monakhov wrote:
> Currently all quota block reservation macros contains hardcoded "2"
> aka MAXQUOTAS value. This is no good because in some places it is not
> obvious to understand what does this digit represent. Let's introduce
> new macro with self descriptive name.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext3/inode.c          |    8 ++++----
>  fs/ext3/namei.c          |    8 ++++----
>  include/linux/ext3_jbd.h |    7 +++++--
>  3 files changed, 13 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> index 354ed3b..1c99eba 100644
> --- a/fs/ext3/inode.c
> +++ b/fs/ext3/inode.c
> @@ -970,7 +970,7 @@ static int ext3_get_block(struct inode *inode, sector_t iblock,
>  		if (max_blocks > DIO_MAX_BLOCKS)
>  			max_blocks = DIO_MAX_BLOCKS;
>  		handle = ext3_journal_start(inode, DIO_CREDITS +
> -				2 * EXT3_QUOTA_TRANS_BLOCKS(inode->i_sb));
> +				EXT3_ALL_QUOTAS_TRANS_BLOCKS(inode->i_sb));
>  		if (IS_ERR(handle)) {
>  			ret = PTR_ERR(handle);
>  			goto out;
> @@ -3136,8 +3136,8 @@ int ext3_setattr(struct dentry *dentry, struct iattr *attr)
> 
>  		/* (user+group)*(old+new) structure, inode write (sb,
>  		 * inode block, ? - but truncate inode update has it) */
> -		handle = ext3_journal_start(inode, 2*(EXT3_QUOTA_INIT_BLOCKS(inode->i_sb)+
> -					EXT3_QUOTA_DEL_BLOCKS(inode->i_sb))+3);
> +		handle = ext3_journal_start(inode, EXT3_ALL_QUOTAS_INIT_BLOCKS(inode->i_sb)+
> +					EXT3_QUOTA_DEL_BLOCKS(inode->i_sb)+3);
>  		if (IS_ERR(handle)) {
>  			error = PTR_ERR(handle);
>  			goto err_out;
> @@ -3229,7 +3229,7 @@ static int ext3_writepage_trans_blocks(struct inode *inode)
>  #ifdef CONFIG_QUOTA
>  	/* We know that structure was already allocated during vfs_dq_init so
>  	 * we will be updating only the data blocks + inodes */
> -	ret += 2*EXT3_QUOTA_TRANS_BLOCKS(inode->i_sb);
> +	ret += EXT3_ALL_QUOTAS_TRANS_BLOCKS(inode->i_sb);
>  #endif
> 
>  	return ret;
> diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
> index aad6400..5c1b676 100644
> --- a/fs/ext3/namei.c
> +++ b/fs/ext3/namei.c
> @@ -1699,7 +1699,7 @@ static int ext3_create (struct inode * dir, struct dentry * dentry, int mode,
>  retry:
>  	handle = ext3_journal_start(dir, EXT3_DATA_TRANS_BLOCKS(dir->i_sb) +
>  					EXT3_INDEX_EXTRA_TRANS_BLOCKS + 3 +
> -					2*EXT3_QUOTA_INIT_BLOCKS(dir->i_sb));
> +					EXT3_ALL_QUOTAS_INIT_BLOCKS(dir->i_sb));
>  	if (IS_ERR(handle))
>  		return PTR_ERR(handle);
> 
> @@ -1733,7 +1733,7 @@ static int ext3_mknod (struct inode * dir, struct dentry *dentry,
>  retry:
>  	handle = ext3_journal_start(dir, EXT3_DATA_TRANS_BLOCKS(dir->i_sb) +
>  					EXT3_INDEX_EXTRA_TRANS_BLOCKS + 3 +
> -					2*EXT3_QUOTA_INIT_BLOCKS(dir->i_sb));
> +					EXT3_ALL_QUOTAS_INIT_BLOCKS(dir->i_sb));
>  	if (IS_ERR(handle))
>  		return PTR_ERR(handle);
> 
> @@ -1769,7 +1769,7 @@ static int ext3_mkdir(struct inode * dir, struct dentry * dentry, int mode)
>  retry:
>  	handle = ext3_journal_start(dir, EXT3_DATA_TRANS_BLOCKS(dir->i_sb) +
>  					EXT3_INDEX_EXTRA_TRANS_BLOCKS + 3 +
> -					2*EXT3_QUOTA_INIT_BLOCKS(dir->i_sb));
> +					EXT3_ALL_QUOTAS_INIT_BLOCKS(dir->i_sb));
>  	if (IS_ERR(handle))
>  		return PTR_ERR(handle);
> 
> @@ -2175,7 +2175,7 @@ static int ext3_symlink (struct inode * dir,
>  retry:
>  	handle = ext3_journal_start(dir, EXT3_DATA_TRANS_BLOCKS(dir->i_sb) +
>  					EXT3_INDEX_EXTRA_TRANS_BLOCKS + 5 +
> -					2*EXT3_QUOTA_INIT_BLOCKS(dir->i_sb));
> +					EXT3_ALL_QUOTAS_INIT_BLOCKS(dir->i_sb));
>  	if (IS_ERR(handle))
>  		return PTR_ERR(handle);
> 
> diff --git a/include/linux/ext3_jbd.h b/include/linux/ext3_jbd.h
> index cf82d51..40dd8bd 100644
> --- a/include/linux/ext3_jbd.h
> +++ b/include/linux/ext3_jbd.h
> @@ -44,13 +44,13 @@
> 
>  #define EXT3_DATA_TRANS_BLOCKS(sb)	(EXT3_SINGLEDATA_TRANS_BLOCKS + \
>  					 EXT3_XATTR_TRANS_BLOCKS - 2 + \
> -					 2*EXT3_QUOTA_TRANS_BLOCKS(sb))
> +					 EXT3_ALL_QUOTAS_TRANS_BLOCKS(sb))
> 
>  /* Delete operations potentially hit one directory's namespace plus an
>   * entire inode, plus arbitrary amounts of bitmap/indirection data.  Be
>   * generous.  We can grow the delete transaction later if necessary. */
> 
> -#define EXT3_DELETE_TRANS_BLOCKS(sb)	(2 * EXT3_DATA_TRANS_BLOCKS(sb) + 64)
> +#define EXT3_DELETE_TRANS_BLOCKS(sb)   (EXT3_ALL_QUOTAS_TRANS_BLOCKS(sb) + 64)
> 
>  /* Define an arbitrary limit for the amount of data we will anticipate
>   * writing to any given transaction.  For unbounded transactions such as
> @@ -86,6 +86,9 @@
>  #define EXT3_QUOTA_INIT_BLOCKS(sb) 0
>  #define EXT3_QUOTA_DEL_BLOCKS(sb) 0
>  #endif
> +#define EXT3_ALL_QUOTAS_TRANS_BLOCKS(sb) (MAXQUOTAS*EXT3_QUOTA_TRANS_BLOCKS(sb))
> +#define EXT3_ALL_QUOTAS_INIT_BLOCKS(sb) (MAXQUOTAS*EXT3_QUOTA_INIT_BLOCKS(sb))
> +#define EXT3_ALL_QUOTAS_DEL_BLOCKS(sb) (MAXQUOTAS*EXT3_QUOTA_DEL_BLOCKS(sb))
> 

Any reason not to use the same micro name in the corresponding ext4
micros cleanup patch?
>  int
>  ext3_mark_iloc_dirty(handle_t *handle,


