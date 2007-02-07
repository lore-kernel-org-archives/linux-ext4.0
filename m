From: Suparna Bhattacharya <suparna@in.ibm.com>
Subject: Re: Testing ext4 persistent preallocation patches for 64 bit features
Date: Wed, 7 Feb 2007 16:06:22 +0530
Message-ID: <20070207103622.GA6328@in.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070207074801.GA5419@amitarora.in.ibm.com> <1170836750.4355.36.camel@localhost.localdomain>
Reply-To: suparna@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	alex@clusterfs.com, suzuki@in.ibm.com
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1170836750.4355.36.camel@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Feb 07, 2007 at 12:25:50AM -0800, Mingming Cao wrote:
> On Wed, 2007-02-07 at 13:18 +0530, Amit K. Arora wrote:
> > I plan to test the persistent preallocation patches on a huge sparse
> > device, to know if >32 bit physical block numbers (upto 48bit) behave as
> > expected.
> Thanks!
> 
> 
> >  I have following questions for this and will appreciate
> > suggestions here:
> 
> > c) Do I need to put some hack in the filesystem code for above (to
> > allocate >32 bit physical block numbers) ?
> > 
> 
> I had a ext3 hack patch before to allow application specify which block
> group is the targeted block allocation group,using ioctl command, so to
> allocate >32 bit physical block numbers it just set the target block
> group beyond 2**(32-15) = 2**17. patch is below..
> 
> BTW, have you considered
> - move the preallocation code in ioctl to a seperate function, and call
> that function from ioctl? That way we could easily switch to
> posix_falloc later.

Good suggestion.

> - Test preallocation with mapped IO?
> - disable preallocation if the filesystem free blocks is under some low
> watermarks, to save space for near future real block allocation?

A policy decision like this is probably worth a discussion during today's call.

> - is de-preallocation something worth doing?

Wouldn't truncate do that ? 
Or you thinking of something like hole punching ?

Regards
Suparna


