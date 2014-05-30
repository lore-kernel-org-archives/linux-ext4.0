From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH V3] filefrag: filefrag: fix issues with 29758d2
Date: Fri, 30 May 2014 15:03:51 -0600
Message-ID: <7862495B-2A0E-400B-9AEF-CF4B2C603B91@dilger.ca>
References: <53876D7D.8050108@redhat.com> <5388C989.8050100@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: multipart/signed; boundary="Apple-Mail=_AD4C073D-40F0-4610-8DB9-2960F779A41F"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:47774 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955AbaE3VDw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 May 2014 17:03:52 -0400
Received: by mail-pa0-f50.google.com with SMTP id fb1so2121094pad.9
        for <linux-ext4@vger.kernel.org>; Fri, 30 May 2014 14:03:51 -0700 (PDT)
In-Reply-To: <5388C989.8050100@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_AD4C073D-40F0-4610-8DB9-2960F779A41F
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=iso-8859-1


On May 30, 2014, at 12:10 PM, Eric Sandeen <sandeen@redhat.com> wrote:

> 29758d2 filefrag: exit with error code if an error is hit
>=20
> introduced a couple errors; in one case it missed returning
> a value, and possibly picked up errno from (unchecked) close(),
> and in the other used a test where it needed an
> assignment.  So capture the error, move perror() directly
> after the failed call in both cases, and fix the assignment.
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
>=20
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good:

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
>=20
> diff --git a/misc/filefrag.c b/misc/filefrag.c
> index 37c4416..820821b 100644
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
> @@ -378,17 +378,18 @@ static int frag_report(const char *filename)
> #else
> 	if (fstat(fd, &st) < 0) {
> #endif
> -		close(fd);
> 		rc =3D -errno;
> 		perror("stat");
> +		close(fd);
> 		return rc;
> 	}
>=20
> 	if (last_device !=3D st.st_dev) {
> 		if (fstatfs(fd, &fsinfo) < 0) {
> -			close(fd);
> +			rc =3D -errno;
> 			perror("fstatfs");
> -			return;
> +			close(fd);
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


Cheers, Andreas






--Apple-Mail=_AD4C073D-40F0-4610-8DB9-2960F779A41F
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBU4jyN3Kl2rkXzB/gAQJMFBAAulmiKqavcUhxTMd+mBSEevR0cdzAXKWE
3u7GtielohAauw5PCPDU46o7AbdrRFoAiOjyZKNOLBLP/xGk30CEUE8XTRmpMb4N
DhsgND1wcYgwIgiknC8hhDZQI+lnlIy/+kYKoMmrfZgRg3nDZSPANsCJvN3iUq7k
Jh5jjT6kZ49Y3KBx6MR21vALZTibUYoTjmW+pqJH6yKwid/hxaS9Ne8X1Sqp3BJr
MjwBCcgpHj6Jy4LLcaLwG9w12Y8hIVkTchAjU01hnGIBK7rtd3J91XhcvsahAhJS
Kh/k8FnOoGRjovWBVc+zCfg5xEZcfQKmzHPFNZ0D1NARmtqaIUdkkW+AtU2FFi5o
zP2UpPoAjN3hbauIGi5P1i67MlwSVlLU2Nj6TXnDWlc4Rtp9Zia7XLZYynnbmyGb
4T718q7HKVRL+vxMZtmgVMF+NM2s/wVvYQ7xrMAuaqwehBy2DQEuEn10Y8R1T5EI
W7EqqCX49IyVGf/k5S8rqFqpIR3Hi2zD9b6d7mZiRWvHraFoAF282qhLM8LcbLcz
rNJ9X3DJNkIHJzzbWdSWkmIx0uTdsO/eZslilXW1YM3lsoIMP6/HQ6gNVL3Y2OwE
iaMjox/v3rjdvXFNPoESvefuQoIGD++SC9i7G/xlpvZDCTsdqatQexHVG9Koryi0
jwAZVzoe4ck=
=fFd/
-----END PGP SIGNATURE-----

--Apple-Mail=_AD4C073D-40F0-4610-8DB9-2960F779A41F--
