From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] fix up vfs inode version patch for modules
Date: Mon, 03 Dec 2007 10:00:34 -0800
Message-ID: <1196704834.4022.2.camel@localhost.localdomain>
References: <474DD0A6.9010809@redhat.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:33945 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754AbXLCSBK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Dec 2007 13:01:10 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id lB3I0YuX007039
	for <linux-ext4@vger.kernel.org>; Mon, 3 Dec 2007 13:00:34 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lB3I0YsU076680
	for <linux-ext4@vger.kernel.org>; Mon, 3 Dec 2007 13:00:34 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lB3I0YcO030082
	for <linux-ext4@vger.kernel.org>; Mon, 3 Dec 2007 13:00:34 -0500
In-Reply-To: <474DD0A6.9010809@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2007-11-28 at 14:33 -0600, Eric Sandeen wrote:
> ext4 calls inode_inc_iversion(), but it's not exported, so modular ext4
> has trouble.  Any reason not to just make it an inline, as below?
> 

I agree.

Mingming
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> ---
> 
> Index: linux-2.6.24-rc1/fs/inode.c
> ===================================================================
> --- linux-2.6.24-rc1.orig/fs/inode.c
> +++ linux-2.6.24-rc1/fs/inode.c
> @@ -1243,23 +1243,6 @@ void touch_atime(struct vfsmount *mnt, s
>  EXPORT_SYMBOL(touch_atime);
> 
>  /**
> - *     inode_inc_iversion      -       increments i_version
> - *     @inode: inode that need to be updated
> - *
> - *     Every time the inode is modified, the i_version field
> - *     will be incremented.
> - *     The filesystem has to be mounted with i_version flag
> - *
> - */
> -
> -void inode_inc_iversion(struct inode *inode)
> -{
> -	spin_lock(&inode->i_lock);
> -	inode->i_version++;
> -	spin_unlock(&inode->i_lock);
> -}
> -
> -/**
>   *	file_update_time	-	update mtime and ctime time
>   *	@file: file accessed
>   *
> Index: linux-2.6.24-rc1/include/linux/fs.h
> ===================================================================
> --- linux-2.6.24-rc1.orig/include/linux/fs.h
> +++ linux-2.6.24-rc1/include/linux/fs.h
> @@ -1396,7 +1396,21 @@ static inline void inode_dec_link_count(
>  	mark_inode_dirty(inode);
>  }
> 
> -extern void inode_inc_iversion(struct inode *inode);
> +/**
> + * inode_inc_iversion - increments i_version
> + * @inode: inode that need to be updated
> + *
> + * Every time the inode is modified, the i_version field will be incremented.
> + * The filesystem has to be mounted with i_version flag
> + */
> +
> +static inline void inode_inc_iversion(struct inode *inode)
> +{
> +       spin_lock(&inode->i_lock);
> +       inode->i_version++;
> +       spin_unlock(&inode->i_lock);
> +}
> +
>  extern void touch_atime(struct vfsmount *mnt, struct dentry *dentry);
>  static inline void file_accessed(struct file *file)
>  {
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
