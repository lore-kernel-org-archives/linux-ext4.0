From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC] exclude bitmap and 32bit bitmap cheksum fields
Date: Fri, 8 Apr 2011 11:53:39 -0700
Message-ID: <4966647B-F65E-4C30-9990-73DAA12EF89B@gmail.com>
References: <BANLkTimV8qQUNDM2Sx+jOo+DWV-3NSpsuw@mail.gmail.com> <4D9F57C4.4010306@tao.ma>
Mime-Version: 1.0 (iPhone Mail 7D11)
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52535 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757098Ab1DHSxa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Apr 2011 14:53:30 -0400
Received: by pzk9 with SMTP id 9so1333767pzk.19
        for <linux-ext4@vger.kernel.org>; Fri, 08 Apr 2011 11:53:29 -0700 (PDT)
In-Reply-To: <4D9F57C4.4010306@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



Sent from my iPhone

On 08/04/2011, at 11:45, Tao Ma <tm@tao.ma> wrote:

> Hi Amir,
> On 04/09/2011 02:00 AM, Amir Goldstein wrote:
>> Hi Ted,
>>
>> Following our conversation, here is a proposal how to squeeze:
>> - 32bit exclude bitmap block address
>> - 32bit block+exclude bitmap checksum
>> - 32bit inode bitmap checksum
>> into the reaming 8 bytes in the group descriptor.
>>
>> The idea is that the 16bit persistent free inode/block counters
>> are redundant to the inode/block bitmap information
>> and are needed in 2 use cases:
>> 1. sanity checks on fsck
>> 2. quick load of in-memory counters
>>
>> The first use case is nulled by the introduction of inode/block  
>> bitmap
>> checksums.
>> The second use case can be bypassed with no substantial penalty:
>> in-memory counters can be calculated on first inode/block bitmap  
>> access,
>> when the GRP_NEED_INIT (or another) flag is set in the group_info  
>> struct,
>> just like their cousins, the buddy bitmap counters.
>>
>> Amir.
>>
>> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
>> index 0deb554..5cbaeb2 100644
>> --- a/lib/ext2fs/ext2_fs.h
>> +++ b/lib/ext2fs/ext2_fs.h
>> @@ -153,11 +153,11 @@ struct ext2_group_desc
>>    __u32    bg_block_bitmap;    /* Blocks bitmap block */
>>    __u32    bg_inode_bitmap;    /* Inodes bitmap block */
>>    __u32    bg_inode_table;        /* Inodes table block */
>> -    __u16    bg_free_blocks_count;    /* Free blocks count */
>> -    __u16    bg_free_inodes_count;    /* Free inodes count */
>> +    __u32    bg_exclude_bitmap;    /* Exclude bitmap block */
>>    __u16    bg_used_dirs_count;    /* Directories count */
>>    __u16    bg_flags;
>> -    __u32    bg_reserved[2];
>> +    __u32    bg_block_bitmap_csum;    /* Blocks+exclude bitmap  
>> checksum */
>> +    __u32    bg_inode_bitmap_csum;    /* Inodes bitmap checksum */
>>    __u16    bg_itable_unused;    /* Unused inodes count */
>>    __u16    bg_checksum;        /* crc16(s_uuid+grouo_num 
>> +group_desc)*/
>> };
>> @@ -170,18 +170,17 @@ struct ext4_group_desc
>>    __u32    bg_block_bitmap;    /* Blocks bitmap block */
>>    __u32    bg_inode_bitmap;    /* Inodes bitmap block */
>>    __u32    bg_inode_table;        /* Inodes table block */
>> -    __u16    bg_free_blocks_count;    /* Free blocks count */
>> -    __u16    bg_free_inodes_count;    /* Free inodes count */
>> +    __u32    bg_exclude_bitmap;    /* Exclude bitmap block */
>>    __u16    bg_used_dirs_count;    /* Directories count */
>>    __u16    bg_flags;
>> -    __u32    bg_reserved[2];
>> +    __u32    bg_block_bitmap_csum;    /* Blocks+exclude bitmap  
>> checksum */
>> +    __u32    bg_inode_bitmap_csum;    /* Inodes bitmap checksum */
>>    __u16    bg_itable_unused;    /* Unused inodes count */
>>    __u16    bg_checksum;        /* crc16(s_uuid+grouo_num 
>> +group_desc)*/
>>    __u32    bg_block_bitmap_hi;    /* Blocks bitmap block MSB */
>>    __u32    bg_inode_bitmap_hi;    /* Inodes bitmap block MSB */
>>    __u32    bg_inode_table_hi;    /* Inodes table block MSB */
>> -    __u16    bg_free_blocks_count_hi;/* Free blocks count MSB */
>> -    __u16    bg_free_inodes_count_hi;/* Free inodes count MSB */
>> +    __u32    bg_exclude_bitmap;    /* Exclude bitmap block MSB */
>>    __u16    bg_used_dirs_count_hi;    /* Directories count MSB */
>>    __u16   bg_pad;
>>    __u32    bg_reserved2[3];
>> @@ -190,6 +189,7 @@ struct ext4_group_desc
>> #define EXT2_BG_INODE_UNINIT    0x0001 /* Inode table/bitmap not  
>> initialized */
>> #define EXT2_BG_BLOCK_UNINIT    0x0002 /* Block bitmap not  
>> initialized */
>> #define EXT2_BG_INODE_ZEROED    0x0004 /* On-disk itable  
>> initialized to zero */
>> +#define EXT2_BG_EXCLUDE_UNINIT    0x0008 /* Exclude bitmap not  
>> initialized */
>>
>> /*
>>  * Data structures used by the directory indexing feature
>> @@ -751,6 +751,7 @@ struct ext2_super_block {
>> #define EXT4_FEATURE_RO_COMPAT_DIR_NLINK    0x0020
>> #define EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE    0x0040
>> #define EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT    0x0080
>> +#define EXT4_FEATURE_RO_COMPAT_BITMAP_CSUM    0x0100
> I guess this should be in FEATURE_INCOMPAT, not RO_COMPAT?
> Since you have changed free_{inodes, blocks}_count to exclude_map. an
> old kernel will interpret these values wrongly.
I don't think the counters matter for read only mount

>
> Regards,
> Tao
