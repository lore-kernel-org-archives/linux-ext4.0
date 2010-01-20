From: Mingming <cmm@us.ibm.com>
Subject: Re: [PATCH] Add flag to files with blocks intentionally past EOF
Date: Tue, 19 Jan 2010 16:46:17 -0800
Message-ID: <1263948377.3954.2.camel@mingming-laptop>
References: <4B5627EF.3080804@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:40110 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab0ATAqY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Jan 2010 19:46:24 -0500
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com [9.17.195.226])
	by e38.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id o0K0f6Si021853
	for <linux-ext4@vger.kernel.org>; Tue, 19 Jan 2010 17:41:06 -0700
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o0K0kJ25175172
	for <linux-ext4@vger.kernel.org>; Tue, 19 Jan 2010 17:46:19 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o0K0kI5s012118
	for <linux-ext4@vger.kernel.org>; Tue, 19 Jan 2010 17:46:18 -0700
In-Reply-To: <4B5627EF.3080804@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2010-01-19 at 15:45 -0600, Eric Sandeen wrote:
> From: Jiaying Zhang <jiayingz@google.com>
> 
> fallocate() may potentially instantiate blocks past EOF, depending
> on the flags used when it is called.
> 
> e2fsck currently has a test for blocks past i_size, and it
> sometimes trips up - noticeably on xfstests 013 which runs fsstress.
> 
> This patch from Jiayang does fix it up for me - it (along with
> e2fsprogs updates and other patches recently from Aneesh) has
> survived many fsstress runs in a row.
> 
> The setattr interface may also be used to clear the flag and remove
> any blocks past EOF.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> (just resending this since it probably got lost in the previous
> thread - Jiaying didn't have a SOB line, but maybe that should
> be added.  I have included the proper From: line for authorship)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 874d169..4c7cd9b 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -284,10 +284,11 @@ struct flex_groups {
>  #define EXT4_TOPDIR_FL			0x00020000 /* Top of directory hierarchies*/
>  #define EXT4_HUGE_FILE_FL               0x00040000 /* Set to each huge file */
>  #define EXT4_EXTENTS_FL			0x00080000 /* Inode uses extents */
> +#define EXT4_EOFBLOCKS_FL		0x00400000 /* Blocks allocated beyond EOF (bit reserved in fs.h) */
>  #define EXT4_RESERVED_FL		0x80000000 /* reserved for ext4 lib */
> 
> -#define EXT4_FL_USER_VISIBLE		0x000BDFFF /* User visible flags */
> -#define EXT4_FL_USER_MODIFIABLE		0x000B80FF /* User modifiable flags */
> +#define EXT4_FL_USER_VISIBLE		0x004BDFFF /* User visible flags */
> +#define EXT4_FL_USER_MODIFIABLE		0x004B80FF /* User modifiable flags */
> 
>  /* Flags that should be inherited by new inodes from their parent. */
>  #define EXT4_FL_INHERITED (EXT4_SECRM_FL | EXT4_UNRM_FL | EXT4_COMPR_FL |\
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 765a482..e7d5ba2 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3185,7 +3185,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
>  {
>  	struct ext4_ext_path *path = NULL;
>  	struct ext4_extent_header *eh;
> -	struct ext4_extent newex, *ex;
> +	struct ext4_extent newex, *ex, *last_ex;
>  	ext4_fsblk_t newblock;
>  	int err = 0, depth, ret, cache_type;
>  	unsigned int allocated = 0;
> @@ -3366,6 +3366,14 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
>  					EXT4_STATE_DIO_UNWRITTEN;;
>  		}
>  	}
> +
> +	if (unlikely(inode->i_flags & EXT4_EOFBLOCKS_FL)) {
> +		BUG_ON(!eh->eh_entries);

Perhaps BUG_ON() is too strong? Maybe add some warning messages first.

> +		last_ex = EXT_LAST_EXTENT(eh);
> +		if (iblock + ar.len > le32_to_cpu(last_ex->ee_block)
> +					+ ext4_ext_get_actual_len(last_ex))
> +			inode->i_flags &= ~EXT4_EOFBLOCKS_FL;
> +	}
>  	err = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
>  	if (err) {
>  		/* free data blocks we just allocated */
> @@ -3499,6 +3507,13 @@ static void ext4_falloc_update_inode(struct inode *inode,
>  			i_size_write(inode, new_size);
>  		if (new_size > EXT4_I(inode)->i_disksize)
>  			ext4_update_i_disksize(inode, new_size);
> +	} else {
> +		/*
> +		 * Mark that we allocate beyond EOF so the subsequent truncate
> +		 * can proceed even if the new size is the same as i_size.
> +		 */
> +		if (new_size > i_size_read(inode))
> +			inode->i_flags |= EXT4_EOFBLOCKS_FL;
>  	}
> 
>  }
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index cbf56da..bc31ea6 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4429,6 +4429,8 @@ void ext4_truncate(struct inode *inode)
>  	if (!ext4_can_truncate(inode))
>  		return;
> 
> +	inode->i_flags &= ~EXT4_EOFBLOCKS_FL;
> +
>  	if (inode->i_size == 0 && !test_opt(inode->i_sb, NO_AUTO_DA_ALLOC))
>  		ei->i_state |= EXT4_STATE_DA_ALLOC_CLOSE;
> 
> @@ -4741,8 +4743,8 @@ void ext4_get_inode_flags(struct ext4_inode_info *ei)
>  {
>  	unsigned int flags = ei->vfs_inode.i_flags;
> 
> -	ei->i_flags &= ~(EXT4_SYNC_FL|EXT4_APPEND_FL|
> -			EXT4_IMMUTABLE_FL|EXT4_NOATIME_FL|EXT4_DIRSYNC_FL);
> +	ei->i_flags &= ~(EXT4_SYNC_FL|EXT4_APPEND_FL|EXT4_IMMUTABLE_FL|
> +			EXT4_NOATIME_FL|EXT4_DIRSYNC_FL|EXT4_EOFBLOCKS_FL);
>  	if (flags & S_SYNC)
>  		ei->i_flags |= EXT4_SYNC_FL;
>  	if (flags & S_APPEND)
> @@ -4753,6 +4755,8 @@ void ext4_get_inode_flags(struct ext4_inode_info *ei)
>  		ei->i_flags |= EXT4_NOATIME_FL;
>  	if (flags & S_DIRSYNC)
>  		ei->i_flags |= EXT4_DIRSYNC_FL;
> +	if (flags & FS_EOFBLOCKS_FL)
> +		ei->i_flags |= EXT4_EOFBLOCKS_FL;
>  }
> 
>  static blkcnt_t ext4_inode_blocks(struct ext4_inode *raw_inode,
> @@ -5284,7 +5288,9 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
>  	}
> 
>  	if (S_ISREG(inode->i_mode) &&
> -	    attr->ia_valid & ATTR_SIZE && attr->ia_size < inode->i_size) {
> +	    attr->ia_valid & ATTR_SIZE &&
> +	    (attr->ia_size < inode->i_size ||
> +	     (inode->i_flags & EXT4_EOFBLOCKS_FL))) {
>  		handle_t *handle;
> 
>  		handle = ext4_journal_start(inode, 3);
> @@ -5315,6 +5321,11 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
>  				goto err_out;
>  			}
>  		}
> +		if ((inode->i_flags & EXT4_EOFBLOCKS_FL)) {
> +			rc = vmtruncate(inode, attr->ia_size);
> +			if (rc)
> +				goto err_out;
> +		}
>  	}
> 

