From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v2 1/2] e2p: Fix segfault in e2p_os2string.
Date: Tue, 18 Jul 2017 16:32:24 -0600
Message-ID: <43A1A64D-C929-41A2-BB51-AA38DDC1E238@dilger.ca>
References: <20170718192919.32406-1-abuchbinder@google.com>
 <20170718214823.22649-1-abuchbinder@google.com>
 <20170718214823.22649-2-abuchbinder@google.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_A5DD0B75-9732-4C16-AA4C-8E54CF87C415";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Adam Buchbinder <abuchbinder@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:33188 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751647AbdGRWc3 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 18 Jul 2017 18:32:29 -0400
Received: by mail-io0-f195.google.com with SMTP id n64so593925ioo.0
        for <linux-ext4@vger.kernel.org>; Tue, 18 Jul 2017 15:32:29 -0700 (PDT)
In-Reply-To: <20170718214823.22649-2-abuchbinder@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_A5DD0B75-9732-4C16-AA4C-8E54CF87C415
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Jul 18, 2017, at 3:48 PM, Adam Buchbinder <abuchbinder@google.com> =
wrote:
>=20
> Passing in a negative integer would lead to a segfault, and
> a crafted filesystem image could trigger that.
>=20
> Signed-off-by: Adam Buchbinder <abuchbinder@google.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> lib/e2p/ostype.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/lib/e2p/ostype.c b/lib/e2p/ostype.c
> index 7f088446..c5fd8ab3 100644
> --- a/lib/e2p/ostype.c
> +++ b/lib/e2p/ostype.c
> @@ -30,7 +30,7 @@ char *e2p_os2string(int os_type)
>         const char	*os;
> 	char 		*ret;
>=20
> -	if (os_type <=3D EXT2_OS_LITES)
> +	if (os_type >=3D 0 && os_type <=3D EXT2_OS_LITES)
> 		os =3D os_tab[os_type];
> 	else
> 		os =3D "(unknown os)";
> --
> 2.14.0.rc0.284.gd933b75aa4-goog
>=20


Cheers, Andreas






--Apple-Mail=_A5DD0B75-9732-4C16-AA4C-8E54CF87C415
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZbox4pIg59Q01vtYRAvyFAKCD111eXFQmXUy+0y9PA2aDd1RTfACg1DGq
PdNBbrkM53MR29I0SYSdBR4=
=qbCP
-----END PGP SIGNATURE-----

--Apple-Mail=_A5DD0B75-9732-4C16-AA4C-8E54CF87C415--
