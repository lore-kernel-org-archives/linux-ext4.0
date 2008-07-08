From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: delayed allocation i_blocks fix for stat(2)
Date: Mon, 07 Jul 2008 20:11:08 -0500
Message-ID: <4872BEAC.7010007@redhat.com>
References: <1215473799.6702.9.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:43126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754679AbYGHBLL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Jul 2008 21:11:11 -0400
In-Reply-To: <1215473799.6702.9.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Mingming Cao wrote:
> ext4: delayed allocation i_blocks fix for stat(2)
> 
> From: Mingming Cao <cmm@us.ibm.com>
> 
> Right now i_blocks is not getting updated until the disks are actually
> allocaed on disk.  This means with delayed allocation, right after files
> are copied, "ls -sF" shoes the file as taking 0 blocks on disk.  "du"
> also shows the files taking zero space, which is highly confusing to the user.
> 
> Since current delayed allocation already keep track of per-inode total number
> of blocks that are subject to delayed allocation, this patch fix this by using
> that to adjust the value returned by stat(2). When real block allocation
> is done, the i_blocks will get updated. Since the reserved blocks for delayed
> allocation will be decreased, this will be keep value returned by stat(2)
> consistent.
> 
> Signed-off-by: Mingming Cao <cmm@us.ibm.com>

Thanks Mingming, looks like just the right approach.

Something about the spinlock for every stat seems heavy-handed to me but
I'll have to give that more thought.  :)

-Eric

> ---
>  fs/ext4/ext4.h  |    2 ++
>  fs/ext4/file.c  |    1 +
>  fs/ext4/inode.c |   26 ++++++++++++++++++++++++++
>  3 files changed, 29 insertions(+)
> 
> Index: linux-2.6.26-rc9/fs/ext4/ext4.h
> ===================================================================
> --- linux-2.6.26-rc9.orig/fs/ext4/ext4.h	2008-07-07 16:29:23.000000000 -0700
> +++ linux-2.6.26-rc9/fs/ext4/ext4.h	2008-07-07 16:32:54.000000000 -0700
> @@ -1059,6 +1059,8 @@ int ext4_get_blocks_handle(handle_t *han
>  extern struct inode *ext4_iget(struct super_block *, unsigned long);
>  extern int  ext4_write_inode (struct inode *, int);
>  extern int  ext4_setattr (struct dentry *, struct iattr *);
> +extern int  ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
> +				struct kstat *stat);
>  extern void ext4_delete_inode (struct inode *);
>  extern int  ext4_sync_inode (handle_t *, struct inode *);
>  extern void ext4_discard_reservation (struct inode *);
> Index: linux-2.6.26-rc9/fs/ext4/file.c
> ===================================================================
> --- linux-2.6.26-rc9.orig/fs/ext4/file.c	2008-07-07 16:29:21.000000000 -0700
> +++ linux-2.6.26-rc9/fs/ext4/file.c	2008-07-07 16:29:51.000000000 -0700
> @@ -161,6 +161,7 @@ const struct file_operations ext4_file_o
>  const struct inode_operations ext4_file_inode_operations = {
>  	.truncate	= ext4_truncate,
>  	.setattr	= ext4_setattr,
> +	.getattr	= ext4_getattr,
>  #ifdef CONFIG_EXT4DEV_FS_XATTR
>  	.setxattr	= generic_setxattr,
>  	.getxattr	= generic_getxattr,
> Index: linux-2.6.26-rc9/fs/ext4/inode.c
> ===================================================================
> --- linux-2.6.26-rc9.orig/fs/ext4/inode.c	2008-07-07 16:29:22.000000000 -0700
> +++ linux-2.6.26-rc9/fs/ext4/inode.c	2008-07-07 16:31:13.000000000 -0700
> @@ -4203,6 +4203,32 @@ err_out:
>  	return error;
>  }
>  
> +int ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
> +		 struct kstat *stat)
> +{
> +	struct inode *inode;
> +	unsigned long delalloc_blocks;
> +
> +	inode = dentry->d_inode;
> +	generic_fillattr(inode, stat);
> +
> +	/*
> +	 * We can't update i_blocks if the block allocation is delayed
> +	 * otherwise in the case of system crash before the real block
> +	 * allocation is done, we will have i_blocks inconsistent with
> +	 * on-disk file blocks.
> +	 * We always keep i_blocks updated together with real
> +	 * allocation. But to not confuse with user, stat
> +	 * will return the blocks that include the delayed allocation
> +	 * blocks for this file.
> +	 */
> +	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
> +	delalloc_blocks = EXT4_I(inode)->i_reserved_data_blocks;
> +	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> +
> +	stat->blocks += (delalloc_blocks << inode->i_sb->s_blocksize_bits)>>9;
> +	return 0;
> +}
>  
>  /*
>   * How many blocks doth make a writepage()?
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

