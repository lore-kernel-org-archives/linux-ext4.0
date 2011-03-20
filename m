From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH, RFC 00/12] bigalloc patchset
Date: Sun, 20 Mar 2011 12:33:44 +0200
Message-ID: <AANLkTikixQLgsf=HTYkT3Xrv6m+JTJ_UoKSvc9VRfQoL@mail.gmail.com>
References: <1300570117-24048-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:65478 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab1CTKdp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 20 Mar 2011 06:33:45 -0400
Received: by qyg14 with SMTP id 14so4420419qyg.19
        for <linux-ext4@vger.kernel.org>; Sun, 20 Mar 2011 03:33:44 -0700 (PDT)
In-Reply-To: <1300570117-24048-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Mar 19, 2011 at 11:28 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> This is an initial patchset of the bigalloc patches to ext4. =A0This =
patch
> adds support for clustered allocation, so that each bit in the ext4
> block allocation bitmap addresses a power of two number of blocks. =A0=
=46or
> example, if the file system is mainly going to be storing large files=
 in
> the 4-32 megabyte range, it might make sense to set a cluster size of=
 1
> megabyte. =A0This means that each bit in the block allocaiton bitmap =
would
> now address 256 4k blocks, and it means that the size of the block
> bitmaps for a 2T file system shrinks from 64 megabytes to 256k. =A0It=
 also
> means that a block group addresses 32 gigabytes instead of 128
> megabytes, also shrinking the amount of file system overhead for
> metadata.
>
> The cost is increased disk space efficiency. =A0Directories will cons=
ume
> 1T, as will extent tree blocks. =A0(I am on the fence as to whether I
> should add complexity so that in the rare case that an inode needs mo=
re
> than 344 extents --- a highly fragmented file indeed --- and need a
> second extent tree block, we can avoid allocating any cluster and
> instead use another block from the cluster used by the inode. =A0The
> concern is the amount of complexity this adds to the e2fsck, not just=
 to
> the kernel.)

Unless you define extent tree block size =3D cluster size.
Shouldn't be too hard to teach that to kernel and fsck, right?

>
> To test these patches, I have used an *extremely* kludgy set of patch=
es
> to e2fsprogs, which are attached below. =A0These patches need *extens=
ive*
> revision before I would consider them clean enough suitable for
> committing into e2fsprogs, but they were sufficient for me to do the
> kernel-side changes --- mke2fs, dumpe2fs, and debugfs work. =A0E2fsck=
 most
> definitely does _not_ work at this stage.
>
> Please comment! =A0I do not intend for these patches to be merged dur=
ing
> the 2.6.39 merge window. =A0I am targetting 2.6.40, 3 months from now=
,
> since these patches are quite extensive.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>
> Theodore Ts'o (12):
> =A0ext4: read-only support for bigalloc file systems
> =A0ext4: enforce bigalloc restrictions (e.g., no online resizing, etc=
=2E)
> =A0ext4: Convert instances of EXT4_BLOCKS_PER_GROUP to
> =A0 =A0EXT4_CLUSTERS_PER_GROUP
> =A0ext4: Remove block bitmap initialization in ext4_new_inode()
> =A0ext4: factor out block group accounting into functions
> =A0ext4: split out ext4_free_blocks_after_init()
> =A0ext4: bigalloc changes to block bitmap initialization functions
> =A0ext4: Convert block group-relative offsets to use clusters
> =A0ext4: teach ext4_ext_map_blocks() about the bigalloc feature


I think you are missing an important patch here:

ext4: teach ext4_free_blocks() about the bigalloc feature

=46ree only clusters whose 'base' block is contained within the
requested blocks range.


