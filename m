From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] Add basic BIGALLOC support for cluster-based allocation
Date: Sat, 26 Feb 2011 09:20:55 +0200
Message-ID: <AANLkTi=b8eKuiOPxUiJYaDCzu1nJ40SxNqszxONC3CZ8@mail.gmail.com>
References: <1298688625-19820-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62042 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab1BZHU5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Feb 2011 02:20:57 -0500
Received: by qwd7 with SMTP id 7so1752392qwd.19
        for <linux-ext4@vger.kernel.org>; Fri, 25 Feb 2011 23:20:56 -0800 (PST)
In-Reply-To: <1298688625-19820-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 26, 2011 at 4:50 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> This adds the superblock fields needed so that dumpe2fs works and the
> code points and renames the superblock fields from describing
> fragments to clusters.
>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
> =A0debugfs/set_fields.c =A0 =A0 =A0 =A0| =A0 =A04 ++--
> =A0e2fsck/super.c =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 23 ++++++++-------=
--------
> =A0lib/e2p/feature.c =A0 =A0 =A0 =A0 =A0 | =A0 =A02 ++
> =A0lib/e2p/ls.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 14 ++++++++++++-=
-
> =A0lib/ext2fs/ext2_fs.h =A0 =A0 =A0 =A0| =A0 25 +++++++++++----------=
----
> =A0lib/ext2fs/ext2fs.h =A0 =A0 =A0 =A0 | =A0 =A04 ++--
> =A0lib/ext2fs/initialize.c =A0 =A0 | =A0 11 ++++-------
> =A0lib/ext2fs/openfs.c =A0 =A0 =A0 =A0 | =A0 =A02 +-
> =A0lib/ext2fs/swapfs.c =A0 =A0 =A0 =A0 | =A0 =A04 ++--
> =A0lib/ext2fs/tst_super_size.c | =A0 =A04 ++--
> =A0misc/mke2fs.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 24 +++++++++++++++=
+--------
> =A011 files changed, 62 insertions(+), 55 deletions(-)
>
> diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
> index 3b40117..9d7099b 100644
> --- a/debugfs/set_fields.c
> +++ b/debugfs/set_fields.c
> @@ -74,9 +74,9 @@ static struct field_set_info super_fields[] =3D {
> =A0 =A0 =A0 =A0{ "free_inodes_count", &set_sb.s_free_inodes_count, 4,=
 parse_uint },
> =A0 =A0 =A0 =A0{ "first_data_block", &set_sb.s_first_data_block, 4, p=
arse_uint },
> =A0 =A0 =A0 =A0{ "log_block_size", &set_sb.s_log_block_size, 4, parse=
_uint },
> - =A0 =A0 =A0 { "log_frag_size", &set_sb.s_log_frag_size, 4, parse_in=
t },
> + =A0 =A0 =A0 { "log_cluster_size", &set_sb.s_log_cluster_size, 4, pa=
rse_int },
> =A0 =A0 =A0 =A0{ "blocks_per_group", &set_sb.s_blocks_per_group, 4, p=
arse_uint },
> - =A0 =A0 =A0 { "frags_per_group", &set_sb.s_frags_per_group, 4, pars=
e_uint },
> + =A0 =A0 =A0 { "clusters_per_group", &set_sb.s_clusters_per_group, 4=
, parse_uint },
> =A0 =A0 =A0 =A0{ "inodes_per_group", &set_sb.s_inodes_per_group, 4, p=
arse_uint },
> =A0 =A0 =A0 =A0{ "mtime", &set_sb.s_mtime, 4, parse_time },
> =A0 =A0 =A0 =A0{ "wtime", &set_sb.s_wtime, 4, parse_time },
> diff --git a/e2fsck/super.c b/e2fsck/super.c
> index accc2f1..82c07b2 100644
> --- a/e2fsck/super.c
> +++ b/e2fsck/super.c
> @@ -501,9 +501,12 @@ void check_super_block(e2fsck_t ctx)
> =A0 =A0 =A0 =A0check_super_value(ctx, "log_block_size", sb->s_log_blo=
ck_size,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0MIN_CHECK | MAX_CH=
ECK, 0,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT2_MAX_BLOCK_LOG=
_SIZE - EXT2_MIN_BLOCK_LOG_SIZE);
> - =A0 =A0 =A0 check_super_value(ctx, "log_frag_size", sb->s_log_frag_=
size,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 MIN_CHECK | MAX_CHE=
CK, 0, sb->s_log_block_size);
> - =A0 =A0 =A0 check_super_value(ctx, "frags_per_group", sb->s_frags_p=
er_group,
> + =A0 =A0 =A0 check_super_value(ctx, "log_cluster_size",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sb->s_log_cluster_s=
ize,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 MIN_CHECK | MAX_CHE=
CK, sb->s_log_block_size,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (EXT2_MAX_CLUSTER_L=
OG_SIZE -
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT2_MIN_CLUSTER=
_LOG_SIZE));
> + =A0 =A0 =A0 check_super_value(ctx, "clusters_per_group", sb->s_clus=
ters_per_group,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0MIN_CHECK | MAX_CH=
ECK, sb->s_blocks_per_group,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bpg_max);
> =A0 =A0 =A0 =A0check_super_value(ctx, "blocks_per_group", sb->s_block=
s_per_group,
> @@ -541,24 +544,14 @@ void check_super_block(e2fsck_t ctx)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 if (sb->s_log_block_size !=3D (__u32) sb->s_log_frag_si=
ze) {
> + =A0 =A0 =A0 if (sb->s_log_block_size !=3D (__u32) sb->s_log_cluster=
_size) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pctx.blk =3D EXT2_BLOCK_SIZE(sb);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 pctx.blk2 =3D EXT2_FRAG_SIZE(sb);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pctx.blk2 =3D EXT2_CLUSTER_SIZE(sb);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fix_problem(ctx, PR_0_NO_FRAGMENTS, &p=
ctx);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ctx->flags |=3D E2F_FLAG_ABORT;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 should_be =3D sb->s_frags_per_group >>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 (sb->s_log_block_size - sb->s_log_frag_=
size);
> - =A0 =A0 =A0 if (sb->s_blocks_per_group !=3D should_be) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 pctx.blk =3D sb->s_blocks_per_group;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 pctx.blk2 =3D should_be;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 fix_problem(ctx, PR_0_BLOCKS_PER_GROUP,=
 &pctx);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ctx->flags |=3D E2F_FLAG_ABORT;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> - =A0 =A0 =A0 }
> -
> =A0 =A0 =A0 =A0should_be =3D (sb->s_log_block_size =3D=3D 0) ? 1 : 0;
> =A0 =A0 =A0 =A0if (sb->s_first_data_block !=3D should_be) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pctx.blk =3D sb->s_first_data_block;
> diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
> index 9324199..16fba53 100644
> --- a/lib/e2p/feature.c
> +++ b/lib/e2p/feature.c
> @@ -57,6 +57,8 @@ static struct feature feature_list[] =3D {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"extra_isize" },
> =A0 =A0 =A0 =A0{ =A0 =A0 =A0 E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO=
_COMPAT_QUOTA,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"quota" },
> + =A0 =A0 =A0 { =A0 =A0 =A0 E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_=
COMPAT_BIGALLOC,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "bigalloc"},
>
> =A0 =A0 =A0 =A0{ =A0 =A0 =A0 E2P_FEATURE_INCOMPAT, EXT2_FEATURE_INCOM=
PAT_COMPRESSION,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"compression" },
> diff --git a/lib/e2p/ls.c b/lib/e2p/ls.c
> index 8b8360a..04a2c71 100644
> --- a/lib/e2p/ls.c
> +++ b/lib/e2p/ls.c
> @@ -229,12 +229,22 @@ void list_super2(struct ext2_super_block * sb, =
=46ILE *f)
> =A0 =A0 =A0 =A0fprintf(f, "Free inodes: =A0 =A0 =A0 =A0 =A0 =A0 =A0%u=
\n", sb->s_free_inodes_count);
> =A0 =A0 =A0 =A0fprintf(f, "First block: =A0 =A0 =A0 =A0 =A0 =A0 =A0%u=
\n", sb->s_first_data_block);
> =A0 =A0 =A0 =A0fprintf(f, "Block size: =A0 =A0 =A0 =A0 =A0 =A0 =A0 %u=
\n", EXT2_BLOCK_SIZE(sb));
> - =A0 =A0 =A0 fprintf(f, "Fragment size: =A0 =A0 =A0 =A0 =A0 =A0%u\n"=
, EXT2_FRAG_SIZE(sb));
> + =A0 =A0 =A0 if (sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_BI=
GALLOC)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(f, "Cluster size: =A0 =A0 =A0 =A0=
 =A0 =A0 %u\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT2_CLUSTER_SIZE(sb));
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(f, "Fragment size: =A0 =A0 =A0 =
=A0 =A0 =A0%u\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT2_CLUSTER_SIZE(sb));
> =A0 =A0 =A0 =A0if (sb->s_reserved_gdt_blocks)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fprintf(f, "Reserved GDT blocks: =A0 =A0=
 =A0%u\n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sb->s_reserved_gdt_blo=
cks);
> =A0 =A0 =A0 =A0fprintf(f, "Blocks per group: =A0 =A0 =A0 =A0 %u\n", s=
b->s_blocks_per_group);
> - =A0 =A0 =A0 fprintf(f, "Fragments per group: =A0 =A0 =A0%u\n", sb->=
s_frags_per_group);
> + =A0 =A0 =A0 if (sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_BI=
GALLOC)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(f, "Clusters per group: =A0 =A0=
 =A0 %u\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sb->s_clusters_per_grou=
p);
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(f, "Fragments per group: =A0 =A0=
 =A0%u\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sb->s_clusters_per_grou=
p);
> =A0 =A0 =A0 =A0fprintf(f, "Inodes per group: =A0 =A0 =A0 =A0 %u\n", s=
b->s_inodes_per_group);
> =A0 =A0 =A0 =A0fprintf(f, "Inode blocks per group: =A0 %u\n", inode_b=
locks_per_group);
> =A0 =A0 =A0 =A0if (sb->s_raid_stride)
> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
> index f396a10..b4fc6d9 100644
> --- a/lib/ext2fs/ext2_fs.h
> +++ b/lib/ext2fs/ext2_fs.h
> @@ -98,18 +98,15 @@
> =A0#define EXT2_ADDR_PER_BLOCK(s) (EXT2_BLOCK_SIZE(s) / sizeof(__u32)=
)
>
> =A0/*
> - * Macro-instructions used to manage fragments
> + * Macro-instructions used to manage allocation clusters
> =A0*/
> -#define EXT2_MIN_FRAG_SIZE =A0 =A0 =A0 =A0 =A0 =A0 EXT2_MIN_BLOCK_SI=
ZE
> -#define EXT2_MAX_FRAG_SIZE =A0 =A0 =A0 =A0 =A0 =A0 EXT2_MAX_BLOCK_SI=
ZE
> -#define EXT2_MIN_FRAG_LOG_SIZE =A0 =A0 =A0 =A0 EXT2_MIN_BLOCK_LOG_SI=
ZE
> -#ifdef __KERNEL__
> -# define EXT2_FRAG_SIZE(s) =A0 =A0 =A0 =A0 =A0 =A0 (EXT2_SB(s)->s_fr=
ag_size)
> -# define EXT2_FRAGS_PER_BLOCK(s) =A0 =A0 =A0 (EXT2_SB(s)->s_frags_pe=
r_block)
> -#else
> -# define EXT2_FRAG_SIZE(s) =A0 =A0 =A0 =A0 =A0 =A0 (EXT2_MIN_FRAG_SI=
ZE << (s)->s_log_frag_size)
> -# define EXT2_FRAGS_PER_BLOCK(s) =A0 =A0 =A0 (EXT2_BLOCK_SIZE(s) / E=
XT2_FRAG_SIZE(s))
> -#endif
> +#define EXT2_MIN_CLUSTER_LOG_SIZE =A0 =A0 =A0EXT2_MIN_BLOCK_LOG_SIZE
> +#define EXT2_MAX_CLUSTER_LOG_SIZE =A0 =A0 =A029 =A0 =A0 =A0/* 512MB =
=A0*/
> +#define EXT2_MIN_CLUSTER_SIZE =A0 =A0 =A0 =A0 =A0EXT2_MIN_BLOCK_SIZE
> +#define EXT2_MAX_CLUSTER_SIZE =A0 =A0 =A0 =A0 =A0(1 << EXT2_MAX_CLUS=
TER_LOG_SIZE)
> +#define EXT2_CLUSTER_SIZE(s) =A0 =A0 =A0 =A0 =A0 (EXT2_MIN_BLOCK_SIZ=
E << \
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 (s)->s_log_cluster_size)
> +#define EXT2_CLUSTER_SIZE_BITS(s) =A0 =A0 =A0((s)->s_log_cluster_siz=
e + 10)
>
> =A0/*
> =A0* ACL structures
> @@ -518,9 +515,9 @@ struct ext2_super_block {
> =A0 =A0 =A0 =A0__u32 =A0 s_free_inodes_count; =A0 =A0/* Free inodes c=
ount */
> =A0 =A0 =A0 =A0__u32 =A0 s_first_data_block; =A0 =A0 /* First Data Bl=
ock */
> =A0 =A0 =A0 =A0__u32 =A0 s_log_block_size; =A0 =A0 =A0 /* Block size =
*/
> - =A0 =A0 =A0 __s32 =A0 s_log_frag_size; =A0 =A0 =A0 =A0/* Fragment s=
ize */
> + =A0 =A0 =A0 __s32 =A0 s_log_cluster_size; =A0 =A0 /* Allocation clu=
ster size */
> =A0 =A0 =A0 =A0__u32 =A0 s_blocks_per_group; =A0 =A0 /* # Blocks per =
group */
> - =A0 =A0 =A0 __u32 =A0 s_frags_per_group; =A0 =A0 =A0/* # Fragments =
per group */
> + =A0 =A0 =A0 __u32 =A0 s_clusters_per_group; =A0 /* # Fragments per =
group */
> =A0 =A0 =A0 =A0__u32 =A0 s_inodes_per_group; =A0 =A0 /* # Inodes per =
group */

