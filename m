From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 1/2] ext4: cleanup GFP flags inside resize path V2
Date: Mon, 24 Nov 2014 15:55:13 +0300
Message-ID: <87vbm4yczy.fsf@openvz.org>
References: <1415958040-4393-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Cc: tytso@mit.edu, cmm@us.ibm.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:44634 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbaKXMzi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Nov 2014 07:55:38 -0500
Received: by mail-wi0-f171.google.com with SMTP id bs8so5513289wib.16
        for <linux-ext4@vger.kernel.org>; Mon, 24 Nov 2014 04:55:37 -0800 (PST)
In-Reply-To: <1415958040-4393-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Ping...


Dmitry Monakhov <dmonakhov@openvz.org> writes:

> We must use GFP_NOFS instead GFP_KERNEL inside ext4_mb_add_groupinfo beca=
use resize-path
> call  it inside journal transaction. Call trace:
> ioctl
>  ->ext4_group_add
>    ->journal_start
>    ->ext4_setup_new_descs
>      ->ext4_mb_add_groupinfo -> GFP_KERNEL
>    ->ext4_flex_group_add
>      ->ext4_update_super
>        ->ext4_calculate_overhead  -> GFP_KERNEL
>    ->journal_stop
>
> Changes from V1:
>  - Fix up gfp flags for ext4_calculate_overhead
>
> ext4_update_super
>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/mballoc.c |    6 +++---
>  fs/ext4/super.c   |    2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index dbfe15c..654e70d 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2385,7 +2385,7 @@ int ext4_mb_add_groupinfo(struct super_block *sb, e=
xt4_group_t group,
>  	if (group % EXT4_DESC_PER_BLOCK(sb) =3D=3D 0) {
>  		metalen =3D sizeof(*meta_group_info) <<
>  			EXT4_DESC_PER_BLOCK_BITS(sb);
> -		meta_group_info =3D kmalloc(metalen, GFP_KERNEL);
> +		meta_group_info =3D kmalloc(metalen, GFP_NOFS);
>  		if (meta_group_info =3D=3D NULL) {
>  			ext4_msg(sb, KERN_ERR, "can't allocate mem "
>  				 "for a buddy group");
> @@ -2399,7 +2399,7 @@ int ext4_mb_add_groupinfo(struct super_block *sb, e=
xt4_group_t group,
>  		sbi->s_group_info[group >> EXT4_DESC_PER_BLOCK_BITS(sb)];
>  	i =3D group & (EXT4_DESC_PER_BLOCK(sb) - 1);
>=20=20
> -	meta_group_info[i] =3D kmem_cache_zalloc(cachep, GFP_KERNEL);
> +	meta_group_info[i] =3D kmem_cache_zalloc(cachep, GFP_NOFS);
>  	if (meta_group_info[i] =3D=3D NULL) {
>  		ext4_msg(sb, KERN_ERR, "can't allocate buddy mem");
>  		goto exit_group_info;
> @@ -2428,7 +2428,7 @@ int ext4_mb_add_groupinfo(struct super_block *sb, e=
xt4_group_t group,
>  	{
>  		struct buffer_head *bh;
>  		meta_group_info[i]->bb_bitmap =3D
> -			kmalloc(sb->s_blocksize, GFP_KERNEL);
> +			kmalloc(sb->s_blocksize, GFP_NOFS);
>  		BUG_ON(meta_group_info[i]->bb_bitmap =3D=3D NULL);
>  		bh =3D ext4_read_block_bitmap(sb, group);
>  		BUG_ON(bh =3D=3D NULL);
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 2c9e686..5f6cab8 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3310,7 +3310,7 @@ int ext4_calculate_overhead(struct super_block *sb)
>  	struct ext4_super_block *es =3D sbi->s_es;
>  	ext4_group_t i, ngroups =3D ext4_get_groups_count(sb);
>  	ext4_fsblk_t overhead =3D 0;
> -	char *buf =3D (char *) get_zeroed_page(GFP_KERNEL);
> +	char *buf =3D (char *) get_zeroed_page(GFP_NOFS);
>=20=20
>  	if (!buf)
>  		return -ENOMEM;
> --=20
> 1.7.1

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJUcyqxAAoJELhyPTmIL6kB2/8H/35OlySRvXGDC78ePXqUMRiL
wkFDpiiqNS+mFzDmrZBCaRI+VE1kjourxjblb6+JtYc+enUIF3W7LvsK6TMA9V41
USVicDpvsP3GPnuYOm3n6cBNJKxHrL4A5gUpecOI98NWV4Drb64UiUlbmcXF1Acc
RkFpADF7tyrXoluiZjHNoJH9dNntHw/m4dfIPemJvseaWsRF1X/Ux102ZCevdTUB
4eOKVbqOdoq5yOcIh64KyXkqvfI8s2IbKGAajQZhuo1rbJMo/9xv6XbSmUW9gIur
ulX7o6QGNuLzkW2HAL4IIu8EO/NpZZmjBuSYwsNUg8xnks1Yb5hbC4iUdIuAhF4=
=S7bx
-----END PGP SIGNATURE-----
--=-=-=--
