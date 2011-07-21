From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH] e2fsprogs: add ext2fs_group_blocks_count helper
Date: Thu, 21 Jul 2011 22:54:48 +0800
Message-ID: <CAGBYx2a+n-DzZtSqCsrpVNcFFLBWBWbdJQrAGVhEKC2HM_WUoQ@mail.gmail.com>
References: <1311090411-13766-1-git-send-email-xiaoqiangnk@gmail.com>
	<4E25AE6A.6090909@redhat.com>
	<4E274CD0.1000801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:40245 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab1GUOys convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jul 2011 10:54:48 -0400
Received: by pzk37 with SMTP id 37so2024609pzk.1
        for <linux-ext4@vger.kernel.org>; Thu, 21 Jul 2011 07:54:48 -0700 (PDT)
In-Reply-To: <4E274CD0.1000801@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 21, 2011 at 5:46 AM, Eric Sandeen <sandeen@redhat.com> wrot=
e:
> Code to count the number of blocks in the last partial
> group is cut and pasted around the e2fsprogs codebase, and
> is wrong in at least one instancem as pointed out by
> Yongqiang Yang (but not fixed in this patch).
>
> Making this a helper function should improve matters.
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>
> (I have not fixed up the spot Yongqiang Yang discovered,
> but this helper should now make that fix easy to do.)
>
> =A0e2fsck/pass5.c =A0 =A0 =A0 =A0| =A0 =A06 +-----
> =A0lib/ext2fs/alloc_sb.c | =A0 10 +---------
> =A0lib/ext2fs/blknum.c =A0 | =A0 19 +++++++++++++++++++
> =A0lib/ext2fs/closefs.c =A0| =A0 =A09 +--------
> =A0lib/ext2fs/ext2fs.h =A0 | =A0 =A01 +
> =A0resize/online.c =A0 =A0 =A0 | =A0 =A07 +------
> =A0resize/resize2fs.c =A0 =A0| =A0 14 ++------------
> =A07 files changed, 26 insertions(+), 40 deletions(-)
>
>
> diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
> index b423d28..73db4e8 100644
> --- a/e2fsck/pass5.c
> +++ b/e2fsck/pass5.c
> @@ -218,11 +218,7 @@ redo_counts:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0fs->super->s_reserved_gdt_blocks;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0count =
=3D 0;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cmp_blo=
ck =3D fs->super->s_blocks_per_group;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (gro=
up =3D=3D (int)fs->group_desc_count - 1)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 cmp_block =3D
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 ext2fs_blocks_count(fs->super) %
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 fs->super->s_blocks_per_group;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cmp_blo=
ck =3D ext2fs_group_blocks_count(fs, group);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
Hi Eric,

You fixed the bug I pointed out here.  but your commit log said it is n=
ot fixed.

