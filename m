From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ext4: ext4_trim_fs() load buddy only when it is needed
Date: Tue, 19 Apr 2011 22:16:03 +0300
Message-ID: <BANLkTikn=BO9HsZGGXFUiH4hALecqcCV-Q@mail.gmail.com>
References: <1303144351-15614-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44314 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab1DSTQE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Apr 2011 15:16:04 -0400
Received: by ewy4 with SMTP id 4so4513ewy.19
        for <linux-ext4@vger.kernel.org>; Tue, 19 Apr 2011 12:16:03 -0700 (PDT)
In-Reply-To: <1303144351-15614-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 18, 2011 at 7:32 PM, Lukas Czerner <lczerner@redhat.com> wr=
ote:
> Currently we are loading buddy ext4_mb_load_buddy() for every block
> group we are going through in ext4_trim_fs() in many cases just to fi=
nd
> out that there is not enough space to be bothered with. As Amir Golds=
tein
> suggested we can use bb_free information directly from ext4_group_inf=
o.
>
> This commit removes ext4_mb_load_buddy() from ext4_trim_fs() and rath=
er
> get the ext4_group_info via ext4_get_group_info() and use the bb_free
> information directly from that. This avoids unnecessary call to load
> buddy in the case the group does not have enough free space to trim.
> Loading buddy is now moved to ext4_trim_all_free().
>
> Tested by me with xfstests 251.
>
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
> =A0fs/ext4/mballoc.c | =A0 48 ++++++++++++++++++++++++++-------------=
---------
> =A01 files changed, 26 insertions(+), 22 deletions(-)
>
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index d8a16ee..776d7a8 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4760,20 +4760,25 @@ static int ext4_trim_extent(struct super_bloc=
k *sb, int start, int count,
> =A0* the group buddy bitmap. This is done until whole group is scanne=
d.
> =A0*/
> =A0static ext4_grpblk_t
> -ext4_trim_all_free(struct super_block *sb, struct ext4_buddy *e4b,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_grpblk_t start, ext4_grpblk_t max,=
 ext4_grpblk_t minblocks)
> +ext4_trim_all_free(struct super_block *sb, ext4_group_t group,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_grpblk_t start, ext4_grpblk=
_t max,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_grpblk_t minblocks)
> =A0{
> =A0 =A0 =A0 =A0void *bitmap;
> =A0 =A0 =A0 =A0ext4_grpblk_t next, count =3D 0;
> - =A0 =A0 =A0 ext4_group_t group;
> + =A0 =A0 =A0 struct ext4_buddy e4b;
> =A0 =A0 =A0 =A0int ret =3D 0;
>
> - =A0 =A0 =A0 BUG_ON(e4b =3D=3D NULL);
> + =A0 =A0 =A0 ret =3D ext4_mb_load_buddy(sb, group, &e4b);
> + =A0 =A0 =A0 if (ret) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_error(sb, "Error in loading buddy =
"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "inform=
ation for %u", group);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> + =A0 =A0 =A0 }
>
> - =A0 =A0 =A0 bitmap =3D e4b->bd_bitmap;
> - =A0 =A0 =A0 group =3D e4b->bd_group;
> - =A0 =A0 =A0 start =3D (e4b->bd_info->bb_first_free > start) ?
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 e4b->bd_info->bb_first_free : start;
> + =A0 =A0 =A0 bitmap =3D e4b.bd_bitmap;
> + =A0 =A0 =A0 start =3D (e4b.bd_info->bb_first_free > start) ?
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 e4b.bd_info->bb_first_free : start;

not related to the patch, but bb_first_free sound like something that
needs lock_group
protection. I didn't check it though.
other than that, patch looks fine to me.

> =A0 =A0 =A0 =A0ext4_lock_group(sb, group);
>
> =A0 =A0 =A0 =A0while (start < max) {
> @@ -4784,7 +4789,7 @@ ext4_trim_all_free(struct super_block *sb, stru=
ct ext4_buddy *e4b,
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if ((next - start) >=3D minblocks) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D ext4_trim_exte=
nt(sb, start,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 next - =
start, group, e4b);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 next - =
start, group, &e4b);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ret < 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0count +=3D next - star=
t;
> @@ -4802,10 +4807,11 @@ ext4_trim_all_free(struct super_block *sb, st=
ruct ext4_buddy *e4b,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_lock_group(sb, gr=
oup);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((e4b->bd_info->bb_free - count) < m=
inblocks)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((e4b.bd_info->bb_free - count) < mi=
nblocks)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0ext4_unlock_group(sb, group);
> + =A0 =A0 =A0 ext4_mb_unload_buddy(&e4b);
>
> =A0 =A0 =A0 =A0ext4_debug("trimmed %d blocks in the group %d\n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0count, group);
> @@ -4830,11 +4836,11 @@ ext4_trim_all_free(struct super_block *sb, st=
ruct ext4_buddy *e4b,
> =A0*/
> =A0int ext4_trim_fs(struct super_block *sb, struct fstrim_range *rang=
e)
> =A0{
> - =A0 =A0 =A0 struct ext4_buddy e4b;
> + =A0 =A0 =A0 struct ext4_group_info *grp;
> =A0 =A0 =A0 =A0ext4_group_t first_group, last_group;
> =A0 =A0 =A0 =A0ext4_group_t group, ngroups =3D ext4_get_groups_count(=
sb);
> =A0 =A0 =A0 =A0ext4_grpblk_t cnt =3D 0, first_block, last_block;
> - =A0 =A0 =A0 uint64_t start, len, minlen, trimmed;
> + =A0 =A0 =A0 uint64_t start, len, minlen, trimmed =3D 0;
> =A0 =A0 =A0 =A0ext4_fsblk_t first_data_blk =3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0le32_to_cpu(EXT4_SB(sb=
)->s_es->s_first_data_block);
> =A0 =A0 =A0 =A0int ret =3D 0;
> @@ -4842,7 +4848,6 @@ int ext4_trim_fs(struct super_block *sb, struct=
 fstrim_range *range)
> =A0 =A0 =A0 =A0start =3D range->start >> sb->s_blocksize_bits;
> =A0 =A0 =A0 =A0len =3D range->len >> sb->s_blocksize_bits;
> =A0 =A0 =A0 =A0minlen =3D range->minlen >> sb->s_blocksize_bits;
> - =A0 =A0 =A0 trimmed =3D 0;
>
> =A0 =A0 =A0 =A0if (unlikely(minlen > EXT4_BLOCKS_PER_GROUP(sb)))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EINVAL;
> @@ -4863,11 +4868,12 @@ int ext4_trim_fs(struct super_block *sb, stru=
ct fstrim_range *range)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EINVAL;
>
> =A0 =A0 =A0 =A0for (group =3D first_group; group <=3D last_group; gro=
up++) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D ext4_mb_load_buddy(sb, group, &=
e4b);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_error(sb, "Error i=
n loading buddy "
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 "information for %u", group);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 grp =3D ext4_get_group_info(sb, group);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* We only do this if the grp has never=
 been initialized */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely(EXT4_MB_GRP_NEED_INIT(grp)=
)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D ext4_mb_init_gr=
oup(sb, group);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> @@ -4880,16 +4886,14 @@ int ext4_trim_fs(struct super_block *sb, stru=
ct fstrim_range *range)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0last_block =3D first_b=
lock + len;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0len -=3D last_block - first_block;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (e4b.bd_info->bb_free >=3D minlen) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cnt =3D ext4_trim_all_f=
ree(sb, &e4b, first_block,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (grp->bb_free >=3D minlen) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cnt =3D ext4_trim_all_f=
ree(sb, group, first_block,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0last_block, minlen);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (cnt < 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D=
 cnt;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_mb=
_unload_buddy(&e4b);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_mb_unload_buddy(&e4b);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0trimmed +=3D cnt;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0first_block =3D 0;
> =A0 =A0 =A0 =A0}
> --
> 1.7.4.2
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