Just to be clear, my alternative suggestion to on-disk format change wa=
s:

  =A0 =A0 =A0 =A0__u32 =A0 s_log_block_size; =A0 =A0 =A0 /* Block size =
*/
 - =A0 =A0 =A0 __s32 =A0 s_log_frag_size; =A0 =A0 =A0 =A0/* Fragment si=
ze */
+ =A0 =A0 =A0 __s32 =A0 s_log_cluster_size; =A0 =A0 /* Allocation clust=
er size */
 -=A0 =A0 =A0 =A0__u32 =A0 s_blocks_per_group; =A0 =A0 /* # Blocks per =
group */
+ =A0 =A0 =A0 __u32 =A0 s_clusters_per_group; =A0 /* # Clusters per gro=
up */
 - =A0 =A0 =A0 __u32 =A0 s_frags_per_group; =A0 =A0 =A0/* # Fragments p=
er group */
+ =A0 =A0 =A0 __u32 =A0 s_blocks_per_group; =A0 /* # Blocks per group *=
/
  =A0 =A0 =A0 =A0__u32 =A0 s_inodes_per_group; =A0 =A0 /* # Inodes per =
group */

This way, old kernels see a sane value in what used to be
s_blocks_per_group (32K)
and new kernels (even without the BIGALLOC feature) make sure to write
correct values
in both new s_blocks_per_group and s_clusters_per_group (old s_blocks_p=
er_group)


