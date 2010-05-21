From: Andreas Dilger <andreas.dilger@oracle.com>
Subject: Re: [PATCH 2/2] ext4: Fix compat EXT4_IOC_ADD_GROUP
Date: Thu, 20 May 2010 22:41:20 -0600
Message-ID: <63042D4C-90AA-4A3D-A5DC-C0ADF4BF9DDE@oracle.com>
References: <1274398223.2257.0.camel@localhost> <1274398462.2257.7.camel@localhost>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	linux-ext4@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:31475 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab0EUEme convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 May 2010 00:42:34 -0400
In-Reply-To: <1274398462.2257.7.camel@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-05-20, at 17:34, Ben Hutchings wrote:
> struct ext4_new_group_input needs to be converted because u64 has
> only 32-bit alignment on some 32-bit architectures, notably i386.

Sigh, it would have been nice to catch this when ext4_new_group_input was first created.

I don't mind fixing the kernel, since this is clearly broken.  However, we may as well go ahead and declare a new struct ext4_new_group_input that has the right alignment, rename and deprecate the old one (have resize2fs prefer the new one if available) and take the old one out in a few years.  I hate this business of keeping around old cruft like this forever.

struct compat_ext4_new_group_input {
	u32 group;
	u64 block_bitmap;
	u64 inode_bitmap;
	u64 inode_table;
	u32 blocks_count;
	u16 reserved_blocks;
	u16 unused;
};

struct ext4_new_group_input {
	u64 group;
	u64 block_bitmap;
	u64 inode_bitmap;
	u64 inode_table;
	u64 blocks_count;
	u32 reserved_blocks;
        u32 unused;
};

#define EXT2_IOC_GROUP_ADD              _IOW('f', 8,struct ext2_new_group_input)
#define EXT4_IOC_GROUP_ADD_OLD          _IOW('f', 8,struct compat_ext4_new_group_input)
#define EXT4_IOC_GROUP_ADD		_IOW('f', 8,struct ext4_new_group_input)

The resize/online.c code already has compat support for both 32-bit and 64-bit IOC numbers, so it isn't much effort to have it try a third variant for a couple of years.

> +#if defined(__KERNEL__) && defined(CONFIG_COMPAT)
> +struct compat_ext4_new_group_input {
> +	u32 group;
> +	compat_u64 block_bitmap;
> +	compat_u64 inode_bitmap;
> +	compat_u64 inode_table;
> +	u32 blocks_count;
> +	u16 reserved_blocks;
> +	u16 unused;
> +};
> +#endif
> +
> /* The struct ext4_new_group_input in kernel space, with free_blocks_count */
> struct ext4_new_group_data {
> 	__u32 group;
> @@ -409,6 +424,7 @@ struct ext4_new_group_data {
> #define EXT4_IOC32_GETRSVSZ		_IOR('f', 5, int)
> #define EXT4_IOC32_SETRSVSZ		_IOW('f', 6, int)
> #define EXT4_IOC32_GROUP_EXTEND		_IOW('f', 7, unsigned int)
> +#define EXT4_IOC32_GROUP_ADD		_IOW('f', 8, struct compat_ext4_new_group_input)
> #ifdef CONFIG_JBD2_DEBUG
> #define EXT4_IOC32_WAIT_FOR_READONLY	_IOR('f', 99, int)
> #endif
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index 66fa0b0..6ddec84 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -373,8 +373,29 @@ long ext4_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> 	case EXT4_IOC32_SETRSVSZ:
> 		cmd = EXT4_IOC_SETRSVSZ;
> 		break;
> -	case EXT4_IOC_GROUP_ADD:
> -		break;
> +	case EXT4_IOC32_GROUP_ADD: {
> +		struct compat_ext4_new_group_input __user *uinput;
> +		struct ext4_new_group_input input;
> +		mm_segment_t old_fs;
> +		int err;
> +
> +		uinput = compat_ptr(arg);
> +		err = get_user(input.group, &uinput->group);
> +		err |= get_user(input.block_bitmap, &uinput->block_bitmap);
> +		err |= get_user(input.inode_bitmap, &uinput->inode_bitmap);
> +		err |= get_user(input.inode_table, &uinput->inode_table);
> +		err |= get_user(input.blocks_count, &uinput->blocks_count);
> +		err |= get_user(input.reserved_blocks,
> +				&uinput->reserved_blocks);
> +		if (err)
> +			return -EFAULT;
> +		old_fs = get_fs();
> +		set_fs(KERNEL_DS);
> +		err = ext4_ioctl(file, EXT4_IOC_GROUP_ADD,
> +				 (unsigned long) &input);
> +		set_fs(old_fs);
> +		return err;
> +	}
> 	case EXT4_IOC_MOVE_EXT:
> 		break;
> 	default:
> -- 
> 1.7.1
> 
> 


Cheers, Andreas
--
Andreas Dilger
Lustre Technical Lead
Oracle Corporation Canada Inc.