Yongqiang.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bitmap =3D 0;
> diff --git a/lib/ext2fs/alloc_sb.c b/lib/ext2fs/alloc_sb.c
> index d5fca3b..98aec52 100644
> --- a/lib/ext2fs/alloc_sb.c
> +++ b/lib/ext2fs/alloc_sb.c
> @@ -71,15 +71,7 @@ int ext2fs_reserve_super_and_bgd(ext2_filsys fs,
> =A0 =A0 =A0 =A0if (new_desc_blk)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext2fs_mark_block_bitmap2(bmap, new_de=
sc_blk);
>
> - =A0 =A0 =A0 if (group =3D=3D fs->group_desc_count-1) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 num_blocks =3D (ext2fs_blocks_count(fs-=
>super) -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fs->super->s=
_first_data_block) %
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fs->super->s_blocks_per=
_group;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!num_blocks)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 num_blocks =3D fs->supe=
r->s_blocks_per_group;
> - =A0 =A0 =A0 } else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 num_blocks =3D fs->super->s_blocks_per_=
group;
> -
> + =A0 =A0 =A0 num_blocks =3D ext2fs_group_blocks_count(fs, group);
> =A0 =A0 =A0 =A0num_blocks -=3D 2 + fs->inode_blocks_per_group + used_=
blks;
>
> =A0 =A0 =A0 =A0return num_blocks =A0;
> diff --git a/lib/ext2fs/blknum.c b/lib/ext2fs/blknum.c
> index b3e6dca..f1bbe9b 100644
> --- a/lib/ext2fs/blknum.c
> +++ b/lib/ext2fs/blknum.c
> @@ -43,6 +43,25 @@ blk64_t ext2fs_group_last_block2(ext2_filsys fs, d=
grp_t group)
> =A0}
>
> =A0/*
> + * Return the number of blocks in a group
> + */
> +int ext2fs_group_blocks_count(ext2_filsys fs, dgrp_t group)
> +{
> + =A0 =A0 =A0 int num_blocks;
> +
> + =A0 =A0 =A0 if (group =3D=3D fs->group_desc_count-1) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 num_blocks =3D (ext2fs_blocks_count(fs-=
>super) -
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fs->sup=
er->s_first_data_block) %
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fs->super->=
s_blocks_per_group;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!num_blocks)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 num_blocks =3D fs->supe=
r->s_blocks_per_group;
> + =A0 =A0 =A0 } else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 num_blocks =3D fs->super->s_blocks_per_=
group;
> +
> + =A0 =A0 =A0 return num_blocks;
> +}
> +
> +/*
> =A0* Return the inode data block count
> =A0*/
> =A0blk64_t ext2fs_inode_data_blocks2(ext2_filsys fs,
> diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
> index 7a23e46..b13a0c9 100644
> --- a/lib/ext2fs/closefs.c
> +++ b/lib/ext2fs/closefs.c
> @@ -150,14 +150,7 @@ int ext2fs_super_and_bgd_loc(ext2_filsys fs,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0&ret_new_desc_blk2,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0&ret_used_blks);
>
> - =A0 =A0 =A0 if (group =3D=3D fs->group_desc_count-1) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 numblocks =3D (ext2fs_blocks_count(fs->=
super) -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(blk64_t) fs=
->super->s_first_data_block) %
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (blk64_t) fs->super->s_=
blocks_per_group;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!numblocks)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 numblocks =3D fs->super=
->s_blocks_per_group;
> - =A0 =A0 =A0 } else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 numblocks =3D fs->super->s_blocks_per_g=
roup;
> + =A0 =A0 =A0 numblocks =3D ext2fs_group_blocks_count(fs, group);
>
> =A0 =A0 =A0 =A0if (ret_super_blk)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*ret_super_blk =3D (blk_t)ret_super_bl=
k2;
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index d3eb31d..5983adc 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -731,6 +731,7 @@ extern errcode_t ext2fs_get_block_bitmap_range2(e=
xt2fs_block_bitmap bmap,
> =A0extern dgrp_t ext2fs_group_of_blk2(ext2_filsys fs, blk64_t);
> =A0extern blk64_t ext2fs_group_first_block2(ext2_filsys fs, dgrp_t gr=
oup);
> =A0extern blk64_t ext2fs_group_last_block2(ext2_filsys fs, dgrp_t gro=
up);
> +extern int ext2fs_group_blocks_count(ext2_filsys fs, dgrp_t group);
> =A0extern blk64_t ext2fs_inode_data_blocks2(ext2_filsys fs,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 struct ext2_inode *inode);
> =A0extern blk64_t ext2fs_inode_i_blocks(ext2_filsys fs,
> diff --git a/resize/online.c b/resize/online.c
> index 1d8d4ec..c2b98c6 100644
> --- a/resize/online.c
> +++ b/resize/online.c
> @@ -135,12 +135,7 @@ errcode_t online_resize_fs(ext2_filsys fs, const=
 char *mtpt,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0input.block_bitmap =3D ext2fs_block_bi=
tmap_loc(new_fs, i);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0input.inode_bitmap =3D ext2fs_inode_bi=
tmap_loc(new_fs, i);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0input.inode_table =3D ext2fs_inode_tab=
le_loc(new_fs, i);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 input.blocks_count =3D sb->s_blocks_per=
_group;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (i =3D=3D new_fs->group_desc_count-1=
) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 input.blocks_count =3D =
ext2fs_blocks_count(new_fs->super) -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sb->s_f=
irst_data_block -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (i * sb=
->s_blocks_per_group);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 input.blocks_count =3D ext2fs_group_blo=
cks_count(new_fs, i);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0input.reserved_blocks =3D (blk_t) (per=
cent * input.blocks_count
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 / 100.0);
>
> diff --git a/resize/resize2fs.c b/resize/resize2fs.c
> index 216a626..4b83ca9 100644
> --- a/resize/resize2fs.c
> +++ b/resize/resize2fs.c
> @@ -499,18 +499,8 @@ retry:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext2fs_bg_flags_zap(fs, i);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (csum_flag)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext2fs_bg_flags_set(fs=
, i, EXT2_BG_INODE_UNINIT | EXT2_BG_INODE_ZEROED);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (i =3D=3D fs->group_desc_count-1) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 numblocks =3D (ext2fs_b=
locks_count(fs->super) -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0fs->super->s_first_data_block) %
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0fs->super->s_blocks_per_group;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!numblocks)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 numbloc=
ks =3D fs->super->s_blocks_per_group;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 numblocks =3D fs->super=
->s_blocks_per_group;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (csum_flag)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext2fs_=
bg_flags_set(fs, i,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT2_BG_BLOCK_UNINIT);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 numblocks =3D ext2fs_group_blocks_count=
(fs, i);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0has_super =3D ext2fs_bg_has_super(fs, =
i);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (has_super) {
>
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
