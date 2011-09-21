From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 1/2] libext2fs: add metadata checksum and snapshot feature flags
Date: Wed, 21 Sep 2011 11:03:57 +0300
Message-ID: <CAOQ4uxiM9uet14rgNN9-ohTW6W1OrQgU4-OoteHYA3iHxtuLAw@mail.gmail.com>
References: <1316127052-1890-1-git-send-email-tytso@mit.edu>
	<1316127052-1890-2-git-send-email-tytso@mit.edu>
	<20110920185604.GK12086@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:50812 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab1IUID6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Sep 2011 04:03:58 -0400
Received: by ewy4 with SMTP id 4so962394ewy.5
        for <linux-ext4@vger.kernel.org>; Wed, 21 Sep 2011 01:03:57 -0700 (PDT)
In-Reply-To: <20110920185604.GK12086@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 20, 2011 at 9:56 PM, Darrick J. Wong <djwong@us.ibm.com> wr=
ote:
> On Thu, Sep 15, 2011 at 06:50:51PM -0400, Theodore Ts'o wrote:
>> Reserve EXT4_FEATURE_RO_COMPAT_METADATA_CSUM and
>> EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP. =A0Also reserve fields in the
>> superblock and the inode for the checksums. =A0In the block group
>> descriptor, reserve the exclude bitmap field for the snapshot featur=
e,
>> and checksums for the inode and block allocation bitmaps.
>>
>> With this commit, the metadata checksum and exclude bitmap features
>> should have reserved all of the fields they need in ext4's on-disk
>> format.
>>
>> This commit also fixes an a missing byte swap for s_overhead_blocks.
>>
>> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>> Cc: Darrick J. Wong <djwong@us.ibm.com>
>> Cc: Amir Goldstein <amir73il@gmail.com>
>> ---
>> =A0debugfs/set_fields.c =A0 =A0 =A0 =A0| =A0 =A03 ++-
>> =A0e2fsck/pass1.c =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A04 ++--
>> =A0lib/e2p/feature.c =A0 =A0 =A0 =A0 =A0 | =A0 =A04 ++++
>> =A0lib/e2p/ls.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A04 ++++
>> =A0lib/ext2fs/ext2_fs.h =A0 =A0 =A0 =A0| =A0 31 ++++++++++++++++++++=
++---------
>> =A0lib/ext2fs/swapfs.c =A0 =A0 =A0 =A0 | =A0 16 ++++++++++++++--
>> =A0lib/ext2fs/tst_inode_size.c | =A0 =A03 ++-
>> =A0lib/ext2fs/tst_super_size.c | =A0 =A01 +
>> =A08 files changed, 51 insertions(+), 15 deletions(-)
>>
>> diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
>> index ac6bc25..1a5ec7f 100644
>> --- a/debugfs/set_fields.c
>> +++ b/debugfs/set_fields.c
>> @@ -144,6 +144,7 @@ static struct field_set_info super_fields[] =3D =
{
>> =A0 =A0 =A0 { "usr_quota_inum", &set_sb.s_usr_quota_inum, 4, parse_u=
int },
>> =A0 =A0 =A0 { "grp_quota_inum", &set_sb.s_grp_quota_inum, 4, parse_u=
int },
>> =A0 =A0 =A0 { "overhead_blocks", &set_sb.s_overhead_blocks, 4, parse=
_uint },
>> + =A0 =A0 { "checksum", &set_sb.s_checksum, 4, parse_uint },
>> =A0 =A0 =A0 { 0, 0, 0, 0 }
>> =A0};
>>
>> @@ -179,6 +180,7 @@ static struct field_set_info inode_fields[] =3D =
{
>> =A0 =A0 =A0 { "fsize", &set_inode.osd2.hurd2.h_i_fsize, 1, parse_uin=
t },
>> =A0 =A0 =A0 { "uid_high", &set_inode.osd2.linux2.l_i_uid_high, 2, pa=
rse_uint },
>> =A0 =A0 =A0 { "gid_high", &set_inode.osd2.linux2.l_i_gid_high, 2, pa=
rse_uint },
>> + =A0 =A0 { "checksum", &set_inode.osd2.linux2.l_i_checksum_lo, 2, p=
arse_uint },
>> =A0 =A0 =A0 { "author", &set_inode.osd2.hurd2.h_i_author, 4, parse_u=
int },
>> =A0 =A0 =A0 { "bmap", NULL, 4, parse_bmap, FLAG_ARRAY },
>> =A0 =A0 =A0 { 0, 0, 0, 0 }
>> @@ -192,7 +194,6 @@ static struct field_set_info ext2_bg_fields[] =3D=
 {
>> =A0 =A0 =A0 { "free_inodes_count", &set_gd.bg_free_inodes_count, 2, =
parse_uint },
>> =A0 =A0 =A0 { "used_dirs_count", &set_gd.bg_used_dirs_count, 2, pars=
e_uint },
>> =A0 =A0 =A0 { "flags", &set_gd.bg_flags, 2, parse_uint },
>> - =A0 =A0 { "reserved", &set_gd.bg_reserved, 2, parse_uint, FLAG_ARR=
AY, 2 },
>> =A0 =A0 =A0 { "itable_unused", &set_gd.bg_itable_unused, 2, parse_ui=
nt },
>> =A0 =A0 =A0 { "checksum", &set_gd.bg_checksum, 2, parse_gd_csum },
>> =A0 =A0 =A0 { 0, 0, 0, 0 }
>> diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
>> index dd18ade..16ddcda 100644
>> --- a/e2fsck/pass1.c
>> +++ b/e2fsck/pass1.c
>> @@ -364,8 +364,8 @@ static void check_inode_extra_space(e2fsck_t ctx=
, struct problem_context *pctx)
>> =A0 =A0 =A0 printf("inode #%u, i_extra_size %d\n", pctx->ino,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 inode->i_extra_isize);
>> =A0#endif
>> - =A0 =A0 /* i_extra_isize must cover i_extra_isize + i_pad1 at leas=
t */
>> - =A0 =A0 min =3D sizeof(inode->i_extra_isize) + sizeof(inode->i_pad=
1);
>> + =A0 =A0 /* i_extra_isize must cover i_extra_isize + i_checksum_hi =
at least */
>> + =A0 =A0 min =3D sizeof(inode->i_extra_isize) + sizeof(inode->i_che=
cksum_hi);
>> =A0 =A0 =A0 max =3D EXT2_INODE_SIZE(sb) - EXT2_GOOD_OLD_INODE_SIZE;
>> =A0 =A0 =A0 /*
>> =A0 =A0 =A0 =A0* For now we will allow i_extra_isize to be 0, but re=
ally
>> diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
>> index 16fba53..965fc16 100644
>> --- a/lib/e2p/feature.c
>> +++ b/lib/e2p/feature.c
>> @@ -40,6 +40,8 @@ static struct feature feature_list[] =3D {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "resize_inode" },
>> =A0 =A0 =A0 { =A0 =A0 =A0 E2P_FEATURE_COMPAT, EXT2_FEATURE_COMPAT_LA=
ZY_BG,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "lazy_bg" },
>> + =A0 =A0 { =A0 =A0 =A0 E2P_FEATURE_COMPAT, EXT2_FEATURE_COMPAT_EXCL=
UDE_BITMAP,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "snapshot" },
>>
>> =A0 =A0 =A0 { =A0 =A0 =A0 E2P_FEATURE_RO_INCOMPAT, EXT2_FEATURE_RO_C=
OMPAT_SPARSE_SUPER,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "sparse_super" },
>> @@ -59,6 +61,8 @@ static struct feature feature_list[] =3D {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "quota" },
>> =A0 =A0 =A0 { =A0 =A0 =A0 E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_C=
OMPAT_BIGALLOC,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "bigalloc"},
>> + =A0 =A0 { =A0 =A0 =A0 E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COM=
PAT_METADATA_CSUM,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "metadata_csum"},
>>
>> =A0 =A0 =A0 { =A0 =A0 =A0 E2P_FEATURE_INCOMPAT, EXT2_FEATURE_INCOMPA=
T_COMPRESSION,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "compression" },
>> diff --git a/lib/e2p/ls.c b/lib/e2p/ls.c
>> index 0f36f40..aaacdaa 100644
>> --- a/lib/e2p/ls.c
>> +++ b/lib/e2p/ls.c
>> @@ -413,6 +413,10 @@ void list_super2(struct ext2_super_block * sb, =
=46ILE *f)
>> =A0 =A0 =A0 if (sb->s_grp_quota_inum)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(f, "Group quota inode: =A0 =A0 =A0=
 =A0%u\n",
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sb->s_grp_quota_inum);
>> +
>> + =A0 =A0 if (sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_METAD=
ATA_CSUM)
>> + =A0 =A0 =A0 =A0 =A0 =A0 fprintf(f, "Checksum: =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 0x%08x\n",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sb->s_checksum);
>> =A0}
>>
>> =A0void list_super (struct ext2_super_block * s)
>> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
>> index 4fec5db..1c86cb2 100644
>> --- a/lib/ext2fs/ext2_fs.h
>> +++ b/lib/ext2fs/ext2_fs.h
>> @@ -142,7 +142,9 @@ struct ext2_group_desc
>> =A0 =A0 =A0 __u16 =A0 bg_free_inodes_count; =A0 /* Free inodes count=
 */
>> =A0 =A0 =A0 __u16 =A0 bg_used_dirs_count; =A0 =A0 /* Directories cou=
nt */
>> =A0 =A0 =A0 __u16 =A0 bg_flags;
>> - =A0 =A0 __u32 =A0 bg_reserved[2];
>> + =A0 =A0 __u32 =A0 bg_exclude_bitmap_lo; =A0 /* Exclude bitmap for =
snapshots */
>> + =A0 =A0 __u16 =A0 bg_block_bitmap_csum_lo;/* crc32c(s_uuid+grp_num=
+bitmap) LSB */
>> + =A0 =A0 __u16 =A0 bg_inode_bitmap_csum_lo;/* crc32c(s_uuid+grp_num=
+bitmap) LSB */
>> =A0 =A0 =A0 __u16 =A0 bg_itable_unused; =A0 =A0 =A0 /* Unused inodes=
 count */
>> =A0 =A0 =A0 __u16 =A0 bg_checksum; =A0 =A0 =A0 =A0 =A0 =A0/* crc16(s=
_uuid+grouo_num+group_desc)*/
>> =A0};
>> @@ -159,7 +161,9 @@ struct ext4_group_desc
>> =A0 =A0 =A0 __u16 =A0 bg_free_inodes_count; =A0 /* Free inodes count=
 */
>> =A0 =A0 =A0 __u16 =A0 bg_used_dirs_count; =A0 =A0 /* Directories cou=
nt */
>> =A0 =A0 =A0 __u16 =A0 bg_flags; =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* EXT4_=
BG_flags (INODE_UNINIT, etc) */
>> - =A0 =A0 __u32 =A0 bg_reserved[2]; =A0 =A0 =A0 =A0 /* Likely block/=
inode bitmap checksum */
>> + =A0 =A0 __u32 =A0 bg_exclude_bitmap_lo; =A0 /* Exclude bitmap for =
snapshots */
>> + =A0 =A0 __u16 =A0 bg_block_bitmap_csum_lo;/* crc32c(s_uuid+grp_num=
+bitmap) LSB */
>> + =A0 =A0 __u16 =A0 bg_inode_bitmap_csum_lo;/* crc32c(s_uuid+grp_num=
+bitmap) LSB */
>> =A0 =A0 =A0 __u16 =A0 bg_itable_unused; =A0 =A0 =A0 /* Unused inodes=
 count */
>> =A0 =A0 =A0 __u16 =A0 bg_checksum; =A0 =A0 =A0 =A0 =A0 =A0/* crc16(s=
b_uuid+group+desc) */
>> =A0 =A0 =A0 __u32 =A0 bg_block_bitmap_hi; =A0 =A0 /* Blocks bitmap b=
lock MSB */
>> @@ -169,7 +173,10 @@ struct ext4_group_desc
>> =A0 =A0 =A0 __u16 =A0 bg_free_inodes_count_hi;/* Free inodes count M=
SB */
>> =A0 =A0 =A0 __u16 =A0 bg_used_dirs_count_hi; =A0/* Directories count=
 MSB */
>> =A0 =A0 =A0 __u16 =A0 bg_itable_unused_hi; =A0 =A0/* Unused inodes c=
ount MSB */
>> - =A0 =A0 __u32 =A0 bg_reserved2[3];
>> + =A0 =A0 __u32 =A0 bg_exclude_bitmap_hi; =A0 /* Exclude bitmap bloc=
k MSB */
>> + =A0 =A0 __u16 =A0 bg_block_bitmap_csum_hi;/* crc32c(s_uuid+grp_num=
+bitmap) MSB */
>> + =A0 =A0 __u16 =A0 bg_inode_bitmap_csum_hi;/* crc32c(s_uuid+grp_num=
+bitmap) MSB */
>> + =A0 =A0 __u32 =A0 bg_reserved;
>
> Should we attach a checksum to the exclude bitmap? =A0That would, unf=
ortunately,
> put the 64-byte block group pretty close to full, unless we're ok wit=
h making
> the bg even bigger...

Good point.
My initial approach (which I probably expressed somewhere) was that whe=
n
exclude_bitmap feature is set, the block bitmap checksum should cover b=
oth
block bitmap and exclude bitmap.
The reason being that exclude bitmap adds little entropy over block bit=
map:
- it should always be a sub set of block bitmap bits
- clearing exclude bit is done together with clearing the block used bi=
t
- the only case of modifying exclude bitmap only is when a used block b=
ecomes
  excluded (a.k.a moved to snapshot)

so how do you feel about compressing 2 blocks into 16bits of checksum :=
-/?

>
> --D
>> =A0};
>>
>> =A0#define EXT2_BG_INODE_UNINIT 0x0001 /* Inode table/bitmap not ini=
tialized */
>> @@ -363,7 +370,8 @@ struct ext2_inode {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u16 =A0 l_i_file_acl_h=
igh;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u16 =A0 l_i_uid_high; =
=A0 /* these 2 fields =A0 =A0*/
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u16 =A0 l_i_gid_high; =
=A0 /* were reserved2[0] */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 =A0 l_i_reserved2;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u16 =A0 l_i_checksum_lo;=
 =A0 =A0 =A0 =A0/* crc32c(uuid+inum+inode) */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u16 =A0 l_i_reserved; =A0=
 /* crc32c(uuid+inum+inode) */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 } linux2;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u8 =A0 =A0h_i_frag; =A0=
 =A0 =A0 /* Fragment number */
