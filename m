From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC] on-line resize with flex_bg and exclude_bitmap
Date: Wed, 13 Apr 2011 09:45:25 -0400
Message-ID: <1A1F7181-8985-477C-AECB-783848D88AC3@dilger.ca>
References: <BANLkTimfddp_6LkfCMfAe_SA2wa3t3jrMQ@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Tso <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:30455 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab1DMNp2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Apr 2011 09:45:28 -0400
In-Reply-To: <BANLkTimfddp_6LkfCMfAe_SA2wa3t3jrMQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-04-12, at 7:27 AM, Amir Goldstein wrote:
> I realized another issue regarding exclude bitmap compatibility.
> the exiting EXT4_IOC_GROUP_ADD ioctl doesn't pass a field for the location
> of exclude_bitmap block, so we need to either allocate exclude_bitmap in kernel
> or define a new ioctl, which passes the exclude_bitmap to kernel.
> 
> If we are going to go with the latter solution, we may want to add
> support for flex_bg layout for the new ioctl, so following is my proposal
> for EXT4_IOC_FLEX_GROUP_ADD:
> 
> 1. As far as online resize and mkfs are concerned, we always allocate all
> group descriptors of a flex bg at the same time.
> 
> 2. If there is not enough space for all flex_bg metadata in the last group,
> the last group will be dropped.
> 
> 3. The new flex group input will assume all bitmaps of the same type are
> consecutive, so only the address of the first bitmap is needed as input.
> 
> struct ext4_new_flex_group_input {
>      __u32 group;            /* Group number for this data */

This field will cause a misalignment/padding in the structure and will cause
problems with 32-bit binaries on 64-bit kernels.

Should we add a "__u32 flags" field to this structure?  I prefer flags/features
instead of versions...  This will avoid the need to continually adding new
ioctls in the future.

>      __u64 block_bitmap;     /* Absolute block number of first
> block bitmap */
>      __u64 exclude_bitmap;     /* Absolute block number of first
> exclude bitmap */
>      __u64 inode_bitmap;     /* Absolute block number of first
> inode bitmap */
>      __u64 inode_table;      /* Absolute block number of first
> inode table start */
>      __u32 blocks_count;     /* Total number of blocks in this flex group */
>      __u16 reserved_blocks;  /* Number of reserved blocks in this
> flex group */
>      __u16 flex_size;            /* Number of groups in the flex group */
> };


Since the kernel only supports a single s_log_groups_per_flex value in the superblock, we should use the superblock value and change "flex_size" to be just a count of the number of groups that should be added.  That means resize2fs should align its ioctls to multiples of the superblock s_log_groups_per_flex.


> 4. ext4_group_extend() should be the same except we need to allow extending
> within the last flex bg, but not necessarily the last block group.
> 
> 
> To look at this from a different angle, if you imagine that the flex
> group is just a big group, whose bitmaps and group descriptor are flex_size
> times bigger and where ext4_new_flex_group_input encodes the info of the big
> descriptor, then this design is identical to the current implementation of
> online resize.
> 
> What I will do, if you agree to this design, is use the new ioctl,
> with flex_size = 1 to pass the exclude_bitmap in online resize and enforce
> flex_size == 1 in kernel.

If you are going to be modifying the kernel to add support for this ioctl,
why not properly add in support for flex_size > 1?  It should only involve
the kernel looping over the groups as they are added.  This doesn't require
that resize2fs has added support for it yet, but forcing flex_size == 1 in
the kernel means that userspace will not know whether the kernel is doing
the right thing or not.

In order to handle future resize in the case of a partially-added flex group,
it would be desirable for the unused blocks (bitmaps, inode table) are reserved
so that they are not allocated by the block allocator. 

> Then later we can teach resize2fs and the kernel to extend flex groups properly
> using the new ioctl.
> 
> What do you think?
> Can you think of another way I can support exclude_bitmap and online resize,
> without the need for a new ioctl?
> 
> Amir.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





