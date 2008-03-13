From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: Fail migrate if we allocated new blocks via mmap
	write.
Date: Thu, 13 Mar 2008 16:02:52 -0700
Message-ID: <1205449373.3642.14.camel@localhost.localdomain>
References: <1205397487-16040-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, adilger@sun.com, jack@suse.cz,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:34239 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462AbYCMWC6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Mar 2008 18:02:58 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m2DM4uou005524
	for <linux-ext4@vger.kernel.org>; Thu, 13 Mar 2008 18:04:56 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2DM2uqZ110498
	for <linux-ext4@vger.kernel.org>; Thu, 13 Mar 2008 18:02:56 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m2DM2tFF030846
	for <linux-ext4@vger.kernel.org>; Thu, 13 Mar 2008 18:02:55 -0400
In-Reply-To: <1205397487-16040-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2008-03-13 at 14:08 +0530, Aneesh Kumar K.V wrote:
> If we write to holes in the file via mmap, we endup allocating
> new blocks. This block allocation happens without taking inode->i_mutex.
> Since migrate is protected by i_mutex and migrate expect no
> new blocks get allocated during migrate, fail migrate if new blocks
> get allocated.
> 
> We can't take inode->i_mutex in the mmap write path because that
> would result in a locking order violation between i_mutex and mmap_sem.
> Also adding a seprate rw_sempahore for protecion is really high overhead
> for a rare operation such as migrate.
> 

Hi Aneesh,

Thanks for the update. I like this approach...some comments below.

> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/inode.c         |   17 ++++++++++++-----
>  fs/ext4/migrate.c       |   28 +++++++++++++++++++++++++---
>  include/linux/ext4_fs.h |    1 +
>  3 files changed, 38 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 059f2fc..f947251 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -986,6 +986,16 @@ int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
>  		retval = ext4_get_blocks_handle(handle, inode, block,
>  				max_blocks, bh, create, extend_disksize);
>  	}
> +
> +	if (retval > 0) {
> +		/*
> +		 * We allocated new blocks which will result in i_data
> +		 * format to change.  Force the migrate to fail by
> +		 * clearing migrate flags
> +		 */
> +		EXT4_I(inode)->i_flags = EXT4_I(inode)->i_flags &
> +							~EXT4_EXT_MIGRATE;
> +	}

We probably need to check buffer_new() for the resulting bh, as retval >
0 doesn't necessarily means ext4_ext_get_blocks() allocated new blocks.

And I think this check should only for ext3 type files, maybe checking
the flag or move the "if" right after ext4_get_blocks_handle()?

>  	up_write((&EXT4_I(inode)->i_data_sem));
>  	return retval;
>  }
> @@ -2962,7 +2972,8 @@ static int ext4_do_update_inode(handle_t *handle,
>  	if (ext4_inode_blocks_set(handle, raw_inode, ei))
>  		goto out_brelse;
>  	raw_inode->i_dtime = cpu_to_le32(ei->i_dtime);
> -	raw_inode->i_flags = cpu_to_le32(ei->i_flags);
> +	/* clear the migrate flag in the raw_inode */
> +	raw_inode->i_flags = cpu_to_le32(ei->i_flags & ~EXT4_EXT_MIGRATE);

Do we need to save this flag on-disk?

>  	if (EXT4_SB(inode->i_sb)->s_es->s_creator_os !=
>  	    cpu_to_le32(EXT4_OS_HURD))
>  		raw_inode->i_file_acl_high =
> @@ -3502,9 +3513,5 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page)
>  	 * access and zero out the page. The journal handle get initialized
>  	 * in ext4_get_block.
>  	 */
> -	/* FIXME!! should we take inode->i_mutex ? Currently we can't because
> -	 * it has a circular locking dependency with DIO. But migrate expect
> -	 * i_mutex to ensure no i_data changes
> -	 */
>  	return block_page_mkwrite(vma, page, ext4_get_block);

If you update this patch, how about split this part to a separate fix
and merge that with it's parent ext4-page-mkwrite() patch? 

