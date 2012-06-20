From: Tony Breeds <tony@bakeyournoodle.com>
Subject: Re: Minimal configuration for e2fsprogs
Date: Wed, 20 Jun 2012 15:33:03 +1000
Message-ID: <20120620053303.GC11330@thor.bakeyournoodle.com>
References: <20120615042421.GA7021@thor.bakeyournoodle.com>
 <20120616000825.GE7363@thunk.org>
 <20120618055836.GA30557@thor.bakeyournoodle.com>
 <20120618171257.GA16017@thunk.org>
 <20120619054751.GA2660@thor.bakeyournoodle.com>
 <86585638-21F5-4FEE-9313-28AC122FCCEE@dilger.ca>
 <20120619135610.GA10637@thunk.org>
 <20120620052604.GB11330@thor.bakeyournoodle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="4ZLFUWh1odzi/v6L"
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:44553 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277Ab2FTFdH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Jun 2012 01:33:07 -0400
Content-Disposition: inline
In-Reply-To: <20120620052604.GB11330@thor.bakeyournoodle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--4ZLFUWh1odzi/v6L
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 20, 2012 at 03:26:05PM +1000, Tony Breeds wrote:

> diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
> index cf80bd0..0c27b1e 100644
> --- a/debugfs/debugfs.c
> +++ b/debugfs/debugfs.c
> @@ -2194,6 +2194,7 @@ void do_punch(int argc, char *argv[])
> =20
>  void do_dump_mmp(int argc EXT2FS_ATTR((unused)), char *argv[])
>  {
> +#if CONFIG_MMP

Eeek this should be #ifdef oops.

We could also do:
void do_dump_mmp(int argc EXT2FS_ATTR((unused)), char *argv[])
{
#ifndef CONFIG_MMP
	fprintf(.....);
	return;
#endif
	....
}

to avoid the #else and make the approach more consistent with the rest
of the patch.


Yours Tony

--4ZLFUWh1odzi/v6L
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP4WCPAAoJEEsCiJRY75GKyOsQAIgyYSIocKe+Bec0j3S+dHFs
ZNuGyaYVPw1gnMoJLgXvUyUUSY8eizo3MkuT5dfkDkPSPFBonDJU4oRnNjvGxHEG
PEog4MLGBv38JbWmsUCya5UxwzSqEzDomX0KC8FiY2elL/Zb4e/ECkTzo2U3Uwkf
xOWIg3wcF2arR03BhnyOZKnyeail0dBPDim8jIYtptrkpb2YPRKawhqNLDaRBj1B
/3xy1z2C7Kf1xyU5eqGmm2Kd8qJJXZSBZhg9vtHfG89zf5fOYWF3alrPsbyNCTm0
8cFn/idItqL+MYgObnms6MqJSZq/ckcyo0GgT+rFf0L4p05ahpOJaHx5pKZ1ox3e
AU7Z/2/+Oa+Ta5bdYQz3QgwOoAQOykS4RvXs+JLINZEJi1sdh7RZqc0Q0NrzPy7y
j5Fs6BYHg0OOs+LIHcCRQBDjxuZWEj2GLTUjDFj+KC0nOHivZ0uyYA/QN/QUccI0
1lgH+e9nEdTXzql/++HsNdcQrKBKHDisfSqtD22T7e8ut4qlQx8YEPBgHW9oIn8V
umZFgIPL30TQF6+a9RMYQ8QB4xNodn0ruH8W0AOuFgM0/sYvOM/92ldvfhlVno7e
D4S//f52zi8YpsT0oRd6o+y0DJqKk+sbUqyBC/OsjaoEXQeBJDMos/Wp4CeETBdL
+HhaImSpIQ7mKRMKMmpr
=17ew
-----END PGP SIGNATURE-----

--4ZLFUWh1odzi/v6L--
