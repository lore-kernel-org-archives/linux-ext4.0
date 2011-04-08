From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC] exclude bitmap and 32bit bitmap cheksum fields
Date: Fri, 8 Apr 2011 14:45:22 -0700
Message-ID: <BANLkTimORTWEYTiQu9SFthG_nQrvdQ=anQ@mail.gmail.com>
References: <BANLkTimV8qQUNDM2Sx+jOo+DWV-3NSpsuw@mail.gmail.com>
	<85609C33-2A88-4BAE-9512-0E627CD257B8@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41324 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757264Ab1DHVpY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Apr 2011 17:45:24 -0400
Received: by yxs7 with SMTP id 7so1592236yxs.19
        for <linux-ext4@vger.kernel.org>; Fri, 08 Apr 2011 14:45:23 -0700 (PDT)
In-Reply-To: <85609C33-2A88-4BAE-9512-0E627CD257B8@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 8, 2011 at 1:37 PM, Andreas Dilger <adilger@whamcloud.com> =
wrote:
> On 2011-04-08, at 12:00 PM, Amir Goldstein <amir73il@gmail.com> wrote=
:
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
>> The first use case is nulled by the introduction of inode/block bitm=
ap
>> checksums.
>> The second use case can be bypassed with no substantial penalty:
>> in-memory counters can be calculated on first inode/block bitmap acc=
ess,
>> when the GRP_NEED_INIT (or another) flag is set in the group_info st=
ruct,
>> just like their cousins, the buddy bitmap counters.
>
> I disagree with this assumption. The group descriptor free block and =
inode counters are very important to avoid loading the bitmaps in the f=
irst place. There are very significant performance impacts from loading=
 all of the bitmaps from disk, which is why even recently the buddy des=
criptors have added in-memory fields for the largest available extent i=
n each group.

d@#*! I keep forgetting about that aspect.
well, we can use a single persistent bit to specify BG_INODE_FULL
and a single bit to specify BG_BLOCK_FULL, but that doesn't cover the
test ext4_free_inodes_count(sb, desc) >=3D avefreei.
all the rest of the tests currently only test for non-zero value
before loading the (inode or block) bitmap.

Andreas, did you have a chance to look at the patches  I posted to
remove alloc_semp?
The patches are available online on github:
https://github.com/amir73il/ext4-snapshots/commits/alloc_semp/


>
>> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
>> index 0deb554..5cbaeb2 100644
>> --- a/lib/ext2fs/ext2_fs.h
>> +++ b/lib/ext2fs/ext2_fs.h
>> @@ -153,11 +153,11 @@ struct ext2_group_desc
>> =A0 =A0__u32 =A0 =A0bg_block_bitmap; =A0 =A0/* Blocks bitmap block *=
/
>> =A0 =A0__u32 =A0 =A0bg_inode_bitmap; =A0 =A0/* Inodes bitmap block *=
/
>> =A0 =A0__u32 =A0 =A0bg_inode_table; =A0 =A0 =A0 =A0/* Inodes table b=
lock */
>> - =A0 =A0__u16 =A0 =A0bg_free_blocks_count; =A0 =A0/* Free blocks co=
unt */
>> - =A0 =A0__u16 =A0 =A0bg_free_inodes_count; =A0 =A0/* Free inodes co=
unt */
>> + =A0 =A0__u32 =A0 =A0bg_exclude_bitmap; =A0 =A0/* Exclude bitmap bl=
ock */
>> =A0 =A0__u16 =A0 =A0bg_used_dirs_count; =A0 =A0/* Directories count =
*/
>> =A0 =A0__u16 =A0 =A0bg_flags;
>> - =A0 =A0__u32 =A0 =A0bg_reserved[2];
>> + =A0 =A0__u32 =A0 =A0bg_block_bitmap_csum; =A0 =A0/* Blocks+exclude=
 bitmap checksum */
