From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] libext2fs: reserve exclude bitmap fields in group descriptor
Date: Thu, 15 Sep 2011 17:03:37 +0300
Message-ID: <CAOQ4uxgCqTEMBha-13aLy5mKExquK=3Ma5LheqKaPBzCo3PRCw@mail.gmail.com>
References: <CAOQ4uxjydz_6Upm5AUErHct2J0VKSN3-d-XT+Jn=q9BJFWQtaw@mail.gmail.com>
	<99156E1E-97E0-4165-B5E3-D54004846F95@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Ted Ts'o" <tytso@mit.edu>, "Darrick J. Wong" <djwong@us.ibm.com>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f45.google.com ([209.85.212.45]:57303 "EHLO
	mail-vw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933412Ab1IOODi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Sep 2011 10:03:38 -0400
Received: by vws17 with SMTP id 17so4672472vws.4
        for <linux-ext4@vger.kernel.org>; Thu, 15 Sep 2011 07:03:37 -0700 (PDT)
In-Reply-To: <99156E1E-97E0-4165-B5E3-D54004846F95@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 15, 2011 at 1:06 PM, Andreas Dilger
<adilger.kernel@dilger.ca> wrote:
> On 2011-09-15, at 12:50 AM, Amir Goldstein wrote:
>> Here is a patch to reserve the exclude bitmap field, so we won't
>> forget them again...
>> The full patch series for adding exclude bitmap can be found here:
>> https://github.com/amir73il/e2fsprogs-snapshots-patch-queue
>>
>> ---
>> From: Amir Goldstein <amir73il@users.sf.net>
>> Date: Thu, 15 Sep 2011 09:42:38 +0300
>>
>> Ext4 snapshots require the compatible feature 'exclude_bitmap', mean=
ing that
>> the exclude bitmap was allocated.
>> The allocated exclude bitmap blocks are stored in the block group de=
scriptors.
>>
>> To allow easy migration of existing Next3 installations, I took the =
liberty
>> of 'burning' the old 'exclude_inode' compatible flag and using a new
>> 'exclude_bitmap' comaptible flag, to state the exclude bitmap blocks=
 are stored
>> in the group descriptors.
>>
>> Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
>> ---
>> lib/ext2fs/ext2_fs.h | =A0 13 +++++++++----
>> 1 files changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
>> index 54cb3d4..f1f0e19 100644
>> --- a/lib/ext2fs/ext2_fs.h
>> +++ b/lib/ext2fs/ext2_fs.h
>> @@ -142,7 +142,8 @@ struct ext2_group_desc
>> =A0 =A0 =A0 =A0__u16 =A0 bg_free_inodes_count; =A0 /* Free inodes co=
unt */
>> =A0 =A0 =A0 =A0__u16 =A0 bg_used_dirs_count; =A0 =A0 /* Directories =
count */
>> =A0 =A0 =A0 =A0__u16 =A0 bg_flags;
>> - =A0 =A0 =A0 __u32 =A0 bg_reserved[2];
>> + =A0 =A0 =A0 __u32 =A0 bg_exclude_bitmap; =A0 =A0 =A0/* Exclude bit=
map block */
>
> I'd prefer if these comments were "Snapshot exclude bitmap block" so
> that it is more clear what an exclude bitmap is used for.

I'll change that.

>
> For consistency, it would also be good to name these "_lo" to match t=
he
> kernel fields.
>

That's a major cleanup.
=46orgive me for not picking up that glove...

