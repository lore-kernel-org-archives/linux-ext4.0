From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 1/2]  i_version update - vfs part
Date: Fri, 05 Oct 2007 17:58:41 -0700
Message-ID: <1191632321.3861.77.camel@localhost.localdomain>
References: <1191598088.24615.45.camel@frecb002711.frec.bull.fr>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: jean-noel.cordenner@bull.net
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:54910 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764807AbXJFA7J (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Oct 2007 20:59:09 -0400
In-Reply-To: <1191598088.24615.45.camel@frecb002711.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2007-10-05 at 17:28 +0200, Cordenner jean noel wrote:
> Hi, 
> 
Hi Jean Noel,

> This is an update of the i_version patch. 

Just to make sure, is this vfs patch and next ext4 patch together going
to replace the 4 inode-version related patches currently in
ext4-patch-queue (and git tree)? 

> The i_version field is a 64bit counter that is set on every inode 
> creation and that is incremented every time the inode data is modified 
> (similarly to the "ctime" time-stamp). 
> The aim is to fulfill a NFSv4 requirement for rfc3530: 
> "5.5.  Mandatory Attributes - Definitions 
> Name        #    DataType   Access   Description 
> ___________________________________________________________________ 
> change        3    uint64       READ     A value created by the 
>         server that the client can use to determine if file 
>         data, directory contents or attributes of the object 
>         have been modified.  The servermay return the object's 
>         time_metadata attribute for this attribute's value but 
>         only if the filesystem object can not be updated more 
>         frequently than the resolution of time_metadata. 
> "
> 
> This first part deals with adding a flag in the super block and incrementing the i_version in the vfs.
> 
> Signed-off-by: Jean Noel Cordenner <jean-noel.cordenner@bull.net>
> --- 
>  fs/inode.c         |   23 +++++++++++++++++++++++
>  fs/libfs.c         |   12 ++++++++++++
>  include/linux/fs.h |    3 +++
>  3 files changed, 38 insertions(+)
> 
> Index: linux-2.6.23-rc8-ext4-i_version/fs/inode.c
> ===================================================================
> --- linux-2.6.23-rc8-ext4-i_version.orig/fs/inode.c	2007-09-26 14:41:41.000000000 +0200
> +++ linux-2.6.23-rc8-ext4-i_version/fs/inode.c	2007-10-05 16:14:41.000000000 +0200
> @@ -1216,6 +1216,24 @@
>  EXPORT_SYMBOL(touch_atime);
> 
>  /**
> + *	inode_inc_iversion	-	increments i_version
> + *	@inode: inode that need to be updated
> + *
> + *	Every time the inode is modified, the i_version field
> + *	will be incremented.
> + *	The filesystem has to be mounted with i_version flag
> + *
> + */
> +
> +void inode_inc_iversion(struct inode *inode)
> +{
> +	spin_lock(&inode->i_lock);
> +	inode->i_version++;
> +	spin_unlock(&inode->i_lock);
> +}

I suspect we need a lock here,  the places where need to update the
inode->i_version are already doing update for inode, mostly protected by
i_mutex. 

You could remove the above function and update the counter directly at
the places it need to.

> +EXPORT_SYMBOL(inode_inc_iversion);
> +

Seems unnecessary.

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
> Index: linux-2.6.23-rc8-ext4-i_version/fs/libfs.c
> ===================================================================
> --- linux-2.6.23-rc8-ext4-i_version.orig/fs/libfs.c	2007-07-09 01:32:17.000000000 +0200
> +++ linux-2.6.23-rc8-ext4-i_version/fs/libfs.c	2007-09-26 14:51:08.000000000 +0200
> @@ -255,6 +255,10 @@
>  	struct inode *inode = old_dentry->d_inode;
> 
>  	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
> +	if (IS_I_VERSION(inode)) {
> +		inode_inc_iversion(inode);
> +		inode_inc_iversion(dir);
> +	}
>  	inc_nlink(inode);
>  	atomic_inc(&inode->i_count);
>  	dget(dentry);
> @@ -287,6 +291,10 @@
>  	struct inode *inode = dentry->d_inode;
> 
>  	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
> +	if (IS_I_VERSION(inode)) {
> +		inode_inc_iversion(inode);
> +		inode_inc_iversion(dir);
> +	}
>  	drop_nlink(inode);
>  	dput(dentry);
>  	return 0;
> @@ -323,6 +331,10 @@
> 
>  	old_dir->i_ctime = old_dir->i_mtime = new_dir->i_ctime =
>  		new_dir->i_mtime = inode->i_ctime = CURRENT_TIME;
> +	if (IS_I_VERSION(old_dir)) {
> +		inode_inc_iversion(old_dir);
> +		inode_inc_iversion(new_dir);
> +	}
> 
>  	return 0;
>  }

Need to update the counter in libfs.c?

> Index: linux-2.6.23-rc8-ext4-i_version/include/linux/fs.h
> ===================================================================
> --- linux-2.6.23-rc8-ext4-i_version.orig/include/linux/fs.h	2007-09-26 14:46:15.000000000 +0200
> +++ linux-2.6.23-rc8-ext4-i_version/include/linux/fs.h	2007-09-26 14:51:08.000000000 +0200
> @@ -123,6 +123,7 @@
>  #define MS_SLAVE	(1<<19)	/* change to slave */
>  #define MS_SHARED	(1<<20)	/* change to shared */
>  #define MS_RELATIME	(1<<21)	/* Update atime relative to mtime/ctime. */
> +#define MS_I_VERSION	(1<<22)	/* Update inode i_version field */
>  #define MS_ACTIVE	(1<<30)
>  #define MS_NOUSER	(1<<31)
> 
> @@ -172,6 +173,7 @@
>  					((inode)->i_flags & (S_SYNC|S_DIRSYNC)))
>  #define IS_MANDLOCK(inode)	__IS_FLG(inode, MS_MANDLOCK)
>  #define IS_NOATIME(inode)   __IS_FLG(inode, MS_RDONLY|MS_NOATIME)
> +#define IS_I_VERSION(inode)	__IS_FLG(inode, MS_I_VERSION)
> 
>  #define IS_NOQUOTA(inode)	((inode)->i_flags & S_NOQUOTA)
>  #define IS_APPEND(inode)	((inode)->i_flags & S_APPEND)
> @@ -1284,6 +1286,7 @@
>  	mark_inode_dirty(inode);
>  }
> 
> +extern void inode_inc_iversion(struct inode *inode);
>  extern void touch_atime(struct vfsmount *mnt, struct dentry *dentry);
>  static inline void file_accessed(struct file *file)
>  {
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