I am a little lost why doing vmtruncate here...

>  	rc = inode_setattr(inode, attr);
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index b63d193..71f578e 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -92,6 +92,16 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  			flags &= ~EXT4_EXTENTS_FL;
>  		}
> 
> +		if (flags & EXT4_EOFBLOCKS_FL) {
> +			/* we don't support adding EOFBLOCKS flag */
> +			if (!(oldflags & EXT4_EOFBLOCKS_FL)) {
> +				err = -EOPNOTSUPP;
> +				goto flags_out;
> +			}
> +		} else if (oldflags & EXT4_EOFBLOCKS_FL)
> +			/* free the space reserved with fallocate KEEPSIZE */
> +			vmtruncate(inode, inode->i_size);
> +
>  		handle = ext4_journal_start(inode, 1);
>  		if (IS_ERR(handle)) {
>  			err = PTR_ERR(handle);

And here...
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 9147ca8..db3ffb6 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -349,10 +349,11 @@ struct inodes_stat_t {
>  #define FS_TOPDIR_FL			0x00020000 /* Top of directory hierarchies*/
>  #define FS_EXTENT_FL			0x00080000 /* Extents */
>  #define FS_DIRECTIO_FL			0x00100000 /* Use direct i/o */
> +#define FS_EOFBLOCKS_FL			0x00400000 /* Blocks allocated beyond EOF */
>  #define FS_RESERVED_FL			0x80000000 /* reserved for ext2 lib */
> 
> -#define FS_FL_USER_VISIBLE		0x0003DFFF /* User visible flags */
> -#define FS_FL_USER_MODIFIABLE		0x000380FF /* User modifiable flags */
> +#define FS_FL_USER_VISIBLE		0x0043DFFF /* User visible flags */
> +#define FS_FL_USER_MODIFIABLE		0x004380FF /* User modifiable flags */
> 
> 
>  #define SYNC_FILE_RANGE_WAIT_BEFORE	1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


