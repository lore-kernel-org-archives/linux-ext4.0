From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [RFC] [patch 1/2] i_version update - vfs part
Date: Mon, 14 May 2007 14:56:56 -0700
Message-ID: <1179179817.3772.16.camel@dyn9047017103.beaverton.ibm.com>
References: <1179140698.7733.3.camel@frecb002711.frec.bull.fr>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: jean-noel.cordenner@bull.net
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:32887 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653AbXENV47 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 May 2007 17:56:59 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l4ELuwxi008360
	for <linux-ext4@vger.kernel.org>; Mon, 14 May 2007 17:56:58 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4ELuwxf192904
	for <linux-ext4@vger.kernel.org>; Mon, 14 May 2007 15:56:58 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4ELuw0t020110
	for <linux-ext4@vger.kernel.org>; Mon, 14 May 2007 15:56:58 -0600
In-Reply-To: <1179140698.7733.3.camel@frecb002711.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 2007-05-14 at 13:04 +0200, Cordenner jean noel wrote:
> Concerning the first part of the set, the i_version field of the inode
> structure has been reused. The field  has been redefined from unsigned
> long to unsigned long long as the counter has to be 64bit.
> 
Since this chnged the vfs layer inode structure, it would be better to
send this patch to the linux-fsdev list for a wider review.

The unsigned long long could still be 32 bit on 32 bit arch though.


> Signed-off-by: Jean Noel Cordenner <jean-noel.cordenner@bull.net>
> 
> fs/binfmt_misc.c   |    1 +
> fs/libfs.c         |    9 +++++++++
> fs/pipe.c          |    1 +
> include/linux/fs.h |    2 +-
> 
> Index: linux-2.6.21-rc4-i_version/fs/binfmt_misc.c
> ===================================================================
> --- linux-2.6.21-rc4-i_version.orig/fs/binfmt_misc.c	2007-05-10 14:14:48.000000000 +0200
> +++ linux-2.6.21-rc4-i_version/fs/binfmt_misc.c	2007-05-10 14:18:45.000000000 +0200
> @@ -508,6 +508,7 @@
>  		inode->i_blocks = 0;
>  		inode->i_atime = inode->i_mtime = inode->i_ctime =
>  			current_fs_time(inode->i_sb);
> +		inode->i_version = 1;
>  	}
>  	return inode;
>  }
> Index: linux-2.6.21-rc4-i_version/fs/libfs.c
> ===================================================================
> --- linux-2.6.21-rc4-i_version.orig/fs/libfs.c	2007-05-10 14:14:48.000000000 +0200
> +++ linux-2.6.21-rc4-i_version/fs/libfs.c	2007-05-10 17:26:13.000000000 +0200
> @@ -223,6 +223,7 @@
>  	root->i_mode = S_IFDIR | S_IRUSR | S_IWUSR;
>  	root->i_uid = root->i_gid = 0;
>  	root->i_atime = root->i_mtime = root->i_ctime = CURRENT_TIME;
> +	root->i_version = 1;
>  	dentry = d_alloc(NULL, &d_name);
>  	if (!dentry) {
>  		iput(root);
> @@ -246,6 +247,8 @@
>  	struct inode *inode = old_dentry->d_inode;
> 
>  	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
> +	inode->i_version++;
> +	dir->i_version++;
>  	inc_nlink(inode);
>  	atomic_inc(&inode->i_count);
>  	dget(dentry);
> @@ -278,6 +281,8 @@
>  	struct inode *inode = dentry->d_inode;
> 
>  	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
> +	inode->i_version++;
> +	dir->i_version++;
>  	drop_nlink(inode);
>  	dput(dentry);
>  	return 0;
> @@ -314,6 +319,8 @@
> 
>  	old_dir->i_ctime = old_dir->i_mtime = new_dir->i_ctime =
>  		new_dir->i_mtime = inode->i_ctime = CURRENT_TIME;
> +	old_dir->i_version++;
> +	new_dir->i_version++;
> 
>  	return 0;
>  }
> @@ -380,6 +387,7 @@
>  	inode->i_uid = inode->i_gid = 0;
>  	inode->i_blocks = 0;
>  	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
> +	inode->i_version = 1;
>  	inode->i_op = &simple_dir_inode_operations;
>  	inode->i_fop = &simple_dir_operations;
>  	inode->i_nlink = 2;
> @@ -401,6 +409,7 @@
>  		inode->i_uid = inode->i_gid = 0;
>  		inode->i_blocks = 0;
>  		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
> +		inode->i_version = 1;
>  		inode->i_fop = files->ops;
>  		inode->i_ino = i;
>  		d_add(dentry, inode);
> Index: linux-2.6.21-rc4-i_version/fs/pipe.c
> ===================================================================
> --- linux-2.6.21-rc4-i_version.orig/fs/pipe.c	2007-05-10 14:14:48.000000000 +0200
> +++ linux-2.6.21-rc4-i_version/fs/pipe.c	2007-05-10 14:18:45.000000000 +0200
> @@ -872,6 +872,7 @@
>  	inode->i_uid = current->fsuid;
>  	inode->i_gid = current->fsgid;
>  	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
> +	inode->i_version = 1;
> 
>  	return inode;
> 
> Index: linux-2.6.21-rc4-i_version/include/linux/fs.h
> ===================================================================
> --- linux-2.6.21-rc4-i_version.orig/include/linux/fs.h	2007-04-26 16:23:59.000000000 +0200
> +++ linux-2.6.21-rc4-i_version/include/linux/fs.h	2007-05-10 17:23:38.000000000 +0200
> @@ -536,7 +536,7 @@
>  	uid_t			i_uid;
>  	gid_t			i_gid;
>  	dev_t			i_rdev;
> -	unsigned long		i_version;
> +	unsigned long long	i_version;
>  	loff_t			i_size;
>  #ifdef __NEED_I_SIZE_ORDERED
>  	seqcount_t		i_size_seqcount;
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
