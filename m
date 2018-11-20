Return-Path: <SRS0=dvF+=N7=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39457 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730134AbeKTNWE (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Nov 2018 08:22:04 -0500
Received: by mail-pf1-f195.google.com with SMTP id c72so246117pfc.6
        for <linux-ext4@vger.kernel.org>; Mon, 19 Nov 2018 18:55:13 -0800 (PST)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <57398420-CC12-4C74-A38A-1370AE169F32@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_8E770696-ABC3-46F4-B8A6-F15A1ACA211D";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH] ext4: change variable reusable to bool type
Date: Mon, 19 Nov 2018 19:55:09 -0700
In-Reply-To: <20181115064146.21232-1-cgxu519@gmx.com>
Cc: "Theodore Y . Ts'o" <tytso@mit.edu>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Chengguang Xu <cgxu519@gmx.com>
References: <20181115064146.21232-1-cgxu519@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_8E770696-ABC3-46F4-B8A6-F15A1ACA211D
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 14, 2018, at 11:41 PM, Chengguang Xu <cgxu519@gmx.com> wrote:
>=20
> Reusable parameter of mb_cache_entry_create() is bool type,
> so change variable resuable to bool type from int.
>=20
> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
> ---
> fs/ext4/xattr.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 7643d52c776c..cda5dd16a8cb 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -2979,8 +2979,8 @@ ext4_xattr_block_cache_insert(struct mb_cache =
*ea_block_cache,
> {
> 	struct ext4_xattr_header *header =3D BHDR(bh);
> 	__u32 hash =3D le32_to_cpu(header->h_hash);
> -	int reusable =3D le32_to_cpu(header->h_refcount) <
> -		       EXT4_XATTR_REFCOUNT_MAX;
> +	bool reusable =3D (le32_to_cpu(header->h_refcount) <
> +		       EXT4_XATTR_REFCOUNT_MAX) ? true : false;

You don't need to add the "? true : false" at the end here.  The
statement "le32_to_cpu(header->h_refcount) < EXT4_XATTR_REFCOUNT_MAX"
is itself already a boolean value.

Cheers, Andreas






--Apple-Mail=_8E770696-ABC3-46F4-B8A6-F15A1ACA211D
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlvzd40ACgkQcqXauRfM
H+CJgQ//bXZOEquftIaPcuyMlOtxQxRzXfvG7G7q25FXRxMr8FUmo4XiruL3oDRG
2DqmmzEAOG2wvpflV2S/y3M0Y8qF30R66LZzdZJq69aGDyIW2NmkIzzqjF1dq7/Q
AOmkf7OBSBZ7l1rKoEH/KCLyQiyNF/WJSQpsjAvkwfxODjwUbN4Jvae5O2aXuB7b
oYy17sb3QRmR5bk+DnKEyxfGrw82yN4szdt9UVNObBwQ0gKkv+6K92kaLYTq71j/
YUgEzutrn+XOIfdOeut6QzK5aGR0mC1LyJDiUyCwpGYFvps9gJA92kdZkFsTdiHR
uqEZ3NEDUj/Qcv1e8Z9NcEgbN846TDjyZxV76cEclQupn008Qkp/7/4AET/0/DQ0
6BlqmWSjo1N/Hy8d7d+S/Nf6n1LXRr7OYSXl9+lSh3o1pccj7KdGPcMyfKytFewB
uZhBc3ZmEquy4zRzMX0n52poAyEog1AThQqdWt1Q/5LL4tw6B+KQ5asMxgg6tb+G
PK6rdZR9EEcQFxI/BhMXhRFQ4r6ljlJElZsUdOe/Hp1mpJxq6YP1x8E88XZTn3y4
dfbgSTIP01CDc9Ca9Bk1RVGLPmwy7Qrin+M3GVXbI6B/dEq2+tgbOXkBXLTg6Grg
T93BwbTIzKd7A7QfKyKiYCfQh6C7DY7U18K6Q3xhMQ+dePtH6hg=
=icMe
-----END PGP SIGNATURE-----

--Apple-Mail=_8E770696-ABC3-46F4-B8A6-F15A1ACA211D--
