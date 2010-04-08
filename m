From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: random performance optimizations for ext4_setattr
Date: Thu, 08 Apr 2010 10:33:46 -0500
Message-ID: <4BBDF75A.1060903@redhat.com>
References: <1270715363-10958-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932339Ab0DHPdv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Apr 2010 11:33:51 -0400
In-Reply-To: <1270715363-10958-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dmitry Monakhov wrote:
> If quota is not enabled it is not necessery to start separate
> transaction for uid, gid and quota credits changes.
> 
> If inode wasn't added to orphan list when it is not necessary
> to remove it from the list. This allow to avoid locking on
> per-sb s_orphan_lock mutex.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/inode.c |   15 ++++++++++++---
>  1 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 3996151..b498274 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5418,6 +5418,7 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
>  {
>  	struct inode *inode = dentry->d_inode;
>  	int error, rc = 0;
> +	int orphan = 0;
>  	const unsigned int ia_valid = attr->ia_valid;
>  
>  	error = inode_change_ok(inode, attr);
> @@ -5426,8 +5427,13 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
>  
>  	if (ia_valid & ATTR_SIZE)
>  		dquot_initialize(inode);
> -	if ((ia_valid & ATTR_UID && attr->ia_uid != inode->i_uid) ||
> -		(ia_valid & ATTR_GID && attr->ia_gid != inode->i_gid)) {
> +	/*
> +	 * If quota is active when uig, git and quota's credits must

lame spell-check review ;)

"uid, gid, and ..."

-Eric

> +	 * being changed in the one transaction.
> +	*/
> +	if (sb_any_quota_active(inode->i_sb) && !IS_NOQUOTA(inode) && (
> +		(ia_valid & ATTR_UID && attr->ia_uid != inode->i_uid) ||
> +		(ia_valid & ATTR_GID && attr->ia_gid != inode->i_gid))) {
>  		handle_t *handle;
>  
>  		/* (user+group)*(old+new) structure, inode write (sb,
> @@ -5477,6 +5483,7 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
>  		}
>  
>  		error = ext4_orphan_add(handle, inode);
> +		orphan = 1;
>  		EXT4_I(inode)->i_disksize = attr->ia_size;
>  		rc = ext4_mark_inode_dirty(handle, inode);
>  		if (!error)
> @@ -5491,9 +5498,11 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
>  				handle = ext4_journal_start(inode, 3);
>  				if (IS_ERR(handle)) {
>  					ext4_orphan_del(NULL, inode);
> +					orphan = 0;
>  					goto err_out;
>  				}
>  				ext4_orphan_del(handle, inode);
> +				orphan = 0;
>  				ext4_journal_stop(handle);
>  				goto err_out;
>  			}
> @@ -5508,7 +5517,7 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
>  	/* If inode_setattr's call to ext4_truncate failed to get a
>  	 * transaction handle at all, we need to clean up the in-core
>  	 * orphan list manually. */
> -	if (inode->i_nlink)
> +	if (orphan && inode->i_nlink)
>  		ext4_orphan_del(NULL, inode);
>  
>  	if (!rc && (ia_valid & ATTR_MODE))

