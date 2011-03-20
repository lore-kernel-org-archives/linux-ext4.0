From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH, RFC 03/12] ext4: Convert instances of EXT4_BLOCKS_PER_GROUP
 to EXT4_CLUSTERS_PER_GROUP
Date: Sun, 20 Mar 2011 12:26:57 +0200
Message-ID: <AANLkTik962xWpBCaFgfu9Xm0YkPJ8+RwTJH9Oj48Wh2r@mail.gmail.com>
References: <1300570117-24048-1-git-send-email-tytso@mit.edu>
	<1300570117-24048-4-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:49183 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab1CTK06 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 20 Mar 2011 06:26:58 -0400
Received: by qyg14 with SMTP id 14so4418606qyg.19
        for <linux-ext4@vger.kernel.org>; Sun, 20 Mar 2011 03:26:58 -0700 (PDT)
In-Reply-To: <1300570117-24048-4-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Mar 19, 2011 at 11:28 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> Change the places in fs/ext4/mballoc.c where EXT4_BLOCKS_PER_GROUP ar=
e
> used to indicate the number of bits in a block bitmap (which is reall=
y
> a cluster allocation bitmap in bigalloc file systems). =A0There are
> still some places in the ext4 codebase where usage of
> EXT4_BLOCKS_PER_GROUP needs to be audited/fixed, in code paths that
> aren't used given the initial restricted assumptions for bigalloc.
> These will need to be fixed before we can relax those restrictions.
>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
> =A0fs/ext4/mballoc.c | =A0 34 +++++++++++++++++-----------------
> =A01 files changed, 17 insertions(+), 17 deletions(-)
>
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 2f6f0dd..02f099f 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -651,7 +651,7 @@ static void ext4_mb_mark_free_simple(struct super=
_block *sb,
> =A0 =A0 =A0 =A0ext4_grpblk_t chunk;
> =A0 =A0 =A0 =A0unsigned short border;
>
> - =A0 =A0 =A0 BUG_ON(len > EXT4_BLOCKS_PER_GROUP(sb));
> + =A0 =A0 =A0 BUG_ON(len > EXT4_CLUSTERS_PER_GROUP(sb));
>
> =A0 =A0 =A0 =A0border =3D 2 << sb->s_blocksize_bits;
>
> @@ -703,7 +703,7 @@ void ext4_mb_generate_buddy(struct super_block *s=
b,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0void *=
buddy, void *bitmap, ext4_group_t group)
> =A0{
> =A0 =A0 =A0 =A0struct ext4_group_info *grp =3D ext4_get_group_info(sb=
, group);
> - =A0 =A0 =A0 ext4_grpblk_t max =3D EXT4_BLOCKS_PER_GROUP(sb);
> + =A0 =A0 =A0 ext4_grpblk_t max =3D EXT4_CLUSTERS_PER_GROUP(sb);
> =A0 =A0 =A0 =A0ext4_grpblk_t i =3D 0;
> =A0 =A0 =A0 =A0ext4_grpblk_t first;
> =A0 =A0 =A0 =A0ext4_grpblk_t len;
> @@ -1680,8 +1680,8 @@ static void ext4_mb_measure_extent(struct ext4_=
allocation_context *ac,
> =A0 =A0 =A0 =A0struct ext4_free_extent *gex =3D &ac->ac_g_ex;
>
> =A0 =A0 =A0 =A0BUG_ON(ex->fe_len <=3D 0);
> - =A0 =A0 =A0 BUG_ON(ex->fe_len > EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
> - =A0 =A0 =A0 BUG_ON(ex->fe_start >=3D EXT4_BLOCKS_PER_GROUP(ac->ac_s=
b));
> + =A0 =A0 =A0 BUG_ON(ex->fe_len > EXT4_CLUSTERS_PER_GROUP(ac->ac_sb))=
;
> + =A0 =A0 =A0 BUG_ON(ex->fe_start >=3D EXT4_CLUSTERS_PER_GROUP(ac->ac=
_sb));
> =A0 =A0 =A0 =A0BUG_ON(ac->ac_status !=3D AC_STATUS_CONTINUE);
>
> =A0 =A0 =A0 =A0ac->ac_found++;
> @@ -1879,8 +1879,8 @@ void ext4_mb_complex_scan_group(struct ext4_all=
ocation_context *ac,
>
> =A0 =A0 =A0 =A0while (free && ac->ac_status =3D=3D AC_STATUS_CONTINUE=
) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0i =3D mb_find_next_zero_bit(bitmap,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_BLOCKS_PER_GROUP(sb), i);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (i >=3D EXT4_BLOCKS_PER_GROUP(sb)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_CLUSTERS_PER_GROUP(sb), i);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (i >=3D EXT4_CLUSTERS_PER_GROUP(sb))=
 {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * IF we have corrupt =
bitmap, we won't find any
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * free blocks even th=
ough group info says we
> @@ -1943,7 +1943,7 @@ void ext4_mb_scan_aligned(struct ext4_allocatio=
n_context *ac,
> =A0 =A0 =A0 =A0do_div(a, sbi->s_stripe);
> =A0 =A0 =A0 =A0i =3D (a * sbi->s_stripe) - first_group_block;
>
> - =A0 =A0 =A0 while (i < EXT4_BLOCKS_PER_GROUP(sb)) {
> + =A0 =A0 =A0 while (i < EXT4_CLUSTERS_PER_GROUP(sb)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!mb_test_bit(i, bitmap)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0max =3D mb_find_extent=
(e4b, 0, i, sbi->s_stripe, &ex);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (max >=3D sbi->s_st=
ripe) {
> @@ -3071,7 +3071,7 @@ ext4_mb_normalize_request(struct ext4_allocatio=
n_context *ac,
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0BUG_ON(start + size <=3D ac->ac_o_ex.fe_logical &&
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0start > ac->ac_o_ex.fe=
_logical);
> - =A0 =A0 =A0 BUG_ON(size <=3D 0 || size > EXT4_BLOCKS_PER_GROUP(ac->=
ac_sb));
> + =A0 =A0 =A0 BUG_ON(size <=3D 0 || size > EXT4_CLUSTERS_PER_GROUP(ac=
->ac_sb));
>
> =A0 =A0 =A0 =A0/* now prepare goal request */
>
> @@ -3724,7 +3724,7 @@ ext4_mb_discard_group_preallocations(struct sup=
er_block *sb,
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0if (needed =3D=3D 0)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 needed =3D EXT4_BLOCKS_PER_GROUP(sb) + =
1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 needed =3D EXT4_CLUSTERS_PER_GROUP(sb) =
+ 1;
>
> =A0 =A0 =A0 =A0INIT_LIST_HEAD(&list);
> =A0repeat:
> @@ -4039,8 +4039,8 @@ ext4_mb_initialize_context(struct ext4_allocati=
on_context *ac,
> =A0 =A0 =A0 =A0len =3D ar->len;
>
> =A0 =A0 =A0 =A0/* just a dirty hack to filter too big requests =A0*/
> - =A0 =A0 =A0 if (len >=3D EXT4_BLOCKS_PER_GROUP(sb) - 10)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D EXT4_BLOCKS_PER_GROUP(sb) - 10;
> + =A0 =A0 =A0 if (len >=3D EXT4_CLUSTERS_PER_GROUP(sb) - 10)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D EXT4_CLUSTERS_PER_GROUP(sb) - 1=
0;
>
> =A0 =A0 =A0 =A0/* start searching from the goal */
> =A0 =A0 =A0 =A0goal =3D ar->goal;
> @@ -4579,8 +4579,8 @@ do_more:
> =A0 =A0 =A0 =A0 * Check to see if we are freeing blocks across a grou=
p
> =A0 =A0 =A0 =A0 * boundary.
> =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 if (bit + count > EXT4_BLOCKS_PER_GROUP(sb)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 overflow =3D bit + count - EXT4_BLOCKS_=
PER_GROUP(sb);
> + =A0 =A0 =A0 if (bit + count > EXT4_CLUSTERS_PER_GROUP(sb)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 overflow =3D bit + count - EXT4_CLUSTER=
S_PER_GROUP(sb);



On Sat, Mar 19, 2011 at 11:28 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> Change the places in fs/ext4/mballoc.c where EXT4_BLOCKS_PER_GROUP ar=
e
> used to indicate the number of bits in a block bitmap (which is reall=
y
> a cluster allocation bitmap in bigalloc file systems). =A0There are
> still some places in the ext4 codebase where usage of
> EXT4_BLOCKS_PER_GROUP needs to be audited/fixed, in code paths that
> aren't used given the initial restricted assumptions for bigalloc.
> These will need to be fixed before we can relax those restrictions.
>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
> =A0fs/ext4/mballoc.c | =A0 34 +++++++++++++++++-----------------
> =A01 files changed, 17 insertions(+), 17 deletions(-)
>
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 2f6f0dd..02f099f 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -651,7 +651,7 @@ static void ext4_mb_mark_free_simple(struct super=
_block *sb,
> =A0 =A0 =A0 =A0ext4_grpblk_t chunk;
> =A0 =A0 =A0 =A0unsigned short border;
>
> - =A0 =A0 =A0 BUG_ON(len > EXT4_BLOCKS_PER_GROUP(sb));
> + =A0 =A0 =A0 BUG_ON(len > EXT4_CLUSTERS_PER_GROUP(sb));
>
> =A0 =A0 =A0 =A0border =3D 2 << sb->s_blocksize_bits;
>
> @@ -703,7 +703,7 @@ void ext4_mb_generate_buddy(struct super_block *s=
b,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0void *=
buddy, void *bitmap, ext4_group_t group)
> =A0{
> =A0 =A0 =A0 =A0struct ext4_group_info *grp =3D ext4_get_group_info(sb=
, group);
> - =A0 =A0 =A0 ext4_grpblk_t max =3D EXT4_BLOCKS_PER_GROUP(sb);
> + =A0 =A0 =A0 ext4_grpblk_t max =3D EXT4_CLUSTERS_PER_GROUP(sb);
> =A0 =A0 =A0 =A0ext4_grpblk_t i =3D 0;
> =A0 =A0 =A0 =A0ext4_grpblk_t first;
> =A0 =A0 =A0 =A0ext4_grpblk_t len;
> @@ -1680,8 +1680,8 @@ static void ext4_mb_measure_extent(struct ext4_=
allocation_context *ac,
> =A0 =A0 =A0 =A0struct ext4_free_extent *gex =3D &ac->ac_g_ex;
>
> =A0 =A0 =A0 =A0BUG_ON(ex->fe_len <=3D 0);
> - =A0 =A0 =A0 BUG_ON(ex->fe_len > EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
> - =A0 =A0 =A0 BUG_ON(ex->fe_start >=3D EXT4_BLOCKS_PER_GROUP(ac->ac_s=
b));
> + =A0 =A0 =A0 BUG_ON(ex->fe_len > EXT4_CLUSTERS_PER_GROUP(ac->ac_sb))=
;
> + =A0 =A0 =A0 BUG_ON(ex->fe_start >=3D EXT4_CLUSTERS_PER_GROUP(ac->ac=
_sb));
> =A0 =A0 =A0 =A0BUG_ON(ac->ac_status !=3D AC_STATUS_CONTINUE);
>
> =A0 =A0 =A0 =A0ac->ac_found++;
> @@ -1879,8 +1879,8 @@ void ext4_mb_complex_scan_group(struct ext4_all=
ocation_context *ac,
>
> =A0 =A0 =A0 =A0while (free && ac->ac_status =3D=3D AC_STATUS_CONTINUE=
) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0i =3D mb_find_next_zero_bit(bitmap,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_BLOCKS_PER_GROUP(sb), i);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (i >=3D EXT4_BLOCKS_PER_GROUP(sb)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_CLUSTERS_PER_GROUP(sb), i);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (i >=3D EXT4_CLUSTERS_PER_GROUP(sb))=
 {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * IF we have corrupt =
bitmap, we won't find any
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * free blocks even th=
ough group info says we
> @@ -1943,7 +1943,7 @@ void ext4_mb_scan_aligned(struct ext4_allocatio=
n_context *ac,
> =A0 =A0 =A0 =A0do_div(a, sbi->s_stripe);
> =A0 =A0 =A0 =A0i =3D (a * sbi->s_stripe) - first_group_block;
>
> - =A0 =A0 =A0 while (i < EXT4_BLOCKS_PER_GROUP(sb)) {
> + =A0 =A0 =A0 while (i < EXT4_CLUSTERS_PER_GROUP(sb)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!mb_test_bit(i, bitmap)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0max =3D mb_find_extent=
(e4b, 0, i, sbi->s_stripe, &ex);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (max >=3D sbi->s_st=
ripe) {
> @@ -3071,7 +3071,7 @@ ext4_mb_normalize_request(struct ext4_allocatio=
n_context *ac,
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0BUG_ON(start + size <=3D ac->ac_o_ex.fe_logical &&
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0start > ac->ac_o_ex.fe=
_logical);
> - =A0 =A0 =A0 BUG_ON(size <=3D 0 || size > EXT4_BLOCKS_PER_GROUP(ac->=
ac_sb));
> + =A0 =A0 =A0 BUG_ON(size <=3D 0 || size > EXT4_CLUSTERS_PER_GROUP(ac=
->ac_sb));
>
> =A0 =A0 =A0 =A0/* now prepare goal request */
>
> @@ -3724,7 +3724,7 @@ ext4_mb_discard_group_preallocations(struct sup=
er_block *sb,
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0if (needed =3D=3D 0)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 needed =3D EXT4_BLOCKS_PER_GROUP(sb) + =
1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 needed =3D EXT4_CLUSTERS_PER_GROUP(sb) =
+ 1;
>
> =A0 =A0 =A0 =A0INIT_LIST_HEAD(&list);
> =A0repeat:
> @@ -4039,8 +4039,8 @@ ext4_mb_initialize_context(struct ext4_allocati=
on_context *ac,
> =A0 =A0 =A0 =A0len =3D ar->len;
>
> =A0 =A0 =A0 =A0/* just a dirty hack to filter too big requests =A0*/
> - =A0 =A0 =A0 if (len >=3D EXT4_BLOCKS_PER_GROUP(sb) - 10)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D EXT4_BLOCKS_PER_GROUP(sb) - 10;
> + =A0 =A0 =A0 if (len >=3D EXT4_CLUSTERS_PER_GROUP(sb) - 10)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D EXT4_CLUSTERS_PER_GROUP(sb) - 1=
0;
>
> =A0 =A0 =A0 =A0/* start searching from the goal */
> =A0 =A0 =A0 =A0goal =3D ar->goal;
> @@ -4579,8 +4579,8 @@ do_more:
> =A0 =A0 =A0 =A0 * Check to see if we are freeing blocks across a grou=
p
> =A0 =A0 =A0 =A0 * boundary.
> =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 if (bit + count > EXT4_BLOCKS_PER_GROUP(sb)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 overflow =3D bit + count - EXT4_BLOCKS_=
PER_GROUP(sb);
> + =A0 =A0 =A0 if (bit + count > EXT4_CLUSTERS_PER_GROUP(sb)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 overflow =3D bit + count - EXT4_CLUSTER=
S_PER_GROUP(sb);

If I am not mistaken, while 'bit' was already converted to cluster unit=
s,
'count' is still in block units.

I think ext4_free_blocks() need to do 2 things:
1. convert 'count' to clusters (after issuing journal_forget())
2. round 'bit' up (and round 'count' down) if start block is not
on cluster boundary, so truncate/punch hole, will not free a
cluster when it's 'base' block is still allocated.


> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0count -=3D overflow;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0bitmap_bh =3D ext4_read_block_bitmap(sb, block_group);
> @@ -4844,7 +4844,7 @@ int ext4_trim_fs(struct super_block *sb, struct=
 fstrim_range *range)
> =A0 =A0 =A0 =A0minlen =3D range->minlen >> sb->s_blocksize_bits;
> =A0 =A0 =A0 =A0trimmed =3D 0;
>
> - =A0 =A0 =A0 if (unlikely(minlen > EXT4_BLOCKS_PER_GROUP(sb)))
> + =A0 =A0 =A0 if (unlikely(minlen > EXT4_CLUSTERS_PER_GROUP(sb)))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EINVAL;
> =A0 =A0 =A0 =A0if (start < first_data_blk) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0len -=3D first_data_blk - start;
> @@ -4857,7 +4857,7 @@ int ext4_trim_fs(struct super_block *sb, struct=
 fstrim_range *range)
> =A0 =A0 =A0 =A0ext4_get_group_no_and_offset(sb, (ext4_fsblk_t) (start=
 + len),
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 &last_group, &last_block);
> =A0 =A0 =A0 =A0last_group =3D (last_group > ngroups - 1) ? ngroups - =
1 : last_group;
> - =A0 =A0 =A0 last_block =3D EXT4_BLOCKS_PER_GROUP(sb);
> + =A0 =A0 =A0 last_block =3D EXT4_CLUSTERS_PER_GROUP(sb);
>
> =A0 =A0 =A0 =A0if (first_group > last_group)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EINVAL;
> @@ -4870,8 +4870,8 @@ int ext4_trim_fs(struct super_block *sb, struct=
 fstrim_range *range)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (len >=3D EXT4_BLOCKS_PER_GROUP(sb))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 len -=3D (EXT4_BLOCKS_P=
ER_GROUP(sb) - first_block);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (len >=3D EXT4_CLUSTERS_PER_GROUP(sb=
))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 len -=3D (EXT4_CLUSTERS=
_PER_GROUP(sb) - first_block);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0last_block =3D first_b=
lock + len;
>
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
