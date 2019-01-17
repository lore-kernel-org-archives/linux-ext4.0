Return-Path: <SRS0=xLGb=PZ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43194 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728562AbfAQRjS (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Jan 2019 12:39:18 -0500
Received: by mail-pg1-f195.google.com with SMTP id v28so4734886pgk.10
        for <linux-ext4@vger.kernel.org>; Thu, 17 Jan 2019 09:39:17 -0800 (PST)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <965D4A30-6A3A-4A13-8C4C-3D75BF9B4BF1@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_E35A060D-0284-4083-ABFD-E0BA10F4B0E9";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH 1/2] ext4: annotate implicit fall throughs
Date: Thu, 17 Jan 2019 10:38:56 -0700
In-Reply-To: <20190114203945.20233-1-malat@debian.org>
Cc: Theodore Ts'o <tytso@mit.edu>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Mathieu Malaterre <malat@debian.org>
References: <20190114203945.20233-1-malat@debian.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_E35A060D-0284-4083-ABFD-E0BA10F4B0E9
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Jan 14, 2019, at 1:39 PM, Mathieu Malaterre <malat@debian.org> =
wrote:
>=20
> There is a plan to build the kernel with -Wimplicit-fallthrough and
> these places in the code produced warnings (W=3D1). Fix them up.
>=20
> This commit remove the following warnings:
>=20
>  fs/ext4/hash.c:233:15: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]
>  fs/ext4/hash.c:246:15: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]
>=20
> Signed-off-by: Mathieu Malaterre <malat@debian.org>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> fs/ext4/hash.c | 2 ++
> 1 file changed, 2 insertions(+)
>=20
> diff --git a/fs/ext4/hash.c b/fs/ext4/hash.c
> index e22dcfab308b..46b24da33a28 100644
> --- a/fs/ext4/hash.c
> +++ b/fs/ext4/hash.c
> @@ -231,6 +231,7 @@ int ext4fs_dirhash(const char *name, int len, =
struct dx_hash_info *hinfo)
> 		break;
> 	case DX_HASH_HALF_MD4_UNSIGNED:
> 		str2hashbuf =3D str2hashbuf_unsigned;
> +		/* fall through */
> 	case DX_HASH_HALF_MD4:
> 		p =3D name;
> 		while (len > 0) {
> @@ -244,6 +245,7 @@ int ext4fs_dirhash(const char *name, int len, =
struct dx_hash_info *hinfo)
> 		break;
> 	case DX_HASH_TEA_UNSIGNED:
> 		str2hashbuf =3D str2hashbuf_unsigned;
> +		/* fall through */
> 	case DX_HASH_TEA:
> 		p =3D name;
> 		while (len > 0) {
> --
> 2.19.2
>=20


Cheers, Andreas






--Apple-Mail=_E35A060D-0284-4083-ABFD-E0BA10F4B0E9
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlxAvcEACgkQcqXauRfM
H+AGhQ/+LnOrJ9kpc86G+XPgBkXotiBcyTomHDxl82+FpT5vrR9vppCcAzHzhSh6
dYBy0pr4ygNpLbZaf1bJk3CmjXC/7QeV2WuSfxDnqdOG4snPdUFsRVqe75giCAHT
4zofdwqeoZqZ7o95DJ1jqJ/CajfoCcCo86uxDmqSI1YBFKol96dD0eeB8y7p1SOG
Ya7ui+Zb/Iyep2a13je2uz/ECNeNQl9ohLZFF/JopRAYezSGkkUTAI66vh1XtLNn
EDoZEZFeSX14D2sWayPtNGZmB/cQDPg+kXruuwX6Yh4oShZI1d92/D3a8JCGQ0H5
6JgMYChoPbnd+SyUuXJZ8G/6kdZiGH11yndbLAHkqG7ynIomwkt/dtkGlBAUZqt/
EKSOmL7fkRnbpBTgU3e/UbnDRXEDWI5k3KjMkts6kRJGTNRuuMpMXyEaFob6EAaa
35zSYDAtTKGFgzxx+SiJRJxa+38cHRBMl022NXwvSojCGHZml1uCw2vLYyJiE3Lx
iF3+GB3Z+/k2naQkf8zk/nMLPey+jAYXgjB9yqZEn7WNQRv6mUgK8EzR4yWvGQsU
yxmWcFu6z2WEUCVkvCuPqWri0kpTMnkkYGzf8f3Nk8qUySNb5GM/IDGCq4EioJJW
TM18WyDOsVQbgzI3GyU2SOu6Wk2kKlgbKQGn0TuvcJojbgQPJx8=
=jAzx
-----END PGP SIGNATURE-----

--Apple-Mail=_E35A060D-0284-4083-ABFD-E0BA10F4B0E9--
