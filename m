From: Mingming <cmm@us.ibm.com>
Subject: Re: [PATCH 3/3] ext4: Convert to generic reserved quota's space
 management.
Date: Wed, 09 Dec 2009 16:16:34 -0800
Message-ID: <1260404194.4018.543.camel@mingming-laptop>
References: <1260324686-15863-1-git-send-email-dmonakhov@openvz.org>
	 <1260324686-15863-2-git-send-email-dmonakhov@openvz.org>
	 <1260324686-15863-3-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com,
	jack@suse.cz
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:34187 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758931AbZLJAQs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Dec 2009 19:16:48 -0500
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e33.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id nBA0E1Mf027414
	for <linux-ext4@vger.kernel.org>; Wed, 9 Dec 2009 17:14:01 -0700
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id nBA0GahV154012
	for <linux-ext4@vger.kernel.org>; Wed, 9 Dec 2009 17:16:37 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id nBA0GaUr024451
	for <linux-ext4@vger.kernel.org>; Wed, 9 Dec 2009 17:16:36 -0700
In-Reply-To: <1260324686-15863-3-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2009-12-09 at 05:11 +0300, Dmitry Monakhov wrote:
> - ext4_getattr() not longer required
>  - ext4_get_reserved_space() not longer required
>  - drop i_block_reservation_lock before vfs_dq_reserve_block().
>    this fix http://bugzilla.kernel.org/show_bug.cgi?id=14739diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 26d3cf8..6198751 100644
> 

How about split this patch to just drop i_block_reservation_lock before
vfs_dq_reserve_block()? This deadlock could be fixed right away without
depending on the rest of the VFS changes you proposed.

Mingming
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/ext4.h  |    2 -
>  fs/ext4/file.c  |    1 -
>  fs/ext4/inode.c |   67 +++++++++++++-----------------------------------------
>  fs/ext4/super.c |    1 -
>  4 files changed, 16 insertions(+), 55 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 26d3cf8..6198751 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1407,8 +1407,6 @@ int ext4_get_block(struct inode *inode, sector_t iblock,
>  extern struct inode *ext4_iget(struct super_block *, unsigned long);
>  extern int  ext4_write_inode(struct inode *, int);
>  extern int  ext4_setattr(struct dentry *, struct iattr *);
> -extern int  ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
> -				struct kstat *stat);
>  extern void ext4_delete_inode(struct inode *);
>  extern int  ext4_sync_inode(handle_t *, struct inode *);
>  extern void ext4_dirty_inode(struct inode *);
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 9630583..36a75e7 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -151,7 +151,6 @@ const struct file_operations ext4_file_operations = {
>  const struct inode_operations ext4_file_inode_operations = {
>  	.truncate	= ext4_truncate,
>  	.setattr	= ext4_setattr,
> -	.getattr	= ext4_getattr,
>  #ifdef CONFIG_EXT4_FS_XATTR
>  	.setxattr	= generic_setxattr,
>  	.getxattr	= generic_getxattr,
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index cc4737e..9a27505 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1048,17 +1048,6 @@ out:
>  	return err;
>  }
> 
> -qsize_t ext4_get_reserved_space(struct inode *inode)
> -{
> -	unsigned long long total;
> -
> -	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
> -	total = EXT4_I(inode)->i_reserved_data_blocks +
> -		EXT4_I(inode)->i_reserved_meta_blocks;
> -	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> -
> -	return (total << inode->i_blkbits);
> -}
>  /*
>   * Calculate the number of metadata blocks need to reserve
>   * to allocate @blocks for non extent file based file
> @@ -1852,19 +1841,8 @@ repeat:
>  	md_needed = mdblocks - EXT4_I(inode)->i_reserved_meta_blocks;
>  	total = md_needed + nrblocks;
> 
> -	/*
> -	 * Make quota reservation here to prevent quota overflow
> -	 * later. Real quota accounting is done at pages writeout
> -	 * time.
> -	 */
> -	if (vfs_dq_reserve_block(inode, total)) {
> -		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> -		return -EDQUOT;
> -	}
> -
>  	if (ext4_claim_free_blocks(sbi, total)) {
>  		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> -		vfs_dq_release_reservation_block(inode, total);
>  		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
>  			yield();
>  			goto repeat;
> @@ -1872,10 +1850,24 @@ repeat:
>  		return -ENOSPC;
>  	}
>  	EXT4_I(inode)->i_reserved_data_blocks += nrblocks;
> -	EXT4_I(inode)->i_reserved_meta_blocks = mdblocks;
> +	EXT4_I(inode)->i_reserved_meta_blocks += md_needed;
> +	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> +
> +	/*
> +	 * Make quota reservation here to prevent quota overflow
> +	 * later. Real quota accounting is done at pages writeout
> +	 * time.
> +	 */
> +	if (!vfs_dq_reserve_block(inode, total))
> +		return 0;       /* success */
> 
> +	/* Quota reservation has failed, revert inode's reservation */
> +	percpu_counter_sub(&sbi->s_dirtyblocks_counter, total);
> +	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
> +	EXT4_I(inode)->i_reserved_data_blocks -= nrblocks;
> +	EXT4_I(inode)->i_reserved_meta_blocks -= md_needed;
>  	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> -	return 0;       /* success */
> +	return -EDQUOT;
>  }
> 
>  static void ext4_da_release_space(struct inode *inode, int to_free)
> @@ -5511,33 +5503,6 @@ err_out:
>  	return error;
>  }
> 
> -int ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
> -		 struct kstat *stat)
> -{
> -	struct inode *inode;
> -	unsigned long delalloc_blocks;
> -
> -	inode = dentry->d_inode;
> -	generic_fillattr(inode, stat);
> -
> -	/*
> -	 * We can't update i_blocks if the block allocation is delayed
> -	 * otherwise in the case of system crash before the real block
> -	 * allocation is done, we will have i_blocks inconsistent with
> -	 * on-disk file blocks.
> -	 * We always keep i_blocks updated together with real
> -	 * allocation. But to not confuse with user, stat
> -	 * will return the blocks that include the delayed allocation
> -	 * blocks for this file.
> -	 */
> -	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
> -	delalloc_blocks = EXT4_I(inode)->i_reserved_data_blocks;
> -	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> -
> -	stat->blocks += (delalloc_blocks << inode->i_sb->s_blocksize_bits)>>9;
> -	return 0;
> -}
> -
>  static int ext4_indirect_trans_blocks(struct inode *inode, int nrblocks,
>  				      int chunk)
>  {
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 4c87d97..d87c7f7 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1007,7 +1007,6 @@ static const struct dquot_operations ext4_quota_operations = {
>  	.reserve_space	= dquot_reserve_space,
>  	.claim_space	= dquot_claim_space,
>  	.release_rsv	= dquot_release_reserved_space,
> -	.get_reserved_space = ext4_get_reserved_space,
>  	.alloc_inode	= dquot_alloc_inode,
>  	.free_space	= dquot_free_space,
>  	.free_inode	= dquot_free_inode,