>> + =A0 =A0 =A0 __u32 =A0 bg_reserved[1];
>> =A0 =A0 =A0 =A0__u16 =A0 bg_itable_unused; =A0 =A0 =A0 /* Unused ino=
des count */
>> =A0 =A0 =A0 =A0__u16 =A0 bg_checksum; =A0 =A0 =A0 =A0 =A0 =A0/* crc1=
6(s_uuid+grouo_num+group_desc)*/
>> };
>> @@ -159,7 +160,8 @@ struct ext4_group_desc
>> =A0 =A0 =A0 =A0__u16 =A0 bg_free_inodes_count; =A0 /* Free inodes co=
unt */
>> =A0 =A0 =A0 =A0__u16 =A0 bg_used_dirs_count; =A0 =A0 /* Directories =
count */
>> =A0 =A0 =A0 =A0__u16 =A0 bg_flags; =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* EX=
T4_BG_flags (INODE_UNINIT, etc) */
>> - =A0 =A0 =A0 __u32 =A0 bg_reserved[2]; =A0 =A0 =A0 =A0 /* Likely bl=
ock/inode bitmap checksum */
>> + =A0 =A0 =A0 __u32 =A0 bg_exclude_bitmap; =A0 =A0 =A0/* Exclude bit=
map block */
>> + =A0 =A0 =A0 __u32 =A0 bg_reserved[1]; =A0 =A0 =A0 =A0 /* Likely bl=
ock/inode bitmap checksum */
>> =A0 =A0 =A0 =A0__u16 =A0 bg_itable_unused; =A0 =A0 =A0 /* Unused ino=
des count */
>> =A0 =A0 =A0 =A0__u16 =A0 bg_checksum; =A0 =A0 =A0 =A0 =A0 =A0/* crc1=
6(sb_uuid+group+desc) */
>> =A0 =A0 =A0 =A0__u32 =A0 bg_block_bitmap_hi; =A0 =A0 /* Blocks bitma=
p block MSB */
>>
>> @@ -169,12 +171,14 @@ struct ext4_group_desc
>> =A0 =A0 =A0 =A0__u16 =A0 bg_free_inodes_count_hi;/* Free inodes coun=
t MSB */
>> =A0 =A0 =A0 =A0__u16 =A0 bg_used_dirs_count_hi; =A0/* Directories co=
unt MSB */
>> =A0 =A0 =A0 =A0__u16 =A0 bg_itable_unused_hi; =A0 =A0/* Unused inode=
s count MSB */
>> - =A0 =A0 =A0 __u32 =A0 bg_reserved2[3];
>> + =A0 =A0 =A0 __u32 =A0 bg_exclude_bitmap_hi; =A0 /* Exclude bitmap =
block MSB */
>> + =A0 =A0 =A0 __u32 =A0 bg_reserved2[2];
>> };
>>
>> #define EXT2_BG_INODE_UNINIT =A0 0x0001 /* Inode table/bitmap not in=
itialized */
>> #define EXT2_BG_BLOCK_UNINIT =A0 0x0002 /* Block bitmap not initiali=
zed */
>> #define EXT2_BG_INODE_ZEROED =A0 0x0004 /* On-disk itable initialize=
d to zero */
>> +#define EXT2_BG_EXCLUDE_UNINIT 0x0008 /* Exclude bitmap not initial=
ized */
>>
>> /*
>> =A0* Data structures used by the directory indexing feature
>> @@ -670,7 +674,8 @@ struct ext2_super_block {
>> #define EXT2_FEATURE_COMPAT_RESIZE_INODE =A0 =A0 =A0 0x0010
>> #define EXT2_FEATURE_COMPAT_DIR_INDEX =A0 =A0 =A0 =A0 =A00x0020
>> #define EXT2_FEATURE_COMPAT_LAZY_BG =A0 =A0 =A0 =A0 =A0 =A00x0040
>> -#define EXT2_FEATURE_COMPAT_EXCLUDE_INODE =A0 =A0 =A00x0080
>> +/* #define EXT2_FEATURE_COMPAT_EXCLUDE_INODE =A0 0x0080 not used */
>> +#define EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP =A0 =A0 0x0100
>>
>> #define EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER =A0 =A00x0001
>> #define EXT2_FEATURE_RO_COMPAT_LARGE_FILE =A0 =A0 =A00x0002
>> --
>> 1.7.0.4
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
