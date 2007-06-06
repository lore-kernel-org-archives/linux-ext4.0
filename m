From: Laurent Vivier <Laurent.Vivier@bull.net>
Subject: Re: [PATCH] Set JBD2_FEATURE_INCOMPAT_64BIT on filesystems larger
 than 32-bit blocks
Date: Wed, 06 Jun 2007 09:56:10 +0200
Message-ID: <4666689A.8070605@bull.net>
References: <20070605230912.1d6c4377@gara>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF18E9132106A44D41E5CEEE4"
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:46579 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbXFFH40 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Jun 2007 03:56:26 -0400
In-Reply-To: <20070605230912.1d6c4377@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF18E9132106A44D41E5CEEE4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Jose R. Santos wrote:
> Set the journals JBD2_FEATURE_INCOMPAT_64BIT on devices with more
> than 32bit block sizes during mount time.  This ensure proper record
> lenth when writing to the journal.
>=20
> Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
> Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
> Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> ---
>  fs/ext4/super.c |   11 +++++++++++
>  1 file changed, 11 insertions(+)
>=20
> Index: linux-2.6.22-rc3/fs/ext4/super.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.22-rc3.orig/fs/ext4/super.c	2007-06-04 11:01:20.028360650=
 -0500
> +++ linux-2.6.22-rc3/fs/ext4/super.c	2007-06-05 21:14:33.974854532 -050=
0
> @@ -1824,6 +1824,13 @@ static int ext4_fill_super (struct super
>  		goto failed_mount3;
>  	}
> =20
> +	if (ext4_blocks_count(es) > 0xffffffff &&

Perhaps you should use 0xffffffffULL ?

> +	    !jbd2_journal_set_features(EXT4_SB(sb)->s_journal, 0, 0,
> +				       JBD2_FEATURE_INCOMPAT_64BIT)) {
> +		printk(KERN_ERR "ext4: Failed to set 64-bit journal feature\n");
> +		goto failed_mount4;
> +	}
> +
>  	/* We have now updated the journal if required, so we can
>  	 * validate the data journaling mode. */
>  	switch (test_opt(sb, DATA_FLAGS)) {

Regards,
Laurent
--=20
------------- Laurent.Vivier@bull.net  --------------
       "Any sufficiently advanced technology is
  indistinguishable from magic." - Arthur C. Clarke


--------------enigF18E9132106A44D41E5CEEE4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.7 (GNU/Linux)

iD8DBQFGZmim9Kffa9pFVzwRAnhoAKCsE3io+RgOn6SbGDj8xCZiw7AN2ACgxOUb
A/6j9Sm/kC96YmsPv/iLIk8=
=ekxX
-----END PGP SIGNATURE-----

--------------enigF18E9132106A44D41E5CEEE4--