> =A0ext4: teach ext4_statfs() to deal with clusters if bigalloc is
> =A0 =A0enabled
> =A0ext4: tune mballoc's default group prealloc size for bigalloc file
> =A0 =A0systems
> =A0ext4: enable mounting bigalloc as read/write
>
> =A0fs/ext4/balloc.c =A0| =A0268 +++++++++++++++++++++++++++++++++----=
----------------
> =A0fs/ext4/ext4.h =A0 =A0| =A0 47 ++++++++--
> =A0fs/ext4/extents.c | =A0132 +++++++++++++++++++++++---
> =A0fs/ext4/ialloc.c =A0| =A0 37 --------
> =A0fs/ext4/inode.c =A0 | =A0 =A07 ++
> =A0fs/ext4/ioctl.c =A0 | =A0 33 ++++++-
> =A0fs/ext4/mballoc.c | =A0 49 ++++++----
> =A0fs/ext4/mballoc.h | =A0 =A03 +-
> =A0fs/ext4/super.c =A0 | =A0100 ++++++++++++++++----
> =A09 files changed, 472 insertions(+), 204 deletions(-)
>
> --
> 1.7.3.1
>
> ------------------- e2fsprogs patches follow below
>
> diff --git a/lib/ext2fs/bmap64.h b/lib/ext2fs/bmap64.h
> index b0aa84c..cfbdfd6 100644
> --- a/lib/ext2fs/bmap64.h
> +++ b/lib/ext2fs/bmap64.h
> @@ -31,6 +31,10 @@ struct ext2fs_struct_generic_bitmap {
> =A0 =A0 =A0 =A0 ((bmap)->magic =3D=3D EXT2_ET_MAGIC_BLOCK_BITMAP64) |=
| \
> =A0 =A0 =A0 =A0 ((bmap)->magic =3D=3D EXT2_ET_MAGIC_INODE_BITMAP64))
>
> +/* Bitmap flags */
> +
> +#define EXT2_BMFLAG_CLUSTER 0x0001
> +
> =A0struct ext2_bitmap_ops {
> =A0 =A0 =A0 =A0int =A0 =A0 type;
> =A0 =A0 =A0 =A0/* Generic bmap operators */
> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
> index a89e33b..0970506 100644
> --- a/lib/ext2fs/ext2_fs.h
> +++ b/lib/ext2fs/ext2_fs.h
> @@ -228,9 +228,13 @@ struct ext2_dx_countlimit {
>
> =A0#define EXT2_BLOCKS_PER_GROUP(s) =A0 =A0 =A0 (EXT2_SB(s)->s_blocks=
_per_group)
> =A0#define EXT2_INODES_PER_GROUP(s) =A0 =A0 =A0 (EXT2_SB(s)->s_inodes=
_per_group)
> +#define EXT2_CLUSTERS_PER_GROUP(s) =A0 =A0 (EXT2_SB(s)->s_clusters_p=
er_group)
> =A0#define EXT2_INODES_PER_BLOCK(s) =A0 =A0 =A0 (EXT2_BLOCK_SIZE(s)/E=
XT2_INODE_SIZE(s))
> =A0/* limits imposed by 16-bit value gd_free_{blocks,inode}_count */
> -#define EXT2_MAX_BLOCKS_PER_GROUP(s) =A0 ((1 << 16) - 8)
> +#define EXT2_MAX_BLOCKS_PER_GROUP(s) =A0 (((1 << 16) - 8) * =A0 =A0 =
=A0\
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0(EXT2_CLUSTER_SIZE(s) / \
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 EXT2_BLOCK_SIZE(s)))
> +#define EXT2_MAX_CLUSTERS_PER_GROUP(s) ((1 << 16) - 8)
> =A0#define EXT2_MAX_INODES_PER_GROUP(s) =A0 ((1 << 16) - EXT2_INODES_=
PER_BLOCK(s))
> =A0#ifdef __KERNEL__
> =A0#define EXT2_DESC_PER_BLOCK(s) =A0 =A0 =A0 =A0 (EXT2_SB(s)->s_desc=
_per_block)
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index d3eb31d..a065e87 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -207,7 +207,7 @@ struct struct_ext2_filsys {
> =A0 =A0 =A0 =A0char * =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0device_name;
> =A0 =A0 =A0 =A0struct ext2_super_block * =A0 =A0 =A0 super;
> =A0 =A0 =A0 =A0unsigned int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bl=
ocksize;
> - =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 clustersize;
> + =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 cluster_ratio;
> =A0 =A0 =A0 =A0dgrp_t =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0group_desc_count;
> =A0 =A0 =A0 =A0unsigned long =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 desc=
_blocks;
> =A0 =A0 =A0 =A0struct opaque_ext2_group_desc * group_desc;
> @@ -232,7 +232,8 @@ struct struct_ext2_filsys {
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * Reserved for future expansion
> =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 __u32 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 reserved[7];
> + =A0 =A0 =A0 __u32 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 clustersize;
> + =A0 =A0 =A0 __u32 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 reserved[6];
>
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * Reserved for the use of the calling application.
> @@ -553,7 +554,8 @@ typedef struct ext2_icount *ext2_icount_t;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 EXT2_FEATURE_RO_COMPAT_LARGE_FILE|\
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 EXT4_FEATURE_RO_COMPAT_DIR_NLINK|\
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE|\
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0EXT4_FEATURE_RO_COMPAT_GDT_CSUM)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0EXT4_FEATURE_RO_COMPAT_GDT_CSUM|\
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0EXT4_FEATURE_RO_COMPAT_BIGALLOC)
>
> =A0/*
> =A0* These features are only allowed if EXT2_FLAG_SOFTSUPP_FEATURES i=
s passed
> diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
> index df095ac..60321df 100644
> --- a/lib/ext2fs/gen_bitmap64.c
> +++ b/lib/ext2fs/gen_bitmap64.c
> @@ -559,3 +559,85 @@ int ext2fs_warn_bitmap32(ext2fs_generic_bitmap b=
itmap, const char *func)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"called %s with 64-bit=
 bitmap", func);
> =A0#endif
> =A0}
> +
> +errcode_t ext2fs_allocate_cluster_bitmap(ext2_filsys fs,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0const char *descr,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0ext2fs_block_bitmap *ret)
> +{
> + =A0 =A0 =A0 __u64 =A0 =A0 =A0 =A0 =A0 start, end, real_end;
> + =A0 =A0 =A0 errcode_t =A0 =A0 =A0 retval;
> +
> + =A0 =A0 =A0 EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
> +
> + =A0 =A0 =A0 if (!(fs->flags & EXT2_FLAG_64BITS))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return EXT2_ET_CANT_USE_LEGACY_BITMAPS;
> +
> + =A0 =A0 =A0 fs->write_bitmaps =3D ext2fs_write_bitmaps;
> +
> + =A0 =A0 =A0 start =3D (fs->super->s_first_data_block >>
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT2_CLUSTER_SIZE_BITS(fs->super));
> + =A0 =A0 =A0 end =3D (ext2fs_blocks_count(fs->super) - 1) / fs->clus=
ter_ratio;
> + =A0 =A0 =A0 real_end =3D ((__u64) EXT2_CLUSTERS_PER_GROUP(fs->super=
)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * (__u64) fs->group_desc_count)=
-1 + start;
> +
> + =A0 =A0 =A0 retval =3D ext2fs_alloc_generic_bmap(fs,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0EXT2_ET_MAGIC_BLOCK_BITMAP64,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0EXT2FS_BMAP64_BITARRAY,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0start, end, real_end, descr, ret);
> + =A0 =A0 =A0 if (retval)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return retval;
> +
> + =A0 =A0 =A0 (*ret)->flags =3D EXT2_BMFLAG_CLUSTER;
> +
> + =A0 =A0 =A0 printf("Returning 0...\n");
> + =A0 =A0 =A0 return 0;
> +}
> +
> +int ext2fs_is_cluster_bitmap(ext2fs_block_bitmap bm)
> +{
> + =A0 =A0 =A0 if (EXT2FS_IS_32_BITMAP(bm))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> +
> + =A0 =A0 =A0 return (bm->flags & EXT2_BMFLAG_CLUSTER);
> +}
> +
> +errcode_t ext2fs_convert_to_cluster_bitmap(ext2_filsys fs,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 ext2fs_block_bitmap bmap,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 ext2fs_block_bitmap *ret)
> +{
> + =A0 =A0 =A0 ext2fs_block_bitmap =A0 =A0 cmap;
> + =A0 =A0 =A0 errcode_t =A0 =A0 =A0 =A0 =A0 =A0 =A0 retval;
> + =A0 =A0 =A0 blk64_t =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 i, j, b_end, c_=
end;
> + =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 n;
> +
> + =A0 =A0 =A0 retval =3D ext2fs_allocate_cluster_bitmap(fs, "converte=
d cluster bitmap",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 ret);
> + =A0 =A0 =A0 if (retval)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return retval;
> +
> + =A0 =A0 =A0 cmap =3D *ret;
> + =A0 =A0 =A0 i =3D bmap->start;
> + =A0 =A0 =A0 b_end =3D bmap->end;
> + =A0 =A0 =A0 bmap->end =3D bmap->real_end;
> + =A0 =A0 =A0 j =3D cmap->start;
> + =A0 =A0 =A0 c_end =3D cmap->end;
> + =A0 =A0 =A0 cmap->end =3D cmap->real_end;
> + =A0 =A0 =A0 n =3D 0;
> + =A0 =A0 =A0 while (i < bmap->real_end) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ext2fs_test_block_bitmap2(bmap, i))=
 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext2fs_mark_block_bitma=
p2(cmap, j);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 i +=3D fs->cluster_rati=
o - n;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 j++;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 n =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 i++; n++;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (n >=3D fs->cluster_ratio) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 j++;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 n =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 bmap->end =3D b_end;
> + =A0 =A0 =A0 cmap->end =3D c_end;
> + =A0 =A0 =A0 return 0;
> +}
> diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
> index e1f229b..00a8b38 100644
> --- a/lib/ext2fs/initialize.c
> +++ b/lib/ext2fs/initialize.c
> @@ -94,6 +94,7 @@ errcode_t ext2fs_initialize(const char *name, int f=
lags,
> =A0 =A0 =A0 =A0blk_t =A0 =A0 =A0 =A0 =A0 numblocks;
> =A0 =A0 =A0 =A0int =A0 =A0 =A0 =A0 =A0 =A0 rsv_gdt;
> =A0 =A0 =A0 =A0int =A0 =A0 =A0 =A0 =A0 =A0 csum_flag;
> + =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 bigalloc_flag;
> =A0 =A0 =A0 =A0int =A0 =A0 =A0 =A0 =A0 =A0 io_flags;
> =A0 =A0 =A0 =A0char =A0 =A0 =A0 =A0 =A0 =A0*buf =3D 0;
> =A0 =A0 =A0 =A0char =A0 =A0 =A0 =A0 =A0 =A0c;
> @@ -134,12 +135,25 @@ errcode_t ext2fs_initialize(const char *name, i=
nt flags,
>
> =A0#define set_field(field, default) (super->field =3D param->field ?=
 \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 p=
aram->field : (default))
> +#define assign_field(field) =A0 =A0(super->field =3D param->field)
>
> =A0 =A0 =A0 =A0super->s_magic =3D EXT2_SUPER_MAGIC;
> =A0 =A0 =A0 =A0super->s_state =3D EXT2_VALID_FS;
>
> - =A0 =A0 =A0 set_field(s_log_block_size, 0); /* default blocksize: 1=
024 bytes */
> - =A0 =A0 =A0 set_field(s_log_cluster_size, 0);
> + =A0 =A0 =A0 bigalloc_flag =3D EXT2_HAS_RO_COMPAT_FEATURE(param,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
EXT4_FEATURE_RO_COMPAT_BIGALLOC);
> +
> + =A0 =A0 =A0 assign_field(s_log_block_size);
> +
> + =A0 =A0 =A0 if (bigalloc_flag) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 set_field(s_log_cluster_size, super->s_=
log_block_size+4);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (super->s_log_block_size > super->s_=
log_cluster_size) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 retval =3D EXT2_ET_INVA=
LID_ARGUMENT;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto cleanup;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 } else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 super->s_log_cluster_size =3D super->s_=
log_block_size;
> +
> =A0 =A0 =A0 =A0set_field(s_first_data_block, super->s_log_block_size =
? 0 : 1);
> =A0 =A0 =A0 =A0set_field(s_max_mnt_count, 0);
> =A0 =A0 =A0 =A0set_field(s_errors, EXT2_ERRORS_DEFAULT);
> @@ -183,14 +197,36 @@ errcode_t ext2fs_initialize(const char *name, i=
nt flags,
>
> =A0 =A0 =A0 =A0fs->blocksize =3D EXT2_BLOCK_SIZE(super);
> =A0 =A0 =A0 =A0fs->clustersize =3D EXT2_CLUSTER_SIZE(super);
> + =A0 =A0 =A0 fs->cluster_ratio =3D fs->clustersize / fs->blocksize;
> +
> + =A0 =A0 =A0 if (bigalloc_flag) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (param->s_blocks_per_group &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 param->s_clusters_per_group &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ((param->s_clusters_per_group *=
 fs->cluster_ratio) !=3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0param->s_blocks_per_group)) =
{
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 retval =3D EXT2_ET_INVA=
LID_ARGUMENT;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto cleanup;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (param->s_clusters_per_group)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 assign_field(s_clusters=
_per_group);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (param->s_blocks_per_group)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 super->s_clusters_per_g=
roup =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 param->=
s_blocks_per_group / fs->cluster_ratio;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 super->s_clusters_per_g=
roup =3D fs->blocksize * 8;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (super->s_clusters_per_group > EXT2_=
MAX_CLUSTERS_PER_GROUP(super))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 super->s_blocks_per_gro=
up =3D EXT2_MAX_CLUSTERS_PER_GROUP(super);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 super->s_blocks_per_group =3D super->s_=
clusters_per_group;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 super->s_blocks_per_group *=3D fs->clus=
ter_ratio;
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 set_field(s_blocks_per_group, fs->block=
size * 8);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (super->s_blocks_per_group > EXT2_MA=
X_BLOCKS_PER_GROUP(super))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 super->s_blocks_per_gro=
up =3D EXT2_MAX_BLOCKS_PER_GROUP(super);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 super->s_clusters_per_group =3D super->=
s_blocks_per_group;
> + =A0 =A0 =A0 }
>
> - =A0 =A0 =A0 /* default: (fs->blocksize*8) blocks/group, up to 2^16 =
(GDT limit) */
> - =A0 =A0 =A0 set_field(s_blocks_per_group, fs->blocksize * 8);
> - =A0 =A0 =A0 if (super->s_blocks_per_group > EXT2_MAX_BLOCKS_PER_GRO=
UP(super))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 super->s_blocks_per_group =3D EXT2_MAX_=
BLOCKS_PER_GROUP(super);
> - =A0 =A0 =A0 super->s_clusters_per_group =3D super->s_blocks_per_gro=
up;
> -
> - =A0 =A0 =A0 ext2fs_blocks_count_set(super, ext2fs_blocks_count(para=
m));
> + =A0 =A0 =A0 ext2fs_blocks_count_set(super, ext2fs_blocks_count(para=
m) &
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ~((blk6=
4_t) fs->cluster_ratio - 1));
> =A0 =A0 =A0 =A0ext2fs_r_blocks_count_set(super, ext2fs_r_blocks_count=
(param));
> =A0 =A0 =A0 =A0if (ext2fs_r_blocks_count(super) >=3D ext2fs_blocks_co=
unt(param)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0retval =3D EXT2_ET_INVALID_ARGUMENT;
> @@ -246,7 +282,7 @@ retry:
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0ipg =3D ext2fs_div_ceil(super->s_inodes_count, fs->gro=
up_desc_count);
> =A0 =A0 =A0 =A0if (ipg > fs->blocksize * 8) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (super->s_blocks_per_group >=3D 256)=
 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!bigalloc_flag && super->s_blocks_p=
er_group >=3D 256) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Try again with slig=
htly different parameters */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0super->s_blocks_per_gr=
oup -=3D 8;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext2fs_blocks_count_se=
t(super,
> diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
> index 90abed1..8b37852 100644
> --- a/lib/ext2fs/openfs.c
> +++ b/lib/ext2fs/openfs.c
> @@ -251,6 +251,7 @@ errcode_t ext2fs_open2(const char *name, const ch=
ar *io_options,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto cleanup;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0fs->clustersize =3D EXT2_CLUSTER_SIZE(fs->super);
> + =A0 =A0 =A0 fs->cluster_ratio =3D fs->clustersize / fs->blocksize;
> =A0 =A0 =A0 =A0fs->inode_blocks_per_group =3D ((EXT2_INODES_PER_GROUP=
(fs->super) *
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 EXT2_INODE_SIZE(fs->super) +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 EXT2_BLOCK_SIZE(fs->super) - 1) /
> diff --git a/lib/ext2fs/rw_bitmaps.c b/lib/ext2fs/rw_bitmaps.c
> index 3031b7d..aeea997 100644
> --- a/lib/ext2fs/rw_bitmaps.c
> +++ b/lib/ext2fs/rw_bitmaps.c
> @@ -51,7 +51,7 @@ static errcode_t write_bitmaps(ext2_filsys fs, int =
do_inode, int do_block)
>
> =A0 =A0 =A0 =A0inode_nbytes =3D block_nbytes =3D 0;
> =A0 =A0 =A0 =A0if (do_block) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 block_nbytes =3D EXT2_BLOCKS_PER_GROUP(=
fs->super) / 8;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 block_nbytes =3D EXT2_CLUSTERS_PER_GROU=
P(fs->super) / 8;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0retval =3D ext2fs_get_memalign(fs->blo=
cksize, fs->blocksize,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 &block_buf);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (retval)
> @@ -85,7 +85,7 @@ static errcode_t write_bitmaps(ext2_filsys fs, int =
do_inode, int do_block)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Force bitmap paddin=
g for the last group */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0nbits =3D ((ext2fs_blo=
cks_count(fs->super)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0- =
(__u64) fs->super->s_first_data_block)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0% (_=
_u64) EXT2_BLOCKS_PER_GROUP(fs->super));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0% (_=
_u64) EXT2_CLUSTERS_PER_GROUP(fs->super));
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (nbits)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0for (j=
 =3D nbits; j < fs->blocksize * 8; j++)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0ext2fs_set_bit(j, block_buf);
> @@ -141,7 +141,7 @@ static errcode_t read_bitmaps(ext2_filsys fs, int=
 do_inode, int do_block)
> =A0 =A0 =A0 =A0char *block_bitmap =3D 0, *inode_bitmap =3D 0;
> =A0 =A0 =A0 =A0char *buf;
> =A0 =A0 =A0 =A0errcode_t retval;
> - =A0 =A0 =A0 int block_nbytes =3D EXT2_BLOCKS_PER_GROUP(fs->super) /=
 8;
> + =A0 =A0 =A0 int block_nbytes =3D EXT2_CLUSTERS_PER_GROUP(fs->super)=
 / 8;
> =A0 =A0 =A0 =A0int inode_nbytes =3D EXT2_INODES_PER_GROUP(fs->super) =
/ 8;
> =A0 =A0 =A0 =A0int csum_flag =3D 0;
> =A0 =A0 =A0 =A0int do_image =3D fs->flags & EXT2_FLAG_IMAGE_FILE;
> @@ -219,7 +219,7 @@ static errcode_t read_bitmaps(ext2_filsys fs, int=
 do_inode, int do_block)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0blk =3D (fs->image_header->offset_bloc=
kmap /
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fs->blocksize);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 blk_cnt =3D (blk64_t)EXT2_BLOCKS_PER_GR=
OUP(fs->super) *
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 blk_cnt =3D (blk64_t)EXT2_CLUSTERS_PER_=
GROUP(fs->super) *
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fs->group_desc_count;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0while (block_nbytes > 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0retval =3D io_channel_=
read_blk64(fs->image_io, blk++,
> diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
> index c01ffe5..d3f617a 100644
> --- a/misc/dumpe2fs.c
> +++ b/misc/dumpe2fs.c
> @@ -71,25 +71,26 @@ static void print_range(unsigned long long a, uns=
igned long long b)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printf("%llu-%llu", a, b);
> =A0}
>
> -static void print_free (unsigned long group, char * bitmap,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned long nbytes, u=
nsigned long offset)
> +static void print_free(unsigned long group, char * bitmap,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long nbytes, un=
signed long offset, int ratio)
> =A0{
> =A0 =A0 =A0 =A0int p =3D 0;
> =A0 =A0 =A0 =A0unsigned long i;
> =A0 =A0 =A0 =A0unsigned long j;
>
> + =A0 =A0 =A0 offset /=3D ratio;
> =A0 =A0 =A0 =A0offset +=3D group * nbytes;
> =A0 =A0 =A0 =A0for (i =3D 0; i < nbytes; i++)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!in_use (bitmap, i))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0{
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (p)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printf=
 (", ");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 print_number(i + offset=
);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 print_number((i + offse=
t) * ratio);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0for (j =3D i; j < nbyt=
es && !in_use (bitmap, j); j++)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (--j !=3D i) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fputc(=
'-', stdout);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 print_n=
umber(j + offset);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 print_n=
umber((j + offset) * ratio);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0i =3D =
j;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0p =3D 1;
> @@ -153,7 +154,7 @@ static void list_desc (ext2_filsys fs)
> =A0 =A0 =A0 =A0blk64_t =A0 =A0 =A0 =A0 blk_itr =3D fs->super->s_first=
_data_block;
> =A0 =A0 =A0 =A0ext2_ino_t =A0 =A0 =A0ino_itr =3D 1;
>
> - =A0 =A0 =A0 block_nbytes =3D EXT2_BLOCKS_PER_GROUP(fs->super) / 8;
> + =A0 =A0 =A0 block_nbytes =3D EXT2_CLUSTERS_PER_GROUP(fs->super) / 8=
;
> =A0 =A0 =A0 =A0inode_nbytes =3D EXT2_INODES_PER_GROUP(fs->super) / 8;
>
> =A0 =A0 =A0 =A0if (fs->block_map)
> @@ -238,18 +239,19 @@ static void list_desc (ext2_filsys fs)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fputs(_(" =A0Free bloc=
ks: "), stdout);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext2fs_get_block_bitma=
p_range2(fs->block_map,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 blk_i=
tr, block_nbytes << 3, block_bitmap);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 print_free (i, block_bi=
tmap,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 fs->super->s_blocks_per_group,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 fs->super->s_first_data_block);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 print_free(i, block_bit=
map,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
fs->super->s_clusters_per_group,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
fs->super->s_first_data_block,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
fs->cluster_ratio);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fputc('\n', stdout);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 blk_itr +=3D fs->super-=
>s_blocks_per_group;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 blk_itr +=3D fs->super-=
>s_clusters_per_group;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (inode_bitmap) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fputs(_(" =A0Free inod=
es: "), stdout);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext2fs_get_inode_bitma=
p_range2(fs->inode_map,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ino_i=
tr, inode_nbytes << 3, inode_bitmap);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 print_free (i, inode_bi=
tmap,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 fs->super->s_inodes_per_group, 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 print_free(i, inode_bit=
map,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
fs->super->s_inodes_per_group, 1, 1);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fputc('\n', stdout);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ino_itr +=3D fs->super=
->s_inodes_per_group;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index 9798b88..079638f 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -815,7 +815,8 @@ static __u32 ok_features[3] =3D {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT4_FEATURE_RO_COMPAT_DIR_NLINK|
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE|
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_FEATURE_RO_COMPAT_GDT_CSUM
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_FEATURE_RO_COMPAT_GDT_CSUM|
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_FEATURE_RO_COMPAT_BIGALLOC
> =A0};
>
>
> @@ -1252,7 +1253,7 @@ profile_error:
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0while ((c =3D getopt (argc, argv,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "b:cf:g:G:i:jl:m:no:qr:s:t:vE:F=
I:J:KL:M:N:O:R:ST:U:V")) !=3D EOF) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "b:cg:i:jl:m:no:qr:s:t:vC:E:FG:=
I:J:KL:M:N:O:R:ST:U:V")) !=3D EOF) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0switch (c) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case 'b':
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0blocksize =3D strtol(o=
ptarg, &tmp, 0);
> @@ -1275,17 +1276,17 @@ profile_error:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case 'c': =A0 =A0 =A0 /* Check for bad=
 blocks */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cflag++;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 case 'f':
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case 'C':
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0size =3D strtoul(optar=
g, &tmp, 0);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (size < EXT2_MIN_BLO=
CK_SIZE ||
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 size > EXT2_MAX=
_BLOCK_SIZE || *tmp) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (size < EXT2_MIN_CLU=
STER_SIZE ||
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 size > EXT2_MAX=
_CLUSTER_SIZE || *tmp) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0com_er=
r(program_name, 0,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0_("invalid fragment size - %s"),
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0optarg);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0exit(1=
);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr, _("Warn=
ing: fragments not supported. =A0"
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"Ignorin=
g -f option\n"));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fs_param.s_log_cluster_=
size =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int_log=
2(size >> EXT2_MIN_CLUSTER_LOG_SIZE);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case 'g':
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fs_param.s_blocks_per_=
group =3D strtoul(optarg, &tmp, 0);
> @@ -1515,8 +1516,6 @@ profile_error:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0check_plausibility(device_name);
> =A0 =A0 =A0 =A0check_mount(device_name, force, _("filesystem"));
>
> - =A0 =A0 =A0 fs_param.s_log_cluster_size =3D fs_param.s_log_block_si=
ze;
> -
> =A0 =A0 =A0 =A0/* Determine the size of the device (if possible) */
> =A0 =A0 =A0 =A0if (noaction && fs_blocks_count) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dev_size =3D fs_blocks_count;
> @@ -1752,16 +1751,24 @@ profile_error:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}
>
> + =A0 =A0 =A0 fs_param.s_log_block_size =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 int_log2(blocksize >> EXT2_MIN_BLOCK_LO=
G_SIZE);
> + =A0 =A0 =A0 if (fs_param.s_feature_ro_compat & EXT4_FEATURE_RO_COMP=
AT_BIGALLOC) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (fs_param.s_log_cluster_size =3D=3D =
0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fs_param.s_log_cluster_=
size =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fs_para=
m.s_log_block_size + 4;
> + =A0 =A0 =A0 } else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fs_param.s_log_cluster_size =3D fs_para=
m.s_log_block_size;
> +
> =A0 =A0 =A0 =A0if (inode_ratio =3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0inode_ratio =3D get_int_from_profile(f=
s_types, "inode_ratio",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 8192);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (inode_ratio < blocksize)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0inode_ratio =3D blocks=
ize;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (inode_ratio < EXT2_CLUSTER_SIZE(&fs=
_param))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 inode_ratio =3D EXT2_CL=
USTER_SIZE(&fs_param);
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 fs_param.s_log_cluster_size =3D fs_param.s_log_block_si=
ze =3D
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 int_log2(blocksize >> EXT2_MIN_BLOCK_LO=
G_SIZE);
> -
> =A0#ifdef HAVE_BLKID_PROBE_GET_TOPOLOGY
> =A0 =A0 =A0 =A0retval =3D get_device_geometry(device_name, &fs_param,=
 psector_size);
> =A0 =A0 =A0 =A0if (retval < 0) {
> @@ -2049,6 +2056,33 @@ static int mke2fs_discard_device(ext2_filsys f=
s)
> =A0 =A0 =A0 =A0return retval;
> =A0}
>
> +static fix_cluster_bg_counts(ext2_filsys fs)
> +{
> + =A0 =A0 =A0 blk64_t cluster, num_clusters, tot_free;
> + =A0 =A0 =A0 int =A0 =A0 grp_free, num_free, group, num;
> +
> + =A0 =A0 =A0 num_clusters =3D ext2fs_blocks_count(fs->super) / fs->c=
luster_ratio;
> + =A0 =A0 =A0 tot_free =3D num_free =3D num =3D group =3D grp_free =3D=
 0;
> + =A0 =A0 =A0 for (cluster =3D fs->super->s_first_data_block / fs->cl=
uster_ratio;
> + =A0 =A0 =A0 =A0 =A0 =A0cluster < num_clusters; cluster++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!ext2fs_test_block_bitmap2(fs->bloc=
k_map, cluster)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 grp_free++;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tot_free++;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 num++;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((num =3D=3D fs->super->s_clusters_p=
er_group) ||
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (cluster =3D=3D num_clusters-1)=
) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printf("Group %d has fr=
ee #: %d\n", group, grp_free);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext2fs_bg_free_blocks_c=
ount_set(fs, group, grp_free);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext2fs_group_desc_csum_=
set(fs, group);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 num =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 grp_free =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 group++;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 ext2fs_free_blocks_count_set(fs->super, tot_free);
> +}
> +
> =A0int main (int argc, char *argv[])
> =A0{
> =A0 =A0 =A0 =A0errcode_t =A0 =A0 =A0 retval =3D 0;
> @@ -2367,6 +2401,17 @@ int main (int argc, char *argv[])
> =A0 =A0 =A0 =A0}
> =A0no_journal:
>
> + =A0 =A0 =A0 if (EXT2_HAS_RO_COMPAT_FEATURE(&fs_param,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0EXT4_FEATURE_RO_COMPAT_BIGALLOC)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext2fs_block_bitmap cluster_map;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 retval =3D ext2fs_convert_to_cluster_bi=
tmap(fs, fs->block_map,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&cluster_map);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext2fs_free_block_bitmap(fs->block_map)=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fs->block_map =3D cluster_map;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fix_cluster_bg_counts(fs);
> + =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0if (!quiet)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printf(_("Writing superblocks and "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "filesystem accounting in=
formation: "));
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
