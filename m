From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC] exclude bitmap and 16bit bitmap cheksum fields
Date: Fri, 8 Apr 2011 23:29:46 -0700
Message-ID: <BANLkTikzMBApwEwoRK-VCeX8VznZrQzZNQ@mail.gmail.com>
References: <BANLkTi=xbrQ2qKSMR71Vev3tfrMf1o02vA@mail.gmail.com>
	<F283969A-4B24-4F6E-AE81-BAE6D6CC92BF@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:49824 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab1DIG3s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 9 Apr 2011 02:29:48 -0400
Received: by qyg14 with SMTP id 14so2943483qyg.19
        for <linux-ext4@vger.kernel.org>; Fri, 08 Apr 2011 23:29:47 -0700 (PDT)
In-Reply-To: <F283969A-4B24-4F6E-AE81-BAE6D6CC92BF@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 8, 2011 at 9:41 PM, Andreas Dilger <adilger.kernel@dilger.c=
a> wrote:
> On 2011-04-08, at 9:08 PM, Amir Goldstein wrote:
>> As Andreas pointed out, dropping the persistent group counters was
>> probably not as good idea as I thought it was.
>>
>> Too bad. That would have saved me the trouble of fixing the snapshot=
 group
>> block counters very elegantly... (no counters to fix).
>> At least I won't need to fix the block bitmap checksum, since
>> the checksum of block+exclude bitmaps should be consistent
>> with the snapshot's block bitmap, which is (block bitmap)^(exclude_b=
itmap).
>>
>> On the bright side, it is not obvious that replacing 16bit count + 1=
6bit
>> checksum with 32bit checksum is always a good trade off.
>> In the worst case of half of the blocks free, 16bit checksum gives y=
ou
>> more chances of false positive checksum, but in the common special c=
ases
>> of empty group and full group, the validation of free counter is muc=
h
>> stronger then the checksum validation (there is only 1 correct bitma=
p
>> with free count =3D=3D 0).
>>
>> So following is the on-disk format with 16bit checksums as you initi=
ally
>> suggested. I wasn't sure if 64bit version of group_desc should have
>> 32bit checksums and whether they should be split to lo/hi 16bit or
>> just put them at the end on the struct? as I wasn't sure why the
>> lower part of the struct needs to be compatible with the 32bit versi=
on.
>
> Can you please include a proposed description or algorithm for the ch=
ecksums?
> crc16 is what I would expect for 16-bit csums, since that is also wha=
t is used for the bg_checksum field.
>

I suppose crc16 will be used.
This is not intended to be a proposal for the bitmap checksums feature,
but merely a proposal of how the on-disk format will host the new
fields in the group descriptor.


> It isn't at all clear how this would be extended to a 32-bit checksum=
 for the larger group descriptor.
>

This is where I have a gap.
Aren't the large group descriptors only allocated when you mkfs a
64bit fs from scratch?
And if so, why do they need to be compatible with the small group
descriptor format?
I just figured we could calculate 32bit checksums if we have the space
to store them
and 16bit checksums otherwise, but I wasn't sure what would be the
right thing to do.

>> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
>> index 0deb554..aa6afe8 100644
>> --- a/lib/ext2fs/ext2_fs.h
>> +++ b/lib/ext2fs/ext2_fs.h
>> @@ -157,7 +157,9 @@ struct ext2_group_desc
>> =A0 =A0 =A0 __u16 =A0 bg_free_inodes_count; =A0 /* Free inodes count=
 */
>> =A0 =A0 =A0 __u16 =A0 bg_used_dirs_count; =A0 =A0 /* Directories cou=
nt */
>> =A0 =A0 =A0 __u16 =A0 bg_flags;
>> - =A0 =A0 __u32 =A0 bg_reserved[2];
>> + =A0 =A0 __u32 =A0 bg_exclude_bitmap; =A0 =A0 =A0/* Exclude bitmap =
block */
>> + =A0 =A0 __u16 =A0 bg_block_bitmap_csum; =A0 /* Blocks+exclude bitm=
ap checksum */
>> + =A0 =A0 __u16 =A0 bg_inode_bitmap_csum; =A0 /* Inodes bitmap check=
sum */
>> =A0 =A0 =A0 __u16 =A0 bg_itable_unused; =A0 =A0 =A0 /* Unused inodes=
 count */