>  }
> diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
> index 5c1e27d..f4c9e78 100644
> --- a/fs/ext4/migrate.c
> +++ b/fs/ext4/migrate.c
> @@ -327,7 +327,7 @@ static int free_ind_block(handle_t *handle, struct inode *inode, __le32 *i_data)
>  }
> 
>  static int ext4_ext_swap_inode_data(handle_t *handle, struct inode *inode,
> -				struct inode *tmp_inode)
> +						struct inode *tmp_inode)
>  {
>  	int retval;
>  	__le32	i_data[3];
> @@ -351,6 +351,18 @@ static int ext4_ext_swap_inode_data(handle_t *handle, struct inode *inode,
> 
>  	down_write(&EXT4_I(inode)->i_data_sem);
>  	/*
> +	 * if EXT4_EXT_MIGRATE is cleared a block allocation
> +	 * happened after we started the migrate. We need to
> +	 * fail the migrate
> +	 */
> +	if (!(EXT4_I(inode)->i_flags & EXT4_EXT_MIGRATE)) {
> +		retval = -EAGAIN;
> +		up_write(&EXT4_I(inode)->i_data_sem);
> +		goto err_out;
> +	} else
> +		EXT4_I(inode)->i_flags = EXT4_I(inode)->i_flags &
> +							~EXT4_EXT_MIGRATE;
> +	/*

I could not see the caller of ext4_ext_swap_inode_data():
ext4_ext_mirgrate() checks the return value from
ext4_ext_swap_inode_data(). We probably should free allocated blocks,
rebuild the extents tree for the tmp inode and do the swap again in the
EAGAIN case. And for other error case probably need proper error
handling too.


>  	 * We have the extent map build with the tmp inode.
>  	 * Now copy the i_data across
>  	 */
> @@ -508,6 +520,17 @@ int ext4_ext_migrate(struct inode *inode, struct file *filp,
>  	 * switch the inode format to prevent read.
>  	 */
>  	mutex_lock(&(inode->i_mutex));
> +	/*
> +	 * Even though we take i_mutex we can still cause block allocation
> +	 * via mmap write to holes. If we have allocated new blocks we fail
> +	 * migrate. New block allocation will clear EXT4_EXT_MIGRATE flag
> +	 * The flag is updated with i_data_sem held to prevent racing with
> +	 * block allocation.
> +	 */
> +	down_read((&EXT4_I(inode)->i_data_sem));
> +	EXT4_I(inode)->i_flags = EXT4_I(inode)->i_flags | EXT4_EXT_MIGRATE;
> +	up_read((&EXT4_I(inode)->i_data_sem));
> +

I wonder if online defrag could use this flag to protect race issue...

>  	handle = ext4_journal_start(inode, 1);
> 
>  	ei = EXT4_I(inode);
> @@ -560,8 +583,7 @@ err_out:
>  		 */
>  		free_ext_block(handle, tmp_inode);
>  	else
> -		retval = ext4_ext_swap_inode_data(handle, inode,
> -							tmp_inode);
> +		retval = ext4_ext_swap_inode_data(handle, inode, tmp_inode);
> 
>  	/* We mark the tmp_inode dirty via ext4_ext_tree_init. */
>  	if (ext4_journal_extend(handle, 1) != 0)
> diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
> index 8f5a563..2d15f16 100644
> --- a/include/linux/ext4_fs.h
> +++ b/include/linux/ext4_fs.h
> @@ -240,6 +240,7 @@ struct flex_groups {
>  #define EXT4_TOPDIR_FL			0x00020000 /* Top of directory hierarchies*/
>  #define EXT4_HUGE_FILE_FL               0x00040000 /* Set to each huge file */
>  #define EXT4_EXTENTS_FL			0x00080000 /* Inode uses extents */
> +#define EXT4_EXT_MIGRATE		0x00100000 /* Inode is migrating */
>  #define EXT4_RESERVED_FL		0x80000000 /* reserved for ext4 lib */
> 
>  #define EXT4_FL_USER_VISIBLE		0x000BDFFF /* User visible flags */

Regards,
Mingming

