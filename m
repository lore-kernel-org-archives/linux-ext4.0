From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>
Subject: Re: [PATCH] ext4: remove usage of Uptodate flag to initialize
	buddy after an online resize
Date: Fri, 03 Oct 2008 14:21:55 +0200
Message-ID: <1223036515.4075.11.camel@frecb007923.frec.bull.fr>
References: <1222872243.11560.19.camel@frecb007923.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:45338 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbYJCMUd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Oct 2008 08:20:33 -0400
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 70E9A1A18DE
	for <linux-ext4@vger.kernel.org>; Fri,  3 Oct 2008 14:20:26 +0200 (CEST)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 02812-04 for <linux-ext4@vger.kernel.org>;
 Fri,  3 Oct 2008 14:20:22 +0200 (CEST)
Received: from cyclope.frec.bull.fr (cyclope.frec.bull.fr [129.183.4.9])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id B7EDA1A196F
	for <linux-ext4@vger.kernel.org>; Fri,  3 Oct 2008 14:20:18 +0200 (CEST)
Received: from [129.183.101.223] (dhcp129183101223.frec.bull.fr [129.183.101.223])
	by cyclope.frec.bull.fr (Postfix) with ESMTP id D5F4D2728D
	for <linux-ext4@vger.kernel.org>; Fri,  3 Oct 2008 14:20:15 +0200 (CEST)
In-Reply-To: <1222872243.11560.19.camel@frecb007923.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Please hold on with this patch. There is a race condition somewhere. I
will investigated more and send a new patch later.