> =A0 =A0 =A0 =A0__u32 =A0 s_mtime; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* M=
ount time */
> =A0 =A0 =A0 =A0__u32 =A0 s_wtime; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* W=
rite time */
> @@ -675,6 +672,7 @@ struct ext2_super_block {
> =A0#define EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE =A0 =A0 0x0040
> =A0#define EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT =A0 =A00x0080
> =A0#define EXT4_FEATURE_RO_COMPAT_QUOTA =A0 =A0 =A0 =A0 =A0 0x0100
> +#define EXT4_FEATURE_RO_COMPAT_BIGALLOC =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A00x0200
>
> =A0#define EXT2_FEATURE_INCOMPAT_COMPRESSION =A0 =A0 =A00x0001
> =A0#define EXT2_FEATURE_INCOMPAT_FILETYPE =A0 =A0 =A0 =A0 0x0002
> @@ -688,7 +686,6 @@ struct ext2_super_block {
> =A0#define EXT4_FEATURE_INCOMPAT_EA_INODE =A0 =A0 =A0 =A0 0x0400
> =A0#define EXT4_FEATURE_INCOMPAT_DIRDATA =A0 =A0 =A0 =A0 =A00x1000
>
> -
> =A0#define EXT2_FEATURE_COMPAT_SUPP =A0 =A0 =A0 0
> =A0#define EXT2_FEATURE_INCOMPAT_SUPP =A0 =A0 (EXT2_FEATURE_INCOMPAT_=
=46ILETYPE)
> =A0#define EXT2_FEATURE_RO_COMPAT_SUPP =A0 =A0(EXT2_FEATURE_RO_COMPAT=
_SPARSE_SUPER| \
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index cf76562..516eb1a 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -195,7 +195,7 @@ struct struct_ext2_filsys {
> =A0 =A0 =A0 =A0char * =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0device_name;
> =A0 =A0 =A0 =A0struct ext2_super_block * =A0 =A0 =A0 super;
> =A0 =A0 =A0 =A0unsigned int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bl=
ocksize;
> - =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 fragsize;
> + =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 clustersize;
> =A0 =A0 =A0 =A0dgrp_t =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0group_desc_count;
> =A0 =A0 =A0 =A0unsigned long =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 desc=
_blocks;
> =A0 =A0 =A0 =A0struct ext2_group_desc * =A0 =A0 =A0 =A0group_desc;
> @@ -545,7 +545,7 @@ typedef struct ext2_icount *ext2_icount_t;
> =A0* to ext2fs_openfs()
> =A0*/
> =A0#define EXT2_LIB_SOFTSUPP_INCOMPAT =A0 =A0 (0)
> -#define EXT2_LIB_SOFTSUPP_RO_COMPAT =A0 =A0(0)
> +#define EXT2_LIB_SOFTSUPP_RO_COMPAT =A0 =A0(EXT4_FEATURE_RO_COMPAT_B=
IGALLOC)
>
> =A0/*
> =A0* function prototypes
> diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
> index cba2453..c109d08 100644
> --- a/lib/ext2fs/initialize.c
> +++ b/lib/ext2fs/initialize.c
> @@ -83,7 +83,6 @@ errcode_t ext2fs_initialize(const char *name, int f=
lags,
> =A0 =A0 =A0 =A0ext2_filsys =A0 =A0 fs;
> =A0 =A0 =A0 =A0errcode_t =A0 =A0 =A0 retval;
> =A0 =A0 =A0 =A0struct ext2_super_block *super;
> - =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 frags_per_block;
> =A0 =A0 =A0 =A0unsigned int =A0 =A0rem;
> =A0 =A0 =A0 =A0unsigned int =A0 =A0overhead =3D 0;
> =A0 =A0 =A0 =A0unsigned int =A0 =A0ipg;
> @@ -136,7 +135,7 @@ errcode_t ext2fs_initialize(const char *name, int=
 flags,
> =A0 =A0 =A0 =A0super->s_state =3D EXT2_VALID_FS;
>
> =A0 =A0 =A0 =A0set_field(s_log_block_size, 0); /* default blocksize: =
1024 bytes */
> - =A0 =A0 =A0 set_field(s_log_frag_size, 0); /* default fragsize: 102=
4 bytes */
> + =A0 =A0 =A0 set_field(s_log_cluster_size, 0);
> =A0 =A0 =A0 =A0set_field(s_first_data_block, super->s_log_block_size =
? 0 : 1);
> =A0 =A0 =A0 =A0set_field(s_max_mnt_count, 0);
> =A0 =A0 =A0 =A0set_field(s_errors, EXT2_ERRORS_DEFAULT);
> @@ -179,14 +178,13 @@ errcode_t ext2fs_initialize(const char *name, i=
nt flags,
> =A0 =A0 =A0 =A0super->s_creator_os =3D CREATOR_OS;
>
> =A0 =A0 =A0 =A0fs->blocksize =3D EXT2_BLOCK_SIZE(super);
> - =A0 =A0 =A0 fs->fragsize =3D EXT2_FRAG_SIZE(super);
> - =A0 =A0 =A0 frags_per_block =3D fs->blocksize / fs->fragsize;
> + =A0 =A0 =A0 fs->clustersize =3D EXT2_CLUSTER_SIZE(super);
>
> =A0 =A0 =A0 =A0/* default: (fs->blocksize*8) blocks/group, up to 2^16=
 (GDT limit) */
> =A0 =A0 =A0 =A0set_field(s_blocks_per_group, fs->blocksize * 8);
> =A0 =A0 =A0 =A0if (super->s_blocks_per_group > EXT2_MAX_BLOCKS_PER_GR=
OUP(super))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0super->s_blocks_per_group =3D EXT2_MAX=
_BLOCKS_PER_GROUP(super);
> - =A0 =A0 =A0 super->s_frags_per_group =3D super->s_blocks_per_group =
* frags_per_block;
> + =A0 =A0 =A0 super->s_clusters_per_group =3D super->s_blocks_per_gro=
up;
>
> =A0 =A0 =A0 =A0super->s_blocks_count =3D param->s_blocks_count;
> =A0 =A0 =A0 =A0super->s_r_blocks_count =3D param->s_r_blocks_count;
> @@ -239,8 +237,7 @@ retry:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Try again with slig=
htly different parameters */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0super->s_blocks_per_gr=
oup -=3D 8;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0super->s_blocks_count =
=3D param->s_blocks_count;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 super->s_frags_per_grou=
p =3D super->s_blocks_per_group *
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 frags_p=
er_block;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 super->s_clusters_per_g=
roup =3D super->s_blocks_per_group;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto retry;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0retval =3D EXT2_ET_TOO=
_MANY_INODES;
> diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
> index d638da0..a20b923 100644
> --- a/lib/ext2fs/openfs.c
> +++ b/lib/ext2fs/openfs.c
> @@ -244,7 +244,7 @@ errcode_t ext2fs_open2(const char *name, const ch=
ar *io_options,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0retval =3D EXT2_ET_CORRUPT_SUPERBLOCK;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto cleanup;
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 fs->fragsize =3D EXT2_FRAG_SIZE(fs->super);
> + =A0 =A0 =A0 fs->clustersize =3D EXT2_CLUSTER_SIZE(fs->super);
> =A0 =A0 =A0 =A0fs->inode_blocks_per_group =3D ((EXT2_INODES_PER_GROUP=
(fs->super) *
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 EXT2_INODE_SIZE(fs->super) +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 EXT2_BLOCK_SIZE(fs->super) - 1) /
> diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
> index 15ff6fc..52b0fa9 100644
> --- a/lib/ext2fs/swapfs.c
> +++ b/lib/ext2fs/swapfs.c
> @@ -31,9 +31,9 @@ void ext2fs_swap_super(struct ext2_super_block * sb=
)
> =A0 =A0 =A0 =A0sb->s_free_inodes_count =3D ext2fs_swab32(sb->s_free_i=
nodes_count);
> =A0 =A0 =A0 =A0sb->s_first_data_block =3D ext2fs_swab32(sb->s_first_d=
ata_block);
> =A0 =A0 =A0 =A0sb->s_log_block_size =3D ext2fs_swab32(sb->s_log_block=
_size);
> - =A0 =A0 =A0 sb->s_log_frag_size =3D ext2fs_swab32(sb->s_log_frag_si=
ze);
> + =A0 =A0 =A0 sb->s_log_cluster_size =3D ext2fs_swab32(sb->s_log_clus=
ter_size);
> =A0 =A0 =A0 =A0sb->s_blocks_per_group =3D ext2fs_swab32(sb->s_blocks_=
per_group);
> - =A0 =A0 =A0 sb->s_frags_per_group =3D ext2fs_swab32(sb->s_frags_per=
_group);
> + =A0 =A0 =A0 sb->s_clusters_per_group =3D ext2fs_swab32(sb->s_cluste=
rs_per_group);
> =A0 =A0 =A0 =A0sb->s_inodes_per_group =3D ext2fs_swab32(sb->s_inodes_=
per_group);
> =A0 =A0 =A0 =A0sb->s_mtime =3D ext2fs_swab32(sb->s_mtime);
> =A0 =A0 =A0 =A0sb->s_wtime =3D ext2fs_swab32(sb->s_wtime);
> diff --git a/lib/ext2fs/tst_super_size.c b/lib/ext2fs/tst_super_size.=
c
> index a3a5b44..6fffcfd 100644
> --- a/lib/ext2fs/tst_super_size.c
> +++ b/lib/ext2fs/tst_super_size.c
> @@ -50,9 +50,9 @@ void check_superblock_fields()
> =A0 =A0 =A0 =A0check_field(s_free_inodes_count);
> =A0 =A0 =A0 =A0check_field(s_first_data_block);
> =A0 =A0 =A0 =A0check_field(s_log_block_size);
> - =A0 =A0 =A0 check_field(s_log_frag_size);
> + =A0 =A0 =A0 check_field(s_log_cluster_size);
> =A0 =A0 =A0 =A0check_field(s_blocks_per_group);
> - =A0 =A0 =A0 check_field(s_frags_per_group);
> + =A0 =A0 =A0 check_field(s_clusters_per_group);
> =A0 =A0 =A0 =A0check_field(s_inodes_per_group);
> =A0 =A0 =A0 =A0check_field(s_mtime);
> =A0 =A0 =A0 =A0check_field(s_wtime);
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index a5cf16b..eace0d3 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -616,8 +616,13 @@ static void show_stats(ext2_filsys fs)
> =A0 =A0 =A0 =A0printf("\n");
> =A0 =A0 =A0 =A0printf(_("Block size=3D%u (log=3D%u)\n"), fs->blocksiz=
e,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0s->s_log_block_size);
> - =A0 =A0 =A0 printf(_("Fragment size=3D%u (log=3D%u)\n"), fs->fragsi=
ze,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 s->s_log_frag_size);
> + =A0 =A0 =A0 if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0EXT4_FEATURE_RO_COMPAT_BIGALLOC))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 printf(_("Cluster size=3D%u (log=3D%u)\=
n"),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fs->clustersize, s->s_lo=
g_cluster_size);
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 printf(_("Fragment size=3D%u (log=3D%u)=
\n"), fs->clustersize,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0s->s_log_cluster_size);
> =A0 =A0 =A0 =A0printf(_("Stride=3D%u blocks, Stripe width=3D%u blocks=
\n"),
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 s->s_raid_stride, s->s_raid_stripe_width)=
;
> =A0 =A0 =A0 =A0printf(_("%u inodes, %u blocks\n"), s->s_inodes_count,
> @@ -634,8 +639,13 @@ static void show_stats(ext2_filsys fs)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printf(_("%u block groups\n"), fs->gro=
up_desc_count);
> =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printf(_("%u block group\n"), fs->grou=
p_desc_count);
> - =A0 =A0 =A0 printf(_("%u blocks per group, %u fragments per group\n=
"),
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0s->s_blocks_per_group, s->s_frags_per_gr=
oup);
> + =A0 =A0 =A0 if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0EXT4_FEATURE_RO_COMPAT_BIGALLOC))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 printf(_("%u blocks per group, %u clust=
ers per group\n"),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0s->s_blocks_per_group, s=
->s_clusters_per_group);
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 printf(_("%u blocks per group, %u fragm=
ents per group\n"),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0s->s_blocks_per_group, s=
->s_clusters_per_group);
> =A0 =A0 =A0 =A0printf(_("%u inodes per group\n"), s->s_inodes_per_gro=
up);
>
> =A0 =A0 =A0 =A0if (fs->group_desc_count =3D=3D 1) {
> @@ -1309,8 +1319,6 @@ static void PRS(int argc, char *argv[])
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0optarg);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0exit(1=
);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fs_param.s_log_frag_siz=
e =3D
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int_log=
2(size >> EXT2_MIN_BLOCK_LOG_SIZE);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fprintf(stderr, _("War=
ning: fragments not supported. =A0"
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Ignoring=
 -f option\n"));
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> @@ -1542,7 +1550,7 @@ static void PRS(int argc, char *argv[])
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0check_plausibility(device_name);
> =A0 =A0 =A0 =A0check_mount(device_name, force, _("filesystem"));
>
> - =A0 =A0 =A0 fs_param.s_log_frag_size =3D fs_param.s_log_block_size;
> + =A0 =A0 =A0 fs_param.s_log_cluster_size =3D fs_param.s_log_block_si=
ze;
>
> =A0 =A0 =A0 =A0if (noaction && fs_param.s_blocks_count) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dev_size =3D fs_param.s_blocks_count;
> @@ -1780,7 +1788,7 @@ got_size:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0inode_ratio =3D blocks=
ize;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 fs_param.s_log_frag_size =3D fs_param.s_log_block_size =
=3D
> + =A0 =A0 =A0 fs_param.s_log_cluster_size =3D fs_param.s_log_block_si=
ze =3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int_log2(blocksize >> EXT2_MIN_BLOCK_L=
OG_SIZE);
>
> =A0#ifdef HAVE_BLKID_PROBE_GET_TOPOLOGY
> --
> 1.7.3.1
>
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
