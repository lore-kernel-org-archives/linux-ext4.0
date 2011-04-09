From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [RFC] exclude bitmap and 16bit bitmap cheksum fields
Date: Fri, 8 Apr 2011 22:41:19 -0600
Message-ID: <F283969A-4B24-4F6E-AE81-BAE6D6CC92BF@dilger.ca>
References: <BANLkTi=xbrQ2qKSMR71Vev3tfrMf1o02vA@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Tso <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:7998 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab1DIElW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 9 Apr 2011 00:41:22 -0400
In-Reply-To: <BANLkTi=xbrQ2qKSMR71Vev3tfrMf1o02vA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-04-08, at 9:08 PM, Amir Goldstein wrote:
> As Andreas pointed out, dropping the persistent group counters was
> probably not as good idea as I thought it was.
> 
> Too bad. That would have saved me the trouble of fixing the snapshot group
> block counters very elegantly... (no counters to fix).
> At least I won't need to fix the block bitmap checksum, since
> the checksum of block+exclude bitmaps should be consistent
> with the snapshot's block bitmap, which is (block bitmap)^(exclude_bitmap).
> 
> On the bright side, it is not obvious that replacing 16bit count + 16bit
> checksum with 32bit checksum is always a good trade off.
> In the worst case of half of the blocks free, 16bit checksum gives you
> more chances of false positive checksum, but in the common special cases
> of empty group and full group, the validation of free counter is much
> stronger then the checksum validation (there is only 1 correct bitmap
> with free count == 0).
> 
> So following is the on-disk format with 16bit checksums as you initially
> suggested. I wasn't sure if 64bit version of group_desc should have
> 32bit checksums and whether they should be split to lo/hi 16bit or
> just put them at the end on the struct? as I wasn't sure why the
> lower part of the struct needs to be compatible with the 32bit version.

Can you please include a proposed description or algorithm for the checksums?
crc16 is what I would expect for 16-bit csums, since that is also what is used for the bg_checksum field.

It isn't at all clear how this would be extended to a 32-bit checksum for the larger group descriptor.

> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
> index 0deb554..aa6afe8 100644
> --- a/lib/ext2fs/ext2_fs.h
> +++ b/lib/ext2fs/ext2_fs.h
> @@ -157,7 +157,9 @@ struct ext2_group_desc
> 	__u16	bg_free_inodes_count;	/* Free inodes count */
> 	__u16	bg_used_dirs_count;	/* Directories count */
> 	__u16	bg_flags;
> -	__u32	bg_reserved[2];
> +	__u32	bg_exclude_bitmap;	/* Exclude bitmap block */
> +	__u16	bg_block_bitmap_csum;	/* Blocks+exclude bitmap checksum */
> +	__u16	bg_inode_bitmap_csum;	/* Inodes bitmap checksum */
> 	__u16	bg_itable_unused;	/* Unused inodes count */
> 	__u16	bg_checksum;		/* crc16(s_uuid+grouo_num+group_desc)*/
> };
> @@ -174,7 +176,9 @@ struct ext4_group_desc
> 	__u16	bg_free_inodes_count;	/* Free inodes count */
> 	__u16	bg_used_dirs_count;	/* Directories count */
> 	__u16	bg_flags;
> -	__u32	bg_reserved[2];
> +	__u32	bg_exclude_bitmap;	/* Exclude bitmap block */
> +	__u16	bg_block_bitmap_csum;	/* Blocks+exclude bitmap checksum */
> +	__u16	bg_inode_bitmap_csum;	/* Inodes bitmap checksum */
> 	__u16	bg_itable_unused;	/* Unused inodes count */
> 	__u16	bg_checksum;		/* crc16(s_uuid+grouo_num+group_desc)*/
> 	__u32	bg_block_bitmap_hi;	/* Blocks bitmap block MSB */
> @@ -184,12 +188,16 @@ struct ext4_group_desc
> 	__u16	bg_free_inodes_count_hi;/* Free inodes count MSB */
> 	__u16	bg_used_dirs_count_hi;	/* Directories count MSB */
> 	__u16   bg_pad;
> -	__u32	bg_reserved2[3];
> +	__u32	bg_exclude_bitmap_hi;	/* Exclude bitmap block MSB */
> +	__u16	bg_block_bitmap_csum_hi;/* Blocks bitmap checksum MSB */
> +	__u16	bg_inode_bitmap_csum_hi;/* Inodes bitmap checksum MSB */
> +	__u32	bg_reserved2[1];
> };
> 
> #define EXT2_BG_INODE_UNINIT	0x0001 /* Inode table/bitmap not initialized */
> #define EXT2_BG_BLOCK_UNINIT	0x0002 /* Block bitmap not initialized */
> #define EXT2_BG_INODE_ZEROED	0x0004 /* On-disk itable initialized to zero */
> +#define EXT2_BG_EXCLUDE_UNINIT	0x0008 /* Exclude bitmap not initialized */
> 
> /*
>  * Data structures used by the directory indexing feature
> @@ -751,6 +759,7 @@ struct ext2_super_block {
> #define EXT4_FEATURE_RO_COMPAT_DIR_NLINK	0x0020
> #define EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE	0x0040
> #define EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT	0x0080
> +#define EXT4_FEATURE_RO_COMPAT_BITMAP_CSUM	0x0100
> 
> #define EXT2_FEATURE_INCOMPAT_COMPRESSION	0x0001
> #define EXT2_FEATURE_INCOMPAT_FILETYPE		0x0002
> 
> 
> On Fri, Apr 8, 2011 at 2:45 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Fri, Apr 8, 2011 at 1:37 PM, Andreas Dilger <adilger@whamcloud.com> wrote:
>>> On 2011-04-08, at 12:00 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>> Following our conversation, here is a proposal how to squeeze:
>>>> - 32bit exclude bitmap block address
>>>> - 32bit block+exclude bitmap checksum
>>>> - 32bit inode bitmap checksum
>>>> into the reaming 8 bytes in the group descriptor.
>>>> 
>>>> The idea is that the 16bit persistent free inode/block counters
>>>> are redundant to the inode/block bitmap information
>>>> and are needed in 2 use cases:
>>>> 1. sanity checks on fsck
>>>> 2. quick load of in-memory counters
>>>> 
>>>> The first use case is nulled by the introduction of inode/block bitmap
>>>> checksums.
>>>> The second use case can be bypassed with no substantial penalty:
>>>> in-memory counters can be calculated on first inode/block bitmap access,
>>>> when the GRP_NEED_INIT (or another) flag is set in the group_info struct,
>>>> just like their cousins, the buddy bitmap counters.
>>> 
>>> I disagree with this assumption. The group descriptor free block and inode counters are very important to avoid loading the bitmaps in the first place. There are very significant performance impacts from loading all of the bitmaps from disk, which is why even recently the buddy descriptors have added in-memory fields for the largest available extent in each group.
>> 
>> d@#*! I keep forgetting about that aspect.
>> well, we can use a single persistent bit to specify BG_INODE_FULL
>> and a single bit to specify BG_BLOCK_FULL, but that doesn't cover the
>> test ext4_free_inodes_count(sb, desc) >= avefreei.
>> all the rest of the tests currently only test for non-zero value
>> before loading the (inode or block) bitmap.
>> 
>> Andreas, did you have a chance to look at the patches  I posted to
>> remove alloc_semp?
>> The patches are available online on github:
>> https://github.com/amir73il/ext4-snapshots/commits/alloc_semp/
>> 
>> 
>>> 
>>>> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
>>>> index 0deb554..5cbaeb2 100644
>>>> --- a/lib/ext2fs/ext2_fs.h
>>>> +++ b/lib/ext2fs/ext2_fs.h
>>>> @@ -153,11 +153,11 @@ struct ext2_group_desc
>>>>    __u32    bg_block_bitmap;    /* Blocks bitmap block */
>>>>    __u32    bg_inode_bitmap;    /* Inodes bitmap block */
>>>>    __u32    bg_inode_table;        /* Inodes table block */
>>>> -    __u16    bg_free_blocks_count;    /* Free blocks count */
>>>> -    __u16    bg_free_inodes_count;    /* Free inodes count */
>>>> +    __u32    bg_exclude_bitmap;    /* Exclude bitmap block */
>>>>    __u16    bg_used_dirs_count;    /* Directories count */
>>>>    __u16    bg_flags;
>>>> -    __u32    bg_reserved[2];
>>>> +    __u32    bg_block_bitmap_csum;    /* Blocks+exclude bitmap checksum */
>>>> +    __u32    bg_inode_bitmap_csum;    /* Inodes bitmap checksum */
>>>>    __u16    bg_itable_unused;    /* Unused inodes count */
>>>>    __u16    bg_checksum;        /* crc16(s_uuid+grouo_num+group_desc)*/
>>>> };
>>>> @@ -170,18 +170,17 @@ struct ext4_group_desc
>>>>    __u32    bg_block_bitmap;    /* Blocks bitmap block */
>>>>    __u32    bg_inode_bitmap;    /* Inodes bitmap block */
>>>>    __u32    bg_inode_table;        /* Inodes table block */
>>>> -    __u16    bg_free_blocks_count;    /* Free blocks count */
>>>> -    __u16    bg_free_inodes_count;    /* Free inodes count */
>>>> +    __u32    bg_exclude_bitmap;    /* Exclude bitmap block */
>>>>    __u16    bg_used_dirs_count;    /* Directories count */
>>>>    __u16    bg_flags;
>>>> -    __u32    bg_reserved[2];
>>>> +    __u32    bg_block_bitmap_csum;    /* Blocks+exclude bitmap checksum */
>>>> +    __u32    bg_inode_bitmap_csum;    /* Inodes bitmap checksum */
>>>>    __u16    bg_itable_unused;    /* Unused inodes count */
>>>>    __u16    bg_checksum;        /* crc16(s_uuid+grouo_num+group_desc)*/
>>>>    __u32    bg_block_bitmap_hi;    /* Blocks bitmap block MSB */
>>>>    __u32    bg_inode_bitmap_hi;    /* Inodes bitmap block MSB */
>>>>    __u32    bg_inode_table_hi;    /* Inodes table block MSB */
>>>> -    __u16    bg_free_blocks_count_hi;/* Free blocks count MSB */
>>>> -    __u16    bg_free_inodes_count_hi;/* Free inodes count MSB */
>>>> +    __u32    bg_exclude_bitmap;    /* Exclude bitmap block MSB */
>>>>    __u16    bg_used_dirs_count_hi;    /* Directories count MSB */
>>>>    __u16   bg_pad;
>>>>    __u32    bg_reserved2[3];
>>>> @@ -190,6 +189,7 @@ struct ext4_group_desc
>>>> #define EXT2_BG_INODE_UNINIT    0x0001 /* Inode table/bitmap not initialized */
>>>> #define EXT2_BG_BLOCK_UNINIT    0x0002 /* Block bitmap not initialized */
>>>> #define EXT2_BG_INODE_ZEROED    0x0004 /* On-disk itable initialized to zero */
>>>> +#define EXT2_BG_EXCLUDE_UNINIT    0x0008 /* Exclude bitmap not initialized */
>>>> 
>>>> /*
>>>>  * Data structures used by the directory indexing feature
>>>> @@ -751,6 +751,7 @@ struct ext2_super_block {
>>>> #define EXT4_FEATURE_RO_COMPAT_DIR_NLINK    0x0020
>>>> #define EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE    0x0040
>>>> #define EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT    0x0080
>>>> +#define EXT4_FEATURE_RO_COMPAT_BITMAP_CSUM    0x0100
>>>> 
>>>> #define EXT2_FEATURE_INCOMPAT_COMPRESSION    0x0001
>>>> #define EXT2_FEATURE_INCOMPAT_FILETYPE        0x0002
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> 
>> 


Cheers, Andreas