Le mercredi 01 octobre 2008 =C3=A0 16:44 +0200, Fr=C3=A9d=C3=A9ric Boh=C3=
=A9 a =C3=A9crit :
> From: Frederic Bohe <frederic.bohe@bull.net>
>=20
> Replace Page cache's uptodate flag by ext4_group_info's
> EXT4_GROUP_INFO_NEED_INIT_BIT flags to allow extended group's buddy a=
nd
> added groups' buddy to be initialized or re-initialized after an onli=
ne
> resize.
>=20
> Signed-off-by: Frederic Bohe <frederic.bohe@bull.net>
> ---
>  ext4.h    |    3 +-
>  mballoc.c |   67 ++++++++++++---------------------------------------=
-----------
>  resize.c  |   49 +++++----------------------------------------
>  3 files changed, 21 insertions(+), 98 deletions(-)
>=20
> Index: linux/fs/ext4/ext4.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/fs/ext4/ext4.h	2008-10-01 14:14:01.000000000 +0200
> +++ linux/fs/ext4/ext4.h	2008-10-01 14:14:51.000000000 +0200
> @@ -1070,7 +1070,8 @@ extern int __init init_ext4_mballoc(void
>  extern void exit_ext4_mballoc(void);
>  extern void ext4_mb_free_blocks(handle_t *, struct inode *,
>  		unsigned long, unsigned long, int, unsigned long *);
> -extern int ext4_mb_add_more_groupinfo(struct super_block *sb,
> +extern void ext4_mb_set_need_init_bit(struct ext4_group_info *);
> +extern int ext4_mb_add_groupinfo(struct super_block *sb,
>  		ext4_group_t i, struct ext4_group_desc *desc);
>  extern void ext4_mb_update_group_info(struct ext4_group_info *grp,
>  		ext4_grpblk_t add);
> Index: linux/fs/ext4/mballoc.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/fs/ext4/mballoc.c	2008-10-01 14:15:02.000000000 +0200
> +++ linux/fs/ext4/mballoc.c	2008-10-01 15:49:32.000000000 +0200
> @@ -918,13 +918,15 @@ ext4_mb_load_buddy(struct super_block *s
>  	/* we could use find_or_create_page(), but it locks page
>  	 * what we'd like to avoid in fast path ... */
>  	page =3D find_get_page(inode->i_mapping, pnum);
> -	if (page =3D=3D NULL || !PageUptodate(page)) {
> +	if (page =3D=3D NULL || !PageUptodate(page) ||
> +	    EXT4_MB_GRP_NEED_INIT(e4b->bd_info)) {
>  		if (page)
>  			page_cache_release(page);
>  		page =3D find_or_create_page(inode->i_mapping, pnum, GFP_NOFS);
>  		if (page) {
>  			BUG_ON(page->mapping !=3D inode->i_mapping);
> -			if (!PageUptodate(page)) {
> +			if (!PageUptodate(page) ||
> +			    EXT4_MB_GRP_NEED_INIT(e4b->bd_info)) {
>  				ret =3D ext4_mb_init_cache(page, NULL);
>  				if (ret) {
>  					unlock_page(page);
> @@ -949,13 +951,15 @@ ext4_mb_load_buddy(struct super_block *s
>  	poff =3D block % blocks_per_page;
> =20
>  	page =3D find_get_page(inode->i_mapping, pnum);
> -	if (page =3D=3D NULL || !PageUptodate(page)) {
> +	if (page =3D=3D NULL || !PageUptodate(page) ||
> +	    EXT4_MB_GRP_NEED_INIT(e4b->bd_info)) {
>  		if (page)
>  			page_cache_release(page);
>  		page =3D find_or_create_page(inode->i_mapping, pnum, GFP_NOFS);
>  		if (page) {
>  			BUG_ON(page->mapping !=3D inode->i_mapping);
> -			if (!PageUptodate(page)) {
> +			if (!PageUptodate(page) ||
> +			    EXT4_MB_GRP_NEED_INIT(e4b->bd_info)) {
>  				ret =3D ext4_mb_init_cache(page, e4b->bd_bitmap);
>  				if (ret) {
>  					unlock_page(page);
> @@ -2240,6 +2244,10 @@ ext4_mb_store_history(struct ext4_alloca
>  #define ext4_mb_history_init(sb)
>  #endif
> =20
> +void ext4_mb_set_need_init_bit(struct ext4_group_info *grp)
> +{
> +	set_bit(EXT4_GROUP_INFO_NEED_INIT_BIT, &(grp->bb_state));
> +}
> =20
>  /* Create and initialize ext4_group_info data for the given group. *=
/
>  int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group=
,
> @@ -2284,8 +2292,7 @@ int ext4_mb_add_groupinfo(struct super_b
>  		printk(KERN_ERR "EXT4-fs: can't allocate buddy mem\n");
>  		goto exit_group_info;
>  	}
> -	set_bit(EXT4_GROUP_INFO_NEED_INIT_BIT,
> -		&(meta_group_info[i]->bb_state));
> +	ext4_mb_set_need_init_bit(meta_group_info[i]);
> =20
>  	/*
>  	 * initialize bb_free to be able to skip
> @@ -2326,54 +2333,6 @@ exit_meta_group_info:
>  } /* ext4_mb_add_groupinfo */
> =20
>  /*
> - * Add a group to the existing groups.
> - * This function is used for online resize
> - */
> -int ext4_mb_add_more_groupinfo(struct super_block *sb, ext4_group_t =
group,
> -			       struct ext4_group_desc *desc)
> -{
> -	struct ext4_sb_info *sbi =3D EXT4_SB(sb);
> -	struct inode *inode =3D sbi->s_buddy_cache;
> -	int blocks_per_page;
> -	int block;
> -	int pnum;
> -	struct page *page;
> -	int err;
> -
> -	/* Add group based on group descriptor*/
> -	err =3D ext4_mb_add_groupinfo(sb, group, desc);
> -	if (err)
> -		return err;
> -
> -	/*
> -	 * Cache pages containing dynamic mb_alloc datas (buddy and bitmap
> -	 * datas) are set not up to date so that they will be re-initilaize=
d
> -	 * during the next call to ext4_mb_load_buddy
> -	 */
> -
> -	/* Set buddy page as not up to date */
> -	blocks_per_page =3D PAGE_CACHE_SIZE / sb->s_blocksize;
> -	block =3D group * 2;
> -	pnum =3D block / blocks_per_page;
> -	page =3D find_get_page(inode->i_mapping, pnum);
> -	if (page !=3D NULL) {
> -		ClearPageUptodate(page);
> -		page_cache_release(page);
> -	}
> -
> -	/* Set bitmap page as not up to date */
> -	block++;
> -	pnum =3D block / blocks_per_page;
> -	page =3D find_get_page(inode->i_mapping, pnum);
> -	if (page !=3D NULL) {
> -		ClearPageUptodate(page);
> -		page_cache_release(page);
> -	}
> -
> -	return 0;
> -}
> -
> -/*
>   * Update an existing group.
>   * This function is used for online resize
>   */
> Index: linux/fs/ext4/resize.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/fs/ext4/resize.c	2008-10-01 14:17:56.000000000 +0200
> +++ linux/fs/ext4/resize.c	2008-10-01 14:23:42.000000000 +0200
> @@ -870,7 +870,7 @@ int ext4_group_add(struct super_block *s
>  	 * We can allocate memory for mb_alloc based on the new group
>  	 * descriptor
>  	 */
> -	err =3D ext4_mb_add_more_groupinfo(sb, input->group, gdp);
> +	err =3D ext4_mb_add_groupinfo(sb, input->group, gdp);
>  	if (err)
>  		goto exit_journal;
> =20
> @@ -1082,50 +1082,13 @@ int ext4_group_extend(struct super_block
>  	if ((err =3D ext4_journal_stop(handle)))
>  		goto exit_put;
> =20
> -	/*
> -	 * Mark mballoc pages as not up to date so that they will be update=
d
> -	 * next time they are loaded by ext4_mb_load_buddy.
> -	 *
> -	 * XXX Bad, Bad, BAD!!!  We should not be overloading the
> -	 * Uptodate flag, particularly on thte bitmap bh, as way of
> -	 * hinting to ext4_mb_load_buddy() that it needs to be
> -	 * overloaded.  A user could take a LVM snapshot, then do an
> -	 * on-line fsck, and clear the uptodate flag, and this would
> -	 * not be a bug in userspace, but a bug in the kernel.  FIXME!!!
> -	 */
> -	{
> -		struct ext4_sb_info *sbi =3D EXT4_SB(sb);
> -		struct inode *inode =3D sbi->s_buddy_cache;
> -		int blocks_per_page;
> -		int block;
> -		int pnum;
> -		struct page *page;
> -
> -		/* Set buddy page as not up to date */
> -		blocks_per_page =3D PAGE_CACHE_SIZE / sb->s_blocksize;
> -		block =3D group * 2;
> -		pnum =3D block / blocks_per_page;
> -		page =3D find_get_page(inode->i_mapping, pnum);
> -		if (page !=3D NULL) {
> -			ClearPageUptodate(page);
> -			page_cache_release(page);
> -		}
> -
> -		/* Set bitmap page as not up to date */
> -		block++;
> -		pnum =3D block / blocks_per_page;
> -		page =3D find_get_page(inode->i_mapping, pnum);
> -		if (page !=3D NULL) {
> -			ClearPageUptodate(page);
> -			page_cache_release(page);
> -		}
> +	/* Get the info on the last group */
> +	grp =3D ext4_get_group_info(sb, group);
> =20
> -		/* Get the info on the last group */
> -		grp =3D ext4_get_group_info(sb, group);
> +	ext4_mb_set_need_init_bit(grp);
> =20
> -		/* Update free blocks in group info */
> -		ext4_mb_update_group_info(grp, add);
> -	}
> +	/* Update free blocks in group info */
> +	ext4_mb_update_group_info(grp, add);
> =20
>  	if (test_opt(sb, DEBUG))
>  		printk(KERN_DEBUG "EXT4-fs: extended group to %llu blocks\n",
> --
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
