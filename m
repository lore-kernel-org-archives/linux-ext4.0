From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH V2] filefrag: fix issues with 29758d2
Date: Fri, 30 May 2014 00:45:41 -0600
Message-ID: <B05C2B5E-199C-4177-993C-9C4F095F7C1B@dilger.ca>
References: <53876D7D.8050108@redhat.com> <5387712B.1060009@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: multipart/signed; boundary="Apple-Mail=_20A38679-E781-4060-91B6-D5B2FDAEF573"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45913 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbaE3Gpf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 May 2014 02:45:35 -0400
Received: by mail-pb0-f46.google.com with SMTP id rq2so1389995pbb.19
        for <linux-ext4@vger.kernel.org>; Thu, 29 May 2014 23:45:34 -0700 (PDT)
In-Reply-To: <5387712B.1060009@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_20A38679-E781-4060-91B6-D5B2FDAEF573
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=iso-8859-1

On May 29, 2014, at 11:40 AM, Eric Sandeen <sandeen@redhat.com> wrote:
> 29758d2 filefrag: exit with error code if an error is hit
>=20
> introduced a couple errors; in one case it missed returning
> a value, and in the other used a test where it needed an
> assignment.
>=20
> Also fix a precedence problem with:
>=20
> 	if (fe_flags & mask =3D=3D 0)
>=20
> which is equivalent to:
>=20
> 	if (fe_flags & (mask =3D=3D 0))
>=20
> but we need:
>=20
> 	if ((fe_flags & mask) =3D=3D 0)

Strange.  I'm pretty sure I fixed this, because it was causing every
flag to be printed, but I guess I sent the wrong version or something.
Thanks for fixing this.

> diff --git a/misc/filefrag.c b/misc/filefrag.c
> index 37c4416..1d05f47 100644
> --- a/misc/filefrag.c
> +++ b/misc/filefrag.c
> @@ -175,7 +175,7 @@ static void print_extent_info(struct fiemap_extent =
*fm_extent, int cur_ex,
> 	for (mask =3D 1; fe_flags !=3D 0 && mask !=3D 0; mask <<=3D 1) {
> 		char hex[6];
>=20
> -		if (fe_flags & mask =3D=3D 0)
> +		if ((fe_flags & mask) =3D=3D 0)
> 			continue;
> 		sprintf(hex, "%#04x,", mask);
> 		print_flag(&fe_flags, mask, flags, hex);
> @@ -387,8 +387,9 @@ static int frag_report(const char *filename)
> 	if (last_device !=3D st.st_dev) {
> 		if (fstatfs(fd, &fsinfo) < 0) {
> 			close(fd);
> +			rc =3D -errno;

Would be better to move this above close(), instead of introducing
another case of the potential error you mentioned.

Cheers, Andreas

> 			perror("fstatfs");
> -			return;
> +			return rc;
> 		}
> 		if (verbose)
> 			printf("Filesystem type is: %lx\n",
> @@ -556,7 +557,7 @@ int main(int argc, char**argv)
> 		int rc2 =3D frag_report(*cpp);
>=20
> 		if (rc2 < 0 && rc =3D=3D 0)
> -			rc =3D=3D rc2;
> +			rc =3D rc2;
> 	}
>=20
> 	return rc;
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_20A38679-E781-4060-91B6-D5B2FDAEF573
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBU4gpFXKl2rkXzB/gAQLR/hAAmKE6oSbzI6yljuG0VtQiayPPsM1F0jtt
pCbAaZY+q3eEIG0PTzLvQnlDDY206Jk1Kz8tiWgqGaz948xtWJk6QkXBWYTfcdzN
6bD09a/PAnqAwrSX7FYJEevltPvpvDPfidxxZ6QajqdUQuj5fxwgMciSXGd7QT9J
nv1sVcMp7+x1I/oxHR+3yCkkPtAJDh2dLCW7YfwGW7XgJutJWxbq2vDZRXFO2t+s
7LYQU24utGsgZKKCUtkDi63L4M/2mPLs39s0iELdovceOCBtk4IiV6CYdLKukwfI
N4QNafTEbJbr+YaRo6Xda85/mL8iZm7wnVWRTeRp7kZErqwZmoVL1HUczYtpWQcF
b+NQBgLeQx3+p66XXA4C2CXyF4oEhHFYhRIZMKMs9+UUKE+RRZK5P6e2e1y3n4MI
MqTOBvGNZZ56rNSQRl347/vOdc+SmNR5ON3z60Acvtp3qWFryIJ17ys8nk80cQak
CctCi4GV4yV+WdNKHTgy2SIim0hCHBIabBFcwZsXKSWuFCAxWmTeyngL2lsbOf89
aZHpOL+jnKCXlgKTVHvgDWk5APFucjhkx+bZM1y751JnJYpPtK1I4vTN+NWaDNPQ
W0U8uBa9wHVlk41StX5dG2KTDjeaWFO5EuNox8jAIhQ+G8TP8+7OaHOIXYY/CWUQ
8XNyV32hcyw=
=bCaL
-----END PGP SIGNATURE-----

--Apple-Mail=_20A38679-E781-4060-91B6-D5B2FDAEF573--
