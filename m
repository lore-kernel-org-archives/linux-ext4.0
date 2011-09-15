From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: On-disk field assignments for metadata checksum and snapshots
Date: Thu, 15 Sep 2011 19:01:47 +0300
Message-ID: <CAOQ4uxihCk=o2C8Htzn5JgnbZ3zRSS+JhaiCw=gcDdgLojd94Q@mail.gmail.com>
References: <E1R4Dby-0005qO-I2@tytso-glaptop.cam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46775 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934081Ab1IOQBs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Sep 2011 12:01:48 -0400
Received: by qyk30 with SMTP id 30so5342606qyk.19
        for <linux-ext4@vger.kernel.org>; Thu, 15 Sep 2011 09:01:47 -0700 (PDT)
In-Reply-To: <E1R4Dby-0005qO-I2@tytso-glaptop.cam.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 15, 2011 at 6:12 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>
> Hi Darrick, Amir,
>
> Could you please take a look at the changes here and make sure they l=
ook
> sane to you? =A0 I just want to make sure we're all on the same page =
as
> far as on-disk field assignments are concerned.

Looks sane to me, short of one typo (see below).

>
> Also, one thought for Darrick. =A0I note that with the assignment of
> l_i_checksum, we've exhausted the very last field in the base 128-byt=
e
> inode. =A0Given that the checksum is protecting a 128 byte or 256 byt=
e
> inode, I wonder if we need to use a full 32 bit checksum. =A0Maybe we
> should just use 16 bits of a crc32c?
>
> I did some web searching on the issue, and the recommendation I've co=
me
> across is the following:
>
> =A0 =A0 =A0 =A0"Generally speaking, an n-bit CRC's error detection pr=
operties
> =A0 =A0 =A0 =A0degrade after 2**(n-1)-1 data bits."
>
> So a CRC-16 will be good up to just under 4k. =A0A 16-bit truncated c=
rc32c
> will presumably not be as good as a crc16, but seems to me that it's
> probably fine for a 128-256 byte inode. =A0Especially since the main =
thing
> we're generally worried about is detecting a block getting written to
> the wrong location, overwriting an existing inode table block. =A0So =
if we
> were really paranoid we could verify the checksums for all of the ino=
des
> in a particular inode table block when we read in the inode table blo=
ck
> in question.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>
>
> commit ceade753f14f2697d329f71b5277b49fd46fcb55
> Author: Theodore Ts'o <tytso@mit.edu>
> Date: =A0 Thu Sep 15 10:38:55 2011 -0400
>
> =A0 =A0libext2fs: add metadata checksum and snapshot feature flags
>
> =A0 =A0Reserve EXT4_FEATURE_RO_COMPAT_METADATA_CSUM and
> =A0 =A0EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP. =A0Also reserve fields in =
the
> =A0 =A0superblock and the inode for the checksums. =A0In the block gr=
oup
> =A0 =A0descriptor, reserve the exclude bitmap field for the snapshot =
feature,
> =A0 =A0and checksums for the inode and block allocation bitmaps.
>
> =A0 =A0With this commit, the metadata checksum and exclude bitmap fea=
tures
> =A0 =A0should have reserved all of the fields they need in ext4's on-=
disk
> =A0 =A0format.
>
> =A0 =A0This commit also fixes an a missing byte swap for s_overhead_b=
locks.
>
> =A0 =A0Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> =A0 =A0Cc: Darrick J. Wong <djwong@us.ibm.com>
> =A0 =A0Cc: Amir Goldstein <amir73il@gmail.com>
>
> diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
> index ac6bc25..cba9c12 100644
> --- a/debugfs/set_fields.c
> +++ b/debugfs/set_fields.c
> @@ -144,6 +144,7 @@ static struct field_set_info super_fields[] =3D {
> =A0 =A0 =A0 =A0{ "usr_quota_inum", &set_sb.s_usr_quota_inum, 4, parse=
_uint },
> =A0 =A0 =A0 =A0{ "grp_quota_inum", &set_sb.s_grp_quota_inum, 4, parse=
_uint },
> =A0 =A0 =A0 =A0{ "overhead_blocks", &set_sb.s_overhead_blocks, 4, par=
se_uint },
> + =A0 =A0 =A0 { "checksum", &set_sb.s_checksum, 2, parse_uint },
> =A0 =A0 =A0 =A0{ 0, 0, 0, 0 }
> =A0};
>
> @@ -179,6 +180,7 @@ static struct field_set_info inode_fields[] =3D {
> =A0 =A0 =A0 =A0{ "fsize", &set_inode.osd2.hurd2.h_i_fsize, 1, parse_u=
int },
> =A0 =A0 =A0 =A0{ "uid_high", &set_inode.osd2.linux2.l_i_uid_high, 2, =
parse_uint },
> =A0 =A0 =A0 =A0{ "gid_high", &set_inode.osd2.linux2.l_i_gid_high, 2, =
parse_uint },
> + =A0 =A0 =A0 { "checksum", &set_inode.osd2.linux2.l_i_checksum, 4, p=
arse_uint },
> =A0 =A0 =A0 =A0{ "author", &set_inode.osd2.hurd2.h_i_author, 4, parse=
_uint },
> =A0 =A0 =A0 =A0{ "bmap", NULL, 4, parse_bmap, FLAG_ARRAY },
> =A0 =A0 =A0 =A0{ 0, 0, 0, 0 }
> @@ -192,7 +194,6 @@ static struct field_set_info ext2_bg_fields[] =3D=
 {
> =A0 =A0 =A0 =A0{ "free_inodes_count", &set_gd.bg_free_inodes_count, 2=
, parse_uint },
> =A0 =A0 =A0 =A0{ "used_dirs_count", &set_gd.bg_used_dirs_count, 2, pa=
rse_uint },
> =A0 =A0 =A0 =A0{ "flags", &set_gd.bg_flags, 2, parse_uint },
> - =A0 =A0 =A0 { "reserved", &set_gd.bg_reserved, 2, parse_uint, FLAG_=
ARRAY, 2 },
> =A0 =A0 =A0 =A0{ "itable_unused", &set_gd.bg_itable_unused, 2, parse_=
uint },
> =A0 =A0 =A0 =A0{ "checksum", &set_gd.bg_checksum, 2, parse_gd_csum },
> =A0 =A0 =A0 =A0{ 0, 0, 0, 0 }
> diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
> index 16fba53..965fc16 100644
> --- a/lib/e2p/feature.c
> +++ b/lib/e2p/feature.c
> @@ -40,6 +40,8 @@ static struct feature feature_list[] =3D {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"resize_inode" },
> =A0 =A0 =A0 =A0{ =A0 =A0 =A0 E2P_FEATURE_COMPAT, EXT2_FEATURE_COMPAT_=
LAZY_BG,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"lazy_bg" },
> + =A0 =A0 =A0 { =A0 =A0 =A0 E2P_FEATURE_COMPAT, EXT2_FEATURE_COMPAT_E=
XCLUDE_BITMAP,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "snapshot" },

The feature name should read "exclude_bitmap".
This is a COMPAT feature which should be set by default on every mkfs.e=
xt4.
The "has_snapshot" (or "snapshots") feature is a RO_COMPAT feature, whi=
ch
can be turned on and off, depending on whether you want to enable or
disable snapshots.

Amir.

>
> =A0 =A0 =A0 =A0{ =A0 =A0 =A0 E2P_FEATURE_RO_INCOMPAT, EXT2_FEATURE_RO=
_COMPAT_SPARSE_SUPER,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"sparse_super" },
> @@ -59,6 +61,8 @@ static struct feature feature_list[] =3D {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"quota" },
> =A0 =A0 =A0 =A0{ =A0 =A0 =A0 E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO=
_COMPAT_BIGALLOC,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"bigalloc"},
> + =A0 =A0 =A0 { =A0 =A0 =A0 E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_=
COMPAT_METADATA_CSUM,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "metadata_csum"},
>
> =A0 =A0 =A0 =A0{ =A0 =A0 =A0 E2P_FEATURE_INCOMPAT, EXT2_FEATURE_INCOM=
PAT_COMPRESSION,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"compression" },
> diff --git a/lib/e2p/ls.c b/lib/e2p/ls.c
> index 0f36f40..aaacdaa 100644
> --- a/lib/e2p/ls.c
> +++ b/lib/e2p/ls.c
> @@ -413,6 +413,10 @@ void list_super2(struct ext2_super_block * sb, F=
ILE *f)
> =A0 =A0 =A0 =A0if (sb->s_grp_quota_inum)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fprintf(f, "Group quota inode: =A0 =A0=
 =A0 =A0%u\n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sb->s_grp_quota_inum);
> +
> + =A0 =A0 =A0 if (sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_ME=
TADATA_CSUM)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(f, "Checksum: =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 0x%08x\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sb->s_checksum);
> =A0}
>
> =A0void list_super (struct ext2_super_block * s)
> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
> index 4fec5db..1b02054 100644
> --- a/lib/ext2fs/ext2_fs.h
> +++ b/lib/ext2fs/ext2_fs.h
> @@ -142,7 +142,9 @@ struct ext2_group_desc
> =A0 =A0 =A0 =A0__u16 =A0 bg_free_inodes_count; =A0 /* Free inodes cou=
nt */
> =A0 =A0 =A0 =A0__u16 =A0 bg_used_dirs_count; =A0 =A0 /* Directories c=
ount */
> =A0 =A0 =A0 =A0__u16 =A0 bg_flags;
> - =A0 =A0 =A0 __u32 =A0 bg_reserved[2];
> + =A0 =A0 =A0 __u32 =A0 bg_exclude_bitmap_lo; =A0 /* Exclude bitmap f=
or snapshots */
> + =A0 =A0 =A0 __u16 =A0 bg_block_bitmap_csum_lo;/* crc32c(s_uuid+grp_=
num+bitmap) LSB */
> + =A0 =A0 =A0 __u16 =A0 bg_inode_bitmap_csum_lo;/* crc32c(s_uuid+grp_=
num+bitmap) LSB */
> =A0 =A0 =A0 =A0__u16 =A0 bg_itable_unused; =A0 =A0 =A0 /* Unused inod=
es count */
> =A0 =A0 =A0 =A0__u16 =A0 bg_checksum; =A0 =A0 =A0 =A0 =A0 =A0/* crc16=
(s_uuid+grouo_num+group_desc)*/
> =A0};
> @@ -159,7 +161,9 @@ struct ext4_group_desc
> =A0 =A0 =A0 =A0__u16 =A0 bg_free_inodes_count; =A0 /* Free inodes cou=
nt */
> =A0 =A0 =A0 =A0__u16 =A0 bg_used_dirs_count; =A0 =A0 /* Directories c=
ount */
> =A0 =A0 =A0 =A0__u16 =A0 bg_flags; =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* EXT=
4_BG_flags (INODE_UNINIT, etc) */
> - =A0 =A0 =A0 __u32 =A0 bg_reserved[2]; =A0 =A0 =A0 =A0 /* Likely blo=
ck/inode bitmap checksum */
> + =A0 =A0 =A0 __u32 =A0 bg_exclude_bitmap_lo; =A0 /* Exclude bitmap f=
or snapshots */
> + =A0 =A0 =A0 __u16 =A0 bg_block_bitmap_csum_lo;/* crc32c(s_uuid+grp_=
num+bitmap) LSB */
> + =A0 =A0 =A0 __u16 =A0 bg_inode_bitmap_csum_lo;/* crc32c(s_uuid+grp_=
num+bitmap) LSB */
> =A0 =A0 =A0 =A0__u16 =A0 bg_itable_unused; =A0 =A0 =A0 /* Unused inod=
es count */
> =A0 =A0 =A0 =A0__u16 =A0 bg_checksum; =A0 =A0 =A0 =A0 =A0 =A0/* crc16=
(sb_uuid+group+desc) */
> =A0 =A0 =A0 =A0__u32 =A0 bg_block_bitmap_hi; =A0 =A0 /* Blocks bitmap=
 block MSB */
> @@ -169,7 +173,10 @@ struct ext4_group_desc
> =A0 =A0 =A0 =A0__u16 =A0 bg_free_inodes_count_hi;/* Free inodes count=
 MSB */
> =A0 =A0 =A0 =A0__u16 =A0 bg_used_dirs_count_hi; =A0/* Directories cou=
nt MSB */
> =A0 =A0 =A0 =A0__u16 =A0 bg_itable_unused_hi; =A0 =A0/* Unused inodes=
 count MSB */
> - =A0 =A0 =A0 __u32 =A0 bg_reserved2[3];
> + =A0 =A0 =A0 __u32 =A0 bg_exclude_bitmap_hi; =A0 /* Exclude bitmap b=
lock MSB */
> + =A0 =A0 =A0 __u16 =A0 bg_block_bitmap_csum_hi;/* crc32c(s_uuid+grp_=
num+bitmap) MSB */
> + =A0 =A0 =A0 __u16 =A0 bg_inode_bitmap_csum_hi;/* crc32c(s_uuid+grp_=
num+bitmap) MSB */
> + =A0 =A0 =A0 __u32 =A0 bg_reserved;
> =A0};
>
> =A0#define EXT2_BG_INODE_UNINIT =A0 0x0001 /* Inode table/bitmap not =
initialized */
> @@ -363,7 +370,7 @@ struct ext2_inode {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u16 =A0 l_i_file_acl=
_high;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u16 =A0 l_i_uid_high=
; =A0 /* these 2 fields =A0 =A0*/
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u16 =A0 l_i_gid_high=
; =A0 /* were reserved2[0] */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 =A0 l_i_reserved2=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 =A0 l_i_checksum;=
 =A0 /* crc32c(uuid+inum+inode) */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} linux2;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u8 =A0 =A0h_i_frag; =