> 
> Mingming
> 
> ---
> 
>  linux-2.6.16-ming/fs/ext3/balloc.c          |   24 ++++++++++++++---------
>  linux-2.6.16-ming/fs/ext3/ioctl.c           |   29 ++++++++++++++++++++++++++++
>  linux-2.6.16-ming/include/linux/ext3_fs.h   |    1 
>  linux-2.6.16-ming/include/linux/ext3_fs_i.h |    1 
>  4 files changed, 46 insertions(+), 9 deletions(-)
> 
> diff -puN fs/ext3/ioctl.c~ext3_set_alloc_blk_group_hack fs/ext3/ioctl.c
> --- linux-2.6.16/fs/ext3/ioctl.c~ext3_set_alloc_blk_group_hack	2006-03-28 15:19:58.000000000 -0800
> +++ linux-2.6.16-ming/fs/ext3/ioctl.c	2006-03-28 15:54:14.507288400 -0800
> @@ -22,6 +22,7 @@ int ext3_ioctl (struct inode * inode, st
>  	struct ext3_inode_info *ei = EXT3_I(inode);
>  	unsigned int flags;
>  	unsigned short rsv_window_size;
> +	unsigned int blk_group;
> 
>  	ext3_debug ("cmd = %u, arg = %lu\n", cmd, arg);
> 
> @@ -193,6 +194,34 @@ flags_err:
>  		mutex_unlock(&ei->truncate_mutex);
>  		return 0;
>  	}
> +	case EXT3_IOC_SETALLOCBLKGRP: {
> +
> +		if (!test_opt(inode->i_sb, RESERVATION) ||!S_ISREG(inode->i_mode))
> +			return -ENOTTY;
> +
> +		if (IS_RDONLY(inode))
> +			return -EROFS;
> +
> +		if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
> +			return -EACCES;
> +
> +		if (get_user(blk_group, (int __user *)arg))
> +			return -EFAULT;
> +
> +		/*
> +		 * need to allocate reservation structure for this inode
> +		 * before set the window size
> +		 */
> +		mutex_lock(&ei->truncate_mutex);
> +		if (!ei->i_block_alloc_info)
> +			ext3_init_block_alloc_info(inode);
> +
> +		if (ei->i_block_alloc_info){
> +			ei->i_block_alloc_info->goal_block_group = blk_group;
> +		}
> +		mutex_unlock(&ei->truncate_mutex);
> +		return 0;
> +	}
>  	case EXT3_IOC_GROUP_EXTEND: {
>  		unsigned long n_blocks_count;
>  		struct super_block *sb = inode->i_sb;
> diff -puN include/linux/ext3_fs.h~ext3_set_alloc_blk_group_hack include/linux/ext3_fs.h
> --- linux-2.6.16/include/linux/ext3_fs.h~ext3_set_alloc_blk_group_hack	2006-03-28 15:42:51.000000000 -0800
> +++ linux-2.6.16-ming/include/linux/ext3_fs.h	2006-03-28 15:51:48.321237417 -0800
> @@ -238,6 +238,7 @@ struct ext3_new_group_data {
>  #endif
>  #define EXT3_IOC_GETRSVSZ		_IOR('f', 5, long)
>  #define EXT3_IOC_SETRSVSZ		_IOW('f', 6, long)
> +#define EXT3_IOC_SETALLOCBLKGRP		_IOW('f', 9, long)
> 
>  /*
>   *  Mount options
> diff -puN include/linux/ext3_fs_i.h~ext3_set_alloc_blk_group_hack include/linux/ext3_fs_i.h
> --- linux-2.6.16/include/linux/ext3_fs_i.h~ext3_set_alloc_blk_group_hack	2006-03-28 15:43:59.000000000 -0800
> +++ linux-2.6.16-ming/include/linux/ext3_fs_i.h	2006-03-28 15:47:54.274367219 -0800
> @@ -51,6 +51,7 @@ struct ext3_block_alloc_info {
>  	 * allocation when we detect linearly ascending requests.
>  	 */
>  	__u32                   last_alloc_physical_block;
> +	__u32			goal_block_group;
>  };
> 
>  #define rsv_start rsv_window._rsv_start
> diff -puN fs/ext3/balloc.c~ext3_set_alloc_blk_group_hack fs/ext3/balloc.c
> --- linux-2.6.16/fs/ext3/balloc.c~ext3_set_alloc_blk_group_hack	2006-03-28 15:45:30.000000000 -0800
> +++ linux-2.6.16-ming/fs/ext3/balloc.c	2006-03-28 16:03:55.770850040 -0800
> @@ -285,6 +285,7 @@ void ext3_init_block_alloc_info(struct i
>  		rsv->rsv_alloc_hit = 0;
>  		block_i->last_alloc_logical_block = 0;
>  		block_i->last_alloc_physical_block = 0;
> +		block_i->goal_block_group = 0;
>  	}
>  	ei->i_block_alloc_info = block_i;
>  }
> @@ -1263,15 +1264,20 @@ unsigned long ext3_new_blocks(handle_t *
>  		*errp = -ENOSPC;
>  		goto out;
>  	}
> -
> -	/*
> -	 * First, test whether the goal block is free.
> -	 */
> -	if (goal < le32_to_cpu(es->s_first_data_block) ||
> -	    goal >= le32_to_cpu(es->s_blocks_count))
> -		goal = le32_to_cpu(es->s_first_data_block);
> -	group_no = (goal - le32_to_cpu(es->s_first_data_block)) /
> -			EXT3_BLOCKS_PER_GROUP(sb);
> +	if (block_i->goal_block_group) {
> +		group_no = block_i->goal_block_group;
> +		goal = le32_to_cpu(EXT3_SB(sb)->s_es->s_first_data_block) +                                group_no * EXT3_BLOCKS_PER_GROUP(sb);
> +		block_i->goal_block_group = 0;
> +	} else {
> +		/*
> +		 * First, test whether the goal block is free.
> +		 */
> +		if (goal < le32_to_cpu(es->s_first_data_block) ||
> +		    goal >= le32_to_cpu(es->s_blocks_count))
> +			goal = le32_to_cpu(es->s_first_data_block);
> +		group_no = (goal - le32_to_cpu(es->s_first_data_block)) /
> +				EXT3_BLOCKS_PER_GROUP(sb);
> +	}
>  	gdp = ext3_get_group_desc(sb, group_no, &gdp_bh);
>  	if (!gdp)
>  		goto io_error;
> 
> _
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Suparna Bhattacharya (suparna@in.ibm.com)
Linux Technology Center
IBM Software Lab, India

