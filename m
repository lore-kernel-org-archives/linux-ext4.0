From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 1/2]  i_version update - vfs part
Date: Thu, 25 Oct 2007 14:05:51 -0700
Message-ID: <1193346351.4288.16.camel@localhost.localdomain>
References: <1191598088.24615.45.camel@frecb002711.frec.bull.fr>
	 <1193331870.5487.31.camel@frecb002711.frec.bull.fr>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: jean-noel.cordenner@bull.net
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:51734 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbXJYVFt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Oct 2007 17:05:49 -0400
In-Reply-To: <1193331870.5487.31.camel@frecb002711.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2007-10-25 at 19:04 +0200, Cordenner jean noel wrote:
> Hi,
> 
> This is an update of the previous patches on the ext4 git tree, the 2
> coming patches applies at the end of the current ext4-patch-queue, and
> replaces the inode-version related patches:
> 64-bit-i_version.patch
> i_version_hi.patch
> ext4_i_version_hi_2.patch
> i_version_update_ext4.patch
> 
> The first part deals with the vfs part. 
> The i_version field of the inode is changed to be a 64-bit counter that
> is set on every inode creation and that is incremented every time the
> inode data is modified (similarly to the "ctime" time-stamp). 
> The aim is to fulfill a NFSv4 requirement for rfc3530.
> This first part concerns the vfs, it converts the 32-bit i_version in
> the generic inode to a 64-bit, a flag is added in the super block in
> order to check if the feature is enabled and the i_version is
> incremented in the vfs.
> 
Thanks for reposting it.

> Index: linux-2.6.23-ext4-1/fs/inode.c
> ===================================================================
> --- linux-2.6.23-ext4-1.orig/fs/inode.c	2007-10-25 16:15:52.000000000
> +0200
> +++ linux-2.6.23-ext4-1/fs/inode.c	2007-10-25 16:25:53.000000000 +0200
> @@ -1216,6 +1216,24 @@
>  EXPORT_SYMBOL(touch_atime);
> 
>  /**
> + *     inode_inc_iversion      -       increments i_version
> + *     @inode: inode that need to be updated
> + *
> + *     Every time the inode is modified, the i_version field
> + *     will be incremented.
> + *     The filesystem has to be mounted with i_version flag
> + *
> + */
> +
> +void inode_inc_iversion(struct inode *inode)
> +{
> +	spin_lock(&inode->i_lock);
> +	inode->i_version++;
> +	spin_unlock(&inode->i_lock);
> +}

I wonder do we really need i_lock here for inode versioning update?

Understand this is a 64 bit counter, but file_update_time() and
ext4_mark_inode_dirty() (where the inode version is updated) is called
on the file write path so i_mutex should be hold all the time. As long
as the read patch holding i_mutex everything should be fine, isn't it?

Have you get a chance to check the performance impact to ext4?

> +
> +/**
>   *	file_update_time	-	update mtime and ctime time
>   *	@file: file accessed
>   *
> @@ -1249,6 +1267,11 @@
>  		sync_it = 1;
>  	}
> 
> +	if (IS_I_VERSION(inode)) {
> +		inode_inc_iversion(inode);
> +		sync_it = 1;
> +	}
> +
>  	if (sync_it)
>  		mark_inode_dirty_sync(inode);
>  }
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
