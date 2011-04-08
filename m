From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [RFC] exclude bitmap and 32bit bitmap cheksum fields
Date: Fri, 8 Apr 2011 14:37:02 -0600
Message-ID: <85609C33-2A88-4BAE-9512-0E627CD257B8@whamcloud.com>
References: <BANLkTimV8qQUNDM2Sx+jOo+DWV-3NSpsuw@mail.gmail.com>
Mime-Version: 1.0 (iPhone Mail 8F190)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Tso <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53215 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab1DHUhF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Apr 2011 16:37:05 -0400
Received: by iyb14 with SMTP id 14so3791083iyb.19
        for <linux-ext4@vger.kernel.org>; Fri, 08 Apr 2011 13:37:04 -0700 (PDT)
In-Reply-To: <BANLkTimV8qQUNDM2Sx+jOo+DWV-3NSpsuw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-04-08, at 12:00 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Following our conversation, here is a proposal how to squeeze:
> - 32bit exclude bitmap block address
> - 32bit block+exclude bitmap checksum
> - 32bit inode bitmap checksum
> into the reaming 8 bytes in the group descriptor.
> 
> The idea is that the 16bit persistent free inode/block counters
> are redundant to the inode/block bitmap information
> and are needed in 2 use cases:
> 1. sanity checks on fsck
> 2. quick load of in-memory counters
> 
> The first use case is nulled by the introduction of inode/block bitmap
> checksums.
> The second use case can be bypassed with no substantial penalty:
> in-memory counters can be calculated on first inode/block bitmap access,
> when the GRP_NEED_INIT (or another) flag is set in the group_info struct,
> just like their cousins, the buddy bitmap counters.

I disagree with this assumption. The group descriptor free block and inode counters are very important to avoid loading the bitmaps in the first place. There are very significant performance impacts from loading all of the bitmaps from disk, which is why even recently the buddy descriptors have added in-memory fields for the largest available extent in each group. 

> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
> index 0deb554..5cbaeb2 100644
> --- a/lib/ext2fs/ext2_fs.h
> +++ b/lib/ext2fs/ext2_fs.h
> @@ -153,11 +153,11 @@ struct ext2_group_desc
>    __u32    bg_block_bitmap;    /* Blocks bitmap block */
>    __u32    bg_inode_bitmap;    /* Inodes bitmap block */
>    __u32    bg_inode_table;        /* Inodes table block */
> -    __u16    bg_free_blocks_count;    /* Free blocks count */
> -    __u16    bg_free_inodes_count;    /* Free inodes count */
> +    __u32    bg_exclude_bitmap;    /* Exclude bitmap block */
>    __u16    bg_used_dirs_count;    /* Directories count */
>    __u16    bg_flags;
> -    __u32    bg_reserved[2];
> +    __u32    bg_block_bitmap_csum;    /* Blocks+exclude bitmap checksum */
> +    __u32    bg_inode_bitmap_csum;    /* Inodes bitmap checksum */
>    __u16    bg_itable_unused;    /* Unused inodes count */
>    __u16    bg_checksum;        /* crc16(s_uuid+grouo_num+group_desc)*/
> };
> @@ -170,18 +170,17 @@ struct ext4_group_desc
>    __u32    bg_block_bitmap;    /* Blocks bitmap block */
>    __u32    bg_inode_bitmap;    /* Inodes bitmap block */
>    __u32    bg_inode_table;        /* Inodes table block */
> -    __u16    bg_free_blocks_count;    /* Free blocks count */
> -    __u16    bg_free_inodes_count;    /* Free inodes count */
> +    __u32    bg_exclude_bitmap;    /* Exclude bitmap block */
>    __u16    bg_used_dirs_count;    /* Directories count */
>    __u16    bg_flags;
> -    __u32    bg_reserved[2];
> +    __u32    bg_block_bitmap_csum;    /* Blocks+exclude bitmap checksum */
> +    __u32    bg_inode_bitmap_csum;    /* Inodes bitmap checksum */
>    __u16    bg_itable_unused;    /* Unused inodes count */
>    __u16    bg_checksum;        /* crc16(s_uuid+grouo_num+group_desc)*/
>    __u32    bg_block_bitmap_hi;    /* Blocks bitmap block MSB */
>    __u32    bg_inode_bitmap_hi;    /* Inodes bitmap block MSB */
>    __u32    bg_inode_table_hi;    /* Inodes table block MSB */
> -    __u16    bg_free_blocks_count_hi;/* Free blocks count MSB */
> -    __u16    bg_free_inodes_count_hi;/* Free inodes count MSB */
> +    __u32    bg_exclude_bitmap;    /* Exclude bitmap block MSB */
>    __u16    bg_used_dirs_count_hi;    /* Directories count MSB */
>    __u16   bg_pad;
>    __u32    bg_reserved2[3];
> @@ -190,6 +189,7 @@ struct ext4_group_desc
> #define EXT2_BG_INODE_UNINIT    0x0001 /* Inode table/bitmap not initialized */
> #define EXT2_BG_BLOCK_UNINIT    0x0002 /* Block bitmap not initialized */
> #define EXT2_BG_INODE_ZEROED    0x0004 /* On-disk itable initialized to zero */
> +#define EXT2_BG_EXCLUDE_UNINIT    0x0008 /* Exclude bitmap not initialized */
> 
> /*
>  * Data structures used by the directory indexing feature
> @@ -751,6 +751,7 @@ struct ext2_super_block {
> #define EXT4_FEATURE_RO_COMPAT_DIR_NLINK    0x0020
> #define EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE    0x0040
> #define EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT    0x0080
> +#define EXT4_FEATURE_RO_COMPAT_BITMAP_CSUM    0x0100
> 
> #define EXT2_FEATURE_INCOMPAT_COMPRESSION    0x0001
> #define EXT2_FEATURE_INCOMPAT_FILETYPE        0x0002
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