>> + =A0 =A0__u32 =A0 =A0bg_inode_bitmap_csum; =A0 =A0/* Inodes bitmap =
checksum */
>> =A0 =A0__u16 =A0 =A0bg_itable_unused; =A0 =A0/* Unused inodes count =
*/
>> =A0 =A0__u16 =A0 =A0bg_checksum; =A0 =A0 =A0 =A0/* crc16(s_uuid+grou=
o_num+group_desc)*/
>> };
>> @@ -170,18 +170,17 @@ struct ext4_group_desc
>> =A0 =A0__u32 =A0 =A0bg_block_bitmap; =A0 =A0/* Blocks bitmap block *=
/
>> =A0 =A0__u32 =A0 =A0bg_inode_bitmap; =A0 =A0/* Inodes bitmap block *=
/
>> =A0 =A0__u32 =A0 =A0bg_inode_table; =A0 =A0 =A0 =A0/* Inodes table b=
lock */
>> - =A0 =A0__u16 =A0 =A0bg_free_blocks_count; =A0 =A0/* Free blocks co=
unt */
>> - =A0 =A0__u16 =A0 =A0bg_free_inodes_count; =A0 =A0/* Free inodes co=
unt */
>> + =A0 =A0__u32 =A0 =A0bg_exclude_bitmap; =A0 =A0/* Exclude bitmap bl=
ock */
>> =A0 =A0__u16 =A0 =A0bg_used_dirs_count; =A0 =A0/* Directories count =
*/
>> =A0 =A0__u16 =A0 =A0bg_flags;
>> - =A0 =A0__u32 =A0 =A0bg_reserved[2];
>> + =A0 =A0__u32 =A0 =A0bg_block_bitmap_csum; =A0 =A0/* Blocks+exclude=
 bitmap checksum */
>> + =A0 =A0__u32 =A0 =A0bg_inode_bitmap_csum; =A0 =A0/* Inodes bitmap =
checksum */
>> =A0 =A0__u16 =A0 =A0bg_itable_unused; =A0 =A0/* Unused inodes count =
*/
>> =A0 =A0__u16 =A0 =A0bg_checksum; =A0 =A0 =A0 =A0/* crc16(s_uuid+grou=
o_num+group_desc)*/
>> =A0 =A0__u32 =A0 =A0bg_block_bitmap_hi; =A0 =A0/* Blocks bitmap bloc=
k MSB */
>> =A0 =A0__u32 =A0 =A0bg_inode_bitmap_hi; =A0 =A0/* Inodes bitmap bloc=
k MSB */
>> =A0 =A0__u32 =A0 =A0bg_inode_table_hi; =A0 =A0/* Inodes table block =
MSB */
>> - =A0 =A0__u16 =A0 =A0bg_free_blocks_count_hi;/* Free blocks count M=
SB */
>> - =A0 =A0__u16 =A0 =A0bg_free_inodes_count_hi;/* Free inodes count M=
SB */
>> + =A0 =A0__u32 =A0 =A0bg_exclude_bitmap; =A0 =A0/* Exclude bitmap bl=
ock MSB */
>> =A0 =A0__u16 =A0 =A0bg_used_dirs_count_hi; =A0 =A0/* Directories cou=
nt MSB */
>> =A0 =A0__u16 =A0 bg_pad;
>> =A0 =A0__u32 =A0 =A0bg_reserved2[3];
>> @@ -190,6 +189,7 @@ struct ext4_group_desc
>> #define EXT2_BG_INODE_UNINIT =A0 =A00x0001 /* Inode table/bitmap not=
 initialized */
>> #define EXT2_BG_BLOCK_UNINIT =A0 =A00x0002 /* Block bitmap not initi=
alized */
>> #define EXT2_BG_INODE_ZEROED =A0 =A00x0004 /* On-disk itable initial=
ized to zero */
>> +#define EXT2_BG_EXCLUDE_UNINIT =A0 =A00x0008 /* Exclude bitmap not =
initialized */
>>
>> /*
>> =A0* Data structures used by the directory indexing feature
>> @@ -751,6 +751,7 @@ struct ext2_super_block {
>> #define EXT4_FEATURE_RO_COMPAT_DIR_NLINK =A0 =A00x0020
>> #define EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE =A0 =A00x0040
>> #define EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT =A0 =A00x0080
>> +#define EXT4_FEATURE_RO_COMPAT_BITMAP_CSUM =A0 =A00x0100
>>
>> #define EXT2_FEATURE_INCOMPAT_COMPRESSION =A0 =A00x0001
>> #define EXT2_FEATURE_INCOMPAT_FILETYPE =A0 =A0 =A0 =A00x0002
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