>> =A0 =A0 =A0 __u16 =A0 bg_checksum; =A0 =A0 =A0 =A0 =A0 =A0/* crc16(s=
_uuid+grouo_num+group_desc)*/
>> };
>> @@ -174,7 +176,9 @@ struct ext4_group_desc
>> =A0 =A0 =A0 __u16 =A0 bg_free_inodes_count; =A0 /* Free inodes count=
 */
>> =A0 =A0 =A0 __u16 =A0 bg_used_dirs_count; =A0 =A0 /* Directories cou=
nt */
>> =A0 =A0 =A0 __u16 =A0 bg_flags;
>> - =A0 =A0 __u32 =A0 bg_reserved[2];
>> + =A0 =A0 __u32 =A0 bg_exclude_bitmap; =A0 =A0 =A0/* Exclude bitmap =
block */
>> + =A0 =A0 __u16 =A0 bg_block_bitmap_csum; =A0 /* Blocks+exclude bitm=
ap checksum */
>> + =A0 =A0 __u16 =A0 bg_inode_bitmap_csum; =A0 /* Inodes bitmap check=
sum */
>> =A0 =A0 =A0 __u16 =A0 bg_itable_unused; =A0 =A0 =A0 /* Unused inodes=
 count */
>> =A0 =A0 =A0 __u16 =A0 bg_checksum; =A0 =A0 =A0 =A0 =A0 =A0/* crc16(s=
_uuid+grouo_num+group_desc)*/
>> =A0 =A0 =A0 __u32 =A0 bg_block_bitmap_hi; =A0 =A0 /* Blocks bitmap b=
lock MSB */
>> @@ -184,12 +188,16 @@ struct ext4_group_desc
>> =A0 =A0 =A0 __u16 =A0 bg_free_inodes_count_hi;/* Free inodes count M=
SB */
>> =A0 =A0 =A0 __u16 =A0 bg_used_dirs_count_hi; =A0/* Directories count=
 MSB */
>> =A0 =A0 =A0 __u16 =A0 bg_pad;
>> - =A0 =A0 __u32 =A0 bg_reserved2[3];
>> + =A0 =A0 __u32 =A0 bg_exclude_bitmap_hi; =A0 /* Exclude bitmap bloc=
k MSB */
>> + =A0 =A0 __u16 =A0 bg_block_bitmap_csum_hi;/* Blocks bitmap checksu=
m MSB */
>> + =A0 =A0 __u16 =A0 bg_inode_bitmap_csum_hi;/* Inodes bitmap checksu=
m MSB */
>> + =A0 =A0 __u32 =A0 bg_reserved2[1];
>> };
>>
>> #define EXT2_BG_INODE_UNINIT =A00x0001 /* Inode table/bitmap not ini=
tialized */
>> #define EXT2_BG_BLOCK_UNINIT =A00x0002 /* Block bitmap not initializ=
ed */
>> #define EXT2_BG_INODE_ZEROED =A00x0004 /* On-disk itable initialized=
 to zero */
>> +#define EXT2_BG_EXCLUDE_UNINIT =A0 =A0 =A0 0x0008 /* Exclude bitmap=
 not initialized */
