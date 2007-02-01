From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [Resubmit][PATCH 4/5] Secure Deletion and Trash-Bin Support
	for Ext4
Date: Thu, 01 Feb 2007 12:43:09 -0800
Message-ID: <1170362589.4271.34.camel@localhost.localdomain>
References: <Pine.GSO.4.53.0701310954240.28263@compserv1>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, ezk@cs.sunysb.edu, kolya@cs.sunysb.edu
To: Harry Papaxenopoulos <harry@cs.sunysb.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:59929 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423002AbXBAUnL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Feb 2007 15:43:11 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.12.11.20060308/8.13.8) with ESMTP id l11Kh2mO016133
	for <linux-ext4@vger.kernel.org>; Thu, 1 Feb 2007 15:43:02 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l11KhAbM521906
	for <linux-ext4@vger.kernel.org>; Thu, 1 Feb 2007 13:43:10 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l11KhAEi011388
	for <linux-ext4@vger.kernel.org>; Thu, 1 Feb 2007 13:43:10 -0700
In-Reply-To: <Pine.GSO.4.53.0701310954240.28263@compserv1>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2007-01-31 at 09:55 -0500, Harry Papaxenopoulos wrote:

> @@ -2077,6 +2079,10 @@ static int ext4_unlink(struct inode * di
>  	struct buffer_head * bh;
>  	struct ext4_dir_entry_2 * de;
>  	handle_t *handle;
> +	int trashed = 0;
> +#ifdef CONFIG_EXT4DEV_FS_TRASHBIN
> +	struct dentry *user_dentry = NULL;
> +#endif
> 
>  	/* Initialize quotas before so that eventual writes go
>  	 * in separate transaction */
> @@ -2105,13 +2111,41 @@ static int ext4_unlink(struct inode * di
>  			      inode->i_ino, inode->i_nlink);
>  		inode->i_nlink = 1;
>  	}
> -	retval = ext4_delete_entry(handle, dir, de, bh);
> +#ifdef CONFIG_EXT4DEV_FS_TRASHBIN
> +	if ((dentry->d_inode->i_sb->s_flags & MNT_TRASHBIN) &&
> +				(EXT4_I(dentry->d_inode)->i_flags &
> +				(EXT4_UNRM_FL | EXT4_SECRM_FL))) {
> +
> +		/*
> +		 * We put this code here to optimize the common case. Since
> +		 * lookups are expensive, we try to reserve from making any,
> +		 * unless one of the trash-bin flags are set. The cleanest
> +		 * way though is to probably move this code outside the
> +		 * above if statement.
> +		 */
> +		user_dentry = vfs_get_user_dentry(dir, 1);
> +		if (IS_ERR(user_dentry)) {
> +			retval = PTR_ERR(user_dentry);
> +			user_dentry = NULL;
> +			goto end_unlink;
> +		}
> +
> +		if (inode->i_nlink == 1 && user_dentry->d_inode &&
> +			   	user_dentry->d_inode->i_ino != dir->i_ino) {
> +			retval = vfs_trash_entry(dir, dentry);
> +			trashed = 1;
> +		}
> +	}
> +#endif
> +	if (!trashed)
> +		retval = ext4_delete_entry(handle, dir, de, bh);
>  	if (retval)
>  		goto end_unlink;
>  	dir->i_ctime = dir->i_mtime = CURRENT_TIME_SEC;
>  	ext4_update_dx_flag(dir);
>  	ext4_mark_inode_dirty(handle, dir);
> -	drop_nlink(inode);
> +	if (!trashed)
> +		drop_nlink(inode);
>  	if (!inode->i_nlink)
>  		ext4_orphan_add(handle, inode);
>  	inode->i_ctime = dir->i_ctime;
> @@ -2121,6 +2155,10 @@ static int ext4_unlink(struct inode * di
>  end_unlink:
>  	ext4_journal_stop(handle);
>  	brelse (bh);
> +#ifdef CONFIG_EXT4DEV_FS_TRASHBIN
> +	if (user_dentry)
> +		dput(user_dentry);
> +#endif
>  	return retval;
>  }

I feel we could move the trash bin feature check at the beginning of
ext4_unlink() call, we don't need to start a journal and find the entry
at all if we are going to move that file to trash bin, that's all
handles by rename.

Mingming