=A0 =A0 =A0 /* Fragment number */
> @@ -410,7 +417,7 @@ struct ext2_inode_large {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u16 =A0 l_i_file_acl=
_high;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u16 =A0 l_i_uid_high=
; =A0 /* these 2 fields =A0 =A0*/
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u16 =A0 l_i_gid_high=
; =A0 /* were reserved2[0] */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 =A0 l_i_reserved2=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 =A0 l_i_checksum;=
 =A0 /* crc32c(uuid+inum+inode) */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} linux2;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u8 =A0 =A0h_i_frag; =
=A0 =A0 =A0 /* Fragment number */
> @@ -441,7 +448,7 @@ struct ext2_inode_large {
> =A0#define i_gid_low =A0 =A0 =A0i_gid
> =A0#define i_uid_high =A0 =A0 osd2.linux2.l_i_uid_high
> =A0#define i_gid_high =A0 =A0 osd2.linux2.l_i_gid_high
> -#define i_reserved2 =A0 =A0osd2.linux2.l_i_reserved2
> +#define i_checksum =A0 =A0 osd2.linux2.l_i_checksum
> =A0#else
> =A0#if defined(__GNU__)
>
> @@ -623,7 +630,8 @@ struct ext2_super_block {
> =A0 =A0 =A0 =A0__u32 =A0 s_usr_quota_inum; =A0 =A0 =A0 /* inode numbe=
r of user quota file */
> =A0 =A0 =A0 =A0__u32 =A0 s_grp_quota_inum; =A0 =A0 =A0 /* inode numbe=
r of group quota file */
> =A0 =A0 =A0 =A0__u32 =A0 s_overhead_blocks; =A0 =A0 =A0/* overhead bl=
ocks/clusters in fs */
> - =A0 =A0 =A0 __u32 =A0 s_reserved[109]; =A0 =A0 =A0 =A0/* Padding to=
 the end of the block */
> + =A0 =A0 =A0 __u32 =A0 s_checksum; =A0 =A0 =A0 =A0 =A0 =A0 /* crc32c=
(superblock) */
> + =A0 =A0 =A0 __u32 =A0 s_reserved[108]; =A0 =A0 =A0 =A0/* Padding to=
 the end of the block */
> =A0};
>
> =A0#define EXT4_S_ERR_LEN (EXT4_S_ERR_END - EXT4_S_ERR_START)
> @@ -671,7 +679,9 @@ struct ext2_super_block {
> =A0#define EXT2_FEATURE_COMPAT_RESIZE_INODE =A0 =A0 =A0 0x0010
> =A0#define EXT2_FEATURE_COMPAT_DIR_INDEX =A0 =A0 =A0 =A0 =A00x0020
> =A0#define EXT2_FEATURE_COMPAT_LAZY_BG =A0 =A0 =A0 =A0 =A0 =A00x0040
> -#define EXT2_FEATURE_COMPAT_EXCLUDE_INODE =A0 =A0 =A00x0080
> +/* #define EXT2_FEATURE_COMPAT_EXCLUDE_INODE =A0 0x0080 not used, le=
gacy */
> +#define EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP =A0 =A0 0x0100
> +
>
> =A0#define EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER =A0 =A00x0001
> =A0#define EXT2_FEATURE_RO_COMPAT_LARGE_FILE =A0 =A0 =A00x0002
> @@ -683,6 +693,7 @@ struct ext2_super_block {
> =A0#define EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT =A0 =A00x0080
> =A0#define EXT4_FEATURE_RO_COMPAT_QUOTA =A0 =A0 =A0 =A0 =A0 0x0100
> =A0#define EXT4_FEATURE_RO_COMPAT_BIGALLOC =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A00x0200
> +#define EXT4_FEATURE_RO_COMPAT_METADATA_CSUM =A0 0x0400
>
> =A0#define EXT2_FEATURE_INCOMPAT_COMPRESSION =A0 =A0 =A00x0001
> =A0#define EXT2_FEATURE_INCOMPAT_FILETYPE =A0 =A0 =A0 =A0 0x0002
> diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
> index 87b1a2e..d1c4a56 100644
> --- a/lib/ext2fs/swapfs.c
> +++ b/lib/ext2fs/swapfs.c
> @@ -78,6 +78,8 @@ void ext2fs_swap_super(struct ext2_super_block * sb=
)
> =A0 =A0 =A0 =A0sb->s_snapshot_list =3D ext2fs_swab32(sb->s_snapshot_l=
ist);
> =A0 =A0 =A0 =A0sb->s_usr_quota_inum =3D ext2fs_swab32(sb->s_usr_quota=
_inum);
> =A0 =A0 =A0 =A0sb->s_grp_quota_inum =3D ext2fs_swab32(sb->s_grp_quota=
_inum);
> + =A0 =A0 =A0 sb->s_overhead_blocks =3D ext2fs_swab32(sb->s_overhead_=
blocks);
> + =A0 =A0 =A0 sb->s_checksum =3D ext2fs_swab32(sb->s_checksum);
>
> =A0 =A0 =A0 =A0for (i=3D0; i < 4; i++)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sb->s_hash_seed[i] =3D ext2fs_swab32(s=
b->s_hash_seed[i]);
> @@ -106,6 +108,11 @@ void ext2fs_swap_group_desc2(ext2_filsys fs, str=
uct ext2_group_desc *gdp)
> =A0 =A0 =A0 =A0gdp->bg_free_inodes_count =3D ext2fs_swab16(gdp->bg_fr=
ee_inodes_count);
> =A0 =A0 =A0 =A0gdp->bg_used_dirs_count =3D ext2fs_swab16(gdp->bg_used=
_dirs_count);
> =A0 =A0 =A0 =A0gdp->bg_flags =3D ext2fs_swab16(gdp->bg_flags);
> + =A0 =A0 =A0 gdp->bg_exclude_bitmap_lo =3D ext2fs_swab32(gdp->bg_exc=
lude_bitmap_lo);
> + =A0 =A0 =A0 gdp->bg_block_bitmap_csum_lo =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext2fs_swab16(gdp->bg_block_bitmap_csum=
_lo);
> + =A0 =A0 =A0 gdp->bg_inode_bitmap_csum_lo =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext2fs_swab16(gdp->bg_inode_bitmap_csum=
_lo);
> =A0 =A0 =A0 =A0gdp->bg_itable_unused =3D ext2fs_swab16(gdp->bg_itable=
_unused);
> =A0 =A0 =A0 =A0gdp->bg_checksum =3D ext2fs_swab16(gdp->bg_checksum);
> =A0 =A0 =A0 =A0/* If we're 32-bit, we're done */
> @@ -125,6 +132,11 @@ void ext2fs_swap_group_desc2(ext2_filsys fs, str=
uct ext2_group_desc *gdp)
> =A0 =A0 =A0 =A0gdp4->bg_used_dirs_count_hi =3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext2fs_swab16(gdp4->bg_used_dirs_count=
_hi);
> =A0 =A0 =A0 =A0gdp4->bg_itable_unused_hi =3D ext2fs_swab16(gdp4->bg_i=
table_unused_hi);
> + =A0 =A0 =A0 gdp->bg_exclude_bitmap_hi =3D ext2fs_swab16(gdp->bg_exc=
lude_bitmap_hi);
> + =A0 =A0 =A0 gdp->bg_block_bitmap_csum_hi =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext2fs_swab16(gdp->bg_block_bitmap_csum=
_hi);
> + =A0 =A0 =A0 gdp->bg_inode_bitmap_csum_hi =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext2fs_swab16(gdp->bg_inode_bitmap_csum=
_hi);
> =A0}
>
> =A0void ext2fs_swap_group_desc(struct ext2_group_desc *gdp)
> @@ -244,8 +256,8 @@ void ext2fs_swap_inode_full(ext2_filsys fs, struc=
t ext2_inode_large *t,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext2fs_swab16 (f->osd2.linux2.l_i_=
uid_high);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0t->osd2.linux2.l_i_gid_high =3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext2fs_swab16 (f->osd2.linux2.l_i_=
gid_high);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 t->osd2.linux2.l_i_reserved2 =3D
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext2fs_swab32(f->osd2.l=
inux2.l_i_reserved2);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 t->osd2.linux2.l_i_checksum =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext2fs_swab32(f->osd2.l=
inux2.checksum);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0case EXT2_OS_HURD:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0t->osd1.hurd1.h_i_translator =3D
> diff --git a/lib/ext2fs/tst_inode_size.c b/lib/ext2fs/tst_inode_size.=
c
> index 962f1cd..683b79c 100644
> --- a/lib/ext2fs/tst_inode_size.c
> +++ b/lib/ext2fs/tst_inode_size.c
> @@ -61,7 +61,7 @@ void check_structure_fields()
> =A0 =A0 =A0 =A0check_field(osd2.linux2.l_i_file_acl_high);
> =A0 =A0 =A0 =A0check_field(osd2.linux2.l_i_uid_high);
> =A0 =A0 =A0 =A0check_field(osd2.linux2.l_i_gid_high);
> - =A0 =A0 =A0 check_field(osd2.linux2.l_i_reserved2);
> + =A0 =A0 =A0 check_field(osd2.linux2.l_i_checksum);
> =A0 =A0 =A0 =A0printf("Ending offset is %d\n\n", cur_offset);
> =A0#endif
> =A0}
> diff --git a/lib/ext2fs/tst_super_size.c b/lib/ext2fs/tst_super_size.=
c
> index 1e5a524..75659ae 100644
> --- a/lib/ext2fs/tst_super_size.c
> +++ b/lib/ext2fs/tst_super_size.c
> @@ -126,6 +126,7 @@ void check_superblock_fields()
> =A0 =A0 =A0 =A0check_field(s_usr_quota_inum);
> =A0 =A0 =A0 =A0check_field(s_grp_quota_inum);
> =A0 =A0 =A0 =A0check_field(s_overhead_blocks);
> + =A0 =A0 =A0 check_field(s_checksum);
> =A0 =A0 =A0 =A0check_field(s_reserved);
> =A0 =A0 =A0 =A0printf("Ending offset is %d\n\n", cur_offset);
> =A0#endif
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