>>
>> /*
>> =A0* Data structures used by the directory indexing feature
>> @@ -751,6 +759,7 @@ struct ext2_super_block {
>> #define EXT4_FEATURE_RO_COMPAT_DIR_NLINK =A0 =A0 =A00x0020
>> #define EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE =A0 =A00x0040
>> #define EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT =A0 0x0080
>> +#define EXT4_FEATURE_RO_COMPAT_BITMAP_CSUM =A0 0x0100
>>
>> #define EXT2_FEATURE_INCOMPAT_COMPRESSION =A0 =A0 0x0001
>> #define EXT2_FEATURE_INCOMPAT_FILETYPE =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
0x0002
>>
>>
>> On Fri, Apr 8, 2011 at 2:45 PM, Amir Goldstein <amir73il@gmail.com> =
wrote:
>>> On Fri, Apr 8, 2011 at 1:37 PM, Andreas Dilger <adilger@whamcloud.c=
om> wrote:
>>>> On 2011-04-08, at 12:00 PM, Amir Goldstein <amir73il@gmail.com> wr=
ote:
>>>>> Following our conversation, here is a proposal how to squeeze:
>>>>> - 32bit exclude bitmap block address
>>>>> - 32bit block+exclude bitmap checksum
>>>>> - 32bit inode bitmap checksum
>>>>> into the reaming 8 bytes in the group descriptor.
>>>>>
>>>>> The idea is that the 16bit persistent free inode/block counters
>>>>> are redundant to the inode/block bitmap information
>>>>> and are needed in 2 use cases:
>>>>> 1. sanity checks on fsck
>>>>> 2. quick load of in-memory counters
>>>>>
>>>>> The first use case is nulled by the introduction of inode/block b=
itmap
>>>>> checksums.
>>>>> The second use case can be bypassed with no substantial penalty:
>>>>> in-memory counters can be calculated on first inode/block bitmap =
access,
>>>>> when the GRP_NEED_INIT (or another) flag is set in the group_info=
 struct,
>>>>> just like their cousins, the buddy bitmap counters.
>>>>
>>>> I disagree with this assumption. The group descriptor free block a=
nd inode counters are very important to avoid loading the bitmaps in th=
e first place. There are very significant performance impacts from load=
ing all of the bitmaps from disk, which is why even recently the buddy =
descriptors have added in-memory fields for the largest available exten=
t in each group.
>>>
>>> d@#*! I keep forgetting about that aspect.
>>> well, we can use a single persistent bit to specify BG_INODE_FULL
>>> and a single bit to specify BG_BLOCK_FULL, but that doesn't cover t=
he
>>> test ext4_free_inodes_count(sb, desc) >=3D avefreei.
>>> all the rest of the tests currently only test for non-zero value
>>> before loading the (inode or block) bitmap.
>>>
>>> Andreas, did you have a chance to look at the patches =A0I posted t=
o
>>> remove alloc_semp?
>>> The patches are available online on github:
>>> https://github.com/amir73il/ext4-snapshots/commits/alloc_semp/
>>>
>>>
>>>>
>>>>> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
>>>>> index 0deb554..5cbaeb2 100644
>>>>> --- a/lib/ext2fs/ext2_fs.h
>>>>> +++ b/lib/ext2fs/ext2_fs.h
>>>>> @@ -153,11 +153,11 @@ struct ext2_group_desc
>>>>> =A0 =A0__u32 =A0 =A0bg_block_bitmap; =A0 =A0/* Blocks bitmap bloc=
k */
>>>>> =A0 =A0__u32 =A0 =A0bg_inode_bitmap; =A0 =A0/* Inodes bitmap bloc=
k */
>>>>> =A0 =A0__u32 =A0 =A0bg_inode_table; =A0 =A0 =A0 =A0/* Inodes tabl=
e block */
>>>>> - =A0 =A0__u16 =A0 =A0bg_free_blocks_count; =A0 =A0/* Free blocks=
 count */
>>>>> - =A0 =A0__u16 =A0 =A0bg_free_inodes_count; =A0 =A0/* Free inodes=
 count */
>>>>> + =A0 =A0__u32 =A0 =A0bg_exclude_bitmap; =A0 =A0/* Exclude bitmap=
 block */
>>>>> =A0 =A0__u16 =A0 =A0bg_used_dirs_count; =A0 =A0/* Directories cou=
nt */
>>>>> =A0 =A0__u16 =A0 =A0bg_flags;
>>>>> - =A0 =A0__u32 =A0 =A0bg_reserved[2];
>>>>> + =A0 =A0__u32 =A0 =A0bg_block_bitmap_csum; =A0 =A0/* Blocks+excl=
ude bitmap checksum */
>>>>> + =A0 =A0__u32 =A0 =A0bg_inode_bitmap_csum; =A0 =A0/* Inodes bitm=
ap checksum */
>>>>> =A0 =A0__u16 =A0 =A0bg_itable_unused; =A0 =A0/* Unused inodes cou=
nt */
>>>>> =A0 =A0__u16 =A0 =A0bg_checksum; =A0 =A0 =A0 =A0/* crc16(s_uuid+g=
rouo_num+group_desc)*/
>>>>> };
>>>>> @@ -170,18 +170,17 @@ struct ext4_group_desc
>>>>> =A0 =A0__u32 =A0 =A0bg_block_bitmap; =A0 =A0/* Blocks bitmap bloc=
k */
>>>>> =A0 =A0__u32 =A0 =A0bg_inode_bitmap; =A0 =A0/* Inodes bitmap bloc=
k */
>>>>> =A0 =A0__u32 =A0 =A0bg_inode_table; =A0 =A0 =A0 =A0/* Inodes tabl=
e block */
>>>>> - =A0 =A0__u16 =A0 =A0bg_free_blocks_count; =A0 =A0/* Free blocks=
 count */
