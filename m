From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: mballoc.c: fix ac_g_ex and ac_f_ex misuse bug in EXT4_MB_HINT_TRY_GOAL path
Date: Tue, 7 Jun 2016 15:01:46 -0600
Message-ID: <D4F0CA1E-2075-4EBE-A945-A56F6B7D6808@dilger.ca>
References: <1464868898-31336-1-git-send-email-linf@chinanetcenter.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_849E16F1-5A5B-4191-A515-D6BAD97160D2"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Theodore Ts'o <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Lin Feng <linf@chinanetcenter.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:33714 "EHLO
	mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932843AbcFGVBz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2016 17:01:55 -0400
Received: by mail-it0-f67.google.com with SMTP id u203so15190564itc.0
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jun 2016 14:01:54 -0700 (PDT)
In-Reply-To: <1464868898-31336-1-git-send-email-linf@chinanetcenter.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_849E16F1-5A5B-4191-A515-D6BAD97160D2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jun 2, 2016, at 6:01 AM, Lin Feng <linf@chinanetcenter.com> wrote:
>=20
> Descriptions:
> ext4 block allocation core stack:
> ext4_mb_new_blocks
>  ext4_mb_normalize_request
>  ext4_mb_regular_allocator
>    ext4_mb_find_by_goal
>      mb_find_extent(e4b, ac->ac_g_ex.fe_start, ac->ac_g_ex.fe_len, =
&ex);
>=20
> The start block searching hint for merging(use EXT4_MB_HINT_TRY_GOAL =
flag)
> set in ext4_mb_normalize_request is stored in ac_f_ex, while in
> EXT4_MB_HINT_TRY_GOAL path which falls in ext4_mb_find_by_goal always =
use
> ac_g_ex as a hint and the hint set in ext4_mb_normalize_request is =
never
> use.
>=20
> We could hit this bug by writing a sparse file from backward mode and =
the
> file may get fragments even if the physical blocks in the hole is =
free,
> which is expected to be merged into a single extent.

This looks reasonable.  Do you have any kind of test case that shows the
effect of the change (e.g. fragmentation counts per file before/after)?

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> Signed-off-by: Lin Feng <linf@chinanetcenter.com>
> ---
> fs/ext4/mballoc.c | 8 ++++----
> 1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index c1ab3ec..e31fc63 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -3198,15 +3198,15 @@ ext4_mb_normalize_request(struct =
ext4_allocation_context *ac,
> 	if (ar->pright && (ar->lright =3D=3D (start + size))) {
> 		/* merge to the right */
> 		ext4_get_group_no_and_offset(ac->ac_sb, ar->pright - =
size,
> -						&ac->ac_f_ex.fe_group,
> -						&ac->ac_f_ex.fe_start);
> +						&ac->ac_g_ex.fe_group,
> +						&ac->ac_g_ex.fe_start);
> 		ac->ac_flags |=3D EXT4_MB_HINT_TRY_GOAL;
> 	}
> 	if (ar->pleft && (ar->lleft + 1 =3D=3D start)) {
> 		/* merge to the left */
> 		ext4_get_group_no_and_offset(ac->ac_sb, ar->pleft + 1,
> -						&ac->ac_f_ex.fe_group,
> -						&ac->ac_f_ex.fe_start);
> +						&ac->ac_g_ex.fe_group,
> +						&ac->ac_g_ex.fe_start);
> 		ac->ac_flags |=3D EXT4_MB_HINT_TRY_GOAL;
> 	}
>=20
> --
> 1.9.3
>=20
>=20


Cheers, Andreas






--Apple-Mail=_849E16F1-5A5B-4191-A515-D6BAD97160D2
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBV1c2PHKl2rkXzB/gAQjdNRAAjSOvwDKENQgbftJuo9Stxu7L1yyt24AF
TmXUbpXwX+gjfgcpxaVLapykEJHUW7JSpBfDDdnwPwgBCRdyfzq7xpEQXqv5gxJn
AyRB9/GNNe9hnPa5mwWh4i868Ya4T/0NJFMbtwKH3RQD9qwvwzEBdqc6sEe+ITYw
bgfOwQXZKZWwKaRq2PS4W6YkE6UEuVliQpakpzTvlCoEOUQBB0aE3TxbnHpF6hU/
W0ZKRFm7vLdDtLc1fcl1ySLhDta1janoEguEFAJAoUsaDshOFzPZA7vb8YfE57ha
At6pE07EwYAqEf15GthCbW8v8Bk2ryuesUsWEd+AJzylSUuEDAqQNzrAFL8SOqgS
h3QgK45znlgZBEjL0DcKUuo6NBXcppXi0ctbcDaDVOlLiY/NoXNyg59IzTUO/xu7
079lT4wfOQ0GZmTJAyIWE73Ias4BB4kW2F//0j8Lh2tRA12K3PbNJ6BClohGiRlF
tzF2fpFUE5cZdnBuk+bSQGDLGc4cO5Bsojo6CW1p93pxJSXzmzBzWlXoOKou/7Ik
1zGquYMo1evqdveJyz9dI7OJ8rm5gucOIvYQwUjgVOdxNnlGbb/HJYcRoDyK5rEF
9Z++Zdu5zjtnXlXFR+O2iQTGbDkO3tD1vjU2Q7gT3lw0MjTNVXZ3mi08ELkXuW3k
IYm+yybIEMc=
=/xj4
-----END PGP SIGNATURE-----

--Apple-Mail=_849E16F1-5A5B-4191-A515-D6BAD97160D2--