>> @@ -410,7 +418,8 @@ struct ext2_inode_large {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u16 =A0 l_i_file_acl_h=
igh;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u16 =A0 l_i_uid_high; =
=A0 /* these 2 fields =A0 =A0*/
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u16 =A0 l_i_gid_high; =
=A0 /* were reserved2[0] */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 =A0 l_i_reserved2;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u16 =A0 l_i_checksum_lo;=
 /* crc32c(uuid+inum+inode) */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u16 =A0 l_i_reserved;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 } linux2;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u8 =A0 =A0h_i_frag; =A0=
 =A0 =A0 /* Fragment number */
>> @@ -422,7 +431,7 @@ struct ext2_inode_large {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 } hurd2;
>> =A0 =A0 =A0 } osd2; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
/* OS dependent 2 */
>> =A0 =A0 =A0 __u16 =A0 i_extra_isize;
>> - =A0 =A0 __u16 =A0 i_pad1;
>> + =A0 =A0 __u16 =A0 i_checksum_hi; =A0/* crc32c(uuid+inum+inode) */
>> =A0 =A0 =A0 __u32 =A0 i_ctime_extra; =A0/* extra Change time (nsec <=
< 2 | epoch) */
>> =A0 =A0 =A0 __u32 =A0 i_mtime_extra; =A0/* extra Modification time (=
nsec << 2 | epoch) */
>> =A0 =A0 =A0 __u32 =A0 i_atime_extra; =A0/* extra Access time (nsec <=
< 2 | epoch) */
>> @@ -441,7 +450,7 @@ struct ext2_inode_large {
>> =A0#define i_gid_low =A0 =A0i_gid
>> =A0#define i_uid_high =A0 osd2.linux2.l_i_uid_high
>> =A0#define i_gid_high =A0 osd2.linux2.l_i_gid_high
>> -#define i_reserved2 =A0osd2.linux2.l_i_reserved2
>> +#define i_checksum =A0 osd2.linux2.l_i_checksum
>> =A0#else
>> =A0#if defined(__GNU__)
>>
>> @@ -623,7 +632,8 @@ struct ext2_super_block {
>> =A0 =A0 =A0 __u32 =A0 s_usr_quota_inum; =A0 =A0 =A0 /* inode number =
of user quota file */
>> =A0 =A0 =A0 __u32 =A0 s_grp_quota_inum; =A0 =A0 =A0 /* inode number =
of group quota file */
>> =A0 =A0 =A0 __u32 =A0 s_overhead_blocks; =A0 =A0 =A0/* overhead bloc=
ks/clusters in fs */
>> - =A0 =A0 __u32 =A0 s_reserved[109]; =A0 =A0 =A0 =A0/* Padding to th=
e end of the block */
>> + =A0 =A0 __u32 =A0 s_checksum; =A0 =A0 =A0 =A0 =A0 =A0 /* crc32c(su=
perblock) */
>> + =A0 =A0 __u32 =A0 s_reserved[108]; =A0 =A0 =A0 =A0/* Padding to th=
e end of the block */
>> =A0};
>>
>> =A0#define EXT4_S_ERR_LEN (EXT4_S_ERR_END - EXT4_S_ERR_START)
>> @@ -671,7 +681,9 @@ struct ext2_super_block {
>> =A0#define EXT2_FEATURE_COMPAT_RESIZE_INODE =A0 =A0 0x0010
>> =A0#define EXT2_FEATURE_COMPAT_DIR_INDEX =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A00x0020
>> =A0#define EXT2_FEATURE_COMPAT_LAZY_BG =A0 =A0 =A0 =A0 =A00x0040
>> -#define EXT2_FEATURE_COMPAT_EXCLUDE_INODE =A0 =A00x0080
>> +/* #define EXT2_FEATURE_COMPAT_EXCLUDE_INODE 0x0080 not used, legac=
y */
>> +#define EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP =A0 0x0100
>> +
>>
>> =A0#define EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER =A00x0001
>> =A0#define EXT2_FEATURE_RO_COMPAT_LARGE_FILE =A0 =A00x0002
>> @@ -683,6 +695,7 @@ struct ext2_super_block {
>> =A0#define EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT =A00x0080
>> =A0#define EXT4_FEATURE_RO_COMPAT_QUOTA =A0 =A0 =A0 =A0 0x0100
>> =A0#define EXT4_FEATURE_RO_COMPAT_BIGALLOC =A0 =A0 =A0 =A0 =A0 =A0 =A0=
0x0200
>> +#define EXT4_FEATURE_RO_COMPAT_METADATA_CSUM 0x0400
>>
>> =A0#define EXT2_FEATURE_INCOMPAT_COMPRESSION =A0 =A00x0001
>> =A0#define EXT2_FEATURE_INCOMPAT_FILETYPE =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 0x0002
>> diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
>> index 87b1a2e..d1c4a56 100644
>> --- a/lib/ext2fs/swapfs.c
>> +++ b/lib/ext2fs/swapfs.c
>> @@ -78,6 +78,8 @@ void ext2fs_swap_super(struct ext2_super_block * s=
b)
>> =A0 =A0 =A0 sb->s_snapshot_list =3D ext2fs_swab32(sb->s_snapshot_lis=
t);
>> =A0 =A0 =A0 sb->s_usr_quota_inum =3D ext2fs_swab32(sb->s_usr_quota_i=
num);
>> =A0 =A0 =A0 sb->s_grp_quota_inum =3D ext2fs_swab32(sb->s_grp_quota_i=
num);
>> + =A0 =A0 sb->s_overhead_blocks =3D ext2fs_swab32(sb->s_overhead_blo=
cks);
>> + =A0 =A0 sb->s_checksum =3D ext2fs_swab32(sb->s_checksum);
>>
>> =A0 =A0 =A0 for (i=3D0; i < 4; i++)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sb->s_hash_seed[i] =3D ext2fs_swab32(sb-=
>s_hash_seed[i]);
>> @@ -106,6 +108,11 @@ void ext2fs_swap_group_desc2(ext2_filsys fs, st=
ruct ext2_group_desc *gdp)
>> =A0 =A0 =A0 gdp->bg_free_inodes_count =3D ext2fs_swab16(gdp->bg_free=
_inodes_count);
>> =A0 =A0 =A0 gdp->bg_used_dirs_count =3D ext2fs_swab16(gdp->bg_used_d=
irs_count);
>> =A0 =A0 =A0 gdp->bg_flags =3D ext2fs_swab16(gdp->bg_flags);
>> + =A0 =A0 gdp->bg_exclude_bitmap_lo =3D ext2fs_swab32(gdp->bg_exclud=
e_bitmap_lo);
>> + =A0 =A0 gdp->bg_block_bitmap_csum_lo =3D
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext2fs_swab16(gdp->bg_block_bitmap_csum_lo=
);
>> + =A0 =A0 gdp->bg_inode_bitmap_csum_lo =3D
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext2fs_swab16(gdp->bg_inode_bitmap_csum_lo=
);
>> =A0 =A0 =A0 gdp->bg_itable_unused =3D ext2fs_swab16(gdp->bg_itable_u=
nused);
>> =A0 =A0 =A0 gdp->bg_checksum =3D ext2fs_swab16(gdp->bg_checksum);
>> =A0 =A0 =A0 /* If we're 32-bit, we're done */
>> @@ -125,6 +132,11 @@ void ext2fs_swap_group_desc2(ext2_filsys fs, st=
ruct ext2_group_desc *gdp)
>> =A0 =A0 =A0 gdp4->bg_used_dirs_count_hi =3D
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext2fs_swab16(gdp4->bg_used_dirs_count_h=
i);
>> =A0 =A0 =A0 gdp4->bg_itable_unused_hi =3D ext2fs_swab16(gdp4->bg_ita=
ble_unused_hi);
>> + =A0 =A0 gdp->bg_exclude_bitmap_hi =3D ext2fs_swab16(gdp->bg_exclud=
e_bitmap_hi);
>> + =A0 =A0 gdp->bg_block_bitmap_csum_hi =3D
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext2fs_swab16(gdp->bg_block_bitmap_csum_hi=
);
>> + =A0 =A0 gdp->bg_inode_bitmap_csum_hi =3D
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext2fs_swab16(gdp->bg_inode_bitmap_csum_hi=
);
>> =A0}
>>
>> =A0void ext2fs_swap_group_desc(struct ext2_group_desc *gdp)
>> @@ -244,8 +256,8 @@ void ext2fs_swap_inode_full(ext2_filsys fs, stru=
ct ext2_inode_large *t,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext2fs_swab16 (f->osd2.linux2.l_i_ui=
d_high);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 t->osd2.linux2.l_i_gid_high =3D
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext2fs_swab16 (f->osd2.linux2.l_i_gi=
d_high);
>> - =A0 =A0 =A0 =A0 =A0 =A0 t->osd2.linux2.l_i_reserved2 =3D
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext2fs_swab32(f->osd2.linu=
x2.l_i_reserved2);
>> + =A0 =A0 =A0 =A0 =A0 =A0 t->osd2.linux2.l_i_checksum =3D
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext2fs_swab32(f->osd2.linu=
x2.checksum);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> =A0 =A0 =A0 case EXT2_OS_HURD:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 t->osd1.hurd1.h_i_translator =3D
>> diff --git a/lib/ext2fs/tst_inode_size.c b/lib/ext2fs/tst_inode_size=
=2Ec
>> index 962f1cd..a4f6247 100644
>> --- a/lib/ext2fs/tst_inode_size.c
>> +++ b/lib/ext2fs/tst_inode_size.c
>> @@ -61,7 +61,8 @@ void check_structure_fields()
>> =A0 =A0 =A0 check_field(osd2.linux2.l_i_file_acl_high);
>> =A0 =A0 =A0 check_field(osd2.linux2.l_i_uid_high);
>> =A0 =A0 =A0 check_field(osd2.linux2.l_i_gid_high);
>> - =A0 =A0 check_field(osd2.linux2.l_i_reserved2);
>> + =A0 =A0 check_field(osd2.linux2.l_i_checksum_lo);
>> + =A0 =A0 check_field(osd2.linux2.l_i_reserved);
>> =A0 =A0 =A0 printf("Ending offset is %d\n\n", cur_offset);
>> =A0#endif
>> =A0}
>> diff --git a/lib/ext2fs/tst_super_size.c b/lib/ext2fs/tst_super_size=
=2Ec
>> index 1e5a524..75659ae 100644
>> --- a/lib/ext2fs/tst_super_size.c
>> +++ b/lib/ext2fs/tst_super_size.c
>> @@ -126,6 +126,7 @@ void check_superblock_fields()
>> =A0 =A0 =A0 check_field(s_usr_quota_inum);
>> =A0 =A0 =A0 check_field(s_grp_quota_inum);
>> =A0 =A0 =A0 check_field(s_overhead_blocks);
>> + =A0 =A0 check_field(s_checksum);
>> =A0 =A0 =A0 check_field(s_reserved);
>> =A0 =A0 =A0 printf("Ending offset is %d\n\n", cur_offset);
>> =A0#endif
>> --
>> 1.7.4.1.22.gec8e1.dirty
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
