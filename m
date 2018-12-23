Return-Path: <SRS0=TkYx=PA=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33787 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726924AbeLWISh (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 23 Dec 2018 03:18:37 -0500
Received: by mail-pg1-f196.google.com with SMTP id z11so4439054pgu.0
        for <linux-ext4@vger.kernel.org>; Sun, 23 Dec 2018 00:18:36 -0800 (PST)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <82AB8F0B-AB85-4C98-8978-B5E71B43B54C@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_42968CCF-27D5-4DED-B769-FEE6D3E6BEC8";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v2 2/2] ext4: clean up group state test macros with
 predicate functions
Date: Sun, 23 Dec 2018 01:18:30 -0700
In-Reply-To: <1545297741-49408-2-git-send-email-yi.zhang@huawei.com>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>, Wang Shilong <wshilong@ddn.com>,
        Miao Xie <miaoxie@huawei.com>
To: "zhangyi (F)" <yi.zhang@huawei.com>
References: <1545297741-49408-1-git-send-email-yi.zhang@huawei.com>
 <1545297741-49408-2-git-send-email-yi.zhang@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_42968CCF-27D5-4DED-B769-FEE6D3E6BEC8
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Dec 20, 2018, at 2:22 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>=20
> Create separate predicate functions to test/set/clear/test_and_set
> bb_state flags in ext4_group_info like features testing, and then
> replace all old macros and the places where we use
> EXT4_GROUP_INFO_XXX_BIT directly.
>=20
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>

You can add:

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> Change since v1:
> - Add static functions prototypes as Andreas suggests
>=20
> fs/ext4/balloc.c  |  6 ++---
> fs/ext4/ext4.h    | 69 =
++++++++++++++++++++++++++++++++++++++++---------------
> fs/ext4/ialloc.c  |  8 +++----
> fs/ext4/mballoc.c | 35 ++++++++++++++--------------
> fs/ext4/super.c   |  4 ++--
> 5 files changed, 76 insertions(+), 46 deletions(-)
>=20
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index e5d6ee6..082387a 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -364,7 +364,7 @@ static int ext4_validate_block_bitmap(struct =
super_block *sb,
>=20
> 	if (buffer_verified(bh))
> 		return 0;
> -	if (EXT4_MB_GRP_BBITMAP_CORRUPT(grp))
> +	if (ext4_mb_grp_bbitmap_corrupt(grp))
> 		return -EFSCORRUPTED;
>=20
> 	ext4_lock_group(sb, block_group);
> @@ -699,7 +699,7 @@ ext4_fsblk_t ext4_count_free_clusters(struct =
super_block *sb)
> 		grp =3D NULL;
> 		if (EXT4_SB(sb)->s_group_info)
> 			grp =3D ext4_get_group_info(sb, i);
> -		if (!grp || !EXT4_MB_GRP_BBITMAP_CORRUPT(grp))
> +		if (!grp || !ext4_mb_grp_bbitmap_corrupt(grp))
> 			desc_count +=3D ext4_free_group_clusters(sb, =
gdp);
> 		brelse(bitmap_bh);
> 		bitmap_bh =3D ext4_read_block_bitmap(sb, i);
> @@ -729,7 +729,7 @@ ext4_fsblk_t ext4_count_free_clusters(struct =
super_block *sb)
> 		grp =3D NULL;
> 		if (EXT4_SB(sb)->s_group_info)
> 			grp =3D ext4_get_group_info(sb, i);
> -		if (!grp || !EXT4_MB_GRP_BBITMAP_CORRUPT(grp))
> +		if (!grp || !ext4_mb_grp_bbitmap_corrupt(grp))
> 			desc_count +=3D ext4_free_group_clusters(sb, =
gdp);
> 	}
>=20
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 755ba14..a5980d2 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2882,25 +2882,56 @@ struct ext4_group_info {
> #define EXT4_GROUP_INFO_IBITMAP_CORRUPT		\
> 	(1 << EXT4_GROUP_INFO_IBITMAP_CORRUPT_BIT)
>=20
> -#define EXT4_MB_GRP_NEED_INIT(grp)	\
> -	(test_bit(EXT4_GROUP_INFO_NEED_INIT_BIT, &((grp)->bb_state)))
> -#define EXT4_MB_GRP_BBITMAP_CORRUPT(grp)	\
> -	(test_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT, =
&((grp)->bb_state)))
> -#define EXT4_MB_GRP_IBITMAP_CORRUPT(grp)	\
> -	(test_bit(EXT4_GROUP_INFO_IBITMAP_CORRUPT_BIT, =
&((grp)->bb_state)))
> -#define EXT4_MB_GRP_TEST_AND_SET_BBITMAP_CORRUPT(grp)	\
> -	(test_and_set_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT, \
> -			  &((grp)->bb_state)))
> -#define EXT4_MB_GRP_TEST_AND_SET_IBITMAP_CORRUPT(grp)	\
> -	(test_and_set_bit(EXT4_GROUP_INFO_IBITMAP_CORRUPT_BIT, \
> -			  &((grp)->bb_state)))
> -
> -#define EXT4_MB_GRP_WAS_TRIMMED(grp)	\
> -	(test_bit(EXT4_GROUP_INFO_WAS_TRIMMED_BIT, &((grp)->bb_state)))
> -#define EXT4_MB_GRP_SET_TRIMMED(grp)	\
> -	(set_bit(EXT4_GROUP_INFO_WAS_TRIMMED_BIT, &((grp)->bb_state)))
> -#define EXT4_MB_GRP_CLEAR_TRIMMED(grp)	\
> -	(clear_bit(EXT4_GROUP_INFO_WAS_TRIMMED_BIT, &((grp)->bb_state)))
> +
> +#define EXT4_MB_GROUP_STATE_FUNCS(name, statename)			=
\
> +static inline int ext4_mb_grp_##name(struct ext4_group_info *grp)	=
\
> +{									=
\
> +	return test_bit(EXT4_GROUP_INFO_##statename##_BIT,		=
\
> +			&(grp->bb_state));				=
\
> +}									=
\
> +static inline void ext4_mb_grp_set_##name(struct ext4_group_info =
*grp)	\
> +{									=
\
> +	set_bit(EXT4_GROUP_INFO_##statename##_BIT, &(grp->bb_state));	=
\
> +}									=
\
> +static inline void ext4_mb_grp_clear_##name(struct ext4_group_info =
*grp)\
> +{									=
\
> +	clear_bit(EXT4_GROUP_INFO_##statename##_BIT, &(grp->bb_state));	=
\
> +}									=
\
> +static inline int ext4_mb_grp_test_and_set_##name(struct =
ext4_group_info *grp) \
> +{									=
\
> +	return test_and_set_bit(EXT4_GROUP_INFO_##statename##_BIT,	=
\
> +				&(grp->bb_state));			=
\
> +}
> +
> +
> +/*
> + * Add these declarations here only so that these functions can be
> + * found by name.  Otherwise, they are very hard to locate.
> + */
> +static inline int ext4_mb_grp_need_init(struct ext4_group_info *grp);
> +static inline void ext4_mb_grp_set_need_init(struct ext4_group_info =
*grp);
> +static inline void ext4_mb_grp_clear_need_init(struct ext4_group_info =
*grp);
> +static inline int ext4_mb_grp_test_and_set_need_init(struct =
ext4_group_info *grp);
> +EXT4_MB_GROUP_STATE_FUNCS(need_init, NEED_INIT)
> +
> +static inline int ext4_mb_grp_trimmed(struct ext4_group_info *grp);
> +static inline void ext4_mb_grp_set_trimmed(struct ext4_group_info =
*grp);
> +static inline void ext4_mb_grp_clear_trimmed(struct ext4_group_info =
*grp);
> +static inline int ext4_mb_grp_test_and_set_trimmed(struct =
ext4_group_info *grp);
> +EXT4_MB_GROUP_STATE_FUNCS(trimmed, WAS_TRIMMED)
> +
> +static inline int ext4_mb_grp_bbitmap_corrupt(struct ext4_group_info =
*grp);
> +static inline void ext4_mb_grp_set_bbitmap_corrupt(struct =
ext4_group_info *grp);
> +static inline void ext4_mb_grp_clear_bbitmap_corrupt(struct =
ext4_group_info *grp);
> +static inline int ext4_mb_grp_test_and_set_bbitmap_corrupt(struct =
ext4_group_info *grp);
> +EXT4_MB_GROUP_STATE_FUNCS(bbitmap_corrupt, BBITMAP_CORRUPT)
> +
> +static inline int ext4_mb_grp_ibitmap_corrupt(struct ext4_group_info =
*grp);
> +static inline void ext4_mb_grp_set_ibitmap_corrupt(struct =
ext4_group_info *grp);
> +static inline void ext4_mb_grp_clear_ibitmap_corrupt(struct =
ext4_group_info *grp);
> +static inline int ext4_mb_grp_test_and_set_ibitmap_corrupt(struct =
ext4_group_info *grp);
> +EXT4_MB_GROUP_STATE_FUNCS(ibitmap_corrupt, IBITMAP_CORRUPT)
> +
>=20
> #define EXT4_MAX_CONTENTION		8
> #define EXT4_CONTENTION_THRESHOLD	2
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 014f6a6..ca86368 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -86,7 +86,7 @@ static int ext4_validate_inode_bitmap(struct =
super_block *sb,
>=20
> 	if (buffer_verified(bh))
> 		return 0;
> -	if (EXT4_MB_GRP_IBITMAP_CORRUPT(grp))
> +	if (ext4_mb_grp_ibitmap_corrupt(grp))
> 		return -EFSCORRUPTED;
>=20
> 	ext4_lock_group(sb, block_group);
> @@ -293,7 +293,7 @@ void ext4_free_inode(handle_t *handle, struct =
inode *inode)
> 		bitmap_bh =3D NULL;
> 		goto error_return;
> 	}
> -	if (unlikely(EXT4_MB_GRP_IBITMAP_CORRUPT(grp))) {
> +	if (unlikely(ext4_mb_grp_ibitmap_corrupt(grp))) {
> 		fatal =3D -EFSCORRUPTED;
> 		goto error_return;
> 	}
> @@ -898,13 +898,13 @@ struct inode *__ext4_new_inode(handle_t *handle, =
struct inode *dir,
>=20
> 		grp =3D ext4_get_group_info(sb, group);
> 		/* Skip groups with already-known suspicious inode =
tables */
> -		if (EXT4_MB_GRP_IBITMAP_CORRUPT(grp))
> +		if (ext4_mb_grp_ibitmap_corrupt(grp))
> 			goto next_group;
>=20
> 		brelse(inode_bitmap_bh);
> 		inode_bitmap_bh =3D ext4_read_inode_bitmap(sb, group);
> 		/* Skip groups with suspicious inode tables */
> -		if (EXT4_MB_GRP_IBITMAP_CORRUPT(grp) ||
> +		if (ext4_mb_grp_ibitmap_corrupt(grp) ||
> 		    IS_ERR(inode_bitmap_bh)) {
> 			inode_bitmap_bh =3D NULL;
> 			goto next_group;
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index e224808..4151c76 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -622,7 +622,7 @@ static int __mb_check_buddy(struct ext4_buddy =
*e4b, char *file,
> 			MB_CHECK_ASSERT(mb_test_bit(k, buddy2));
> 		}
> 	}
> -	MB_CHECK_ASSERT(!EXT4_MB_GRP_NEED_INIT(e4b->bd_info));
> +	MB_CHECK_ASSERT(!ext4_mb_grp_need_init(e4b->bd_info));
> 	MB_CHECK_ASSERT(e4b->bd_info->bb_fragments =3D=3D fragments);
>=20
> 	grp =3D ext4_get_group_info(sb, e4b->bd_group);
> @@ -755,7 +755,7 @@ void ext4_mb_generate_buddy(struct super_block =
*sb,
> 	}
> 	mb_set_largest_free_order(sb, grp);
>=20
> -	clear_bit(EXT4_GROUP_INFO_NEED_INIT_BIT, &(grp->bb_state));
> +	ext4_mb_grp_clear_need_init(grp);
>=20
> 	period =3D get_cycles() - period;
> 	spin_lock(&sbi->s_bal_lock);
> @@ -857,7 +857,7 @@ static int ext4_mb_init_cache(struct page *page, =
char *incore, gfp_t gfp)
> 		 * we must skip all initialized uptodate buddies on the =
page,
> 		 * which may be currently in use by an allocating task.
> 		 */
> -		if (PageUptodate(page) && =
!EXT4_MB_GRP_NEED_INIT(grinfo)) {
> +		if (PageUptodate(page) && =
!ext4_mb_grp_need_init(grinfo)) {
> 			bh[i] =3D NULL;
> 			continue;
> 		}
> @@ -1050,7 +1050,7 @@ int ext4_mb_init_group(struct super_block *sb, =
ext4_group_t group, gfp_t gfp)
> 	 * page accessed.
> 	 */
> 	ret =3D ext4_mb_get_buddy_page_lock(sb, group, &e4b, gfp);
> -	if (ret || !EXT4_MB_GRP_NEED_INIT(this_grp)) {
> +	if (ret || !ext4_mb_grp_need_init(this_grp)) {
> 		/*
> 		 * somebody initialized the group
> 		 * return without doing anything
> @@ -1122,7 +1122,7 @@ ext4_mb_load_buddy_gfp(struct super_block *sb, =
ext4_group_t group,
> 	e4b->bd_buddy_page =3D NULL;
> 	e4b->bd_bitmap_page =3D NULL;
>=20
> -	if (unlikely(EXT4_MB_GRP_NEED_INIT(grp))) {
> +	if (unlikely(ext4_mb_grp_need_init(grp))) {
> 		/*
> 		 * we need full data about the group
> 		 * to make a good selection
> @@ -1424,7 +1424,7 @@ static void mb_free_blocks(struct inode *inode, =
struct ext4_buddy *e4b,
> 	BUG_ON(last >=3D (sb->s_blocksize << 3));
> 	assert_spin_locked(ext4_group_lock_ptr(sb, e4b->bd_group));
> 	/* Don't bother if the block group is corrupt. */
> -	if (unlikely(EXT4_MB_GRP_BBITMAP_CORRUPT(e4b->bd_info)))
> +	if (unlikely(ext4_mb_grp_bbitmap_corrupt(e4b->bd_info)))
> 		return;
>=20
> 	mb_check_buddy(e4b);
> @@ -1833,7 +1833,7 @@ int ext4_mb_find_by_goal(struct =
ext4_allocation_context *ac,
> 	if (err)
> 		return err;
>=20
> -	if (unlikely(EXT4_MB_GRP_BBITMAP_CORRUPT(e4b->bd_info))) {
> +	if (unlikely(ext4_mb_grp_bbitmap_corrupt(e4b->bd_info))) {
> 		ext4_mb_unload_buddy(e4b);
> 		return 0;
> 	}
> @@ -2046,11 +2046,11 @@ static int ext4_mb_good_group(struct =
ext4_allocation_context *ac,
> 	if (cr <=3D 2 && free < ac->ac_g_ex.fe_len)
> 		return 0;
>=20
> -	if (unlikely(EXT4_MB_GRP_BBITMAP_CORRUPT(grp)))
> +	if (unlikely(ext4_mb_grp_bbitmap_corrupt(grp)))
> 		return 0;
>=20
> 	/* We only do this if the grp has never been initialized */
> -	if (unlikely(EXT4_MB_GRP_NEED_INIT(grp))) {
> +	if (unlikely(ext4_mb_grp_need_init(grp))) {
> 		int ret =3D ext4_mb_init_group(ac->ac_sb, group, =
GFP_NOFS);
> 		if (ret)
> 			return ret;
> @@ -2304,7 +2304,7 @@ static int ext4_mb_seq_groups_show(struct =
seq_file *seq, void *v)
>=20
> 	grinfo =3D ext4_get_group_info(sb, group);
> 	/* Load the group info in memory only if not already loaded. */
> -	if (unlikely(EXT4_MB_GRP_NEED_INIT(grinfo))) {
> +	if (unlikely(ext4_mb_grp_need_init(grinfo))) {
> 		err =3D ext4_mb_load_buddy(sb, group, &e4b);
> 		if (err) {
> 			seq_printf(seq, "#%-5u: I/O error\n", group);
> @@ -2418,8 +2418,7 @@ int ext4_mb_add_groupinfo(struct super_block =
*sb, ext4_group_t group,
> 		ext4_msg(sb, KERN_ERR, "can't allocate buddy mem");
> 		goto exit_group_info;
> 	}
> -	set_bit(EXT4_GROUP_INFO_NEED_INIT_BIT,
> -		&(meta_group_info[i]->bb_state));
> +	ext4_mb_grp_set_need_init(meta_group_info[i]);
>=20
> 	/*
> 	 * initialize bb_free to be able to skip
> @@ -2807,7 +2806,7 @@ static void ext4_free_data_in_buddy(struct =
super_block *sb,
> 	 * is supported and the free blocks will be trimmed online.
> 	 */
> 	if (!test_opt(sb, DISCARD))
> -		EXT4_MB_GRP_CLEAR_TRIMMED(db);
> +		ext4_mb_grp_clear_trimmed(db);
>=20
> 	if (!db->bb_free_root.rb_node) {
> 		/* No more items in the per group rb tree
> @@ -4790,7 +4789,7 @@ void ext4_free_blocks(handle_t *handle, struct =
inode *inode,
> 	overflow =3D 0;
> 	ext4_get_group_no_and_offset(sb, block, &block_group, &bit);
>=20
> -	if (unlikely(EXT4_MB_GRP_BBITMAP_CORRUPT(
> +	if (unlikely(ext4_mb_grp_bbitmap_corrupt(
> 			ext4_get_group_info(sb, block_group))))
> 		return;
>=20
> @@ -4896,7 +4895,7 @@ void ext4_free_blocks(handle_t *handle, struct =
inode *inode,
> 					 " with %d", block_group, bit, =
count,
> 					 err);
> 		} else
> -			EXT4_MB_GRP_CLEAR_TRIMMED(e4b.bd_info);
> +			ext4_mb_grp_clear_trimmed(e4b.bd_info);
>=20
> 		ext4_lock_group(sb, block_group);
> 		mb_clear_bits(bitmap_bh->b_data, bit, count_clusters);
> @@ -5169,7 +5168,7 @@ ext4_trim_all_free(struct super_block *sb, =
ext4_group_t group,
> 	bitmap =3D e4b.bd_bitmap;
>=20
> 	ext4_lock_group(sb, group);
> -	if (EXT4_MB_GRP_WAS_TRIMMED(e4b.bd_info) &&
> +	if (ext4_mb_grp_trimmed(e4b.bd_info) &&
> 	    minblocks >=3D =
atomic_read(&EXT4_SB(sb)->s_last_trim_minblks))
> 		goto out;
>=20
> @@ -5210,7 +5209,7 @@ ext4_trim_all_free(struct super_block *sb, =
ext4_group_t group,
>=20
> 	if (!ret) {
> 		ret =3D count;
> -		EXT4_MB_GRP_SET_TRIMMED(e4b.bd_info);
> +		ext4_mb_grp_set_trimmed(e4b.bd_info);
> 	}
> out:
> 	ext4_unlock_group(sb, group);
> @@ -5273,7 +5272,7 @@ int ext4_trim_fs(struct super_block *sb, struct =
fstrim_range *range)
> 	for (group =3D first_group; group <=3D last_group; group++) {
> 		grp =3D ext4_get_group_info(sb, group);
> 		/* We only do this if the grp has never been initialized =
*/
> -		if (unlikely(EXT4_MB_GRP_NEED_INIT(grp))) {
> +		if (unlikely(ext4_mb_grp_need_init(grp))) {
> 			ret =3D ext4_mb_init_group(sb, group, GFP_NOFS);
> 			if (ret)
> 				break;
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 5b83765..d08bcd7 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -798,14 +798,14 @@ void ext4_mark_group_bitmap_corrupted(struct =
super_block *sb,
> 	int ret;
>=20
> 	if (flags & EXT4_GROUP_INFO_BBITMAP_CORRUPT) {
> -		ret =3D EXT4_MB_GRP_TEST_AND_SET_BBITMAP_CORRUPT(grp);
> +		ret =3D ext4_mb_grp_test_and_set_bbitmap_corrupt(grp);
> 		if (!ret)
> 			percpu_counter_sub(&sbi->s_freeclusters_counter,
> 					   grp->bb_free);
> 	}
>=20
> 	if (flags & EXT4_GROUP_INFO_IBITMAP_CORRUPT) {
> -		ret =3D EXT4_MB_GRP_TEST_AND_SET_IBITMAP_CORRUPT(grp);
> +		ret =3D ext4_mb_grp_test_and_set_ibitmap_corrupt(grp);
> 		if (!ret && gdp) {
> 			int count;
>=20
> --
> 2.7.4
>=20


Cheers, Andreas






--Apple-Mail=_42968CCF-27D5-4DED-B769-FEE6D3E6BEC8
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlwfRNcACgkQcqXauRfM
H+DLAQ//dRGQC+LvsP+Rf5lGqwSrovqr+V5GHfewbwYHju1GhcopHVPYL9lIApwJ
eNpGNH7J+7AhKNdweplLtfVWfWxwFCFhdDOG7rxjxd47TJkOu9khKjQ7bAzx9MzF
+ANLsJOVPJUkXlbboQRwhXznibwsRxPaiAZ8sPvDqDPPLWRgCQvHRNpvOhFn1fUm
xzX9o+brmS5atq8+UcKTKMpVYlZlhmu77yW/26kalOlGuesRfeMRBi5josszOCcP
1YGIQ4onryCCIcZnt8DPBpBcum145FFKHdSNDhkOq8tfqAYb9cX4YNjQ6cnj/dG/
Qi4qXxdYez/LLQ09NAqs5y/5CDY+pDJt+nIlepBw4HKuK3v8sUmmfHHvnnSm4rl7
AYbl9++lR7ZMA6Jvk44HzdRMikjUSpamOyziMHaeoRsZH+eddCZHJgu0lepKr1b6
fX2uOCTxnOEC2D3+8TZG/QBlU4s+qQ5GGZGTrO9qVW8sc5btgT6mjtF0fiHBKiUb
Xn9xvhkbP866X4uwrVevs0CIIFIvUfCid4XkpBDmz5f1c+wxgnGjK3rVQgi2TlZb
uxzZXWOzN0q/siNROWJY7VJyaKpmlq41ikrSuzfUs2cbBIg8chTzACYZUpEAintV
GKtgTaHe/XkMolMaFfZYZFLSNG/4boBgGFqoDAq0Fhu0HrTranM=
=aik+
-----END PGP SIGNATURE-----

--Apple-Mail=_42968CCF-27D5-4DED-B769-FEE6D3E6BEC8--