>>>>> - =A0 =A0__u16 =A0 =A0bg_free_inodes_count; =A0 =A0/* Free inodes=
 count */
>>>>> + =A0 =A0__u32 =A0 =A0bg_exclude_bitmap; =A0 =A0/* Exclude bitmap=
 block */
>>>>> =A0 =A0__u16 =A0 =A0bg_used_dirs_count; =A0 =A0/* Directories cou=
nt */
>>>>> =A0 =A0__u16 =A0 =A0bg_flags;
>>>>> - =A0 =A0__u32 =A0 =A0bg_reserved[2];
>>>>> + =A0 =A0__u32 =A0 =A0bg_block_bitmap_csum; =A0 =A0/* Blocks+excl=
ude bitmap checksum */
>>>>> + =A0 =A0__u32 =A0 =A0bg_inode_bitmap_csum; =A0 =A0/* Inodes bitm=
ap checksum */
>>>>> =A0 =A0__u16 =A0 =A0bg_itable_unused; =A0 =A0/* Unused inodes cou=
nt */
>>>>> =A0 =A0__u16 =A0 =A0bg_checksum; =A0 =A0 =A0 =A0/* crc16(s_uuid+g=
rouo_num+group_desc)*/
>>>>> =A0 =A0__u32 =A0 =A0bg_block_bitmap_hi; =A0 =A0/* Blocks bitmap b=
lock MSB */
>>>>> =A0 =A0__u32 =A0 =A0bg_inode_bitmap_hi; =A0 =A0/* Inodes bitmap b=
lock MSB */
>>>>> =A0 =A0__u32 =A0 =A0bg_inode_table_hi; =A0 =A0/* Inodes table blo=
ck MSB */
>>>>> - =A0 =A0__u16 =A0 =A0bg_free_blocks_count_hi;/* Free blocks coun=
t MSB */
>>>>> - =A0 =A0__u16 =A0 =A0bg_free_inodes_count_hi;/* Free inodes coun=
t MSB */
>>>>> + =A0 =A0__u32 =A0 =A0bg_exclude_bitmap; =A0 =A0/* Exclude bitmap=
 block MSB */
>>>>> =A0 =A0__u16 =A0 =A0bg_used_dirs_count_hi; =A0 =A0/* Directories =
count MSB */
>>>>> =A0 =A0__u16 =A0 bg_pad;
>>>>> =A0 =A0__u32 =A0 =A0bg_reserved2[3];
>>>>> @@ -190,6 +189,7 @@ struct ext4_group_desc
>>>>> #define EXT2_BG_INODE_UNINIT =A0 =A00x0001 /* Inode table/bitmap =
not initialized */
>>>>> #define EXT2_BG_BLOCK_UNINIT =A0 =A00x0002 /* Block bitmap not in=
itialized */
>>>>> #define EXT2_BG_INODE_ZEROED =A0 =A00x0004 /* On-disk itable init=
ialized to zero */
>>>>> +#define EXT2_BG_EXCLUDE_UNINIT =A0 =A00x0008 /* Exclude bitmap n=
ot initialized */
>>>>>
>>>>> /*
>>>>> =A0* Data structures used by the directory indexing feature
>>>>> @@ -751,6 +751,7 @@ struct ext2_super_block {
>>>>> #define EXT4_FEATURE_RO_COMPAT_DIR_NLINK =A0 =A00x0020
>>>>> #define EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE =A0 =A00x0040
>>>>> #define EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT =A0 =A00x0080
>>>>> +#define EXT4_FEATURE_RO_COMPAT_BITMAP_CSUM =A0 =A00x0100
>>>>>
>>>>> #define EXT2_FEATURE_INCOMPAT_COMPRESSION =A0 =A00x0001
>>>>> #define EXT2_FEATURE_INCOMPAT_FILETYPE =A0 =A0 =A0 =A00x0002
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-e=
xt4" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.h=
tml
>>>>
>>>
>
>
> Cheers, Andreas
>
>
>
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
