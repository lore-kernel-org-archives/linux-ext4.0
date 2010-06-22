From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH 1/8] e2fsprogs: Next3 on-disk format changes
Date: Tue, 22 Jun 2010 12:47:55 +0300
Message-ID: <AANLkTikAAXb90lPSH9fcz-KQa37GR3C_cCfB_b_8ZkTS@mail.gmail.com>
References: <DEF06E15-64B4-4661-9091-2F5E2BD308CC@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Amir Goldstein <amir73il@users.sf.net>,
	"linux-ext4@vger.kernel.org development" <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35845 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759186Ab0FVJr5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Jun 2010 05:47:57 -0400
Received: by bwz7 with SMTP id 7so1311256bwz.19
        for <linux-ext4@vger.kernel.org>; Tue, 22 Jun 2010 02:47:56 -0700 (PDT)
In-Reply-To: <DEF06E15-64B4-4661-9091-2F5E2BD308CC@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andreas,

Thank you for taking the time to review my patches.
=46YI, those are not the most recent patches. the latest patch series i=
s
available at:
http://sourceforge.net/projects/next3/files/Latest%20patch%20series
If you like, I can post the latest patches to the list.

Also, I suggested Next3/Ext4 merge issues as a topic for LSF:
http://marc.info/?l=3Dlinux-fsdevel&m=3D127675996522835&w=3D2

If you are interested, please help me promote this topic.

>> + =A0 =A0 { "snapshot_inum", &set_sb.s_snapshot_inum, 4, parse_uint =
},
>> + =A0 =A0 { "snapshot_id", &set_sb.s_snapshot_id, 4, parse_uint },
>> + =A0 =A0 { "snapshot_r_blocks_count", &set_sb.s_snapshot_r_blocks_c=
ount,
>> + =A0 =A0 =A0 =A0 =A0 =A0 4, parse_uint },
>> + =A0 =A0 { "snapshot_list", &set_sb.s_snapshot_list, 4, parse_uint =
},
>> =A0 =A0 =A0 { "hash_seed", &set_sb.s_hash_seed, 16, parse_uuid },
>> =A0 =A0 =A0 { "def_hash_version", &set_sb.s_def_hash_version, 1, par=
se_hashalg },
>> =A0 =A0 =A0 { "jnl_backup_type", &set_sb.s_jnl_backup_type, 1, parse=
_uint },
>
>
> These should be added into the array in superblock offset order, rath=
er than into the middle of the array.

OK. I will fix all the arrays you mentioned.

>
>
>> @@ -144,7 +144,8 @@ struct ext2_group_desc
>> =A0 =A0 =A0 __u16 =A0 bg_free_inodes_count; =A0 /* Free inodes count=
 */
>> =A0 =A0 =A0 __u16 =A0 bg_used_dirs_count; =A0 =A0 /* Directories cou=
nt */
>> =A0 =A0 =A0 __u16 =A0 bg_flags;
>> - =A0 =A0 __u32 =A0 bg_reserved
>> [2]
>> ;
>> + =A0 =A0 __u32 =A0 bg_exclude_bitmap; =A0 =A0 =A0/* Exclude bitmap =
block */
>> + =A0 =A0 __u32 =A0 bg_cow_bitmap; =A0 =A0 =A0 =A0 =A0/* COW bitmap =
block of last snapshot */
>
> These two fields were intended to hold the 32-bit checksum of the ino=
de and block bitmaps for this group. =A0Also, a 32-bit block number is =
not sufficient for a filesystem larger than 2^32 blocks, and there is n=
o way to extend this in the future to hold the full block number.

Ted has already told me to evacuate those fields, which I did.
They were moved into a per-group memory-only struct.

>
>> @@ -426,14 +427,14 @@ struct ext2_inode_large {
>> -#define i_reserved1 =A0osd1.linux1.l_i_reserved1
>> +#define i_next_snapshot =A0 =A0 =A0osd1.linux1.l_i_version
>
> This field is already in use by NFS and Lustre, I don't think it is c=
orrect to re-use it.
>

I discussed this issue with Ted and he agreed that i_version can be
overloaded with next_snapshot.
This is because snapshot files are not writable to users, so as far as
NFS and Lustre are concerned,
a snapshot file never changes, which is true. The content of a
snapshot file is frozen from snapshot take to snapshot delete.
only the metadata of snapshot files changes in time.

>> @@ -638,6 +648,10 @@ struct ext2_super_block {
>> =A0#define EXT4_FEATURE_RO_COMPAT_GDT_CSUM =A0 =A0 =A0 =A0 =A0 =A0 =A0=
0x0010
>> =A0#define EXT4_FEATURE_RO_COMPAT_DIR_NLINK =A0 =A0 0x0020
>> =A0#define EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE =A0 0x0040
>> +#define NEXT3_FEATURE_RO_COMPAT_HAS_SNAPSHOT 0x1000 /* Next3 has sn=
apshots */
>> +#define NEXT3_FEATURE_RO_COMPAT_IS_SNAPSHOT =A00x2000 /* Is a snaps=
hot image */
>> +#define NEXT3_FEATURE_RO_COMPAT_FIX_SNAPSHOT 0x4000 /* Corrupted sn=
apshot */
>> +#define NEXT3_FEATURE_RO_COMPAT_FIX_EXCLUDE =A00x8000 /* Bad exclud=
e bitmap */
>
> Are all of these states mutually exclusive? =A0Can they legally all b=
e set at the same time?
>

The last 3 features were moved to s_flags.
The 2 'fix' flags are independent and 'tune2fs -O ^has_snapshot' and
e2fsck clears them both.
'is_snapshot' is only set inside a read-only snapshot image, where
'has_snapshot' is clear.
I was going to ask Ted to re-assign me the 'is_snapshot' feature, but
didn't get around to it yet.

Thanks,
Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
